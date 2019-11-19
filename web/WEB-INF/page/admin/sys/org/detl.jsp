<!-- 生成版本:1.1 -->
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>组织机构详情</title>
</head>
<body>
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>组织机构基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">组织代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="orgCode" value="${item['orgCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">组织名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="name" value="${item['name']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">上级组织代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="parentCode" value="${item['parentCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">备注说明</label>
                    <div class="layui-input-inline">
                        <input type="text" name="remark" value="${item['remark']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sortNum" value="${item['sortNum']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">是否隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" value="${(empty item)?'0':(item['isLock'])}" ${item['isLock'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="isLock" disabled>
                    </div>
                </div>
            </div>

        </form>
    <script>
        var form
        layui.use('form', function(){
            form = layui.form;
        });

    </script>
</body>
</html>
