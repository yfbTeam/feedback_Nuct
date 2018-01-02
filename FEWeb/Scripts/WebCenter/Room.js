/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../jquery-1.8.3.min.js" />


var PageSize = 10;
function GetClassInfoCompleate() { };
//绑定课程信息
function GetClassInfo(PageIndex) {
    layer_index = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
        
    var postData = {
        func: "GetClassInfo", "PageIndex": PageIndex, "PageSize": PageSize,
        "SectionID": $('#section').val(), "DP": $('#DP').val(), "CT": $('#CT').val(),
        "CP": $('#CP').val(), "TD": $('#TD').val(), "TN": $('#TN').val(), "MD": $('#MD').val(),
        "GD": $('#GD').val(), "CN": $('#CN').val(),
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/SysClass/ClassInfoHandler.ashx",
        data: postData,
        dataType: "json",
        async: false,
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {

                var data = returnVal.result.retData;
                //data.filter(function (item, index) { item.Num = index + 1 })
                layer.close(layer_index);

                $("#tbody").empty();
                if (data.length <= 0) {
                    nomessage('#tbody');
                    $('#pageBar').hide();
                    return;
                }
                else {
                    $('#pageBar').show();
                }


                $("#itemData").tmpl(data).appendTo("#tbody");
                tableSlide();

                laypage({
                    cont: 'pageBar', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                    pages: returnVal.result.PageCount, //通过后台拿到的总页数
                    curr: returnVal.result.PageIndex || 1, //当前页
                    skip: true, //是否开启跳页
                    skin: '#CA90B0',
                    groups: 10,
                    jump: function (obj, first) { //触发分页后的回调
                        if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr                                       
                            GetClassInfo(obj.curr)
                            pageIndex = obj.curr;
                        }
                    }
                });
                $("#itemCount").tmpl(returnVal.result).appendTo(".laypage_total");

                GetClassInfoCompleate();
            }
        },
        error: function (errMsg) {
            alert("失败2");
        }
    });
}

function GetClassInfoSelect() {
    var postData = {
        func: "GetClassInfoSelect",
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/SysClass/ClassInfoHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var obj = returnVal.result.retData;
                obj.DPList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#DP").append(str);
                });
                ChosenInit($('#DP'));
              
                obj.CTList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CT").append(str);
                });               
                ChosenInit($('#CT'));
                obj.CPList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CP").append(str);
                });
                ChosenInit($('#CP'));
                obj.TDList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#TD").append(str);
                });
                ChosenInit($('#TD'));

                obj.TNList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#TN").append(str);
                });
                ChosenInit($('#TN'));

                obj.MDList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#MD").append(str);
                });
                ChosenInit($('#MD'));
                obj.GDList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#GD").append(str);
                });
                ChosenInit($('#GD'));
                obj.CNList.forEach(function (item) {
                    var str = str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CN").append(str);
                });
                ChosenInit($('#CN'));


                $("#DP,#CT,#CP,#TD,#TN,#MD,#GD,#CN").on('change', function () {
                    pageIndex = 0;
                    GetClassInfo(pageIndex);
                });
            }
        },
        error: function (errMsg) {
            alert("失败2");
        }
    });
}

