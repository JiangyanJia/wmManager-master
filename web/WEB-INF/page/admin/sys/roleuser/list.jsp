<%--
  Created by IntelliJ IDEA.
  User: Winner
  Date: 2018/8/8
  Time: 11:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body class="layui-layout-body">
<blockquote class="layui-elem-quote">
    <b>角色信息列表</b>
    <div>
        <a class="layui-btn layui-btn-primary"  id="btnFresh">
            <i class="layui-icon layui-btn-search" ><i class="fa fa-refresh" aria-hidden="true"></i></i>
        </a>
        <button class="layui-btn layui-btn-warm" id='btnAdd' type="button"><i class="layui-icon"></i>新增</button>
    </div>
</blockquote>

<div class="x-left">
    <!-- 内容主体区域 -->
    <form class="layui-form" name="listForms" id="listForms">
        <div class="layui-input-inline">
            <input type="text" name="keyWord" id="keyWord" autocomplete="off" class="layui-input" placeholder="关键词">
        </div>
         <button class="layui-btn" lay-submit="" lay-filter="btnSearch" id="btnSearch"><i class="layui-icon"></i></button>
        <button id="btnReset" class="layui-btn layui-btn-primary" type="button">重置</button>
        <button id="btnDown" class="layui-btn layui-btn-primary" lay-filter="btnExp" lay-submit=''>导出</button>
    </form>
    <table id="dataList" lay-filter="dataList">
    </table>
    <script type="text/html" id="dataFormTab">
        <a class="layui-icon i-right i-edit" lay-event="view" title='查看'>
            <i class="fa fa-file-text-o" aria-hidden="true"></i>
        </a>
        <a class='layui-icon i-right i-edit' lay-event='edit' title='编辑'>&#xe642;</a>
        <a class='layui-icon i-right i-del'  lay-event='del' id='btnDel' title='删除'> <i class="fa fa-minus-circle" aria-hidden="true"></i></a>
    </script>
</div>
<script>
    layui.use(['layedit', 'laydate', 'tree', 'table', 'form'], function () {
        var table = layui.table;
        var form = layui.form;

        $('#btnReset').on('click', function (e) {
            $('#keyWord').val('');
            console.log($('#keyWord').val(''))
            $('#btnSearch').click();
            console.log($('#keyWord').val(''))
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
                    content: '${BASE}/page/sysroleuser/view?userId=' + data.userId
                });
            } else if (layEvent === 'edit') {
                layer.open({
                    id: 'add_form',
                    name: 'haha',
                    title: '编辑信息',
                    btn: ['保存', '关闭'],
                    type: 2,
                    area: ['900px', '520px'],
                    content: '${BASE}/page/sysroleuser/edit?userId=' + data.userId,
                    yes: function () {
                        userAddSubmit();
                    }
                });
            } else if (layEvent === 'del') {
                layer.confirm('确认删除记录?', {
                    btn: ['确认', '取消'] //按钮
                }, function () {
                    $.post('${BASE}/func/sysroleuser/del?id=' + data.userId, function (e) {
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
                }, function () {
                });
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
                content: '${BASE}/page/sysroleuser/add',
                yes: function () {
                    userAddSubmit();
                }
            });
        });
        $('#btnSave').on('click', function (e) {

        });
        $('#btnUpload').on('click', function (e) {

        });
        $('#btnDown').on('click', function (e) {

        });
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
            url: '${BASE}/data/sysroleuser/dl', //数据接口
            page: true,//开启分页
            skin:'line',
            size:'sm',
            cols: [
                [ //表头

                    {
                    field: 'roleId',
                    title: '角色',
                    //width: 80
                }, {
                    field: 'userId',
                    title: '用户',
                    //width: 80,
                    sort: true
                }, {
                    field: 'addUser',
                    title: '创建用户',
                    //width: 80
                }, {
                    field: 'addTime',
                    title: '创建时间',
                    //width: 177
                },
                    {
                        fixed: 'right',
                        title: '操作',
                        width: 180,
                        align: 'center',
                        toolbar: '#dataFormTab'
                    }
                ]
            ]
        });

        form.on('submit(btnSearch)', function (data) {
            var keyWrods = $.trim(data.field.keyWord);
            table.reload('dataList', {
                method: 'POST', where: {
                    'params': keyWrods
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
