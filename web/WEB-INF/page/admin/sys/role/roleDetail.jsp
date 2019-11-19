<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>角色详情</title>
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
        <c:set var="base" value="${requestScope['@DATA']}"></c:set>
            <div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
                <ul class="layui-tab-title">
                    <li class="layui-this">基本信息</li>
                    <li>功能信息</li>
                </ul>
                <div class="layui-tab-content" style="height: 100px;">
                    <div class="layui-tab-item layui-show">
                        <fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                            <legend>基本信息</legend>
                            <div class="layui-row">
                                <div class="layui-inline layui-col-lg6 ">
                                    <label class="layui-form-label">角色名称：</label>
                                    <div class="layui-form-mid layui-word-aux">${base['RNAME']}</div>
                            </div>
                            <div class="layui-inline layui-col-lg6 ">
                                <label class="layui-form-label">角色编码：</label>
                                <div class="layui-form-mid layui-word-aux">${base['RCODE']}</div>
                            </div>
                        </div>
                        <div class="layui-row">
                            <div class="layui-inline layui-col-lg6 ">
                                <label class="layui-form-label">状态：</label>
                                <div class="layui-form-mid layui-word-aux">${base['STAT']}</div>
                            </div>
                            <div class="layui-inline layui-col-lg6 ">
                                <label class="layui-form-label">角色说明：</label>
                                <div class="layui-form-mid layui-word-aux">${base['REMARK']}</div>
                            </div>
                        </div>
                    </fieldset>
                    <fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                        <legend>授权用户</legend>
                        <c:forEach var="user" items="${requestScope['@loadUser']}">
                            <div class="layui-collapse" lay-accordion="" style="margin-bottom:20px">
                                <div class="layui-colla-item">
                                    <h2 class="layui-colla-title">${user['VNAME']}</h2>
                                    <div class="layui-colla-content layui-show">
                                        ${user['ULIST']}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </fieldset> 
                </div>
                <div class="layui-tab-item"><fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                        <legend>授权功能</legend>
                        <c:if test="${not empty requestScope['@funclist']}">
                            <table class="layui-table" style="color:#141414">
                                <thead>
                                    <tr>
                                        <th style="width:25%;text-align: center;">产品</th>
                                        <th style="width:75%;text-align: center;">功能</th>
                                    </tr> 
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${requestScope['@funclist']}">
                                        <tr>
                                            <td>${item['MNAME']}</td>
                                            <td>
                                                <c:forEach var="it" items="${item['GDATA']}">
                                                    ${it['NAME']}、
                                                </c:forEach>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </fieldset>
                    <fieldset class="layui-elem-field site-demo-button" style="margin: 30px;padding: 30px">
                        <legend>授权接口</legend>
                        <c:set var="inter" value="${requestScope['@interlist']}"></c:set>
                        ${inter['FNAME']}
                    </fieldset>
                </div>
            </div>
        </div>
        <script>
            layui.use(['element', 'form', 'layedit', 'laydate'], function () {
                var form = layui.form;
                var element = layui.element;
                var layer = layui.layer;
            });
        </script>
    </body>
</html>
