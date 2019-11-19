<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>系统参数</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="add">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>系统参数基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>参数key</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmKey" value="${item['prmKey']}" placeholder="请输入参数key" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="50">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>显示值</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmValue" value="${item['prmValue']}" placeholder="请输入显示值" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="50">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>类别代码</label>
                    <div class="layui-input-block">
                        <input type="text" name="prmCode" value="${item['prmCode']}" placeholder="请输入类别代码" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="50">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sortNum" value="${item['sortNum']!=null?item['sortNum']:99}" placeholder="请输入排序" autocomplete="off" class="layui-input" lay-verify="required|number" maxlength="10">
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字越小越向前</div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="islock" value="${(empty item)?'0':(item['islock'])}" ${item['islock'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="islock">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否隐藏，隐藏不允许使用</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">系统参数</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isSys" value="${(empty item)?'0':(item['isSys'])}" ${item['isSys'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="isSys">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否系统参数，系统不允许编辑</div>
                </div>
            </div>
            <%--<div class="layui-form-item">
               <div class="layui-inline">
                    <label class="layui-form-label">公司编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="comId" value="${item['comId']!=null?item['comId']:0}" placeholder="请输入公司编号" autocomplete="off" class="layui-input" maxlength="10">
                    </div>
                    <div class="layui-form-mid layui-word-aux">公司编号，0为系统</div>
                </div>
            </div>--%>
            <input type="hidden" name="comId" value="${item['comId']!=null?item['comId']:0}" placeholder="请输入公司id" autocomplete="off" class="layui-input" maxlength="10">
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">描述</label>
                    <div class="layui-input-block">
                        <textarea name="prmDesc" placeholder="请输入描述" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255">${item['prmDesc']}</textarea>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-block">
                        <textarea name="remark" placeholder="请输入备注" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255">${item['remark']}</textarea>
                    </div>
                </div>
            </div>
        <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>
    </form>
</div>
    <script>
        var form;
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        layui.use(['form'], function () {
            form = layui.form;

            //监听开关
            form.on('switch', function(data) {
                var name = $(data.elem).attr('name');
                $('input[name='+name+']').val(this.checked ? 1 : 0);
            });      

            form.on('submit(btnSave)', function (data) {
                var uname='${sysUsrId}';

                data.field.islock=$("input[name='islock']").val();
                data.field.isSys=$("input[name='isSys']").val();

                <c:if test="${empty item}">
                    $.post("${BASE}/func/sysparams/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('参数key和类别代码已存在，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('新增成功');
                                setTimeout(function () {
                                    parent.layer.close(index);
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
                    $.post("${BASE}/func/sysparams/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('参数key和类别代码已存在，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('修改成功');
                                setTimeout(function () {
                                    parent.layer.close(index);
                                }, 1000);
                            } else {
                                layer.msg('修改失败');
                                return false;
                            }
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
