<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统角色详情</title>
</head>
<body>
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">角色名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="roleName" value="${item['roleName']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">公司id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="comId" value="${item['comId']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">是否隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" ${item['isLock'] == '1'?'checked':''}  value="${item['isLock']}" lay-skin="switch" disabled="disabled" lay-text="是|否"  lay-filter="isLock">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">备注</label>
                    <div class="layui-input-inline">
                        <input type="text" name="remark" value="${item['remark']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
        </form>
</body>
<script>
    layui.use('form', function(){
        var form = layui.form;
    });
</script>
</html>
