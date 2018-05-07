<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourSortMan.aspx.cs" Inherits="FEWeb.SysSettings.CourSortMan" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课程分类</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .menu_list li .operates {
            position: absolute;
            right: 10px;
            top: 8px;
            line-height: 22px;
            z-index: 11;
        }

        .menu .menu_list li .operate {
            text-align: center;
            min-width: 32px;
        }

        .menu_list li em {
            display: block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            line-height: 36px;
        }

        .menu_list li ul li:before {
            width: 5px;
            height: 5px;
            content: '';
            border-radius: 50%;
            display: block;
            background: #C1E68E;
            position: absolute;
            left: 8px;
            top: 15px;
        }

        .menu_list li ul li {
            padding: 0px 10px 0px 20px;
        }
    </style>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <div class="sort_nav" id="threenav">
            </div>
            <div class="sortwrap clearfix">
                <div class="menu fl">
                    <h1 class="titlea">课程分类
                    </h1>
                    <ul class="menu_list" id="menu_listscours">
                    </ul>

                </div>
                <div class="sort_right fr mr" style="margin-left: -20px">
                    <div class="search_toobar clearfix">
                        <div class="fl mr10" style="display:none;" id="div_CourseType">
                            <label for="">课程分类:</label>
                            <select id="sel_CourseType" secid="" class="select" style="width:150px;"></select>
                        </div>
                        <div class="fl">
                            <input type="text" name="" id="select_where" placeholder="请输入课程编码或课程名称关键字" value="" style="width:220px;" class="text fl">
                            <a class="search fl" href="javascript:;" onclick="all_change();"><i class="iconfont">&#xe600;</i></a>
                        </div>
                        <div class="fr" style="display: block" id="operator">
                        </div>
                    </div>
                    <div class="table">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 10%;">课程编码</th>
                                    <th style="width: 15%;">课程名称</th>
                                    <th style="width: 10%;">排课分类</th>
                                    <th style="width: 10%;">课程性质</th>
                                    <th style="width: 10%;">任务性质</th>
                                    <th style="width: 15%;">部门</th>
                                    <th style="width: 15%;">子部门</th>
                                    <th style="width: 10%;">课程分类</th>
                                    <th style="width: 10%;">操作</th>
                                </tr>
                            </thead>
                            <tbody id="ShowCourseInfo">
                            </tbody>
                        </table>
                    </div>
                    <div id="pageBar" class="page"></div>
                </div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script src="../../Scripts/WebCenter/CourSortMan.js"></script>
    <script id="Courseinfo_tmpl" type="text/x-jquery-tmpl">
        <tr>
            <td>${Course_No}</td>
            <td title="${Course_Name}">${cutstr(Course_Name,18)}</td>
            <td>${PkType}</td>
            <td>${CourseProperty}</td>
            <td>${TaskProperty}</td>
            <td title="${DepartmentName}">${cutstr(DepartmentName,15)}</td>
            <td title="${SubDepartmentName.trim()}">${cutstr(SubDepartmentName.trim(),15)}</td>
            <td>${CourseRel_Name}</td>
            <td>{{if CourseRel_Id ==''}}
                 <div class="operate">
                     <i class="iconfont color_gray">&#xe798;</i>
                     <span class="operate_none bg_gray" style="display: none;">移除      
                     </span>
                 </div>
                {{else}}
                 <div class="operate" onclick="removeCourseDis('${CourseRelID}','${Course_Name}')">
                     <i class="iconfont color_purple">&#xe798;</i>
                     <span class="operate_none bg_purple" style="display: none;">移除      
                     </span>
                 </div>
                {{/if}}               
            </td>
        </tr>
    </script>
    <script id="course_item" type="text/x-jquery-tmpl">
        <li sectionid='${course_parent.SectionId}'>
            <span onclick="GetCourseinfoBySortManType('{{= course_parent.SectionId}}')">${course_parent.DisPlayName}<i class="iconfont">&#xe643;</i></span>
            <ul>
                {{each objectlist}}
                <li class="typeli" regustate="${ReguState}" ctypeK="{{= $value.Key}}" ctypeV="{{= $value.Value}}">
                    <em title="{{= $value.Value}}" onclick="GetCourseinfoBySortMan('{{= $value.Key}}','{{= $value.Value}}','{{= $value.SectionId}}')">{{= cutstr($value.Value,10)}}</em>

                    {{if ReguState == 3}}                        
                         <div class="operates">
                             <div class="operate">
                                 <i class="iconfont color_gray">&#xe632;</i>
                             </div>
                             <div class="operate ml5">
                                 <i class="iconfont color_gray">&#xe61b;</i>
                             </div>
                         </div>
                    {{else}}
                       <div class="operates">
                           <div class="operate" onclick="GetCourseinfoBySortMan('{{= $value.Key}}','{{= $value.Value}}','{{= $value.SectionId}}');OpenIFrameWindow('设置分类', 'AddCourseSort.aspx?id={{= $value.Id}}&Name={{= $value.Value}}&IsEnable={{= $value.IsEnable}}', '500px', '280px')">
                               <i class="iconfont color_purple">&#xe632;</i>
                               <a class='operate_none bg_purple'>设置</a>
                           </div>
                           <div class="operate ml5" onclick="GetCourseinfoBySortMan('{{= $value.Key}}','{{= $value.Value}}','{{= $value.SectionId}}');remove('{{= $value.Id}}','{{= $value.Value}}');">
                               <i class="iconfont color_purple">&#xe61b;</i>
                               <a class='operate_none bg_purple'>删除</a>
                           </div>
                       </div>
                    {{/if}}
                   
                </li>
                {{/each}}                                     
                {{if course_parent.Study_IsEnable == 0}}
                  <input type="button" value="新增分类" style="display: block" class="new" onclick="OpenIFrameWindow('新增分类', 'AddCourseSort.aspx?itemid=0&SectionId={{= course_parent.SectionId}}&IsEnable=0', '500px', '280px')" />
                {{else course_parent.Study_IsEnable== 1}}
                  <input type="button" value="新增分类" style="display: block; background: #A8A8A8" class="new" />
                {{/if}}
              
            </ul>
        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>

    <script type="text/x-jquery-tmpl" id="itemAllot">
        <input type="button" value="分配评价表" class="btn mr10" onclick="OpenTableAllot()" />
        <input type="button" name="" value="分配课程" class="btn" onclick="dis_course();">
    </script>

    <script type="text/x-jquery-tmpl" id="itemAllotNo">
        <%-- <input type="button" value="分配评价表" class="btn mr10" style="background: #A8A8A8" />--%>
        <input type="button" value="分配评价表" class="btn mr10" onclick="OpenTableAllot(-1)" />
        <input type="button" name="" value="分配课程" class="btn" style="background: #A8A8A8">
    </script>
</body>
</html>

<script>
    var select_sectionid = '';
    var returnVal_Courseinfo;
    var reUserinfoByselect
    var UserinfoByNoSort;
    //当前选择的课程类型
    var select_CourseTypeId = '';
    //当前选择的课程类型
    var select_CourseTypeName = '';
    var pageIndex = 0;
    var pageSize = 10;
    var pageCount;
    $(function () {
        $('#top').load('/header.html');
        $('#footer').load('/footer.html');
        UI_Course.PageType = 'CourSortMan';

        UI_Course.GetCourse_Type();

    });
    function menu_list() {
        UI_Course.menu_list();
    }
    function GetCourse_Type() {
        //获取课程分类
        UI_Course.GetCourse_Type();
    }
    function GetCourseInfo() {
        var key = $("#select_where").val();
        UI_Course.GetCourseInfo(pageIndex, select_sectionid, key, select_CourseTypeId);
    }
    //设置课程分类为未分类状态
    function SetIsEnable(Course_Id, isenable) {
        UI_Course.SetIsEnable(Course_Id, isenable);
    }
    //点击课程分类
    function GetCourseinfoBySortMan(key, value, SectionId) {
        $("#div_CourseType").hide();
        select_CourseTypeId = key;
        select_CourseTypeName = value;
        select_sectionid = SectionId;
        pageIndex = 0;
        UI_Course.select_CourseTypeId = key;
        UI_Course.select_CourseTypeName = value;
        var key = $("#select_where").val().trim();

        UI_Course.GetCourseInfo(pageIndex, select_sectionid, key, select_CourseTypeId);
    }

    //点击课程分类
    function GetCourseinfoBySortManType(SectionId) {        
        select_CourseTypeId = -1;
        select_CourseTypeName = '';
        select_sectionid = SectionId;
        pageIndex = 0;
        UI_Course.select_CourseTypeId = -1;
        UI_Course.select_CourseTypeName = '';
        var key = $("#select_where").val().trim();
        BindSel_CourseType(SectionId);
        UI_Course.GetCourseInfo(pageIndex, select_sectionid, key, select_CourseTypeId);
    }
    function BindSel_CourseType(SectionId) { //绑定课程分类
        $("#div_CourseType").show();
        var $sel_CourseType = $("#sel_CourseType");
        $sel_CourseType.attr('secid', SectionId);
        $sel_CourseType.empty().append('<option value="-1" selected="selected">全部</option><option value="null">未分类</option>');
        var curtypes = $('#menu_listscours li[sectionid=' + SectionId + ']').find('ul li');
        $(curtypes).each(function (i, n) {
            $sel_CourseType.append('<option value="' + $(this).attr('ctypeK') + '">' + $(this).attr('ctypeV') + '</option>');
        });
        $sel_CourseType.on('change', function () {
            pageIndex = 0;
            var key = $("#select_where").val().trim();
            select_CourseTypeId = $(this).val();
            UI_Course.GetCourseInfo(pageIndex, $(this).attr('secid'), key, select_CourseTypeId);
        });
    }
    //搜索
    function all_change() {
        var key = $("#select_where").val().trim();
        UI_Course.GetCourseInfo(pageIndex, select_sectionid, key, select_CourseTypeId);
    }
    //分配课程
    function dis_course() {
        OpenIFrameWindow('分配课程', 'SortCourse.aspx?course_TypeId=' + select_CourseTypeId, '1000px', '600px')
    }
    //删除课程分类
    function remove(id, value) {
        layer.confirm('确定删除' + value + '吗？', {
            btn: ['确定', '取消'], //按钮
            title: '操作'
        }, function () { UI_Course.remove(id) });
    }

    function OpenTableAllot(state) {
        OpenIFrameWindow('分配表格', 'EvalTableAllot.aspx?Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid') + '&select_CourseTypeId=' + select_CourseTypeId + '&select_CourseTypeName=' + select_CourseTypeName + '&state=' + state, '1000px', '650px');
    }
</script>

