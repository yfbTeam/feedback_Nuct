﻿/// <reference path="AllotTable.js" />
/// <reference path="../public.js" />
/// <reference path="../Common.js" />
/// <reference path="../Common.js" />

var Type = 0;
var CreateUID = '';

var UI_Table =
    {
        PageType: "",
        copy: function (id) {
            layer.confirm('确定要复制？', {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function () {
                CreateUID = login_User.UniqueNo;

                $.ajax({
                    url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
                    type: "post",
                    async: false,
                    dataType: "json",
                    data: { Func: "Copy_Eva_Table", "table_Id": id, "CreateUID": CreateUID },
                    success: function (json) {
                        if (json.result.errMsg == "success") {
                            layer.msg('操作成功!');
                            initdata();
                        }
                    },
                    error: function () {
                        //接口错误时需要执行的
                    }
                });
            });

        },

        //删除表
        delete_table: function (id) {
            layer.confirm('确定要删除？', {
                btn: ['确定', '取消'],//按钮
                title: '操作'
            }, function () {
                $.ajax({
                    url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
                    type: "post",
                    async: false,
                    dataType: "json",
                    data: { Func: "Delete_Eva_Table", Id: id },//组合input标签
                    success: function (json) {
                        //console.log(JSON.stringify(json));
                        if (json.result.errMsg == "success") {
                            layer.msg('操作成功!');
                            initdata();
                        }
                    },
                    error: function () {
                        //接口错误时需要执行的
                    }
                });
            })
        },

        Enable_Eva_Table: function (id, IsEnable) {

            $.ajax({
                url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
                type: "post",
                async: false,
                dataType: "json",
                data: { Func: "Enable_Eva_Table", table_Id: id, IsEnable: IsEnable },//组合input标签
                success: function (json) {
                    //console.log(JSON.stringify(json));
                    if (json.result.errMsg == "success") {
                        layer.msg('操作成功!');
                        initdata();
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        },
        initdataCompleate: function (refdata) { },
        //初始化表格列表
        initdata: function (IsEnable) {
            $.ajax({
                url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
                type: "post",
                async: false,
                dataType: "json",
                data: { Func: "Get_Eva_Table_S", "Type": Type, "CreateUID": CreateUID },
                success: function (json) {

                    retData = json.result.retData;

                    $("#tb_eva").empty();
                    $(".Pagination").remove();
                    retDataCache = retData;
                    retDataCache = Enumerable.From(retDataCache).Where("item=>item.t.IsDelete==0").OrderByDescending('$.t.Id').ToArray();//按Id进行升序排列

                    var PagesMth = 10;
                    if (IsEnable) {
                        retDataCache = Enumerable.From(retDataCache).Where("item=>item.t.IsEnable ==0").OrderByDescending('$.t.Id').ToArray();//按Id进行升序排列
                        PagesMth = 5;
                    }

                    var key = $("#key").val().trim();
                    if (key != "" && key != undefined) {
                        retDataCache = Enumerable.From(retDataCache).Where("item=>item.t.Name.indexOf('" + key + "')>-1").ToArray();
                    }
                    if (retDataCache.length == 0) {
                        nomessage('#tb_eva', 'tr');
                        return;
                    }
                    if (UI_Table.PageType == 'Allot_Add_Table') {
                        UI_Table.fenye(retDataCache.length);
                    }
                    else {
                        $("#item_eva").tmpl(retDataCache).appendTo("#tb_eva");
                        tableSlide();

                    }
                    UI_Table.initdataCompleate(retDataCache);
                    //CheckEventInit();
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        },

        fenye: function (pageCount) {

            $("#test1").pagination(pageCount, {
                callback: UI_Table.PageCallback,
                prev_text: '上一页',
                next_text: '下一页',
                items_per_page: pageSize,
                num_display_entries: 6,//连续分页主体部分分页条目数
                current_page: pageIndex,//当前页索引
                num_edge_entries: 1//两侧首尾分页条目数
            });
        },
        //翻页调用
        PageCallback: function (index, jq) {
            var arrRes = Enumerable.From(retDataCache).Skip(index * pageSize).Take(pageSize).ToArray();

            UI_Table.Data_Display(index * pageSize + 1, arrRes);
        },

        Data_Display: function (index, bindData) {
            reUserinfoByselect = bindData;
            $("#tb_eva").empty();

            if (Enumerable.From(bindData).ToArray().length == 0) {
                nomessage('#tb_eva', 'tr', 25, 320);
                return;
            }
            $("#item_eva").tmpl(bindData).appendTo("#tb_eva");
            tableSlide();
            CheckEventInit();
            //SameCountDealWidth();

        },

    };
//=================================================================================================================================
var UI_Table_Create =
{
    PageType: '', //AddEvalTable 表格设计   SelTabelHead 添加表头
    Type: 0, //1为编辑 其余则视为添加
    head_value: [],//自由表格头部
    Header_Name:null,
    PrepareInit: function () {
        $("#IsScore").click(function () {//计分的情况
            if ($(this).is(":checked")) {
                $('.isscore').show();
            }
            else {
                $('.isscore').hide();
            }
        })
        //------------------存储比例系数----------------------------------------------------
        UI_Table_Create.load_score_parameter();
    },
    load_score_parameter: function () {
        var S_A_P2 = localStorage.getItem('S_A_P2');
        var S_B_P2 = localStorage.getItem('S_B_P2');
        var S_C_P2 = localStorage.getItem('S_C_P2');
        var S_D_P2 = localStorage.getItem('S_D_P2');
        var S_E_P2 = localStorage.getItem('S_E_P2');
        var S_F_P2 = localStorage.getItem('S_F_P2');
        if (S_A_P2 != null && S_A_P2 != undefined) {
            $('#A').val(S_A_P2);
        }
        if (S_B_P2 != null && S_B_P2 != undefined) {
            $('#B').val(S_B_P2);
        }
        if (S_C_P2 != null && S_C_P2 != undefined) {
            $('#C').val(S_C_P2);
        }
        if (S_D_P2 != null && S_D_P2 != undefined) {
            $('#D').val(S_D_P2);
        }
        if (S_E_P2 != null && S_E_P2 != undefined) {
            $('#E').val(S_E_P2);
        }
        if (S_F_P2 != null && S_F_P2 != undefined) {
            $('#F').val(S_F_P2);
        }
    },
    save_score_parameter: function () {
        var S_A_P2 = $('#A').val();
        var S_B_P2 = $('#B').val();
        var S_C_P2 = $('#C').val();
        var S_D_P2 = $('#D').val();
        var S_E_P2 = $('#E').val();
        var S_F_P2 = $('#F').val();
        if (S_A_P2 != null && S_A_P2 != undefined) {
            setItem('S_A_P2', S_A_P2);
        }
        if (S_B_P2 != null && S_B_P2 != undefined) {
            setItem('S_B_P2', S_B_P2);
        }
        if (S_C_P2 != null && S_C_P2 != undefined) {
            setItem('S_C_P2', S_C_P2);
        }
        if (S_D_P2 != null && S_D_P2 != undefined) {
            setItem('S_D_P2', S_D_P2);
        }
        if (S_E_P2 != null && S_E_P2 != undefined) {
            setItem('S_E_P2', S_E_P2);
        }
        if (S_F_P2 != null && S_F_P2 != undefined) {
            setItem('S_F_P2', S_F_P2);
        }
        layer.msg('设置成功');
    },
    //新添节点【自定义表头】
    add_checkItem2: function () {
        var header = Object();
        if (lisss.length == 0) {
            header.Num = 1;
            header.t_Id = 't_' + header.Num;
        }
        else {
            header.Num = lisss[lisss.length - 1].Num + 1;
            header.t_Id = 't_' + header.Num;
        }
        header.title = '新填节点' + header.Num;
        lisss.push(header);
        this.head_value.push(header);
        $("#item_check2").tmpl(header).appendTo("#list");
    },
    /**
    * 失去焦点判断是否是重复数据
    *@param id
    */
    customBlur: function (id) {
        var val = $('#list input[t_id=' + id + ']').val();
        this.Header_Name = this.head_value.find(function (item) {
            if (item.hasOwnProperty('id')) {
                return item.name == val
            } else if (item.hasOwnProperty('t_Id')) {
                return item.t_Id == val
            }
        })
        if (this.Header_Name != null) {
            layer.msg('表头名字有重复，请重新输入！');
            return false;
        }
    },
    /**
     * 移除表头
     * @param id
     */
    removeTableHeader: function (id) {
        this.head_value = this.head_value.filter(function (item){
            return item.id!=id
        })
        $('#list li[t_id=' + id + ']').remove();
    },
     /**
     * 移除自定义表头
     * @param id
     */
    removeCustomHeader: function (id) {
        this.head_value = this.head_value.filter(function (item) {
            return item.t_Id!=id
        })
        lisss = lisss.filter(function (item) {
            return item.t_Id != id;
        })
        $('#list li[t_id=' + id + ']').remove();
        this.Header_Name=null
    },
    //-------------------------------------添加节点【试题】
    add_root: function () {
        //if ($('#inputTitle').val().trim() == '') {
        //    layer.msg('请输入节点名称');
        //    return;
        //}
        var sheet = Object();
        //第一个给其选中
        if (list_sheets.length == 0) {
            sheet.Num = 1;
            sheet.t_Id = 't_' + sheet.Num;
            select_sheet_Id = sheet.t_Id;
        }
        else {
            sheet.Num = list_sheets[list_sheets.length - 1].Num + 1;
            sheet.t_Id = 't_' + sheet.Num;
        }

        sheet.title = $('#inputTitle').val();
        sheet.indicator_array = [];
        $('#inputTitle').val('');
        list_sheets.push(sheet);
        $("#item_sheet").tmpl(sheet).appendTo("#sheets");

        UI_Table_Create.sheet_init();

    },
    sheet_init: function () {
        $("#sheets div").children('input').each(function () {
            $(this).unbind("click");
            $(this).on('click', function () {
                select_sheet_Id = $(this).attr('t_id');
                //alert(select_sheet_Id)
                //变更样式
                $(this).addClass('border-red').parent().siblings(0).children('input').removeClass('border-red');
                $(this).prop('readonly', '')
                for (var i in list_sheets) {
                    if (list_sheets[i].t_Id == select_sheet_Id) {
                        //-------------------------------------------------------------------试题节点切换                      
                        UI_Table_Create.Reflesh_View(list_sheets[i]);
                        break;
                    }
                }
            });
            $(this).unbind("blur");
            $(this).on('blur', function () {
                $(this).prop('readonly', 'readonly')
                //$(this).prop('cursor', 'pointer')
            });
        });

        $("#sheets div").children('.iconfont').each(function () {
            $(this).unbind("click");
            $(this).on('click', function () {
                select_sheet_Id = $(this).attr('t_id');
                for (var i in list_sheets) {
                    if (list_sheets[i].t_Id == select_sheet_Id) {
                        if ($(this).prev().hasClass('border-red')) { //如果当前节点是选中状态
                            select_sheet_Id = null;
                            UI_Table_Create.Reflesh_View({ indicator_array: [] });//删除时，同时改变页面
                        }
                        list_sheets.splice(i, 1);
                        $(this).parent().remove();
                        UI_Table_Create.calculate_realtotal();
                        break;
                    }
                }
            });
        });
    },
    //---------------------------------移除试题-----------------------------------------------------
    //移除
    remove1: function (_this, id) {
        //for (var i = 0; i < select_Array.indicator_array.length; i++) {
        //    if (select_Array.indicator_array[i] == id) {
        //        select_Array.indicator_array.splice(i, 1);
        //    }
        //}

        //移除数组中的内容，才算具体的删除
        //for (var i = 0; i < select_sheet.length; i++) {

        var array = select_sheet.indicator_array[0];

        for (var j = 0; j < array.indicator_list.length; j++) {
            if (array.indicator_list[j].Id == id) {//如果遍历的数组的id和当前的id一样，然后删除这个内容splice
                Array.prototype.splice.call(select_sheet.indicator_array[0].indicator_list, j, 1)
                //indicator_array[i].indicator_list.splice(j, 1); //此方法不支持IE 改为上述方法
                flg--;//题号需要减减
            }
        }
        UI_Table_Create.calculate_realtotal();
        //if (select_sheet.indicator_list.length == 0) {//如果长度为0了表示该类型下无问题了， 要删除类型标题行的
        //    select_sheet.splice(i, 1);
        //    $("#test_lists").html('<ul id="text_list1"><li id="default_li" style="min-height: 475px; background: #fff url(/images/no.jpg) no-repeat center center; border-bottom: none;"></li></ul>');
        //}
        //}

        //if (select_sheet.length == 0) {
        //    $("#test_lists").html('<ul id="text_list1"><li id="default_li" style="min-height: 475px; background: #fff url(/images/no.jpg) no-repeat center center; border-bottom: none;"></li></ul>');

        //    //$(".test_module").html('<div class="test_lists"> <ul id="text_list1"><li id="default_li" style="min-height: 475px; background: #fff url(/images/no.jpg) no-repeat center center; border-bottom: none;"></li></ul></div>');
        //}

        //效果的移除
        //if ($(_this).parents("ul").children("li").length == 1)//如果当前移除的试题数为1的话则把标题类型也移除掉
        //{
        //    $(_this).parents(".indicator_type").find("h1").remove();
        //}

        //$(_this).parents("li").remove();//移除当前的试题

        //UI_Table_Create.common_sort();

        UI_Table_Create.Reflesh_View(select_sheet);
    },
    //试题向上排序
    up: function (_this) {
        var _li = $(_this).parents("li");
        var len = _li.length;
        if (_li.index() != 0) {
            //替换
            _li.fadeOut().fadeIn();
            _li.prev().before(_li);
            $(_this).parents("ul").children('li').find('.down').removeClass("color_gray").addClass("color_purple");
            $(_this).parents("ul").children('li').find('.down').last().removeClass("color_purple").addClass("color_gray");

            UI_Table_Create.up_sort_update(_li);
        }
        if (_li.index() == 0) {
            $(_this).parents("ul").children('li').find('.up').removeClass("color_gray").addClass("color_purple");
            UI_Table_Create.common_sort(_this);
        }

        UI_Table_Create.indicator_sort(_this);
    },
    //排序后 重新写序号
    indicator_sort: function (_this) {
        $(_this).parents("ul").children('li').each(function () {
            var flg = $(this).children("input[name='name_flg']").val();
            $("#sp_" + flg).html(($(this).index() + 1));
        })
    },
    //试题向下排序
    down: function (_this) {

        var _li = $(_this).parents("li");
        var len = $(_this).parents("ul").find("li").length;
        if (_li.index() != len - 1) {


            //替换
            _li.fadeOut().fadeIn();
            _li.next().after(_li);
            $(_this).parents("ul").children('li').find('.up').removeClass("color_gray").addClass("color_purple");
            $(_this).parents("ul").children('li').find('.up').first().removeClass("color_purple").addClass("color_gray");

            UI_Table_Create.dwon_sort_update(_li);
        }
        if (_li.index() == len - 1) {
            $(_this).parents("ul").children('li').find('.down').removeClass("color_gray").addClass("color_purple");
            UI_Table_Create.common_sort(_this);
        }
        UI_Table_Create.indicator_sort(_this);
    },
    up_sort_update: function (_li) {
        //==================序号进行变更
        var sort_Id = _li.attr('Sort');
        var data_indic = select_sheet.indicator_array[0].indicator_list;

        var next_sort_Id = _li.next().attr('Sort');
        var ary = data_indic.filter(function (item) { return item.Id == sort_Id });
        var ary_before = data_indic.filter(function (item) { return item.Id == next_sort_Id });
        if (ary.length > 0 && ary_before.length > 0) {
            var ary_sort = ary[0].Sort;
            var ary_next_sort = ary_before[0].Sort;
            ary[0].Sort = ary_next_sort;
            ary_before[0].Sort = ary_sort;

            //alert(ary_sort)
            //alert(ary_next_sort)
        }
        select_sheet.indicator_array[0].indicator_list = Enumerable.From(data_indic).OrderBy(function (item) { return item.Sort }).ToArray();


    },
    dwon_sort_update: function (_li) {
        //==================序号进行变更
        var sort_Id = _li.attr('Sort');
        var data_indic = select_sheet.indicator_array[0].indicator_list;

        var next_sort_Id = _li.prev().attr('Sort');
        var ary = data_indic.filter(function (item) { return item.Id == sort_Id });
        var ary_next = data_indic.filter(function (item) { return item.Id == next_sort_Id });
        if (ary.length > 0 && ary_next.length > 0) {
            var ary_sort = ary[0].Sort;
            var ary_next_sort = ary_next[0].Sort;
            ary[0].Sort = ary_next_sort;
            ary_next[0].Sort = ary_sort;

            //alert(ary_sort)
            //alert(ary_next_sort)
        }
        select_sheet.indicator_array[0].indicator_list = Enumerable.From(data_indic).OrderBy(function (item) { return item.Sort }).ToArray();
    },
    //标题的向上排序
    t_up: function (_this) {
        var _div = $(_this).parents(".indicator_type");
        if (_div.prev().attr("ques") == 1 && _div.attr("ques") == 3)//说明上一个是单选题 当前是简答
        {
            layer.msg("简答题无法继续向上排序");
        }
        else {
            var len = _div.length;
            //alert(_div.index() + ":" + len);
            if (_div.index() != 0) {
                _div.fadeOut().fadeIn();
                _div.prev().before(_div);
                $(_this).parents(".test_module").find("h1").find('.down_t').removeClass("color_gray").addClass("color_purple");
                $(_this).parents(".test_module").find("h1").find('.down_t').last().removeClass("color_purple").addClass("color_gray");
            }
            if (_div.index() == 0) {
                //alert($(_this).parents(".test_module").find("h1").find('.iconfont:eq(0)').length);
                $(_this).parents(".test_module").find("h1").find('.up_t').removeClass("color_gray").addClass("color_purple");
                UI_Table_Create.common_sort(_this);
            }
        }

    },
    //标题的向下排序
    t_down: function (_this) {
        //获取最大类型的div indicator_type
        var _div = $(_this).parents(".indicator_type");
        if (_div.next().attr("ques") == 3 && _div.attr("ques") == 1)//说明下一个是简答  当前是单选
        {
            layer.msg("单选题不能在简答题的后面");
        }
        else {
            //获取总的h1的长度
            var len = $(_this).parents(".test_module").find("h1").length;
            //如果不是最后一个就进行顺序的互换
            if (_div.index() != len - 1) {
                _div.fadeOut().fadeIn();//淡入淡出
                _div.next().after(_div);//互换

                //预防错误
                $(_this).parents(".test_module").find("h1").find('.up_t').removeClass("color_gray").addClass("color_purple");
                $(_this).parents(".test_module").find("h1").find('.up_t').first().removeClass("color_purple").addClass("color_gray");
            }
            if (_div.index() == len - 1) {
                $(_this).parents(".test_module").find("h1").find('.down_t').eq(1).removeClass("color_gray").addClass("color_purple");
                UI_Table_Create.common_sort(_this);
            }
        }

    },
    //公用排序
    common_sort: function (_this) {
        //当前选中的图标置灰
        $(_this).removeClass("color_purple").addClass("color_gray");
        //取消click事件
        $(_this).off("click");
    },
    //计算离开文本框的方法
    text_blur: function () {
        $(".number").blur(function () {
            var flg = $(this).attr('flg');
            if (flg == 'sum') {
                UI_Table_Create.text_Sum_event($(this))
            }
            else {
                text_change_event($(this))
            }
        });

        $(".number").bind('keydown', function (event) {
            if (event.keyCode == "13") {
                var flg = $(this).attr('flg');
                if (flg == 'sum') {
                    UI_Table_Create.text_Sum_event($(this))
                }
                else {
                    text_change_event($(this))
                }
            }
        })
    },
    text_change_event: function (element) {
        var va = element.val();
        if (va != null && va != '' && va != undefined) {
            var Id = element.parents("li").children("input[name='name_in']").val();//获取试题的id
            var sum = $("#t_" + Id).val();
            if (sum != null && sum != '' && sum != undefined) {
                if (Number(va) >= Number(sum)) {
                    element.val(element.attr('lastvalue'))
                    layer.msg("选项的分数不能超过当前题目的分数")
                    return false;
                }
            }

            var all_array = [];//定义类型需要存的数组         
            var Title = element.parents("li").children("input[name='name_title']").val();//获取试题类型的id
            var num_array = [];//定义标题内文本框需要存的数组
            //循环每一个试题选项的文本框的值，存在数组num_array中
            element.parents("li").find('input[class="number"]').each(function () {
                var flg = $(this).attr('flg');
                if (flg != 'sum') {
                    num_array.push($(this).val());
                }
            })

            //为标题内的文本框赋最大值
            //var max = Math.max.apply(null, num_array);
            //$("#t_" + Id).val(max == 0 ? "" : max);

            //类型的文本框为标题文本框的求和
            var len = element.parents(".indicator_type").find("h2").find('input[type="text"]').length;
            //循环每个标题文本框的text控件，并把值赋予all_array
            element.parents(".indicator_type").find("h2").find('input[type="text"]').each(function () {
                if ($(this).val() != "") {
                    all_array.push($(this).val());
                }
            });
            //对all_array进行遍历，进行求和
            var sum = 0;
            for (var i = 0; i < all_array.length; i++) {
                sum = numAdd(sum, all_array[i]);//防止值为字符串 导致计算错误
            }
            //赋值
            $("#h_" + Title).val(sum == 0 ? "" : sum);
           //================================【新加，每个小题分数调整都可以进行整体进行刷新】
            var list_s = Enumerable.From(select_sheet.indicator_array[0].indicator_list).Where("x=>x.Id == '" + Id + "'").ToArray();
            //循环每一个试题选项的文本框的值，存在数组num_array中
            element.parents("li").find('input[class="number"]').each(function (i) {
                var flg = $(this).attr('flg');
                if (flg != 'sum') {
                    var option = $(this).attr('id');
                    var result = $(this).val() > 0 ? Number($(this).val()) : 0;
                    if (option.indexOf('OptionA_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionA_S = result;
                    }
                    else if (option.indexOf('OptionB_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionB_S = result;
                    }
                    else if (option.indexOf('OptionC_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionC_S = result;
                    }
                    else if (option.indexOf('OptionD_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionD_S = result;
                    }
                    else if (option.indexOf('OptionE_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionE_S = result;
                    }
                    else if (option.indexOf('OptionF_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionF_S = result;
                    }
                }
            })
            UI_Table_Create.calculate_realtotal();
        }
    },
    text_Sum_event: function (element) {
        var va = element.val();
        if (va != null && va != '' && va != undefined) {
            var va_num = Number(va)
            if (isNaN(va_num)) {
                layer.msg('输入的格式不正确,请重新输入');
                var lastvalue = element.attr('lastvalue');
                if (lastvalue != null && lastvalue != '' && lastvalue != undefined) {
                    element.val(lastvalue);
                }

                return;
            }
            else {
                element.attr('lastvalue', va);
            }

            var all_array = [];//定义类型需要存的数组
            var Id = element.parents("li").children("input[name='name_in']").val();//获取试题的id
            var Title = element.parents("li").children("input[name='name_title']").val();//获取试题类型的id
            var num_array = [];//定义标题内文本框需要存的数组

            var A_S = $('#A').val();
            var B_S = $('#B').val();
            var C_S = $('#C').val();
            var D_S = $('#D').val();
            var E_S = $('#E').val();
            var F_S = $('#F').val();
            //选项A的参数标准
            //var A_S_Parameter = element.val();

            var list_s = Enumerable.From(select_sheet.indicator_array[0].indicator_list).Where("x=>x.Id == '" + Id + "'").ToArray();

            //循环每一个试题选项的文本框的值，存在数组num_array中
            element.parents("li").find('input[class="number"]').each(function (i) {
                var flg = $(this).attr('flg');
                if (flg != 'sum') {
                    var option = $(this).attr('id');
                    var result;
                    if (option.indexOf('OptionA_') >= 0) {
                        result = va * A_S;
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionA_S = result;
                    }
                    else if (option.indexOf('OptionB_') >= 0) {
                        result = va * B_S;
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionB_S = result;
                    }
                    else if (option.indexOf('OptionC_') >= 0) {
                        result = va * C_S;
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionC_S = result;
                    }
                    else if (option.indexOf('OptionD_') >= 0) {
                        result = va * D_S;
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionD_S = result;
                    }
                    else if (option.indexOf('OptionE_') >= 0) {
                        result = va * E_S;
                        result = result > 0 ? result.toFixed(2) : 0;
                        list_s[0].OptionE_S = result;
                    }
                    else if (option.indexOf('OptionF_') >= 0) {
                        result = result > 0 ? result.toFixed(2) : 0;
                        result = va * F_S;
                        list_s[0].OptionF_S = result;
                    }

                    $(this).val(result)
                    $(this).attr('lastvalue', result);
                    $(this).attr('max', va);
                    num_array.push($(this).val());
                }
                //alert(JSON.stringify($(this).attr('id')));
            });
            va = va > 0 ? Number(va).toFixed(2) : 0;
            list_s[0].OptionF_S_Max = va;

            //为标题内的文本框赋最大值
            //var max = Math.max.apply(null, num_array);
            //$("#t_" + Id).val(max == 0 ? "" : max);
            $("#t_" + Id).val(va);
            //类型的文本框为标题文本框的求和
            var len = element.parents(".indicator_type").find("h2").find('input[type="text"]').length;
            //循环每个标题文本框的text控件，并把值赋予all_array
            element.parents(".indicator_type").find("h2").find('input[type="text"]').each(function () {
                if ($(this).val() != "") {
                    all_array.push($(this).val());
                }
            });

            //对all_array进行遍历，进行求和
            var sum = 0;
            for (var i = 0; i < all_array.length; i++) {
                sum = numAdd(sum, all_array[i]);//防止值为字符串 导致计算错误
            }
            //赋值
            $("#h_" + Title).val(sum == 0 ? "" : sum);
            UI_Table_Create.calculate_realtotal();
        }
    },
    calculate_realtotal: function () { //计算实时总分        
        var total = 0;//实时总分
        for (var i in list_sheets) {
            if (list_sheets[i].indicator_array.length > 0) {
                for (var j in list_sheets[i].indicator_array) {                    
                    var indicator_list = list_sheets[i].indicator_array[j].indicator_list;
                    for (var h in indicator_list) {                       
                        var cur_indmodel = indicator_list[h];//当前对象
                        if (cur_indmodel.QuesType_Id == 1 || cur_indmodel.QuesType_Id == 4) {
                            var total_1 = cur_indmodel.OptionF_S_Max;
                            if (total_1 != null && total_1 != '' && total_1 != undefined && !isNaN(Number(total_1))) {
                                total_1 = Number(total_1);
                                total += total_1;
                            }                            
                        }
                    }
                }
            }
        }
        $("#total").html(total.toFixed(2) + '');
    },
    //选择指标
    openIndicator: function () {
        if (select_sheet == null) {
            layer.msg('请先创建一个节点');
            return;
        }
        for (var i = 0; i < select_sheet.length; i++) {
            var Eva_TableDetail = select_sheet[i].indicator_list;
            select_sheet[i]["indicator_type_value"] = $("#h_" + select_sheet[i].indicator_type_tid).val();//赋值
            select_sheet[i]["indicator_type_tname"] = $("#indicator_type_tid_" + select_sheet[i].indicator_type_tid).val();//赋值
            select_sheet[i]["total_value"] = $("#total").html();//实时总分的赋值
            select_sheet[i]["index"] = index_1;//赋值
            for (var j = 0; j < Eva_TableDetail.length; j++) {
                var Id = Eva_TableDetail[j].Id;//获取指标的id
                if (select_Array.indexOf(Id) == -1) {
                    select_Array.push(Id);
                }
                Eva_TableDetail[j]["OptionA_S"] = $("#OptionA_" + Id).val();//赋值
                Eva_TableDetail[j]["OptionB_S"] = $("#OptionB_" + Id).val();
                Eva_TableDetail[j]["OptionC_S"] = $("#OptionC_" + Id).val();
                var d_v = "";
                if ($("#OptionD_" + Id).val() != undefined) {//值为undifined的情况
                    d_v = $("#OptionD_" + Id).val();
                }
                Eva_TableDetail[j]["OptionD_S"] = d_v;

                var e_v = "";
                if ($("#OptionE_" + Id).val() != undefined) {
                    e_v = $("#OptionE_" + Id).val();
                }
                Eva_TableDetail[j]["OptionE_S"] = e_v;
                var f_v = "";
                if ($("#OptionF_" + Id).val() != undefined) {
                    f_v = $("#OptionF_" + Id).val();
                }
                Eva_TableDetail[j]["OptionF_S"] = f_v;
                var t_v = "";
                if ($("#t_" + Id).val() != undefined) {
                    t_v = $("#t_" + Id).val();
                }
                Eva_TableDetail[j]["OptionF_S_Max"] = t_v;

                //排序后的索引字段  按指标类型和 题的组合

                if (Eva_TableDetail[j]["QuesType_Id"] != "3") {
                    var Sort = ($("#OptionA_" + Id).parents('.indicator_type').index() + 1) + "" + $("#OptionA_" + Id).parents('li').index() + 1;
                    Eva_TableDetail[j]["Sort"] = Sort;
                }
                else {
                    var Sort = ($("#txt_" + Id).parents('.indicator_type').index() + 1) + "" + $("#txt_" + Id).parents('li').index() + 1;
                    Eva_TableDetail[j]["Sort"] = Sort;
                }
            }
        }
        flg = flg * 2;//这样写是为了保证永远没有重复的sp_1 标题的id  为了有正确的题的序号，相同的flg会导致序号排列错误

        OpenIFrameWindow('选择指标库', '../../SysSettings/Indicate/SelectDataBase.aspx?page=0' + '&Type=' + Type, '1170px', '700px');//Type 0为公用型，1为私用型（教师自用）  
    },
    onlyNum: function () {
        if (event.keyCode == 190 || event.keyCode == 110) {
            event.returnValue = true;
            return;
        }
        if (!(event.keyCode == 46) && !(event.keyCode == 8) && !(event.keyCode == 37) && !(event.keyCode == 39))
            if (!((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105)))
                event.returnValue = false;

    },
    //----------------------------------------------------------------------------------------提交表格设计
    submit: function () {
        var func = UI_Table_Create.Type == 1 ? 'Edit_Eva_Table' : 'Add_Eva_Table';
        var scoreflag = 0;
        //试题加载
        var all_array = [];
        for (var i in list_sheets) {
            if (list_sheets[i].indicator_array.length > 0) {
                for (var j in list_sheets[i].indicator_array) {
                    all_array.push(list_sheets[i].indicator_array[j]);
                    var indicator_list = list_sheets[i].indicator_array[j].indicator_list;
                    for (var h in indicator_list) {
                        indicator_list[h].Root = $('#sheets').find('input[t_id="' + list_sheets[i].t_Id + '"]').val();
                        indicator_list[h].Sort = Number(h) + 1;
                        indicator_list[h].RootID = Number(i) + 1;
                        indicator_list[h].Id = indicator_list[h].Indicator_Id == undefined ? indicator_list[h].Id : indicator_list[h].Indicator_Id;
                        var cur_indmodel = indicator_list[h];//当前对象
                        if ($("#IsScore").is(":checked")&&(cur_indmodel.QuesType_Id == 1 || cur_indmodel.QuesType_Id == 4)) {
                            if (cur_indmodel.OptionF_S_Max == null || cur_indmodel.OptionF_S_Max == '' || cur_indmodel.OptionF_S_Max == undefined || isNaN(Number(cur_indmodel.OptionF_S_Max))) {
                                scoreflag++;                              
                            }
                            if (cur_indmodel.QuesType_Id == 1) {
                                if (cur_indmodel.OptionA_S == null || cur_indmodel.OptionA_S == '' || cur_indmodel.OptionA_S == undefined || isNaN(Number(cur_indmodel.OptionA_S))) {
                                    scoreflag++; 
                                }
                                if (cur_indmodel.OptionB_S == null || cur_indmodel.OptionB_S == '' || cur_indmodel.OptionB_S == undefined || isNaN(Number(cur_indmodel.OptionB_S))) {
                                    scoreflag++; 
                                }
                                if (cur_indmodel.OptionC_S == null || cur_indmodel.OptionC_S == '' || cur_indmodel.OptionC_S == undefined || isNaN(Number(cur_indmodel.OptionC_S))) {
                                    scoreflag++; 
                                }
                                if (cur_indmodel.OptionD.length && (cur_indmodel.OptionD_S == null || cur_indmodel.OptionD_S == '' || cur_indmodel.OptionD_S == undefined || isNaN(Number(cur_indmodel.OptionD_S)))) {
                                    scoreflag++; 
                                }
                                if (cur_indmodel.OptionE.length && (cur_indmodel.OptionE_S == null || cur_indmodel.OptionE_S == '' || cur_indmodel.OptionE_S == undefined || isNaN(Number(cur_indmodel.OptionE_S)))) {
                                    scoreflag++; 
                                }
                                if (cur_indmodel.OptionF.length && (cur_indmodel.OptionF_S == null || cur_indmodel.OptionF_S == '' || cur_indmodel.OptionF_S == undefined || isNaN(Number(cur_indmodel.OptionF_S)))) {
                                    scoreflag++; 
                                }
                            }                            
                        }                        
                    }
                }
            }
        }

        var Name = $("#Name").val().trim();
        if (this.Header_Name != null) {
            layer.msg('表头名字有重复，请重新输入！');
            return false;
        }
        //请输入评价表名称
        if (Name == '') {
            layer.msg('请输入评价表名称！');
            return false;
        }

        var IsScore = "0";
        //是否记分
        if ($("#IsScore").is(":checked")) {
            IsScore = "0";
            //验证 为0表示验证通过
            var valid_flag = validateForm($('input[type="text"],input[class="number"]'));
            if (valid_flag != "0")////验证失败的情况  需要表单的input控件 有isrequired 值为true或false 和fl 值为不为空的名称两个属性
            {
                return false;
            }
            if (scoreflag > 0) { layer.msg('存在未赋分的指标项，请赋分后再进行保存！'); return false; }
        }
        else {
            IsScore = "1";
        }
        var Remarks = $("#Remarks").val();
        var CreateUID = GetLoginUser().UniqueNo;
        var EditUID = GetLoginUser().UniqueNo;
        //是否选择指标
        if (all_array.length <= 0) {
            layer.msg('您还未选择指标！');
            return false;
        }

        var lisss_IsNull = false;
        //表头信息填充
        for (var i in lisss) {
            lisss[i].title = $('#list').find('input[t_id="' + lisss[i].t_Id + '"]').val();
            if (lisss[i].title.trim() == '') { lisss_IsNull = true }
        }
        if (lisss_IsNull) {
            layer.msg('请输入自定义表头信息！');
            return false;
        }

        //for (var i in UI_Table_Create.head_value) {
        //    UI_Table_Create.head_value[i].Code = UI_Table_Create.head_value[i].CustomCode;
        //}

        //启用或禁用
        var IsEnable = $("#disalbe").is(":checked") ? 0 : 1;
        for (var h in all_array) {
            for (var f in all_array[h].indicator_list) {
                var obj = all_array[h].indicator_list[f];
                obj.OptionF_S_Max = obj.OptionF_S_Max == '' ? 0 : obj.OptionF_S_Max;

                obj.OptionA_S = obj.OptionA_S == '' ? 0 : obj.OptionA_S;
                obj.OptionB_S = obj.OptionB_S == '' ? 0 : obj.OptionB_S;
                obj.OptionC_S = obj.OptionC_S == '' ? 0 : obj.OptionC_S;
                obj.OptionD_S = obj.OptionD_S == '' ? 0 : obj.OptionD_S;
                obj.OptionE_S = obj.OptionE_S == '' ? 0 : obj.OptionE_S;
                obj.OptionF_S = obj.OptionF_S == '' ? 0 : obj.OptionF_S;
            }
        }
       
        var _head_value = this.head_value.map(function (item) {
            if (item.hasOwnProperty('t_Id')) {
                return {
                    name: item.title,
                    id: 0,
                    description: '',
                    Code: ''
                }
            } else {
                return item
            }
        })
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: {
                "func": func, "table_Id": table_Id, "Name": Name, "IsScore": IsScore, "Remarks": Remarks,
                "CreateUID": CreateUID, "EditUID": EditUID, "List": JSON.stringify(all_array),
                "head_value": JSON.stringify(_head_value), "IsEnable": IsEnable,
                "Type": Type
            },//组合input标签
            success: function (json) {
                if (json.result.errMsg == "success") {

                    UI_Table_Create.submit_Compleate();
                    layer.msg('操作成功!');
                }
            },
            error: function () {
                //接口错误时需要执行的
            }
        });

    },

    submit_Compleate: function () {
    },
    sel_CousrseType: function () {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: { "func": "GetCourse_Type" },//组合input标签
            success: function (json) {

                if (json.result.errMsg == "success") {
                    var retData = json.result.retData;
                    //console.log(retData);
                    for (var i = 0; i < retData.length; i++) {
                        $("#CousrseType_Id").append('<option value="' + retData[i]["Key"] + '">' + retData[i]["Value"] + '</option>');
                    }
                }
            },
            error: function () {
                //接口错误时需要执行的
            }
        });
    },
    CallBack_Hepler: function () {
        if (select_sheet_Id != null) {
            var sheet = list_sheets.filter(function (item) { return item.t_Id == select_sheet_Id });
            if (sheet.length > 0) {
                var _sheet = sheet[0];
                _sheet.indicator_array = indicator_array;

                //单一节点
                if (DataBaseMainModel.Root_SingleMode && _sheet.indicator_array.length >= 2) {
                    for (var i = 1; i < _sheet.indicator_array.length; i++) {
                        for (var j in _sheet.indicator_array[i].indicator_list) {
                            _sheet.indicator_array[0].indicator_list.push(_sheet.indicator_array[i].indicator_list[j]);
                        }
                    }
                    var single_array = [];
                    single_array.push(_sheet.indicator_array[0]);
                    _sheet.indicator_array = single_array;
                }

                //加上序号
                for (var i in _sheet.indicator_array[0].indicator_list) {

                    _sheet.indicator_array[0].indicator_list[i].Sort = Number(i) + 1;
                    _sheet.indicator_array[0].indicator_list[i].flg = Number(i) + 1;
                    _sheet.indicator_array[0].indicator_list[i].Root = _sheet.title;
                }

                //_array = Enumerable.From(_array).OrderBy("item=>item.QuesType_Id").ThenBy("item=>item.indicator_type_type").ToArray();//按题的类型排序，若是问答题则 排列在最下边
                UI_Table_Create.Reflesh_View(_sheet);
            }
        }
    },
    //-----------数据填充----------------------------------------------------------
    //回调函数（子页面调的回调函数）【已被修改，作为每一节的视图】
    Reflesh_View: function (_sheet) {


        select_sheet = _sheet;
        $("#text_list1").empty();//先清空目标的元素
        $("#default_li").hide();//默认的图片隐藏

        var _array = _sheet.indicator_array;
        //DataBaseMainModel.flg = _array.length + 1;
        if (_array.length > 0) {

            $("#item_indicator_title_1").tmpl(_array).appendTo("#text_list1");//填充数据

            //文本框的数字显示
            text_blur();

            //// 设置默认的第一个和最后一个置灰
            var h_v = $(".indicator_type").length;//获取类型的长度
            $(".indicator_type").each(function () {
                var f_v = $(this).find("li").length;
                $(this).find("li").each(function () {
                    var flg = $(this).children("input[name='name_flg']").val();//使用flg的原因防止有重复的id标签出现  比如有两个id=sp_1
                    $("#sp_" + flg).html($(this).index() + 1);//为题目设置索引

                    if ($(this).index() == 0) {//试题首行的图标置灰
                        $(this).find('.iconfont:eq(0)').removeClass("color_green").addClass("color_gray");

                    }
                    if ($(this).index() == f_v - 1) {//试题尾行的图标置灰
                        $(this).find('.iconfont:eq(1)').removeClass("color_green").addClass("color_gray");

                    }
                })
                if ($(this).index() == 0) {
                    //类型和试题首行的图标置灰
                    $(this).children("h1").find('.iconfont:eq(0)').removeClass("color_green").addClass("color_gray");

                }
                if ($(this).index() == h_v - 1) {
                    //类型和试题尾行的图标置灰
                    $(this).children("h1").find('.iconfont:eq(1)').removeClass("color_green").addClass("color_gray");

                }
            })

            if ($("#IsScore").is(":checked") == false) {//如果不计分的话，隐藏             
                $(".isscore").hide();
            }
        }
        else {
            $("#text_list1").html('<li id="default_li" style="min-height: 475px; background: #fff url(/images/no.jpg) no-repeat center center; border-bottom: none;"></li>');//先清空目标的元素
            $("#default_li").show();//默认的图片隐藏

        }
    },
    //【SelTabelHead】
    Get_Eva_Table_Header_Custom_List: function (successCb) {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            dataType: "json",
            data: { Func: "Get_Eva_Table_Header_Custom_List" },
            success: function (json) {
                successCb(json);

            },
            error: function () {
                //接口错误时需要执行的
            }
        });
    },
    //Get_Eva_Table_Header_Custom_List_Compleate: function (retData) { },
};


//=======================查看视图 ---系统设置用表============================================================
var headerList = [];
var IsScore = 0;
var RoomID = 0;
var IsRealName = 0;
var ReguID = 0;
var UI_Table_View = {
    PageType: 'TableView',//TableView 答卷视图  AddEvalTable添加答卷
    IsPage_Display: false,
    TableView_Init: function (retData) {

        $("#table_view").empty();
        for (var i in retData.Table_Detail_Dic_List) {
            $("#item_table_view").tmpl(retData.Table_Detail_Dic_List[i]).appendTo("#table_view");
        }
    },

    headerInit: function (retData) {
        $("#list").empty();
        
        retData.Table_Header_List.forEach(function (item) {
            if (item.Type == 0) {
                $("#item_check2").tmpl(item).appendTo("#list");
            } else {
                $("#item_check").tmpl(item).appendTo("#list");
            }
        })
    },

    scoreInit: function (retData) {

        if (retData.IsScore == 1) {
            $(".isscore").hide();
        }
        var sp_total = 0;
        for (var i in retData.Table_Detail_Dic_List) {
            var data = retData.Table_Detail_Dic_List[i];

            for (var j in data.Eva_TableDetail_List) {

                var child = data.Eva_TableDetail_List[j];
                sp_total += child.OptionF_S_Max;
            }
        }
        if (UI_Table_View.IsScore == 0) {
            $("#sp_total").html('总分：' + sp_total + '分')
        }
        else {
            $("#sp_total").html('不计分')
        }
    },


    //初始化表格列表
    Get_Eva_TableDetail: function () {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: { Func: "Get_Eva_TableDetail", "table_Id": table_Id, "IsPage_Display": UI_Table_View.IsPage_Display, "RoomID": RoomID, "ReguID": ReguID, "UserID": login_User.UniqueNo },
            success: function (json) {
                var retData = json.result.retData;
                if (retData.Table_Header_List.length == 0) {
                    $('#list').hide();
                } else {
                    $('#list').show();
                }
                $(".tablename").html(retData.Name);
                UI_Table_View.IsScore = retData.IsScore;
                switch (UI_Table_View.PageType) {
                    case 'TableView':
                        UI_Table_View.TableView_Init(retData);
                        UI_Table_View.headerInit(retData);
                        UI_Table_View.scoreInit(retData);
                        break;
                    case 'selectTable':
                        UI_Table_View.TableView_Init(retData);
                        UI_Table_View.headerInit(retData);
                        UI_Table_View.scoreInit(retData);
                        break;
                    case 'EvalDetail':
                        UI_Table_View.TableView_Init(retData);
                        break;
                    case 'EvalTable':
                        UI_Table_View.TableView_Init(retData);
                        UI_Table_View.scoreInit(retData);
                        break;

                    case 'detailModal':

                        break;
                    case 'RegularEva_View':

                        break;
                    case 'onlinetest':
                       
                        retData.headerList = retData.Table_Header_List.filter(function (item) { return item.CustomCode != null && item.CustomCode != '' });
                        retData.head_value = retData.Table_Header_List.filter(function (item) { return item.CustomCode == null || item.CustomCode == '' });

                        break;

                    case 'AddEvalTable':

                        if (retData.IsScore == 0) {
                            $("#IsScore").attr('checked', true);
                        }
                        else {
                            $("#IsScore").attr('checked', false);
                        }
                        if (retData.IsEnable == 0) {
                            $("#disalbe").attr('checked', true);
                        }
                        else {
                            $("#disalbe").attr('checked', false);
                        }

                        $('#Name').val(retData.Name);
                        var total_ = 0;
                        //添加节点信息
                        for (var i in retData.Table_Detail_Dic_List) {
                            var sheet = new Object();
                            sheet.title = retData.Table_Detail_Dic_List[i].Root;
                            sheet.indicator_array = [];
                            var indica = {
                                QuesType_Id: 3, index: 1, indicator_p_type: 1, indicator_type_tid: 2, indicator_type_tname: ''
                                , indicator_type_type: '0', indicator_type_value: '', total_value: 0,
                                indicator_list: retData.Table_Detail_Dic_List[i].Eva_TableDetail_List,
                            };

                            for (var j in indica.indicator_list) {
                                indica.indicator_list[j].flg = indica.indicator_list[j].Sort;

                                total_ += indica.indicator_list[j].OptionF_S_Max;
                            }

                            sheet.indicator_array.push(indica);
                            if (list_sheets.length == 0) {
                                sheet.Num = 1;
                                sheet.t_Id = 't_' + sheet.Num;
                                select_sheet_Id = sheet.t_Id;
                            }
                            else {
                                sheet.Num = list_sheets[list_sheets.length - 1].Num + 1;
                                sheet.t_Id = 't_' + sheet.Num;
                            }

                            list_sheets.push(sheet);
                            $("#item_sheet").tmpl(sheet).appendTo("#sheets");
                        }
                        $('#total').text(total_)
                        UI_Table_Create.sheet_init();

                        retData.Table_Header_List = Enumerable.From(retData.Table_Header_List).OrderBy(function (item) { return item.Id }).ToArray();//按Id进行升序排列
                        //添加表头信息
                        for (var i in retData.Table_Header_List) {
                            var item = retData.Table_Header_List[i];
                            
                            if (item.Type == 0) {
                                var header = Object();
                                header.title = item.Value;
                                if (lisss.length == 0) {
                                    header.Num = 1;
                                    header.t_Id = 't_' + header.Num;
                                }
                                else {
                                    header.Num = lisss[lisss.length - 1].Num + 1;
                                    header.t_Id = 't_' + header.Num;
                                }
                                lisss.push(header);
                                
                                UI_Table_Create.head_value.push(header);
                               
                                $("#item_check2").tmpl(header).appendTo("#list");
                            }
                            else {
                                //自由表头
                                var header_s = Object();
                                header_s.description = item.Header;
                                header_s.id = item.Id;
                                header_s.name = item.Value;
                                header_s.CustomCode = item.CustomCode;
                                UI_Table_Create.head_value.push(header_s);
                                $("#item_check").tmpl(header_s).appendTo("#list");
                            }
                        }
                        $('#sheets input:eq(0)').trigger('click');

                        break;
                    default:
                }


                $('.test_desc2').find('input').on('click', function () {
                    if ($(this).prop('Sel')) {
                        $(this).prop('Sel', false);
                        $(this).prop('checked', false);
                    }
                    else {
                        $(this).prop('Sel', true);
                        $(this).prop('checked', true);
                    }
                });

                UI_Table_View.Get_Eva_TableDetail_Compleate(retData);

            },
            error: function () {
                //接口错误时需要执行的
            }
        });
    },

    Get_Eva_TableDetail_Compleate: function (retData) { },
};

var All_Array = [];
var IsScore = false;
var TableName = '';
var head_value = [];
function Refresh_View_Display() {
    //试题加载
    All_Array = [];
    for (var i in list_sheets) {
        if (list_sheets[i].indicator_array.length > 0) {
            for (var j in list_sheets[i].indicator_array) {
                All_Array.push(list_sheets[i].indicator_array[j]);
                var indicator_list = list_sheets[i].indicator_array[j].indicator_list;
                for (var h in indicator_list) {
                    indicator_list[h].Root = $('#sheets').find('input[t_id="' + list_sheets[i].t_Id + '"]').val();
                }
            }
        }
    }
    var lisss_IsNull = false;
    //表头信息填充
    for (var i in lisss) {
        lisss[i].title = $('#list').find('input[t_id="' + lisss[i].t_Id + '"]').val();
        if (lisss[i].title.trim() == '') { lisss_IsNull = true }
    }

    head_value = UI_Table_Create.head_value;
    //启用或禁用
    IsScore = $("#IsScore").is(":checked") ? true : false;

    TableName = $("#Name").val();
}
//===================================================================================