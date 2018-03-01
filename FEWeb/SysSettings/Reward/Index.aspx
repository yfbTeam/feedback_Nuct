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
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <div class="search_toobar clearfix" id="div_ache_bar">
                <div class="fl ml20">
                    <label for="">年度:</label>
                    <input type="text"  class="text Wdate" name="Year" id="Year" onclick="WdatePicker({ dateFmt: 'yyyy年' })" style="border:1px solid #ccc;width:150px;"/>
                </div>
                <div class="fl ml20">
                    <input type="text" name="key" id="key" placeholder="请输入奖金批次名称" value="" class="text fl" style="width: 150px;">
                    <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
                </div>
                <div class="fr">
                    <input type="button" value="新增奖金批次" class="btn" onclick="OpenIFrameWindow('新增奖金批次', 'Batch_Add.aspx', '500px', '400px')">
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
                    <tbody id="tb_info">
                        <tr>
                            <td>2017年</td>
                            <td>教学工作会议奖励费用</td>
                            <td>50000</td>
                            <td>40000</td>
                            <td>10000</td>
                            <td>2017-12-12</td>
                            <td><span class="switch-on" themecolor="#6a264b" id="IsMoneyAllot"></span></td>
                            <td class="operate_wrap">
                                <div class="operate" onclick="OpenIFrameWindow('查看奖金批次', 'Batch_Detail.aspx', '500px', '400px')">
                                    <i class="iconfont color_purple">&#xe60b;</i>
                                    <span class="operate_none bg_purple">查看</span>
                                </div>
                                <div class="operate" onclick="OpenIFrameWindow('编辑奖金批次', 'Batch_Add.aspx', '500px', '400px')">
                                    <i class="iconfont color_purple">&#xe628;</i>
                                    <span class="operate_none bg_purple">编辑</span>
                                </div>
                                <div class="operate">
                                    <i class="iconfont color_purple" onclick="window.location.href='DetailIndex.aspx'">&#xe60b;</i>
                                    <span class="operate_none bg_purple">详情</span>
                                </div>
                                <div class="operate">
                                    <i class="iconfont color_purple">&#xe63c;</i>
                                    <span class="operate_none bg_purple">导出</span>
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
    <link href="../../Scripts/HoneySwitch/honeySwitch.css" rel="stylesheet" />
    <script src="../../Scripts/HoneySwitch/honeySwitch.js"></script>
    <script type="text/javascript" src="../../Scripts/My97DatePicker/WdatePicker.js"></script>
     <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            honeySwitch.showOn("#IsMoneyAllot");
        })
    </script>
</body>
</html>
