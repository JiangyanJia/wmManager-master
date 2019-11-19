/* global layer */

/**
 * @author cangyue
 * @version v1.0.1
 * */
"use strict";
var _ = function (selector) {
    if (selector === undefined || selector === null || selector === "") {
        return;
    }
    var object = {};
    var config = {
        "node": undefined,
        "doc": document
    };
    var Node = function () {
        config.node = config.doc.querySelectorAll(selector);
        if (typeof config.node === undefined) {
            config.node = [];
            return;
        } else {
            if (config.node.length === 1) {
                config.node = config.node[0];
            }
        }
        return config.node;
    };
    Node();

    var getValue = function () {
        switch (config.node.type) {
            case undefined :
                if (typeof config.node === 'object') {
                    var val;
                    for (var x = 0; x < config.node.length; x++) {
                        switch (config.node[x].type) {
                            case 'checkbox':
                                if (config.node[x].checked === true) {
                                    if (val === undefined) {
                                        val = config.node[x].value;
                                    } else {
                                        val = val + ',' + config.node[x].value;
                                    }
                                }
                                break;
                            case 'radio':
                                if (config.node[x].checked === true) {
                                    return config.node[x].value;
                                }
                                break;
                            default :
                                return undefined;
                                break;
                        }
                    }
                    return val;
                }
                break;
            default :
                return config.node.value;
        }
    };
    var setValue = function (val) {
        switch (config.node.type) {
            case undefined :
                if (typeof config.node === 'object') {
                    for (var x = 0; x < config.node.length; x++) {
                        switch (config.node[x].type) {
                            case 'checkbox':
                                var box = val.split(',');
                                for (var y = 0; y < box.length; y++) {
                                    if (config.node[x].value == box[y]) {
                                        config.node[x].checked = true;
                                    }
                                }
                                break;
                            case 'radio':
                                if (config.node[x].value == val) {
                                    config.node[x].checked = true;
                                }
                                break;
                            default :
                                return undefined;
                                break;
                        }
                    }
                }
                break;
            default :
                config.node.value = val;
        }
    };

    object.val = function (val) {
        if (!arguments.length) {
            return getValue();
        } else {
            if (val === undefined || val === '') {
                return;
            }
            setValue(val);
        }
    };
    var validate = function (feled) {
        var data = feled.getAttribute("data-limit");
        var val = feled.value;
        var mes = feled.getAttribute("data-message");
        var message = "参数不合法!";
        if (mes !== null && mes !== "" && mes !== undefined) {
            message = mes;
        }
        if (data === 'NOTNULL') {
            if (val === undefined || val === '') {
                mge(message);
                return false;
            }
            return true;
        }
        var formula = / /;
        if (data !== undefined && data !== null && data !== "") {
            if (data.substring(0, 2) === "LM") {
                formula = limitData(data)
            } else {
                formula = RegExp(data)
            }
        }

        if (!formula.test(val)) {
            mge(message);
            return false;
        }
        return true;
    }

    object.getformval = function () {
        var form = config.node;
        var obj = {};
        for (var i = 0; i < form.elements.length; i++) {
            var feled = form.elements[i];
            switch (feled.type) {
                case undefined:
                case 'button':
                case 'file':
                case 'reset':
                case 'submit':
                    break;
                case 'checkbox':
                case 'radio':
                    if (!feled.checked) {
                        break;
                    }
                default:
                    if (obj[feled.name]) {
                        obj[feled.name] = obj[feled.name] + ',' + feled.value;
                    } else {
                        if ((feled.getAttribute("data-switch") === null || feled.getAttribute("data-switch") === 'false')
                                && feled.getAttribute("data-limit") === null) {
                            obj[feled.name] = feled.value;
                        } else {
                            if (validate(feled)) {
                                obj[feled.name] = feled.value;
                            } else {
                                return undefined;
                            }
                        }
                    }
            }
        }
        return obj;
    };

    object.setformval = function (formObject) {
        if (formObject === undefined || typeof formObject !== "object") {
            return;
        }
        var form = config.node;
        for (var i = 0; i < form.elements.length; i++) {
            var feled = form.elements[i];
            var value = formObject[feled.name.toUpperCase()];
            if (value === undefined) {
                continue;
            }
            switch (feled.type) {
                case undefined:
                    continue;
                case 'button':
                    continue;
                case 'file':
                case 'reset':
                    continue;
                case 'submit':
                    continue;
                case 'checkbox':
                    var boxArray = value.split(',');
                    for (var x = 0; x < boxArray.length; x++) {
                        if (boxArray[x] == feled.value) {
                            feled.checked = true;
                        }
                    }
                    break;
                case 'radio':
                    if (feled.value == value) {
                        feled.checked = true;
                    }
                    break;
                default:
                    feled.value = value;
            }
        }
    };

    object.formValidate = function () {
        var form = config.node;
        for (var i = 0; i < form.elements.length; i++) {
            var feled = form.elements[i];
            switch (feled.type) {
                case undefined:
                case 'button':
                case 'file':
                case 'reset':
                case 'submit':
                    break;
                case 'checkbox':
                case 'radio':
                    if (!feled.checked) {
                        break;
                    }
                default:
                    if ((feled.getAttribute("data-switch") === null || feled.getAttribute("data-switch") === 'false')
                            && feled.getAttribute("data-limit") === null) {
                        continue;
                    } else {
                        feled.onblur = function () {
                            validate(this);
                        };
                    }
            }
        }
    };

    var c = 1, suspend = false;
    var mge = function (message) {
        layer.msg(message, {icon: 5, anim: 6});
    };
    object.onclick = function (object) {
        config.node.onclick = object;
    };
    object.onload = function (object) {
        config.node.onload = object;
    };
    object.onunload = function (object) {
        config.node.object.onunload = object;
    };
    object.onblur = function (object) {
        config.node.onblur = object;
    };
    object.onchange = function (object) {
        config.node.onchange = object;
    };
    object.onmouseover = function (object) {
        config.node.onmouseover = object;
    };
    object.onmouseout = function (object) {
        config.node.onmouseout = object;
    };
    object.onmousedown = function (object) {
        config.node.onmousedown = object;
    };
    object.onmouseup = function (object) {
        config.node.onmouseup = object;
    };
    var limitData = function (index) {
        var array = new Array();
        //不为空
        //数字
        array['LMA'] = /^[0-9]*$/;
        //n位的数字
        array['LMB'] = /^\d{n}$/;
        //至少n位的数字
        array['LMC'] = /^\d{n,}$/;
        //m-n位的数字
        array['LMD'] = /^\d{m,n}$/;
        //零和非零开头的数字
        array['LME'] = /^(0|[1-9][0-9]*)$/;
        //Email地址
        array['LMF'] = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
        //手机号码
        array['LMG'] = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|17[0-9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
        //IP地址
        array['LMH'] = /((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))/;
        //邮政编码
        array['LMI'] = /[1-9]\d{5}(?!\d)/;
        //汉字
        array['LMK'] = /^[\u4e00-\u9fa5]{0,}$/;
        //英文和数字
        array['LML'] = /^[A-Za-z0-9]+$/;
        //由数字、26个英文字母或者下划线组成的字符串
        array['LMM'] = /^\w+$/;
        //由26个英文字母组成的字符串
        array['LMN'] = /^[A-Za-z]+$/;
        //电话号码
        array['LMO'] = /^([0-9]|[-])+$/g;
        //身份证号
        array['LMP'] = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
        //帐号是否合法
        array['LMQ'] = /^[a-zA-Z][a-zA-Z0-9_]{4,15}$/;
        //密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)
        array['LMR'] = /^[a-zA-Z]\w{5,17}$/;
        //强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-10之间)
        array['LMS'] = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$/;
        //金额
        array['LMT'] = /^[1-9][0-9]*$/;
        //腾讯QQ
        array['LMU'] = /[1-9][0-9]{4,}/;
        //不包含特殊字符
        array['LMV'] = /^[\u4E00-\u9FA5A-Za-z0-9_]+$/;
        return array[index];
    };
    return object;
};