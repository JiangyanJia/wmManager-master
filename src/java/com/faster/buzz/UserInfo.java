/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.faster.buzz;

import java.io.UnsupportedEncodingException;
import java.security.AlgorithmParameters;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Security;
import java.security.spec.InvalidParameterSpecException;
import java.util.Arrays;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.http.QHttp;
import tech.qting.mcore.Conf;
import tech.qting.qson.JSONObject;
import tech.qting.util.L;
import tech.qting.util.TL;

/**
 *
 * @author cangy
 */
public class UserInfo {

    private static final QHttp QHTTP = new QHttp();

    public void user(IContext ctx) throws Exception {
        String appid = Conf.getConstStr("APPID");
        String app_key = Conf.getConstStr("APPKEY");
        String url = Conf.getConstStr("LOGIN_URL");
        String code = ctx.para("code");
        String encryptedData = ctx.para("encryptedData");
        String iv = ctx.para("iv");
        int mid = 0;
        if (TL.isEmpty(code, encryptedData, iv)) {
            ctx.attr("@info", new JSONObject().fluentPut("code", 5000).fluentPut("msg", "必填参数不能为空"));
            return;
        }
        JSONObject data = QHTTP.getJSON(url + "?appid=" + appid + "&secret=" + app_key + "&js_code=" + code + "&grant_type=authorization_code");
//        if (!Objects.equals(data.getString("expires_in"), "7200")) {
//            ctx.attr("@info", new JSONObject().fluentPut("code", 5000).fluentPut("msg", data.getString("errmsg")));
//            return;
//        }
        JSONObject _dt = getUserInfo(encryptedData, data.getString("session_key"), iv);
        String city = _dt.getString("city");
        if(city .contains("'")){
            city = city.replaceAll("'","");
            _dt.put("city",city);
        }
        if (_dt == null) {
            ctx.attr("@info", new JSONObject().fluentPut("code", 5000).fluentPut("msg", "解密失败!"));
            return;
        }
        RecordSet<Record> info = HSF.query(L.i("select f.*,m.`status` as state from fst_member_fans f inner join fst_members m on f.mid=m.mid where f.openid=").s(_dt.getString("openId")).a(" and f.stype=1").e());
        if (!info.next()) {
            String nickName = replaceEmoji(_dt.getString("nickName"));
            int cuid = HSF.insert(L.i("insert into fst_members(createtime,nickname,avatar,gender,residecity) values (now(),").s2(nickName).s2(_dt.getString("avatarUrl")).s2(_dt.getString("gender")).s(city).e(")"));
            mid = HSF.insert(L.i("insert into fst_member_fans(mid,stype,openid,nickname,follow_date) values (").s2(cuid).s2("1").s2(_dt.getString("openId")).s2(nickName).a("now()").e(")"));
        }else{
            int state = info.getInt("state");
            if(state==1){
                ctx.attr("@info", new JSONObject().fluentPut("code", 5001).fluentPut("msg", "账号无效，请联系管理员!"));
                return;
            }else {
                mid = info.getInt("mid");
            }
        }
        _dt.fluentPut("mid", mid);
        ctx.attr("@info", _dt);
    }
    //替换特殊字符
    private String replaceEmoji(String str){
        if(!hasEmoji(str)){
            return str;
        }else{
            str=str.replaceAll("[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]"," ");
            return str;
        }
    }
    //判断是否有特殊字符
    private boolean hasEmoji(String nickName){
        Pattern pattern = Pattern.compile("[\ud83c\udc00-\ud83c\udfff]|[\ud83d\udc00-\ud83d\udfff]|[\u2600-\u27ff]");
        Matcher matcher = pattern.matcher(nickName);
        return matcher .find();
    }
    public static JSONObject getUserInfo(String encryptedData, String sessionKey, String iv) {
        // 被加密的数据
        byte[] dataByte = new Base64().decode(encryptedData);
        // 加密秘钥
        byte[] keyByte = new Base64().decode(sessionKey);
        // 偏移量
        byte[] ivByte = new Base64().decode(iv);

        try {
            int base = 16;
            if (keyByte.length % base != 0) {
                int groups = keyByte.length / base + (keyByte.length % base != 0 ? 1 : 0);
                byte[] temp = new byte[groups * base];
                Arrays.fill(temp, (byte) 0);
                System.arraycopy(keyByte, 0, temp, 0, keyByte.length);
                keyByte = temp;
            }
            // 初始化
            Security.addProvider(new BouncyCastleProvider());
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding", "BC");
            SecretKeySpec spec = new SecretKeySpec(keyByte, "AES");
            AlgorithmParameters parameters = AlgorithmParameters.getInstance("AES");
            parameters.init(new IvParameterSpec(ivByte));
            cipher.init(Cipher.DECRYPT_MODE, spec, parameters);// 初始化
            byte[] resultByte = cipher.doFinal(dataByte);
            if (null != resultByte && resultByte.length > 0) {
                String result = new String(resultByte, "UTF-8");
                return JSONObject.parseObject(result);
            }
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidParameterSpecException | IllegalBlockSizeException
                | BadPaddingException | UnsupportedEncodingException | InvalidKeyException | InvalidAlgorithmParameterException | NoSuchProviderException e) {
        }
        return null;
    }
}