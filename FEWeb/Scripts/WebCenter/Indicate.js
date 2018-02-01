var Type = 0;
var CreateUID = '';

//指标一级分类
function set_indicator_type() {
    var P_Type = get_IndicatorType_by_rid();
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: { Func: "Get_IndicatorType", P_Type: P_Type, "Type": Type ,"CreateUID":CreateUID},
        success: function (json) {
            var retData = json.result.retData;
            retData = Enumerable.From(retData).OrderBy('$.Id').ToArray();//按Id进行升序排列
            var data_length = retData.length;
            for (var i = 0; i < data_length; i++) {
                if (retData[i].Parent_Id == 0) {//获取分类父Id                       
                    $("#indicator_type").append("<option value='" + retData[i].Id + "'>" + retData[i].Name + "</option>");
                }
            }
            //父指标id赋值
            $("#indicator_type").val(indicator_Parent_Id[0].Id);
            set_indicator_type_2("one");
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}
//指标二级分类
function set_indicator_type_2(type) {
    type = arguments[0] || "";//""change时调用；"one"第一次加载
    var indicator_type = $("#indicator_type").val();
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: { Func: "Get_IndicatorType", "Type": Type, "CreateUID": CreateUID },
        success: function (json) {
            var retData = json.result.retData;
            retData = Enumerable.From(retData).OrderBy('$.Id').ToArray();//按Id进行升序排列
            var data_length = retData.length;
            for (var i = 0; i < data_length; i++) {
                if (retData[i].Parent_Id == indicator_type) {//获取分类父Id                     
                    $("#indicator_type_2").append("<option value='" + retData[i].Id + "'>" + retData[i].Name + "</option>");
                }
            }
            if (type == "one") {
                $("#indicator_type_2").val(indicator_name[0].Id);
            }
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}
//新增选项
function newItem() {
    if ($("#item_list li").length <= 5) {
        $("#item_list").append('<li><i class="radio"></i><input type="text" placeholder=""   class="text"/><i class="iconfont" onclick="remove1(this)">&#xe61b;</i></li>');
    }
    else {
        layer.msg("超出数量,无法添加");
    }
}

//取消按钮
function cancel() {
    parent.layer.close(index);
}

//移除选项
function remove1(_this) {
    $(_this).parent().remove();//移除当前i元素的父元素li
}



