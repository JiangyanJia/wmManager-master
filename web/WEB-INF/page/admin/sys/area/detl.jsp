<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>行政区域详情</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>行政区域基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">区域代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="areaCode" value="${item['areaCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">区域名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="areaName" value="${item['areaName']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <%--<div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label labelCls">所属区域代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="parentCode" value="${item['parentCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>--%>
            <input type="hidden" name="parentCode" value="${item['parentCode']}" disabled="disabled" autocomplete="off" class="layui-input">

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">所属区域名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="parentName" value="${item['parentName']!=null?item['parentName']:'无所属区域名称'}" disabled="disabled" autocomplete="off" class="layui-input">
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
                    <label class="layui-form-label labelCls">等级</label>
                    <div class="layui-input-block">
                        <%--<input type="text" name="lvl" value="${item['lvl']}" disabled="disabled" autocomplete="off" class="layui-input">--%>
                        <c:forEach items="${requestScope['@gradeList']}" var="rs" varStatus="status">
                            <%--<input type="checkbox" name="actionType" title="${rs.prmValue}" value="${rs.prmKey}">--%>
                            <input type="radio" name="lvl" value="${rs.prmKey}" title="${rs.prmValue}" ${(rs.prmKey==item['lvl'])?'checked':''}>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">邮政编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="postCode" value="${item['postCode']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">经度</label>
                    <div class="layui-input-inline">
                        <input type="text" name="lng" value="${item['lng']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">纬度</label>
                    <div class="layui-input-inline">
                        <input type="text" name="lat" value="${item['lat']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" ${item['isLock'] == '1'?'checked':''}  value="${item['isLock']}" lay-skin="switch" disabled="disabled" lay-text="是|否"  lay-filter="isLock">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否隐藏，隐藏不允许使用</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">备注说明</label>
                    <div class="layui-input-block">
                    <textarea name="remark" value="${item['remark']}" placeholder="请输入备注说明" disabled class="layui-textarea"
                              autocomplete="off" class="layui-input" maxlength="255"></textarea>
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
