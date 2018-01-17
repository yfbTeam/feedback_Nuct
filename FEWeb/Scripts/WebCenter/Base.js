/// <reference path="../jquery-1.11.2.min.js" />
var Base = {
    bindStudySectionCompleate: function () { },
    bindStudySection: function () {
        var that = this;
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            dataType: "json",
            data: { Func: "Get_StudySection" },
            success: function (json) {
                json.result.retData.forEach(function (item) {

                    var str = '';
                    if (item.IsEnable == 1) {
                        str = "<option IsEnable='" + item.IsEnable + "' value='" + item.Id + "'>" + item.DisPlayName + "</option>";
                    }
                    else {
                        str = "<option IsEnable='" + item.IsEnable + "' selected='selected' value='" + item.Id + "'>" + item.DisPlayName + "</option>";
                    }
                    $("#section").append(str);
                })
                that.bindStudySectionCompleate();
            },
            error: function () { }
        });
    },

    BindDepartCompleate: function () { },
    BindDepart: function (width, nochonse, majorId) {
        var that = this;
        $.ajax({
            url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
            type: "post",
            dataType: "json",
            data: {
                func: "GetMajors"
            },
            success: function (json) {
                if (json.result.errNum.toString() == "0") {

                    if (nochonse == false) {
                        $("#DepartMent").empty();

                        if (majorId == '') {
                            $("#DepartMent").append('<option value="0">全部</option>');
                            $(json.result.retData).each(function () {
                                $("#DepartMent").append('<option value="' + this.Id + '">' + this.Major_Name + '</option>');
                            });
                        }
                        else {
                            $(json.result.retData).each(function () {
                                if (this.Id == majorId) {
                                    $("#DepartMent").append('<option value="' + this.Id + '">' + this.Major_Name + '</option>');
                                }
                            });
                        }


                    } else {
                        $(json.result.retData).each(function () {
                            $("#DepartMent").append('<option value="' + this.Id + '">' + this.Major_Name + '</option>');
                        });

                        width = (width == undefined || width == null) ? '335px' : width;

                        $("#DepartMent").chosen({
                            allow_single_deselect: true,
                            disable_search_threshold: 6,
                            no_results_text: '未找到',
                            width: width,
                        })
                    }

                    that.BindDepartCompleate();
                }
            },
            error: function (errMsg) { }
        });
    },

    BindTableCompleate: function () { },
    BindTable: function (SectionID, CourseID) {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            dataType: "json",
            data: {
                func: "Get_Eva_Table",
                "CourseID": CourseID, "SectionID": SectionID,
            },
            success: function (json) {

                if (json.result.errNum.toString() == "0") {
                    $(json.result.retData).each(function () {
                        $("#table").append('<option title="' + this.Name + '" value="' + this.Id + '">' + cutstr(this.Name, 45) + '</option>');
                    });
                    ChosenInit($("#table"));
                    Base.BindTableCompleate()
                }
            },
            error: function (errMsg) { }
        });
    },

    BindCourseCompleate: function () { },
    BindCourse: function (select_sectionid) {
        var postData = {
            func: "GetCourseInfo_Select",
            "SectionId": select_sectionid,
        };
        $.ajax({
            type: "Post",
            url: HanderServiceUrl + "/SysClass/CourseInfoHandler.ashx",
            data: postData,
            dataType: "json",
            success: function (returnVal) {
                if (returnVal.result.errMsg == "success") {

                    $('#pk,#ck,#cp,#dp,#cn').empty()
                    var obj = returnVal.result.retData;
                    obj.PkList.forEach(function (item) {
                        var str = str = "<option value='" + item + "'>" + item + "</option>";
                        $("#pk").append(str);
                    });
                    ChosenInit($('#pk'));
                    obj.TKList.forEach(function (item) {
                        var str = str = "<option value='" + item + "'>" + item + "</option>";
                        $("#ck").append(str);
                    });
                    ChosenInit($('#ck'));
                    obj.CPList.forEach(function (item) {
                        var str = str = "<option value='" + item + "'>" + item + "</option>";
                        $("#cp").append(str);
                    });
                    ChosenInit($('#cp'));
                    obj.DPList.forEach(function (item) {
                        var str = str = "<option value='" + item.DepartMentID + "'>" + item.DepartmentName + "</option>";
                        $("#dp").append(str);
                    });
                    ChosenInit($('#dp'));
                    obj.CNList.forEach(function (item) {
                        var str = str = "<option value='" + item.CourseID + "'>" + item.CourseName + "</option>";
                        $("#cn").append(str);
                    });
                    ChosenInit($('#cn'));
                }
            },
            error: function (errMsg) {
                alert("失败2");
            }
        });
    },


    CheckHasExpertReguCompleate: function () { },
    CheckHasExpertRegu: function (Type) {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            dataType: "json",
            data: {
                func: "CheckHasExpertRegu",
                "Type": Type,
            },
            success: function (json) {
                if (json.result.errNum.toString() == "0") {
                    var result = false;
                    if (json.result.retData.length > 0) {
                        result = true;
                    }
                    Base.CheckHasExpertReguCompleate(result, json.result.retData);
                }
            },
            error: function (errMsg) { }
        });
    }
}
