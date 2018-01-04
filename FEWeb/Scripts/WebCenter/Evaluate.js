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
    Get_SubData: function () {
        var s_flg = 0;
        evaluate_Model.Submit_array = [];
        var first_option = evaluate_Model.Submit_ele.find("input[type='radio']:checked").eq(0).attr('flv');
        var radioCount = 0, sameCount = 0;

        //初始化所有答题都未完成
        var hasAnswerQuestion3 = false;
        var question_3_Count = 0;

        evaluate_Model.Submit_ele.each(function (i, n) {
            var sub_array = new Object();
            var TableDetail_Id = $(this).find("input[name='name_id']").val();
            var sub_Score = $(this).find("input[type='radio']:checked").val();
            if (sub_Score == undefined) {
                sub_Score = 0;
            }
            var QuesType_Id = $(this).find("input[name='name_QuesType_Id']").val();

            var Q_Type = $(this).find("input[name='name_QuesType_Id']").attr('Q_Type');
            switch (Q_Type) {
                case "1":
                    //普通答题
                    break;
                case "2":
                    //教师反馈
                    break;
                case "3":
                    //听课记录
                    break;
                default:
            }

            var Answer = '';
            if (QuesType_Id == 3) {
                Answer = $(this).find("textarea").val().replace(/(^\s*)|(\s*$)/g, "");
                question_3_Count++;

                if (Answer != null && Answer != '') {
                    //其中有答过一个
                    hasAnswerQuestion3 = true;
                }
            }
            else {
                Answer = $(this).find("input[type='radio']:checked").attr('flv');
                radioCount++;
                if (first_option == Answer) { sameCount++; }
            }



            sub_array.TableDetail_Id = TableDetail_Id;
            sub_array.Score = sub_Score;
            sub_array.Answer = Answer;
            sub_array.IsEnable = evaluate_Model.Is_Required ? 0 : 1
            if (evaluate_Model.Is_AddQuesType) {
                sub_array.QuesType_Id = QuesType_Id;
            }
            if ($(this).find("input[type='radio']").length != 0 && $(this).find("input[type='radio']").is(":checked") == false && Q_Type != "2") {
                s_flg++;
                //layer.msg("请答题完整", { icon: 2, offset: '400px' });
                return;
            }
            //if ($(this).find("textarea").length != 0 && Answer == "" && Q_Type != "2") {
            //    s_flg++;
            //    layer.msg("请答题完整", { icon: 2 });
            //    return;
            //}           
            evaluate_Model.Submit_array.push(sub_array);
        });

        if (question_3_Count > 0 && radioCount == 0 && !hasAnswerQuestion3) {
            layer.msg('请至少填写一道题目!', { offset: '400px' });
            return;
        }

        if (evaluate_Model.Is_Required) {
            if (s_flg == 0) {
                if (radioCount > 1 && radioCount == sameCount) {
                    layer.msg('答题选项选择均一致，不允许提交!', { offset: '400px' });
                    return;
                }
                evaluate_Model.Submit_Data();
            } else {
                layer.msg('请填写未提交项', { offset: '400px' });
            }
        }
        else {
            evaluate_Model.Submit_Data();
        }
    },
    Submit_Data: function () { },
}
var Type = 1;

function SubmitQuestion()
{
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
    obj.TableName = $('#table').find('option:selected').text();

    obj.CreateUID = AnswerUID;
    
  
    obj.Type = Type;

    evaluate_Model.Submit_ele = $(".ti");
    evaluate_Model.Is_AddQuesType = false;
    evaluate_Model.Submit_Data = function () {
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
        //        //console.log(JSON.stringify(json));
        //        if (json.result.errMsg == "success") {

        //            var data = json.result.retData;

        //            layer.msg('提交成功!', { offset: '400px' });
        //            page_callBack()
        //        }
        //        else {
        //            layer.msg(json.result.retData, { offset: '400px' });
        //            page_callBack()
        //        }
        //    },
        //    error: function () {
        //        //接口错误时需要执行的
        //    }
        //});
    }
    evaluate_Model.Get_SubData();
}


