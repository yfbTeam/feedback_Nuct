<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClassInfo.aspx.cs" Inherits="FEWeb.SysSettings.ClassInfo" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂信息维护</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .selectdiv {
            margin-right: 10px;
            margin-bottom: 10px;
        }

        .select {
            width: 150px;
        }
    </style>
</head>

<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <div class="sort_nav" id="threenav">
            </div>
            <div class="search_toobar clearfix">
                <div class="fl selectdiv">
                    <label for="">学年学期:</label>
                    <select class="select" id="section">
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">开课部门:</label>
                    <select class="select" id="DP">
                        <option value="">全部</option>
                    </select>
                </div>

                <div class="fl selectdiv">
                    <label for="">课程类别:</label>
                    <select class="select" id="CT">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">课程性质:</label>
                    <select class="select" id="CP">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">教师所属部门:</label>
                    <select class="select" id="TD">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">教师姓名:</label>
                    <select class="select" id="TN">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">专业部门:</label>
                    <select class="select" id="MD">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label style="letter-spacing: 23px;" for="">年</label>
                    <label for="">级:</label>
                    <select class="select" id="GD">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label style="letter-spacing: 23px;" for="">合</label>
                    <label for="">班:</label>
                    <select class="select" id="CN">
                        <option value="">全部</option>
                    </select>
                </div>


                <div class="fl ml3">
                    <input type="text" name="" id="class_key" placeholder="请输入课堂名称" value="" class="text fl">
                    <a class="search fl" href="javascript:;" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                </div>
                <div class="fr">
                    <input type="button" name="" id="" style="display: none" value="添加" onclick="OpenIFrameWindow('添加课堂信息', 'AddClassInfo.aspx', '800px', '540px')" class="btn">
                </div>
            </div>
            <div class="table">
                <table class="W_form" id="tb_CourseList">
                    <thead>
                        <tr class="trth">
                            <th class="number">序号</th>
                            <th>学年学期</th>
                            <th>开课部门</th>
                            <th>课程名称</th>
                            <th>课程类别</th>
                            <th>课程性质</th>
                            <th>教师所属部门</th>
                            <th>教师姓名</th>
                            <th>专业部门</th>
                            <th>年级</th>
                            <th>合班</th>
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    </tbody>
                </table>
            </div>
            <div id="pageBar" class="page"></div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>

    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <script src="../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../Scripts/choosen/prism.js"></script>

    <script src="../Scripts/WebCenter/Base.js"></script>
    <script src="../Scripts/WebCenter/Room.js"></script>

    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="width: 3%">${Num}</td>
            <td style="width: 7%">${DisPlayName}</td>
            <td title="${DepartmentName}" style="width: 13%">${cutstr(DepartmentName,15)}</td>
            <td title="${Course_Name}" style="width: 13%">${cutstr(Course_Name,15)}</td>
            <td title="${CourseType}" style="width: 7%">${cutstr(CourseType,8)}</td>
            <td style="width: 7%">${CourseProperty}</td>
            <td title="${TeacherDepartmentName}" style="width: 13%">${cutstr(TeacherDepartmentName,15)}</td>
            <td title="${Teacher_Name}" style="width: 5%">${cutstr(Teacher_Name,7)}</td>
            <td title="${CourseDepartmentName}" style="width: 13%">${cutstr(CourseDepartmentName,15)}</td>
            <td style="width: 5%">${GradeInfo_Name}</td>
            <td title="${ClassName}" style="width: 19%">${cutstr(ClassName,15)}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>

    <script>
        var pageIndex = 0;

        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            Base.bindStudySection();
            GetClassInfo(pageIndex);

            GetClassInfoSelect();

            $("#DP,#CT,#CP,#TD,#TN,#MD,#GD,#CN").on('change', function () {
                pageIndex = 0;
                GetClassInfo(pageIndex);
            });

            $("#section").on('change', function () {
                pageIndex = 0;
                GetClassInfo(pageIndex);
            });
        })

        function SelectByWhere() {
            pageIndex = 0;
            GetClassInfo(pageIndex);
        }

    </script>
</body>
</html>

