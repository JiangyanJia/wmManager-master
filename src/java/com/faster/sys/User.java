package com.faster.sys;

import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.L;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.sys
 * @ClassName: User
 * @Author: shaohong-zhu
 * @Description: 用户
 * @Date: 2019/9/26 17:02
 * @Version: 1.0
 */
public class User {

    /**
     * 新增用户
     *
     * @param userId
     * @param orgId
     * @param userName
     * @param pwd
     * @param tel
     * @param email
     * @param addr
     * @param remark
     * @return int
     * @date 2019/9/27 9:15
     * @author shaohong-zhu
     */
    public int add(String userId, String orgId, String userName, String pwd, String tel, String email, String addr, String remark) {
        String insertSQL = L.i("INSERT INTO t_sys_user(userid,orgId,stype,uname,rname,passwd,tel,email,address,stat,remark) VALUES (")
                .s2(userId).s2(orgId).s2(2).s2(userName).s2(userName).s2(pwd).s2(tel).s2(email).s2(addr).s2(1).s(remark).a(")").e();
        return HSF.insert(insertSQL);
    }

    /**
     * 更新用户信息
     *
     * @param userId
     * @param orgId
     * @param userName
     * @param tel
     * @param email
     * @param addr
     * @param remark
     * @return boolean
     * @date 2019/9/27 9:21
     * @author shaohong-zhu
     */
    public boolean update(String userId, String orgId, String userName, String tel, String email, String addr, String remark) {
        return HSF.exec("UPDATE t_sys_user SET userid = ?,orgId = ?,uname = ?, rname= ? ,tel = ?,email = ?,address = ?,remark = ? WHERE userid = ?",
                userId, orgId, userName, userName, tel, email, addr, remark, userId) > 0;
    }

    /**
     * 删除用户
     *
     * @param userId
     * @return boolean
     * @date 2019/9/27 9:22
     * @author shaohong-zhu
     */
    public boolean del(String userId) {
        return HSF.exec("delete from t_sys_user where userid=?", userId) > 0;
    }

    public JSONObject queryOne(String userId) {
        RecordSet<Record> records = HSF.query("select *  from t_sys_user where userid = ?", userId);
        return records.size() > 0 ? records.get(0) : null;
    }

    /**
     * 获取用户信息
     * @param orgId 机构编码
     * @date 2019-10-25 10:22:08
     * @author lhh
     * @return
     */
    public JSONArray getUserDataList(String orgId){
        RecordSet<Record> record = HSF.query("select * from t_sys_user");
        return record.size()>0?record:new JSONArray();
    }
}
