﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegularEval.aspx.cs" Inherits="FEWeb.SysSettings.RegularEval" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>专家评价</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link rel="stylesheet" href="../../css/layout.css" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
        .input-wrap .text {
            margin-left: 0px;
        }


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

        /*.operates {
            display: none;
        }

        .new {
            display: none;
        }

        .btn {
            display: none;
        }*/
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
                    <h1 class="titlea">学年学期</h1>
                    <ul class="menu_list" id="menu_listscours" style="height:545px;overflow:auto;">
                    </ul>

                </div>
                <div class="sort_right fr">
                    <div class="search_toobar clearfix">
                        <div class="fl">
                            <input type="text" name="" id="key" placeholder="请输入教师名称" value="" class="text fl">
                            <a class="search fl" href="javascript:;" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                        </div>
                        <div class="fr " id="operator">
                        </div>
                    </div>
                    <div class="table">
                        <table>
                            <thead>
                                <tr>
                                    <th>序号</th>
                                    <th>评价名称</th>
                                    <th>授课教师</th>
                                    <th>学院</th>
                                    <th>课程名称</th>
                                    <th>评价人</th>
                                    <th>状态</th>
                                    <th>操作</th>
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
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        })
    </script>
    <script type="text/x-jquery-tmpl" id="item_StudySection">
        <li>${DisPlayName}<input type="hidden" name="semester" value="${Id}" /><input type="hidden" name="starttime" value="${DateTimeConvert(StartTime,'yy-MM-dd',true)}" /><input type="hidden" name="endtime" value="${DateTimeConvert(EndTime,'yy-MM-dd',true)}" />
        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td>${Num}</td>
            <td title="${ReguName}">${cutstr(ReguName,10)}</td>
            <td>${TeacherName}</td>
            <td title="${Departent_Name}" style="width: 25%">${cutstr(Departent_Name,30)}</td>
            <td title="${Course_Name}" style="width: 25%">${cutstr(Course_Name,30)}</td>
            <td>${ExpertName}</td>
            <td>${State}</td>
            {{if StateType == 2 || StateType ==3}}
             <td class="operate_wrap">
                 <div class="operate">
                     <i class="iconfont color_gray">&#xe61b;</i>
                     <span class="operate_none bg_gray">删除</span>
                 </div>
             </td>
            {{else StateType ==1}}          
             <td class="operate_wrap">
                 <div class="operate" onclick='remove_data(${Id})'>
                     <i class="iconfont color_purple">&#xe61b;</i>
                     <span class="operate_none bg_purple">删除</span>
                 </div>
             </td>
            {{/if}}
        </tr>
    </script>


    <script id="course_item" type="text/x-jquery-tmpl">
        <li sectionid='${course_parent.SectionId}'>
            <span>${course_parent.DisPlayName}<i class="iconfont">&#xe643;</i></span>
            <ul>
                {{each objectlist}}
                <li regustate="${ReguState}">
                    <em title="{{= $value.Value}}" onclick="GetCourseinfoBySortMan('{{= $value.Id}}')">{{= cutstr($value.Value,10)}}</em>

                    {{if mange == true || rid ==1}}
                     <div class="operates">
                         {{if ReguState == 1}}                        
                         
                         <div class="operate" onclick="OpenIFrameWindow('编辑评价', 'EditEval.aspx?Id={{= $value.Id}}', '600px', '250px')">
                             <i class="iconfont color_purple">&#xe632;</i>
                             <a class='operate_none bg_purple'>设置</a>
                         </div>
                         <div class="operate ml5" onclick="remove('{{= $value.Id}}','{{= $value.Value}}');">
                             <i class="iconfont color_purple">&#xe61b;</i>
                             <a class='operate_none bg_purple'>删除</a>
                         </div>

                         {{else ReguState ==2}}
                         <div class="operate" onclick="OpenIFrameWindow('编辑评价', 'EditEval.aspx?Id={{= $value.Id}}', '600px', '250px')">
                             <i class="iconfont color_purple">&#xe632;</i>
                             <a class='operate_none bg_purple'>设置</a>
                         </div>
                         <div class="operate ml5">
                             <i class="iconfont color_gray">&#xe61b;</i>
                         </div>
                         {{else ReguState ==3}}
                        <div class="operate">
                            <i class="iconfont color_gray">&#xe632;</i>
                        </div>
                         <div class="operate ml5">
                             <i class="iconfont color_gray">&#xe61b;</i>
                         </div>
                         {{/if}}
                     </div>
                    {{else}}
                    {{/if}}

                   
                </li>
                {{/each}}     
                
                 {{if mange || rid ==1}}
                                               
                {{if course_parent.Study_IsEnable == 0 }}
                <input type="button" value="新增评价" class="new" onclick="OpenIFrameWindow('新增评价', 'AddEval.aspx?itemid=0&SectionId={{= course_parent.SectionId}}&IsEnable=0', '600px', '250px')" />
                {{else course_parent.Study_IsEnable== 1}}
                  <input type="button" value="新增评价" style="background: #A8A8A8" class="new" />
                {{/if}}

                 {{else}}
                 {{/if}}
              
            </ul>
        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>


    <script type="text/x-jquery-tmpl" id="itemAllot">
        {{if allot || rid ==1}}
        <input type="button" name="" id="" value="分配任务" class="btn" onclick="AllotTask()">
        {{else}}
        {{/if}}
    </script>

    <script type="text/x-jquery-tmpl" id="itemAllotNo">
         {{if allot || rid ==1}}
        <input type="button" name="" id="" value="分配任务" class="btn" style="background: #A8A8A8">
        {{else}}
        {{/if}}
    </script>
</body>
</html>

<script>
    var select_sectionid = 0;
    var select_reguid = 0;
    var SectionList = [];
    $(function () {
        limitreflesh();


        Get_Eva_RegularCompleate = function () {
            PrepareInit();
        };
        Get_Eva_Regular(0, 1);

        Delete_Eva_RegularCompleate = function () {
            Reflesh();
        }

    })

    function Reflesh() {
        Get_Eva_RegularCompleate = function () {
            PrepareInit();
        };
        Get_Eva_Regular(0, 1);
    }

    function AllotTask() {
        OpenIFrameWindow('分配任务', 'AllotTask.aspx', '1220px', '92%')
    }
    function remove(Id, value) {

        layer.confirm('确定删除"' + value + '"吗？', {
            btn: ['确定', '取消'], //按钮
            title: '操作'
        }, function () { Delete_Eva_Regular(Id); });
    }

    function remove_data(Id) {
        layer.confirm('确定删除吗？', {
            btn: ['确定', '取消'], //按钮
            title: '操作'
        }, function () { DeleteExpert_List_Teacher_Course(Id); });
    }

    function SelectByWhere() {
        Get_Eva_RegularData(select_reguid, 0);
    }


    var mange = false;
    var allot = false;
    var rid = 0;
    function limitreflesh() {
     
        Get_PageBtn("/SysSettings/Regu/RegularEval.aspx");
        mange = JudgeBtn_IsExist("mange");
        allot = JudgeBtn_IsExist("allot");
        
        DepartmentID = login_User.Major_ID;
        if (isHasElement(ids, 10) > -1 )
        {
            ModelType = 3;
        }
        else if( isHasElement(ids, 19) >-1)
        {
            ModelType = 2;
        }       
    }
</script>
