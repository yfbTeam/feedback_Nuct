<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateOrEditModal.aspx.cs" Inherits="FEWeb.SysSettings.Reward.CreateOrEditModal" %>

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
                <label>年度：</label>
                <input type="text"  class="text Wdate" name="Year" id="Year" onclick="WdatePicker({ dateFmt: 'yyyy年' })" style="border:1px solid #ccc;width:250px;"/>
            </div>
            <div class="input-wrap">
                <label>名称：</label>
                <input type="text" class="text" name="" id="" placeholder="请输入名称"/>
            </div>
            <div class="input-wrap">
                <label>总金额：</label>
                <input type="number" class="text" name="" id="" placeholder="请输入金额"/>
            </div>
            <div class="input_lable2">
                <label for="" style="min-width:100px;">附件：</label>
                <div class="fl uploader_container pr" style="padding-left:110px;">
                    <div id="uploader">
                        <div class="queueList">
                            <div id="dndArea" class="placeholder photo_lists">
                                <div id="filePicker"></div>
                                <ul class="filelist clearfix"></ul>
                            </div>
                        </div>
                        <div class="statusBar" style="display: none;">
                            <div class="progress">
                                <span class="text">0%</span>
                                <span class="percentage"></span>
                            </div>
                            <div class="info"></div>                                
                        </div>
                    </div>
                    <div class="uploader_msg">单个文件大小不可超过50M</div>
                </div>
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
     <script src="../../Scripts/Webuploader/dist/webuploader.js"></script>
    <link href="../../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="../../TeaAchManage/upload_batchfile.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $(function () {
            BindFile_Plugin();
        })
    </script>
</body>
</html>
