﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AchieveCheck.aspx.cs" Inherits="FEWeb.TeaAchManage.AchieveCheck" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>业绩审核</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/x-jquery-tmpl" id="trAcheive">
        <tr>
            <td>${GidName}</td>
            <td>${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${ResponsName}</td>
            <td>${Year}</td>
            <td>{{if Status==1}}
                 <span class="checking1">信息待审核</span>
                {{else Status==5}}<span class="checking1">分数待审核</span>
                {{else}}<span class="checking1">奖金待审核</span>
                {{/if}}               
            </td>           
            <td class="operate_wrap">
                <div class="operate" onclick="OpenIFrameWindow('业绩审核', 'CheckAchieve.aspx?Id=${Id}&Type=Check', '1000px', '700px');;">
                    <i class="iconfont color_purple">&#xe624;</i>
                    <span class="operate_none bg_purple">审核</span>
                </div>
            </td>
        </tr>
    </script>
</head>
<body>
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap">
            <div class="sort_nav" id="threenav">
               
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th width="23%">奖励项目</th>
                            <th width="22%">获奖项目名称</th>
                            <th width="22%">负责单位</th>
                            <th width="15%">负责人</th>
                            <th width="5%">获奖年度</th>
                            <th width="8%">状态</th>                           
                            <th width="5%">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb_Acheive"></tbody>
                </table>
                <div id="pageBar_Acheive" class="page none"></div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/laypage/laypage.js"></script>
    <script>
        var loginUser = GetLoginUser();
        $(function () {
            $("#CreateUID").val(loginUser.UniqueNo);
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        });
    </script>
    <script>
        var UrlDate = new GetUrlDate();
        var pagebtns = [];
        $(function () {
            pagebtns=Get_PageBtn("/TeaAchManage/AchieveCheck.aspx");
            BindAchieve(1, 10);    
        });        
        function BindAchieve(startIndex, pageSize) {
            var rtnObj = GetAchieveIds();
            var departArray = rtnObj.departArray, allArray = rtnObj.allArray,two_status = rtnObj.two_status;
            $("#tb_Acheive").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", PageIndex: startIndex, pageSize: pageSize, AuditMajor_ID: loginUser.Major_ID, Level_DepartIds: departArray.join(','), Level_AllIds: allArray.join(','), TwoAudit_Status: two_status.join(',')},
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#trAcheive").tmpl(json.result.retData.PagedData).appendTo("#tb_Acheive");
                        laypage({
                            cont: 'pageBar_Acheive', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                            pages: json.result.retData.PageCount, //通过后台拿到的总页数
                            curr: json.result.retData.PageIndex || 1, //当前页
                            skip: true, //是否开启跳页
                            skin: '#6a264b',
                            jump: function (obj, first) { //触发分页后的回调
                                if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr
                                    BindAchieve(obj.curr, pageSize)
                                }
                            }
                        });
                        $("#pageBar_Acheive").show();
                        tableSlide();
                    } else {
                        $("#pageBar_Acheive").hide();
                        nomessage('#tb_Acheive');
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function GetAchieveIds() {
            //院系范围              全校范围
            var departArray = [-1], allArray = [-1],two_status=[-1];
            $.each(pagebtns, function (index, value) {
                var cur_code = value.MenuCode;
                if (cur_code.indexOf("achieve_depart_") != -1) {
                    var ach_did = cur_code.replace('achieve_depart_', '');
                    if (ach_did == "2") { //教师个人竞赛奖
                        two_status.push(1); //院系范围，二级待审核1，一级待审核1
                    }
                    departArray.push(ach_did);
                }
                if (cur_code.indexOf("achieve_all_") != -1) {
                    var ach_aid = cur_code.replace('achieve_all_', '');
                    if (ach_aid == "2") {//教师个人竞赛奖
                        two_status.push(3); //全校范围，二级审核通过3，一级待审核1
                    }
                    allArray.push(ach_aid);
                }
            });
            return { departArray: departArray, allArray: allArray, two_status: two_status }
        }
    </script>
</body>
</html>
