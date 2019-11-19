<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <script src="${BASE}/layui/v2.4/layui-xtree.js"></script>
    <title>角色授权</title>
    <style>
        .system {
            line-height: 50px;
            padding-left: 30px;
            background: #96b97d;
            border-bottom: 1px solid #fff;
            color: #fff
        }

        .func {
            line-height: 50px;
            padding-left: 50px;
            background: #F2F2F2;
            border-bottom: 1px solid #fff
        }
        .layui-form-checked:hover span{
            background-color:#fff !important;
        }
    </style>
    <style type="text/css">
        form {
            margin: 10px auto;
            width: 100%
        }

        h1, h2, h3 {
            padding: 10px 0
        }

        a {
            color: #1C86EE;
            text-align: right;
            font-size: 18px
        }

        .xtree_contianer {
            overflow: auto;
            margin-bottom: 30px;
            padding: 10px 0 25px 5px;
            width: 500px;
            background-color: #fff
        }

        .div-btns {
            margin: 20px 0
        }

        .layui-form-label {
            width: 60px !important
        }

        .ckbx {
            margin: 0 3px 0 15px;
        }
    </style>
    <script>
        function checkTd(obj){
            var checkboxVal = $(obj).find("input[type='checkbox']");
            if (checkboxVal.attr("checked") == 'checked') {
                checkboxVal.removeAttr("checked");
            } else {
                checkboxVal.attr("checked", "checked");
            }
        }
        function pickPar(obj) {
            checkTd(obj);
            var id = $(obj).find("td:eq(0)").attr("id");
            $("#showMenuList td[pid=" + id + "]").each(function () {
                checkTd($(this).closest('tr'));
                var chirdId = $(this).attr("id");
                $("#showMenuList td[pid=" + chirdId + "]").each(function(){
                    checkTd($(this).closest('tr'));
                });
            });

        }
    </script>
</head>
<body>
<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
    <ul class="layui-tab-title">
        <li class="layui-this">菜单功能授权</li>
    </ul>

    <form class="layui-form" name="form1">
        <div id="xtree1" class="xtree_contianer" style="width:300px"></div>
    </form>
</div>
<script>
    //    var xtree1;
    var index = parent.layer.getFrameIndex(window.name);
    var xtreefunc;
    var xtreeinter;
    layui.use(['element', 'form', 'layedit', 'laydate'], function () {
        var form = layui.form;
        var element = layui.element;
        var layer = layui.layer;
        str = []
        /*$.post({
            url:'${BASE}/data/index/menulist1?rid='+${param.rid},
            success:function(res){
                var xtree1 = new layuiXtree({
                    elem: 'xtree1',
                    form: form,
                    data: res.data,

                    click: function (data) {
                        str = []
                        $("input:checkbox:checked").each(function() { // 遍历name=standard的多选框
                            var json = new Object();
                            json.id = $(this).val();
                            json.pid = $(this).attr("pid");
                            json.grade = $(this).attr("grade");
                            json.ftype = $(this).attr("ftype");
                            str.push(json);
                        });
                    }
                })
            }
        })*/

        $.ajax({
            url:'${BASE}/data/index/menulist1?rid='+${param.rid},
            type: 'post',
            dataType: 'json',
            success: function (res, status) {
                var xtree1 = new layuiXtree({
                    elem: 'xtree1',
                    form: form,
                    data: res.data,

                    click: function (data) {
                        str = []
                        $("input:checkbox:checked").each(function() { // 遍历name=standard的多选框
                            var json = new Object();
                            json.id = $(this).val();
                            json.pid = $(this).attr("pid");
                            json.grade = $(this).attr("grade");
                            json.ftype = $(this).attr("ftype");
                            str.push(json);
                        });
                    }
                })
            }, fail: function (err, status) {
            }
        });
    });

    function mySubmit() {
        if(str.length>0){//console.log("kkk:"+JSON.stringify(str));
            $.post("${BASE}/func/role/rolefunc?rid=" +${param.rid},{idd: JSON.stringify(str)},function (res) {
                //console.log('res',res);
                if(res==='0'){
                    layer.msg("授权成功");
                    setTimeout(function () {
                        parent.layer.close(index);
                    }, 1000);
                }else {
                    layer.msg("授权失败");
                    return false;
                }

            });
        }else{
            parent.layer.close(index);
        };
    }
</script>
</body>
</html>