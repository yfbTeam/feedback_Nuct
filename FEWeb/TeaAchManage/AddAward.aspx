<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAward.aspx.cs" Inherits="FEWeb.TeaAchManage.AddAward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>奖金管理</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/x-jquery-tmpl" id="tr_Award">
        <tr id="tr_award_${Id}">
            <td>${rowNum}</td>
            <td>${Money}</td>
            <td>${CreateName}</td>
            <td>${DateTimeConvert(CreateTime)}</td>
            <td>${AddBasis}</td>
            <td class="operate_wrap">
                {{if UseCount>0}}
                   <div class="operate">
                         <i class="iconfont color_gray">&#xe617;</i>
                         <span class="operate_none bg_gray">修改</span>
                     </div>
                     {{if rowNum>1}} 
                    <div class="operate">
                             <i class="iconfont color_gray">&#xe61b;</i>
                             <span class="operate_none bg_gray">删除</span>
                         </div>
                    {{/if}}
                {{else}}
                    <div class="operate" onclick="Open_AddWindow(${Id});">
                        <i class="iconfont color_purple">&#xe617;</i>
                        <span class="operate_none bg_purple">修改</span>
                    </div>
                    {{if rowNum>1}} 
                    <div class="operate" onclick="DelReward(${Id});">
                        <i class="iconfont color_purple">&#xe61b;</i>
                        <span class="operate_none bg_purple">删除</span>
                    </div>
                    {{/if}}
                {{/if}}
            </td>
        </tr>
    </script>
</head>
<body >
    <input type="hidden" name="Func" value="AddRewardLevelData" />
    <!--这两个必须放在上边-->
    <input type="hidden" name="EID" id="EID" />
    <input type="hidden" name="Id" id="Id" value="0" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" name="EditUID" id="EditUID" value="011" />
    <div class="main" >
        <div class="search_toobar clearfix" style="padding:0px 0px 10px 0px;">
            <button class="btn fr" onclick="Open_AddWindow(0);">追加</button> 
        </div>
        <div class="table">
            <table>
                <thead>
                    <tr>
                        <th style="width:5%;">批次</th>
                        <th style="width:15%;">金额（元）</th>
                        <th style="width:12%;">追加人</th>
                        <th style="width:12%;">时间</th>
                        <th style="width:44%;">依据</th>
                        <th style="width:12%;">操作</th>
                    </tr>
                </thead>
                <tbody id="tb_Award"></tbody>
            </table>
        </div>
    </div>
    <div class="btnwrap">       
        <input type="button" value="关闭" class="btna" onclick="javascript: parent.CloseIFrameWindow();" />
    </div>
</body>
</html>
<script src="../Scripts/Common.js"></script>
<script src="../scripts/public.js"></script>
<script src="../Scripts/jquery.tmpl.js"></script>
<script src="../Scripts/layer/layer.js"></script>
<script type="text/javascript">
    var UrlDate = new GetUrlDate();
    var cur_rankid = UrlDate.rank || "", LID = UrlDate.lid || "";
    $(function () {
        $("#CreateUID").val(GetLoginUser().UniqueNo);
        Get_RewardBatchDetailData();
    });
    //绑定奖项奖金信息
    function Get_RewardBatchDetailData() {        
        $("#tb_Award").empty();
        $.ajax({
            url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
            type: "post",
            dataType: "json",
            data: { "Func": "Get_RewardBatchDetailData", "IsPage": "false", RewardBatch_Id: UrlDate.Id, Rank_Id: cur_rankid, IsOnlyBase: 0 },
            success: function (json) {
                if (json.result.errMsg == "success") {
                    $("#tr_Award").tmpl(json.result.retData).appendTo("#tb_Award");
                    tableSlide();
                }
            },
            error: function () {}
        });
    }
    function Open_AddWindow(id){
        OpenIFrameWindow(id == 0 ? '追加' : '修改', '../TeaAchManage/AddSingleAward.aspx?id=' + id + '&rwid=' + UrlDate.Id + '&rankid=' + cur_rankid + '&lid=' + LID, '480px', '320px');
    }    
    function DelReward(id) {
        layer.confirm('确认删除么吗？', {
            btn: ['确定', '取消'], //按钮
            title: '操作'
        }, function (index) {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Del_RewardBatch", ItemId: id },
                success: function (json) {
                    if (json.result.errNum == 0) {
                        layer.msg('操作成功!');
                        Get_RewardBatchDetailData();
                        if (cur_rankid == "") {
                            parent.BindReward(LID);
                        } else { //教学成果奖
                            parent.BindRank(UrlDate.Id);
                        }
                    } else {
                        layer.msg(json.result.errMsg);
                    }
                },
                error: function () {}
            });
        }, function () { });        
    }
</script>
