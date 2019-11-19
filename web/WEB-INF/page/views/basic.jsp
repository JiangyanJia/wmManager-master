<%-- 
    Document   : addUser
    Created on : 2017-12-23, 11:21:44
    Author     : HMQ
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>
        <title>基本信息</title>
    </head>
    <body class="layui-layout-body">
        <blockquote class="layui-elem-quote">
            <b>基本资料</b>
        </blockquote>
        <c:set var="item" value="${requestScope['@dmm']}"></c:set>
            <form class="layui-form layui-form-pane" action="" style="margin:30px;">
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                    <legend>基本信息</legend>
                </fieldset>
                <div class="layui-form-item">
                    <label class="layui-form-label">真实姓名</label>
                    <div class="layui-input-block">
                        <input type="text" name="rname" value="${item['rname']}" lay-verify="realname" autocomplete="off" placeholder="请输入您的真实姓名" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">用户账号</label>
                <div class="layui-input-block">
                    <input type="text" name="uname" value="${item['uname']}"  lay-verify="usrname" placeholder="请输入您的用户账号" autocomplete="off" class="layui-input" disabled>
                </div>
            </div>
            <c:if test="${param.view != 'detail'}">
                <div class="layui-form-item">
                    <label class="layui-form-label">密码</label>
                    <div class="layui-input-block">
                        <input type="password" name="passwd" lay-verify="passwd" value="${item['passwd']}" placeholder="请输入您的密码" autocomplete="off" class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">确认密码</label>
                    <div class="layui-input-block">
                        <input type="password" name="repasswd" lay-verify="repasswd" value="${item['passwd']}" placeholder="请输入您的确认密码" autocomplete="off" class="layui-input">
                    </div>
                </div>
            </c:if>
            <div class="layui-form-item">
                <label class="layui-form-label">手机号码</label>
                <div class="layui-input-block">
                    <input type="text" name="tel" value="${item['tel']}" lay-verify="tel" placeholder="请输入您的手机号码" autocomplete="off" class="layui-input" maxlength="11">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">QQ</label>
                <div class="layui-input-block">
                    <input type="text" name="qq" value="${item['qq']}" placeholder="请输入您的QQ" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">微信号</label>
                <div class="layui-input-block">
                    <input type="text" name="wechat" value="${item['wechat']}" placeholder="请输入您的微信号" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电子邮件</label>
                <div class="layui-input-block">
                    <input type="text" name="email" value="${item['email']}" lay-verify="email" placeholder="请输入您的电子邮件" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">地址</label>
                <div class="layui-input-block">
                    <input type="text" name="address" value="${item['address']}" placeholder="请输入您的地址" autocomplete="off" class="layui-input">
                </div>
            </div>
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                </fieldset>
            <div class="layui-form-item" style="text-align:center;">
                <button class="layui-btn" type="button" lay-submit lay-filter="addUserForm">保存</button>
            </div>
        </form>
        <script>
            layui.use(['form'], function () {
                var form = layui.form;
                var reg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
                form.render();
                //自定义验证规则
                form.verify({
                    rname: function (value) {
                        if (value.length < 2) {
                            return '真实姓名至少得2个字符';
                        }
                    },
                    uname: function (val) {
                        if (val.length < 2) {
                            return '用户账号至少得2个字符';
                        }
                    },
                    passwd: function (value, item) {
                        if (value.length < 6) {
                            return "密码长度不能小于6位";
                        }else{
                            var pw = $("input[name='passwd']").val();
                            if (!reg.test(pw)) {
                                return "密码有误，长度至少6~18位且必须包含一个英文和一个数字";
                            }
                        }
                    },
                    repasswd: function (value, item) {
                        //获取密码
                        var passwd =$('input[name=passwd]').val();
                        var repwd =$('input[name=repasswd]').val();
                        if (passwd!=repwd) {
                            return '两次输入的密码不一致';
                        }else{

                            var pw = $("input[name='repasswd']").val();
                            if (!reg.test(pw)) {
                                return "密码有误，长度至少6~18位且必须包含一个英文和一个数字";
                            }
                        }

                    },
                    tel: [/^1(3|4|5|7|8)\d{9}$/, '手机号码格式不正确'],
                    email: function (val) {
                        if (val!=null) {
                            var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                            if (!myreg.test(val)) {
                                return '您的电子邮箱格式不正确';
                            }
                        }
                    }
                });
                //监听提交
                form.on('submit(addUserForm)', function (data) {
                    layer.load(2);
                    var uname='${sysUsrId}';
                    $.post("${BASE}/func/user/updatePersonal?uid=${item['uid']}&uname=" + uname, data.field, function (resp) {
                                    if (resp.err == "true") {

                                        setTimeout(function () {
                                            layer.msg("保存成功");
                                            layer.closeAll('loading');
                                        }, 2000);
                                    } else {
                                        layer.msg("保存失败");
                                        layer.closeAll('loading');
                                        return false;
                                    }
                                }, "json");
                                return false;
                            });
                        });
        </script>
       <%@include file="/WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
