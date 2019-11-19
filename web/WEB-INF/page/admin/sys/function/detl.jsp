<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>详情</title>
</head>
<body>
<div class="layui-form-margin-top">
    <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
        <form class="layui-form" action="" id="detl">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                <legend>系统菜单基本信息</legend>
            </fieldset>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">菜单编号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="FID" value="${item['FID']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">菜单编号只能填写数字</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">菜单名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="FNAME" value="${item['FNAME']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">上级菜单</label>
                    <div class="layui-input-inline">
                        <input type="text" name="PNAME" value="${item['PNAME']!=null?item['PNAME']:'无上级菜单'}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">菜单路径</label>
                    <div class="layui-input-inline">
                        <input type="text" name="RESURL" value="${item['RESURL']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">排序</label>
                    <div class="layui-input-inline">
                        <input type="text" name="PRIORITY" value="${item['PRIORITY']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                    <div class="layui-form-mid layui-word-aux">数字越小越向前</div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">层级</label>
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
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">状态</label>
                    <div class="layui-input-inline">
                        <c:if test="${empty item}">
                            <input type="radio" name="STATE" value="1" title="有效" checked>
                            <input type="radio" name="STATE" value="0" title="无效" ${(item['STATE']==0)?'checked':''}>
                        </c:if>
                        <c:if test="${not empty item}">
                            <input type="radio" name="STATE" value="1" title="有效" ${(item['STATE']==1)?'checked':''}>
                            <input type="radio" name="STATE" value="0" title="无效" ${(item['STATE']==0)?'checked':''}>
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label labelCls">类型</label>
                    <div class="layui-input-inline">
                        <c:if test="${empty item}">
                            <input type="radio" name="TYPE" value="0" title="产品" checked >
                            <input type="radio" name="TYPE" value="1" title="接口" >
                        </c:if>
                        <c:if test="${not empty item}">
                            <input type="radio" name="TYPE" value="0" title="产品" ${(item['TYPE']==0)?'checked':''} >
                            <input type="radio" name="TYPE" value="1" title="接口" ${(item['TYPE']==1)?'checked':''} >
                        </c:if>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">叶子节点</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="ISLEAF" value="${(empty item)?'0':(item['ISLEAF'])}" ${item['ISLEAF'] == '1'?'checked':''} disabled="disabled" lay-skin="switch" lay-text="是|否" lay-filter="ISLEAF">
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <%--<div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">权限资源</label>
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
                    <label class="layui-form-label labelCls">别名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="alias" value="${item['alias']}" disabled="disabled" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-block">
                        <textarea name="REMARK" placeholder="请输入备注" class="layui-textarea" disabled="disabled"
                                  autocomplete="off" class="layui-input" maxlength="255">${item['REMARK']}</textarea>
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
        </form>
</div>
</body>
<script>
    layui.use('form', function(){
        var form = layui.form;

        // 遍历name=actionType的多选框、赋值
        $("input:checkbox[name='actionType']").each(function() {
            /*console.log("value:"+$(this).val());*/
            //获取多复选框赋值
            var actionType = '${item['actionType']}';
            var at = actionType.split(",");
            for (i=0;i<at.length ;i++ ){
                at[i]==$(this).val()?$(this).attr("checked",""):"";
            }
            form.render();

            setTimeout(function () {//延迟1秒渲染多复选框
                //设置只读
                $("input:checkbox[name='actionType']").attr("disabled","disabled");
                $("input:radio[name='TYPE']").attr("disabled","disabled");
                $("input:radio[name='STATE']").attr("disabled","disabled");
            }, 1000);
        });
    });
</script>
</html>
