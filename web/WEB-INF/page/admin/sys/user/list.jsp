<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="mc" uri="/mobi/tcloud/mcore" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title></title>
</head>
<body class="layui-layout-body">
    <blockquote class="layui-elem-quote">
        <b>用户列表</b>
        <div>
            <a class="layui-btn layui-btn-primary"  id="btnFresh">
                <i class="layui-icon layui-btn-search" ><i class="fa fa-refresh" aria-hidden="true"></i></i>
            </a>
            <mc:Auto code="yhxz" tagName="button"  attrEx=" class='layui-btn layui-btn-warm' id='btnAdd' type='button'"><i class="layui-icon"></i>新增</mc:Auto>
            <mc:Auto code="yhdr" tagName="button"  attrEx=" class='layui-btn layui-btn-warm' id='btnUpload' type='button'">导入</mc:Auto>

        </div>
    </blockquote>
    <div class="x-left">
        <!-- 内容主体区域 -->
        <form class="layui-form" name="listForms" action="${BASE}/exp/user/down" id="listForms">
            <div class="layui-input-inline">
                <input type="text" name="params" id="keyWord" autocomplete="off" class="layui-input" placeholder="关键词">
            </div>
             <button class="layui-btn" lay-submit="" lay-filter="btnSearch" id="btnSearch"><i class="layui-icon"></i></button>
            <button id="btnReset" class="layui-btn layui-btn-primary" type="button">重置</button>
            <mc:Auto code="yhdc" tagName="button"  attrEx=" class='layui-btn layui-btn-primary' id='btnDown' lay-filter='btnExp'">导出</mc:Auto>
        </form>
        <table class="layui-table" id="dataList" lay-filter="dataList">
        </table>
        <script type="text/html" id="dataFormTab">
            <a class="layui-icon i-right i-edit" lay-event="view" title='查看'>
                <i class="fa fa-file-text-o" aria-hidden="true"></i>
            </a>
            <a class='layui-icon i-right i-edit' lay-event='edit' title='编辑'>&#xe642;</a>
            <mc:Auto code="yhsc" tagName="a"  attrEx=" class='layui-icon i-right i-edit' style='color:red' lay-event='del' title='删除'">
                <i class="fa fa-minus-circle" aria-hidden="true"></i></mc:Auto>
        </script>
    </div>
</body>
<script>
    layui.use(['layedit', 'laydate', 'tree', 'table', 'form'], function () {
        var table = layui.table;
        var form = layui.form;    
    
        $('#btnReset').on('click', function (e) {
            $("input[name='params']").val('');
            $('#keyword').val('');
            $('#btnSearch').click();
        });
        //监听工具条
        table.on('tool(dataList)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data, layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'view') {
                layer.open({
                    title: '查看详情',
                    type: 2,
                    area: ['900px', '570px'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/user/view?uid=' + data.uid
                });
            } else if (layEvent === 'edit') {
                layer.open({
                    id: 'add_form',
                    name: 'haha',
                    title: '编辑信息',
                    btn: ['保存', '关闭'],
                    type: 2,
                    area: ['900px', '520px'],
                    content: '${BASE}/page/user/edit?uid=' + data.uid,
                    yes: function () {
                        userAddSubmit();
                    },end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent === 'del') {
                layer.confirm('确认删除记录?', {
                    btn: ['确认', '取消'] //按钮
                }, function () {
                    $.post('${BASE}/func/user/del?uid=' + data.uid, function (e) {
                        if (e.err == 'true') {
                            layer.msg('删除成功');
                            table.reload('dataList', {
                                page: {curr: 1}
                            });
                        } else {
                            layer.msg('删除失败');
                            return false;
                        }
                    });
                }, function () {});
            }
        });
        function userAddSubmit() {
            var frameId = document.getElementById('add_form').getElementsByTagName('iframe')[0].id;
            $('#' + frameId)[0].contentWindow._usrAddSubmit();
        }
        $('#btnAdd').on('click', function () {
            layer.open({
                id: 'add_form',
                name: 'haha',
                title: '新增',
                btn: ['保存', '关闭'],
                type: 2,
                area: ['900px', '75%'],
                content: '${BASE}/page/user/add',
                yes: function () {
                    userAddSubmit();
                },end: function () {
                    table.reload('dataList');
                }
            });
        });
        $('#btnSave').on('click', function (e) {

        });
        $('#btnUpload').on('click', function (e) {

        });
        // 监听导出
        form.on('submit(btnExp)', function (data) {
            return true;
        })
        //刷新页面
        $('#btnFresh').on('click', function (e) {
            table.reload('dataList');
        });
        //渲染table
        table.render({
            method: 'post',
            limit: 15,
            elem: '#dataList',
            height: 'full-120',
            url: '${BASE}/data/user/dl', //数据接口
            page: true,//开启分页
            skin:'line',
            size:'sm',
            cols: [
                    [ //表头

                        {field: 'orgName', title: '组织机构', sort: true }
                        ,{field: 'stype', title: '角色类型', sort: true }
                        ,{field: 'userid', title: '登录账号', sort: true }
                        ,{field: 'uname', title: '用户名称', sort: true }
                        ,{field: 'rname', title: '真实姓名', sort: true }
                        ,{field: 'tel', title: '电话', sort: true }
                        ,{field: 'email', title: '电子邮箱', sort: true }
                        ,{field: 'address', title: '地址', sort: true }
                        ,{field: 'stat', title: '是否启用', sort: true, align: 'center' }
                        ,{field: 'qq', title: 'qq', sort: true }
                        ,{field: 'wechat', title: '微信', sort: true }
                        ,{fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#dataFormTab'}
                    ]
                ]
            });

        //监听搜索框事件
        form.on('submit(btnSearch)', function (data) {
            var params = $.trim(data.field.params);
            table.reload('dataList', {
                method: 'POST', where: {
                    'params': params
                }
            });
            return false;
        });
    });
</script>
</html>
