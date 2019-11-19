<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>新增角色 </title>
        <style>
            .inputtext{width: 95%}
        </style>
    </head>
    <body> 
        <c:set var="DATA" value="${requestScope['@DATA']}"></c:set>
            <form class="layui-form inputtext" style="margin-top:30px" id="roleAdd">
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                    <legend>角色基本信息</legend>
                </fieldset>
                <div class="layui-form-item">
                    <label class="layui-form-label">角色编码</label>
                    <div class="layui-input-block">
                        <input type="text" name="rcode" lay-verify="rcode"  id ="rcode" value="${DATA['RCODE']}"  autocomplete="off" placeholder="请输入角色编码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">角色名称</label>
                <div class="layui-input-block">
                    <input type="text" name="rname" lay-verify="rname" value="${DATA['RNAME']}"  autocomplete="off" placeholder="请输入角色名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item layui-form-text">
                <label class="layui-form-label">角色说明</label>
                <div class="layui-input-block">
                    <textarea name="remark" placeholder="请输入角色说明" class="layui-textarea">${DATA['REMARK']}</textarea>
                </div>
            </div>
            <button class="layui-btn" lay-submit lay-filter="editrole" id="editrole" style="display:none">编辑</button>
            <button class="layui-btn" lay-submit lay-filter="addrole" id="addrole" style="display:none">新增</button>
            </form>
            <div class="layui-input-block">
                <textarea class="layui-textarea layui-hide" name="content" lay-verify="content" id="LAY_demo_editor"></textarea>
            </div>
            <script>
                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                layui.use(['form'], function () {
                    var form = layui.form;
                    form.verify({
                        rname: function (val) {
                            if (val.length == 0) {
                                return '角色名称不能为空';
                            }
                        },
                        rcode: function (val) {
                            if (val.length == 0) {
                                return '角色编码不能为空';
                            }
                        }
                    });
                    //新增角色
                    form.on('submit(addrole)', function (data) {
                        $.ajax({
                            url: '${BASE}/func/role/addrole',
                            type: 'post',
                            dataType: 'json',
                            data: data.field,
                            success: function (data, status) {
                                if (data.check == 'false') {
                                    if (data.err == 'true') {
                                        layer.msg("添加角色成功");
                                        setTimeout(function () {
                                            
                                            parent.layer.close(index);
                                        }, 2000);
                                    } else {
                                        layer.msg("添加角色失败了...");
                                        return false;
                                    }
                                } else {
                                    layer.msg("角色编码【" + $("#rcode").val() + "】已存在，请重新输入");
                                    return false;
                                }

                            }, fail: function (err, status) {
                                layer.msg("发生错误了...");
                            }
                        });
                        return false;
                    });
                    form.on('submit(editrole)', function (data) {
                        data.field.rid = '${DATA['RID']}';
                        $.ajax({
                            url: '${BASE}/func/role/editrole',
                            type: 'post',
                            dataType: 'json',
                            data: data.field,
                            success: function (data, status) {
                                if (data.check == 'false') {
                                    if (data.err == 'true') {
                                        layer.msg("修改角色成功");
                                        
                                        parent.layer.close(index);
//                                        setTimeout(function () {
//                                            
//                                            parent.layer.close(index);
//                                        }, 2000);
                                    } else {
                                        layer.msg("修改角色失败了...");
                                        return false;
                                    }
                                } else {
                                    layer.msg("角色编码【" + $("#rcode").val() + "】已存在，请重新输入");
                                    return false;
                                }
                            }, fail: function (err, status) {
                                layer.msg("发生错误了...");
                                return false;
                            }
                        });
                        return false;
                    });
                    //自定义验证规则
                    form.verify({
                        rname: function (value) {
                            if (value === '' || value === undefined || value.length < 2) {
                                return '角色名称至少得2个字符';
                            }
                        }, explain: function (value) {
                            if (value === '' || value === undefined) {
                                return '说明不能为空！';
                            }
                        }, content: function (value) {
                            layedit.sync(value);
                        }
                    });
                });
                function editSubmit() {
                    $("#editrole").click();
                }
                function addRoleSubmit() {
                    $("#addrole").click();
                }
                function closeFram() {
                    parent.layer.close(index);
                }
        </script>
    </body>
</html>
