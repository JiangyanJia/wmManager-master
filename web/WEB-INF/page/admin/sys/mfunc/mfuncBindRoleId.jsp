<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>功能角色授权</title>
        <style>
            .layui-checkbox-disbaled .layui-disabled{}
        </style>
    </head>
    <body>
        <div class="x-left">
            <form class="layui-form" action="${BASE}/exp/user/save">
                <div class="layui-input-inline">
                    <input class="layui-input" name="keyword" id="keyword" autocomplete="off" placeholder="角色名称">
                </div>
                <button class="layui-btn" id="module"  lay-submit="" lay-filter="serch"><i class="layui-icon"></i></button>
                <button type="reset"  class="layui-btn layui-btn-primary" >重置</button>
                <button class="layui-btn layui-btn-normal"  id="userwh" type='button'>绑定</button>
            </form>
            <table class="layui-table" id="bindList" lay-data="{url:'${BASE}/data/mfunc/mfuncBindRoleIdlist?iid=${param.iid}&fid=${param.fid}&pid=${param.pid}',height: 'full-120', cellMinWidth: 80, page: true}"  lay-filter="bindList">
                <thead>
                    <tr>
                        <th lay-data="{type:'checkbox'}"></th>
                        <th lay-data="{field:'RCODE',width:100}">角色编码</th>
                        <th lay-data="{field:'RNAME'}">角色名称</th>
                        <!--<th lay-data="{field:'VPATH'}">所属机构</th>-->
                        <th lay-data="{field:'REMARK'}">角色说明</th>
                        <th lay-data="{field:'CDATE'}">创建时间</th>
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
                    var ckbox = table.checkStatus('bindList').data;
                    len = ckbox.length;
                    if (len == 0) {
                        layer.msg("请选择绑定的角色");
                        return false;
                    }
                    for (var i = 0; i < len; i++) {
                        ulist += ckbox[i].RID + ",";
                    }
                    if (ulist) {
                        ulist = ulist.substr(0, ulist.length - 1);
                    }
                    $.post("${BASE}/func/mfunc/bindRole?iid=${param.iid}&fid=${param.fid}&pid=${param.pid}&rid=" + ulist, function (resp) {
                        if (resp.err == 0) {
                            layer.msg("绑定角色成功");
                            setTimeout(function () {
                                window.parent.location.reload(); //刷新父页面
                                parent.layer.close(parent.layer.getFrameIndex(window.name));
                            }, 2000);
                        } else {
                            layer.msg("绑定角色失败");
                            return false;
                        }
                    }, "json");
                });
            });
        </script>
    </body>
</html>
