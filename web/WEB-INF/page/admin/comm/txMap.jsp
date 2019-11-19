<!-- 生成版本:1.2 -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>鼠标移动显示地图坐标信息</title>
    <style type="text/css">
        *{
            margin:0px;
            padding:0px;
        }
        body, button, input, select, textarea {
            font: 12px/16px Verdana, Helvetica, Arial, sans-serif;
        }
        #container{
            min-width:600px;
            min-height:667px;
        }
    </style>
    <script charset="utf-8" src="https://map.qq.com/api/js?v=2.exp&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77"></script>
    <script src="${BASE}/layui/v2.4/layui.js"></script>
    <script>
        var init = function() {
            var lat = window.parent.$("#lat").val();
            var lng = window.parent.$("#lng").val();
            if (lat == "") lat = "30.6595";
            if (lng == "") lng = "104.066";
            var map = new qq.maps.Map(document.getElementById("container"),{
                // center: new qq.maps.LatLng(30.6595,104.066),
                center: new qq.maps.LatLng(lat, lng),
                zoom: 13
            });
            qq.maps.event.addListener(map,'click',function(event) {
                var latLng = event.latLng,
                    lat = latLng.getLat().toFixed(5),
                    lng = latLng.getLng().toFixed(5);
                //document.getElementById("latLng").innerHTML = lng+','+lat;
                // 弹出确认框，确认后关闭地图选择
                layui.use(['layer'], function() {
                    var layer = layui.layer;
                    layui.layer.msg('确定选择', {
                        icon: 0
                        ,time: 0 //不自动关闭
                        ,btn: ['确定', '取消']
                        ,yes: function(index){
                            window.parent.setlatLng(lat,lng);
                            layer.close(index);
                            // 先得到当前iframe层的索引
                            var parentIndex = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(parentIndex);
                        }
                    });
                });
            });

        }

    </script>
</head>
<body onload="init()">
<div style="width:603px;" id="latLng"></div>
<div id="container"></div>

</body>
</html>
