/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../../Evaluation/Input/selectTable.aspx" />
//==========================评价===================================================
var evaluate_Model = {
    //总数据
    _Data: [],
    //获取数据
    Load_Data: function () {

    },
    //获取数据完成时执行【类似于异步委托】
    Load_Data_Compleate: function () { },
    Submit_ele: null,
    Submit_array: [],
    Is_AddQuesType: false, //是否保存题的类型
    Is_Required: true, //true提交   false 保存

    AllScore: 0,
    Get_SubData: function () {
        var s_flg = 0;
        evaluate_Model.Submit_array = [];
        var first_option = evaluate_Model.Submit_ele.find("input[type='radio']:checked").eq(0).attr('flv');
        var radioCount = 0, sameCount = 0;

        //初始化所有答题都未完成
        var hasAnswerQuestion3 = false;


        var question_3_Count = 0;
        var question_answer_Count = 0;

        evaluate_Model.Submit_ele.each(function (i, n) {

            s_flg++;
            var sub_array = new Object();
            var TableDetailID = $(this).find("input[name='name_id']").val();
            var sub_Score = $(this).find("input[type='radio']:checked").val();
            if (sub_Score == undefined) {
                sub_Score = 0;
            }
            var QuestionType = $(this).find("input[name='name_QuesType_Id']").val();

            var Answer = '';
            if (QuestionType == 3) {
                Answer = $(this).find("textarea").val().replace(/(^\s*)|(\s*$)/g, "");
                question_3_Count++;

                if (Answer != null && Answer != '') {
                    //其中有答过一个
                    //hasAnswerQuestion3 = true;
                    question_answer_Count++;                  
                }
            }
            else {
                Answer = $(this).find("input[type='radio']:checked").attr('flv');

                if (first_option == Answer) { sameCount++; }
            }

            sub_array.TableDetailID = TableDetailID;
            sub_array.Score = sub_Score;
            //总分
            evaluate_Model.AllScore += Number(sub_Score);

            sub_array.Answer = Answer;
            sub_array.IsEnable = evaluate_Model.Is_Required ? 0 : 1
            if (evaluate_Model.Is_AddQuesType) {
                sub_array.QuestionType = QuestionType;
            }
            if ($(this).find("input[type='radio']").length != 0 && $(this).find("input:checked").length == 1) {
                radioCount++;              
                return;
            }
           
            evaluate_Model.Submit_array.push(sub_array);
        });

        if (evaluate_Model.Is_Required) {
            if (s_flg == radioCount + question_answer_Count) {
                if (radioCount > 1 && radioCount == sameCount && ((question_3_Count > 0 && question_answer_Count == question_3_Count) || (question_3_Count == 0))) {
                    if (Eva_Role == 1) {
                        layer.msg('答题选项选择均一致，不允许提交!', { offset: '400px' });
                    }
                    else {
                        alert('答题选项选择均一致，不允许提交!')
                    }
                    return;
                }
                evaluate_Model.Submit_Data();
            } else {


                if (Eva_Role == 1) {
                    layer.msg('请填写未提交项', { offset: '400px' });
                }
                else {
                    alert('请填写未提交项')
                }
            }
        }
        else {
            evaluate_Model.Submit_Data();
        }
    },
    Submit_Data: function () { },
}
var Type = 1;
var Eva_Role = 1;
var Is_AddQuesType = false;
var HeaderList = [];
var State = 1;

function SubmitQuestionCompleate() { };
function SubmitQuestion() {
    var obj = new Object();
    obj.func = "Add_Eva_QuestionAnswer";

    obj.SectionID = SectionID;
    obj.DisplayName = DisplayName;

    obj.ReguID = ReguID;
    obj.ReguName = ReguName;

    obj.CourseID = CourseID;
    obj.CourseName = CourseName;

    obj.TeacherUID = TeacherUID;
    obj.TeacherName = TeacherName;

    obj.AnswerUID = AnswerUID;
    obj.AnswerName = AnswerName;

    obj.TableID = table_Id;

    obj.TableName = Eva_Role == 2 ? TableName : $('#table').find('option:selected').attr('title');

    obj.CreateUID = AnswerUID;
    obj.Type = Type;
    obj.Eva_Role = Eva_Role;
    obj.State = State;

    obj.HeaderList = JSON.stringify(HeaderList);;
    if (Eva_Role == 2) {
        evaluate_Model.Submit_ele = $(".indicatype");
    }
    else {
        evaluate_Model.Submit_ele = $(".ti");
    }
    evaluate_Model.Is_AddQuesType = Is_AddQuesType;
    evaluate_Model.Submit_Data = function () {

        obj.Score = evaluate_Model.AllScore;
        obj.List = JSON.stringify(evaluate_Model.Submit_array);
        var index_layer = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        //$.ajax({
        //    url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        //    type: "post",
        //    async: false,
        //    dataType: "json",
        //    data: obj,//组合input标签
        //    success: function (json) {

        //        if (json.result.errMsg == "success") {
        //            var data = json.result.retData;
        //            layer.msg('提交成功!', { offset: '400px' });
        //            window.history.go(-1);
        //        }
        //        else {
        //            layer.msg(json.result.retData, { offset: '400px' });
        //        }

        //        layer.close(index_layer);
        //    },
        //    error: function () {
        //        //接口错误时需要执行的
        //    }
        //});
        debugger;
    }
    evaluate_Model.Get_SubData();
}


function EditQuestionCompleate() { };
function EditQuestion(Id) {
    var obj = new Object();
    obj.func = "Edit_Eva_QuestionAnswer";
    obj.Id = Id;
    obj.State = State;
    obj.HeaderList = JSON.stringify(HeaderList);

    if (Eva_Role == 2) {
        evaluate_Model.Submit_ele = $(".indicatype");
    }
    else {
        evaluate_Model.Submit_ele = $(".ti");
    }
    evaluate_Model.Is_AddQuesType = Is_AddQuesType;
    evaluate_Model.Submit_Data = function () {

        obj.Score = evaluate_Model.AllScore;
        obj.List = JSON.stringify(evaluate_Model.Submit_array);
        var index_layer = layer.load(1, {
            shade: [0.1, '#fff'] //0.1透明度的白色背景
        });
        $.ajax({
            url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: obj,//组合input标签
            success: function (json) {

                if (json.result.errMsg == "success") {
                    var data = json.result.retData;
                    layer.msg('提交成功!', { offset: '400px' });
                    window.history.go(-1);
                }
                else {
                    layer.msg(json.result.retData, { offset: '400px' });
                }

                layer.close(index_layer);
            },
            error: function () {
                //接口错误时需要执行的
            }
        });

    }
    evaluate_Model.Get_SubData();
}

var pageSize = 10;
var pageIndex = 0;
var Mode = 1;  //Check  Record
var AnswerUID = ''; //专家，不填则为管理员
function Get_Eva_QuestionAnswer(PageIndex, SectionID, DepartmentID, Key, TableID) {
    index_layer = layer.load(1, {
        shade: [0.1, '#fff'] //0.1透明度的白色背景
    });
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: {
            func: "Get_Eva_QuestionAnswer", "SectionID": SectionID, "DepartmentID": DepartmentID,
            "TableID": TableID, "Key": Key, "AnswerUID": AnswerUID, "Mode": Mode,
            "PageIndex": PageIndex, "PageSize": pageSize
        },
        dataType: "json",
        success: function (returnVal) {

            if (returnVal.result.errMsg == "success") {
                var data = returnVal.result.retData;
                layer.close(index_layer);

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
                            Get_Eva_QuestionAnswer(obj.curr, SectionID, DepartmentID, Key, TableID)
                            pageIndex = obj.curr;
                        }
                    }
                });
                $("#itemCount").tmpl(returnVal.result).appendTo(".laypage_total");
            }
            else {

            }

            layer.close(index_layer);
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}

function Remove_Eva_QuestionAnswerCompleate() { };
function Remove_Eva_QuestionAnswer(Id) {
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: {
            func: "Remove_Eva_QuestionAnswer", "Id": Id,
        },
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功!');
                Reflesh();
                Remove_Eva_QuestionAnswerCompleate();
            }
            else {
                layer.msg('操作失败!');
            }
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}



var PageType = "EvalDetail";
var HeaderList = [];
function Get_Eva_QuestionAnswerDetail(Id) {
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: {
            func: "Get_Eva_QuestionAnswerDetail", "Id": Id,
        },
        dataType: "json",
        success: function (returnVal) {

            if (returnVal.result.errMsg == "success") {
                var data = returnVal.result.retData;
                console.log(data);

                data.DetailList.filter(function (item) {
                    switch (item.QuestionType) {
                        case 1:
                            $('.test_lists').find('div[DetailID="' + item.TableDetailID + '"]').find('input[flv="' + item.Answer + '"]').attr("checked", true);
                            break;
                        case 2:

                            break;
                        case 3:
                            $('.test_lists').find('div[DetailID="' + item.TableDetailID + '"]').find('textarea').text(item.Answer);
                            break;

                        default:

                    }
                });
                switch (PageType) {
                    case 'EvalDetail':
                        $("#item_check").tmpl(data.HeaderList).appendTo(".table_header_left");

                        if (IsScore == 0) {
                            $("#sp_total").html('分数：' + data.Score + '分')
                        }
                        else {
                            $("#sp_total").html('不计分')
                        }

                        break;
                    case 'EvalTable':

                        HeaderList = data.HeaderList;

                        break;
                    default:

                }
            }
            else {

            }
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}


function Change_Eva_QuestionAnswer_StateCompleate() { };
function Change_Eva_QuestionAnswer_State(Id) {
    $.ajax({
        url: HanderServiceUrl + "/Eva_Manage/Eva_ManageHandler.ashx",
        type: "post",
        async: false,
        dataType: "json",
        data: {
            func: "Change_Eva_QuestionAnswer_State", "Id": Id, "State": State
        },
        dataType: "json",
        success: function (returnVal) {
            if (returnVal.result.errMsg == "success") {
                layer.msg('操作成功!');
                parent.Reflesh();
                Change_Eva_QuestionAnswer_StateCompleate();
                setTimeout(function () { parent.CloseIFrameWindow(); }, 400);

            }
            else {
                layer.msg('操作失败!');
            }
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}

