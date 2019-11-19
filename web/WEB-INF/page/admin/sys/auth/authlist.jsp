<%-- 
    Document   : authlist
    Created on : 2018-3-26, 14:59:12
    Author     : HMQ
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <script src="${BASE}/layui/v2.4/layui-xtree.js"></script>
        <title>功能录入</title>
    </head>
    <body class="layui-layout-body">
        <blockquote class="layui-elem-quote">
            <b>功能录入</b>
            <div>
                <a class="layui-btn layui-btn-primary"  id="btnFresh">
                    <i class="layui-icon layui-btn-search" ><i class="fa fa-refresh" aria-hidden="true"></i></i>
                </a>
                <button id="addbtn" class="layui-btn layui-icon" type="button"><i class="layui-icon"></i>新增</button>
            </div>
        </blockquote>
        <div class="layui-fluid" style="padding:0px;margin-top:20px">
            <div class="layui-col-md2">
                <fieldset class="layui-elem-field" style="min-width:180px">
                    <legend style="font-size:1.2em">产品列表</legend>
                    <div class="layui-field-box" style="height: 86vh;overflow-y:auto;">
                        <form class="layui-form" name="form1">
                            <div id="xtree1" class="xtree_contianer" style="width:200px"></div>
                        </form>
                    </div>
                </fieldset>
            </div>
            <div class="layui-col-md10">
                <div class="x-left">
                    <form class="layui-form" action="">
                        <div class="layui-input-inline">
                            <input type="text" name="keyword" id="keywords" placeholder="名称"  autocomplete="off" class="layui-input">
                        </div>
                        <button class="layui-btn"  lay-submit=""  lay-filter="serch" id="serch"><i class="layui-icon"></i></button>
                        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        <input type="hidden" value="" id="pids" name="pid"/>
                        <input type="hidden" value="" id="spids" name="spid"/>
                    </form>
                    <table class="layui-table" id="dataTable" lay-filter="dataTable"></table>
                </div>
            </div>
        </div>
    </body>
    <script type="text/html" id="tbar">
         <a class="layui-icon i-right i-edit" lay-event="detail" title='查看'>
             <i class="fa fa-file-text-o" aria-hidden="true"></i>
         </a>
         <a class='layui-icon i-right i-edit' title='编辑' lay-event="edit" name="edit">&#xe642;</a>
         <a class='layui-icon i-right i-edit' style='color:red' lay-event='del' title='删除' lay-event="del" name="del">
             <i class="fa fa-minus-circle" aria-hidden="true"></i>
         </a>
    </script>
    <script>
        var mm={};
        var grade = '';
        layui.use(['layer', 'table', 'form'], function () {
            var form = layui.form, table = layui.table, layer = layui.layer, $ = layui.jquery;
            table.render({
                method: 'post',
                limit: 15,
                elem: '#dataTable',
                height: 'full-120',
                url: '${BASE}/data/auth/authlist', //数据接口
                page: true,//开启分页
                skin:'line',
                size:'sm',
                cols: [
                    [ //表头
                       {field: 'FNAME', title: '功能名称' }
                        ,{field: 'CODE', title: '功能编码' }
                        ,{field: 'PNAME', title: '所属产品' }
                        ,{field: 'REMARK', title: '备注' }
                        ,{field: 'CREATOR', title: '操作人' }
                        ,{field: 'CDATE', title: '创建时间' }
                        ,{fixed: 'right', width:200, align:'center', toolbar: '#tbar',title:'操作'}
                        ]
                    ]
            });
            form.on('submit(serch)', function (data) {
                data.field.keyword = $.trim(data.field.keyword);
                table.reload('dataTable', {method: "POST", where: data.field});
                return false;
            });
            $(document).ready(function () {
                var _dlist = ${requestScope['@dlist']};
                var slist = [];
                var childlist = [];
                if (_dlist) {
                    for (var i = 0; i < _dlist.length; i++) {
                        childlist.push(_dlist[i].FID);
                    }
                }
                $.post('${BASE}/func/auth/loadPid', function (data) {
                    slist = JSON.parse(data);
                });
                $.post('${BASE}/data/auth/menulist', function (data) {
                    var dlist = data.data;
                    if (dlist) {
                        var xtree1 = new layuiXtree({
                            isopen: false,
                            elem: 'xtree1'   //(必填) 放置xtree的容器，样式参照 .xtree_contianer
                            , form: form     //(必填) layui 的 from
                            , data: dlist     //(必填) json数据
                            , click: function (data) {
                                console.log(data.elem+"=q=data=2="+JSON.stringify(data))
                                $("input[name='xtree1']").find(".ckspan").removeClass("ckspan")
                                data.othis.addClass("ckspan");
                                grade = $("#"+data.value).attr("grade");
                                console.log(data.value)
                                grade = parseInt(grade)+1;
                                $("input[name='pid']").val(data.value);
                                document.getElementById("addbtn").className = 'layui-btn layui-btn-warm';
                                if (isInArray(slist, data.value)) {
                                    $("input[name='spid']").val(data.value);
                                }
                                $("#serch").click();
                            },ckbox: false
                        });
                    }
                });
            });


            function isInArray(arr, value) {
                for (var i = 0; i < arr.length; i++) {
                    if (value == arr[i]) {
                        return true;
                    }
                }
                return false;
            }
            function authAddSubmit() {
                var frameId = document.getElementById('auth_add_form').getElementsByTagName("iframe")[0].id;
                $('#' + frameId)[0].contentWindow.athAddSubmit();
            }
            function authEditSubmit() {
                var frameId = document.getElementById('auth_edit_form').getElementsByTagName("iframe")[0].id;
                $('#' + frameId)[0].contentWindow.athEditSubmit();
            }
            function addTrafficData(){
                $("#serch").click();
            }
            
            //监听工具条
            table.on('tool(dataTable)', function (obj) {
                var data = obj.data;
                if (obj.event === 'del') {
                    layer.confirm('确定要删除该功能吗', {title: '删除功能'}, function (index) {
                        $.post("${BASE}/func/auth/del?id=" + data.ID, function (resp) {
                            if (resp.err == 'true') {
                                layer.msg("删除成功");
                                $("#serch").click();
                            } else {
                                layer.msg("删除失败");
                                return false;
                            }
                        }, "json");
                        return false;
                    });
                } else if (obj.event === 'edit') {
                    layer.open({
                        id: 'auth_edit_form',
                        title: '编辑功能授权',
                        btn: ['编辑', '关闭'],
                        type: 2,
                        area: ['900px', '500px'],
                        content: '${BASE}/page/auth/edit?view=edit&id=' + data.ID+'&fid='+data.PID,
                        yes: function () {
                            authEditSubmit();
                        }
                    });
                } else if (obj.event === 'detail') {
                    layer.open({
                        id: 'auth_edit_form',
                        title: '查看功能授权',
                        type: 2,
                        area: ['900px', '450px'],
                        content: '${BASE}/page/auth/edit?view=detail&id=' + data.ID+'&fid='+data.PID,
                        yes: function () {
                            authEditSubmit();
                        }
                    });
                } else if (obj.event === 'disable') {//启用，禁用
                    var info = data.CSTATE == "禁用" ? "启用" : "禁用";
                    layer.confirm('确定要' + info + '该云商平台吗?', function (index) {
                        $.post("${BASE}/func/cloud_Merchant/enableCloud?id=" + data.CID + "&stat=" + (data.CSTATE == '禁用' ? "1" : "2"), function (resp) {
                            if (resp.err == true) {
                                layer.msg(info + "成功");
                                setTimeout(function () {
                                    location.reload();
                                }, 2000);
                            } else {
                                layer.msg(info + "失败");
                                return false;
                            }
                        }, "json");
                        return false;
                    });
                }
            });
            $("#addbtn").on("click", function () {
                var pid = $("input[name='pid']").val();
                console.log('grade',grade)
                if (pid) {
                    layer.open({
                        id: 'auth_add_form',
                        title: '添加功能授权',
                        btn: ['提交', '关闭'],
                        type: 2,
                        area: ['900px', '500px'],
                        content: '${BASE}/page/auth/edit?view=add&pid=' + pid+"&grade="+grade,
                        yes: function () {
                            authAddSubmit();
                        }
                    });
                } else {
                    layer.msg("请选择授权的产品");
                    return false;
                }
            });
        });
      function loadData(){
        $("#serch").click();
      }
    </script>
</html>

