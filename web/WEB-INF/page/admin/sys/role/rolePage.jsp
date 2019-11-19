<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="mc" uri="/mobi/tcloud/mcore" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>角色管理</title>
</head>
<body class="layui-layout-body">
<blockquote class="layui-elem-quote">
    <b>角色列表</b>
    <div>
        <a class="layui-btn layui-btn-primary" id="btnFresh">
            <i class="layui-icon layui-btn-search"><i class="fa fa-refresh" aria-hidden="true"></i></i>
        </a>
        <mc:Auto code="jsxz" tagName="button" attrEx=" class='layui-btn layui-btn-warm' id='btnAdd' type='button'"><i
                class="layui-icon"></i>新增</mc:Auto>
        <mc:Auto code="jsdr" tagName="button"
                 attrEx=" class='layui-btn layui-btn-warm' id='btnUpload' type='button'">导入</mc:Auto>
    </div>
</blockquote>
<div class="x-left">
    <form class="layui-form" action="${BASE}/exp/role/down">
        <div class="layui-input-inline">
            <input class="layui-input" name="keyword" autocomplete="off" placeholder="角色名称/角色编码">
        </div>
        <button class="layui-btn" id="module" lay-submit="" lay-filter="serch"><i class="layui-icon"></i></button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        <mc:Auto code="jsdc" tagName="button"
                 attrEx=" class='layui-btn layui-btn-primary' id='btnDown' lay-filter='btnExp'">导出</mc:Auto>
    </form>
    <table class="layui-table" id="dataList" lay-filter="dataList"></table>
    <script type="text/html" id="barDemo">
        <!--<a class="layui-icon i-right i-edit" lay-event="edit" title='编辑'>&#xe642;</a>-->
        {{#  if(d.STAT == "启用"){ }}
        <a class='layui-icon i-right i-del' lay-event='disable' title='禁用'>&#x1007;</a>
        {{#  } else { }}
        <a class='layui-icon i-right i-able' lay-event='able' title='启用'>&#x1005;</a>
        <mc:Auto code="m62" tagName="a"
                 attrEx=" class='layui-icon i-right i-able' lay-event='able' title='启用'">&#x1005;</mc:Auto>
        {{#  } }}
        <a class='layui-icon i-right i-edit' lay-event='edit' title='编辑'>&#xe642;</a>
        <c:if test="${sysUsrType!='1'}">
            <a class='layui-icon i-right i-edit' lay-event='role_wh' title='绑定功能'>&#xe620;</a>
        </c:if>
        <!--管理员-->
        <c:if test="${sysUsrType=='1'}">
            <a class='layui-icon i-right i-edit' lay-event='admin_role_wh' title='管理员绑定功能'>&#xe620;</a>
        </c:if>
        <a class='layui-icon i-right i-edit' lay-event='user_wh' title='绑定用户'>&#xe613;</a>

    </script>
    <script type="text/html" id="usrState">
        {{#  if(d.STAT == "启用"){ }}
        <span style="color:green;text-align: center">启用</span>
        {{#  } else { }}
        <span style="color:red;text-align: center">禁用</span>
        {{#  } }}
    </script>
</div>
<script>
    layui.use(['layedit', 'laydate', 'tree', 'table', 'form'], function () {
        var table = layui.table;
        var laydate = layui.laydate; //日期插件
        var form = layui.form;
        //刷新页面
        $('#btnFresh').on('click', function (e) {
            table.reload('dataList');
        });
        // 监听导出
        form.on('submit(btnExp)', function (data) {
            return true;
        })

        //选择所属系统
        form.on('submit(serch)', function (data) {
            table.reload('dataList', {method: "POST", where: data.field});
            return false;
        });
        function roleWhSubmit() {
            var frameId = document.getElementById('role_wh_form').getElementsByTagName("iframe")[0].id;
            $('#' + frameId)[0].contentWindow.mySubmit();
        }

        function roleEditSubmit() {
            var frameId = document.getElementById('role_edit_form').getElementsByTagName("iframe")[0].id;
            $('#' + frameId)[0].contentWindow.editSubmit();
        }

        function roleAddSubmit() {
            var frameId = document.getElementById('role_add_form').getElementsByTagName("iframe")[0].id;
            $('#' + frameId)[0].contentWindow.addRoleSubmit();
        }

        //监听工具条
        table.on('tool(dataList)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data //获得当前行数据
                , layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'detail') {
                layer.open({
                    title: '查看角色详情',
                    type: 2,
                    area: ['100%', '100vh'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/role/roleDetail?rid=' + data.RID
                });
            } else if (layEvent === 'del') {
                layer.confirm('确定删除该角色吗', function (index) {
                    $.ajax({
                        url: '${BASE}/func/role/delrole?rid=' + data.RID,
                        type: 'post',
                        dataType: 'json',
                        data: data.field,
                        success: function (data, status) {
                            if (data.err === 0) {
                                layer.msg("删除角色成功");
                                table.reload('dataList');
                            } else {
                                layer.msg("删除角色失败了...");
                                return false;
                            }
                        }, fail: function (err, status) {
                            layer.msg("发生错误了...");
                        }
                    });
                });
            } else if (layEvent === 'edit') {//编辑
                layer.open({
                    id: 'role_edit_form',
                    title: '编辑',
                    type: 2,
                    btn: ['保存', '关闭'],
                    area: ['700px', '450px'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/role/roleEdit?view=edit&id=' + data.RID,
                    yes: function () {
                        roleEditSubmit();
                    }, end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent === 'user_wh') {//用户维护
                layer.open({
                    title: '请选择用户',
                    type: 2,
                    area: ['1000px', '70%'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/role/userwh?rid=' + data.RID
                    , success: function () {
                    }, end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent === 'role_wh') {//绑定功能
                layer.open({
                    id: 'role_wh_form',
                    title: '请选择功能/接口',
                    type: 2,
                    btn: ['提交', '关闭'],
                    fixed: false, //不固定
                    area: ['60%', '85%'],
                    maxmin: true,
                    content: '${BASE}/page/role/rolewh?len=1&rid=' + data.RID,
                    yes: function (index, layero) {
                        roleWhSubmit();
                    }, end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent == 'admin_role_wh') {
                layer.open({
                    id: 'role_wh_form',
                    title: '请选择功能/接口',
                    type: 2,
                    btn: ['提交', '关闭'],
                    area: ['1020px', '700px'],
                    content: '${BASE}/page/role/adminrolewh?len=1&rid=' + data.RID,
                    yes: function (index, layero) {
                        roleWhSubmit();
                    }, end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent === 'able') {
                layer.confirm('确定要启用该角色吗？', function (index) {
                    $.ajax({
                        url: '${BASE}/func/role/enable?id=' + data.RID,
                        type: 'post',
                        dataType: 'json',
                        success: function (data, status) {
                            if (data.err == 'true') {
                                layer.msg("启用成功！");
                                table.reload('dataList');
                            } else {
                                layer.msg("启用失败！");
                                return false;
                            }
                        }, fail: function (err, status) {
                            layer.msg("系统错误了...");
                        }
                    });
                });
            } else if (layEvent === 'disable') {
                layer.confirm('确定要禁用该角色吗？', function (index) {
                    $.ajax({
                        url: '${BASE}/func/role/disable?id=' + data.RID,
                        type: 'post',
                        dataType: 'json',
                        success: function (data, status) {
                            if (data.err == 'true') {
                                layer.msg("禁用成功!");
                                table.reload('dataList');
                            } else {
                                layer.msg("禁用失败!");
                                return false;
                            }
                        }, fail: function (err, status) {
                            layer.msg("系统错误了...");
                        }
                    });
                });
            }
        });
        //新增
        $("#btnAdd").on("click", function () {
            layer.open({
                id: 'role_add_form',
                title: '新增角色',
                btn: ['提交', '关闭'],
                type: 2,
                area: ['900px', '470px'],
                fixed: false, //不固定
                maxmin: true,
                content: '${BASE}/page/role/roleEdit?view=add',
                yes: function (index, layero) {
                    roleAddSubmit();
                }, end: function () {
                    table.reload('dataList');
                }
            });
        });
        //绑定功能
        $("#bindFunc").on("click", function () {
            var ulist = '', len = 0, str = '';
            var sysUsrType = ${sysUsrType};
            var ckbox = table.checkStatus('dataList').data;
            len = ckbox.length;
            if (len == 0) {
                layer.msg("请选择角色");
                return false;
            }
            for (var i = 0; i < len; i++) {
                ulist += ckbox[i].RID + ",";
            }
            if (ulist) {
                ulist = ulist.substr(0, ulist.length - 1);
            }
            if (sysUsrType == 1) {//管理员
                if (len == 1) {
                    layer.open({
                        id: 'role_wh_form',
                        title: '请选择功能/接口',
                        type: 2,
                        btn: ['提交', '关闭'],
                        area: ['1020px', '700px'],
                        content: '${BASE}/page/role/adminrolewh?len=1&rid=' + ulist,
                        yes: function (index, layero) {
                            roleWhSubmit();
                        }, end: function () {
                            table.reload('dataList');
                        }
                    });
                } else {
                    layer.open({
                        id: 'role_wh_form',
                        title: '请选择功能/接口',
                        type: 2,
                        btn: ['提交', '关闭'],
                        area: ['1024px', '700px'],
                        content: '${BASE}/page/role/adminrolewhMore?rid=' + ulist + '&len=' + len,
                        yes: function (index, layero) {
                            roleWhSubmit();
                        }, end: function () {
                            table.reload('dataList');
                        }
                    });
                }
            } else {//其他角色

            }
        });
        //                绑定用户
        $("#bindUser").on("click", function () {
            var ulist = '', len = 0, str = '';
            var ckbox = table.checkStatus('dataList').data;
            len = ckbox.length;
            if (len == 0) {
                layer.msg("请选择角色");
                return false;
            }
            for (var i = 0; i < len; i++) {
                ulist += ckbox[i].RID + ",";
            }
            if (ulist) {
                ulist = ulist.substr(0, ulist.length - 1) + "";
            }
            if (len == 1) {
                layer.open({
                    id: 'one_user_form',
                    title: '请选择用户',
                    type: 2,
                    area: ['900px', '70%'],
                    content: '${BASE}/page/role/bindOne?rid=' + ulist
                });
            } else {
                layer.open({
                    id: 'more_user_form',
                    title: '请选择用户',
                    type: 2,
                    area: ['900px', '70%'],
                    content: "${BASE}/page/role/bindMore?rid='" + ulist + "'"
                });
            }

        });


        table.render({
            elem: '#dataList'
            , height: 'full-135'
            , url: '${BASE}/data/role/rolesList' //数据接口
            , page: true, //开启分页
            skin: 'line',
            size: 'sm'
            , cols: [[ //表头
                {field: 'RID', width: 60, title: '编号'},
                {field: 'RCODE', width: 100, title: '角色编码'},
                {field: 'RNAME', width: 100, title: '角色名称'},
                {field: 'REMARK', width: 100,title: '角色描述'},
                {field: 'UNUM', align: 'left', width: 120, title: '已授权用户数'},
                {field: 'FNUM', align: 'left', width: 120, title: '已拥有功能数'},
                {field: 'STAT', align: 'center', templet: '#usrState', width: 90, title: '状态'},
                {field: 'CREATOR', width: 80, title: '创建人'},
                {field: 'CDATE', width: 150, align: 'center', title: '创建时间'},
                {align: 'center', toolbar: '#barDemo', width: 200, title: '操作'}
            ]]
        });
    });
</script>
</body>
</html>
