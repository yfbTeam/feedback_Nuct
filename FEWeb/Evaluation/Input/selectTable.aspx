<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="selectTable.aspx.cs" Inherits="FEWeb.Evaluation.Input.selectTable" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>选择评价表</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
        .test_module {
            border: none;
        }

        .test_lists ul li {
            padding-right: 0;
        }

        .tableheader {
            margin-top: 20px;
        }

            .tableheader .evalmes {
                text-align: center;
            }

        .h1_div {
            margin-top: 0;
            background: #f9f4f8;
            height: 40px;
        }

            .h1_div h1 {
                margin-top: 13px;
                margin-left: 20px;
            }


        .tableheader .tablename1 {
            height: 32px;
            text-align: center;
        }

        .tableheader .evalmes span {
            line-height: 40px;
        }

        .test_desc label {
            cursor: pointer;
        }

        .div_header {
            height: 10px;
            margin-bottom: 20px;
            margin-left: 20px;
        }

            .div_header select {
                margin-top: 0px;
            }

        .input_bottom {
            width: 100px;
            border: 0;
            border-bottom: 1px solid #000;
            text-align: center;
        }


        #table_view {
            margin-top: 30px;
        }

        .div_header select {
            min-width: 120px;
        }

        input[Type="radio"] {
            vertical-align: middle;
        }

        .lbl {
            vertical-align: middle;
        }

        .numbers {
            float: none;
        }

        .evalmes2 {
            top: 35%;
            padding: 10px 0;
            position: fixed;
            right: 12%;
            z-index: 99999;
            height: 70px;
            width: 110px;
            background: #A66894;
        }

            .evalmes2 .div1 {
                text-align: center;
                color: white;
                line-height: 35px;
            }

            .evalmes2 .div2 {
                text-align: center;
                line-height: 35px;
                color: white;
            }

                .evalmes2 .div2 label {
                    font-size: 18px;
                }

        .title a {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap ">
            <div class="sort_nav" id="threenav">
            </div>

            <h1 class="title">
                <a id="level1">全部评价</a><span>&gt;</span><a id="GropName">评价</a><span>&gt;</span><a class="crumbs" id="GropName2"></a>
            </h1>

            <div class="evalmes2" style="color: #999999; font-size: 14px">
                <div class="div1">
                    <label>
                        实时总分
                    </label>
                </div>

                <div class="div2">
                    <label id="sp_realtotal">0</label>
                </div>
            </div>

            <div class="tableheader">
                <h1 class="tablename1">
                    <select v-model="" class="tableheader_select" id="table">
                    </select>
                </h1>
                <div class="evalmes" style="color: #999999; font-size: 14px">
                    <span id="sp_total"></span>
                    <span id="remark"></span>
                </div>
                <div class="table_header_left clearfix" id="list">
                </div>

            </div>

            <div class="content">
                <ul id="table_view">
                </ul>
            </div>

            <div class="btnwrap" style="">
               
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/WebCenter/TableDesigin.js"></script>
    <script src="../../Scripts/WebCenter/Room.js"></script>
    <script src="../../Scripts/WebCenter/User.js"></script>
    <script src="../../Scripts/WebCenter/Evaluate.js"></script>

    <script type="text/x-jquery-tmpl" id="EnableItem">
        <input type="button" value="提交" onclick="Submit()" class="btn">
        <input type="button" value="保存" onclick="Save()" class="btn ml10">
        <input type="button" value="取消" class="btna ml10 n_uploadbtn" onclick="window.history.go(-1)">
    </script>

    <script type="text/x-jquery-tmpl" id="DisEnableItem">
        <input type="button" value="提交"  class="btn" style="background:#d7d7d7">
        <input type="button" value="保存"  class="btn" style="background:#d7d7d7">
        <input type="button" value="取消" class="btna ml10 n_uploadbtn" onclick="window.history.go(-1)">
    </script>

    <script type="text/x-jquery-tmpl" id="item_table_view">
        {{if Root.trim() !=''}}
    <div class="content">
        <div class="h1_div">
            <h1 class="test_title" style="display: inline-block">
                <b class="order_num"></b><b>${Root}</b>
            </h1>
        </div>
        {{else}}
            <div class="content " style="margin-top: -20px;">
                {{/if}}    

        <div class="test_module">
            <input type="hidden" value="${indicator_type_tid}" name="name_title" />
            <div class="test_lists">
                <ul>
                    {{each Eva_TableDetail_List}}
                <li class="ti">

                    <input type="hidden" value="${$value.Eva_table_Id}" name="name_title" />
                    <input type="hidden" value="${$value.Id}" name="name_id" />
                    <input type="hidden" value="${QuesType_Id}" name="name_QuesType_Id" />

                    <h2 class="title">${Sort}、 {{if $value.QuesType_Id ==1 }}
                             【单选题】
                             {{else $value.QuesType_Id ==2 }}
                             【多选题】
                             {{else $value.QuesType_Id ==3 }}
                             【问答题】
                             {{else $value.QuesType_Id ==4 }}
                             【选分题】
                             {{/if}} ${$value.Name}
                    {{if $value.QuesType_Id ==1 || $value.QuesType_Id ==4}}
                       <b class="isscore">（<span class="isscore">${OptionF_S_Max}分</span>）</b>

                        {{/if}}
                        
                    </h2>
                    {{if $value.QuesType_Id == 1}}
                    <div class="test_desc">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionA" id="inp_${$value.Id}-1" value="${$value.OptionA_S}" />
                            <label class="lbl" for="inp_${$value.Id}-1">
                                A${$value.OptionA}
                            <b class="isscore">(<span class="numbers">${$value.OptionA_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionB" id="inp_${$value.Id}-2" value="${$value.OptionB_S}" />
                            <label class="lbl" for="inp_${$value.Id}-2">
                                B${$value.OptionB}
                            <b class="isscore">(<span class="numbers">${$value.OptionB_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionC" id="inp_${$value.Id}-3" value="${$value.OptionC_S}" />
                            <label class="lbl" for="inp_${$value.Id}-3">
                                C${$value.OptionC}
                            <b class="isscore">(<span class="numbers">${$value.OptionC_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionD" id="inp_${$value.Id}-4" value="${$value.OptionD_S}" />
                            <label class="lbl" for="inp_${$value.Id}-4">
                                D${$value.OptionD}
                                
                            <b class="isscore">(<span class="numbers">${$value.OptionD_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionE" id="inp_${$value.Id}-5" value="${$value.OptionE_S}" />
                            <label class="lbl" for="inp_${$value.Id}-5">E${$value.OptionE}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionE_S}</span>分)</b>
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input type="radio" name="inp_${$value.Id}" flv="OptionF" id="inp_${$value.Id}-6" value="${$value.OptionF_S}" />
                            <label class="lbl" for="inp_${$value.Id}-6">
                                F${$value.OptionF}
                               
                            <b class="isscore">(<span class="numbers">${$value.OptionF_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                    </div>

                    {{else $value.QuesType_Id==2}}
                    <div class="test_desc test_desc2">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input type="checkbox" flv="OptionA" id="inp_${$value.Id}-1" value="${$value.OptionA_S}" />
                            <label class="lbl" for="inp_${$value.Id}-1">
                            A${$value.OptionA}
                          
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input type="checkbox" flv="OptionB" id="inp_${$value.Id}-2" value="${$value.OptionB_S}" />
                            <label class="lbl" for="inp_${$value.Id}-2">
                            B${$value.OptionB}
                           
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input type="checkbox" flv="OptionC" id="inp_${$value.Id}-3" value="${$value.OptionC_S}" />
                            <label class="lbl" for="inp_${$value.Id}-3">
                            C${$value.OptionC}
                           
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input type="checkbox" flv="OptionD" id="inp_${$value.Id}-4" value="${$value.OptionD_S}" />
                            <label class="lbl" for="inp_${$value.Id}-4">
                            D${$value.OptionD}
                               
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input type="checkbox" flv="OptionE" id="inp_${$value.Id}-5" value="${$value.OptionE_S}" />
                            <label class="lbl" for="inp_${$value.Id}-5">E${$value.OptionE}</label>

                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input type="checkbox" flv="OptionF" id="inp_${$value.Id}-6" value="${$value.OptionF_S}" />
                            <label class="lbl" for="inp_${$value.Id}-6">
                            F${$value.OptionF}
                               
                          
                        </span>
                        {{/if}}
                    </div>

                    {{else $value.QuesType_Id==3}}
                    <div class="test_desc">
                        <textarea></textarea>
                    </div>

                    {{else $value.QuesType_Id==4 }}
                    <div class="test_desc" maxscore="${OptionF_S_Max}">
                        <input type="number" onkeydown="onlyNum();" maxscore="${OptionF_S_Max}" class="text" name="Name" style="width: 100%;" />
                    </div>
                    {{/if}}
                </li>
                    {{/each}}
                </ul>
            </div>
        </div>
            </div>
    </script>
    <%--学年学期7  --%><%--教师3  --%>

    <%--固定表头--%>
    <script type="text/x-jquery-tmpl" id="item_check">
        <div class="fl div_header">
            <label class="lblheader" customcode="${CustomCode}" name="${Value}">
                ${Value}：              
                {{if CustomCode == 4}}
            <select id="major">
            </select>
                {{else  CustomCode == 5}}
            <select id="Cls">
            </select>
                {{else  CustomCode == 6}}
            <select id="Stu">
            </select>
                {{else  CustomCode == 7}} 
           <input readonly="readonly" class="input_bottom" id="section" />
                {{else  CustomCode == 3}}  
           <input readonly="readonly" class="input_bottom" id="teacher" />
                {{else  CustomCode == 2}}  
           <input readonly="readonly" class="input_bottom" id="course" />
                {{else CustomCode == 1}}
             <input readonly="readonly" class="input_bottom" id="dp" />
                {{else 1==1}}
            【${Header}】
                {{/if}}            
            </label>
        </div>
    </script>

    <%--自由表头--%>
    <script type="text/x-jquery-tmpl" id="item_check2">
        <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
            <label class="lblheader" for="" customcode="" name="${Header}">
                ${Header}：<input class="input_bottom" />
            </label>
        </div>
    </script>

    <script>

        var table_Id = 0;

        var SectionID = getQueryString('SectionID');
        var DisplayName = getQueryString('DisplayName');

        var ReguID = getQueryString('ReguID');
        var ReguName = getQueryString('ReguName');

        var TeacherUID = getQueryString('TeacherUID');
        var TeacherName = getQueryString('TeacherName');

        var CourseID = getQueryString('CourseID');
        var CourseName = getQueryString('CourseName');

        var AnswerUID = getQueryString('AnswerUID');
        var AnswerName = getQueryString('AnswerName');

        var DepartmentName = getQueryString('DepartmentName');

        IsAllSchool = getQueryString('IsAllSchool');

        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            UI_Table_View.Get_Eva_TableDetail_Compleate = function (retdata) {

                $('#section').val(DisplayName);
                $('#teacher').val(TeacherName);
                $('#course').val(CourseName);
                $('#dp').val(DepartmentName);
                evaluate_Model.IsScore = retdata.IsScore;
                InitControl(retdata.IsScore);
            };
            UI_Table_View.PageType = 'selectTable';
            Base.BindTableCompleate = function () {
                table_Id = $('#table').val();
                if (table_Id == null) {
                    $("#DisEnableItem").tmpl(1).appendTo(".btnwrap");
                    $('#table').hide();
                    nomessage('#table_view', 'li', 12, 180);
                }
                else {
                    $("#EnableItem").tmpl(1).appendTo(".btnwrap");

                    UI_Table_View.IsPage_Display = true;
                    UI_Table_View.Get_Eva_TableDetail();
                    $('#GropName2').text($('#table').find('option:selected').text());
                }

            };
            Base.BindTable(SectionID, CourseID, true);
            $('#table').on('change', function () {
                table_Id = $('#table').val();
                UI_Table_View.IsPage_Display = true;
                UI_Table_View.Get_Eva_TableDetail();
                $('#GropName2').text($('#table').find('option:selected').text());
                Reflesh();
            });

            Reflesh();


            var level1 = '';
            if (IsAllSchool == 1) {
                $('#threenav').children().eq(0).addClass('selected');
                level1 = $('#threenav').children().eq(0).text();
            }
            else {
                if ($('#threenav').children().length > 1) {
                    $('#threenav').children().eq(1).addClass('selected');
                    level1 = $('#threenav').children().eq(1).text();
                }
                else {
                    $('#threenav').children().eq(0).addClass('selected');
                    level1 = $('#threenav').children().eq(0).text();
                }
            }


            $('#level1').on('click', function () {
                window.location.href = "../EvaluationInput.aspx?IsAllSchool=" + IsAllSchool + "&Id=" + getQueryString('Id') + "&Iid=" + getQueryString('Iid');
            });
            $('#GropName').on('click', function () {
                window.location.href = "./createModal.aspx?IsAllSchool=" + IsAllSchool + "&Id=" + getQueryString('Id') + "&Iid=" + getQueryString('Iid');
            });
            $('#level1').text(level1);

        })

        function Submit() {
            State = 2;
            input();
        }

        function Save() {
            State = 1;
            input();
        }

        function input() {
            HeaderList = [];
            $('.lblheader').each(function (index) {
                var CustomCode = $(this).attr('CustomCode');
                var Name = $(this).attr('Name');
                var ValueID = '';
                var Value = '';

                CustomCode = (CustomCode != undefined && CustomCode != null) ? CustomCode.trim() : "";
                Name = (Name != undefined && Name != null) ? Name.trim() : "";

                if (CustomCode == "" || CustomCode == "2" || CustomCode == "3" || CustomCode == "7") {
                    Value = $(this).find('input').val();
                }
                else {
                    ValueID = $(this).find('select').find('option:selected').val();
                    Value = $(this).find('select').find('option:selected').text();
                }

                var obj = { "CustomCode": CustomCode, "Name": Name, "ValueID": ValueID, "Value": Value };
                HeaderList.push(obj);

            });

            Type = 1;
            Eva_Role = 1;
            Is_AddQuesType = true;
            SubmitQuestionCompleate = function () {
                parent.Reflesh();
            }

            //提交答案
            SubmitQuestion();
        }

        function Reflesh() {
            GetClassInfoSelectCompleate = function () {
                var ClassID = $('#Cls').val();
                GetStudentsSelect(ClassID)
            };
            GetClassInfoSelect(SectionID, TeacherUID, CourseID);

            $('#Cls').on('change', function () {
                var ClassID = $('#Cls').val();
                GetStudentsSelect(ClassID)
            });


        }

    </script>
</body>
</html>
