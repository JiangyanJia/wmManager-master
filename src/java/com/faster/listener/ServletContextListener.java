package com.faster.listener;

import tech.qting.bcore.db.Conn;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.db.ISql;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.mcore.Conf;
import tech.qting.qson.JSONObject;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import java.util.HashMap;
import java.util.Map;

@WebListener
public class ServletContextListener implements javax.servlet.ServletContextListener {
    /**
     * 初始化数据库
     * */
    private static final ISql sms = HSF.init("java:/comp/env/dbmf");
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        HSF.setDefaultDatabase("java:/comp/env/dbmf");
        //读取数据的变量塞到全局里面
        setSysConfig(sce);
    }
    /**
     *  读取数据的变量塞到全局里面
     *  @param sce
     * */
    public void setSysConfig(ServletContextEvent sce){
        //将配置表的所有数据封装到map配置到全局变量
        RecordSet<Record> rs = sms.query("select cfgkey,itemval from t_sys_config", 3600);
            if (rs.next()) {
                Map<String, String> map = new HashMap<String, String>();
                for (int i = 0, j = rs.size(); i < j; i++) {
                    JSONObject obj = rs.getJSONObject(i);
                    map.put(obj.getString("cfgkey"), obj.getString("itemval"));
                }
                javax.servlet.ServletContext sctx = sce.getServletContext();
                sctx.setAttribute("sysconfig", map);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Conf.release();
            Conn.close();
        } catch (Exception e) {
            e.printStackTrace(System.err);
        }
    }
}
