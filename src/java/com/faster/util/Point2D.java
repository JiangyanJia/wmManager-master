package com.faster.util;

/**
 * @ProjectName: fstControlManager
 * @Package: com.faster.util
 * @ClassName: Point
 * @Author: shaohong-zhu
 * @Description: 经纬度坐标点
 * @Date: 2019/9/20 13:55
 * @Version: 1.0
 */
public class Point2D {

    private Double lat;//纬度

    private Double lng;//经度

    public Point2D(Double lat, Double lng) {
        this.lat = lat;
        this.lng = lng;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public Double getLng() {
        return lng;
    }

    public void setLng(Double lng) {
        this.lng = lng;
    }
}
