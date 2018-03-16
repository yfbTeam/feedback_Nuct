<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail_Add.aspx.cs" Inherits="FEWeb.SysSettings.Reward.Detail_Add" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="/images/favicon.ico" rel="shortcut icon" />
    <title>添加奖励项目</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>  
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr>
            <td width="6%"><input type="checkbox" value="${Id}" name="ss"/></td>
            <td>${GidName}</td>
            <td>${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${ResponsName}</td>
            <td>${Year}</td>            
        </tr>
    </script>    
</head>
<body>
    <div class="main">
        <div class="search_toobar clearfix">
            <div class="fl">
                <label for="">业绩类别:</label>
                <select class="select" style="width: 168px;" id="AcheiveType" onchange="Bind_SelGInfo();"></select>
            </div>
            <div class="fl ml20">
                <label for="">奖励项目：</label>
                <select class="select" name="Gid" id="Gid" onchange="BindData(1,10);" style="width: 168px;"></select>
            </div>
            <div class="fl ml20">
                <label for="">获奖年度:</label>
                <input type="text"  class="text Wdate" name="Year" id="Year" onclick="WdatePicker({ dateFmt: 'yyyy年', onpicked: function () { BindData(1, 10); }, oncleared: function () { BindData(1, 10); } })" style="border:1px solid #ccc;width:150px;"/>
            </div>
            <div class="fl ml20">
                <input type="text" name="Key" id="Key" placeholder="请输入获奖项目名称关键字" value="" class="text fl" style="width:180px;"/>
                <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
            </div>             
        </div>
        <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th width="6%"><input type="checkbox" id="ck_head"/></th>
                            <th width="19%">奖励项目</th>
                            <th width="20%">获奖项目名称</th>
                            <th width="19%">负责单位</th>
                            <th width="6%">负责人</th>
                            <th width="6%">获奖年度</th>                                    
                        </tr>
                    </thead>
                    <tbody id="tb_info"></tbody>
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
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../../TeaAchManage/BaseUse.js"></script>
    <script>
        var UrlDate = new GetUrlDate();
        var BatchId = UrlDate.batchid;
        $(function () {
            Bind_SelAchieve();
        });
        var SerKey = $("#Key").val().trim();
        function search() {
            SerKey = $("#Key").val().trim();
            BindData(1, 10);
        }
        function BindData(startIndex, pageSize) {
            $("#tb_info").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", PageIndex: startIndex, pageSize: pageSize, AchieveLevel: $("#AcheiveType").val(), Gid: $("#Gid").val(), Status_Com: '>2', Year: $("#Year").val(), AchiveName: SerKey },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#pageBar").show();
                        $("#tr_Info").tmpl(json.result.retData.PagedData).appendTo("#tb_info");
                        laypage({
                            cont: 'pageBar', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                            pages: json.result.retData.PageCount, //通过后台拿到的总页数
                            curr: json.result.retData.PageIndex || 1, //当前页
                            skip: true, //是否开启跳页
                            skin: '#6a264b',
                            jump: function (obj, first) { //触发分页后的回调
                                if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr
                                    BindData(obj.curr, pageSize)
                                }
                            }
                        });
                        tableSlide();
                    } else {
                        $("#pageBar").hide();
                        nomessage('#tb_info');
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function submit() {
            var checkedtr = $("input[type='checkbox'][name='ss']:checked");
            if (checkedtr.length == 0) { layer.msg('请勾选要添加的奖励项目！'); return; }
            var idArray = [];
            $(checkedtr).each(function (i, n) {
                idArray.push(n.value);
            });
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { Func: "Add_RewardBatchDetail", RewardBatch_Id: BatchId, Acheive_Ids: idArray.join(','), CreateUID: GetLoginUser().UniqueNo},
                success: function (json) {
                    if (json.result.errNum == 0) {
                        parent.layer.msg('操作成功!');                       
                        parent.BindData(1, 10);
                        parent.CloseIFrameWindow();
                    } 
                },
                error: function (errMsg) {}
            });
        }
    </script>
</body>
</html>


