<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllotDetail.aspx.cs" Inherits="FEWeb.SysSettings.Reward.AllotDetail" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="/images/favicon.ico" rel="shortcut icon" />
    <title>分配奖金</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>  
    <script type="text/x-jquery-tmpl" id="div_item">
       <div class="clearfix allot_item">
            <div class="clearfix">
                <div class="fl status-left">
                    <label for="" style="margin-right:20px;">${BatName}</label>
                    <label for="">状态：</label>
                    {{if AuditStatus==10}}<span class="nosubmit">待分配</span>
                    {{else AuditStatus==0}}<span class="nosubmit">待提交</span>
                    {{else AuditStatus==1}}<span class="checking1">待审核</span>
                    {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                    {{else}} <span class="assigning">审核通过</span>{{/if}}
                </div>
                <div class="fr status">奖金：<span id="span_AllMoney_${rowNum}">${Money}</span>元，已分：<span id="span_HasAllot_${rowNum}">${HasAllot}</span>元，<span id="span_UnAllot_${rowNum}" style="color:#d02525;">未分：${Money-HasAllot}元</span></div>
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
                        <th>部门</th>   
                        <th>奖金</th>                    
                        {{/if}}
                    </tr>
                </thead>
                <tbody id="tb_Member_${rowNum}" autid="${Id}" rewid="${Id}" batname="${BatName}">
                    {{each(i, mem) Member_Data.retData}}                        
                            <tr un="${mem.UserNo}" uid="${mem.Id}">
                                <td class="td_memname">${mem.Name}</td>
                                {{if cur_AchieveType==3}}
                                <td>{{if mem.ULevel==0}}独著 {{else mem.ULevel==1}}主编{{else mem.ULevel==2}}参编{{else}}其他人员{{/if}}</td>
                                <td>${mem.Sort}</td>
                                <td>${mem.Major_Name}</td>
                                <td>${mem.WordNum}</td>                                
                                {{else}}
                                <td>${mem.Major_Name}</td>                                                                                
                                {{/if}}  
                                <td class="td_money"></td>   
                            </tr>
                    {{/each}}    
                </tbody>
            </table>
           <div class="clearfix mt10 Enclosure">
               <div class="status-left">
                   <label for="" class="fl">附件：</label>
                   <div class="fl">
                       <ul id="ul_ScoreFile_${rowNum}" auid="${Id}" class="clearfix file-ary allot_file"></ul>
                   </div>
               </div>
           </div>
        </div>
    </script> 
    <style>
        .file-ary .title1{
            float:left;line-height:35px;
        } 
        .file-ary .file-panel{
            float:left;margin-left:10px;cursor:pointer;
        } 
        .preview {
     color: #6a254a;
}
    </style>
</head>
<body>
    <div id="div_MoneyInfo" class="main"></div>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>    
    <script src="../../TeaAchManage/BaseUse.js"></script> 
    <script>
        var UrlDate = new GetUrlDate();
        var loginUser = GetLoginUser();
        var curid = UrlDate.itemid,cur_AchieveType=UrlDate.achtype;
        $(function () {
            Get_AllotUserInfo();
        });
        //绑定成员信息
        var Member_Data = [];
        function Get_AllotUserInfo() {
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                data: { func: "GetTPM_UserInfo", RIId: UrlDate.achid, IsPage: false },
                dataType: "json",
                success: function (json) {
                    if (json.result.errNum.toString() == "0") {
                        Member_Data = json.result;
                    }
                    GetSingle_RewardBatchDetail();
                },
                error: function (errMsg) {
                    layer.msg(errMsg);
                }
            });
        }
        //绑定奖项奖金信息
        function GetSingle_RewardBatchDetail() {         
            $("#div_MoneyInfo").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_RewardBatchDetailData", "IsPage": "false", Id: curid },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#div_item").tmpl(json.result.retData).appendTo("#div_MoneyInfo");
                        Get_AllotRewardByDetail();
                        Bind_AllotFile();
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //获取分配奖金信息
        function Get_AllotRewardByDetail() {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_AllotReward", "IsPage": "false", BatchDetail_Id: curid},
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $(json.result.retData).each(function (i, n) {
                            var $td_money = $("tbody tr[uid='" + n.RewardUser_Id + "']").find('.td_money');
                            if ($td_money.length) {
                                $td_money.html(n.AllotMoney);
                            }
                        });
                    }
                },
                error: function () {}
            });
        }
    </script>
</body>
</html>
