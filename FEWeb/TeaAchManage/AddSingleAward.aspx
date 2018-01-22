<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddSingleAward.aspx.cs" Inherits="FEWeb.TeaAchManage.AddSingleAward" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>追加</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script> 
    <style>
        .input-wrap>label{min-width:60px;}
        .input-wrap2>label{position:absolute;left:0;top:0;}
        .input-wrap2>div{padding-left:70px;width:100%;box-sizing:border-box;}
    </style>
    <script type="text/x-jquery-tmpl" id="sub_Award">
        <div class="input-wrap">
            <label>金额：</label><input type="number" value="${Money}" isrequired="true" regtype="money" fl="金额" id="Award" name="Award" min="0" step="0.01" class="text" placeholder="请输入金额"/><label class="ml10">万元</label>
        </div>
        <div class="input-wrap input-wrap2 pr">
            <label>依据：</label>
            <div><textarea id="AddBasis" name="AddBasis" class="textarea" placeholder="请输入依据" isrequired="true" fl="依据">${AddBasis}</textarea></div>
        </div>
    </script>  
</head>
<body>
    <input type="hidden" name="Func" value="AddRewardDash" />
    <input type="hidden" name="EID" id="EID" />
    <input type="hidden" name="Id" id="Id" value="0" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" name="EditUID" id="EditUID" value="011" />   
    <div class="main" >
        <div id="div_Award" class="search_toobar clearfix"></div>
    </div>
    <div class="btnwrap">
        <input type="button" value="保存" onclick="submit();" class="btn" />
        <input type="button" value="取消" class="btna" onclick="javascript: parent.CloseIFrameWindow();" />
    </div>
</body>
</html>
<script src="../Scripts/Common.js"></script>
<script src="../scripts/public.js"></script>
<script src="../Scripts/jquery.tmpl.js"></script>
<script src="../Scripts/layer/layer.js"></script>
<script type="text/javascript">
    var UrlDate = new GetUrlDate();
    var itemid = UrlDate.id, Reward_Id = UrlDate.rwid, Rank_Id = UrlDate.rankid;
    $(function () {
        $("#CreateUID").val(GetLoginUser().UniqueNo);
        if (itemid != undefined && itemid != 0) {
            BindData();
        } else {
            $("#sub_Award").tmpl({ Award: '', AddBasis :''}).appendTo("#div_Award");
        }
    });
    function BindData() {
        $("#div_Award").empty();
        $.ajax({
            url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
            type: "post",
            dataType: "json",
            data: { Func: "Get_RewardBatchData", IsPage: false, Id: itemid, Reward_Id: Reward_Id, Rank_Id: Rank_Id, IsOnlyBase: 0 },
            success: function (json) {
                if (json.result.errMsg == "success") {
                    $("#sub_Award").tmpl(json.result.retData).appendTo("#div_Award");
                }
            },
            error: function () { }
        });
    }
    function submit() {
        var valid_flag = validateForm($('input[type="number"],#AddBasis'));;
        if (valid_flag !=0) {
            return false;
        }
        $.ajax({
            url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
            type: "post",
            dataType: "json",
            data: {
                "Func": "AddRewardDash", Id: itemid, Reward_Id: Reward_Id,Rank_Id: Rank_Id,
                AddAward: $("#Award").val().trim(), AddBasis: $("#AddBasis").val().trim(), CreateUID: $("#CreateUID").val()
            },
            success: function (json) {
                if (json.result.errNum == 0) {
                    parent.layer.msg('操作成功!');
                    parent.Get_RewardBatchData();//刷新父级弹框
                    parent.parent.BindRank(Reward_Id);//刷新父级弹框的父级
                    parent.CloseIFrameWindow();
                } else {
                    layer.msg(json.result.errMsg);
                }
            },
            error: function () { }
        });
    }
</script>
