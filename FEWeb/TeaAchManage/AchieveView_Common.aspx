<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AchieveView_Common.aspx.cs" Inherits="FEWeb.TeaAchManage.AchieveView_Common" %>

<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>业绩查看</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .area_form {
            padding: 0px 0px 20px 0px;
        }

        .file-ary .title1 {
            float: left;
            line-height: 30px;
        }

        .file-ary .file-panel {
            float: left;
            margin-left: 10px;
            cursor: pointer;
        }
    </style>
    <%--业绩信息--%>
    <script type="text/x-jquery-tmpl" id="div_AchInfo">
        <h2 class="cont_title re_view"><span>获奖文件信息</span></h2>
        <div class="area_form clearfix re_view">
            <div class="input_lable fl">
                <label for="">发文号：</label>
                <span>${FileEdionNo}</span>
            </div>
            <div class="input_lable fl">
                <label for="">文件名称：</label>
                <span>${FileNames}</span>
            </div>
            <div class="input_lable fl">
                <label for="">认定机构：</label>
                <span>${DefindDepart}</span>
            </div>
            <div class="input_lable fl">
                <label for="">认定日期：</label>
                <span>${DateTimeConvert(DefindDate, '年月日')}</span>
            </div>
            <div class="input_lable fl input_lable2">
                <label for="">获奖扫描件：</label>
                <div class="fl uploader_container">
                    <div id="uploader">
                        <div class="queueList">
                            <div id="dndArea" class="placeholder photo_lists">
                                <ul class="filelist clearfix"></ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <h2 class="cont_title"><span>基本信息</span></h2>
        <div class="area_form clearfix">
            {{if AchieveType==1||AchieveType==2}}             
                <div class="input_lable fl">
                    <label for="">获奖项目名称：</label>
                    <span>${AchiveName}</span>
                </div>
            {{/if}}
                {{if  AchieveType==3}}
                <div class="input_lable book fl">
                    <label for="">书名：</label>
                    <span>${BookName}</span>
                    <input type="hidden" id="BookId" name="BookId" value="${BookId}" />
                </div>
            <div class="input_lable book fl">
                <label for="">书号：</label>
                <span>${ISBN}</span>
            </div>
            {{/if}}
                <div class="input_lable fl">
                    <label for="">奖励项目：</label>
                    <span>${GidName}</span>
                </div>
            <div class="input_lable fl">
                <label for="">获奖级别：</label>
                <span>${LevelName}</span>
            </div>
            <div class="input_lable fl">
                <label for="">奖励等级：</label>
                <span>${RewadName}</span>
            </div>
            {{if AchieveType==2}}
                <div class="input_lable fl">
                    <label for="">排名：</label>
                    <span>${RankName}</span>
                </div>
            {{/if}}
                <div class="input_lable fl">
                    <label for="">获奖年度：</label>
                    <span>${Year}</span>
                </div>
            {{if AchieveType!=3}}
                <div class="input_lable fl">
                    <label for="">{{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}：</label>
                    <span>${ResponsName}</span>
                </div>
            {{/if}}
            <div class="input_lable fl">
                <label for="">负责单位：</label>
                <span>${Major_Name}</span>
            </div>
        </div>
        {{if AchieveType==2&&Status <= 3}}  
            <h2 class="cont_title members"><span>成员信息</span></h2>
        <div class="area_form members">
            <table class="allot_table mt10">
                <thead>
                    <tr>
                        <th>姓名</th>
                        <th>部门</th>
                        <th>分数</th>
                    </tr>
                </thead>
                <tbody id="tb_Member"></tbody>
            </table>
        </div>
        {{/if}}
         {{if AchieveType==3&&Status <= 3}}
            <h2 class="cont_title book"><span>作者信息</span></h2>
        <div class="area_form book">
            <table class="allot_table mt10">
                <thead>
                    <tr>
                        <th>姓名</th>
                        <th>作者类型</th>
                        <th>排名</th>
                        <th>部门</th>
                        <th>贡献字数（万字）</th>
                    </tr>
                </thead>
                <tbody id="tb_info"></tbody>
            </table>
        </div>
        {{/if}}
    </script>
    <%--成员信息--%>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit">
        <tr class="memedit" un="${UserNo}">
            <td class="td_memname">${Name}</td>
            <td>${Major_Name}</td>
            <td class="td_score">${Score}</td>
        </tr>
    </script>
    <%--成员信息--%>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit1">
        <tr id="tr_mem_${Id}" class="memedit" un="${UserNo}">
            <td class="td_memname">${Name}</td>
            <td class="td_score">${Score}</td>
            <td>${Major_Name}</td>
            <td>${DateTimeConvert(CreateTime,"yyyy-MM-dd")}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr>
            <td>${Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info1">
        <tr>
            <td>${Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
            <td>${UnitScore*WordNum}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="div_item">
        <div class="clearfix allot_item">
            <div class="clearfix">
                <div class="fl status-left">
                    <label for="" style="margin-right: 20px;">第${rowNum}批奖金</label>
                </div>
            </div>
            <table class="allot_table mt10  ">
                <thead>
                    <tr>
                        {{if cur_AchieveType==3}}
                        <th>姓名</th>
                        <th>作者类型</th>
                        <th>排名</th>
                        <th>部门</th>
                        <th>贡献字数（万字）</th>
                        <th>奖金</th>
                        {{else}}
                        <th>成员</th>
                        <th>奖金</th>
                        <th>部门</th>
                        <th>录入日期</th>
                        {{/if}}
                    </tr>
                </thead>
                <tbody id="tb_Member_${rowNum}" autid="${AuditId}" rewid="${Id}">
                    {{each(i, mem) Member_Data}}                        
                            <tr un="${mem.UserNo}" uid="${mem.Id}">
                                <td class="td_memname">${mem.Name}</td>
                                {{if cur_AchieveType==3}}
                                <td>{{if mem.ULevel==0}}独著 {{else mem.ULevel==1}}主编{{else mem.ULevel==2}}参编{{else}}其他人员{{/if}}</td>
                                <td>${mem.Sort}</td>
                                <td>${mem.Major_Name}</td>
                                <td>${mem.WordNum}</td>
                                <td class="td_money"></td>
                                {{else}}
                                <td class="td_money"></td>
                                <td>${mem.Major_Name}</td>
                                <td>${DateTimeConvert(mem.CreateTime,"yyyy-MM-dd")}</td>
                                {{/if}}     
                            </tr>
                    {{/each}}    
                </tbody>
            </table>
        </div>
    </script>
    <%--分配历史记录--%>
    <script type="text/x-jquery-tmpl" id="li_Record">
        <li class="clearfix">
            <span class="fl">${Content}</span>
            <span class="fr">${DateTimeConvert(CreateTime,"yyyy-MM-dd")}</span>
        </li>
    </script>
</head>
<body style="background: #fff;">
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <div class="checkmes none">审核通过</div>
    <div class="main">
        <div class="cont">
            <div id="div_Achieve"></div>
            <h2 class="cont_title re_score none"><span>分数分配</span></h2>
            <div class="area_form re_score none">
                <table class="allot_table mt10">
                    <thead>
                        <tr class="user_mem none">
                            <th>成员</th>
                            <th>分数</th>
                            <th>部门</th>
                            <th>录入日期</th>
                        </tr>
                        <tr class="user_book none">
                            <th>姓名</th>
                            <th>作者类型</th>
                            <th>排名</th>
                            <th>部门</th>
                            <th>贡献字数（万字）</th>
                            <th>分数</th>
                        </tr>
                    </thead>
                    <tbody id="tb_Member1"></tbody>
                </table>
            </div>
            <h2 class="cont_title re_reward none"><span>奖金分配</span></h2>
            <div class="area_form re_reward none" id="div_MoneyInfo"></div>
            <h2 class="cont_title re_history none"><span>分配历史</span></h2>
            <div class="area_form re_history none">
                <ul class="history" id="ul_Record"></ul>
            </div>
        </div>
    </div>
    <div class="score none"></div>
    <script src="../Scripts/Common.js"></script>
    <script src="../scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <link href="../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="BaseUse.js"></script>
    <script type="text/javascript">
        var UrlDate = new GetUrlDate();
        var cur_AchieveId = UrlDate.Id;
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            var Id = UrlDate.Id;
            if (Id != undefined) {
                GetAchieveDetailById(1);
                Get_LookPage_Document(0, Id);
            }
        });
        //绑定成员信息
        var Member_Data = [];
        function Get_RewardUserInfo(model) {
            $("#tb_Member,#tb_Info,#tb_Member1").html("");
            if (model.AchieveType == 3) {
                $(".user_book").show();
            } else {
                $(".user_mem").show();
            }
            var postData = { func: "GetTPM_UserInfo", RIId: model.Id, IsPage: false };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                data: postData,
                dataType: "json",
                success: function (json) {
                    if (json.result.errNum.toString() == "0") {
                        var type_tr = "#tr_Info1";
                        if (model.AchieveType == 3) { //教材建设类                          
                            $("#tr_Info").tmpl(json.result.retData).appendTo("#tb_info");
                            type_tr = "#tr_Info1";

                        } else {  //其他类型
                            $("#tr_MemEdit").tmpl(json.result.retData).appendTo("#tb_Member");
                            type_tr = "#tr_MemEdit1";
                        }
                        if (model.Status > 6) {
                            $(".re_score").show();
                            var curMemData = Enumerable.From(json.result.retData).Where("x=>x.UserNo=='" + loginUser.UniqueNo + "'").FirstOrDefault();
                            $(type_tr).tmpl(curMemData).appendTo("#tb_Member1");
                            if (model.Status > 7) {
                                Member_Data = [curMemData];
                                $(".re_reward").show();
                                Get_SelfRewardData();
                            }
                            $(".re_history").show();
                            Get_ModifyRecordData(loginUser.UniqueNo);
                        }
                    }
                },
                error: function (errMsg) {
                    layer.msg(errMsg);
                }
            });
        }
        //绑定奖项奖金信息
        function Get_SelfRewardData() {
            $("#div_MoneyInfo").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_RewardBatchData", "IsPage": "false", AchieveId: cur_AchieveId, AuditStatus: "=3" },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $(".re_reward").show();
                        $("#div_item").tmpl(json.result.retData).appendTo("#div_MoneyInfo");
                        Get_SelfAllot();
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //获取自己的分配奖金信息
        function Get_SelfAllot() {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_AllotReward", "IsPage": "false", AchieveId: cur_AchieveId },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $(json.result.retData).each(function (i, n) {
                            var $td_money = $("tbody[autid='" + n.Audit_Id + "'] tr[uid='" + n.RewardUser_Id + "']").find('.td_money');
                            if ($td_money.length) {
                                $td_money.html(n.AllotMoney);
                            }
                        });
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
    </script>
</body>
</html>
