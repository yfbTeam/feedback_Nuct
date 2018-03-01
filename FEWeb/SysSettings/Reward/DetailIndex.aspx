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
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <h1 class="title">
                <a href="" style="cursor: pointer;">奖金管理</a><span>&gt;</span>
                <a href="javascript:;" class="crumbs" id="GropName">教师个人参加竞赛获奖</a>
            </h1>
             <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">总金额：50000元</label>
                </div>
                <div class="fl ml20">
                    <label for="">已分：40000元</label>
                </div>
                <div class="fl ml20">
                    <label for="">未分：40000元</label>
                </div>
                <div class="fr">
                    <input type="button" value="添加奖励项目" class="btn" onclick="OpenIFrameWindow('添加奖励项目', 'Batch_Add.aspx', '500px', '400px')">
                    <input type="button" value="批量分配项目奖金" class="btn" onclick="OpenIFrameWindow('添加奖励项目', 'Batch_Add.aspx', '500px', '400px')">
                    <input type="button" value="导出分配明细" class="btn" >
                </div>
            </div>
            <div class="search_toobar clearfix">
                <div class="fl ml20">
                    <label for="">业绩类别:</label>
                    <select class="select" style="width: 198px;" id="AcheiveType" onchange="Bind_SelGInfo();"></select>
                </div>
                <div class="fl ml20">
                    <label for="">奖励项目：</label>
                    <select class="select" name="Gid" id="Gid" onchange="BindData(1,10);"></select>
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
                    <tbody id="tb_info">
                        <tr>
                            <td>个人竞赛奖奖励项目一</td>
                            <td>测试获奖证书</td>
                            <td>经济管理学院</td>
                            <td>李哲</td>
                            <td>2017</td>
                            <td>500</td>
                            <td>通过</td>
                            <td class="operate_wrap">
                                <div class="operate" onclick="OpenIFrameWindow('分配奖金', 'Detail_AddReward.aspx', '500px', '470px')">
                                    <i class="iconfont color_purple">&#xe652;</i>
                                    <span class="operate_none bg_purple">分配</span>
                                </div>
                                <div class="operate">
                                    <i class="iconfont color_purple" onclick="window.location.href='DetailIndex.aspx'">&#xe60b;</i>
                                    <span class="operate_none bg_purple">详情</span>
                                </div>
                                <div class="operate">
                                    <i class="iconfont color_purple">&#xe61b;</i>
                                    <span class="operate_none bg_purple">删除</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/linq.js"></script>
     <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        })
    </script>
</body>
</html>
