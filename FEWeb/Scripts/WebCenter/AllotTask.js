/// <reference path="../../Evaluation/Input/createModal.aspx" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../../SysSettings/Regu/AllotTask.aspx" />

var PageType = 'AllotTask';//AllotTask 定期评价分配
var ExpertList = null;
var Teachers = null;
var expType = 1;

var selectExpertUID = '';
var selectExpertName = '';


function PrepareInit() {
    switch (PageType) {
        case 'StartEval':
            $("#btn_no").tmpl(1).appendTo(".btnwrap");
            if (IsAllSchool == 1) {

                $('#TD').empty();
                var str = "<option value='" + login_User.DepartmentName + "'>" + login_User.DepartmentName + "</option>";
                $('#TD').append(str)
                ChosenInit($('#TD'));
            }                      
            break;

        case 'AllotTask':
            $("#btn_yes").tmpl(1).appendTo(".btnwrap");
            break;
        default:
    }
    $('.fixed-table_header div').on('click', function (item) {
        var s = $(this).find('.layui-table-sort');
        if (s.length > 0) {
            var lay = s.attr('lay-sort');
            if (lay == '') {
                s.attr('lay-sort', 'asc');
                s.attr('sorttype', '1');
            }
            else if (lay == 'asc') {
                s.attr('lay-sort', 'desc');
                s.attr('sorttype', '2');
            }
            else if (lay == 'desc') {
                s.attr('lay-sort', '');
                s.attr('sorttype', '0');
            }
            pageIndex = 0;
            GetClassInfo(pageIndex);
        }
    });
}

function AddDis(CourseID, CourseName, TeacherUID, TeacherName,Id) {

    var obj = {
        Id: Id,
        CourseId: CourseID,
        Course_Name: CourseName,
        TeacherUID: TeacherUID,
        TeacherName: TeacherName,
        SecionID: select_sectionid,
        ReguId: select_reguid,
        ExpertUID: selectExpertUID,
        ExpertName: selectExpertName,
        CreateUID: cookie_Userinfo.UniqueNo,
        EditUID: cookie_Userinfo.UniqueNo,
        Type: expType,
    };

    var list = select_course_teacher.filter(function (i) { return i.TeacherUID == TeacherUID && i.CourseId == CourseID && i.Id == Id });
    if (list.length == 0) {

        select_course_teacher.push(obj);
    }
}


function AddDisOne(CourseID, CourseName, TeacherUID, TeacherName, Id) {

    var obj = {
        Id:Id,
        CourseId: CourseID,
        Course_Name: CourseName,
        TeacherUID: TeacherUID,
        TeacherName: TeacherName,
        SecionID: select_sectionid,
        ReguId: select_reguid,
        ExpertUID: selectExpertUID,
        ExpertName: selectExpertName,
        CreateUID: cookie_Userinfo.UniqueNo,
        EditUID: cookie_Userinfo.UniqueNo,
        Type: expType,
    };
    select_course_teacher = [];
    select_course_teacher.push(obj);

}

function RemoveDis(Course_UniqueNo, TeacherUID, Id) {
    var data = select_course_teacher.filter(function (item) { return item.CourseId == Course_UniqueNo && item.TeacherUID == TeacherUID && item.Id == Id});
    if (data.length > 0) {
        select_course_teacher.remove(data[0]);
    }
}

function GetTeacherInfo_Course_ClsCompleate() { };
var TeacherUID = '';
function GetTeacherInfo_Course_Cls() {
   
    //if (Teachers == null) {
    var postData = { func: "GetTeacherInfo_Course_Cls", "ReguId": select_reguid, "ExpertUID": selectExpertUID, SourceType: SourceType, IsSelfStart: 1 };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        async: false,
        success: function (json) {
            if (json.result.errMsg == "success") {
                Teachers = json.result.retData;
                switch (PageType) {
                    case 'AllotTask':
                        break;
                    default:
                }
                GetTeacherInfo_Course_ClsCompleate(Teachers);
            }
        },
        error: function (errMsg) {
            layer.msg("失败2");
        }
    });
}


var DepartmentID = '';
function GetUserByTypeCompleate() { };
//获取督导专家
function GetUserByType(userType) {
    if (ExpertList == null) {
        var postData = { func: "GetUserByType", type: userType, "DepartmentID": DepartmentID };
        $.ajax({
            type: "Post",
            url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
            data: postData,
            dataType: "json",
            async: false,
            success: function (json) {
                if (json.result.errMsg == "success") {
                    switch (PageType) {
                        case 'AllotTask':
                            break;

                        default:
                    }
                    ExpertList = json.result.retData;
                    ExpertListReflesh();

                    GetUserByTypeCompleate(ExpertList)
                }
            },
            error: function (errMsg) {
                layer.msg("失败2");
            }
        });
    }

}

function ExpertListRefleshCompleate() { };
function ExpertListReflesh() {
    $("#experts").empty();
    var key1 = $('#key1').val();
    var expertlisttmp = ExpertList;
    if (key1 != '') {
        expertlisttmp = expertlisttmp.filter(function (item) { return item.Name.indexOf(key1) > -1 });
    }
    $("#item_Expert").tmpl(expertlisttmp).appendTo("#experts");
    $('.linkman_lists li').click(function () {
        $(this).addClass('selected').siblings().removeClass('selected');
        selectExpertUID = $(this).attr('Id');
        selectExpertName = $(this).text().trim();
        select_course_teacher = [];
        var exp = ExpertList.filter(function (item) { return item.UniqueNo == selectExpertUID });
        var exp0 = exp.length > 0 ? exp[0] : null;
     
        var roleId = exp0.Roleid;
        departmentInit(roleId, exp0.DepartmentName);       
        ExpertListRefleshCompleate(exp0);

    })

}

function departmentInit(roleId, departmentName)
{
   
    switch (roleId) {
        case 16:
            DepartmentName = departmentName;
            GetClassInfoSelect(select_sectionid);
            $('#TD').empty();
            var str = "<option value='" + departmentName + "'>" + departmentName + "</option>";
            $('#TD').append(str)
            ChosenInit($('#TD'));
            teacherreflesh();
            pageIndex = 0;
            GetClassInfo(pageIndex);

            break;

        case 17:
            DepartmentName = '';
            $('#TD').empty();
            var str = "<option value=''>全部</option>";
            $('#TD').append(str)
            ChosenInit($('#TD'));

            GetClassInfoSelect(select_sectionid);
            pageIndex = 0;
            GetClassInfo(pageIndex);
            break;
        default:

    }
}

function teacherreflesh()
{
    var tnlist = TNList;
    if ($("#TD").val() != '')
    {
        var tnlist = tnlist.filter(function (item) { return item.TeacherDepartmentName == $("#TD").val() })
    }
 
    $("#TN").empty();
    $("#TN").append("<option value=''>全部</option>");
    tnlist.forEach(function (item) {
        var str = "<option value='" + item.TeacherUID + "'>" + item.TeacherName + "</option>";
        $("#TN").append(str);
    });
    ChosenInit($('#TN'));
}
var DisModelType = 0;
var IsSelfStart = 1;//默认不是自发起任务
function AddExpert_List_Teacher_CourseCompleate() { };
function AddExpert_List_Teacher_Course(sourtype) {
    if (PageType == "StartEval") { IsSelfStart = 2; }
    var postData = {
        func: "AddExpert_List_Teacher_Course",
        "CreateUID": login_User.LoginName,
        "ExpertUID": selectExpertUID,
        "Type": 1,      
        "Regu_Id": select_reguid,
        "SectionID": select_sectionid,
        "List": JSON.stringify(select_course_teacher),
        "DisModelType": DisModelType,
        SourceType:sourtype, //判断是否是校管理员
        IsSelfStart: IsSelfStart
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        data: postData,
        dataType: "json",
        async: false,
        success: function (json) {
            if (json.result.errMsg == "success") {

                layer.msg('操作成功')
                setTimeout(function () {
                    if (parent.Get_Eva_RegularData != undefined) {
                        var data = json.result.retData;
                        switch (PageType) {
                            case "AllotTask":
                                parent.Get_Eva_RegularData(select_reguid, 0);
                                break;
                            case "StartEval":                               
                                parent.navicate(data.TableCount,data.TeacherUID, data.TeacherName, data.SectionID, data.DisplayName, data.CourseID,
                                    data.CourseName, data.ReguID, data.ReguName, data.ExpertUID, data.ExpertName, DepartmentName, data.RoomID, data.Id);
                                break;
                            default:
                        }

                    }
                    parent.CloseIFrameWindow();
                }, 300);

            }
            else {
                layer.msg('操作失败')
            }
        },
        error: function (errMsg) {
            layer.msg("操作失败");
        }
    });
}

//--------指定元素进删除---------------------------------------------------------------
Array.prototype.remove = function (val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};
