<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统参数详情</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>系统参数基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">参数key</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmKey" value="${item['prmKey']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">显示值</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmValue" value="${item['prmValue']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">类别代码</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmCode" value="${item['prmCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sortNum" value="${item['sortNum']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字越小越向前</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="islock" ${item['islock'] == '1'?'checked':''}  value="${item['islock']}" lay-skin="switch" disabled="disabled" lay-text="是|否"  lay-filter="islock">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否隐藏，隐藏不允许使用</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">系统参数</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isSys" ${item['isSys'] == '1'?'checked':''}  value="${item['isSys']}" lay-skin="switch" disabled="disabled" lay-text="是|否"  lay-filter="isSys">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否系统参数，系统不允许编辑</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">描述</label>
                    <div class="layui-input-block">
                        <textarea name="prmDesc" disabled="disabled" placeholder="请输入描述" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255">${item['prmDesc']}</textarea>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">备注</label>
                    <div class="layui-input-block">
                        <textarea name="remark" disabled="disabled" placeholder="请输入备注" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255">${item['remark']}</textarea>
                    </div>
                </div>
            </div>
        </form>
</div>
</body>
<script>
    layui.use('form', function(){
        var form = layui.form;
    });
</script>
</html>
