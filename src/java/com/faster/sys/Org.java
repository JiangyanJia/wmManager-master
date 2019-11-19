package com.faster.sys;

import tech.qting.bcore.db.HSF;
import tech.qting.bcore.mo.Record;
import tech.qting.bcore.mo.RecordSet;
import tech.qting.ist.annotation.IstService;
import tech.qting.qson.JSONArray;
import tech.qting.qson.JSONObject;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.Org
 * @ClassName: Params
 * @Author: lhh
 * @Description: 系统组织相关
 * @Date: 2019-10-14 09:23
 * @Version: 1.0
 */
@IstService
public class Org{


    /**
     * @param orgType 机构类型
     * @param areaCode 区域代码
     * @date 2019-10-14 10:22:08
     * @author lhh
     * @return
     */
    public JSONObject getOrgData(String orgType, String areaCode){
        RecordSet<Record> record = HSF.query("SELECT o.id,o.orgCode,o.parentCode,o.orgType,o.areaCode,o.areaName,o.scenic_id," +
                "CASE WHEN o.scenic_id is null OR o.scenic_id ='' THEN (SELECT a.areaName FROM t_sys_area a WHERE a.areaCode=o.areaCode) " +
                "ELSE (SELECT s.`name` FROM t_gis_scenic s WHERE s.type=1 AND s.id=o.scenic_id) END AS `name` FROM t_sys_org o WHERE o.orgType='"+orgType+"' AND o.areaCode=?", areaCode);
        return record.size()>0?record.get(0):new JSONObject();
    }

    /**
     * @param orgType 机构类型
     * @param scenic 景区编号
     * @date 2019-10-14 10:22:08
     * @author lhh
     * @return
     */
    public JSONObject getOrgDataByScenic(String orgType, String scenic){
        String sql = "SELECT o.id,o.orgCode,o.parentCode,o.orgType,o.areaCode,o.areaName,o.scenic_id," +
                "CASE WHEN o.scenic_id is null OR o.scenic_id ='' THEN (SELECT a.areaName FROM t_sys_area a WHERE a.areaCode=o.areaCode) " +
                "ELSE (SELECT s.`name` FROM t_gis_scenic s WHERE s.type=1 AND s.id=o.scenic_id) END AS `name` FROM t_sys_org o WHERE o.orgType='"+orgType+"' AND o.scenic_id=?";
        System.out.println(sql);
        RecordSet<Record> record = HSF.query(sql, scenic);
        return record.size()>0?record.get(0):new JSONObject();
    }

    /**
     * 获取当前区域的机构信息
     * @param areaCode 区域代码
     * @date 2019-10-14 10:22:08
     * @author lhh
     * @return
     */
    public JSONArray getOrgDataListByAreaCode(String areaCode){
        RecordSet<Record> record = HSF.query("select * from t_sys_org o where o.areaCode in " +
                "(select a.areaCode from t_sys_area a where a.parentCode=?)", areaCode);
        return record.size()>0?record:new JSONArray();
    }

    /**
     * 获取当前区域的机构上级机构信息
     * @param areaCode 区域代码
     * @date 2019-10-14 10:22:08
     * @author lhh
     * @return
     */
    public JSONObject getParentOrgDataByAreaCode(String areaCode){
        RecordSet<Record> record = HSF.query("select * from t_sys_org o where o.areaCode in " +
                "(select a.parentCode from t_sys_area a where a.areaCode=?)", areaCode);
        return record.size()>0?record.get(0):new JSONObject();
    }

    /**
     * 获取当前区域的机构信息
     * @param areaCode 区域代码
     * @date 2019-10-14 10:22:08
     * @author lhh
     * @return
     */
    public JSONArray getOrgDataList(String areaCode){
        RecordSet<Record> record = HSF.query("select * from t_sys_org where isLock=0");
        return record.size()>0?record:new JSONArray();
    }
}
