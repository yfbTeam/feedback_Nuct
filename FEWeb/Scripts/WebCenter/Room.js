/// <reference path="../public.js" />
/// <reference path="../Common.js" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../jquery-1.8.3.min.js" />


var PageSize = 10;
var Groups = 10;
var subele = 'tr';
var size = 25;
var height = 480;
var DepartmentName = '';
//年龄
var BirthdayS = 0;
var BirthdayE = 120;
//校龄
var SchoolS = 0;
var SchoolE = 120;

var ClassModelType = 0;//教学安排   分配专家任务

var Key = '';//课程名称

//点击标题进行降序
var S_DP = 0;
var S_CN = 0;
var S_CT = 0;
var S_CP = 0;
var S_TD = 0;
var S_TN = 0;

var S_MD = 0;
var S_GD = 0;
var S_CLS = 0;
var S_TJ = 0;
var S_BR = 0;
var S_SY = 0;
var PageType = '';
var UnEvaTeaRoleId = 0;//不被评价教师组
var select_course_teacher = [];

function GetClassInfoCompleate() { };
//绑定课程信息
function GetClassInfo(PageIndex) {
    layer_index = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
    if (PageType == 'StartEval' || PageType == 'AllotTask') {
        S_DP = $('#S_DP Span').attr('sorttype');
        S_CN = $('#S_CN Span').attr('sorttype');
        S_CT = $('#S_CT Span').attr('sorttype');
        S_CP = $('#S_CP Span').attr('sorttype');
        S_TD = $('#S_TD Span').attr('sorttype');
        S_TN = $('#S_TN Span').attr('sorttype');

        S_MD = $('#S_MD Span').attr('sorttype');
        S_GD = $('#S_GD Span').attr('sorttype');
        S_CLS = $('#S_CLS Span').attr('sorttype');
        S_TJ = $('#S_TJ Span').attr('sorttype');
        S_BR = $('#S_BR Span').attr('sorttype');
        S_SY = $('#S_SY Span').attr('sorttype');
    }

    var key = $('#class_key').val();
    key = key != undefined ? key.trim() : '';

    var sectionid = $('#section').val() != undefined ? $('#section').val() : select_sectionid;
    var postData = {
        func: "GetClassInfo", "PageIndex": PageIndex, "PageSize": PageSize,
        "SectionID": sectionid, "DP": $('#DP').val(), "CT": $('#CT').val(),
        "CP": $('#CP').val(), "TD": $('#TD').val(), "TN": $('#TN').val(), "MD": $('#MD').val(),
        "GD": $('#GD').val(), "CN": $('#CN').val(), "Key": key, "BirthdayS": BirthdayS, "BirthdayE": BirthdayE,
        "SchoolS": SchoolS, "SchoolE": SchoolE, "ClassModelType": ClassModelType,

        "S_DP": S_DP, "S_CN": S_CN, "S_CT": S_CT, "S_CP": S_CP, "S_TD": S_TD, "S_TN": S_TN,
        "S_MD": S_MD, "S_GD": S_GD, "S_CLS": S_CLS, "S_TJ": S_TJ, "S_BR": S_BR, "S_SY": S_SY,
        "DepartmentName": DepartmentName, "UnEvaTeaRoleId": UnEvaTeaRoleId
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

                layer.close(layer_index);
              
                $("#tbody").empty();
                if (data.length <= 0) {
                    if (PageType == 'StartEval' || PageType == 'AllotTask') {
                        //subele = 'other';
                        //size = 15;
                        //nomessage('.fixed-table_body-wraper', subele, size, height);  $('#tbody').find('input[teacheruid="001953"]').find('input[courseid="7120401"]')                       
                        nomessage('#tbody', subele, size, height);
                        $('#tbody').find('td').addClass('trnomessage');
                    }
                    else {
                        nomessage('#tbody', subele, size, height);                       
                    }
                    $('#pageBar').hide();
                    return;
                }
                else {
                    $('#pageBar').show();
                }

                $("#itemData").tmpl(data).appendTo("#tbody");
                if (select_course_teacher != undefined && select_course_teacher.length>0)
                {
                    for (var i = 0; i < select_course_teacher.length; i++) {
                        $('#tbody').find('input[Id="' + select_course_teacher[i].Id + '"]').prop('checked', true);
                    }
                }
               

                tableSlide();

                laypage({
                    cont: 'pageBar', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                    pages: returnVal.result.PageCount, //通过后台拿到的总页数
                    curr: returnVal.result.PageIndex || 1, //当前页
                    skip: true, //是否开启跳页
                    skin: '#CA90B0',
                    groups: Groups,
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

var CCList = [];
var TNList = [];
function GetClassInfoSelectCompleate() { };
function GetClassInfoSelect(SectionID, TeacherUID, CourseID) {

    var postData = {
        func: "GetClassInfoSelect",
        "SectionID": SectionID, "TeacherUID": TeacherUID, "CourseID": CourseID, "DepartmentName": DepartmentName
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/SysClass/ClassInfoHandler.ashx",
        data: postData,
        async: false,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var obj = returnVal.result.retData;

                $("#DP").empty();
                $("#DP").append("<option value=''>全部</option>");
                obj.DPList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#DP").append(str);
                });
                ChosenInit($('#DP'));


                $("#CT").empty();
                $("#CT").append("<option value=''>全部</option>");
                obj.CTList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CT").append(str);
                });
                ChosenInit($('#CT'));


                $("#CP").empty();
                $("#CP").append("<option value=''>全部</option>");
                obj.CPList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CP").append(str);
                });
                ChosenInit($('#CP'));

                $("#TD").empty();
                $("#TD").append("<option value=''>全部</option>");
                obj.TDList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#TD").append(str);
                });
                ChosenInit($('#TD'));


                $("#TN").empty();
                $("#TN").append("<option value=''>全部</option>");
                obj.TNList.forEach(function (item) {
                    var str = "<option value='" + item.TeacherUID + "'>" + item.TeacherName + "</option>";
                    $("#TN").append(str);
                });
                ChosenInit($('#TN'));

                $("#MD").empty();
                $("#MD").append("<option value=''>全部</option>");
                obj.MDList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#MD").append(str);
                });
                ChosenInit($('#MD'));

                $("#GD").empty();
                $("#GD").append("<option value=''>全部</option>");
                obj.GDList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#GD").append(str);
                });
                ChosenInit($('#GD'));


                $("#CN").empty();
                $("#CN").append("<option value=''>全部</option>");
                obj.CNList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#CN").append(str);
                });
                ChosenInit($('#CN'));

                $("#Cls").empty();
                $("#Cls").append("<option value=''>全部</option>");
                obj.ClsList.forEach(function (item) {
                    var str = "<option value='" + item.ClassID + "'>" + item.ClassName + "</option>";
                    $("#Cls").append(str);
                });
                ChosenInit($('#Cls'));

                $("#RP").empty();
                $("#RP").append("<option value=''>全部</option>");
                obj.RPList.forEach(function (item) {
                    var str = "<option value='" + item + "'>" + item + "</option>";
                    $("#RP").append(str);
                });
                ChosenInit($('#RP'));


                CCList = obj.CCList;
                TNList = obj.TNList;

                GetClassInfoSelectCompleate();
            }
        },
        error: function (errMsg) {
            alert("失败2");
        }
    });
}
function Sel_TeaDepart_Change() {
    var Tea_NameData = TNList;  //重新绑定教师姓名选择框              
    if ($("#TD").val() != '') {
        Tea_NameData = Tea_NameData.filter(function (item) { return item.TeacherDepartmentName == $("#TD").val() })
    }
    $("#TN").empty().append("<option value=''>全部</option>");
    Tea_NameData.forEach(function (item) {
        var str = "<option value='" + item.TeacherUID + "'>" + item.TeacherName + "</option>";
        $("#TN").append(str);
    });
    ChosenInit($('#TN'));
}

