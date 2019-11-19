<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统角色</title>
</head>
<body>
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="add">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">角色名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="roleName" value="${item['roleName']}" placeholder="请输入角色名称" autocomplete="off" class="layui-input"  maxlength="200">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">公司id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="comId" value="${item['comId']}" placeholder="请输入公司id" autocomplete="off" class="layui-input" lay-verify="required|number" maxlength="10">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">是否禁用</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" value="${(empty item)?'0':(item['isLock'])}" ${item['isLock'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="isLock">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-inline">
                        <input type="text" name="remark" value="${item['remark']}" placeholder="请输入备注" autocomplete="off" class="layui-input"  maxlength="255">
                    </div>
                </div>
            </div>
       <%--     <div style="margin-left: 120px">
            <table id="menu" lay-filter="menu"></table>
            </div>--%>
            <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>
    </form>

    <script>
        var form;
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form','table'], function () {
            form = layui.form;
            var table = layui.table;
            //监听开关
            table.render({
                elem: '#menu',
                limit: 10000,
                url: '${BASE}/data/sysrole/mlist',
                cols: [[
                    {field: 'FNAME', width:520, title: '功能名称', width:80},
                    {field: 'RESURL', width:520, title: '功能资源路径', width:80},
                    {field: 'GRADE', width:520, title: '功能层级(一级/二级/三级)', width:80},
                    ]]
            });
            form.on('switch', function(data) {
                var name = $(data.elem).attr('name');
                $('input[name='+name+']').val(this.checked ? 1 : 0);
            });
            form.on('submit(btnSave)', function (data) {
                var uname='${sysUsrId}';

                data.field.isLock=$("input[name='isLock']").val();

                <c:if test="${empty item}">
                    $.post("${BASE}/func/sysrole/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('XX已存，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('新增成功');
                                setTimeout(function () {

                                    parent.layer.close(index);
                                }, 2000);
                            } else {
                                layer.msg('新增失败');
                                return false;
                            }
                        }
                    }, "json");
                </c:if>
                <c:if test="${not empty item}">
                    $.post("${BASE}/func/sysrole/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {
                        if (resp.err == 'true') {
                            layer.msg('修改成功');
                            setTimeout(function () {

                                parent.layer.close(index);
                            }, 1000);
                        } else {
                            layer.msg('修改失败');
                            return false;
                        }
                    }, "json");
                </c:if>
                return false;
            });
        });
        function closeFram() {
            parent.layer.close(index);
        }

        //保存方法
        function _usrAddSubmit() {
            $('#btnSave').click();
            return false;
        }
    </script>

    <%@include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>
