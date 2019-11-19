<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/jspf/header.jspf" %>

        <title></title>
    </head>
    <style>
        #img1Add{
            display: none;
            margin-top: 76px;
        }
    </style>
    <body style="padding: 10px">
        <c:set var="item" value="${requestScope['@getSingle']}"></c:set>
            <form class="layui-form" action="" id="add">
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
                    <legend>用户基本信息</legend>
                </fieldset>
                <div class="layui-form-item" style="height: 150px">
                    <label class="layui-form-label">用户头像</label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn" id="img">上传图片</button>
                        <div class="layui-upload-list">
                            <img class="layui-upload-img" style="float:left;" src="<c:choose><c:when test="${item.img != '' && item.img != null}">${sysconfig.defimgservice}/${item['img']}!md</c:when><c:otherwise>${BASE}/css/cbs/np.jpg</c:otherwise></c:choose>" value="${item['img']}" id="img1">
                                <p id="imgText"></p>
                            </div>
                                <button  type="button" id="img1Add" class="layui-btn layui-btn-danger" style="<c:if test="${item.img != '' && item.img != null}">display: block</c:if>" onclick="delImage('#img1')">删除</button>
                    </div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-block">
                        <label class="layui-form-label"><span class="required-flag"></span>组织机构</label>
                        <div class="layui-input-inline">
                            <select name="orgId" lay-verify="required" value="${item['orgId']}">
                            <c:forEach items="${requestScope['@org']}" var="sx">
                                <option value="${sx['orgCode']}" ${sx['orgCode'] == item['orgId'] ? 'selected=""' : ''}>${sx['name']}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>角色类型</label>
                    <div class="layui-input-inline">
                        <select name="stype" lay-verify="required" value="${item['stype']}">
                            <c:forEach items="${requestScope['@role']}" var="sx">
                                <option value="${sx['rid']}" ${sx['rid'] == item['stype'] ? 'selected=""' : ''}>${sx['rname']}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>账号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="userid" value="${item['userid']}" lay-verify="required" ${not empty item['userid']?'readonly':''} placeholder="请输入账号" autocomplete="off" class="layui-input"  maxlength="32">
                    </div>
                    <div class="layui-form-mid layui-word-aux">账号,建议为中文拼音</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>用户名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="uname" value="${item['uname']}" lay-verify="required" placeholder="请输入用户名称" autocomplete="off" class="layui-input"  maxlength="32">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>真实姓名</label>
                    <div class="layui-input-inline">
                        <input type="text" name="rname" value="${item['rname']}" lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input"  maxlength="32">
                    </div>
                    <div class="layui-form-mid layui-word-aux"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>密码 </label>
                    <div class="layui-input-inline">
                        <input type="password" name="passwd" value="${item['passwd']}" lay-verify="passwd" placeholder="请输入密码" autocomplete="off" class="layui-input"  maxlength="32">
                    </div>
                    <div class="layui-form-mid layui-word-aux">&nbsp;密码长度6~18位</div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>密码 </label>
                    <div class="layui-input-inline">
                        <input type="password" name="repasswd" value="${item['passwd']}" lay-verify="repasswd" placeholder="请输入密码" autocomplete="off" class="layui-input"  maxlength="32">
                    </div>
                    <div class="layui-form-mid layui-word-aux">&nbsp;密码与第一次输入相同</div>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>电话</label>
                    <div class="layui-input-inline">
                        <input type="text" name="tel" value="${item['tel']}" lay-verify="required" placeholder="请输入电话" autocomplete="off" class="layui-input"  maxlength="15">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>电子邮箱</label>
                    <div class="layui-input-inline">
                        <input type="text" name="email" value="${item['email']}"  placeholder="请输入电子邮箱" autocomplete="off" class="layui-input" lay-verify="email" maxlength="32">
                    </div>
                </div>
            </div>


            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>地址</label>
                    <div class="layui-input-inline">
                        <input type="text" name="address" value="${item['address']}" lay-verify="required" placeholder="请输入地址" autocomplete="off" class="layui-input"  maxlength="100">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"><span class="required-flag"></span>是否启用</label>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="stat" value="${(empty item)?'0':(item['stat'])}" ${item['stat'] == '1'?'checked':''} lay-skin="switch" lay-text="是|否" lay-filter="stat">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"></span>备注</label>
                    <div class="layui-input-block">
                        <textarea name="remark" placeholder="请输入备注" class="layui-textarea">${item['remark']}</textarea>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label"></span>qq</label>
                    <div class="layui-input-inline">
                        <input type="text" name="qq" value="${item['qq']}" placeholder="请输入qq" autocomplete="off" class="layui-input"  maxlength="11">
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-block">
                    <label class="layui-form-label">微信</label>
                    <div class="layui-input-inline">
                        <input type="text" name="wechat" value="${item['wechat']}" placeholder="请输入微信" autocomplete="off" class="layui-input"  maxlength="100">
                    </div>
                </div>
            </div>
            <button class="layui-btn" lay-submit lay-filter="btnSave" id="btnSave" style="display: none"></button>
        </form>

        <script>
            var form;
            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
            function delImage(obj) {
                console.log("点击了");
                $(obj).attr('value', '');
                $(obj).attr('src', '${BASE}/css/cbs/np.jpg');
                var btn = obj + 'Add';
                $(btn).attr('style', 'display:none');
            }
            layui.use(['form', 'upload', 'layer'], function () {
                var form = layui.form, upload = layui.upload, layer = layui.layer;
                //监听开关
                form.on('switch', function (data) {
                    var name = $(data.elem).attr('name');
                    $('input[name=' + name + ']').val(this.checked ? 1 : 0);

                });

                var reg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
                //监听开关
                form.verify({
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

                    }
                });
                var uploadLogo = upload.render({
                    elem: '#img'
                    , url: '${sysconfig.defupservice}'
                    , size: 20480
                    , before: function () {
                        layer.msg('上传中');
                        layer.load(2);
                    }
                    , done: function (res) {
                        //如果上传失败
                        // console.log(res);
                        layer.closeAll('loading');
                        var img = document.getElementById("img1");
                        $("#img1").attr('value', res.path);
                        img.src = '${sysconfig.defimgservice}/' + res.path + "!md";
                        $("#img1Add").attr('style', 'display:block');
                    }
                    , error: function () {
                        layer.closeAll('loading');
                        // console.log("上传失败");
                        var demoText = $('#imgText');
                        demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
                        demoText.find('.demo-reload').on('click', function () {
                            uploadLogo.upload();
                        });
                    }
                });

                form.on('submit(btnSave)', function (data) {

                    var uname='${sysUsrId}';
                    data.field.img = $("#img1").attr("value");
                    <c:if test="${empty item}">
                            data.field.stat = $("input[name='stat']").val();
                            // console.log(data.field);
                            $.post("${BASE}/func/user/insert?addUser=" + uname, data.field, function (resp) {
                                if (resp.check == 'true') {
                                    layer.msg(uname+'登录名称已存在，请重新输入!');
                                    return false;
                                } else {
                                    if (resp.err == 'true') {
                                        layer.msg('新增成功');
                                        parent.layer.close(index);

                                    } else {
                                        layer.msg('新增失败');
                                        return false;
                                    }
                                }
                            }, "json");
                    </c:if>
                    <c:if test="${not empty item}">
                            data.field.stat = $("input[name='stat']").val();
                            $.post("${BASE}/func/user/update?uid=${item['uid']}&lmdfUser=" + uname, data.field, function (resp) {
                                if (resp.err == 'true') {
                                    layer.msg('修改成功')
                                    parent.layer.close(index);
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
                $('#btnSave').click();
                return false;
            }
        </script>
        <%@include file="/WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
