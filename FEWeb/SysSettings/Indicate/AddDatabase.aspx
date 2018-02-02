<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDatabase.aspx.cs" Inherits="FEWeb.SysSettings.AddDatabase" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>新增指标</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link rel="stylesheet" href="../../css/layout.css" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .option_lists {
            padding-left: 110px;
            margin-top: 0;
        }
    </style>
</head>
<body>
    <input type="hidden" name="Func" value="Add_Indicator" />
    <!--这两个必须放在上边-->

    <input type="hidden" name="id" id="id" value="0" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="001" />
    <input type="hidden" name="EditUID" value="001" />
    <input type="hidden" name="Type" id="indicator_Type" value="0" />

    <div class="selectwrap clearfix">
        <span class="fl cursele">当前选择：</span>
        <div class="search_toobar clearfix fl">
            <div class="fl">
                <label for="">指标分类:</label>
                <select class="select" name="IndicatorType_Id_2" isrequired="true" fl="指标分类" id="indicator_type" style="width: 150px;">
                    <option value="0">--请选择--</option>
                </select>
            </div>
            <div class="fl ml10">
                <select class="select" name="IndicatorType_Id" isrequired="true" fl="指标分类" id="indicator_type_2" style="width: 150px;">
                    <option value="0">--请选择--</option>
                </select>
            </div>
            <div class="fl ml10">
                <label for="">题型:</label>
                <select class="select" name="QuesType_Id" id="QuesType_Id" style="width: 150px;">
                    <option value="1">单选题</option>
                    <option value="2">多选题</option>
                    <option value="3">问答题</option>
                    <option value="4">填分题</option>
                </select>
            </div>
            <div class="fl ml10">
                <label for="">备注:</label>
                <input type="text" name="Remarks" id="" placeholder="备注" value="" class="text" style="border-right: 1px solid #cccccc;">
            </div>
        </div>
    </div>
    <div class="main" style="margin-top: 10px; min-height: 270px;">
    </div>
    <div class="btnwrap">
        <input type="button" value="保存" onclick="submit()" class="btn" />
        <input type="button" value="取消" onclick="cancel()" class="btna ml10" />
    </div>

    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>

    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <link href="../../Scripts/kkPage/Css.css" rel="stylesheet" />
    <script src="../../Scripts/kkPage/jquery.kkPages.js"></script>
    <script src="../../Scripts/WebCenter/Indicate.js"></script>
    <script type="text/x-jquery-tmpl" id="item_indicator_s">
        <div class="input-wrap" id="indicator">
            <label>指标名称：</label><input type="text" name="Name" isrequired="true" fl="指标名称" class="text" placeholder="请填写指标名称" value="" style="width: 500px;" />
            <div class="clear"></div>
            <ul class="option_lists clearfix" id="item_list">
                <li style="margin: 0">
                    <i class="radio"></i>
                    <input type="text" placeholder="请填写选项A" isrequired="true" fl="选项A" value="" class="text" />
                </li>
                <li>
                    <i class="radio"></i>
                    <input type="text" placeholder="请填写选项B" value="" isrequired="true" fl="选项B" class="text" />
                </li>
                <li><i class="radio"></i>
                    <input type="text" <%--name="OptionC"--%> placeholder="请填写选项C" value="" isrequired="true" fl="选项C" class="text" /></li>
            </ul>
            <a href="javascript:newItem();" class="newoption"><i class="iconfont">&#xe649;</i>新增选项</a>
        </div>
    </script>

    <script type="text/x-jquery-tmpl" id="item_indicator_w">
        <div class="input-wrap" id="indicator_w">
            <label style="line-height: 60px">指标名称：</label>
            <ul class="option_lists clearfix" id="item_list_w" style="display: inline-block; padding-left: 0; float: left;">
                <li>
                    <textarea name="Name" maxlength="500" isrequired="true" placeholder="请填写指标名称"></textarea>
                </li>
            </ul>
        </div>
    </script>

    <script type="text/x-jquery-tmpl" id="item_indicator_t">
        <div class="input-wrap" id="indicator_t">
            <label style="line-height: 60px">指标名称：</label>
            <ul class="option_lists clearfix" id="item_list_t" style="display: inline-block; padding-left: 0; float: left; width: 80%;">
                <li>
                    <input type="text" class="text" name="Name" style="width: 500px; height: 35px;" fl="指标名称" isrequired="true" placeholder="请填写指标名称" />
                </li>
            </ul>
        </div>
    </script>


    <script type="text/javascript">
        var page = getQueryString("page");
        $("#indicator_Type").val(page);
        var index = parent.layer.getFrameIndex(window.name);//索引
        var typeid = getQueryString("typeid");//指标分类
        typeid = typeid == "undefined" ? 0 : typeid;

        Type = getQueryString("Type");
        CreateUID = login_User.UniqueNo;

        //retData_type 为父页面的指标分类，indicator_name获取当前指标的信息
        var indicator_name, indicator_Parent_Id;
        if (typeid != 0) {
            indicator_name = Enumerable.From(parent.retData_type).Where("item=>item.Id==" + typeid + "").ToArray();//从父页面获取的缓存数据
            //获取当前指标下的父指标信息（一条完整的信息）
            indicator_Parent_Id = Enumerable.From(parent.retData_type).Where("item=>item.Id==" + indicator_name[0].Parent_Id + "").ToArray();//从父页面获取的缓存数据
        }
        //指标分类下拉框
        set_indicator_type();
        $("#CreateUID").val(GetLoginUser().UniqueNo);//给creteid赋值

        var users = [{}];//随机定义的，为了使用模板，先默认单选类型的显示，
        $("#item_indicator_s").tmpl(users).appendTo(".main");//追加到main中

        $("#indicator_type").change(function () {//一二级指标分类的 级联选择
            set_indicator_type_2();
        })

        $("#QuesType_Id").change(function () {//题型改变时 使用不同的模板
            $(".main").empty();//置空前把main清空
            if ($(this).val() == "3") {//如果是问答题的话
                $("#item_indicator_w").tmpl(users).appendTo(".main");//追加问答题的模板到main中
            }
            else if ($(this).val() == "1") {
                $("#item_indicator_s").tmpl(users).appendTo(".main");//追加单选或多选的模板到main中
            }
            else if ($(this).val() == "2") {
                $("#item_indicator_s").tmpl(users).appendTo(".main");//追加多选题模板到main中
            }
            else if ($(this).val() == "4") {
                $("#item_indicator_t").tmpl(users).appendTo(".main");//追加填分题模板到main中
            }
        })

      
        //提交按钮
        function submit() {
            if ($("#indicator_type").val() == "0") {
                layer.msg("指标分类不允许为空");
                return false;
            }
            if ($("#indicator_type_2").val() == "0") {
                layer.msg("指标分类不允许为空");
                return false;
            }

            var array = ['A', 'B', 'C', 'D', 'E', 'F'];//备选项 最多为6个
            $("#indicator li").each(function (_index) {//循环选项 
                $(this).children("input[type='text']").attr("name", "Option" + array[_index]);//动态为选项赋name的值
            })

            var valid_flag = validateForm($('select,input[type="text"]'));
            if (valid_flag != "0")////验证失败的情况  需要表单的input控件 有isrequired 值为true或false 和fl 值为不为空的名称两个属性
            {
                return false;
            }

            var data = getFromValue();
            $.ajax({
                url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
                type: "post",
                async: false,
                dataType: "json",
                data: data,//组合input标签
                success: function (json) {
                    //console.log(JSON.stringify(json));
                    if (json.result.errMsg == "success") {
                        parent.layer.msg('操作成功!');
                        parent.initdata($("#indicator_type_2").val(), 1);
                        parent.layer.close(index);
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }

      
    </script>

</body>
</html>

