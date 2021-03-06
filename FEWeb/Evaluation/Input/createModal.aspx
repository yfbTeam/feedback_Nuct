﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="createModal.aspx.cs" Inherits="FEWeb.Evaluation.Input.createModal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="/images/favicon.ico" rel="shortcut icon" />
    <title>评价录入</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
          .title a {
            cursor: pointer;
        }
    </style>
   
</head>
<body>
        <div class="main" id="createInput">
            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 198px;">
                    </select>
                </div>

                <div class="fl ml10">
                    <label for="">评价名称:</label>
                    <select class="select" id="Rg" style="width: 198px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">教师姓名:</label>
                    <select class="select" id="Te" style="width: 198px;">
                        <option value="">全部</option>
                    </select>
                </div>

                
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th>序号</th>
                            <th>学年学期</th>
                            <th>评价名称</th>
                            <th>截止时间</th>
                            <th>评价课程</th>
                            <th>被评价教师</th>
                            <th>部门</th>
                            <th>班级</th>
                            <th>已评价次数</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="ShowCourseInfo">
                    </tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
        </div>
        <script src="../../js/vue.min.js"></script>
        <script src="../../Scripts/Common.js"></script>
        <script src="../../Scripts/layer/layer.js"></script>
        <script src="../../Scripts/public.js"></script>
        <script src="../../Scripts/jquery.tmpl.js"></script>

        <link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
        <link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
        <script src="../../Scripts/choosen/chosen.jquery.js"></script>
        <script src="../../Scripts/choosen/prism.js"></script>

        <script src="../../Scripts/WebCenter/Base.js"></script>
        <script src="../../Scripts/WebCenter/RegularEval.js"></script>
        <script src="../../Scripts/laypage/laypage.js"></script>

        

        <script type="text/x-jquery-tmpl" id="itemCount">
            <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
        </script>

        <script type="text/x-jquery-tmpl" id="itemData">
            <tr>
                <td style="width: 5%">${Num}</td>
                <td style="width: 10%">${DisPlayName}</td>
                <td title="${ReguName}">${cutstr(ReguName,10)}</td>
                <td style="width: 10%">${ DateTimeConvert(EndTime, 'yy-MM-dd', true)}</td>
                <td title="${Course_Name}">${cutstr(Course_Name,30)}</td>
                <td>${TeacherName}</td>
                <td title="${Departent_Name}">${cutstr(Departent_Name,30)}</td>
                <td title="${ClassName}">${cutstr(ClassName,15)}</td>
                <td>${AnswerCount}</td>
                {{if StateType == 2}}
          <td style="width: 5%" class="operate_wrap">
              <div class="operate" onclick="parent.navicate(${TableCount},'${TeacherUID}','${TeacherName}','${SectionID}','${DisPlayName}','${CourseID}','${Course_Name}','${ReguId}','${ReguName}','${ExpertUID}','${ExpertName}','${Departent_Name}','${RoomID}','${Id}','${ClassID}','${ClassName}');">
                  <i class="iconfont color_purple">&#xe617;</i>
                  <span class="operate_none bg_purple">评价</span>
              </div>
          </td>
                {{else}}          
             <td style="width: 5%" class="operate_wrap">
                 <div class="operate">
                     <i class="iconfont color_gray">&#xe617;</i>
                     <span class="operate_none bg_gray">评价</span>
                 </div>
             </td>
                {{/if}}
            </tr>
        </script>
       
        <script>
            var reguType = 1;
            var select_sectionid = 0;
            var select_reguid = 0;
            var pageIndex = 0;
           
            IsAllSchool = getQueryString('IsAllSchool');
            SourceType = IsAllSchool == 1 ? 1 : 2;
            $(function () {
                
                ModelType = IsAllSchool == 1 ? 2 : 3;

                Base.bindStudySectionCompleate = function () {
                    $('#section').on('change', function () {

                        SectionID = $('#section').val();
                        $("#Rg").empty();
                        $("#Rg").append("<option value=''>全部</option>");

                        Get_Eva_RegularDataSelect();
                        Reflesh();
                    });
                    SectionID = $('#section').val();
                    Get_Eva_RegularDataSelect();
                    Reflesh();
                };
                Base.bindStudySection();

                SelectUID = login_User.UniqueNo;
                SectionID = select_sectionid

                Get_Eva_RegularDataSelectCompleate = function () {
                    $('#Rg').on('change', function () {
                        Reflesh();
                    });

                    $('#Te').on('change', function () {
                        Reflesh();
                    });
                };
                Base.CheckHasExpertRegu(reguType);            
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
                $('#level1').text(level1);
            })


            function Reflesh() {
                pageIndex = 0;
                Te = $('#Te').val();
                SectionID = $('#section').val();
                Get_Eva_RegularData($('#Rg').val(), pageIndex);
            }
        </script>
</body>
</html>
