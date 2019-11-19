<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<%@ taglib prefix="mc" uri="/mobi/tcloud/mcore" %>--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>功能管理</title>
    </head>
    <body>
        <blockquote class="layui-elem-quote">
            <b>功能管理</b>
            <div>
                <a class="layui-btn layui-btn-primary"  href="javascript:window.location.reload()">
                    <i class="layui-icon" style="color: #1E9FFF;">&#x1002;</i>
                </a>
            </div>
        </blockquote>
        <div class="x-left">
            <form class="layui-form">
                <div class="layui-input-inline">
                    <input class="layui-input" name="keyword" id="keyword" autocomplete="off" placeholder="功能名称">
                </div>
                <button class="layui-btn" id="module"  lay-submit="" lay-filter="serch"><i class="layui-icon"></i></button>
                <button type="reset"  class="layui-btn layui-btn-primary" >重置</button>
                <!--                <button type="button"  class="layui-btn layui-btn-primary" id="bindrole">绑定角色</button>
                                <button type="button"  class="layui-btn layui-btn-primary" id="unbindrole">解绑角色</button>-->
                <mc:Auto code="m71" tagName="button"  attrEx=" class='layui-btn layui-btn-primary' id='bindrole' title='绑定角色' type='button'">绑定角色</mc:Auto>
                <mc:Auto code="m72" tagName="button"  attrEx=" class='layui-btn layui-btn-primary' id='unbindrole' title='解绑角色' type='button'">解绑角色</mc:Auto> 
                </form>
              <%--  <table class="layui-table" id="mfunc" lay-data="{url:'${BASE}/data/mfunc/mfunclist',height: 'full-120', cellMinWidth: 80, page: true}"  lay-filter="mfunc">
                <thead>
                    <tr>
                        <th lay-data="{type:'checkbox'}"></th>
                        <th lay-data="{field:'PNAME'}">产品</th>
                        <th lay-data="{field:'GRADE', width:120}">类型</th>
                        <th lay-data="{field:'ROLELIST'}">已授权角色</th>
                        <th lay-data="{fixed: 'right',align: 'center', toolbar: '#barDemo',width:200}">操作</th>
                    </tr>
                </thead>
            </table>--%>
            <table class="layui-table" id="mfunc1" lay-filter="mfunc1"></table>
        </div>
        <script type="text/html" id="barDemo">
            <a class="layui-icon i-right i-edit" lay-event="detail" title='查看'>
                <i class="fa fa-file-text-o" aria-hidden="true"></i>
            </a>
            <a class="layui-icon i-right i-edit" lay-event="bindRole" title='绑定角色'>&#xe620;</a>
            <%--<mc:Auto code="m71" tagName="a"  attrEx=" class='layui-icon i-right i-edit' lay-event='bindRole' title='绑定角色'">&#xe620;</mc:Auto>--%>
            <%--<mc:Auto code="m72" tagName="a"  attrEx=" class='layui-icon i-right i-edit' lay-event='unbindRole' title='解绑角色'">&#xe613;</mc:Auto>--%> 
            <a class="layui-icon i-right i-edit" lay-event="unbindRole" title='解绑角色'>&#xe613;</a>
            </script>
            <script>
                layui.use(['laydate', 'table', 'form'], function () {
                    var table = layui.table;
                    var laydate = layui.laydate; //日期插件
                    var form = layui.form;
                    //选择所属系统
                    table.render({
                        method: 'post',
                        limit: 15,
                        elem: '#mfunc1',
                        height: 'full-120',
                        url: '${BASE}/data/mfunc/mfunclist', //数据接口
                        page: true,//开启分页
                        skin:'line',
                        size:'sm',
                        cols: [
                            [ //表头
                                {type:'checkbox'},
                                {field:'PNAME',title:'产品'},
                                {field:'GRADE',title:'类型'},
                                {field:'ROLELIST',title:'已授权角色'},
                                {fixed: 'right',align: 'center', toolbar: '#barDemo',width:200,title:'操作'}
                        ]
                            ]
                    });
                    form.on('submit(serch)', function (data) {
                        table.reload('mfunc1', {method: "POST", where: $.extend(data.field, {keyword: data.field.keyword})});
                        return false;
                    });
                    //监听工具条
                    table.on('tool(mfunc1)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
                        var data = obj.data //获得当前行数据
                                , layEvent = obj.event; //获得 lay-event 对应的值
                        var gid = data.GID;
                        if (layEvent === 'detail') {
                            layer.open({
                                title: '查看角色详情',
                                type: 2,
                                area: ['100%', '100vh'],
                                fixed: false, //不固定
                                maxmin: true,
                                content: '${BASE}/page/mfunc/mfuncDetail?pname=' + data.PNAME + '&grade=' + data.GRADE + '&role=' + data.ROLELIST
                            });
                        } else if (layEvent === 'bindRole') {
                            if (gid == 2) {
                                layer.open({
                                    title: '请选择绑定产品项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncBindRole?fid=' + data.FID + '&pid=' + data.PID
                                });
                            } else {
                                layer.open({
                                    title: '请选择绑定功能项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncBindRoleId?iid=' + data.IID + '&fid=' + data.FID + '&pid=' + data.PID
                                });
                            }
                        } else if (layEvent === 'unbindRole') {
                            if (gid == 2) {
                                layer.open({
                                    title: '请选择解绑产品项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncUnbindRole?fid=' + data.FID + '&pid=' + data.PID
                                });
                            } else {
                                layer.open({
                                    title: '请选择解绑功能项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncUnbindRoleId?iid=' + data.IID + '&fid=' + data.FID + '&pid=' + data.PID
                                });
                            }
                        }
                    });
                    $("#bindrole").on("click", function () {
                        var ulist = "", len = 0, str = '', mlist = '', flist = "";
                        var ckbox = table.checkStatus('mfunc1').data;
                        len = ckbox.length;
                        if (len == 0) {
                            layer.msg("请选择绑定角色");
                            return false;
                        }
                        console.log(ckbox)
                        for (var i = 0; i < len; i++) {
                            if (ckbox[i].GID == 2) {
                                mlist += ckbox[i].FID + ":" + ckbox[i].PID + ",";
                            } else {
                                flist += ckbox[i].IID + ":" + ckbox[i].FID + ":" + ckbox[i].PID + ",";
                            }
                        }
                        if (mlist) {
                            mlist = mlist.substr(0, mlist.length - 1);
                        }
                        if (flist) {
                            flist = flist.substr(0, flist.length - 1);
                        }
                        if (len == 1) {
                            var gid = ckbox[0].GID;
                            if (gid == 2) {
                                layer.open({
                                    title: '请选择绑定产品项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncBindRole?fid=' + ckbox[0].FID + '&pid=' + ckbox[0].PID
                                });
                            } else {
                                layer.open({
                                    title: '请选择绑定功能项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncBindRoleId?iid=' + ckbox[0].IID + '&fid=' + ckbox[0].FID + '&pid=' + ckbox[0].PID
                                });
                            }
                        } else {
                            layer.open({
                                title: '请选择绑定角色',
                                type: 2,
                                area: ['900px', '800px'],
                                fixed: false, //不固定
                                maxmin: true,
                                content: "${BASE}/page/mfunc/mfuncRole?mlist=" + mlist + "&flist=" + flist
                            });
                        }
                    });
                    $("#unbindrole").on("click", function () {
                        var ulist = "", len = 0, str = '', mlist = "", flist = "";
                        var ckbox = table.checkStatus('mfunc1').data;
                        len = ckbox.length;
                        if (len == 0) {
                            layer.msg("请选择解绑角色");
                            return false;
                        }
                        for (var i = 0; i < len; i++) {
                            if (ckbox[i].GID == 2) {
                                mlist += ckbox[i].FID + ":" + ckbox[i].PID + ",";
                            } else {
                                flist += ckbox[i].IID + ":" + ckbox[i].FID + ":" + ckbox[i].PID + ",";
                            }
                        }
                        if (mlist) {
                            mlist = mlist.substr(0, mlist.length - 1);
                        }
                        if (flist) {
                            flist = flist.substr(0, flist.length - 1);
                        }
                        if (len == 1) {
                            var gid = ckbox[0].GID;
                            if (gid == 2) {
                                layer.open({
                                    title: '请选择解绑产品项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncUnbindRole?fid=' + ckbox[0].FID + '&pid=' + ckbox[0].PID
                                });
                            } else {
                                layer.open({
                                    title: '请选择解绑功能项角色',
                                    type: 2,
                                    area: ['900px', '800px'],
                                    fixed: false, //不固定
                                    maxmin: true,
                                    content: '${BASE}/page/mfunc/mfuncUnbindRoleId?iid=' + ckbox[0].IID + '&fid=' + ckbox[0].FID + '&pid=' + ckbox[0].PID
                                });
                            }
                        } else {
                            layer.open({
                                title: '请选择角色',
                                type: 2,
                                area: ['900px', '800px'],
                                fixed: false, //不固定
                                maxmin: true,
                                content: "${BASE}/page/mfunc/mfuncUnRole?mlist=" + mlist + "&flist=" + flist
                            });
                        }
                    });
                });
        </script>
    </body>
</html>
