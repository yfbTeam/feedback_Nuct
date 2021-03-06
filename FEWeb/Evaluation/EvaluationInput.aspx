﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvaluationInput.aspx.cs" Inherits="FEWeb.Evaluation.EvaluationInput" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>评价录入</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .regularEval {
            color: #179720;
        }

        .selfEval {
            color: #B25F83;
        }

        .search_toobar .text {
            width: 165px;
            margin-top: 1px;
        }

        .search {
            margin-top: 1px;
        }
    </style>
    <script type="text/x-jquery-tmpl" id="itembtn_Enable">
        <button class="btn ml10" onclick="OpenIFrameWindow('发起评教','./input/StartEval.aspx','1000px','650px')">发起评教</button>
    </script>
    <script type="text/x-jquery-tmpl" id="itembtn_No_Enable">
        <button class="btn ml10" style="background: #A8A8A8">发起评教</button>
    </script>
</head>
<body>
    <div id="top"></div>

    <div class="center" id="centerwrap">
        <div class="wrap clearfix" id="EvaluationInput">
            <div class="sort_nav" id="threenav">
            </div>

            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 128px;">
                        <%-- <option value="">全部</option>--%>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">部门:</label>
                    <select class="select" id="DepartMent" style="width: 148px;">
                        <option value="">全部</option>
                    </select>
                </div>

                <div class="fl ml10">
                    <label for="">评价表:</label>
                    <select class="select" id="table" style="width: 188px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <input type="text" name="" id="Key" placeholder="请输入课程、教师关键字" value="" class="text fl">
                    <a class="search fl" href="javascript:;" onclick="tool_search();" id="select"><i class="iconfont"></i></a>
                </div>
                
                <div class="fr pr">
                    <button class="btn" onclick="evalTask()">评价任务</button>
                    <b class="dian" style="display: none"></b>
                </div>
                <div class="fr mr10" id="btCtrl">
                </div>
            </div>
            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th>序号</th>
                            <th>学年学期</th>
                            <th>评价名称</th>
                            <th>部门</th>
                            <th>教师</th>
                            <th>课程</th>
                            <th>班级</th>
                            <th>学生</th>
                            <th>评价表名称</th>
                            <th>得分</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    </tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../js/vue.min.js"></script>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/layer/layer.js"></script>

    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <script src="../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../Scripts/choosen/prism.js"></script>

    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/WebCenter/Base.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script src="../Scripts/WebCenter/Evaluate.js"></script>
    <script src="../Scripts/WebCenter/RegularEval.js"></script>
    <script src="../Scripts/WebCenter/Base.js"></script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="width: 5%">${Num}</td>
            <td style="width: 5%">${DisPlayName}</td>
            <td style="width: 8%">${ReguName}</td>
            <td title="${Departent_Name}" style="width: 13%">${cutstr(DepartmentName,30)}</td>
            <td style="width: 5%">${TeacherName}</td>
            <td title="${Course_Name}" style="width: 13%">${cutstr(CourseName,30)}</td>
            <td title="${HeaderClassName}" style="width: 6%">${cutstr(HeaderClassName,10)}</td>
            <td title="${HeaderStuName}" style="width: 6%">${cutstr(HeaderStuName,10)}</td>
            <td style="width: 15%" title="${TableName}">${cutstr(TableName,45)}</td>
            <td style="width: 5%">{{if IsScore}}${Score.toFixed(2)}{{else}}-{{/if}}</td>
            {{if State == 1}}
            <td style="width: 5%"><span class="nosubmit">未提交</span></td>
            {{else State == 2}}
              <td style="width: 5%"><span class="checking1">待审核</span></td>
            {{else State == 3}}
               <td style="width: 5%"><span class="pass">已入库</span></td>
            {{else State == 4}}
               <td style="width: 5%"><span class="nopass">不入库</span></td>
            {{/if}}                              
           <td class="operate_wrap" style="width: 10px">
               <div class="operate" onclick="table_view('${TableID}','${Id}')">
                   <i class="iconfont color_purple">&#xe60b;</i>
                   <span class="operate_none bg_purple">查看</span>
               </div>
               {{if State == 1|| State ==4}}                      
                   {{if DateTimeConvert(RegStartTime,'yyyy-MM-dd HH:mm',true)<= getNowFormatDateTime()&& DateTimeConvert(RegEndTime,'yyyy-MM-dd HH:mm',true) >= getNowFormatDateTime()}}
                   <div class="operate" onclick="window.location.href='./input/EvalTable.aspx?IsAllSchool='+IsAllSchool+'&Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid') +'&TeacherUID='+'${TeacherUID}'+'&TeacherName='+'${TeacherName}'
                      +'&SectionID='+'${SectionID}'+'&DisPlayName='+'${DisPlayName}'+'&CourseID='+'${CourseID}'+'&CourseName='+'${CourseName}'+'&ReguID='+'${ReguID}'+'&ReguName='+'${ReguName}'
                      +'&AnswerUID='+'${AnswerUID}'+'&AnswerName='+'${AnswerName}'+'&DepartmentName='+'${DepartmentName}'+'&QuestionID='+ '${Id}'+'&table_Id='+ '${TableID}'+'&TableName='+ '${TableName}'+'&RoomID='+ '${RoomID}'+'&RelationID='+ '${RelationID}'+'&ClassID='+ '${ClassID}'+'&ClassName='+ '${ClassName}'">
                       <i class="iconfont color_purple">&#xe617;</i>
                       <span class="operate_none bg_purple">编辑</span>
                   </div>
                   {{else}}
                        <div class="operate">
                            <i class="iconfont color_gray">&#xe617;</i>
                            <span class="operate_none bg_gray">编辑</span>
                        </div>
                   {{/if}}
                   <div class="operate" onclick="remove('${Id}');">
                       <i class="iconfont color_purple"></i>
                       <span class="operate_none bg_purple">删除</span>
                   </div>
               {{else State == 2||State ==3}}    
                <div class="operate">
                    <i class="iconfont color_gray">&#xe617;</i>
                    <span class="operate_none bg_gray">编辑</span>
                </div>
               <div class="operate">
                   <i class="iconfont color_gray"></i>
                   <span class="operate_none bg_gray">删除</span>
               </div>
               {{/if}}          
           </td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>


    <script>

        var reguType = 1;
        IsAllSchool = getQueryString('IsAllSchool');
        ModelType = IsAllSchool == 1 ? 2 : 3;
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            Mode = 1;
            FuncType = 1;            
            SourceType = IsAllSchool == 1 ? 1 : 2;
            Base.bindStudySectionCompleate = function () {
                SectionID = $('#section').val();
                Base.BindTable(SectionID,'',true);
                pageIndex = 0;
                Reflesh();
                if (IsAllSchool == 1)
                {                   
                    DepartmentID = login_User.Major_ID;                  
                }
                SelectUID = login_User.UniqueNo;
                Get_Eva_RegularDataCompleate = function (result) {
                    if (result) {
                        $('.dian').show();
                    } else { $('.dian').hide(); }
                };               
                Get_Eva_RegularData();
            };
            Base.bindStudySection();
            Base.CheckHasExpertReguCompleate = function (result, data) {
                $('#btCtrl').empty();
                if (result) {
                    $("#itembtn_Enable").tmpl(1).appendTo("#btCtrl");
                    select_sectionid = data[0].Section_Id;
                    select_reguid = data[0].Id;
                }
                else {
                    $("#itembtn_No_Enable").tmpl(1).appendTo("#btCtrl");
                }
            };
            Base.CheckHasExpertRegu(reguType);           
            $('#section').on('change', function () {

                $("#table").empty();
                $("#table").append('<option >全部</option>');

                SectionID = $('#section').val();
                Base.BindTable(SectionID, '', true);
                pageIndex = 0;
                Reflesh();
            });

            $('#DepartMent').on('change', function () {
                pageIndex = 0;
                Reflesh();
            });
            $('#table').on('change', function () {
                pageIndex = 0;
                Reflesh();
            });

            Base.BindDepart('188px');
        })
        function evalTask() {
            OpenIFrameWindow('评价任务', './Input/createModal.aspx?IsAllSchool=' + IsAllSchool+'', '1000px', '600px')
        }
        function tool_search() {
            pageIndex = 0;
            Reflesh();
        }

        function Reflesh() {
            var SectionID = $('#section').val();
            var Key = $('#Key').val();
            Key = Key != undefined ? Key.trim() : '';
            var DepartmentID = $('#DepartMent').val();
            var TableID = $('#table').val();
          
            AnswerUID = login_User.UniqueNo;
            State = 0;
            Get_Eva_QuestionAnswer(pageIndex, SectionID, DepartmentID, Key, TableID);
        }
        function remove(id) {
            layer.confirm('确定要删除？', {
                btn: ['确定', '取消'],//按钮
                title: '操作'
            }, function () {
                Remove_Eva_QuestionAnswer(id);
            });
        }
        function table_view(table_Id, QuestionID) {
            OpenIFrameWindow('答题详情', 'EvalDetail.aspx?table_Id=' + table_Id + '&QuestionID=' + QuestionID + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid'), '1000px', '600px')
        };
        function navicate(TableCount, TeacherUID, TeacherName, SectionID, DisPlayName, CourseID, Course_Name, ReguID, ReguName, ExpertUID, ExpertName, Departent_Name, RoomID, RelationID,ClassID,ClassName) {
            if (TableCount > 0) {
                window.location.href = './selectTable.aspx?IsAllSchool=' + IsAllSchool + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid') + '&TeacherUID=' + TeacherUID + '&TeacherName=' + TeacherName
                    + '&SectionID=' + SectionID + '&DisPlayName=' + DisPlayName + '&CourseID=' + CourseID + '&CourseName=' + Course_Name + '&ReguID=' + ReguID + '&ReguName=' + ReguName
                    + '&AnswerUID=' + ExpertUID + '&AnswerName=' + ExpertName + '&DepartmentName=' + Departent_Name + '&RoomID=' + RoomID + '&RelationID=' + RelationID + '&ClassID=' + ClassID + '&ClassName=' + ClassName;
            } else {
                layer.confirm('该课程没有相关的评价表！<br>请联系管理员进行处理。', {
                    btn: ['确定'],
                    title: '操作'
                }, function (index) { layer.close(index); });
            }
        }
    </script>
</body>
</html>
