<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeeModel.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.SeeModel" %>

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

        .item_department_li {
            margin-bottom: 10px;
            margin-left: 15px;
            float: left;
            font-size: 16px;
            /*width: 200px;*/
            float: left;
        }

        .search_result1 {
            margin-top: 10px;
            width: 335px;
            border: 1px solid #eef3f2;
            margin-left: 110px;
            margin-top: 10px;
            margin-bottom: 10px;
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
<body>
    <div id="newEval">
        <div class="main">
            <div class="input-wrap">
                <label>评价名称：</label>
                <input type="text" readonly="readonly" class="text" id="name" value="" placeholder="请填写评价名称" style="width: 333px;" />
            </div>
            <div class="input-wrap">
                <label>学年学期：</label>
                <input type="text" readonly="readonly" class="select ml10" style="width: 335px;" id="section" />
            </div>
            <div class="input-wrap">
                <label>起止时间：</label>
                <input type="text" disabled="disabled" id="StartTime" name="StartTime" class="text ml10 Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px; margin-left: 10px;" />
                <span style="padding-left: 10px;">~</span>
                <input type="text" disabled="disabled" id="EndTime" name="EndTime" class="text Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px;" />
            </div>
            <div class="input-wrap pr">
                <label>评价表分配：</label>
                <input type="text" readonly="readonly" id="table" class="select ml10" style="width: 335px;" />

            </div>
            <div class="input-wrap clearfix" v-cloak>
                <label class="fl">评价范围：</label>

                <ul id="ulist" class="fl">
                </ul>

            </div>


        </div>
        <div class="btnwrap">
            <input type="button" value="关闭" class="btna" onclick="parent.CloseIFrameWindow();" />
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
    <script src="../../Scripts/WebCenter/Room.js"></script>
    <script src="../../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../../Scripts/choosen/prism.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>
    <script type="text/x-jquery-tmpl" id="item_department">
        <li id="${Id}" class="item_department_li">
            <lable title="${Major_Name}">${CutFileName(Major_Name,12)}</lable>

        </li>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCourse">
        <li>            
           ${CourseName} &nbsp;&nbsp;&nbsp;  ${ClassName}
        </li>
    </script>

    <script>

        var Id = getQueryString('Id');
        var CourseName = getQueryString('CourseName');
        var ClassName = getQueryString('ClassName');
        var that = this;
        var newEval = new Vue({
            el: '#newEval',
            data: {
                role: "",
                appoint: false,
                picked: '0'
            },
            methods: {
                DepartToggle: function () {
                    this.picked == 1 ? this.appoint = true : this.appoint = false;

                },
            },
            mounted: function () {
                this.role = GetLoginUser().Sys_Role_Id;
                Get_Eva_RegularSingleCompleate = function (regu) {
                    var rlist = regu.RoomID.split(',');
                };
                Get_Eva_RegularSingle(2);
                var obj = { CourseName: CourseName, ClassName: ClassName };
                $("#itemCourse").tmpl(obj).appendTo("#ulist");            
            }
        })

    </script>
</body>
</html>
