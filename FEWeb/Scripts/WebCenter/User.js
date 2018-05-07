/// <reference path="../jquery-1.11.2.min.js" />
var User_StuList = [];
function GetStudentsSelect(ClassID) {
    $('#major').empty().append('<option value="">请选择</option>');
    $('#Stu').empty().append('<option value="">请选择</option>');
    if (ClassID.length > 0) {
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
                    User_StuList = obj.StuList;
                    obj.MajorList.forEach(function (item) {
                        $("#major").append('<option value="' + item.Major_ID + '">' + item.MajorName + '</option>');
                    });
                    ChosenInit($('#major'));
                    $('#major').on('change', function () {
                        var majorid = $('#major').val();
                        $('#Stu').empty().append('<option value="">请选择</option>');
                        var cur_stulist = User_StuList.filter(function (item) { return item.Major_ID == majorid });
                        cur_stulist.forEach(function (item) {
                            $("#Stu").append('<option value="' + item.UniqueNo + '">' + item.Name + '</option>');
                        });
                        ChosenInit($('#Stu'));
                    });
                }
            },
            error: function (errMsg) {
                alert("失败2");
            }
        });
    }    
}