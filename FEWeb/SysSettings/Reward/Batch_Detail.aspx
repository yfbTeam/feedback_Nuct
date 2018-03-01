<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Batch_Detail.aspx.cs" Inherits="FEWeb.SysSettings.Reward.Batch_Detail" %>

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
                <label>年度：</label>
                <span>${Year}</span>
            </div>
            <div class="input-wrap">
                <label>名称：</label>
                <span>${Name}</span>
            </div>
            <div class="input-wrap">
                <label>总金额：</label>
                <span>${BatchMoney}</span>
            </div>
            <div class="input_lable2">
                <label for="" style="min-width:100px;">附件：</label>
                <div class="fl uploader_container pr" style="padding-left:100px;">
                    <ul id="ul_BatchFile" class="clearfix filelist"></ul>
                </div>
            </div>
    </script> 
</head>
<body>
    <div class="main">
        <div class="search_toobar clearfix" id="div_Batch"></div>
    </div>
    <div class="btnwrap">
        <input type="button" value="关闭" class="btna" onclick="javascript: parent.CloseIFrameWindow();"/>
    </div>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/Webuploader/dist/webuploader.js"></script>
    <link href="../../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="../../TeaAchManage/upload_batchfile.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        var UrlDate = new GetUrlDate();
        $(function () {
            BindData();            
        });
        function BindData() {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_RewardBatchData", Id: UrlDate.Id, IsPage: false },
                success: function (json) {
                    if (json.result.errMsg == "success") {                        
                        $("#con_item").tmpl(json.result.retData).appendTo("#div_Batch");
                        Get_LookPage_Document(7, UrlDate.Id, $("#ul_BatchFile"));
                    }
                },
                error: function () { }
            });
        }
    </script>
</body>
</html>
