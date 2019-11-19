<!-- 生成版本:1.1 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>组织机构</title>
</head>
<body style="padding: 10px">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form formCls" action="" id="add">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>组织机构基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>组织机构编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="orgCode" value="${item['orgCode']}" placeholder="请输入组织编码" lay-verify="required" autocomplete="off" class="layui-input"  maxlength="20">
                    </div>
                    <div class="layui-form-mid layui-word-aux">机构编码唯一</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>组织名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="name" value="${item['name']}" lay-verify="required" placeholder="请输入组织名称" autocomplete="off" class="layui-input"  maxlength="200">
                    </div>
                    <div class="layui-form-mid layui-word-aux">组织名称唯一</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>上级组织代码</label>
                    <div class="layui-input-inline">
                    <select name="parentCode" lay-verify="required">
                        <option value="${item['parentCode']==-1 ? '-1' : ''}" ${item['parentCode']==-1 ? 'selected=""' : ''}> </option>
                        <c:forEach items="${requestScope['@org']}" var="sx">
                            <option value="${sx['orgCode']}" ${sx['orgCode'] == item['parentCode'] ? 'selected=""' : ''}>${sx['name']}</option>
                        </c:forEach>
                    </select>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">备注说明</label>
                    <div class="layui-input-inline">
                        <input type="text" name="remark" value="${item['remark']}" placeholder="请输入备注说明" autocomplete="off" class="layui-input"  maxlength="255">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">是否隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" value="${(empty item)?'0':(item['isLock'])}" ${item['isLock'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="isLock">
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
            /*form.verify({
                account: function (val) {
                    if (val.length < 3) {
                        return 'XX至少得3个字符';
                    }
                }
            });*/
            form.on('submit(btnSave)', function (data) {
                var uname = '${sysUsrId}';
                data.field.isLock=$("input[name='isLock']").val();
                <c:if test="${empty item}">
                    $.post("${BASE}/func/sysorg/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('该组织机构编码已存在，请重新输入');
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
                    $.post("${BASE}/func/sysorg/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('该组织机构编码已存在，请重新输入');
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
            $("#btnSave").click();
            return false;
        }

        function selectdiaog() {
            layer.open({
                id: 'area_form',
                name: 'haha',
                title: '所属区域',
                type: 2,
                area: ['250px', '80%'],
                shade: 0,
                maxmin: false,
                content: '${BASE}/page/sysarea/selectArea'

            });
        }
        function setvalue(id, name) {
            $("input[name=areaCode]").val(id);
            $("input[name=areaName]").val(name);
            <%--loadData("scenic_id","gateway/getArea?type=3&code="+id,"请选择景区",'${item['scenic_id']}');--%>
        }

        function loadData(id,url,title,defval){
            layui.use(['form'], function () {
                form = layui.form;
                $.post("${BASE}/"+url,function (resp) {
                    if (resp.code == 0) {
                        $("#"+id)
                        var objdata = resp.data;
                        $("#"+id+"  > option").remove();
                        $("#"+id).html("");
                        $("#"+id).append("<option value=''>"+title+"</option>");
                        for (var i = 0; i < objdata.length; i++) {
                            if(defval==(objdata[i].code)){
                                $("#" + id).append("<option value='" + objdata[i].code + "' selected=\"\">" + objdata[i].name + "</option>");
                            }else {
                                $("#" + id).append("<option value='" + objdata[i].code + "' >" + objdata[i].name + "</option>");
                            }
                        }

                            form.render("select");

                    } else {
                        $("#"+id+"  > option").remove();
                        $("#"+id).html("");
                        form.render("select");
                        return false;
                    }
                }, "json");
            });
        }
    </script>

    <%@include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>
