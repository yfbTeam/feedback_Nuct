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
</head>
<body>
    <div class="main">
        <div class="search_toobar clearfix">
            <div class="fl ml20">
                <label for="">业绩类别:</label>
                <select class="select" style="width: 168px;" id="AcheiveType" onchange="Bind_SelGInfo();"></select>
            </div>
            <div class="fl ml20">
                <label for="">奖励项目：</label>
                <select class="select" name="Gid" id="Gid" onchange="BindData(1,10);" style="width: 168px;"></select>
            </div>
            <div class="fl ml20">
                <label for="">获奖年度:</label>
                <input type="text"  class="text Wdate" name="Year" id="Year" onclick="WdatePicker({ dateFmt: 'yyyy年' })" style="border:1px solid #ccc;width:150px;"/>
            </div>
            <div class="fl ml20">
                <input type="text" name="key" id="key" placeholder="请输入获奖项目名称关键字" value="" class="text fl" style="width: 150px;">
                <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
            </div>
             
        </div>
        <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th width="6%">
                                <input type="checkbox" name="name" value="" /></th>
                            <th width="19%">奖励项目</th>
                            <th width="20%">获奖项目名称</th>
                            <th width="19%">负责单位</th>
                            <th width="6%">负责人</th>
                            <th width="6%">获奖年度</th>                                    
                        </tr>
                    </thead>
                    <tbody id="tb_info">
                        <tr>
                            <td width="6%">
                                <input type="checkbox" name="name" value="" /></td>
                            <td>个人竞赛奖奖励项目一</td>
                            <td>测试获奖证书</td>
                            <td>经济管理学院</td>
                            <td>李哲</td>
                            <td>2017</td>
                            <td>500</td>
                        </tr>
                    </tbody>
                </table>
                <div id="pageBar" class="page"></div>
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

