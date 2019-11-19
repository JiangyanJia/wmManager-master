<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <script src="${BASE}/js/dtree/dtree.js"></script>
    <link href="${BASE}/js/dtree/dtree.css" rel="stylesheet"/>
    <title>行政区域</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="add">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>行政区域基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>区域代码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="areaCode" value="${item['areaCode']}" placeholder="请输入区域代码" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="6">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>区域名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="areaName" value="${item['areaName']}" placeholder="请输入区域名称" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="50">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">所属区域</label>
                    <div class="layui-input-inline">
                        <input type="text" name="parentCode" value="${item['parentCode']}" placeholder="点击选择所属区域" autocomplete="off" class="layui-input" lay-verify="required"  maxlength="6" onclick="selectdiaog()">
                    </div>
                    <div class="layui-form-mid layui-word-aux">无所属区域，默认为0</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sortNum" value="${item['sortNum']!=null?item['sortNum']:"99"}" placeholder="请输入排序" autocomplete="off" class="layui-input" lay-verify="required|number" maxlength="10">
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字越小越向前</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>等级</label>
                    <div class="layui-input-block">
                        <c:forEach items="${requestScope['@gradeList']}" var="rs" varStatus="status">
                            <c:if test="${empty item}">
                                <input type="radio" name="lvl" value="${rs.prmKey}" title="${rs.prmValue}" ${(rs.prmKey==1)?'checked':''} lay-verify="required">
                            </c:if>
                            <c:if test="${not empty item}">
                                <input type="radio" name="lvl" value="${rs.prmKey}" title="${rs.prmValue}" ${(rs.prmKey==item['lvl'])?'checked':''} lay-verify="required">
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">邮政编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="postCode" value="${item['postCode']}" placeholder="请输入邮政编码" autocomplete="off" class="layui-input"  maxlength="10">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>经度</label>
                    <div class="layui-input-inline">
                        <input type="text" name="lng" value="${item['lng']}" placeholder="请输入经度" autocomplete="off" class="layui-input" lay-verify="required" maxlength="10">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label"><span class="required-flag"></span>纬度</label>
                    <div class="layui-input-inline">
                        <input type="text" name="lat" value="${item['lat']}" placeholder="请输入纬度" autocomplete="off" class="layui-input" lay-verify="required" maxlength="10">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">隐藏</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="isLock" value="${(empty item)?'0':(item['isLock'])}" ${item['isLock'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="isLock">
                    </div>
                    <div class="layui-form-mid layui-word-aux">是否隐藏，隐藏不允许使用</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">备注说明</label>
                    <div class="layui-input-block">
                        <%--<input type="text" name="remark" value="${item['remark']}" placeholder="请输入备注说明" autocomplete="off" class="layui-input"  maxlength="255">--%>
                        <textarea name="remark" value="${item['remark']}" placeholder="请输入备注" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255"></textarea>
                    </div>
                </div>
            </div>
        <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>

        <%--加载dtree--%>
        <div class="dtree" id="dtree" style="display:none;width:180px; height: 55%;margin-left: 20px;margin-top: 20px;">

        </div>

        <div id="xtree1" class="xtree_contianer" style="width:200px"></div>
    </form>
</div>
</body>
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

                data.field.isLock=$("input[name='isLock']").val();

                <c:if test="${empty item}">

                    var parentCode = $("input[name=parentCode]").val();
                    if(parentCode==""){//无所属区域名称、默认为0
                        $("input[name=parentCode]").val(0);
                        data.field.parentCode = 0;
                    }
                    $.post("${BASE}/func/sysarea/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('区域代码已存在，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('新增成功');
                                setTimeout(function () {
                                    //window.parent.location.reload(); //刷新父页面
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
                    $.post("${BASE}/func/sysarea/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {

                        if (resp.check == 'true') {
                            layer.msg('区域代码已存在，请重新输入');
                            return false;
                        } else {
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

        $(document).ready(function () {


        });


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
            $("input[name=parentCode]").val(id);
        }
    </script>

    <%@include file="/WEB-INF/jspf/footer.jspf" %>
</html>
