/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../../SysSettings/Regu/AllotTask.aspx" />

var PageType = 'AllotTask';//AllotTask 定期评价分配
var ExpertList = null;
var Teachers = null;
var expType = 1;

var selectExpertUID = '';
var selectExpertName = '';


function PrepareInit() {
    $('#teachers').find('li:has(ul)').hover(function () {
        $(this).children('ul').show();
        $(this).addClass('selected');

        var parent_ = $(this);

        $(this).children('ul').find('li').off('click');
        $(this).children('ul').find('li').click(function () {
            if ($(this).attr('flg') != 'selected') {
                $(this).addClass('selected');
                //加数据
                var Course_UniqueNo = $(this).find('span').attr('Course_UniqueNo');
                var TeacherUID = $(this).find('span').attr('TeacherUID');
                var Teacher_Name = $(this).find('span').attr('Teacher_Name');
                var Course_Name = $(this).find('span').text();
                AddDis(Course_UniqueNo, Course_Name, TeacherUID, Teacher_Name);

                $(this).attr('flg', 'selected');
                parent_.attr('flg', 'selected');

            } else {
                $(this).removeClass('selected');
                //移除数据
                var Course_UniqueNo = $(this).find('span').attr('Course_UniqueNo');
                var TeacherUID = $(this).find('span').attr('TeacherUID');
                var Teacher_Name = $(this).find('span').attr('Teacher_Name');
                var Course_Name = $(this).find('span').text();
                RemoveDis(Course_UniqueNo, TeacherUID);

                $(this).attr('flg', '');
                parent_.attr('flg', '');
            }

        })
    }, function () {
        //var li_count = $(this).children('ul').find('li').length;
        var li_selected_count = $(this).children('ul').find('li[flg=selected]').length;


        if (li_selected_count == 0) {
            $(this).removeClass('selected');
            $(this).attr('flg', '');
        }
        $(this).children('ul').hide();
    })

}

function AddDis(Course_UniqueNo, Course_Name, TeacherUID, TeacherName) {

    var obj = {
        CourseId: Course_UniqueNo,
        Course_Name: Course_Name,
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
    select_course_teacher.push(obj);
    deEvent(obj);
}

function deEvent(obj) {
    $("#item_ExpertTeacher").tmpl(obj).appendTo("#selected_course");
    $('#selected_course').find('i').off('click');
    //移除事件
    $('#selected_course').find('i').on('click', function () {
        $(this).parent().remove();
        var TeacherUID = $(this).parent().attr('TeacherUID');
        var Course_UniqueNo = $(this).parent().attr('Course_UniqueNo');
        RemoveDis(Course_UniqueNo, TeacherUID);

        var lis = $('#teachers').find('li:has(ul)').find('span[TeacherUID=' + TeacherUID + '][Course_UniqueNo=' + Course_UniqueNo + ']').parent();
        lis.removeClass('selected');
        lis.attr('flg', '');

        var count = lis.parent().find('li[flg=selected]').length;
        if (count == 0) {
            lis.parent().parent().removeClass('selected');
            lis.parent().parent().attr('flg', 'selected');
        }
    });
}

function RemoveDis(Course_UniqueNo, TeacherUID) {
    var data = select_course_teacher.filter(function (item) { return item.CourseId == Course_UniqueNo && item.TeacherUID == TeacherUID });
    if (data.length > 0) {
        select_course_teacher.remove(data[0]);
    }
    var li = $('#selected_course').find('li[Course_UniqueNo=' + Course_UniqueNo + ']');
    li.remove();
}

function GetTeacherInfo_Course_Cls() {

    if (Teachers == null) {
        var postData = { func: "GetTeacherInfo_Course_Cls", "ReguId": select_reguid };
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
                        case 'AllotTask':
                            break;
                        default:
                    }
                    Teachers_Reflesh();
                    select_course_teacher = [];
                    TeachersFilter();
                }
            },
            error: function (errMsg) {
                layer.msg("失败2");
            }
        });
    }
}
function Teachers_Reflesh() {

    $('#teachers').empty();

    var DepartMent = $('#DepartMent').val().trim();
    var key = $('#key').val().trim();
    var teachers_temp = Teachers;

    if (DepartMent != '0') {
        teachers_temp = teachers_temp.filter(function (item) { return item.Department_UniqueNo == DepartMent });
    }
    if (key != '') {
        teachers_temp = teachers_temp.filter(function (item) { return item.Teacher_Name.indexOf(key) > -1 });
    }
    if (teachers_temp.length == 0) {
        nomessage('#teachers', 'li', 25, 321);
    }

    $("#item_Teachers").tmpl(teachers_temp).appendTo("#teachers");
    PrepareInit();

}



//获取督导专家
function GetUserByType(userType) {
    if (ExpertList == null) {
        var postData = { func: "GetUserByType", type: userType };
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
                        case 'AllotTask':
                            break;
                        default:
                    }
                    ExpertList = json.result.retData;
                    ExpertListReflesh();
                }
            },
            error: function (errMsg) {
                layer.msg("失败2");
            }
        });
    }

}

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

        $('#selected_course').empty();
        select_course_teacher = [];

        if (Teachers != null) {
            TeachersFilter();
        }

    })
    //默认第一个选中，并且添加点击事件，选中样式
    $('.linkman_lists li:eq(0)').trigger('click');
}


function TeachersFilter() {

    var lis = $('#teachers').find('li:has(ul)').find('span').parent();

    lis.removeClass('selected');
    lis.attr('flg', '');

    lis.parent().parent().removeClass('selected');
    lis.parent().parent().attr('flg', '');
    Teachers.filter(function (item) {
        item.T_C_Model_Childs.filter(function (child) {
            if (child.Selected) {
                var obj = {
                    CourseId: child.Course_UniqueNo,
                    Course_Name: child.Course_Name,
                    TeacherUID: child.TeacherUID,
                    TeacherName: item.Teacher_Name,
                    SecionID: select_sectionid,
                    ReguId: select_reguid,
                    ExpertUID: child.SelectedExperUID,
                    ExpertName: child.SelectedExperName,
                    CreateUID: cookie_Userinfo.UniqueNo,
                    EditUID: cookie_Userinfo.UniqueNo,
                    Type: expType,
                };

                if (selectExpertUID == obj.ExpertUID) {
                    select_course_teacher.push(obj);
                    var tea = obj.TeacherName;
                    var lis = $('#teachers').find('li:has(ul)').find('span[TeacherUID=' + obj.TeacherUID + '][Course_UniqueNo=' + obj.CourseId + ']').parent();
                    lis.addClass('selected');
                    lis.attr('flg', 'selected');
                    lis.parent().parent().addClass('selected');
                    lis.parent().parent().attr('flg', 'selected');
                    deEvent(obj);
                }
            }
        });
    });
}

function AddExpert_List_Teacher_Course() {
    var postData = {
        func: "AddExpert_List_Teacher_Course",
        "CreateUID": login_User.LoginName,
        "ExpertUID": selectExpertUID,
        "Type": 1,
        "Regu_Id": select_reguid,
        "SectionID": select_sectionid,
        "List": JSON.stringify(select_course_teacher),
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
                        switch (PageType) {
                            case "AllotTask":
                                parent.Get_Eva_RegularData(select_reguid, 0);
                                break;
                            case "StartEval":
                                parent.Get_Eva_RegularData(0, 0);
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
