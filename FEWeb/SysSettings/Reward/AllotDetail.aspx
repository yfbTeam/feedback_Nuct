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
</head>
<body>
    <div class="main">
         <div class="clearfix">
            <div class="fl status-left">
                <label for="" style="margin-right:20px;">第${rowNum}批奖金</label>
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
                    <th>成员</th>
                    <th>部门</th>
                    <th>奖金</th>
                </tr>
            </thead>
            <tbody></tbody>
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
    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $(function () {
           
        })
    </script>
</body>
</html>
