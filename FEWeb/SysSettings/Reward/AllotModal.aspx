<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllotModal.aspx.cs" Inherits="FEWeb.SysSettings.Reward.AllotModal" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="/images/favicon.ico" rel="shortcut icon" />
    <title>新增奖金批次</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>   
</head>
<body>
    <div class="main">
        <div class="search_toobar clearfix">
            <div class="input-wrap">
                <label>奖励项目：：</label>
                <span>个人竞赛奖奖励项目一</span>
            </div>
            <div class="input-wrap">
                <label>获奖项目名称：</label>
                <span>测试获奖证书</span>
            </div>
            <div class="input-wrap">
                <label>负责单位：</label>
                <span>经济管理学院</span>
            </div>
            <div class="input-wrap">
                <label>负责人：</label>
                <span>李哲</span>
            </div>
            <div class="input-wrap">
                <label>获奖年度：</label>
                <span>2017年</span>
            </div>
            <div class="input-wrap">
                <label>金额：</label>
                <input type="number" class="text" name="" id="" placeholder="请输入金额"/>
            </div>
        </div>
    </div>
    <div class="btnwrap">
        <input type="button" value="保存" onclick="submit()" class="btn" />
        <input type="button" value="取消" class="btna" onclick="javascript: parent.CloseIFrameWindow();" />
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

