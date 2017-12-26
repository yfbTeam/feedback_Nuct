﻿/// <reference path="../jquery-1.8.3.min.js" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../../SysSettings/Regu/RegularEval.aspx" />
var select_sectionid = null;
var pageSize = 10;

//============================================================================================
function PrepareInit() {
    //菜单中找到有ul元素的子集，并绑定click事件
    $('.menu_list').find('li:has(ul)').children('span').click(function () {

        var $next = $(this).next('ul');
        if ($next.is(':hidden')) {
            $(this).addClass('selected');
            $next.stop().slideDown();
            $next.find('li:first').addClass('selected');
            $next.find('li:first').children('em').trigger('click');
            if ($(this).parent('li').siblings().children('ul').is(':visible')) {
                $(this).parent('li').siblings().children('span').removeClass('selected');
                $(this).parent('li').siblings().children('ul').stop().slideUp();
            }
        } else {
            $(this).removeClass('selected');
            $next.stop().slideUp();
        }

    });
    //划过事件
    tableSlide();
    //点击样式事件
    $('.menu_list').find('li:has(ul)').find('li').click(function () {
        $('.menu_list').find('li:has(ul)').find('li').removeClass('selected');
        $(this).parent('li').addClass('selected');
        $(this).addClass('selected');

        select_sectionid = $(this).parent().parent('li').attr('sectionid');


    });
}

function GetSection() {
    var Eva_Role = get_Eva_Role_by_rid();
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: { Func: "Get_StudySection" },
        success: function (json) {
            SectionList = json.result.retData;

            $('#item_StudySection').tmpl(SectionList).appendTo('#section');
            $('.menu_lists li').click(function () {
                $(this).addClass('selected').siblings().removeClass('selected');
            })
        },
        error: function () {
            //接口错误时需要执行的

        }
    })
}

function Get_Eva_RegularS(SectionId, Type, PageIndex) {
    layer_index = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
    var key = $('#key').val();

    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: { func: "Get_Eva_RegularS", "SectionId": SectionId, "Type": Type, "PageIndex": PageIndex, "PageSize": pageSize },
        dataType: "json", "Key": key,
        async: false,
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {

                var data = returnVal.result.retData;
                data.filter(function (item, index) { item.Num = index + 1 })
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
                            Get_Eva_RegularS(SectionId, Type, obj.curr)
                            pageIndex = obj.curr;
                        }
                    }
                });
                $("#itemCount").tmpl(returnVal.result).appendTo(".laypage_total");
            }
        },
        error: function (errMsg) {
            layer.msg("绑定课程类别失败");
        }
    });
}

function Get_Eva_RegularCompleate() { }
function Get_Eva_Regular(SectionId, Type) {

    var HasSection = true;
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: { func: "Get_Eva_Regular", "SectionId": SectionId, "Type": Type },
        dataType: "json",
        async: false,
        success: function (json) {
            if (json.result.errMsg == "success") {
                debugger;
                var retData = json.result.retData;
                var retdata = Enumerable.From(retData).GroupBy(function (x) { return x.SectionId }).ToArray();
                //retdata = Enumerable.From(retdata).OrderByDescending(function (child) { child.source[0].SectionId }).ToArray()
                var data = [];
                for (var i in retdata) {
                    var da = retdata[i].source;
                    var objst = Enumerable.From(da).OrderBy(function (item) {
                        return item.Sort;
                    }).ToArray();
                    data.push({ course_parent: da[0], objectlist: objst });
                    continue;
                }
                for (var i in data) {
                    if (data[i].course_parent.Study_IsEnable == 0) {
                        select_sectionid = data[i].course_parent.SectionId;
                    }
                }
                $("#menu_listscours").empty();
                $("#course_item").tmpl(data).appendTo("#menu_listscours");
                $('.menu_list').find('li:has(ul)').children('span').each(function () {
                    if ($(this).parent('li').attr('sectionid') == select_sectionid) {
                        var $next = $(this).next('ul');
                        $(this).addClass('selected');
                        $next.stop().slideDown();
                        $(this).parent('li').find('li:first').addClass('selected');
                        $(this).parent('li').find('li:first').find('em').trigger('click')
                    }
                })

                Get_Eva_RegularCompleate();
            }
        },
        error: function (errMsg) {
            layer.msg("绑定课程类别失败");
        }
    });
}

//点击课程分类
function GetCourseinfoBySortMan(Id) {

    select_reguid = Id;
    Get_Eva_RegularData(Id, 0);
}

var DepartmentIDs = '';
var LookType = 0;
var TableID = '';
function Add_Eva_RegularCompleate() { }
function Add_Eva_Regular(Type) {
    var index_layer = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
   
    var postData = {
        func: "Add_Eva_Regular", "Name": $('#name').val(), "StartTime": $('#StartTime').val(), "EndTime": $('#EndTime').val(), "LookType": LookType,
        "Look_StartTime": '', "Look_EndTime": '', "MaxPercent": '', "MinPercent": '', "Remarks": '', "CreateUID": cookie_Userinfo.LoginName
        , "EditUID": cookie_Userinfo.LoginName, "Section_Id": select_sectionid, "Type": Type, "TableID": TableID, "DepartmentIDs": DepartmentIDs,
       
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功');
                Add_Eva_RegularCompleate();
                setTimeout(function () {
                    layer.close(index_layer);
                    parent.CloseIFrameWindow();
                }, 100)
            }
            else {
                layer.close(index_layer);
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}

function Edit_Eva_RegularCompleate() { }
function Edit_Eva_Regular(Type) {
    var index_layer = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });

    var postData = {
        func: "Edit_Eva_Regular", "Id": Id, "Name": $('#name').val(), "StartTime": $('#StartTime').val(), "EndTime": $('#EndTime').val(), "LookType": '0',
        "Look_StartTime": '', "Look_EndTime": '', "MaxPercent": '', "MinPercent": '', "Remarks": ''
        , "EditUID": cookie_Userinfo.LoginName, "Type": Type, "TableID": '', "DepartmentIDs": ''
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功');
                Edit_Eva_RegularCompleate();
                setTimeout(function () {
                    layer.close(index_layer);
                    parent.CloseIFrameWindow();
                }, 100)
            }
            else {
                layer.close(index_layer);
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}



function DeleteExpert_List_Teacher_Course(Id) {
    var postData = {
        func: "DeleteExpert_List_Teacher_Course", "Id": Id
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {

                Get_Eva_RegularData(select_reguid, 0);
                layer.msg('操作成功');
                setTimeout(function () {
                    parent.CloseIFrameWindow();
                }, 100)
            }
            else {
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}

function Get_Eva_RegularSingle(Type) {

    var postData = {
        func: "Get_Eva_RegularSingle", "Id": Id
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var regu = returnVal.result.retData;

                $('#name').val(regu.Name);


                $('#StartTime').val(DateTimeConvert(regu.StartTime, 'yy-MM-dd', true));
                $('#EndTime').val(DateTimeConvert(regu.EndTime, 'yy-MM-dd', true));
            }
            else {
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}

function Get_Eva_RegularData(Id, PageIndex) {
    var postData = {
        func: "Get_Eva_RegularData", "ReguId": Id, "PageIndex": PageIndex,
        "PageSize": pageSize, "Key": $('#key').val(),
    };
    layer_index = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var data = returnVal.result.retData;
                data.filter(function (item, index) { item.Num = index + 1 })
                layer.close(layer_index);

                $('#ShowCourseInfo').empty();

                if (data.length <= 0) {
                    nomessage('#ShowCourseInfo');
                    $('#pageBar').hide();
                    return;
                }
                else {
                    $('#pageBar').show();
                }

                $("#itemData").tmpl(data).appendTo("#ShowCourseInfo");
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
                            Get_Eva_RegularData(Id, obj.curr)
                            pageIndex = obj.curr;
                        }
                    }
                });
                $("#itemCount").tmpl(returnVal.result).appendTo(".laypage_total");
            }
            else {
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}

function Delete_Eva_RegularCompleate() { }
function Delete_Eva_Regular(Id) {

    var postData = {
        func: "Delete_Eva_Regular", "Id": Id
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功');
                Delete_Eva_RegularCompleate();
            }
            else {
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}
