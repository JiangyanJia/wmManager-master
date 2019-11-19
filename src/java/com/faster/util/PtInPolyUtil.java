package com.faster.util;

import java.util.ArrayList;
import java.util.List;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.util
 * @ClassName: PtInPolyUtil
 * @Author: shaohong-zhu
 * @Description: 工具类-判断点是否在区域范围内
 * @Date: 2019/9/20 13:56
 * @Version: 1.0
 */
public class PtInPolyUtil {

    /**
     * 判断位置是否在多边形区域内
     *
     * @param pt 当前点
     * @param ps 区域顶点
     * @return boolean 点在多边形内返回true, 否则返回false
     * @date 2019/9/20 13:58
     * @author shaohong-zhu
     */
    public static boolean isPtInPoly(Point2D pt, Point2D[] ps) {

        if (ps.length < 3) {
            return false;
        }
        double p_lng = pt.getLng();
        double p_lat = pt.getLat();
        java.awt.geom.Point2D.Double point = new java.awt.geom.Point2D.Double(p_lng, p_lat);
        List<java.awt.geom.Point2D.Double> pList = new ArrayList<java.awt.geom.Point2D.Double>();

        for (int i = 0; i < ps.length; i++) {
            double polygonPoint_lng = ps[i].getLng();
            double polygonPoint_lat = ps[i].getLat();
            java.awt.geom.Point2D.Double polygonPoint = new java.awt.geom.Point2D.Double(polygonPoint_lng, polygonPoint_lat);
            pList.add(polygonPoint);
        }
        return isPtInPoly(point, pList);
    }

    /**
     * 判断点是否在多边形内，如果点位于多边形的顶点或边上，也算做点在多边形内，直接返回true
     *
     * @param point 检测点
     * @param pList 多边形的顶点
     * @return boolean 点在多边形内返回true, 否则返回false
     * @date 2019/9/20 13:57
     * @author shaohong-zhu
     */
    public static boolean isPtInPoly(java.awt.geom.Point2D.Double point, List<java.awt.geom.Point2D.Double> pList) {

        int size = pList.size();
        int intersectCount = 0;//cross points count of x
        double precision = 2e-10; //浮点类型计算时候与0比较时候的容差
        java.awt.geom.Point2D.Double p1, p2;//neighbour bound vertices
        java.awt.geom.Point2D.Double p = point; //当前点

        p1 = pList.get(0);//left vertex

        //check all rays
        for (int i = 1; i <= size; ++i) {
            if (p.equals(p1)) {
                return true;//p is an vertex
            }

            p2 = pList.get(i % size);//right vertex
            if (p.x < Math.min(p1.x, p2.x) || p.x > Math.max(p1.x, p2.x)) {//ray is outside of our interests
                p1 = p2;
                continue;//next ray left point
            }

            if (p.x > Math.min(p1.x, p2.x) && p.x < Math.max(p1.x, p2.x)) {//ray is crossing over by the algorithm (common part of)
                if (p.y <= Math.max(p1.y, p2.y)) {//x is before of ray
                    if (p1.x == p2.x && p.y >= Math.min(p1.y, p2.y)) {//overlies on a horizontal ray
                        return true;
                    }

                    if (p1.y == p2.y) {//ray is vertical
                        if (p1.y == p.y) {//overlies on a vertical ray
                            return true;
                        } else {//before ray
                            ++intersectCount;
                        }
                    } else {//cross point on the left side
                        double xinters = (p.x - p1.x) * (p2.y - p1.y) / (p2.x - p1.x) + p1.y;//cross point of y
                        if (Math.abs(p.y - xinters) < precision) {//overlies on a ray
                            return true;
                        }

                        if (p.y < xinters) {//before ray
                            ++intersectCount;
                        }
                    }
                }
            } else {//special case when ray is crossing through the vertex
                if (p.x == p2.x && p.y <= p2.y) {//p crossing over p2
                    java.awt.geom.Point2D.Double p3 = pList.get((i + 1) % size); //next vertex
                    if (p.x >= Math.min(p1.x, p3.x) && p.x <= Math.max(p1.x, p3.x)) {//p.x lies between p1.x & p3.x
                        ++intersectCount;
                    } else {
                        intersectCount += 2;
                    }
                }
            }
            p1 = p2;//next ray left point
        }

        if (intersectCount % 2 == 0) {//偶数在多边形外
            return false;
        } else { //奇数在多边形内
            return true;
        }
    }
}
