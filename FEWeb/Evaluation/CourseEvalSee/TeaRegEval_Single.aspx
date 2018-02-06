<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeaRegEval_Single.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.TeaRegEval_Single" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价查看</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix" id="courseEvalSee">
            <div class="sort_nav" id="threenav">
            </div>

            <h1 class="title mb20">
                <div style="width: 1170px; cursor: pointer; z-index: 99; background: #fff; padding: 10px 0px;">
                    <div class="crumbs">
                        <a onclick="window.location.href='indexqcode.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')">课堂扫码评价</a>
                        <span>&gt;</span>
                        <a href="javascript:;" style="cursor: pointer;" onclick="window.location=window.location.href" id="couse_name">详情</a>

                    </div>
                </div>
            </h1>


            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th>序号</th>
                            <th>学年学期</th>
                            <th>评价名称</th>
                            <th>课程名称</th>
                            <th>合班</th>
                            <th>学生姓名</th>
                            <th>提交时间</th>
                            <th>分数</th>
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

    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script src="../../Scripts/WebCenter/Evaluate.js"></script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="width: 5%">${Num}</td>
            <td style="width: 5%">${DisPlayName}</td>
            <td style="width: 7%">${ReguName}</td>
            <td style="width: 15%">${CourseName}</td>
            <td style="width: 15%" title="${ClassName}">${cutstr(ClassName,10)}</td>

            <td style="width: 15%">${AnswerName}</td>
            <td style="width: 15%">${DateTimeConvert(CreateTime,'yyyy-MM-dd HH:mm',true)}</td>

            {{if State == 1}}
            <td style="width: 5%">${Score}</td>
            {{else State == 2}}
            <td style="width: 5%">-</td>
            {{/if}}                                  
           <td class="operate_wrap" style="width: 10px">
               <div class="operate" onclick="table_view('${TableID}','${Id}')">
                   <i class="iconfont color_purple">&#xe60b;</i>
                   <span class="operate_none bg_purple">查看</span>
               </div>
           </td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>

    <script>

        var pageIndex = 0;
        var SectionID = getQueryString('SectionID');
        ReguID = getQueryString('ReguID');
        CourseID = getQueryString('CourseID');
        TeacherUID = getQueryString('TeacherUID');
        Eva_Role = getQueryString('Type');
        TableID = getQueryString('TableID');
        var DepartmentID, Key;


        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            Type = 1;
            CreateUID = login_User.UniqueNo;
            Reflesh();
           
            $('#threenav').children().eq(0).addClass('selected');
        })

        function Reflesh() {
            IsAllSchool = 3;
            Get_Eva_QuestionAnswer(pageIndex, SectionID, DepartmentID, Key, TableID);
        }

        function table_view(table_Id, QuestionID) {
            OpenIFrameWindow('答题详情', '../EvalDetail.aspx?table_Id=' + table_Id + '&QuestionID=' + QuestionID + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid'), '1000px', '600px')
        };
    </script>
</body>
</html>
