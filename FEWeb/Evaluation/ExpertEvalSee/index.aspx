<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="FEWeb.Evaluation.ExpertEvalSee.index" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>评价录入</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
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
                    <select class="select" id="section" style="width: 198px;">
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
                    <a class="search fl" href="javascript:;" id="select"><i class="iconfont"></i></a>
                </div>


            </div>
            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th>序号</th>
                            <th>学年学期</th>
                            <th>部门</th>
                            <th>教师</th>
                            <th>课程</th>

                            <th>评价表名称</th>

                            <th>得分</th>
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
    <script src="../../js/vue.min.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>

    <link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
    <link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
    <script src="../../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../../Scripts/choosen/prism.js"></script>

    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../../../Scripts/laypage/laypage.js"></script>
    <script src="../../Scripts/WebCenter/Evaluate.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="width: 5%">${Num}</td>
            <td style="width: 5%">${DisPlayName}</td>
            <td title="${Departent_Name}" style="width: 15%">${cutstr(DepartmentName,30)}</td>
            <td style="width: 7%">${TeacherName}</td>
            <td title="${Course_Name}" style="width: 15%">${cutstr(CourseName,30)}</td>

            <td style="width: 30%" title="${TableName}">${cutstr(TableName,45)}</td>
            <td style="width: 5%">${Score.toFixed(2)}</td>


            <td style="width: 5%" class="operate_wrap" style="width: 10px">
                <div class="operate" onclick="table_view('${TableID}','${Id}')">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看</span>
                </div>
            </td>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="itemData_Admin">
        <tr>
            <td style="width: 5%">${Num}</td>
            <td style="width: 5%">${DisPlayName}</td>
            <td title="${Departent_Name}" style="width: 15%">${cutstr(DepartmentName,30)}</td>
            <td style="width: 7%">${TeacherName}</td>
            <td title="${Course_Name}" style="width: 15%">${cutstr(CourseName,30)}</td>

            <td style="width: 30%" title="${TableName}">${cutstr(TableName,45)}</td>
            <td style="width: 5%">${Score}</td>
            {{if State == 1}}
            <td style="width: 5%"><span class="nosubmit">未提交</span></td>
            {{else State == 2}}
              <td style="width: 5%"><span class="checking1">待审核</span></td>
            {{else State == 3}}
               <td style="width: 5%"><span class="pass">入库</span></td>
            {{/if}}             
          
            {{if State == 1}}
       <td class="operate_wrap" style="width: 10px">
           <div class="operate" onclick="table_view('${TableID}','${Id}')">
               <i class="iconfont color_purple">&#xe60b;</i>
               <span class="operate_none bg_purple">查看</span>
           </div>
       </td>

            {{else State == 2}}          
             <td class="operate_wrap" style="width: 10px">
                 <div class="operate" onclick="table_view('${TableID}','${Id}')">
                     <i class="iconfont color_purple">&#xe60b;</i>
                     <span class="operate_none bg_purple">查看</span>
                 </div>
             </td>
            {{else State ==3}}
             <td class="operate_wrap" style="width: 10px">
                 <div class="operate" onclick="table_view('${TableID}','${Id}')">
                     <i class="iconfont color_purple">&#xe60b;</i>
                     <span class="operate_none bg_purple">查看</span>
                 </div>
             </td>
            {{/if}}
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>


    <script>

        var reguType = 1;
        IsAllSchool = getQueryString('IsAllSchool');
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            Mode = 3;
            $('#select').on('click', search);


            Base.bindStudySectionCompleate = function () {
                var SectionID = $('#section').val();
                Base.BindTable(SectionID);
                pageIndex = 0;
                Reflesh();
            };
            Base.bindStudySection();

            $('#section').on('change', function () {

                $("#table").empty();
                $("#table").append('<option >全部</option>');

                var SectionID = $('#section').val();
                Base.BindTable(SectionID);

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

        function search() {
            pageIndex = 0;
            Reflesh();
        }

        function Reflesh() {
            var SectionID = $('#section').val();
            var Key = $('#Key').val();
            var DepartmentID = $('#DepartMent').val();
            var TableID = $('#table').val();

            AnswerUID = login_User.UniqueNo;
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
            OpenIFrameWindow('答题详情', '../EvalDetail.aspx?table_Id=' + table_Id + '&QuestionID=' + QuestionID + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid'), '1000px', '600px')
        };
    </script>
</body>
</html>
