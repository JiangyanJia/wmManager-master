<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>

        <title>系统权限设置</title>
    </head>
    <body style="padding: 10px">

            <form class="layui-form" action="" id="add">
                <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                    <legend>系统用户授权</legend>
                </fieldset>

                <div class="layui-form-item">
                    <div class="layui-block">
                        <lab游记列表el class="layui-form-label">是否GIS操作权限</lab游记列表el>
                        <div class="layui-input-inline" style="width:60px;">
                            <input  id="isType" type="checkbox" name="isType"
                                    value="${(empty item['isType'])?'0':(item['isType'])}" ${item['isType'] == '1'?'checked':''}
                                    lay-skin="switch" lay-text="是|否" lay-filter="isType">
                        </div>
                    </div>
                </div>

                <div class="layui-form-item num_clss" style="${item['isType'] == '1'?'':'display: none'}">
                    <div class="layui-block">
                        <label class="layui-form-label"><span class="required-flag"></span>景区操作权限</label>
                        <div class="layui-input-block">
                            <select id="power" name="power" ${sysPower > 0 ? 'disabled=""':''} lay-search="" ${item['isType'] == '1'?'lay-verify="required"':''}>
                                <option value="">查询或选择对应景区权限</option>
                                    <option value="-1" ${item['power']==-1 ? 'selected=""' : ''}>县级管理员</option>
                                    <c:forEach var="scenic" items="${scenicList}">
                                        <option value="${scenic['value']}" ${item['power']==scenic['value'] or  (sysPower == scenic['value'] and sysPower > 0) ? 'selected=""' : ''}>${scenic['name']}管理员</option>
                                    </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>


            <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>
        </form>

        <script>
            var form;
            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
            layui.use(['form', 'upload', 'layer'], function () {
                var form = layui.form, upload = layui.upload, layer = layui.layer;
                $("#power").val("-1");
                //监听开关
                form.on('switch', function (data) {
                    var name = $(data.elem).attr('name');
                    $('input[name=' + name + ']').val(this.checked ? 1 : 0);

                    if(name=="isType"){
                        var value = $('input[name=' + name + ']').val();
                        if(value==0){
                            $("#power").val("-1");
                            $("#power").attr("lay-verify","");
                            $(".num_clss").hide();
                        }else{
                            $("#power").val("");
                            $("#power").attr("lay-verify","required");
                            form.render();
                            $(".num_clss").show();
                        }
                        form.render();
                    };
                });

                form.on('submit(btnSave)', function (data) {

                    data.field.isType = $("input[name='isType']").val();
                    data.field.power = $("select[name='power']").val();
                    // console.log("kkk:"+JSON.stringify(data.field));
                    // return false;
                    $.post("${BASE}/func/authuser/updatePower?id=${param.id}", data.field, function (resp) {
                        if (resp.err == 'true') {
                            layer.msg('授权成功');
                            setTimeout(function () {
                                parent.document.getElementById("btnSearch").click();
                                parent.layer.close(index);
                            }, 2000);

                        } else {
                            layer.msg('授权失败');
                            return false;
                        }
                    }, "json");
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
