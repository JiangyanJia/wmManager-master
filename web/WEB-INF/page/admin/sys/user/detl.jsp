<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jspf/header.jspf" %>
    <title>详情</title>
</head>
<body>
<c:set var="item" value="${requestScope['@getSingle']}"></c:set>
<form class="layui-form" action="" id="detl">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>用户基本信息</legend>
    </fieldset>
    <div class="layui-form-item" style="height: 150px">
        <label class="layui-form-label">用户头像</label>
        <div class="layui-input-block">
            <div class="layui-upload-list">
                <img class="layui-upload-img" style="float:left;"
                     src="<c:choose><c:when test="${item.img != '' && item.img != null}">${sysconfig.defimgservice}/${item['img']}!md</c:when><c:otherwise>${BASE}/css/cbs/np.jpg</c:otherwise></c:choose>"
                     value="${item['img']}" id="img1">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">组织机构</label>
            <div class="layui-input-inline">
                <input type="text" name="orgName" value="${item['orgName']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">角色类型</label>
            <div class="layui-input-inline">
                <input type="text" name="stype" value="${item['stype']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">账号</label>
            <div class="layui-input-inline">
                <input type="text" name="uname" value="${item['uname']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">真实姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="rname" value="${item['rname']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">密码</label>
            <div class="layui-input-inline">
                <input type="text" name="passwd" value="${item['passwd']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">电话号码</label>
            <div class="layui-input-inline">
                <input type="text" name="tel" value="${item['tel']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">电子邮箱</label>
            <div class="layui-input-inline">
                <input type="text" name="email" value="${item['email']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">创建时间</label>
            <div class="layui-input-inline">
                <input type="text" name="cdate" value="${item['cdate']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">最后登陆时间</label>
            <div class="layui-input-inline">
                <input type="text" name="lst_date" value="${item['lst_date']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">最后修改时间</label>
            <div class="layui-input-inline">
                <input type="text" name="edate" value="${item['edate']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">最后登陆IP</label>
            <div class="layui-input-inline">
                <input type="text" name="lst_ip" value="${item['lst_ip']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">地址</label>
            <div class="layui-input-inline">
                <input type="text" name="address" value="${item['address']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label">是否启用</label>
            <div class="layui-input-inline">
                <input type="checkbox" name="stat"
                       value="${(empty item)?'0':(item['stat'])}" ${item['stat'] == '1'?'checked':''} lay-skin="switch"
                       lay-text="是|否" lay-filter="stat">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-inline">
                <textarea name="remark" class="layui-textarea" disabled="disabled">${item['remark']}</textarea>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">QQ</label>
            <div class="layui-input-inline">
                <input type="text" name="qq" value="${item['qq']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-block">
            <label class="layui-form-label labelCls">微信</label>
            <div class="layui-input-inline">
                <input type="text" name="wechat" value="${item['wechat']}" disabled="disabled" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
    </div>
</form>
</body>
<script>
    layui.use('form', function () {
        var form = layui.form;
    });
</script>
</html>
