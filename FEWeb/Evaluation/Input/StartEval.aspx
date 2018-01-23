<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartEval.aspx.cs" Inherits="FEWeb.Evaluation.Input.StartEval" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>评价统计</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
        .chosen-drop {
            color: black;
        }

        .select_expertdiv {
            height: 322px;
            overflow: auto;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="main">
        <div class="InitiateEval">
            <h2 class="navEval">选择评教老师
                <div class="search_toobar clearfix fr">
                    <div class="fl ml10" id="div_DepartMent">
                        <label for="">所属部门:</label>
                        <select class="select" id="DepartMent">
                            <option value="0">全部</option>
                        </select>
                    </div>
                    <div class="fl ml20">
                        <input type="text" name="key" id="key" placeholder="请输入关键字" value="" class="text fl">
                        <a class="search fl" href="javascript:search();" style="background: #fff;"><i class="iconfont">&#xe600;</i></a>
                    </div>
                </div>
            </h2>
            <div class="select_expertdiv">
                <%--        <ul class="select_expert clearfix" id="teachers">
                </ul>--%>
                <div class="table">
                    <table class="W_form" id="tb_CourseList">
                        <thead>
                            <tr class="trth">
                                <th class="number">序号</th>
                                <th>教师名称</th>
                                <th>部门</th>
                                <th>课程名称</th>
                                <th>课程类别</th>
                                <th>课程性质</th>
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
            <%-- <h2 class="navEval mt20">已选择</h2>
            <div class="select_expertdiv" style="overflow-y: auto; height: 80px; min-height: 80px;">
                <ul id="selected_course" class="slectd">
                  
                </ul>
            </div>--%>
        </div>

        <div class="btnwrap">
            <input type="button" value="确定" onclick="submit()" class="btn">
            <input type="button" value="取消" onclick="parent.CloseIFrameWindow()" class="btna ml10">
        </div>
        <script src="../../Scripts/Common.js"></script>
        <script src="../../Scripts/layer/layer.js"></script>
        <script src="../../Scripts/public.js"></script>
        <script src="../../Scripts/linq.min.js"></script>
        <script src="../../Scripts/jquery.tmpl.js"></script>

        <link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
        <link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
        <script src="../../Scripts/choosen/chosen.jquery.js"></script>
        <script src="../../Scripts/choosen/prism.js"></script>

        <script src="../../Scripts/WebCenter/Base.js"></script>
        <script src="../../Scripts/WebCenter/AllotTask.js"></script>
        <script src="../../Scripts/WebCenter/Room.js"></script>
        <%-- <script type="text/x-jquery-tmpl" id="item_Teachers">
            <li>
                <span>${Teacher_Name}</span>
                <ul>
                    {{each T_C_Model_Childs}}
              <li>
                  <span teacheruid="${TeacherUID}" teacher_name="${Teacher_Name}" course_uniqueno="${Course_UniqueNo}">${Course_Name}</span>
              </li>
                    {{/each}}
           
                </ul>
            </li>
        </script>--%>

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

        <script type="text/x-jquery-tmpl" id="item_ExpertTeacher">
            <li teacheruid="${TeacherUID}" course_uniqueno="${CourseId}">${TeacherName} ${Course_Name}<i class="iconfont">&#xe672;</i></li>
        </script>
        <script>

            var select_sectionid = parent.select_sectionid;
            var select_course_teacher = [];
            var select_reguid = parent.select_reguid;
            var IsAllSchool = parent.IsAllSchool;

            var pageIndex = 0;
            $(function () {

                selectExpertUID = login_User.UniqueNo;
                selectExpertName = login_User.Name;


                $('#DepartMent').on('change', function () {
                    Teachers_Reflesh();
                });

                PageType = 'StartEval';
                PrepareInit();//初始化
                //GetUserByType('16,17');//获取专家     

                if (IsAllSchool == 1) {
                    Base.BindDepartCompleate = function () {
                        $("#DepartMent").val(Number(login_User.Major_ID));
                        //GetTeacherInfo_Course_Cls();//获取教师
                        debugger;
                        GetClassInfo(pageIndex);
                    };
                    Base.BindDepart('248px', false, login_User.Major_ID);
                }
                else {
                    Base.BindDepartCompleate = function () {
                        GetTeacherInfo_Course_Cls();//获取教师
                    };
                    Base.BindDepart('248px', false, '');
                }
            })

            function search() {
                Teachers_Reflesh();
            }

            function submit() {
                AddExpert_List_Teacher_Course();
            }
        </script>
</body>
</html>
