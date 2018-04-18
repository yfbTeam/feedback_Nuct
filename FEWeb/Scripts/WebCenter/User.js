/// <reference path="../jquery-1.11.2.min.js" />

function GetStudentsSelect(ClassID) {
    var postData = {
        func: "GetStudentsSelect",
        "ClassID": ClassID
    };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        data: postData,
        dataType: "json",
        async: false,
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                var obj = returnVal.result.retData;
                $('#Stu').empty();
                obj.StuList.forEach(function (item) {
                    var str = str = "<option value='" + item.UniqueNo + "'>" + item.Name + "</option>";
                    $("#Stu").append(str);
                });
                ChosenInit($('#Stu'));
            }
        },
        error: function (errMsg) {
            alert("失败2");
        }
    });
}