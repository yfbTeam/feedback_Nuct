<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="FEWeb.SysSettings.Reward.Index" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>奖金管理</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/x-jquery-tmpl" id="tr_item">
        <tr>
            <td>${Year}年</td>
            <td>${Name}</td>
            <td>${BatchMoney}</td>
            <td>${UseMoney}</td>
            <td>${Num_Fixed(BatchMoney-UseMoney)}</td>
            <td>${DateTimeConvert(CreateTime)}</td>
            <td><div class="allotstatus" onclick="ChangeIsMoneyAllot(${Id});"><span class="{{if IsMoneyAllot==0}}switch-off{{else}}switch-on{{/if}}" themecolor="#6a264b" id="IsMoneyAllot_${Id}"></span></div></td>
            <td class="operate_wrap">
                <div class="operate" onclick="OpenIFrameWindow('查看奖金批次', 'Batch_Detail.aspx?Id=${Id}', '500px', '400px')">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看</span>
                </div>
                <div class="operate" onclick="OpenIFrameWindow('编辑奖金批次', 'Batch_Add.aspx?Id=${Id}', '500px', '400px')">
                    <i class="iconfont color_purple">&#xe628;</i>
                    <span class="operate_none bg_purple">编辑</span>
                </div>
                <div class="operate" onclick="window.location.href = 'DetailIndex.aspx?batchid=${Id}&Id=${pageid}&Iid=${pagelid}';">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">详情</span>
                </div>
                <div class="operate" onclick="Export_RewardBatchDetail(${Id},'${Name}');">
                    <i class="iconfont color_purple">&#xe63c;</i>
                    <span class="operate_none bg_purple">导出</span>
                </div>
                <div class="operate" onclick="Del_RewardBatch(${Id});">
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
            <div class="search_toobar clearfix" id="div_ache_bar">
                <div class="fl ml20">
                    <label for="">年度:</label>
                    <input type="text"  class="text Wdate" name="Year" id="Year" readonly="readonly" placeholder="请选择年度" onclick="WdatePicker({ dateFmt: 'yyyy年', onpicked: function () { GetData(1, 10); }, oncleared: function () { GetData(1, 10); } })" style="border:1px solid #ccc;width:150px;"/>
                </div>
                <div class="fl ml20">
                    <input type="text" name="Key" id="Key" placeholder="请输入奖金批次名称" value="" class="text fl" style="width: 150px;">
                    <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
                </div>
                <div class="fr">
                    <input type="button" value="新增奖金批次" class="btn" onclick="OpenIFrameWindow('新增奖金批次', 'Batch_Add.aspx?Id=0', '500px', '400px')">
                </div>
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th width="10%">年度</th>
                            <th width="22%">名称</th>
                            <th width="10%">总金额（元）</th>
                            <th width="10%">已分（元）</th>
                            <th width="10%">未分（元）</th>                                    
                            <th width="10%">创建时间</th>
                            <th width="10%">奖金分配开启</th>                                    
                            <th width="18%">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb_batch"></tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
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
                    <th width="7%">金额（元）</th>                   
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
    <script src="../../Scripts/laypage/laypage.js"></script>
    <link href="../../Scripts/HoneySwitch/honeySwitch.css" rel="stylesheet" />
    <script src="../../Scripts/HoneySwitch/honeySwitch-noclick.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
     <link href="../../Scripts/tableexport/dist/css/tableexport.min.css" rel="stylesheet">
    <script src="../../Scripts/tableexport/js/xlsx.core.min.js"></script>
	<script src="../../Scripts/tableexport/js/blob.js"></script>
	<script src="../../Scripts/tableexport/js/FileSaver.min.js"></script>
	<script src="../../Scripts/tableexport/dist/js/tableexport.js"></script>
    <script src="../../TeaAchManage/BaseUse.js"></script> 
     <script>
         var pageid = getQueryString('Id'), pagelid = getQueryString('Iid');
         $(function () {
             $('#top').load('/header.html');
             $('#footer').load('/footer.html');
             GetData(1, 10);
         });         
         var SerKey = $("#Key").val().trim();
         function search() {
             SerKey = $("#Key").val().trim();
             GetData(1,10);
         }
         function GetData(startIndex, pageSize) {
             $("#tb_batch").empty();
             Cur_BookData = [];
             var parmsData = { "Func": "Get_RewardBatchData", Year: $("#Year").val(), "Name": SerKey, PageIndex: startIndex, pageSize: pageSize };
             $.ajax({
                 url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                 type: "post",
                 dataType: "json",
                 data: parmsData,
                 success: function (json) {
                     if (json.result.errMsg == "success") {
                         $("#pageBar").show();                        
                         $("#tr_item").tmpl(json.result.retData.PagedData).appendTo("#tb_batch");
                         laypage({
                             cont: 'pageBar', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                             pages: json.result.retData.PageCount, //通过后台拿到的总页数
                             curr: json.result.retData.PageIndex || 1, //当前页
                             skip: true, //是否开启跳页
                             skin: '#6a264b',
                             jump: function (obj, first) { //触发分页后的回调
                                 if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr
                                     GetData(obj.curr, pageSize)
                                 }
                             }
                         });
                         honeySwitch.init();                         
                         tableSlide();
                     } else {
                         $("#pageBar").hide();
                         nomessage('#tb_batch');
                     }
                 },
                 error: function () {
                     //接口错误时需要执行的
                 }
             });
         }
         /* 删除奖金批次*/
         function Del_RewardBatch(id) {
             layer.confirm('确定删除该奖金批次吗？', {
                 btn: ['确定', '取消'],
                 title: '操作'
             }, function (index) {
                 $.ajax({
                     url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                     type: "post",
                     async: false,
                     dataType: "json",
                     data: { Func: "Del_RewardBatch", ItemId: id },
                     success: function (json) {
                         if (json.result.errNum == 0) {
                             layer.msg('操作成功!');
                             GetData(1, 10);
                         } else {
                             layer.msg(json.result.errMsg);
                         }
                     },
                     error: function () { }
                 });
             }, function () { });
         }

         //开启（关闭）奖金分配
         function ChangeIsMoneyAllot(id) {
             var IsMoneyAllot = 1;
             if ($("#IsMoneyAllot_"+id).hasClass("switch-on")) {
                 IsMoneyAllot = 0;
             }
             layer.confirm('确定' + (IsMoneyAllot == 0 ? '关闭' : '开启') + '该批次的奖金分配吗？', {
                 btn: ['确定', '取消'],
                 title: '操作'
             }, function (index) {
                 $.ajax({
                     url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                     type: "post",
                     dataType: "json",
                     data: { "Func": "ChangeIsMoneyAllot", Id: id, IsMoneyAllot: IsMoneyAllot },
                     success: function (json) {
                         if (json.result.errNum == 0) {
                             if (IsMoneyAllot == 1) {
                                 honeySwitch.showOn("#IsMoneyAllot_" + id);
                             }
                             else {
                                 honeySwitch.showOff("#IsMoneyAllot_" + id);
                             }
                             layer.close(index);
                         }
                     },
                     error: function () { }
                 });
             }, function () { });
         }
    </script>
</body>
</html>
