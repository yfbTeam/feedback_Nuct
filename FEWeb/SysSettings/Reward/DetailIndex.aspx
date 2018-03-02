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
                <label for="">未分：${BatchMoney-UseMoney}元</label>
            </div>
            <div class="fr">
                <input type="button" value="添加奖励项目" class="btn" onclick="OpenIFrameWindow('添加奖励项目', 'Detail_Add.aspx?batchid=${Id}', '1050px', '700px')">
                <input type="button" value="批量分配项目奖金" class="btn" onclick="BatchAllotReward()">
                <input type="button" value="导出分配明细" class="btn">
            </div>
        </div>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr>
            <td>${GidName}</td>
            <td>${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${ResponsName}</td>
            <td>${Year}</td>          
            <td>
                <span class="money_span">${Money}</span>
                <input type="number" value="${Money}" class="text money_input none"/>
            </td>
            <td>{{if AuditStatus==10||AuditStatus==0}}<span class="nosubmit">待分配</span>
                    {{else AuditStatus==1}}<span class="checking1">待审核</span>
                    {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                    {{else}} <span class="assigning">审核通过</span>{{/if}}</td>
            <td class="operate_wrap">
                <div class="operate" onclick="OpenIFrameWindow('分配奖金', 'Detail_AddReward.aspx', '500px', '470px')">
                    <i class="iconfont color_purple">&#xe652;</i>
                    <span class="operate_none bg_purple">分配</span>
                </div>
                <div class="operate">
                    <i class="iconfont color_purple" onclick="OpenIFrameWindow('奖金分配详情', 'AllotDetail.aspx', '700px', '500px')">&#xe60b;</i>
                    <span class="operate_none bg_purple">详情</span>
                </div>
                <div class="operate">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <span class="operate_none bg_purple">删除</span>
                </div>
            </td>
        </tr>
    </script>
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
                    <select class="select" name="Gid" id="Gid"></select>
                </div>
                <div class="fl ml20">
                    <label for="">获奖年度:</label>
                    <input type="text" class="text Wdate" name="Year" id="Year" onclick="WdatePicker({ dateFmt: 'yyyy年' })" style="border: 1px solid #ccc; width: 150px;" />
                </div>
                <div class="fl ml20">
                    <input type="text" name="key" id="key" placeholder="请输入获奖项目名称关键字" value="" class="text fl" style="width:180px;">
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
                            <th width="6%">金额</th>
                            <th width="6%">状态</th>
                            <th width="18%">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb_info"></tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
            <div class="btnwrap none">
                <input type="button" value="确定" class="btn" onclick="save();">
                <input type="button" value="取消" class="btna ml10" onclick="cancel()"></div>
            </div>
        </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/linq.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../../TeaAchManage/BaseUse.js"></script> 
    <script>
        
        var UrlDate = new GetUrlDate();
        var pageid = getQueryString('Id'), pagelid = getQueryString('Iid');
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            BindBatchData();
            Bind_SelAchieve();
        });
        function BindBatchData() {
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
        function BindData(startIndex, pageSize) {
            $("#tb_info").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { Func: "Get_RewardBatchDetailData",RewardBatch_Id:UrlDate.batchid,IsOnlyBase:1,PageIndex: startIndex, pageSize: pageSize, AchieveLevel: $("#AcheiveType").val(), Gid: $("#Gid").val()},
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

        }
    </script>
</body>
</html>
