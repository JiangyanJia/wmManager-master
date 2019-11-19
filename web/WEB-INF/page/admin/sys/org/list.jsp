<%--
  Created by IntelliJ IDEA.
  User: Winner
  Date: 2018/8/8
  Time: 11:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="mc" uri="/mobi/tcloud/mcore" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>组织机构信息列表</title>
</head>
<body class="layui-layout-body">
<blockquote class="layui-elem-quote">
    <b>组织机构信息列表</b>
    <div>
        <a class="layui-btn layui-btn-primary" id="btnFresh">
            <i class="layui-icon layui-btn-search"><i class="fa fa-refresh" style="line-height:28px;"
                                                      aria-hidden="true"></i></i>
        </a>
        <mc:Auto code="bmxz" tagName="button" attrEx=" class='layui-btn layui-btn-warm' id='btnAdd' type='button'"><i
                class="layui-icon"></i>新增</mc:Auto>

    </div>
</blockquote>

<div class="x-left">
    <!-- 内容主体区域 -->

    <form class="layui-form" name="listForms" id="listForms" action="${BASE}/exp/sysorg/down">
        <div class="layui-input-inline">
            <input type="text" name="keyWord" id="keyWord" autocomplete="off" class="layui-input" placeholder="关键词">
        </div>
        <button class="layui-btn" lay-submit="" lay-filter="btnSearch" id="btnSearch"><i class="layui-icon"></i>
        </button>
        <button id="btnReset" class="layui-btn layui-btn-primary" type="button">重置</button>
    </form>

    <table id="dataList" lay-filter="dataList">
    </table>
    <script type="text/html" id="dataFormTab">
        <a class="layui-icon i-right i-edit" lay-event="view" title='查看'>
            <i class="fa fa-file-text-o" aria-hidden="true"></i>
        </a>
        <a class='layui-icon i-right i-edit' lay-event='edit' title='编辑'>&#xe642;</a>
        <mc:Auto code="bmsc" tagName="a"
                 attrEx=" class='layui-icon i-right i-edit' style='color:red' lay-event='del' title='删除'">
            <i class="fa fa-minus-circle" aria-hidden="true"></i></mc:Auto>
    </script>

    <script type="text/html" id="typeNameTpl">

        {{#  if(d.scenicName == undefined){ }}
            {{d.typeName}}
        {{#  } else { }}
            {{d.typeName}}({{(d.scenicName)}})
        {{#  } }}
    </script>
</div>
<script>
    layui.use(['layedit', 'laydate', 'tree', 'table', 'form'], function () {
        var table = layui.table;
        var form = layui.form;

        $('#btnReset').on('click', function (e) {
            $('#keyWord').val('');
            $('#btnSearch').click();
        });
        //监听工具条
        table.on('tool(dataList)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var data = obj.data, layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'view') {
                layer.open({
                    title: '查看详情',
                    type: 2,
                    area: ['800px', '500px'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/sysorg/view?id=' + data.id
                });
            } else if (layEvent === 'edit') {
                layer.open({
                    id: 'add_form',
                    name: 'haha',
                    title: '编辑信息',
                    btn: ['保存', '关闭'],
                    type: 2,
                    area: ['800px', '570px'],
                    fixed: false, //不固定
                    maxmin: true,
                    content: '${BASE}/page/sysorg/edit?id=' + data.id,
                    yes: function () {
                        userAddSubmit();
                    }, end: function () {
                        table.reload('dataList');
                    }
                });
            } else if (layEvent === 'del') {
                layer.confirm('确认删除记录?', {
                    btn: ['确认', '取消'] //按钮
                }, function () {
                    $.post('${BASE}/func/sysorg/del?id=' + data.id, function (e) {
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
                area: ['800px', '570px'],
                fixed: false, //不固定
                maxmin: true,
                content: '${BASE}/page/sysorg/add',
                yes: function () {
                    userAddSubmit();
                }, end: function () {
                    table.reload('dataList');
                }
            });
        });
        $('#btnSave').on('click', function (e) {

        });
        $('#btnUpload').on('click', function (e) {

        });
        $('#btnDown').on('click', function () {
            $.post({
                url: '${BASE}/exp/sysorg/down',
                success: function (data, status) {
                }
            })
        });

        // 监听导出
        form.on('submit(btnExp)', function (data) {
            return true;
        })
        //刷新页面
        $('#btnFresh').on('click', function (e) {
            table.reload('dataList');
        });


        table.render({
            method: 'post',
            limit: 15,
            elem: '#dataList',
            height: 'full-140',
            url: '${BASE}/data/sysorg/dl', //数据接口
            page: true,//开启分页
            skin: 'line',
            size: 'sm',
            cols: [
                [
                    {
                        field: 'orgCode',
                        title: '组织代码',
                        // width:80,
                    },
                    {
                        field: 'name',
                        title: '组织名称',
                        // width:180,
                    },
                    {
                        field: 'parentCodeName',
                        title: '上级组织名称',
                        // width:150,
                    },
                    /*{
                        field: 'typeName',
                        title: '机构类型名称',
                        width:180,
                    },
                    {
                        field: 'areaName',
                        title: '区域名称',
                        width:150,
                    },
                    {
                        // field: 'typeName',
                        title: '级别',
                        templet: '#typeNameTpl',
                    },*/
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
                    'key': keyWrods
                }
            });
            return false;
        });
    });
</script>
</body>
</html>
