<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
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
        <b>系统用户授权</b>
        <div>
            <a class="layui-btn layui-btn-primary"  id="btnFresh">
                <i class="layui-icon layui-btn-search" ><i class="fa fa-refresh" aria-hidden="true"></i></i>
            </a>
        </div>
    </blockquote>
    <div class="x-left">
        <!-- 内容主体区域 -->
        <form class="layui-form" name="listForms" action="#" id="listForms">
            <div class="layui-input-inline">
                <input type="text" name="params" id="keyWord" autocomplete="off" class="layui-input" placeholder="关键词">
            </div>
             <button class="layui-btn" lay-submit="" lay-filter="btnSearch" id="btnSearch"><i class="layui-icon"></i></button>
            <button id="btnReset" class="layui-btn layui-btn-primary" type="button">重置</button>
        </form>
        <table class="layui-table" id="dataList" lay-filter="dataList">
        </table>
        <script type="text/html" id="dataFormTab">
            <%--<a class="layui-icon i-right" lay-event="view" title='查看'>&#xe63c;</a>--%>
            <a class="layui-icon i-right" style="color: #23b7e5;" lay-event="role" title='授权'><i class="fa fa-cog" aria-hidden="true"></i></a>
        </script>
        <script type="text/html" id="isTypeTab">
            {{#  if(d.isType == '1'){ }}
                是
            {{# } else if(d.isType == '0' && d.power=='-1'){ }}
                否
            {{#  } else { }}<%--isType：0、power：0--%>
                未授权
            {{#  } }}
        </script>
    </div>
</body>
<script>
    layui.use(['layedit', 'laydate', 'tree', 'table', 'form'], function () {
        var table = layui.table;
        var form = layui.form;    
    
        $('#btnReset').on('click', function (e) {
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
                    content: '${BASE}/page/sysfunction/view?ID=' + data.ID
                });
            } else if (layEvent === 'role') {
                layer.open({
                    id: 'add_form',
                    name: 'haha',
                    title: '授权',
                    btn: ['保存', '关闭'],
                    type: 2,
                    area: ['600px', '80%'],
                    content: '${BASE}/page/authuser/editAuthuser?id=' + data.id,
                    yes: function () {
                        userAddSubmit();
                    }
                });
            }
        });
        function userAddSubmit() {
            var frameId = document.getElementById('add_form').getElementsByTagName('iframe')[0].id;
            $('#' + frameId)[0].contentWindow._usrAddSubmit();
        }
        // 监听导出
        form.on('submit(btnExp)', function (data) {
            return true;
        })
        //刷新页面
        $('#btnFresh').on('click', function (e) {
            table.reload('dataList', {
                page: {curr: 1}
            });
        });
        //渲染table
        table.render({
            method: 'post',
            limit: 15,
            elem: '#dataList',
            height: 'full-120',
            url: '${BASE}/data/authuser/dl', //数据接口
            page: true,//开启分页
            skin:'line',
            size:'sm',
            cols: [
                    [ //表头
                        {field: 'id', title: '序号',width:100}
                        ,{field: 'userid', title: '用户编号',minWidth:150}
                        ,{field: 'name', title: '用户名称',minWidth:150}
                        ,{field: 'mobile', title: '手机号码',minWidth:150}
                        // ,{field: 'gender', title: '性别', width:100,align: 'center'}
                        ,{field: 'isType', title: 'Gis后台权限', width:100,align: 'center', toolbar: '#isTypeTab'}
                        ,{field: 'stat', title: '状态',width:100}

                        ,{fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#dataFormTab'}
                    ]
                ]
            });

        //监听搜索框事件
        form.on('submit(btnSearch)', function (data) {
            var params = $.trim(data.field.params);
            table.reload('dataList', {
                page: {curr: 1},
                method: 'POST', where: {
                    'params': params
                }
            });
            return false;
        });
    });
</script>
</html>
