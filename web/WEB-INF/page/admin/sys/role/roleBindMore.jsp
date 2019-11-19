<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>用户维护</title>
        <style>
            .layui-checkbox-disbaled .layui-disabled{}
        </style>
    </head>
    <body>
        <div class="x-left">
            <form class="layui-form" action="${BASE}/exp/user/save">
                <div class="layui-input-inline">
                    <input class="layui-input" name="keyword" id="keyword" autocomplete="off" placeholder="用户名">
                </div>
                <button class="layui-btn" id="module"  lay-submit="" lay-filter="serch"><i class="layui-icon"></i></button>
                <button type="reset"  class="layui-btn layui-btn-primary" >重置</button>
                <button class="layui-btn layui-btn-normal"  id="userwh" type='button'>授权</button>
            </form>
            <table class="layui-table" id="userList" lay-data="{url:'${BASE}/data/role/bindMoreList?rid='+${param.rid},height: 'full-120', cellMinWidth: 80, page: true}"  lay-filter="userList">
                <thead>
                    <tr>
                        <th lay-data="{type:'checkbox'}"></th>
                        <th lay-data="{field:'uname'}">账号2</th>
                        <th lay-data="{field:'rname'}">真实姓名</th>
                        <th lay-data="{field:'vpath'}">所属机构</th>
                        <th lay-data="{field:'stype'}">类型</th>
                        <th lay-data="{field:'lst_date'}">最近登录时间</th>
                    </tr>
                </thead>
            </table>
        </div>
        <script>
            layui.use(['laydate', 'table', 'form'], function () {
                var table = layui.table;
                var laydate = layui.laydate; //日期插件
                var form = layui.form;
                //多条件搜索
                form.on('submit(serch)', function (data) {
                    data.field.keyword = $.trim(data.field.keyword);
                    table.reload('userList', {method: "POST", where: data.field});
                    return false;
                });
                $("#userwh").on("click", function (e) {
                    var ulist = '', len = 0;
                    var ckbox = table.checkStatus('userList').data;
                    len = ckbox.length;
                    if (len == 0) {
                        layer.msg("请选择授权用户");
                        return false;
                    }
                    for (var i = 0; i < len; i++) {
                        ulist += ckbox[i].uid + ",";
                    }
                    if (ulist) {
                        ulist = ulist.substr(0, ulist.length - 1);
                    }
                    $.post("${BASE}/func/role/instMoreRole?rid=${param.rid}&ulist=" + ulist, function (resp) {
                        if (resp.err == 0) {
                            layer.msg("修改用户角色授权成功");
                            setTimeout(function () {

                                parent.layer.close(parent.layer.getFrameIndex(window.name));
                            }, 2000);
                        } else {
                            layer.msg("修改用户角色授权失败");
                            return false;
                        }
                    }, "json");
                });
            });
        </script>
    </body>
</html>
