<!--
Author: tangshuai
-->
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>登录-旅游平台</title>
    <link href="${BASE}/font-awesome/font-awesome.css" rel="stylesheet"/>
    <link href="${BASE}/login/login.css" rel="stylesheet"/>
    <link href="${BASE}/sideshow/css/normalize.css" rel="stylesheet"/>
    <link href="${BASE}/sideshow/css/demo.css" rel="stylesheet"/>
    <link href="${BASE}/sideshow/css/component.css" rel="stylesheet"/>
    <script src="${BASE}/sideshow/js/html5.js"></script>
    <link href="${BASE}/layui/v2.4/css/layui.css" rel="stylesheet"/>
    <link href="${BASE}/statics/plugins/font-awesome/css/font-awesome.css" rel="stylesheet"/>
    <link href="${BASE}/layui/v2.4/css/verify.css" rel="stylesheet"/>
    <script src="${BASE}/js/common/jquery-3.2.1.min.js"></script>
    <script src="${BASE}/layui/v2.4/verify.js"></script>
    <script src="${BASE}/layui/v2.4/layui.js"></script>
    <script>
        if (window != window.top)
            top.location.href = self.location.href;
    </script>
    <style>
        body {
            font-size: 14px !important;
        }

        canvas {
            position: absolute;
            z-index: -1
        }

        .kit-login-box header h1 {
            line-height: normal
        }

        .kit-login-box header {
            height: auto
        }

        .content {
            position: relative
        }

        .codrops-demos {
            position: absolute;
            bottom: 0;
            left: 40%;
            z-index: 10
        }

        .codrops-demos a {
            border: 2px solid hsla(0, 0%, 95%, .41);
            color: hsla(0, 0%, 100%, .51)
        }

        .kit-login-main .layui-form-item input, .kit-pull-right button {
            background-color: transparent;
            color: #fff
        }

        .kit-login-main .layui-form-item input::-webkit-input-placeholder {
            color: #fff
        }

        .kit-login-main .layui-form-item input:-moz-placeholder, .kit-login-main .layui-form-item input::-moz-placeholder {
            color: #fff
        }

        .kit-login-main .layui-form-item input:-ms-input-placeholder {
            color: #fff
        }

        .kit-pull-right button:hover {
            border-color: #37b7e7;
            color: #37b7e7
        }

        .verify-msg {
            color: #000
        }

        .icon-right:before {
            color: #fff;
        }

        .verify-bar-area {
            width: 100%
        }

        .layui-form-select .layui-input, .layui-input, .layui-input {
            height: 40px !important;
            line-height: 40px !important;
            color: #fff !important;
            font-size: 14px !important;
        }

        .kit-login-main .layui-form-item input, .kit-pull-right button {
            color: #333 !important;
        }

        .layui-form-item {
            margin-bottom: 19px;
        }

        input:-webkit-autofill, textarea:-webkit-autofill, select:-webkit-autofill {
            -webkit-text-fill-color: #333 !important;
            -webkit-box-shadow: 0 0 0px 1000px transparent inset !important;
            background-color: transparent;
            background-image: none;
            transition: background-color 50000s ease-in-out 0s;
            /*//背景色透明  生效时长  过渡效果  启用时延迟的时间*/
        }

        input {
            background-color: transparent;
        }

        .layui-form-item img:hover {
            position: relative;
            transform: scale(1.0);
        }
    </style>
</head>
<body class="kit-login-bg">
<div class="container">
    <div class="content">
        <div id="large-header" class="large-header">
            <div style="height:479px;">
                <img src="${BASE}/sideshow/img/loginBgImg.png" style="width:100%;max-width:100%;height:479px;"/>
            </div>
            <canvas id="demo-canvas"></canvas>
            <div class="kit-login-box">
                <header>
                    <h1>旅游平台</h1>
                </header>
                <div class="kit-login-main">
                    <form action="/" class="layui-form" method="post">
                        <div class="layui-form-item">
                            <label class="kit-login-icon">
                                <span>用户id：</span>
                            </label>
                            <input type="text" name="userid" id="userid" lay-verify="userid" autocomplete="off" style="padding-left: 80px;"
                                   placeholder="请输入用户id" class="layui-input">
                        </div>
                        <div class="layui-form-item">
                            <label class="kit-login-icon">
                                <span>密码：</span>
                            </label>
                            <input type="password" name="password" id="password" lay-verify="password"
                                   autocomplete="off" placeholder="请输入密码" class="layui-input">
                        </div>
                        <div class="layui-form-item">
                            <label class="kit-login-icon">
                                <span>验证码：</span>
                            </label>
                            <div class="" style="width:150px;float:left;display:inline">
                                <input type="text" name="verCode" id="verCode" lay-verify="code" autocomplete="off"
                                       class="layui-input" style="width:150px;padding-left:60px" placeholder="请输入验证码">
                            </div>
                            <div style="width:130px;float:right;display: inline;">
                                <img src="" onclick="refreshCode()" id="codeImg"
                                     style="width:100%;border:1px solid rgb(230, 230, 230);border-radius: 3px;height:40px;">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div>
                                <button class="layui-btn-primary login_Btn" lay-submit lay-filter="login">
                                    登录
                                </button>
                            </div>
                            <div class="kit-clear"></div>
                        </div>
                    </form>
                </div>
                <footer>
                    <!--<p>KIT ADMIN Â© <a href="http://blog.zhengjinfan.cn" style="color:white; font-size:18px;" target="_blank">www.zhengjinfan.cn</a></p>-->
                </footer>
            </div>
        </div>
    </div>
</div>

<script src="${BASE}/sideshow/js/TweenLite.min.js"></script>
<script src="${BASE}/sideshow/js/EasePack.min.js"></script>
<script src="${BASE}/sideshow/js/rAF.js"></script>
<script src="${BASE}/sideshow/js/demo-1.js"></script>

<script>
    $(function () {
        refreshCode();
    });

    var code = 2;
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer, $ = layui.jquery, form = layui.form;
        //清理左侧菜单缓存
        var index = layer.load(2, {
            shade: [0.3, '#333']
        });
        //自定义验证规则
        form.verify({
            userid: function (val) {
                if (val.length == 0) {
                    return '请输入用户id';
                }
            }, password: function (val) {
                if (val.length == 0) {
                    return '请输入用户密码';
                }
            }
        });
        $(window).on('load', function () {
            localStorage.removeItem("sysUsrType");
            layer.close(index);
            form.on('submit(login)', function (data) {
                var loadIndex = layer.load(2, {
                    shade: [0.3, '#333']
                });
                $.get("${BASE}/checkCode?inputStr=" + $("#verCode").val(), function (e) {
                    if (e == "true") {
                        var reg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
                        var pwd = $("#password").val();
                        if (!reg.test(pwd)) {
                            loadIndex && layer.close(loadIndex);
                            layer.msg("密码有误，长度至少6~18位且必须包含一个英文和一个数字");
                            refreshCode();
                            $("#verCode").val('');
                            return false;
                        } else {
                            /*$.post("${BASE}/data/login/loginAuthz", data.field, function (res2) {
                                console.log("login:"+JSON.stringify(res2));
                                if (res2.err == 0) {
                                    console.log("token:"+res2.token);
                                    //localStorage.setItem("storageToken", res2.token);
                                    data.field.utoken=res2.token;
                                    data.field.ftype='func';*/
                                    /*$.post("${BASE}/data/login/loginClzz2", data.field, function (res) {*/
                                     $.post("${BASE}/func/login/loginClzz", data.field, function (res) {
                                        if(res.code==-1){
                                            loadIndex && layer.close(loadIndex);
                                            layer.msg(res.msg);
                                            return false;
                                        }
                                        if (res.err == -1) {
                                            loadIndex && layer.close(loadIndex);
                                            layer.msg("账号密码有误，请重新输入");
                                            refreshCode();
                                            $("#verCode").val('');
                                            return false;
                                        }if(res.err == 11){
                                            loadIndex && layer.close(loadIndex);
                                            layer.msg('密码有误，长度至少6~18位且必须包含一个英文和一个数字');
                                            refreshCode();
                                            $("#verCode").val('');
                                            return false;
                                        }if(res.err == 402){
                                            loadIndex && layer.close(loadIndex);
                                            if(res.info.indexOf("未通过身份认证")!=-1){
                                                layer.msg("账号或密码有误，请重新输入。");
                                            }else {
                                                layer.msg(res.info + ",登录失败。");
                                            }
                                            refreshCode();
                                            $("#verCode").val('');
                                            return false;
                                        } else {
                                            //localStorage.setItem("sysUsrType", JSON.parse(res.err).stype);
                                            //sessionStorage.setItem('$BASE', "${BASE}");
                                            //localStorage.defimgservice="${sysconfig.defimgservice}";
                                            setTimeout(function(){
                                                window.location.href = "${BASE}/page/index/showIndex";
                                            },1000);
                                        }
                                    }, 'json');
                                /*}else if(res2.err == 402||res2.err == 401){
                                    loadIndex && layer.close(loadIndex);
                                    if(res2.info.indexOf("未通过身份认证")!=-1){
                                        layer.msg("账号或密码有误，请重新输入。");
                                    }else {
                                        layer.msg(res2.info + ",登录失败。");
                                    }
                                    refreshCode();
                                    $("#verCode").val('');
                                }else{
                                    loadIndex && layer.close(loadIndex);
                                    layer.msg("登录失败，请重新输入。");
                                    refreshCode();
                                    $("#verCode").val('');
                                    return false;
                                }
                            }, 'json');*/
                        }
                    } else {
                        loadIndex && layer.close(loadIndex);
                        layer.msg("请输入正确的验证码");
                        refreshCode();
                        $("#verCode").val('');
                        return false;
                    }
                });
                return false;
            });
        }());
    });
    $('#mpanel1').slideVerify({
        type: 1, //类型
        vOffset: 5, //误差量，根据需求自行调整
        barSize: {
            width: '100%',
            height: '40px',
        },
        ready: function () {
        },
        success: function () {
            code = 2;
        },
        error: function () {
        }
    });

    //刷新验证码
    function refreshCode() {
        var codeImg = document.getElementById("codeImg");
        codeImg.src = "${BASE}/authCode?s=" + new Date().getTime();
    }
</script>
</body>
</html>