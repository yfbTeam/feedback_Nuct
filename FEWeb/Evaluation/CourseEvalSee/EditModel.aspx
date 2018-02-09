﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditModel.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.EditModel" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .label {
            display: inline-block;
            min-width: 110px;
            height: 35px;
            text-align: left;
            font-size: 15px;
            color: #555;
            float: left;
            line-height: 35px;
        }
        #ulist {
            vertical-align: middle;
            margin-top: 11px;
            margin-left: 10px;
        }

            #ulist li {
                vertical-align: middle;
                margin-bottom: 5px;
                text-align: left;
            }

            #ulist input {
                vertical-align: middle;
                margin-right: 3px;
            }

            #ulist label {
                vertical-align: middle;
            }
    </style>
</head>
<body >
    <div id="newEval">
        <div class="main" >
            <div class="input-wrap">
                <label>评价名称：</label>
                <input type="text" class="text" id="name"  readonly="readonly" value="" placeholder="请填写评价名称" style="width:333px;"/>
            </div>
            <div class="input-wrap">
                <label>学年学期：</label>
                <select class="select ml10" style="width:335px;" id="section" disabled="disabled">
           
                </select>
            </div>
            <div class="input-wrap">
                <label>起止时间：</label>
                <input type="text" id="StartTime" disabled="disabled" name="StartTime" class="text ml10 Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px; margin-left: 10px;" />
                <span style="padding-left: 10px;">~</span>
                <input type="text" id="EndTime" name="EndTime" class="text Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px;" />
            </div>
            <div class="input-wrap1 pr pb20" >
                <label style="width:100px;margin-right:6px;display:inline-block">评价表分配：</label>
                <select id ="table" disabled="disabled" class="select ml10" style="width:335px;">
                         
                </select>
            </div>
            <div class="input-wrap clearfix" v-cloak>
                <label class="fl">评价范围：</label>

                <ul id="ulist" class="fl">
                </ul>

            </div>
        </div>
        <div class="btnwrap">
            <input type="button" value="保存" class="btn" @click="submit" />
            <input type="button" value="取消" class="btna" onclick="parent.CloseIFrameWindow();" />
        </div>
    </div>
    <link rel="stylesheet" href="../../Scripts/choosen/prism.css" />
    <link rel="stylesheet" href="../../Scripts/choosen/chosen.css" />
    <script src="../../js/vue.min.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../scripts/jquery.linq.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../scripts/layer/layer.js"></script>
    <script src="../../scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../../Scripts/choosen/prism.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>

    <script type="text/x-jquery-tmpl" id="itemCourse">
        <li>            
           ${CourseName} &nbsp;&nbsp;&nbsp;  ${ClassName}
        </li>
    </script>
   
    <script>
        var Id = getQueryString('Id');
        var CourseName = getQueryString('CourseName');
        var ClassName = getQueryString('ClassName');
        var StateType = getQueryString('StateType');
        var newEval = new Vue({
            el: '#newEval',
            data: {
                role: "",
                appoint: false,
                picked: '0'
            },
            methods: {
                DepartToggle: function () {
                    this.picked == 1 ? this.appoint = true : this.appoint = false
                },

                submit: function () {
                    var name = $('#name').val();
                    if (name == '') {
                        layer.msg('请输入评价名称');
                        return;
                    }

                    var startime = $('#StartTime').val();
                    var endtime = $('#EndTime').val();
                    if (startime == '') {
                        layer.msg('请输入开始时间');
                        return;
                    }
                    if (endtime == '') {
                        layer.msg('请输入结束时间');
                        return;
                    }
                    if (startime > endtime) {
                        layer.msg('开始时间不能大于结束时间');
                        return;
                    }
                    if (Number(this.picked) == 1) {
                        var departmests = $('#DepartMent').val() == null ? '' : $('#DepartMent').val();
                        if (departmests == '') {
                            layer.msg('请选择部门');
                            return;
                        }
                        DepartmentIDs = [];

                        departmests.filter(function (item) { DepartmentIDs += item + ',' });
                        DepartmentIDs = DepartmentIDs.substring(0, DepartmentIDs.length - 1);

                        LookType = 1;
                    }
                    else {
                        LookType = 0;
                        DepartmentIDs = [];
                    }
                    TableID = $('#table').val();

                    select_sectionid = $('#section').val();
                    Edit_Eva_RegularCompleate = function () {
                        parent.Reflesh();
                    };
                    Edit_Eva_Regular(2);
                }
            },
            mounted: function () {
                this.role = GetLoginUser().Sys_Role_Id;

                if (StateType == 1)
                {
                    $('#name').prop('readonly', false);
                    $('#section,#StartTime,#table').prop('disabled', false);
                    
                }


                Base.bindStudySection();
                t_Type = 1;
                CreateUID = login_User.UniqueNo;

                Base.BindTableCompleate = function () {
                    Get_Eva_RegularSingle(2, true);
                };
                Base.BindTable();
                Base.BindDepart();

                var obj = { CourseName: CourseName, ClassName: ClassName };
                $("#itemCourse").tmpl(obj).appendTo("#ulist");
            }
        })

    </script>
</body>
</html>