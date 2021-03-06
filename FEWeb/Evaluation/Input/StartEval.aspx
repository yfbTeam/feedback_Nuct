﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartEval.aspx.cs" Inherits="FEWeb.Evaluation.Input.StartEval" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>评价统计</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <link href="../../css/fixed-table.css" rel="stylesheet" />

    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <link href="../../css/layui.css" rel="stylesheet" />
    <style>
        .chosen-drop {
            color: black;
        }

        .select_expertdiv {
            /*height: 322px;*/
            overflow: auto;
            width: 100%;
        }

        .fixed-table-box {
            width: 100%;
        }


        .w-150 {
            width: 150px;
        }

        .w-120 {
            width: 120px;
        }

        .w-300 {
            width: 300px;
        }

        .w-100 {
            width: 100px;
        }

        .w-50 {
            width: 50px;
        }

        .w-30 {
            width: 30px;
        }
        .w-20 {
            width: 20px;
        }
        .w-10 {
            width: 10px;
        }

        .w-70 {
            width: 70px;
        }

        .btnno {
            height: 34px;
            min-width: 100px;
            padding: 0px 22px;
            color: #fff;
            border: none;
            background: #d7d7d7;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            display: inline-block;
            line-height: 34px;
            text-align: center;
        }

        .selectdiv {
            margin-right: 10px;
            margin-bottom: 10px;
        }

        .select {
            width: 150px;
        }

        .number {
            width: 50px;
            height: 30px;
            border: 1px solid #cccccc;
            border-radius: 3px;
            margin: 0px 10px;
            text-indent: 10px;
            color: #009706;
        }
    </style>
</head>



<body>
    <div class="main">


        <div class="InitiateEval" style="height: 500px;">
            <div class="search_toobar clearfix">
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
                    <select class="select" id="RP">
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
                    <label style="letter-spacing: 53px;" for="">合</label>
                    <label for="">班:</label>
                    <select class="select" id="CN">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl selectdiv">
                    <label>年龄：</label>
                    <input type="number" id="BirthdayS" value="0" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                    <span style="padding-left: 10px;">~</span>
                    <input type="number" id="BirthdayE" value="120" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                </div>

                <div class="fl selectdiv">
                    <label>校龄：</label>
                    <input type="number" id="SchoolS" value="0" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                    <span style="padding-left: 10px;">~</span>
                    <input type="number" id="SchoolE" value="120" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                </div>


                <div class="fl ml3">
                    <input type="text" name="" id="class_key" placeholder="课程名称关键字搜索" value="" style="width: 164px" class="text fl">
                    <a class="search fl" href="javascript:;" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                </div>

            </div>

            <div class="fixed-table-box row-col-fixed">
                <!-- 表头 start -->
                <div class="fixed-table_header-wraper">
                    <table class="fixed-table_header" border="0">
                        <thead>
                            <tr>
                                <th>
                                    <div class="table-cell w-20"></div>
                                </th>
                                <th>

                                    <div class="table-cell w-30">
                                        <span>序号</span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-150" id="S_DP">
                                        开课部门
                                          <span class="layui-table-sort layui-inline" lay-sort="" sorttype="0">
                                              <i class="layui-edge layui-table-sort-asc"></i>
                                              <i class="layui-edge layui-table-sort-desc"></i>
                                          </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_CN">
                                        课程名称
                                        <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                            <i class="layui-edge layui-table-sort-asc"></i>
                                            <i class="layui-edge layui-table-sort-desc"></i>
                                        </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_CT">
                                        课程类别
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-70" id="S_CP">
                                        课程性质
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-150" id="S_TD">
                                        教师所属部门
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_TN">
                                        教师姓名
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-150" id="S_MD">
                                        专业部门
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_GD">
                                        年级
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_CLS">
                                        合班
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_TJ">
                                        教师职称
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_BR">
                                        年龄
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>
                                <th>
                                    <div class="table-cell w-100" id="S_SY">
                                        校龄
                                         <span class="layui-table-sort layui-inline" lay-sort="" sorttype ="0">
                                             <i class="layui-edge layui-table-sort-asc"></i>
                                             <i class="layui-edge layui-table-sort-desc"></i>
                                         </span>
                                    </div>
                                </th>


                            </tr>
                        </thead>
                    </table>
                </div>
                <!-- 表头 end -->
                <!-- 表格内容 start -->
                <div class="fixed-table_body-wraper">
                    <table class="fixed-table_body" border="0">
                        <tbody id="tbody">
                        </tbody>
                    </table>
                </div>
                <!-- 表格内容 end -->
                <div id="pageBar" class="page"></div>

            </div>
        </div>
    </div>
    <div class="btnwrap">
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
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script src="../../Scripts/fixtable/fixed-table.js"></script>


    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td>
                <div class="table-cell w-20">
                    <input tbcount="${TableCount}" Id="${Id}" courseid="${CourseID}" course_name="${Course_Name}" teacheruid="${TeacherUID}" teacher_name="${Teacher_Name}" class="checkbox" type="checkbox" />
                </div>
            </td>
            <td>
                <div class="table-cell w-30">${Num}</div>
            </td>
            <td>
                <div title="${DepartmentName}" class="table-cell w-150">${DepartmentName}</div>
            </td>
            <td>
                <div title="${Course_Name}" class="table-cell w-100">${Course_Name}</div>
            </td>
            <td>
                <div title="${CourseType}" class="table-cell w-100">${CourseType}</div>
            </td>
            <td>
                <div title="${CourseProperty}" class="table-cell w-70">${CourseProperty}</div>
            </td>
            <td>
                <div title="${TeacherDepartmentName}" class="table-cell w-150">${TeacherDepartmentName}</div>
            </td>
            <td>
                <div title="${Teacher_Name}" class="table-cell w-100">${Teacher_Name}</div>
            </td>
            <td>
                <div title="${RoomDepartmentName}" class="table-cell w-150">${RoomDepartmentName}</div>
            </td>
            <td>
                <div title="${GradeInfo_Name}" class="table-cell w-100">${GradeInfo_Name}</div>
            </td>
            <td>
                <div title="${ClassName}" class="table-cell w-100">${ClassName}</div>
            </td>

            <td>
                <div title="${TeacherJobTitle}" class="table-cell w-100">${TeacherJobTitle}</div>
            </td>

            <td>
                <div title="${TeacherBirthday}" class="table-cell w-100">${TeacherBirthday}</div>
            </td>

            <td>
                <div title="${TeacherSchooldate}" class="table-cell w-100">${TeacherSchooldate}</div>
            </td>

        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="item_ExpertTeacher">
        <li teacheruid="${TeacherUID}" course_uniqueno="${CourseId}">${TeacherName} ${Course_Name}<i class="iconfont">&#xe672;</i></li>
    </script>

    <script type="text/x-jquery-tmpl" id="btn_yes">
        <input type="button" value="确定" onclick="submit()" class="btn">
        <input type="button" value="取消" onclick="parent.CloseIFrameWindow()" class="btna ml10">
    </script>

    <script type="text/x-jquery-tmpl" id="btn_no">
        <input type="button" value="确定" class="btnno">
        <input type="button" value="取消" onclick="parent.CloseIFrameWindow()" class="btna ml10">
    </script>

    <script>

        var select_sectionid = parent.select_sectionid;
        var select_course_teacher = [];
        var select_reguid = parent.select_reguid;
        var IsAllSchool = parent.IsAllSchool;
        var cur_TableCount = 0;
        UnEvaTeaRoleId = 8;
        var pageIndex = 0;
        $(function () {
            $(".fixed-table-box").fixedTable();

            selectExpertUID = login_User.UniqueNo;
            selectExpertName = login_User.Name;

            PageSize = 5;
            Groups = 6;
            size = 12;
            height = 263;
            ClassModelType = 1;

            PageType = 'StartEval';
            if (IsAllSchool == 1) {
                DepartmentName = login_User.DepartmentName;
            }                    
            GetClassInfoSelect(select_sectionid,null,null);
            $("#DP,#CT,#CP,#TD,#TN,#RP,#GD,#CN").on('change', function () {
                pageIndex = 0;
                GetClassInfo(pageIndex);
            });

            $('.number').on('blur', function () {
                pageIndex = 0;

                BirthdayS = $('#BirthdayS').val();
                BirthdayE = $('#BirthdayE').val();

                SchoolS = $('#SchoolS').val();
                SchoolE = $('#SchoolE').val();

                GetClassInfo(pageIndex);
            });

            $('.number').on('change', function () {
                $(this).trigger('blur');
            });


            PrepareInit();

            GetClassInfoCompleate = function () {
                $('#tbody tr').css('cursor', 'pointer');
                $('#tbody').find('.checkbox').on('click', function () {
                    isChecked(this)
                });
                $('#tbody td').click(function () {
                    isChecked($(this).parent().find('.checkbox'))
                })
            };
            GetClassInfo(pageIndex);
        })
        function isChecked(obj) {
            $('#tbody').find('.checkbox').prop('checked', false);
            if (!$(obj).is(':checked')) {
                $(obj).prop('checked', true);
                $(".btnwrap").empty();
                $("#btn_yes").tmpl(1).appendTo(".btnwrap");
                cur_TableCount = Number($(obj).attr('tbcount'));
                AddDisOne($(obj).attr('CourseID'), $(obj).attr('Course_Name'), $(obj).attr('TeacherUID'), $(obj).attr('Teacher_Name'), $(obj).attr('Id'));
            }
        }
        function submit() {
            if (cur_TableCount > 0) {
                AddExpert_List_Teacher_Course($.inArray(17, GetRoleArray('Userinfos')) == -1 ? 1 : 2); //判断是否是校管理员);
            } else {
                layer.confirm('该课程没有相关的评价表！<br>请联系管理员进行处理。', {
                    btn: ['确定'],
                    title: '操作'
                }, function (index) { layer.close(index); });
            }            
        }

        function SelectByWhere() {
            pageIndex = 0;
            GetClassInfo(pageIndex);
        }
    </script>
</body>
</html>
