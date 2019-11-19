<%-- 
    Document   : authedit
    Created on : 2018-03-26, 15:21:44
    Author     : HMQ
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <script type="text/javascript" src="${BASE}/statics/zTree/js/jquery.ztree.core.js"></script>
        <script type="text/javascript" src="${BASE}/statics/zTree/js/jquery.ztree.excheck.js"></script>
        <script type="text/javascript" src="${BASE}/statics/zTree/js/jquery.ztree.exedit.js"></script>
        <link href="${BASE}/statics/zTree/css/demo.css" rel="stylesheet"/>
        <link href="${BASE}/statics/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet"/>
        <title>新增用户</title>
    </head>
    <body>
        <c:set var="item" value="${requestScope['@dmm']}"></c:set>
            <form class="layui-form formCls" action="" id="userAdd">
                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label"><span class="required-flag"></span>功能编码</label>
                        <div class="layui-input-inline">
                            <input type="text" name="code" value="${item['CODE']}" id="code" lay-verify="code" autocomplete="off" placeholder="请输入功能编码" class="layui-input" <c:if test="${param.view == 'detail'}">readonly="true"</c:if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <c:if test="${param.view == 'edit' || param.view == 'add'}">
                        <div class="layui-block">
                            <div class="layui-block">
                                <label class="layui-form-label"><span class="required-flag"></span>所属产品</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="pname" lay-verify="pname" autocomplete="off" value="${item['PNAME']}" disabled placeholder="请选择所属产品" class="layui-input"
                                           id="pname">
                                </div>
                                <button id="menuBtn" type="button" class="layui-btn layui-btn-xs layui-btn-normal topCateory" >选择</button>

                            </div>
                        </div>

                    </c:if>
                    <c:if test="${param.view == 'detail'}">

                        <div class="layui-block">
                            <div class="layui-block">
                                <label class="layui-form-label"><span class="required-flag"></span>所属产品</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="pname" lay-verify="pname" autocomplete="off" value="${item['PNAME']}" disabled placeholder="请选择所属产品" class="layui-input"
                                           id="code">
                                </div>

                            </div>
                        </div>
                    </c:if>

                </div>

                <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>功能名称</label>
                    <div class="layui-input-block">
                        <input type="text" name="name" value="${item['FNAME']}" lay-verify="name" placeholder="请输入功能名称" autocomplete="off" class="layui-input" 
                               <c:if test="${param.view == 'detail'}">readonly="true"</c:if>>
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label">备注</label>
                        <div class="layui-input-block">
                            <textarea name="remark" placeholder="请输入备注" class="layui-textarea"  <c:if test="${param.view == 'detail'}">readonly="true"</c:if>>${item['REMARK']}</textarea>
                        </div>
                    </div>
                </div>

                <input type="hidden" value="${item['PID']}" id="oid" name="oid"/>
                <input type="hidden" value="${param.grade}" id="grade" name="grade"/>
                <input type="hidden" value="${item['PCODE']}" id="pcode" name="pcode"/>
                <button class="layui-btn" lay-submit lay-filter="addUserForm" id="addUserForm" style="display: none"></button>
        </form>
        <div id="menuContent" class="menuContent" style="display:none; position: absolute;">
            <ul id="treeMenu" class="ztree" style="margin-top:0; width:300px; height: 230px"></ul>
        </div>
        <script>
            var form;
            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
            layui.use(['form'], function () {
                form = layui.form;
                //自定义验证规则
                form.verify({
                    name: function (value) {
                        if (value.length == 0) {
                            return '功能名称不能为空';
                        }
                    },
                    code: function (val) {
                        if (val.length == 0) {
                            return '功能编码不能为空';
                        }
                    },
                    pname: function (val) {
                        if (val.length == 0) {
                            return '请选择所属组织';
                        }
                    }, remark: function (val) {
                        if (val == '') {
                            return '备注不能为空';
                        }
                    }
                });
                form.on('submit(addUserForm)', function (data) {
                    var loadIndex = layer.load(2, {shade: [0.3, '#333']});
            <c:if test="${empty item}">
                    $.post("${BASE}/func/auth/insert", data.field, function (resp) {
                        if (resp.check == 'false') {
                            if (resp.err == 'true') {
                                loadIndex && layer.close(loadIndex);
                                layer.msg("新增功能成功");
                                window.parent.loadData();
                                parent.layer.close(index);
                            } else {
                                loadIndex && layer.close(loadIndex);
                                layer.msg("新增功能失败");
                                return false;
                            }
                        } else {
                            loadIndex && layer.close(loadIndex);
                            layer.msg("功能编码【" + $("#code").val() + "】已存在，请重新输入");
                            return false;
                        }
                    }, "json");
            </c:if>
            <c:if test="${not empty item}">
                    $.post("${BASE}/func/auth/update?id=${item['ID']}", data.field, function (resp) {
                                    if (resp.check == 'false') {
                                        if (resp.err == 'true') {
                                            loadIndex && layer.close(loadIndex);
                                            layer.msg("修改功能成功");
                                            window.parent.loadData();
                                            parent.layer.close(index);
                                        } else {
                                            loadIndex && layer.close(loadIndex);
                                            layer.msg("修改功能失败");
                                            return false;
                                        }
                                    } else {
                                        loadIndex && layer.close(loadIndex);
                                        layer.msg("功能编码【" + $("#code").val() + "】已存在，请重新输入");
                                        return false;
                                    }

                                }, "json");
            </c:if>
                                return false;
                            });
                        });
                        var zNodes = [{id: 1, pId: 0, name: "数据错误"}];
                        $(function () {
                            var fun = '${requestScope['@fun']}';
                            if (fun) {
                                fun = JSON.parse(fun);
                                $("#oid").val(fun.FID);
                                $("#pname").val(fun.FNAME);
                                $("#pcode").val(fun.CODE);
                            }
                            var menu = {
                                view: {
                                    dblClickExpand: false
                                },
                                data: {
                                    simpleData: {
                                        enable: true
                                    }
                                },
                                callback: {
                                    onClick: onClick
                                }
                            };
                            loadOrgList();
                            function loadOrgList() {
                                $.post("${BASE}/data/auth/olist", function (data) {
                                    if (data.code == 0) {
                                        zNodes = data.data;
                                        $.fn.zTree.init($("#treeMenu"), menu, zNodes);
                                    }
                                }, "json");
                            }
                            function onClick(e, treeId, treeNode) {

                                var zTree = $.fn.zTree.getZTreeObj("treeMenu"), nodes = zTree.getSelectedNodes(), v = "";
                                nodes.sort(function compare(a, b) {
                                    return a.id - b.id;
                                });
                                console.log("=======nodes======" + JSON.stringify(nodes))
                                if (!nodes[0].isParent) {
                                    for (var i = 0, l = nodes.length; i < l; i++) {
                                        v += nodes[i].name + ",";
                                    }
                                    if (v.length > 0)
                                        v = v.substring(0, v.length - 1);
                                    $("#oid").val(nodes[0].id);
                                    $("#pname").val(v);
                                    $("#pcode").val(nodes[0].CODE);
                                    hideMenu();

                                }
                            }
                            $("#menuBtn").on("click", function () {
                                showMenu()
                            })

                            function showMenu() {
                                var pname = $("#pname");
                                var paOffset = $("#pname").offset();
                                $("#menuContent").css({left: (paOffset.left) + "px", top: (paOffset.top - pname.outerHeight() + 70) + "px"}).slideDown("fast");
                                $("body").bind("mousedown", onBodyDown);
                            }
                            function hideMenu() {
                                $("#menuContent").fadeOut("fast");
                                $("body").unbind("mousedown", onBodyDown);
                            }
                            function onBodyDown(event) {
                                if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length > 0)) {
                                    hideMenu();
                                }
                            }
                        });
                        function closeFram() {
                            parent.layer.close(index);
                        }

                        function athAddSubmit() {
                            $("#addUserForm").click();
                            return false;
                        }
                        function athEditSubmit() {
                            $("#addUserForm").click();
                            return false;
                        }
        </script>
    </body>
</html>
