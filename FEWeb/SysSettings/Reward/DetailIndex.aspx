<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DetailIndex.aspx.cs" Inherits="FEWeb.SysSettings.Reward.DetailIndex" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>奖金批次详情</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/x-jquery-tmpl" id="con_item">
        <h1 class="title">
            <a href="Index.aspx?Id=${pageid}&Iid=${pagelid}" style="cursor: pointer;">奖金管理</a><span>&gt;</span>
            <a href="javascript:;" class="crumbs" id="GropName">${Name}</a>
        </h1>
        <div class="search_toobar clearfix">
            <div class="fl">
                <label for="">总金额：${BatchMoney}元</label>
            </div>
            <div class="fl ml20">
                <label for="">已分：${UseMoney}元</label>
            </div>
            <div class="fl ml20">
                <label for="">未分：${Num_Fixed(BatchMoney-UseMoney)}元</label>
            </div>
            <div class="fr">
                <input type="button" value="添加奖励项目" class="btn" onclick="OpenIFrameWindow('添加奖励项目', 'Detail_Add.aspx?batchid=${Id}', '1050px', '700px')">
                <input type="button" value="批量分配项目奖金" class="btn" onclick="BatchAllotReward();">
                <input type="button" value="导出分配明细" class="btn" onclick="Export_RewardBatchDetail(${Id},'${Name}');">
            </div>
        </div>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr id="tr_Detail_${Id}">
            <td>${GidName}</td>
            <td class="td_acname">${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${ResponsName}</td>
            <td>${Year}</td>          
            <td class="td_money"> 
                <span class="money_span">${Money}</span>
                <input type="number" isrequired="true" regtype="money" fl="金额" min="0.01" step="0.01" id="Money_${Id}" name="Money_${Id}" oldre="${Money}" value="${Money}" class="text money_input none" style="width:130px;"/>
            </td>
            <td>{{if AuditStatus==10||AuditStatus==0}}<span class="nosubmit">待分配</span>
                    {{else AuditStatus==1}}<span class="checking1">待审核</span>
                    {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                    {{else}} <span class="assigning">审核通过</span>{{/if}}</td>
            <td class="operate_wrap">
                <div class="operate" onclick="OpenIFrameWindow('分配奖金', 'Detail_AddReward.aspx?itemid=${Id}', '500px', '470px')">
                    <i class="iconfont color_purple">&#xe652;</i>
                    <span class="operate_none bg_purple">分配</span>
                </div>
                {{if AuditStatus!=10&&AuditStatus!=0}}
                <div class="operate" onclick="OpenIFrameWindow('奖金分配详情', 'AllotDetail.aspx?itemid=${Id}&achid=${Acheive_Id}&achtype=${AchieveType}', '700px', '500px')">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">详情</span>
                </div>                
                {{else}}
                    <div class="operate">
                        <i class="iconfont color_gray">&#xe60b;</i>
                        <span class="operate_none bg_gray">详情</span>
                    </div>
                {{/if}} 
                <div class="operate" onclick="Del_BatchDetail(${Id});">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <span class="operate_none bg_purple">删除</span>
                </div>               
            </td>
        </tr>
    </script>
    <script id="tr_Export" type="text/x-jquery-tmpl">
        <tr>
            <td>${GidName}</td>
            <td>${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${Year}</td>   
            <td>${RUserName}</td>                   
            <td>${AllotMoney}</td>
        </tr>
    </script>
    <style>       
        #table_1 {
            width: 0px;
            height: 0px;
            position: absolute;
            left: -99999px;
            top: -999999px;
        }
    </style>
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <div id="div_Batch"></div>            
            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">业绩类别:</label>
                    <select class="select" style="width: 198px;" id="AcheiveType" onchange="Bind_SelGInfo();"></select>
                </div>
                <div class="fl ml20">
                    <label for="">奖励项目：</label>
                    <select class="select" name="Gid" id="Gid" onchange="BindData(1,10);"></select>
                </div>
                <div class="fl ml20">
                    <label for="">获奖年度:</label>
                    <input type="text" class="text Wdate" name="Year" id="Year" readonly="readonly" placeholder="请选择年度" onclick="WdatePicker({ dateFmt: 'yyyy年', onpicked: function () { BindData(1, 10); }, oncleared: function () { BindData(1, 10); } })" style="border: 1px solid #ccc; width: 150px;" />
                </div>
                <div class="fl ml20">
                    <input type="text" name="Key" id="Key" placeholder="请输入获奖项目名称关键字" value="" class="text fl" style="width:180px;">
                    <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
                </div>
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th width="19%">奖励项目</th>
                            <th width="20%">获奖项目名称</th>
                            <th width="19%">负责单位</th>
                            <th width="6%">负责人</th>
                            <th width="6%">获奖年度</th>
                            <th width="8%">金额（元）</th>
                            <th width="6%">状态</th>
                            <th width="16%">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb_info"></tbody>
                </table>
            </div>
            <div class="btnwrap none">
                <input type="button" value="确定" class="btn" onclick="save();">
                <input type="button" value="取消" class="btna ml10" onclick="cancel()"></div>
            </div>
        </div>
    <footer id="footer"></footer>
    <div id="table_1">
        <table>
            <thead>
                <tr>
                    <th width="27%">奖励项目</th>
                    <th width="27%">获奖项目名称</th>
                    <th width="25%">负责单位</th>                    
                    <th width="7%">获奖年度</th>
                    <th width="7%">获奖人</th>
                    <th width="7%">金额金额（元）</th>                   
                </tr>
            </thead>
            <tbody id="tb_Export"></tbody>
        </table>
    </div>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/linq.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <link href="../../Scripts/tableexport/dist/css/tableexport.min.css" rel="stylesheet">
    <script src="../../Scripts/tableexport/js/xlsx.core.min.js"></script>
	<script src="../../Scripts/tableexport/js/blob.js"></script>
	<script src="../../Scripts/tableexport/js/FileSaver.min.js"></script>
	<script src="../../Scripts/tableexport/dist/js/tableexport.js"></script>
    <script src="../../TeaAchManage/BaseUse.js"></script> 
    <script>        
        var UrlDate = new GetUrlDate();
        var loginUser = GetLoginUser();
        var pageid = getQueryString('Id'), pagelid = getQueryString('Iid');
        var CurDetail_Data = [];
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            BindBatchData();
            Bind_SelAchieve();
        });
        function BindBatchData() {
            $("#div_Batch").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_RewardBatchData", Id: UrlDate.batchid, IsPage: false },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#con_item").tmpl(json.result.retData).appendTo("#div_Batch");                       
                    }
                },
                error: function () { }
            });
        }
        var SerKey = $("#Key").val().trim();
        function search() {
            SerKey = $("#Key").val().trim();
            BindData(1, 10);
        }
        function BindData(startIndex, pageSize) {
            $("#tb_info").empty();
            CurDetail_Data = [];
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { Func: "Get_RewardBatchDetailData", RewardBatch_Id: UrlDate.batchid, IsOnlyBase: 1, IsPage: false, AchieveLevel: $("#AcheiveType").val(), Gid: $("#Gid").val(), Year: $("#Year").val(), AchiveName: SerKey },
                success: function (json) {
                    if (json.result.errMsg == "success") {                       
                        CurDetail_Data = json.result.retData;
                        $("#tr_Info").tmpl(json.result.retData).appendTo("#tb_info");                        
                        tableSlide();
                    } else {                       
                        nomessage('#tb_info');
                    }
                },
                error: function () {}
            });
        }
        function Del_BatchDetail(detid) { //删除奖励项目
            layer.confirm('确定删除该奖励项目吗？', {
                btn: ['确定', '取消'],
                title: '操作'
            }, function (index) {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                    type: "post",
                    async: false,
                    dataType: "json",
                    data: { Func: "Del_RewardBatchDetail", ItemId: detid },
                    success: function (json) {
                        if (json.result.errNum == 0) {
                            layer.msg('操作成功!');
                            BindBatchData();
                            BindData(1, 10);
                        } else {
                            layer.msg(json.result.errMsg);
                        }
                    },
                    error: function () { }
                });
            }, function () { });
        }
        function BatchAllotReward() {
            $('#tb_info').find('.money_input').show();
            $('#tb_info').find('.money_span').hide();
            $('.btnwrap').show();
        }
        function cancel() {
            $('#tb_info').find('.money_input').hide();
            $('#tb_info').find('.money_span').show();
            $('.btnwrap').hide();
        }
        function save() {
            var idarray = [], moneyarray = [],warnarray=[],recordarray=[];
            $("#tb_info tr").each(function (i, n) {
                var did = n.id.replace('tr_Detail_', ''), money = Num_Fixed($(this).find('.td_money input[type=number]').val())
                      , oldmoney = Num_Fixed($(this).find('.td_money input[type=number]').attr('oldre'))
                , achname = $(this).find('.td_acname').html();
                if (Number(money) != Number(oldmoney)) { //修改的
                    idarray.push(did);
                    moneyarray.push(money);
                    warnarray.push("将" + achname + "的金额由" + oldmoney + "元改为" + money + "元");
                    recordarray.push("的金额由" + oldmoney + "元改为" + money + "元");
                }
            });
            if (idarray.length <= 0) {
                layer.msg("没有金额变动!");
                return;
            }
            var object = { Func: "BatchAllot_RewardBatchDetail", BatchId: idarray.join(','), BatchMoney: moneyarray.join(','), LoginUID: loginUser.UniqueNo };
            object.LoginName = loginUser.Name;
            object.ModifyRecord = recordarray.join(',');
            layer.confirm(warnarray.join('<br>'), {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function (index) {                
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                    type: "post",
                    dataType: "json",
                    data: object,
                    success: function (json) {
                        if (json.result.errNum == 0) {
                            layer.msg('操作成功!');
                            cancel();
                            BindBatchData();
                            BindData(1, 10);
                        } else { layer.msg(json.result.errMsg); }
                    },
                    error: function (errMsg) { alert(errMsg); }
                });
            }, function () { });
        }        
    </script>
</body>
</html>
