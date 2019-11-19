<!-- 生成版本:1.1 -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统角色用户详情</title>
</head>
<body>
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">角色id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="roleId" value="${item['roleId']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">用户id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="userId" value="${item['userId']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        </form>
</body>
</html>
