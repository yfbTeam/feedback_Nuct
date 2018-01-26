<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllotTask.aspx.cs" Inherits="FEWeb.SysSettings.AllotTask" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>用户管理</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link rel="stylesheet" href="../../css/layout.css" />
    <link href="../../css/fixed-table.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .email_right .scroll-pane {
            width: auto;
            height: 405px;
            overflow: auto;
            outline: none;
        }

        .email_right {
            width: 200px;
        }

        .searchwrap input[type=text] {
            width: 126px;
        }

        .select_expertdiv {
            height: 322px;
            overflow: auto;
        }

        .linkman_lists li {
            padding: 10px 15px;
            font-size: 14px;
            text-align: center;
            color: #333;
            cursor: pointer;
            /*border-top: 1px solid #dcdcdc;*/
            border-bottom: 1px solid #dcdcdc;
        }

        .search_toobar .text {
            height: 31px;
        }

        .linkman_lists li:hover, .linkman_lists li.selected {
            background: #fff;
            border-left: 2px solid #ffac32;
        }

        .scroll-pane {
            border-top: 1px solid #dcdcdc;
        }

        .chosen-drop {
            color: black;
        }

        .select_expertdiv {
            height: 322px;
            overflow: auto;
            width: 100%;
        }


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

    <div class="main clearfix">
        <div class="email_right fl">
            <h1>专家列表</h1>
            <div class="searchwrap">
                <input type="text" name="name" id="key1" value="" placeholder="查找专家" />
                <a class="search fl" href="javascript:search1();"><i class="iconfont">&#xe600;</i></a>
            </div>
            <div class="scroll-pane">
                <ul class="linkman_lists" id="experts" style="height: 400px; overflow-y: auto">
                    <%--  <li class="selected">（兼）李华东</li>--%>
                </ul>
            </div>
        </div>
        <div class="InitiateEval fr" style="width: 955px;">
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
                                    <div class="table-cell w-10"></div>
                                </th>
                                <th>
                                    <div class="table-cell w-30">序号</div>
                                </th>
                                <th>
                                    <div class="table-cell w-150">开课部门</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">课程名称</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">课程类别</div>
                                </th>
                                <th>
                                    <div class="table-cell w-70">课程性质</div>
                                </th>
                                <th>
                                    <div class="table-cell w-150">教师所属部门</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">教师姓名</div>
                                </th>
                                <th>
                                    <div class="table-cell w-150">专业部门</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">年级</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">合班</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">教师职称</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">年龄</div>
                                </th>
                                <th>
                                    <div class="table-cell w-100">校龄</div>
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
        <%-- <input type="button" value="保存" class="btn" onclick="submit()" />
            <input type="button" value="取消" class="btna" onclick="parent.CloseIFrameWindow();" />--%>
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

    <script src="../../Scripts/WebCenter/Evaluate.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/WebCenter/AllotTask.js"></script>
    <script src="../../Scripts/WebCenter/Room.js"></script>



    <script src="../../Scripts/laypage/laypage.js"></script>
    <script src="../../Scripts/fixtable/fixed-table.js"></script>
    <script type="text/x-jquery-tmpl" id="item_Expert">
        <li id="${UniqueNo}">${Name}
        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td>
                <div class="table-cell w-10">
                    <input courseid="${CourseID}" course_name="${Course_Name}" teacheruid="${TeacherUID}" teacher_name="${Teacher_Name}" class="checkbox" type="checkbox" />
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

        var pageIndex = 0;
        $(function () {

            Get_Eva_QuestionAnswerCompleate = function (data) {
                debugger;
                for (var i = 0; i < data.length; i++) {
                    AddDis(data[i].CourseID, data[i].CourseName, data[i].TeacherUID, data[i].TeacherName)
                }
                fillData_disable(data);
            };

            GetTeacherInfo_Course_ClsCompleate = function (data) {
                debugger;
                for (var i = 0; i < data.length; i++) {
                    AddDis(data[i].CourseId, data[i].Course_Name, data[i].TeacherUID, data[i].TeacherName)
                }
                fillData(data);
            };

            ExpertListRefleshCompleate = function (exp0) {
                Mode = 4;
                AnswerUID = exp0.UniqueNo;               
                Get_Eva_QuestionAnswer(0, select_sectionid);
                GetTeacherInfo_Course_Cls();
            };

            GetUserByType('16,17');//获取专家     

            //selectExpertUID = login_User.UniqueNo;
            //selectExpertName = login_User.Name;

            PageSize = 5;
            Groups = 6;
            size = 12;
            height = 263;
            ClassModelType = 1;

            PageType = 'AllotTask';

            $("#DP,#CT,#CP,#TD,#TN,#MD,#GD,#CN").on('change', function () {
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
            //默认第一个选中，并且添加点击事件，选中样式
            $('.linkman_lists li:eq(0)').trigger('click');
            GetClassInfoCompleate = function () {
                $('#tbody').find('.checkbox').on('click', function () {
                  
                    if ($(this).is(':checked')) {
                      
                        AddDis($(this).attr('CourseID'), $(this).attr('Course_Name'), $(this).attr('TeacherUID'), $(this).attr('Teacher_Name'));
                    }
                    else
                   {                                                                      
                        RemoveDis($(this).attr('CourseID'), $(this).attr('TeacherUID'));
                    }
                });
                $(".fixed-table-box").fixedTable();
               
                Mode = 4;
                AnswerUID = selectExpertUID;
                Get_Eva_QuestionAnswer(0, select_sectionid);
                GetTeacherInfo_Course_Cls();
            };
            GetClassInfo(pageIndex);


           
        })

        //专家搜索
        function search1() {
            ExpertListReflesh();
        }
        //提交分配
        function submit() {
            DisModelType = 1;
            debugger;
            AddExpert_List_Teacher_Course();
        }
       
        //填充checkbox
        function fillData_disable(list)
        {         
            $('#tbody').find('.checkbox').each(function () {                
                var TeacherUID = $(this).attr('TeacherUID');
                var CourseID = $(this).attr('CourseID');
               
                var data = list.filter(function (item) { return item.TeacherUID == TeacherUID && item.CourseID == CourseID });
                if (data.length > 0) {
                    $(this).prop('checked', true);
                    $(this).prop('disabled', 'disabled');
                }
            });

           
        }

        //填充checkbox
        function fillData(list) {
            $('#tbody').find('.checkbox').each(function () {
                var TeacherUID = $(this).attr('TeacherUID');
                var CourseID = $(this).attr('CourseID');
               
                var data = list.filter(function (item) { return item.TeacherUID == TeacherUID && item.CourseId == CourseID });
                if (data.length > 0) {
                    $(this).prop('checked', true);
                }
            });
        }


      

    </script>

</body>
</html>
