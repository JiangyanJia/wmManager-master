<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <script src="${BASE}/js/dtree/dtree.js"></script>
    <link href="${BASE}/js/dtree/dtree.css" rel="stylesheet"/>
    <title>行政区域选择</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="add">

        <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>

        <%--加载dtree--%>
        <div class="dtree" id="dtree" style="width:180px; height: 55%;margin-left: 20px;margin-top: 20px;">

        </div>

    </form>
</div>
</body>
    <script>
        var form;
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form'], function () {
            form = layui.form;

        });
        function closeFram() {
            parent.layer.close(index);
        }

        //保存方法
        function _usrAddSubmit() {
            $('#btnSave').click();
            return false;
        }

        function myOnClient(id, name) {
            window.parent.setvalue(id,name);
            parent.layer.close(index);
        }

        $(function(){
          selectdiaog();
        });

        function selectdiaog(){

            //使用ajax按需要加载
            d = new dTree('d'); //实例化
            d.config.ajaxTree = true; //是否AJAX按需要加载
            d.config.check = false; //是否带复选框
            d.config.useCookies = false; //是否使用Cookies保存状态
            d.config.renderTo = 'dtree'; //树输出DIV的ID，前面加
            d.config.ajaxUrl = '${BASE}/gateway/get_area_list'; //ajax后台处理页面
            d.config.treetype = 'get_area_by_pcode'; //树类型，主要考虑共用一个页面实现多个功能，通过此加以区分

            //d.add('0', '-1', '区域信息');  //添加根节点
            //d.add('0', '0', '区域信息');  //添加根节点
            //$(d.getData('-1')); //页面加载时调用
            d.add(510000, '-1', '四川省',"javascript:myOnClient('510000','四川省')");  //添加根节点
            $(d.getData1('510000','-1', '四川省')); //页面加载时调用


        }


    </script>

    <%@include file="/WEB-INF/jspf/footer.jspf" %>
</html>
