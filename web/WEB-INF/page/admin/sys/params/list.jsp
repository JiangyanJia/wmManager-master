<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%@ taglib prefix="mc" uri="/mobi/tcloud/mcore" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统参数</title>
</head>
<body class="layui-layout-body">
    <blockquote class="layui-elem-quote">
        <b>系统参数列表</b>
        <div>
            <a class="layui-btn layui-btn-primary"  id="btnFresh">
                <i class="layui-icon layui-btn-search" ><i class="fa fa-refresh" aria-hidden="true"></i></i>
            </a>
            <mc:Auto code="xtcsxz" tagName="button"  attrEx=" class='layui-btn layui-btn-warm' id='btnAdd' type='button'"><i class="layui-icon"></i>新增</mc:Auto>
            <mc:Auto code="xtcsdr" tagName="button"  attrEx=" class='layui-btn layui-btn-warm' id='btnUpload' type='button'">导入</mc:Auto>

        </div>
    </blockquote>
    <div class="x-left">
        <!-- 内容主体区域 -->
        <form class="layui-form" name="listForms" action="${BASE}/exp/sysparams/down" id="listForms">
            <div class="layui-input-inline">
                <input type="text" name="params" id="keyWord" autocomplete="off" class="layui-input" placeholder="关键词">
            </div>
             <button class="layui-btn" lay-submit="" lay-filter="btnSearch" id="btnSearch"><i class="layui-icon"></i></button>
            <button id="btnReset" class="layui-btn layui-btn-primary" type="button">重置</button>
            <mc:Auto code="xtcsdc" tagName="button"  attrEx=" class='layui-btn layui-btn-primary' id='btnDown' lay-filter='btnExp'">导出</mc:Auto>
        </form>
        <table id="dataList" class="layui-table" lay-filter="dataList">
        </table>


        <script type="text/html" id="dataFormTab">

            {{#  if(d.isSys === '否'){ }}
                <a class="layui-icon i-right i-edit" lay-event="view" title='查看'>
                    <i class="fa fa-file-text-o" aria-hidden="true"></i>
                </a>
                <a class="layui-icon i-right i-edit" lay-event=edit title=编辑>&#xe642;</a>
            {{#  } else { }}
                <a class="layui-icon i-right i-edit" lay-event="view" title='查看'>
                    <i class="fa fa-file-text-o" aria-hidden="true"></i>
                </a>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            {{#  } }}
            <mc:Auto code="xtcssc" tagName="a"  attrEx=" class='layui-icon i-right i-edit' style='color:red' lay-event='del' title='删除'">
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
                    id:'view',
                    title: '查看详情',
                    type: 2,
                    area: ['900px', '75%'],
                    shade: 0,
                    maxmin: true,
                    content: '${BASE}/page/sysparams/view?id=' + data.id
                });
            } else if (layEvent === 'edit') {
                layer.open({
                    id: 'add_form',
                    name: 'haha',
                    title: '编辑信息',
                    btn: ['保存', '关闭'],
                    type: 2,
                    area: ['900px', '75%'],
                    shade: 0,
                    maxmin: true,
                    content: '${BASE}/page/sysparams/edit?id=' + data.id,
                    yes: function () {
                        userAddSubmit();
                    },end: function () {
                        table.reload('dataList', {
                            page: {curr: 1}
                        });
                    }
                });
            } else if (layEvent === 'del') {
                layer.confirm('确认删除记录?', {
                    btn: ['确认', '取消'] //按钮
                }, function () {
                    $.post('${BASE}/func/sysparams/del?id=' + data.id, function (e) {
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
                shade: 0,
                maxmin: true,
                content: '${BASE}/page/sysparams/add',
                yes: function () {
                    userAddSubmit();
                },end: function () {
                    table.reload('dataList', {
                        page: {curr: 1}
                    });
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
            /*table.reload('dataList');*/
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
            url: '${BASE}/data/sysparams/dl', //数据接口
            page: true,//开启分页
            skin:'line',
            size:'sm',
            cols: [
                    [ //表头
                        {field: 'prmKey', title: '参数key',width: 100, sort: true,align:'center'}
                        ,{field: 'prmValue', title: '参数值',minWidth: 140, sort: true,align:'left'}
                        ,{field: 'prmCode', title: '类别代码',minWidth: 120, sort: true,align:'left'}
                        ,{field: 'prmDesc', title: '描述',minWidth: 300, sort: true }
                        ,{field: 'sortNum', title: '排序',width: 70, sort: true,align:'center'}
                        /*,{field: 'remark', title: '备注',width: 140, sort: true }*/
                        ,{field: 'isSys', title: '系统参数',width: 120, sort: false,align:'center'}
                        ,{field: 'islock', title: '隐藏',width: 100, sort: false,align:'center'}
                        /*,{field: 'comId', title: '公司id(0为系统)',width: 140, sort: true }
                        ,{field: 'addUser', title: '添加用户',width: 140, sort: true }
                        ,{field: 'addTime', title: '添加时间',width: 140,width: 140, sort: true }
                        ,{field: 'lmdfUser', title: '最后编辑用户',width: 140, sort: true }
                        ,{field: 'lmdfTime', title: '最后编辑时间',width: 140, sort: true }*/
                        ,{fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#dataFormTab'}
                    ]
                ],
                done: function (res, curr, count) {
                    var data = res.data;
                    var allck = true;
                    for (var item in data) {
                        if (data[item].isSys === '是') {//关键点如果data中isSys包含'是'那么就不能全选
                            allck = false;
                        }
                        break;
                    }
                    console.log("allck:"+allck);
                    if (!allck) {
                        $(".layui-table-header").find("input[name = 'layTableCheckbox'][lay-filter='layTableAllChoose']").each(function () {
                            $(this).attr("disabled", 'disabled').next().removeClass("layui-form-checked");
                            form.render('checkbox');
                        });
                    }
                    var i = 0;
                    $(".layui-table-body.layui-table-main").find("input[name='layTableCheckbox']").each(function () {
                        if (res.data[i].isSys === '是') {//关键点如果当前行数据中isSys包含'是'那么就不可选
                            $(this).attr("disabled", 'disabled').removeAttr("checked");
                            form.render('checkbox');
                        }
                        i++;
                    });
                    i = 0;
                    $(".layui-table-fixed.layui-table-fixed-l").find(".layui-table-body").find("input[name='layTableCheckbox']").each(function () {
                        if (res.data[i].isSys === '是') {//关键点如果当前行数据中isSys包含'是'那么就不可选
                            $(this).attr("disabled", 'disabled').removeAttr("checked");
                            form.render('checkbox');
                        }
                        i++;
                    });
                }
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
