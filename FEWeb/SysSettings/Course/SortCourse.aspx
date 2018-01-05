﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SortCourse.aspx.cs" Inherits="FEWeb.SysSettings.SortCourse" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>用户管理</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link rel="stylesheet" href="../../css/layout.css" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>


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
    <div>
        <div style="min-height: 445px;" class="wrap clearfix">
            <div class="search_toobar clearfix">
                <div class="fl selectdiv">
                    <label for="">目标分类:</label>
                    <select id="_currsele" class="select">
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">排课分类:</label>
                    <select id="pk" class="select">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">任务性质:</label>
                    <select id="ck" class="select">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label for="">课程性质:</label>
                    <select id="cp" class="select">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label style="letter-spacing: 23px;" for="">部</label>
                    <label for="">门:</label>
                    <select id="dp" class="select">
                        <option value="">全部</option>
                    </select>
                </div>

                <div class="fl selectdiv">
                    <input type="text" name="" id="key" placeholder="请输入关键字" value="" class="text fl">
                    <a class="search fl" href="javascript:;" onclick="GetNoDis_CourseInfo(0);"><i class="iconfont">&#xe600;</i></a>
                </div>


            </div>
            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="ck_head" /></th>
                            <th>课程编码</th>
                            <th>课程名称</th>
                            <th>排课分类</th>
                            <th>课程性质</th>
                            <th>任务性质</th>
                            <th>部门</th>
                            <th>子部门</th>

                        </tr>
                    </thead>
                    <tbody id="ShowCourseInfo">
                    </tbody>
                </table>
            </div>

            <div id="pageBar" class="page"></div>
        </div>
        <div class="btnwrap">
            <input type="button" value="保存" class="btn" onclick="SubmitUpdateCourseSort()" />
            <input type="button" value="取消" class="btna" onclick="CloseW()" />
        </div>
    </div>
</body>
</html>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/public.js"></script>

<script src="../../Scripts/jquery.linq.js"></script>
<script src="../../Scripts/linq.min.js"></script>
<script src="../../Scripts/layer/layer.js"></script>
<script src="../../Scripts/jquery.tmpl.js"></script>
<link href="../../Scripts/kkPage/Css.css" rel="stylesheet" />
<script src="../../Scripts/kkPage/jquery.kkPages.js"></script>
<script src="../../Scripts/pagination/jquery.pagination.js"></script>
<link href="../../Scripts/pagination/pagination.css" rel="stylesheet" />

<link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
<link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
<script src="../../Scripts/choosen/chosen.jquery.js"></script>
<script src="../../Scripts/choosen/prism.js"></script>

<script src="../../Scripts/laypage/laypage.js"></script>
<script src="../../Scripts/WebCenter/SortCourse.js"></script>
<script src="../../Scripts/WebCenter/CourSortMan.js"></script>
<script src="../../Scripts/WebCenter/AllotPeople.js"></script>
<script src="../../Scripts/WebCenter/Base.js"></script>
<%--课程--%>
<script type="text/x-jquery-tmpl" id="item_course">
    <tr>
        <td>
            <input type='checkbox' name="ss" value="${Course_No}" /></td>
        <td>${Course_No}</td>
        <td title="${Course_Name}">${cutstr(Course_Name,18)}</td>
        <td>${PkType}</td>
        <td>${CourseProperty}</td>
        <td>${TaskProperty}</td>
        <td title="${DepartmentName}">${cutstr(DepartmentName,15)}</td>
        <td title="${SubDepartmentName.trim()}">${cutstr(SubDepartmentName.trim(),15)}</td>
    </tr>
</script>

<script type="text/x-jquery-tmpl" id="itemCount">
    <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
</script>

<script type="text/x-jquery-tmpl" id="item_courseType">
    <option value="${Key}">${Value}</option>
</script>
<%--开课单位--%>
<script type="text/x-jquery-tmpl" id="item_College">
    <option value="${Id}">${College_Name}</option>
</script>
<script>
    var pageIndex = 0;
    var pageSize = 7;
    var pageCount;
    var select_sectionid = parent.select_sectionid;
    var course_TypeId = getQueryString('course_TypeId');
    var select_uniques = [];
    //var reUserinfoAll;
    //过滤数据
    var reUserinfoByselect;
    var prent_reUserinfoByselect = parent.UserinfoByNoSort;
    //------------------------------------初始化------------------------------------
    $(function () {

        GetNoDis_CourseInfo(0);
        UI_Course.PageType = "SortCourse";
        select_uniques = [];
        $('#dp').change(function () {
            GetNoDis_CourseInfo(0);
        });
        $('#pk').change(function () {
            GetNoDis_CourseInfo(0);
        });
        $('#ck').change(function () {
            GetNoDis_CourseInfo(0);
        });
        $('#cp').change(function () {
            GetNoDis_CourseInfo(0);
        });
        //UI_Allot.GetProfessInfo();
        //===========获取课程分类，选择课程分类
        UI_Course.GetCourse_Type_Compleate = function () {
            if (course_TypeId != null && course_TypeId > -1) {
                $('#_currsele').val(course_TypeId);
            }
        };

        UI_Course.GetCourse_Type(select_sectionid);
        UI_SortCourse.SubmitUpdateCourseSort_Compleate = function (result) {
            if (result) {
                layer.msg("分配成功！");
                parent.GetCourseInfo();
                parent.CloseIFrameWindow();
            }
            else {
                layer.msg("失败2！");
            }
        };
        Base.BindCourse(select_sectionid);
    });
    //------------------------------------分配课程------------------------------------
    function SubmitUpdateCourseSort() {
        UI_SortCourse.SubmitUpdateCourseSort();
    }
    function CloseW() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }
</script>
