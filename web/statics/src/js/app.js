layui.define(['element', 'nprogress', 'form', 'table', 'loader', 'tab', 'navbar', 'onelevel', 'laytpl', 'spa'], function (exports) {
    var $ = layui.jquery,
        element = layui.element,
        layer = layui.layer,
        _win = $(window),
        _doc = $(document),
        _body = $('.kit-body'),
        form = layui.form,
        table = layui.table,
        loader = layui.loader,
        navbar = layui.navbar,
        _componentPath = 'components/',
        spa = layui.spa;
    var app = {
        hello: function (str) {
            layer.alert('Hello ' + (str || 'test'));
        },
        config: {
            type: 'iframe'
        },
        set: function (options) {
            var that = this;
            $.extend(true, that.config, options);
            return that;
        },
        init: function () {
            var that = this,
                _config = that.config;
            if (_config.type === 'iframe') {

                //处理顶部一级菜单
                var onelevel = layui.onelevel;
                if (onelevel.hasElem()) {
                    var sysUsrType = localStorage.getItem("sysUsrType");
                    var lurl = "../../data/index/onelevelList";
                    var turl = "../../data/index/menulist?pid=";
                    /*if (sysUsrType == 1) {
                        lurl = "../../data/funMenu/onelevelListAdmin";
                        turl = "../../data/funMenu/navberListAdmin?pid=";
                    }*/
                    /*var storageToken = localStorage.getItem("storageToken");
                    var lurl = "../../data/index/onelevelListAuthz?utoken="+storageToken;
                    var turl = "../../data/index/menulistAuthz?utoken="+storageToken+"&pid=";*/
                    onelevel.set({
                        elem: '#oneLevel',
                        remote: {
                            url: lurl //远程地址
                        },
                        onClicked: function (id) {
                            navbar.set({
                                remote: {
                                    url: turl + id
                                }, renderAfter: function (e) {
                                    e.find("a[suri]").eq(0).click();
                                }
                            }).render(function (data) {
                                var _side = $(document).find('div.kit-side');
                                $("#container").height($(window).height() - 60).
                                width($(window).width() - $(".layui-side-scroll").width() - 20);
                                $("#container").attr("src", data.url);
                            });
                        },
                        renderAfter: function (elem) {
                            elem.find('li').eq(0).click(); //模拟点击第一个
                        }
                    }).render();

                }
            }

            // ripple start
            var addRippleEffect = function (e) {
                // console.log(e);
                layui.stope(e)
                var target = e.target;
                if (target.localName !== 'button' && target.localName !== 'a')
                    return false;
                var rect = target.getBoundingClientRect();
                var ripple = target.querySelector('.ripple');
                if (!ripple) {
                    ripple = document.createElement('span');
                    ripple.className = 'ripple'
                    ripple.style.height = ripple.style.width = Math.max(rect.width, rect.height) + 'px'
                    target.appendChild(ripple);
                }
                ripple.classList.remove('show');
                var top = e.pageY - rect.top - ripple.offsetHeight / 2 - document.body.scrollTop;
                var left = e.pageX - rect.left - ripple.offsetWidth / 2 - document.body.scrollLeft;
                ripple.style.top = top + 'px'
                ripple.style.left = left + 'px'
                ripple.classList.add('show');
                return false;
            }
            document.addEventListener('click', addRippleEffect, false);
            // ripple end

            return that;
        }
    };

    //输出test接口
    exports('app', app);
});
