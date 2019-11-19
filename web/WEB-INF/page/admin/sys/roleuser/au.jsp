<!-- 生成版本:1.1 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统角色用户</title>
</head>
<body>
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form formCls" action="" id="add">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">角色id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="roleId" value="${item['roleId']}" placeholder="请输入角色id" autocomplete="off" class="layui-input" lay-verify="required|number" maxlength="10">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">用户id</label>
                    <div class="layui-input-inline">
                        <input type="text" name="userId" value="${item['userId']}" placeholder="请输入用户id" autocomplete="off" class="layui-input" lay-verify="required|number" maxlength="10">
                    </div>
                </div>
            </div>
        <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>
    </form>

    <script>
        var form;
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form'], function () {
            form = layui.form;
            //自定义验证规则
            form.verify({
                account: function (val) {
                    if (val.length < 3) {
                        return 'XX至少得3个字符';
                    }
                }
            });
            form.on('submit(btnSave)', function (data) {
                var uname = 'ccc';
                data.field.isLock=$("input[name='isLock']").val();
                <c:if test="${empty item}">
                    $.post("${BASE}/func/sysroleuser/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('XX已存，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('新增成功');
                                setTimeout(function () {
                                    window.parent.location.reload(); //刷新父页面
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
                    $.post("${BASE}/func/sysroleuser/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {
                        if (resp.err == 'true') {
                            layer.msg('修改成功');
                            setTimeout(function () {
                                //window.parent.location.reload(); //刷新父页面
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
            $("#btnSave").click();
            return false;
        }
    </script>

    <%@include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>
