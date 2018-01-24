<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartEval.aspx.cs" Inherits="FEWeb.Evaluation.Input.StartEval" %>

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
                    <input type="number"  value="0" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                    <span style="padding-left: 10px;">~</span>
                    <input type="number"  value="120" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                </div>
                 <div class="fl selectdiv">
                    <label>校龄：</label>
                    <input type="number"  value="0" onkeydown="onlyNum();" class="number" min="0"  max="120" step="1">
                    <span style="padding-left: 10px;">~</span>
                    <input type="number"  value="120" onkeydown="onlyNum();" class="number" min="0" max="120" step="1">
                </div>

              
                <div class="fl ml3">
                    <input type="text" name="" id="class_key" placeholder="课程名称关键字搜索" value="" style="width:164px" class="text fl">
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
                                    <div class="table-cell w-50"></div>
                                </th>
                                <th>
                                    <div class="table-cell w-50">序号</div>
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
                                    <div class="table-cell w-100">课程性质</div>
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
                <div class="table-cell w-50">
                    <input class="checkbox" type="checkbox" />
                </div>
            </td>
            <td>
                <div class="table-cell w-50">${Num}</div>
            </td>
            <td>
                <div class="table-cell w-150">${DepartmentName}</div>
            </td>
            <td>
                <div class="table-cell w-100">${Course_Name}</div>
            </td>
            <td>
                <div class="table-cell w-100">${CourseType}</div>
            </td>
            <td>
                <div class="table-cell w-100">${CourseProperty}</div>
            </td>
            <td>
                <div class="table-cell w-150">${TeacherDepartmentName}</div>
            </td>
            <td>
                <div class="table-cell w-100">${Teacher_Name}</div>
            </td>
            <td>
                <div class="table-cell w-150">${RoomDepartmentName}</div>
            </td>
            <td>
                <div class="table-cell w-100">${GradeInfo_Name}</div>
            </td>
            <td>
                <div class="table-cell w-100">${ClassName}</div>
            </td>

            <td>
                <div class="table-cell w-100">${TeacherJobTitle}</div>
            </td>

            <td>
                <div class="table-cell w-100">${DateTimeConvert(TeacherBirthday,'yyyy-MM-dd',true)}</div>
            </td>

            <td>
                <div class="table-cell w-100">${DateTimeConvert(TeacherSchooldate,'yyyy-MM-dd',true)}</div>
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

            selectExpertUID = login_User.UniqueNo;
            selectExpertName = login_User.Name;

            PageSize =5;
            Groups = 6;
           

            PageType = 'StartEval';
            $("#btn_no").tmpl(1).appendTo(".btnwrap");
            GetClassInfoSelect();

            $("#DP,#CT,#CP,#TD,#TN,#MD,#GD,#CN").on('change', function () {
                pageIndex = 0;
                GetClassInfo(pageIndex);
            });
           
            if (IsAllSchool == 1) {
                Base.BindDepartCompleate = function () {
                    $("#DepartMent").val(Number(login_User.Major_ID));

                    GetClassInfoCompleate = function () {
                        $('#tbody').find('.checkbox').on('click', function () {
                            $('#tbody').find('.checkbox').prop('checked', false);
                            if (!$(this).is(':checked')) {
                                $(this).prop('checked', true);
                                $(".btnwrap").empty();
                                $("#btn_yes").tmpl(1).appendTo(".btnwrap");
                            }
                        });

                        $(".fixed-table-box").fixedTable();
                    };
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
