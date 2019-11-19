<!--
Author: tangshuai
-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>旅游平台</title>
    <link rel="stylesheet" href="${BASE}/layui/v2.4/css/layui.css" media="all"/>
    <link rel="stylesheet" href="${BASE}/statics/plugins/font-awesome/css/font-awesome.min.css" media="all"/>
    <link rel="stylesheet" href="${BASE}/statics/src/css/app.css" media="all"/>
    <link rel="stylesheet" href="${BASE}/statics/src/css/nprogress.css" media="all"/>
    <link rel="stylesheet" href="${BASE}/statics/src/css/message.css" media="all"/>
    <link rel="stylesheet" href="${BASE}/css/index/index.css" media="all"/>
    <link rel="icon" href="${BASE}/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="${BASE}/favicon.ico" type="image/x-icon">
    <script src="${BASE}/layui/v2.4/layui.js"></script>
    <script src="${BASE}/js/common/jquery-3.2.1.min.js"></script>
    <style>
        .layui-nav .layui-nav-child a:hover {
            background-color: #e1edfa;
            border-left: 2px solid #008afe;
        }
    </style>
</head>
<body class="kit-theme">
<div class="layui-layout layui-layout-admin kit-layout-admin" style="min-width: 1420px;">
    <div class="layui-header">
        <div class="layui-logo"><h3><strong>旅游平台</strong></h3></div>
        <div class="layui-header-right">
            <ul id="oneLevel" class="layui-nav  kit-nav" lay-filter="kitOneLevel">
            </ul>
            <ul class="layui-nav   kit-nav">
                <li class="layui-nav-item" style="right:12px;">
                    <a href="javascript:;">
                        <img src="${BASE}/statics/img/0.jpg" class="layui-nav-img"> ${sysUsrName}
                    </a>
                    <dl class="layui-nav-child" style="background-color:#23b7e5">
                        <%--<dd>
                            <a href="javascript:void(0);" kit-target id="basic"
                               data-options="{url:'${BASE}/page/login/basicMsg',icon:'&#xe658;',title:'基本资料',id:'966'}">
                                <span style="color:#fff;">基本资料</span>
                            </a>
                        </dd>--%>
                        <dd>
                            <a id="loginOut" style="color:#fff;"><i class="fa fa-sign-out" aria-hidden="true"></i>
                                退出</a>
                        </dd>
                    </dl>
                </li>
                <%--<li class="layui-nav-item">--%>
                <%--<a id="loginOut"><i class="fa fa-sign-out" aria-hidden="true"></i> 退出</a>--%>
                <%--</li>--%>
            </ul>
        </div>

    </div>

    <div class="layui-side layui-bg-black kit-side">
        <div class="layui-side-scroll">
            <div class="kit-side-fold"><i class="fa fa-navicon" aria-hidden="true"></i></div>
            <ul class="layui-nav layui-nav-tree" lay-filter="kitNavbar" kit-navbar>
            </ul>
        </div>
    </div>
    <iframe class="layui-body" id="container" style="width: 100%;border:0;">
        <div style="padding: 15px;"><i class="layui-icon layui-anim layui-anim-rotate layui-anim-loop">&#xe63e;</i>
            请稍等...
        </div>
    </iframe>

    <!--            <div class="layui-footer">
                    <div style="text-align: center">© 东华发思特科技有限公司</div>
                </div>-->
</div>
<script>
    var message;
    localStorage.setItem("storageToken", '${sysToken}');
    sessionStorage.setItem('$BASE', "${BASE}");
    localStorage.defimgservice="${sysconfig.defimgservice}";
    <c:if test="${not empty sysUsrName}">
        layui.config({
            base: '${BASE}/statics/src/js/',
            version: ''
        }).use(['app', 'message'], function () {
            var app = layui.app,
                $ = layui.jquery,
                layer = layui.layer;
            //将message设置为全局以便子页面调用
            message = layui.message;
            //主入口
            app.set({
                type: 'iframe'
            }).init();
        });
    </c:if>
    <c:if test="${empty sysUsrName}">
         window.location.href = "${BASE}/page/login/loginPage";
    </c:if>

    $("#loginOut").on("click", function (e) {
        var sysLoginType = '${sysLoginType}';
        if(sysLoginType=="0"){//系统登录，需要调用认证退出接口
            var storageToken = localStorage.getItem("storageToken");
            $.post("${BASE}/func/login/logout?utoken="+storageToken, function (resp) {
                window.location.href = "${BASE}/page/login/loginPage";
            }, "json");
        }else{//单点退出，无需要调用认证退出接口
            $.post("${BASE}/func/login/loginOutClzz", function (resp) {
                window.location.href = "${BASE}/page/login/loginPage";
            }, "json");
        };
    });
    $(window).on("resize", function () {
        $("#container").height($(window).height() - 60).width($(window).width() - $(".layui-side-scroll").width() - 20);
    });
    $(document).ready(function () {
        $("#container").height($(window).height() - 60).width($(window).width() - $(".layui-side-scroll").width() - 20);
    });
</script>
</body>
</html>