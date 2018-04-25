<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeeModel.aspx.cs" Inherits="FEWeb.SysSettings.Regu.SeeModel" %>

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
            
            color: #555;
            float: left;
            line-height: 35px;
        }

        .item_department_li {
            margin-bottom: 10px;
            margin-left: 15px;
            float: left;
            font-size: 14px;
            float: left;
        }

        .search_result1 {
           
             width: 335px; 
            border: 1px solid #eef3f2;
             margin-left: 110px; 
           
        }
    </style>
</head>
<body >
    <div id="newEval">
        <div class="main" >
            <div class="input-wrap">
                <label>评价名称：</label>
                <input type="text"  readonly="readonly" class="text" id="name" value="" placeholder="请填写评价名称" style="width:333px;"/>
            </div>
            <div class="input-wrap">
                <label>学年学期：</label>
                <input type="text"  readonly="readonly" class="select ml10" style="width:335px;" id="section" />                            
            </div>
            <div class="input-wrap">
                <label>起止时间：</label>
                <input type="text" disabled="disabled" id="StartTime" name="StartTime" class="text ml10 Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px; margin-left: 10px;" />
                <span style="padding-left: 10px;">~</span>
                <input type="text" disabled="disabled" id="EndTime" name="EndTime" class="text Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',startDate:'%y-%M-01 00:00:00'})" style="width: 151px;" />
            </div>
            <div class="input-wrap pr">
                <label>评价表分配：</label>
                <input type="text"   readonly="readonly" id ="table" class="select ml10" style="width:335px;"/>
                   
            </div>
            <div class="input-wrap clearfix" <%--v-if="role==1" v-cloak--%>>
                <label>评价范围：</label>
                <span class="ml10" id="allspan">
                    <input type="radio"   name="rank" id="all" class="magic-radio"  v-model="picked" value="0"  @change="DepartToggle">
                    <label for="all">全校</label>
                </span>
                <span class="ml10" id="appointspan">
                    <input type="radio"   name="rank" id="appoint" class="magic-radio" v-model="picked" value="1" @change="DepartToggle">
                    <label for="appoint">指定部门</label>
                </span>
            </div>
            <div class="input-wrap1 pb20" v-cloak v-show="appoint">
               <div class="clearfix search_result1">

                <ul id="_slect_department" style="margin-top: 15px; margin-bottom: 15px">               

                </ul>
                <div id="div_tip" style="margin-bottom: 10px; display: none;">
                    <label id="tip" style="font-size: 16px;">
                        全校
                    </label>
                </div>
            </div>
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
    <script src="../../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../../Scripts/choosen/prism.js"></script>
    <script type="text/javascript" src="../../scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>
    <script type="text/x-jquery-tmpl" id="item_department">
        <li id="${Id}" class="item_department_li">
            <lable title="${Major_Name}">${CutFileName(Major_Name,12)}</lable>

        </li>
    </script>
    <script>

        var Id = getQueryString('Id');
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
                Get_Eva_RegularSingle(2);
            }
        })

    </script>
</body>
</html>