package com.faster.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import tech.qting.IContext;
import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;

import java.util.ArrayList;
import java.util.List;

public class Sysconfig {

    protected final static Logger LOG = LogManager.getLogger();

    public void updateConfig(IContext ctx) throws Exception {

        String[] keyparam = ctx.para("cfgKey").split(",");

        List<String> sqlList = new ArrayList();

        for (int i = 0; i < keyparam.length; i++) {
            String cfgKey = keyparam[i];
            String itemVal = ctx.para(cfgKey);
            if (cfgKey!=null) {
                LOG.info("cfgKey:" + cfgKey);
                LOG.info("itemVal:" + itemVal);
                HSF.exec("UPDATE t_sys_config SET itemVal=? WHERE cfgKey=?",itemVal, cfgKey);
            }
        };
        ctx.attr("@rfunc", "0");
    }

    /**
     * 获取公共图片路径
     * @return
     */
    public static String getImgUrl(){
        String imgUrl = "";
        RecordSet<Record> rs_imgurl = HSF.query("select cfgkey,itemval from t_sys_config WHERE cfgKey='defimgservice'");
        if (rs_imgurl.next()) {
            imgUrl = rs_imgurl.get(0).getString("itemval");
        }
        return imgUrl;
    }
}
