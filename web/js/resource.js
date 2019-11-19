layui.use(['form', 'upload', 'element', 'layedit', 'laydate', 'layer'], function () {
    var form = layui.form, upload = layui.upload, layer = layui.layer, laydate = layui.laydate,
        element = layui.element, layedit = layui.layedit;

    form.on('select(sub_type)', function (data) {
        $("#extend_div").html("");
        var cul_val = data.value;
        reloadData(cul_val,"");
    });

    function reloadData(value,obj){
        //加载修改对象信息
        var extend_info = obj.extend_info==undefined?"":obj.extend_info;
        var typeValue = value;
        //是否必填符号
        var required_flag = (obj!="")?(optionType=='edit'?'<span class="required-flag"></span>':''):'<span class=\"required-flag\"></span>';
        if(typeValue=="hydrant"){//消防栓
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"yyyy-MM-dd\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "   </div>\n" +
                " </div>")
            //初始化化日期
            loadDate("build")
        }else
        if(typeValue=="fire_extinguisher"){//灭火器
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备类型</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"device_type\" id=\"device_type\" lay-verify=\"required\">\n" +
                "           <option value=\"\">请选择</option>\n" +
                /*"           <option value='1' "+(extend_info.device_type=='1'?'selected=""':'')+">干粉灭火器</option>\n" +
                "           <option value='2' "+(extend_info.device_type=='2'?'selected=""':'')+">泡沫灭火器</option>\n" +
                "           <option value='3' "+(extend_info.device_type=='3'?'selected=""':'')+">二氧化碳灭火器</option>\n" +*/
                "       </select>"+
                "   </div>\n" +
                " </div>"+
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"有效期</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"validity_date\" name=\"validity_date\" value='"+(extend_info.validity_date!=undefined?extend_info.validity_date:'')+"' placeholder=\"请输入有效期\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"
            )
            loadDate("validity_date")
            reloadTypeData("device_type","data/sysparams/getParamsList?code=device_type","请选择设备类型",extend_info.device_type);

        }else
        if(typeValue=="recovery_vehicle"){//recovery_vehicle 救援车辆
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"线路</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"line\" value='"+(extend_info.line!=undefined?extend_info.line:'')+"' placeholder=\"请输入线路\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "   </div>\n" +
                " </div>"
            )
        }else
        if(typeValue=="shelter"){//shelter 避难场所
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"最大承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"max_capacity\" value='"+(extend_info.max_capacity!=undefined?extend_info.max_capacity:'')+"' placeholder=\"请输入最大承载量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最优承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"fit_capacity\" value='"+(extend_info.fit_capacity!=undefined?extend_info.fit_capacity:'')+"' placeholder=\"请输入最优承载量\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "   </div>\n" +
                " </div>"
            )
            loadDate("build")
            loadDate("rebuild")
        }

        //智能设备
        if(typeValue=="camera"){//摄像头
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">设备IP</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"ip\" value='"+(extend_info.ip!=undefined?extend_info.ip:'')+"' placeholder=\"请输入设备IP\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"url</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"url\" value='"+(extend_info.url!=undefined?extend_info.url:'')+"' placeholder=\"请输入url\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">安装时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"setupTime\" name=\"setupTime\" value='"+(extend_info.setupTime!=undefined?extend_info.setupTime:'')+"' placeholder=\"请选择安装时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            loadDate("setupTime")
        }else
        if(typeValue=="outdoors"){//户外大屏
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备IP</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"ip\" value='"+(extend_info.ip!=undefined?extend_info.ip:'')+"' placeholder=\"请输入设备IP\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"分辨率</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"resolution_ratio\" value='"+(extend_info.resolution_ratio!=undefined?extend_info.resolution_ratio:'')+"' placeholder=\"请输入分辨率\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">安装时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"setupTime\" name=\"setupTime\" value='"+(extend_info.setupTime!=undefined?extend_info.setupTime:'')+"' placeholder=\"请选择安装时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +

                " </div>"+
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"尺寸</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"dimensions\" value='"+(extend_info.dimensions!=undefined?extend_info.dimensions:'')+"' placeholder=\"请输入尺寸\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"
            )
            loadDate("setupTime")
        }else
        if(typeValue=="broadcast"||typeValue=="charging_pile"||typeValue=="smart_pole"){//公共广播、充电桩、智能杆
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"设备编号</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"code\" value='"+(obj.code!=undefined?obj.code:'')+"' placeholder=\"请输入设备编号\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">安装时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"setupTime\" name=\"setupTime\" value='"+(extend_info.setupTime!=undefined?extend_info.setupTime:'')+"' placeholder=\"请选择安装时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            loadDate("setupTime")
        }

        //基础设施
        if(typeValue=="parking"){//停车场
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"可用总车位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"num\" value='"+(extend_info.num!=undefined?extend_info.num:'')+"' placeholder=\"请输入可用总车位数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"微型车车位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"mini_nun\" value='"+(extend_info.mini_nun!=undefined?extend_info.mini_nun:'')+"' placeholder=\"请输入微型车车位数\" autocomplete=\"off\" class=\"layui-input\" >\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"大巴车车位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"bus_nun\" value='"+(extend_info.bus_nun!=undefined?extend_info.bus_nun:'')+"' placeholder=\"请输入大巴车车位数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"停车场类型</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"ptype\" id=\"ptype\" lay-verify=\"required\">\n" +
                // "           <option value=\"\">请选择类型</option>\n" +
                // "           <option value='0' "+(extend_info.ptype=='0'?'selected=""':'')+">普通</option>\n" +
                // "           <option value='1' "+(extend_info.ptype=='1'?'selected=""':'')+">智慧</option>\n" +
                "       </select>"+
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"开放时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"busi_time\" name=\"busi_time\" value='"+(extend_info.busi_time!=undefined?extend_info.busi_time:'')+"' placeholder=\" - \" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            //渲染日期
            loadHours("busi_time");
            loadDate("build");
            loadDate("rebuild");
            //渲染下拉选项
            reloadTypeData("ptype","data/sysparams/getParamsList?code=ptype","请选择类型",extend_info.ptype);
        }else
        if(typeValue=="toilet"){//厕所
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"可用总厕位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"num\" value='"+(extend_info.num!=undefined?extend_info.num:'')+"' placeholder=\"请输入可用总厕位数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"女厕位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"female\" value='"+(extend_info.female!=undefined?extend_info.female:'')+"' placeholder=\"请输入女厕位数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"男厕位数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"male\" value='"+(extend_info.male!=undefined?extend_info.male:'')+"' placeholder=\"请输入男厕位数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"男便池数</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"murinal\" value='"+(extend_info.murinal!=undefined?extend_info.murinal:'')+"' placeholder=\"请输入男便池数\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"有无第三卫生间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"third\" id=\"third\" lay-verify=\"required\">\n" +
                "           <option value=\"\">请选择</option>\n" +
                "           <option value='0' "+(extend_info.third=='0'?'selected=""':'')+">无</option>\n" +
                "           <option value='1' "+(extend_info.third=='1'?'selected=""':'')+">有</option>\n" +
                "       </select>"+
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"第三卫生间数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"third_num\" value='"+(extend_info.third_num!=undefined?extend_info.third_num:'')+"' placeholder=\"请输入第三卫生间数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"有无母婴室</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"mother\" id=\"mother\" lay-verify=\"required\">\n" +
                "           <option value=\"\">请选择</option>\n" +
                "           <option value='0' "+(extend_info.mother=='0'?'selected=""':'')+">无</option>\n" +
                "           <option value='1' "+(extend_info.mother=='1'?'selected=""':'')+">有</option>\n" +
                "       </select>"+
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"母婴室数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"mother_num\" value='"+(extend_info.mother_num!=undefined?extend_info.mother_num:'')+"' placeholder=\"请输入母婴室数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"有无儿童专用</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"kids\" id=\"kids\" lay-verify=\"required\">\n" +
                "           <option value=\"\">请选择</option>\n" +
                "           <option value='0' "+(extend_info.kids=='0'?'selected=""':'')+">无</option>\n" +
                "           <option value='1' "+(extend_info.kids=='1'?'selected=""':'')+">有</option>\n" +
                "       </select>"+
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"儿童专用数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"kids_num\" value='"+(extend_info.kids_num!=undefined?extend_info.kids_num:'')+"' placeholder=\"请输入儿童专用数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"有无残疾人专用</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"disabled\" id=\"disabled\" lay-verify=\"required\">\n" +
                "           <option value=\"\">请选择</option>\n" +
                "           <option value='0' "+(extend_info.disabled=='0'?'selected=""':'')+">无</option>\n" +
                "           <option value='1' "+(extend_info.disabled=='1'?'selected=""':'')+">有</option>\n" +
                "       </select>"+
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"残疾人专用数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"disabled_num\" value='"+(extend_info.disabled_num!=undefined?extend_info.disabled_num:'')+"' placeholder=\"请输入残疾人专用数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"厕所类型</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"ttype\" id=\"ttype\" lay-verify=\"required\">\n" +
                // "           <option value=\"\">请选择</option>\n" +
                // "           <option value='0' "+(extend_info.ttype=='0'?'selected=""':'')+">普通</option>\n" +
                // "           <option value='1' "+(extend_info.ttype=='1'?'selected=""':'')+">智慧</option>\n" +
                "       </select>"+
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"开放时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"busi_time\" name=\"busi_time\" value='"+(extend_info.busi_time!=undefined?extend_info.busi_time:'')+"' placeholder=\" - \" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\" >\n" +
                "  </div>\n" +
                " </div>"
            )
            //渲染日期
            loadHours("busi_time")
            loadDate("build")
            loadDate("rebuild")
            //渲染下拉选项
            reloadTypeData("ttype","data/sysparams/getParamsList?code=ptype","请选择类型",extend_info.ttype);
        }else
        if(typeValue=="command_center"){//指挥中心
            $("#extend_div").append(
                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"显示屏数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"display_num\" value='"+(extend_info.display_num!=undefined?extend_info.display_num:'')+"' placeholder=\"请输入显示屏数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"工位数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"station_nun\" value='"+(extend_info.station_nun!=undefined?extend_info.station_nun:'')+"' placeholder=\"请输入工位数量\" autocomplete=\"off\" class=\"layui-input\" >\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"电脑数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"computer_num\" value='"+(extend_info.computer_num!=undefined?extend_info.computer_num:'')+"' placeholder=\"请输入电脑数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"最大承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"max_capacity\" value='"+(extend_info.max_capacity!=undefined?extend_info.max_capacity:'')+"' placeholder=\"请输入最大承载量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +

                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">最优承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"fit_capacity\" value='"+(extend_info.fit_capacity!=undefined?extend_info.fit_capacity:'')+"' placeholder=\"请输入最优承载量\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "   </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"开放时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"busi_time\" name=\"busi_time\" value='"+(extend_info.busi_time!=undefined?extend_info.busi_time:'')+"' placeholder=\" - \" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            //渲染日期
            loadHours("busi_time")
            loadDate("build")
            loadDate("rebuild")
        }else
        if(typeValue=="motor_room"){//接入机房
            $("#extend_div").append(

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"电脑数量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"computer_num\" value='"+(extend_info.computer_num!=undefined?extend_info.computer_num:'')+"' placeholder=\"请输入电脑数量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            //渲染日期
            loadDate("build")
            loadDate("rebuild")
        }else
        if(typeValue=="touristd_distribution_center"||typeValue=="door"){//游客集散中心、出入口
            $("#extend_div").append(

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"最大承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"max_capacity\" value='"+(extend_info.max_capacity!=undefined?extend_info.max_capacity:'')+"' placeholder=\"请输入最大承载量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最优承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"fit_capacity\" value='"+(extend_info.fit_capacity!=undefined?extend_info.fit_capacity:'')+"' placeholder=\"请输入最优承载量\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "   </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            loadDate("build")
            loadDate("rebuild")
        }else
        if(typeValue=="gate"){//闸机
            $("#extend_div").append(

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"最大承载量</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" name=\"max_capacity\" value='"+(extend_info.max_capacity!=undefined?extend_info.max_capacity:'')+"' placeholder=\"请输入最大承载量\" autocomplete=\"off\" class=\"layui-input\" lay-verify=\"required\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">"+required_flag+"闸机类型</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <select name=\"gate_type\" id=\"gate_type\" lay-verify=\"required\">\n" +
                // "           <option value=\"\">请选择</option>\n" +
                // "           <option value='1' "+(extend_info.gate_type=='1'?'selected=""':'')+">刷卡</option>\n" +
                // "           <option value='2' "+(extend_info.gate_type=='2'?'selected=""':'')+">刷脸</option>\n" +
                // "           <option value='0' "+(extend_info.gate_type=='0'?'selected=""':'')+">其他</option>\n" +
                "       </select>"+
                "  </div>\n" +
                " </div>"+

                "<div class=\"layui-form-item\">\n" +
                "  <label class=\"layui-form-label\">建设时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"build\" name=\"build\" value='"+(extend_info.build!=undefined?extend_info.build:'')+"' placeholder=\"请选择建设时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                "  <label class=\"layui-form-label\">最近修改时间</label>\n" +
                "  <div class=\"layui-input-inline\">\n" +
                "       <input type=\"text\" id=\"rebuild\" name=\"rebuild\" value='"+(extend_info.rebuild!=undefined?extend_info.rebuild:'')+"' placeholder=\"请选择最近修改时间\" autocomplete=\"off\" class=\"layui-input\">\n" +
                "  </div>\n" +
                " </div>"
            )
            //渲染日期
            loadDate("build")
            loadDate("rebuild")
            //渲染下拉选项
            reloadTypeData("gate_type","data/sysparams/getParamsList?code=gate_type","请选择类型",extend_info.gate_type);
        }
        form.render("select")
    }

    function loadDate(id){
        //初始化化日期
        laydate.render({
            elem: '#'+id,
            type: 'date',
            format: 'yyyy-MM-dd'
        });
    }
    function loadHours(id){
        //初始化化日期
        laydate.render({
            elem: '#'+id
            ,type: 'time'
            ,range: true
            ,format: 'HH:mm'
            ,btns: ['clear', 'confirm']
        });
    }

    var objdata = null;
    if(redata!="")
    objdata = JSON.parse(redata);

    if(objdata!=null){
        var cul_val = objdata.sub_type;
        reloadData(cul_val,objdata);
    }
});