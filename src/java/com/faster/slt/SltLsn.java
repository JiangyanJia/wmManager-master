/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.faster.slt;

import tech.qting.cache.redis.Redis;
import tech.qting.cache.redis.RedisPool;
import tech.qting.ist.IceParse;
import tech.qting.util.TL;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.ResourceBundle;

/**
 * Web application lifecycle listener.
 *
 * @author lhh
 */
@WebListener
public class SltLsn implements ServletContextListener {

    public static Redis redis;

    public SltLsn() {
        IceParse.init("com.faster");
        ResourceBundle conf = ResourceBundle.getBundle("conf");
        if (TL.isNotEmpty(conf.getString("db.cache.host"))) {
            String pwd = conf.getString("db.cache.pwd");
            if (pwd.isEmpty()) {
                redis = RedisPool.init(conf.getString("db.cache.host"), Integer.parseInt(conf.getString("db.cache.port")));
            } else {
                redis = RedisPool.init(conf.getString("db.cache.host"), Integer.parseInt(conf.getString("db.cache.port")), pwd);
            }
//            HSF.setCache(redis);
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {


    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }

    public static String attr(String key) {
        /*if (redis == null) {
            return null;
        }*/
        try {

            if (TL.isEmpty(redis)) {
                return null;
            }

            return redis.get(key);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
//            if(redis!=null)
//                redis.close();
        }
    }

    public static void attr(String key, String val, int timeout) {
//        if (redis == null) {
//            return;
//        }
//        redis.setx(key, val, timeout);
        try {
            if (TL.isEmpty(redis)) {
                return;
            }
            redis.setx(key, val, timeout);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
//            if(redis!=null)
//                redis.close();
        }
    }

    public static boolean del(String key) {
        if (redis == null) {
            return false;
        }
        return redis.del(key);
    }
}
