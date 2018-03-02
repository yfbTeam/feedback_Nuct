<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail_AddReward.aspx.cs" Inherits="FEWeb.SysSettings.Reward.Detail_AddReward" %>
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
    <script type="text/x-jquery-tmpl" id="con_item">
        <div class="input-wrap">
                <label>奖励项目：</label>
                <span>${GidName}</span>
            </div>
            <div class="input-wrap">
                <label>获奖项目名称：</label>
                <span>${AchiveName}</span>
            </div>
            <div class="input-wrap">
                <label>负责单位：</label>
                <span>${Major_Name}</span>
            </div>
            <div class="input-wrap">
                <label>负责人：</label>
                <span>${ResponsName}</span>
            </div>
            <div class="input-wrap">
                <label>获奖年度：</label>
                <span>${Year}</span>
            </div>
            <div class="input-wrap">
                <label>金额：</label>
                <input type="number" isrequired="true" regtype="money" fl="金额" class="text" min="0.01" step="0.01" name="Money" id="Money" value="${Money}" placeholder="请输入金额" style="margin-left:0px;"/>
            </div>
    </script>
</head>
<body>
    <div class="main">
        <div id="div_Detail" class="search_toobar clearfix"></div>
    </div>
    <div class="btnwrap">
        <input type="button" value="保存" onclick="submit()" class="btn" />
        <input type="button" value="取消" class="btna" onclick="javascript: parent.CloseIFrameWindow();" />
    </div>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/linq.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        var UrlDate = new GetUrlDate();
        var curid = UrlDate.itemid;        
        $(function () {
            var curitem = Enumerable.From(parent.CurDetail_Data).Where("x=>x.Id=='" + curid + "'").FirstOrDefault();
            $("#con_item").tmpl(curitem).appendTo("#div_Detail");
        });
        //提交按钮
        function submit() {
            var valid_flag = validateForm($('input[type="number"]'));
            if (valid_flag != "0") {
                return false;
            }            
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { Func: "", Id: curid, Money: $('#Money').val().trim(), CreateUID: GetLoginUser().UniqueNo },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        layer.msg('操作成功!');                      
                        parent.BindData(1, 10);
                        parent.CloseIFrameWindow();
                    } else {
                        layer.msg(json.result.errMsg);
                    }
                },
                error: function () {}
            });
        }
    </script>
</body>
</html>




