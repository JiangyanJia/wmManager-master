package com.faster.buzz;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.http.QHttp;
import tech.qting.ist.annotation.IstService;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.L;
import tech.qting.util.TL;

import java.util.HashSet;
import java.util.Set;

/**
 * @author HMQ
 */
@IstService
public class LoginBuzz {

    private static final QHttp QHTTP = new QHttp();
    protected final static Logger LOG = LogManager.getLogger();

    public void login(IContext ctx) {
        String userid = ctx.para("userid");
        String password = ctx.para("password");
        RecordSet<Record> rs = HSF.query(L.i("SELECT * FROM t_sys_user WHERE stat=1 and userid =").s(userid).a(" and passwd=").se(password));
        if (rs.next()) {
            JSONObject json = new JSONObject();
            String sysUsrId = rs.getString("userid");
            String sysUsrName = rs.getString("rname");
            String sysMobile = rs.getString("mobile");
            String sysUsrType = rs.getString("stype");
            String sysPower = rs.getString("power");
            System.out.println(sysUsrType);
            String sysOrgId = rs.getString("orgId");
            String uid = rs.getString("uid");
            ctx.attr("uid", uid, IContext.Scope.Session);
            ctx.attr("orgId", sysOrgId, IContext.Scope.Session);
            ctx.attr("sysUsrType", sysUsrType, IContext.Scope.Session);
            ctx.attr("sysUsrId", sysUsrId, IContext.Scope.Session);
            ctx.attr("sysUserName", sysUsrName, IContext.Scope.Session);
            ctx.attr("sysMobile", sysMobile, IContext.Scope.Session);
            ctx.attr("sysPower", sysPower, IContext.Scope.Session);
            json.fluentPut("sysUsrId", sysUsrId).fluentPut("sysUsrName", sysUsrName).fluentPut("sysUsrType", sysUsrType).fluentPut("sysOrgId", sysOrgId).fluentPut("uid", uid);
            Set<String> set = new HashSet<String>();
            RecordSet<Record> record = null;
            if ("1".equals(sysUsrType)) {
                record = HSF.query("select CODE from t_sys_function");
            } else {
                record = HSF.query(L.i("SELECT CODE from t_sys_function where fid in (SELECT fid from t_sys_role_function where rid in(select rid from t_sys_user_role where uid = ").s(uid).a(") ) and code is not null and code !='' order by code").e());
            }
            while (record.next()) {
                set.add(record.getString("CODE"));
            }
            ctx.login(sysUsrId, sysUsrName, set, json);
            ctx.attr("@loginclz", rs.getJSONObject(0));
        } else {
            ctx.attr("@loginclz", "-1");
        }
    }

    public void loginOut(IContext ctx) {
        ctx.logout();
        ctx.attr("@loginoutclz", "0");
    }

    public void gisWebLogin(IContext ctx) {
        String userName = ctx.para("userName");
        String password = ctx.para("password");
        RecordSet<Record> rs = HSF.query(L.i("SELECT * FROM t_sys_user WHERE stat=1 and userid =").se(userName));
        if (rs.next()) {

            ctx.attr("@loginclz", rs.getJSONObject(0));
        } else {
            ctx.attr("@loginclz", "-1");
        }
    }

    public void tokenInfo(IContext ctx) {
        JSONObject tokenInfo = (JSONObject) ctx.attr("@tokenInfo");
        String token = tokenInfo.getString("token");

        ctx.attr("sysToken", token, IContext.Scope.Session);
    }

    public void getTokenInfo(IContext ctx) {
        JSONObject loginInfo = (JSONObject) ctx.attr("@logininfo");

        if (!TL.isEmpty(loginInfo)) {

            String uid = loginInfo.getString("userid");
            RecordSet<Record> record = getSynchronLocalUser(uid);
            if (record.next()) {
                String isType = record.getString("isType");
                String sysPower = record.getString("power");
                if (("1".equals(isType) && TL.isEmpty(sysPower)) || "-1".equals(isType)) {
                    ctx.attr("code", -1);
                    ctx.attr("msg", "登录失败，无景区权限");
                    record.get(0).put("code", -1);
                    record.get(0).put("info", "请联系管理员，先配置用户权限");
                    ctx.attr("@tokenInfo", record.get(0));
                } else {
                    System.out.println("info:" + record.get(0));
                    record.get(0).put("code", 0);
                    record.get(0).put("info", "登录成功");
                    ctx.attr("@tokenInfo", record.get(0));
                }
            }
        } else {
            ctx.attr("@tokenInfo", loginInfo);
        }
    }

    /**
     * 系统用户登录
     *
     * @param ctx
     */
    public void loginInfo(IContext ctx) {
        JSONObject functionList = (JSONObject) ctx.attr("@functionList");
        JSONObject userInfo = (JSONObject) ctx.attr("@userInfo");
        String token = ctx.para("utoken");

        if (!TL.isEmpty(userInfo)) {

            //1、同步认证平台用户

            //2、登录数据处理
            JSONObject json = new JSONObject();
            String sysUsrId = userInfo.getString("userid");
            String sysUsrName = userInfo.getString("name");
            String sysMobile = userInfo.getString("mobile");
            String sysUsrType = "";//userInfo.getString("stype");
            //String sysPower = userInfo.getString("power");
            String sysOrgId = userInfo.getString("orgList");
            String uid = userInfo.getString("userid");

            RecordSet<Record> record = getSynchronLocalUser(uid);
            if (record.next()) {
                String isType = record.getString("isType");
                String sysPower = record.getString("power");
                if (("1".equals(isType) && TL.isEmpty(sysPower)) || "-1".equals(isType)) {
//                    ctx.attr("err", -1);
//                    ctx.attr("msg", "登录失败，请先配置景区权限");
                    userInfo.put("code", -1);
                    userInfo.put("msg", "请联系管理员，先配置用户权限");
                    ctx.attr("@loginclz", userInfo);
                } else {
                    ctx.attr("uid", sysUsrId, IContext.Scope.Session);
                    ctx.attr("orgId", sysOrgId, IContext.Scope.Session);
                    ctx.attr("sysUsrType", "", IContext.Scope.Session);
                    ctx.attr("sysUsrId", sysUsrId, IContext.Scope.Session);
                    ctx.attr("sysUserName", sysUsrName, IContext.Scope.Session);
                    ctx.attr("sysMobile", sysMobile, IContext.Scope.Session);
                    ctx.attr("sysPower", sysPower, IContext.Scope.Session);//-1：县级管理员，景区的管理员对应景区编号（如：183：为天门山管理员）
                    ctx.attr("sysIsType", isType, IContext.Scope.Session);//是否Gis后台操作（0:不过滤gis景区数据，1:gis操作数据）
                    ctx.attr("sysToken", token, IContext.Scope.Session);
                    ctx.attr("sysLoginType", "0", IContext.Scope.Session);//1:单点登录 0：系统登录
                    json.fluentPut("sysUsrId", sysUsrId).fluentPut("sysUsrName", sysUsrName).fluentPut("sysUsrType", sysUsrType).fluentPut("sysOrgId", sysOrgId).fluentPut("uid", uid);
                    Set<String> set = new HashSet<String>();

                    if (functionList != null) {
                        JSONArray data = functionList.getJSONArray("data");

                        if (!TL.isEmpty(data)) {
                            for (Object obj : data) {
                                JSONObject o = (JSONObject) obj;
                                if ("func".equals(o.getString("FTYPE"))) {
                                    set.add(o.getString("CODE"));
                                }
                            }
                        }
                    }
                    ctx.login(sysUsrId, sysUsrName, set, json);
                    userInfo.put("code", 0);
                    userInfo.put("msg", "登录成功");
                    ctx.attr("@loginclz", userInfo);
                }
            }
        } else {
            userInfo.put("code", -1);
            userInfo.put("msg", "登录失败，同步用户数据失败");
            ctx.attr("@loginclz", userInfo);
        }
    }

    /**
     * 认证平台单点登录
     *
     * @param ctx
     */
    public void loginAuthzCheck(IContext ctx) {

        JSONObject functionList = (JSONObject) ctx.attr("@functionList");
        JSONObject userInfo = (JSONObject) ctx.attr("@userInfo");
        String token = ctx.para("utoken");

        JSONObject json = new JSONObject();
        if (!TL.isEmpty(userInfo)) {
            String err = userInfo.getString("err");
            if (err.equals("0")) {
                String sysUsrId = userInfo.getString("userid");
                String sysUsrName = userInfo.getString("name");
                String sysMobile = userInfo.getString("mobile");
                String sysUsrType = "";//userInfo.getString("stype");
                //String sysPower = userInfo.getString("power");
                String sysOrgId = userInfo.getString("orgList");
                String uid = userInfo.getString("userid");

                RecordSet<Record> record = getSynchronLocalUser(uid);
                if (record.next()) {
                    String isType = record.getString("isType");
                    String sysPower = record.getString("power");

                    if (("1".equals(isType) && TL.isEmpty(sysPower)) || "-1".equals(isType)) {
                        ctx.attr("err", -1);
                        ctx.attr("msg", "请联系管理员，先配置用户权限。");
                        ctx.redirect("../../page/login/loginPage");
                    } else {
                        ctx.attr("uid", sysUsrId, IContext.Scope.Session);
                        ctx.attr("orgId", sysOrgId, IContext.Scope.Session);
                        ctx.attr("sysUsrType", "", IContext.Scope.Session);
                        ctx.attr("sysUsrId", sysUsrId, IContext.Scope.Session);
                        ctx.attr("sysUserName", sysUsrName, IContext.Scope.Session);
                        ctx.attr("sysMobile", sysMobile, IContext.Scope.Session);
                        ctx.attr("sysPower", sysPower, IContext.Scope.Session);//-1：县级管理员，景区的管理员对应景区编号（如：183：为天门山管理员）
                        ctx.attr("sysIsType", isType, IContext.Scope.Session);//是否Gis后台操作（0:不过滤gis景区数据，1:gis操作数据）
                        ctx.attr("sysToken", token, IContext.Scope.Session);
                        ctx.attr("sysLoginType", "1", IContext.Scope.Session);//1:单点登录 0：系统登录
                        json.fluentPut("sysUsrId", sysUsrId).fluentPut("sysUsrName", sysUsrName).fluentPut("sysUsrType", sysUsrType).fluentPut("sysOrgId", sysOrgId).fluentPut("uid", uid);
                        Set<String> set = new HashSet<String>();

                        if (functionList != null) {
                            JSONArray data = functionList.getJSONArray("data");

                            if (!TL.isEmpty(data)) {
                                for (Object obj : data) {
                                    JSONObject o = (JSONObject) obj;
                                    if ("func".equals(o.getString("FTYPE"))) {
                                        set.add(o.getString("CODE"));
                                    }
                                }
                            }
                        }
                        ctx.login(sysUsrId, sysUsrName, set, json);
                        ctx.redirect("../../page/index/showIndex");
                    }
                }
            } else {
                json.fluentPut("err", -1).fluentPut("msg", "TOKEN无效");
                ctx.redirect("../../page/login/loginPage");
            }
        } else {
            json.fluentPut("err", -1).fluentPut("msg", "TOKEN无效");
            ctx.redirect("../../page/login/loginPage");
        }

    }

    /**
     * 获取同步后的本地用户数据
     *
     * @param userId
     * @return
     */
    private RecordSet<Record> getSynchronLocalUser(String userId) {
        RecordSet<Record> rs = HSF.query(L.i("SELECT * FROM t_auth_user WHERE stat=1 and status=0 AND userid=").se(userId));
        return rs;
    }


}
