package com.faster.util;

import java.util.UUID;

public class Test {
    public static void main(String[] args) throws Exception {
        /*String uuid = UUID.randomUUID().toString().replaceAll("-","");
        String bas64uuid = Base64Utils.encode(uuid.getBytes());
        System.out.println(uuid);
        System.out.println(bas64uuid);
        System.out.println(new String(Base64Utils.decode(bas64uuid)));*/
        String uuid = "{\"USER_MOBILE\":\"13987615228\",\"USER_ID\":\"test\",\"USER_COUNTY\":\"179\",\"USER_NAME\":\"景区测试\",\"scenic\":{\"type\":1,\"county_id\":179,\"province_id\":147,\"name\":\"双流县景区测试\",\"id\":22,\"city_id\":148},\"USER_CITY\":\"148\",\"USER_SCENIC\":\"22\",\"USER_TYPE\":\"scenic\"}";
        String bas64uuid = Base64Utils.encode(uuid.getBytes());
        System.out.println(uuid);
        System.out.println(bas64uuid);
        System.out.println(new String(Base64Utils.decode(bas64uuid)));
       /* boolean bool = PtInCircleUtil.isInCircle(new Point2D(111.00,23.00),new Point2D(111.00,23.00),100.00);
        Point2D[] p = new Point2D[]{new Point2D(1.00, 2.00)};
        bool = PtInPolyUtil.isPtInPoly(new Point2D(111.00,23.00),p);
        System.out.println("bool:"+bool);*/
    }
}
