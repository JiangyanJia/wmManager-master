package com.faster.util;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.util
 * @ClassName: PtInCircleUtil
 * @Author: shaohong-zhu
 * @Description: 工具类-判断一个点是否在一个圆内
 * @Date: 2019/9/20 14:06
 * @Version: 1.0
 */
public class PtInCircleUtil {


    /**
     * 判断是否在圆形内
     *
     * @param circle 圆中心坐标
     * @param pt     点坐标
     * @param radius 圆半径
     * @return boolean
     * @date 2019/9/20 14:22
     * @author shaohong-zhu
     */
    public static boolean isInCircle(Point2D circle, Point2D pt, Double radius) {
        return getDistance(circle, pt) <= radius;
    }

    /**
     * 通过经纬度获取距离(单位：米)
     *
     * @param circle 圆中心坐标
     * @param pt     点坐标
     * @return double
     * @date 2019/9/20 14:19
     * @author shaohong-zhu
     */
    public static double getDistance(Point2D circle, Point2D pt) {
        double R = 6378137.0;
        double dLat = (circle.getLat() - pt.getLat()) * Math.PI / 180;
        double dLng = (circle.getLng() - pt.getLng()) * Math.PI / 180;

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(pt.getLat() * Math.PI / 180) * Math.cos(circle.getLat() * Math.PI / 180) * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double d = R * c;
        double dis = Math.round(d);

        return dis;
    }


}
