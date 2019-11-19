<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>功能详情</title>
        <style>
            .inputtext{width: 95%}
            .formCls{margin: 30px 80px}
            .inlineCls{width: 40%}
            .labelCls{width: 25%}
            .layui-text em, .layui-word-aux {
                color: #444 !important;
            }
        </style>
    </head>
    <body> 
        <div class="layui-tab-item layui-show">
            <fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                <legend>基本信息</legend>
                <div class="layui-row">
                    <div class="layui-inline layui-col-lg6 ">
                        <label class="layui-form-label">产品：</label>
                        <div class="layui-form-mid layui-word-aux">${param.pname}</div>
                    </div>
                    <div class="layui-inline layui-col-lg6 ">
                        <label class="layui-form-label">类型：</label>
                        <div class="layui-form-mid layui-word-aux">${param.grade}</div>
                    </div>
                </div>
            </fieldset>
            <fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                <legend>已授权角色</legend>
                ${param.role}
            </fieldset> 
        </div>
    </body>
</html>
