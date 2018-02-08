/// <reference path="../public.js" />
/// <reference path="../layer/layer.js" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../public.js" />
/// <reference path="../Common.js" />

var PageType = 'Power';  //Power用户组管理
var CurrentRoleid = null;
var CurrentRoleName = '';
var DPList = [];
var ClsList = [];


var department = false;
var school = false;
var all = false;
var rid = 0;



function ShowUserGroup_Compleate() { };
//显示用户组
function ShowUserGroup() {
    var postData = { func: "Get_UserGroup" };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        data: postData,
        dataType: "json",
        async: true,
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                $('#ShowUserGroup').empty();
                var lists = returnVal.result.retData;
                if (lists != null && lists.length > 0) {
                    $('#li_role').tmpl(lists).appendTo('#ShowUserGroup');
                    $('#btnadditem').tmpl(1).appendTo('#ShowUserGroup');


                    $('#header_th').empty();
                    $('#header_stu').tmpl(1).appendTo('#header_th');
                    CurrentRoleid = lists[0].RoleId;
                    CurrentRoleName = lists[0].RoleName;
                    $('.menu_lists li').click(function () {
                        $(this).addClass('selected').siblings().removeClass('selected');
                    })
                    tableSlide();

                   
                }
            }
        },
        error: function (errMsg) {
            alert("失败2");
        }
    });
};


function Ope_UserGourp_Compleate() { };
function Ope_UserGourp(Id, Name, Type) {
    switch (Type) {
        case 1:
            Ope_UserGourp_Helper(Id, Name, Type);
            break;
        case 2:
            Ope_UserGourp_Helper(Id, Name, Type);
            break;
        case 3:
            layer.confirm('确定要删除？', {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function () {
                Ope_UserGourp_Helper(Id, Name, Type);
            });

            break;
        default:
    }
};
function Ope_UserGourp_Helper(Id, Name, Type) {
    var postData = { func: "Ope_UserGourp", Type: Type, Id: Id, Name: Name, UniqueNo: cookie_Userinfo.UniqueNo };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功!');
                Ope_UserGourp_Compleate();
            }
            else {
                layer.msg(returnVal.result.errMsg);
            }
            layer.close();
        },
        error: function (errMsg) {
        }
    });
}


var Dp = '';
var Cls = '';
var key = '';
var pageSize = 10;
function Get_UserByRoleID(PageIndex) {

    Dp = $('#college').val();
    Cls = $('#class').val();
    key = $('#key').val();
    key = key != undefined ? key.trim() : '';

    Cls = CurrentRoleid != 2 ? '' : Cls;

    var postData = {
        func: "Get_UserByRoleID", "RoleID": CurrentRoleid, "PageIndex": PageIndex,
        "PageSize": pageSize, "Key": key, "Dp": Dp, "Cls": Cls,
    };
    layer_index = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var data = returnVal.result.retData;
                layer.close(layer_index);

                $('#ShowUserInfo').empty();

                if (data.length <= 0) {
                    nomessage('#ShowUserInfo');
                    $('#pageBar').hide();
                    return;
                }
                else {
                    $('#pageBar').show();
                }


                $('#ShowUserInfo').empty();
                if (CurrentRoleid == 2) {
                    $('#item_tr_stu').tmpl(data).appendTo('#ShowUserInfo');
                }
                else {
                    $('#item_tr').tmpl(data).appendTo('#ShowUserInfo');
                }

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
                            Get_UserByRoleID(obj.curr)
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


function Get_UserByRole_SelectCompleate() { };
function Get_UserByRole_Select() {
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        data: {
            func: "Get_UserByRole_Select"
        },
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var data = returnVal.result.retData;
                ClsList = data.ClsList;
                DPList = data.DPList;

                $("#item_Class").tmpl(ClsList).appendTo($('#class'));
                ChosenInit($('#class'));


                if (department && rid != 1) {
                    var obj = { Major_ID: login_User.Major_ID, DepartmentName: login_User.DepartmentName };
                    $("#college").empty();
                    $("#item_College").tmpl(obj).appendTo("#college");

                    colloge = login_User.Major_ID;
                }
                else {
                    $("#item_College").tmpl(DPList).appendTo($('#college'));
                    ChosenInit($('#college'));
                }

                Get_UserByRole_SelectCompleate();
            }
            else {
                layer.msg(returnVal.result.retData);
            }
        },
        error: function (errMsg) {

        }
    });
}




//DPList = returnVal.result.retData.DPList;
//                       

