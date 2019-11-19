package com.faster.route;

import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;
import tech.qting.util.L;

/**
 * @author cmm
 * 2018-8-8
 */
public class getRouteData {

    /**
     * 得到t_sys_function 表里面所有url
     */
    public void getRouteUrlJson(IContext ctx) {
        RecordSet<Record> rs = HSF.query(L.i("select * from t_sys_function where RESURL !='' and RESURL is not null").e());
        if (rs.next()) {
            JSONArray JsonArray = new JSONArray();
            //添加首页路由跳转
            JSONObject index = new JSONObject();
            index.fluentPut("path","/");
            
            index.fluentPut("component","../../page/route/index");
            index.fluentPut("name", "主页");
            JsonArray.fluentAdd(index);
            //添加首页路由跳转结束
            for (int i = 0,j = rs.size();i<j; i++) {
                JSONObject Json = new JSONObject();
                JSONObject obj = rs.getJSONObject(i);
                Json.fluentPut("path", obj.getString("RESURL"));
                Json.fluentPut("component", "../../page/" + obj.getString("RESURL"));
                Json.fluentPut("name", obj.getString("FNAME"));
                JsonArray.fluentAdd(Json);
            }
            ctx.attr("@allRoute", JsonArray.toJSONString());
        }

    }
}
