/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.faster.buzz;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.L;
import tech.qting.util.TL;

/**
 *
 * @author HMQ
 */
public class RoleBuzz {

    /**
     * 授权功能(len=1单个角色授权，len>1则多个角色授权)
     *
     * @param ctx
     */
    public void updateRole(IContext ctx) {
        String idd = ctx.para("idd");
        JSONArray items = JSONArray.parseArray(idd);
        String rid = ctx.para("rid");
        List<String> sqlList = new ArrayList();
        sqlList.add("delete from t_sys_role_function where rid="+rid);
        String sysUsrId = (String) ctx.attr("sysUsrId", IContext.Scope.Session);

        int k = 1;
        Map map = new HashMap();
        for (Object strObj : items) {
            JSONObject func = (JSONObject) strObj;
            int id = func.getInteger("id");
            int pid = func.getInteger("pid");
            String grade = func.getString("grade");
            String ftype = func.getString("ftype");
            //System.out.println(rid + "','" + id + "','" + pid + "','" + sysUsrId);
            if ("page".equals(ftype)) {
                sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate,type) values('" + rid + "','" + id + "','" + pid + "','" + sysUsrId + "',now(),0)");
            }else {
                sqlList.add("insert into t_sys_role_function(rid,iid,fid,pid,creator,cdate,type) values(" + rid + ",'" + id + "','" + id + "','" + pid + "','" + sysUsrId + "',now(),0)");
            }
        }
        System.out.println(sqlList);
        try {
            HSF.excute(sqlList);
            ctx.send(0);
        } catch (Exception e) {
            e.printStackTrace();
            ctx.send(1);
        }
        /*String idd = ctx.para("idd");
        String rid = ctx.para("rid");
        String[] usr = idd.split(",");
        List<String> sqlList = new ArrayList();
        sqlList.add("delete from t_sys_role_function where rid="+rid);
        String sysUsrId = (String) ctx.attr("sysUsrId", IContext.Scope.Session);

        int k = 1;
        Map map = new HashMap();
        for (String str : usr) {
            String[] func = str.split(":");
            int xx = Integer.parseInt(func[1]);
            System.out.println(rid + "','" + func[0] + "','" + func[1] + "','" + sysUsrId);
            if ("page".equals(func[3])) {//菜单类型
                sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate,type) values('" + rid + "','" + func[0] + "','" + func[1] + "','" + sysUsrId + "',now(),0)");
            }else {//功能类型 code
                sqlList.add("insert into t_sys_role_function(rid,iid,fid,pid,creator,cdate,type) values(" + rid + ",'" + func[0] + "','" + func[0] + "','" + func[1] + "','" + sysUsrId + "',now(),0)");
            }
        }
        System.out.println(sqlList);
        try {
            HSF.excute(sqlList);
            ctx.send(0);
        } catch (Exception e) {
            e.printStackTrace();
            ctx.send(1);
        }*/
    }

    private List<String> instInter(List<String> sqlList, String interlist, String rid, String sysUsrId) {
        String[] usr = interlist.split(",");
        for (String str : usr) {
            sqlList.add("insert into t_sys_role_function(rid,iid,creator,cdate,type) values(" + rid + "," + str + ",'" + sysUsrId + "',now(),1)");
        }
        return sqlList;
    }

    private List<String> instFunc(List<String> sqlList, String funclist, String rid, String sysUsrId) {
        String[] flist = funclist.split(",");
        for (String str : flist) {
            System.out.println("str---" + str);
            final String[] func = str.split(":");
            sqlList.add("insert into t_sys_role_function(rid,iid,fid,pid,creator,cdate,type) values(" + rid + ",'" + func[0] + "','" + func[0] + "','" + func[1] + "','" + sysUsrId + "',now(),0)");
        }
        return sqlList;
    }

    private List<String> instMenu(List<String> sqlList, String menulist, String rid, String sysUsrId) {
        String[] flist = menulist.split(",");
        int k = 1;
        for (String str : flist) {
            String[] func = str.split(":");
            if ("3".equals(func[2])) {
                //判断是否已添加过
                RecordSet<Record> rs = HSF.query(L.i("select pid from t_sys_function where fid = ").se(func[1]));
                String pid = rs.getString("pid");
                RecordSet<Record> rs2 = HSF.query(L.i("select * from t_sys_role_function where rid=").s(rid).a(" and fid=").s(func[1]).a(" and pid=").se(pid));
                sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate,type) values('" + rid + "','" + func[1] + "','" + pid + "','" + sysUsrId + "',now(),0)");
            }
            sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate,type) values('" + rid + "','" + func[0] + "','" + func[1] + "','" + sysUsrId + "',now(),0)");
        }
        return  sqlList;
    }

    public void userRole(IContext ctx) {
        String rid = ctx.para("rid");
        String ulist = ctx.para("ulist");
        List<String> sqlList = new ArrayList();
        sqlList.add("delete from t_sys_user_role where rid='" + rid + "'");
        if (TL.isNotEmpty(ulist)) {
            String[] usr = ulist.split(",");
            String sysUsrId = (String) ctx.attr("sysUsrId");
            for (String str : usr) {
                sqlList.add("insert into t_sys_user_role(rid,uid,creator,cdate) values(" + rid + "," + str + ",'" + sysUsrId + "',now())");
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@userRole", "0");
        } catch (Exception ex) {
            ctx.attr("@userRole", "1");
        }
    }

    /**
     *
     * @param ctx
     */
    public void instOneRole(IContext ctx) {
        String rid = ctx.para("rid");
        String ulist = ctx.para("ulist");
        List<String> sqlList = new ArrayList();
        if (TL.isNotEmpty(ulist)) {
            String[] usr = ulist.split(",");
            String sysUsrId = (String) ctx.attr("sysUsrId");
            for (String str : usr) {
                sqlList.add("insert into t_sys_user_role(rid,uid,creator,cdate) values(" + rid + "," + str + ",'" + sysUsrId + "',now())");
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@rfunc", "0");
        } catch (Exception ex) {
            ctx.attr("@rfunc", "1");
        }
    }

    public void instMoreRole(IContext ctx) {
        String rids = ctx.para("rid").replaceAll("'", "");
        String ulist = ctx.para("ulist");
        List<String> sqlList = new ArrayList();
        String[] ridStr = rids.split(",");
        String sysUsrId = (String) ctx.attr("sysUsrId");
        for (String rid : ridStr) {
            if (TL.isNotEmpty(ulist)) {
                String[] usr = ulist.split(",");
                for (String str : usr) {
                    RecordSet<Record> rs = HSF.query(new StringBuilder("SELECT * FROM t_sys_user_role WHERE rid ='").append(rid).append("' and uid='").append(str).append("'").toString());
                    if (!rs.next()) {
                        sqlList.add("insert into t_sys_user_role(rid,uid,creator,cdate) values(" + rid + "," + str + ",'" + sysUsrId + "',now())");
                    }
                }
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@rfunc", "0");
        } catch (Exception ex) {
            ctx.attr("@rfunc", "1");
        }
    }

//    public void updateRole(IContext ctx) throws Exception {
//        String rid = ctx.para("rid");
//        String ulist = ctx.para("ulist");
//        HSF._excute("delete from T_SYS_ROLE_FUNCTION where rid=" + rid);
//        if (TL.isNotEmpty(ulist)) {
//            String[] usr = ulist.split(",");
//            List<String> sqlList = new ArrayList();
//            String sysUsrId = (String) ctx.getSessionCache("sysUsrId");
//            for (int i = 0; i < usr.length; i++) {
//                sqlList.add("INSERT INTO T_SYS_ROLE_FUNCTION(RID,FID,CREATOR,CDATE) VALUES(" + rid + "," + usr[i] + "," + sysUsrId + ",now())");
//            }
//            HSF.excute(sqlList);
//        }
//        ctx.setAttribute("@rfunc", "0");
//    }
    protected  List removeDuplicate(List list) {
        List listTemp = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            if (!listTemp.contains(list.get(i))) {
                listTemp.add(list.get(i));
            }
        }
        return listTemp;
    }

}
