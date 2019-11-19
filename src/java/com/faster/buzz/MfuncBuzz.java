package com.faster.buzz;

import java.util.ArrayList;
import java.util.List;
import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.util.TL;

/**
 *
 * @author HMQ
 */
public class MfuncBuzz {

    public void bindRole(IContext ctx) {
        String iid = ctx.para("iid");
        String fid = ctx.para("fid");
        String pid = ctx.para("pid");
        String rids = ctx.para("rid");
        String sysUsrId = (String) ctx.attr("sysUsrId");
        List<String> sqlList = new ArrayList();
        String[] ridStr = rids.split(",");
        for (String rid : ridStr) {
            if (TL.isEmpty(iid)) {
                sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate,type) values(" + rid + ",'" + fid + "','" + pid + "','" + sysUsrId + "',now(),0)");
            } else {
                sqlList.add("insert into t_sys_role_function(rid,iid,fid,pid,creator,cdate,type) values(" + rid + ",'" + iid + "','" + fid + "','" + pid + "','" + sysUsrId + "',now(),0)");
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@bindRole", "0");
        } catch (Exception ex) {
            ctx.attr("@bindRole", "1");
        }
    }

    public void unbindRole(IContext ctx) {
        String iid = ctx.para("iid");
        String fid = ctx.para("fid");
        String pid = ctx.para("pid");
        String rids = ctx.para("rid");
        List<String> sqlList = new ArrayList();
        String[] ridStr = rids.split(",");
        for (String rid : ridStr) {
            if (TL.isEmpty(iid)) {
                sqlList.add("delete from t_sys_role_function where rid=" + rid + " and fid = " + fid + " and pid=" + pid);
            } else {
                sqlList.add("delete from t_sys_role_function where rid=" + rid + " and iid = " + iid + " and fid = " + fid + " and pid=" + pid);
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@unbindRole", "0");
        } catch (Exception ex) {
            ctx.attr("@unbindRole", "1");
        }
    }

    public void bindMore(IContext ctx) {
        String mlists = ctx.para("mlist");//产品项2
        String flists = ctx.para("flist");//功能项3
        String rids = ctx.para("rids");
        String sysUsrId = (String) ctx.attr("sysUsrId");
        List<String> sqlList = new ArrayList();
        String[] ridStr = rids.split(",");
        for (String rid : ridStr) {
            if (TL.isNotEmpty(flists)) {
                String[] flist = flists.split(",");
                for (String str : flist) {
                    String[] func = str.split(":");
                    RecordSet<Record> rs = HSF.query(new StringBuilder("SELECT * FROM t_sys_role_function WHERE rid ='").append(rid).append("' and iid='").append(func[0]).
                            append("' and fid='").append(func[1]).append("' and pid='").append(func[2]).append("'").toString());
                    if (!rs.next()) {
                        sqlList.add("insert into t_sys_role_function(rid,iid,fid,pid,creator,cdate) values(" + rid + ",'" + func[0] + "','" + func[1] + "','" + func[2] + "','" + sysUsrId + "',now())");
                    }
                }
            }
            if (TL.isNotEmpty(mlists)) {
                String[] mlist = mlists.split(",");
                for (String str : mlist) {
                    String[] func = str.split(":");
                    RecordSet<Record> rs = HSF.query(new StringBuilder("SELECT * FROM t_sys_role_function WHERE rid ='").append(rid).
                            append("' and fid='").append(func[0]).append("' and pid='").append(func[1]).append("'").toString());
                    if (!rs.next()) {
                        sqlList.add("insert into t_sys_role_function(rid,fid,pid,creator,cdate) values(" + rid + ",'" + func[0] + "','" + func[1] + "','" + sysUsrId + "',now())");
                    }
                }
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@bindMore", "0");
        } catch (Exception ex) {
            ctx.attr("@bindMore", "1");
        }
    }

    public void unbindMore(IContext ctx) {
        String mlists = ctx.para("mlist");
        String flists = ctx.para("flist");
        String rids = ctx.para("rids");
        List<String> sqlList = new ArrayList();
        String[] ridStr = rids.split(",");
        for (String rid : ridStr) {
            if (TL.isNotEmpty(flists)) {
                String[] flist = flists.split(",");
                for (String str : flist) {
                    String[] func = str.split(":");
                    sqlList.add("delete from t_sys_role_function where rid='" + rid + "' and iid='" + func[0] + "' and fid ='" + func[1] + "' and pid ='" + func[2] + "'");
                }
            }
            if (TL.isNotEmpty(mlists)) {
                String[] mlist = mlists.split(",");
                for (String str : mlist) {
                    String[] func = str.split(":");
                    sqlList.add("delete from t_sys_role_function where rid='" + rid + "' and fid ='" + func[0] + "' and pid ='" + func[1] + "'");
                }
            }
        }
        try {
            HSF.excute(sqlList);
            ctx.attr("@unbindMore", "0");
        } catch (Exception ex) {
            ctx.attr("@unbindMore", "1");
        }
    }
}
