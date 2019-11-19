<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title></title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="add">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>系统菜单基本信息</legend>
            </fieldset>
            <input type="hidden" name="ID" value="${item['ID']}">
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>菜单编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="FID" value="${item['FID']}" placeholder="请输入菜单编号" autocomplete="off" class="layui-input" lay-verify="number" maxlength="10">
                    </div>
                <div class="layui-form-mid layui-word-aux">菜单编号只能填写数字</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>菜单名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="FNAME" value="${item['FNAME']}" placeholder="请输入菜单名称" autocomplete="off" class="layui-input" lay-verify="required" maxlength="50">
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">上级菜单编号</label>
                    <div class="layui-input-inline">
                        <select name="PID" id="PID">
                            <option value="-1">无所属导航</option>
                            <c:forEach var="gr" items="${parentList}">
                                <option value="${gr['id']}" ${item['PID']==gr['id']?'selected=""':''}>${gr['value']}</option>
                            </c:forEach>
                        </select>
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">菜单路径</label>
                    <div class="layui-input-inline">
                        <input type="text" name="RESURL" value="${item['RESURL']}" placeholder="请输入菜单路径" autocomplete="off" class="layui-input" maxlength="50">
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="PRIORITY" value="${item['PRIORITY']!=null?item['PRIORITY']:"99"}" placeholder="请输入排序" autocomplete="off" class="layui-input" lay-verify="number" maxlength="10">
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字越小越向前</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>菜单层级</label>
                    <div class="layui-input-block">
                        <%--<input type="text" name="GRADE" value="${item['GRADE']}" placeholder="请输入菜单层级" autocomplete="off" class="layui-input"  maxlength="5">--%>

                        <c:forEach items="${requestScope['@gradeList']}" var="rs" varStatus="status">
                            <c:if test="${empty item}">
                                <input type="radio" name="GRADE" value="${rs.prmKey}" title="${rs.prmValue}" ${(rs.prmKey==1)?'checked':''} lay-verify="required">
                            </c:if>
                            <c:if test="${not empty item}">
                                <input type="radio" name="GRADE" value="${rs.prmKey}" title="${rs.prmValue}" ${(rs.prmKey==item['GRADE'])?'checked':''} lay-verify="required">
                            </c:if>
                        </c:forEach>
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <%--功能类型--%>
            <input type="hidden" name="FTYPE" value="${item['FTYPE']}" autocomplete="off" class="layui-input"  maxlength="10">

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">菜单状态</label>
                    <div class="layui-input-block">
                        <c:if test="${empty item}">
                            <input type="radio" name="STATE" value="1" title="有效" checked>
                            <input type="radio" name="STATE" value="0" title="无效">
                        </c:if>
                        <c:if test="${not empty item}">
                            <input type="radio" name="STATE" value="1" title="有效" ${(item['STATE']==1)?'checked':''}>
                            <input type="radio" name="STATE" value="0" title="无效" ${(item['STATE']==0)?'checked':''}>
                        </c:if>
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">类型</label>
                    <div class="layui-input-block">
                        <c:if test="${empty item}">
                            <input type="radio" name="TYPE" value="0" title="产品" checked>
                            <input type="radio" name="TYPE" value="1" title="接口" >
                        </c:if>
                        <c:if test="${not empty item}">
                            <input type="radio" name="TYPE" value="0" title="产品" ${(item['TYPE']==0)?'checked':''}>
                            <input type="radio" name="TYPE" value="1" title="接口" ${(item['TYPE']==1)?'checked':''}>
                        </c:if>
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">叶子节点</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="ISLEAF" value="${(empty item)?'0':(item['ISLEAF'])}" ${item['ISLEAF'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="ISLEAF">
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <%--<div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>权限资源</label>
                    <div class="layui-input-block">
                        <c:forEach items="${atList}" var="rs" varStatus="status">
                            <input type="checkbox" name="actionType" title="${rs.prmValue}" value="${rs.prmKey}">
                        </c:forEach>
                    </div>
                <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>--%>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">别名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" value="${item['alias']}" placeholder="请输入别名" autocomplete="off" class="layui-input"  maxlength="50">
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-block">
                        <textarea name="REMARK" value="${item['REMARK']}" placeholder="请输入备注" class="layui-textarea"
                                  autocomplete="off" class="layui-input" maxlength="255"></textarea>
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
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
            $("input:checkbox[name='actionType']").each(function() {
                /*console.log("value:"+$(this).val());*/
                //获取多复选框赋值
                var actionType = '${item['actionType']}';
                var at = actionType.split(",");
                for (i=0;i<at.length ;i++ ){
                    at[i]==$(this).val()?$(this).attr("checked",""):"";
                }
                form.render();

            });

            $('input[name=FID]').blur(function () {
                <c:if test="${empty item}">
                $.post("${BASE}/func/sysfunction/exists?FID=" + $(this).val(), {}, function (resp) {
                    console.log(resp);
                    if (resp.check == 'true') {
                        layer.msg('菜单编号已经存在，请重新输入');
                        return false;
                    }
                }, "json");
                </c:if>
                <c:if test="${not empty item}">
                $.post("${BASE}/func/sysfunction/exists?id=${item['id']}+&grpName=" + $(this).val(), {}, function (resp) {
                    if (resp.check == 'true') {
                        layer.msg('菜单编号已经存在，请重新输入');
                        return false;
                    }
                }, "json");
                </c:if>
                return false;
            });

            form.on('submit(btnSave)', function (data) {
                var uname='${sysUsrId}';

                var atPrarm = "";

                $("input:checkbox[name='actionType']:checked").each(function() { // 遍历name=standard的多选框
                    //form.render();
                    atPrarm+=($(this).val())+",";
                });

                data.field.ISLEAF=$("input[name='ISLEAF']").val();
                data.field.FTYPE='page';//默认page
                data.field.actionType=atPrarm.substring(0,atPrarm.length-1);

                <c:if test="${empty item}">
                    $.post("${BASE}/func/sysfunction/insert?addUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('菜单编号已存在，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('新增成功');
                                setTimeout(function () {
                                    //table.reload('dataList'); //刷新父页面
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
                    $.post("${BASE}/func/sysfunction/update?id=${item['id']}&lmdfUser=" + uname, data.field, function (resp) {
                        if (resp.check == 'true') {
                            layer.msg('菜单编号已存，请重新输入');
                            return false;
                        } else {
                            if (resp.err == 'true') {
                                layer.msg('修改成功');
                                setTimeout(function () {
                                    //table.reload('dataList'); //刷新父页面
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
