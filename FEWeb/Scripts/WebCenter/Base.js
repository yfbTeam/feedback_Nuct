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
                        str = "<option value='" + item.Id + "'>" + item.DisPlayName + "</option>";
                    }
                    else {
                        str = "<option selected='selected' value='" + item.Id + "'>" + item.DisPlayName + "</option>";
                    }
                    $("#section").append(str);
                })
                that.bindStudySectionCompleate();
            },
            error: function () { }
        });
    },
    BindDepartCompleate: function () { },
    BindDepart: function () {
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
                    $(json.result.retData).each(function () {

                        $("#DepartMent").append('<option value="' + this.Id + '">' + this.Major_Name + '</option>');
                    });

                    $("#DepartMent").chosen({
                        allow_single_deselect: true,
                        disable_search_threshold: 6,
                        no_results_text: '未找到',
                        width: '335px'
                    })
                    that.BindDepartCompleate();
                }
            },
            error: function (errMsg) { }
        });
    },

    BindTable: function () {
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            dataType: "json",
            data: {
                func: "Get_Eva_Table"
            },
            success: function (json) {

                if (json.result.errNum.toString() == "0") {

                    $(json.result.retData).each(function () {
                        $("#table").append('<option title="' + this.Name + '" value="' + this.Id + '">' + cutstr(this.Name, 45) + '</option>');
                    });
                }
            },
            error: function (errMsg) { }
        });
    }
}
