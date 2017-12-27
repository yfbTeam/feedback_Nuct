﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="FEWeb.Index" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>首页</title>
    <link href="css/reset.css" rel="stylesheet" />
    <link href="css/layout.css" rel="stylesheet" />
    <script src="Scripts/jquery-1.11.2.min.js"></script>
    <script id="my_prize_detail_Item" type="text/x-jquery-tmpl">
        <tr>
           <td>${GidName}</td>
            <td>${AchiveName}</td>
            <td>${Major_Name}</td>
            <td>${ResponsName}</td>
            <td>${Year}</td>           
            <td>${Score}</td>
            <td>{{if Status==0}}<span class="nosubmit">待提交</span>
                {{else Status==1}}<span class="checking1">信息待审核</span>
                {{else Status==2}}<span class="nocheck">信息不通过</span>
                {{else Status==3}}<span class="assigning">分数待分配</span>
                {{else Status==4}}<span class="nosubmit">分数待提交</span>
                {{else Status==5}}<span class="checking1">分数待审核</span>
                {{else Status==6}}<span class="nocheck">分数不通过</span>
                {{else Status==7}}<span class="assigning">审核通过</span>
                {{else Status==8}}<span class="assigning">奖金待分配</span>
                {{else Status==9}}<span class="nosubmit">奖金待提交</span>
                {{else Status==10}}<span class="checking1">奖金待审核</span>
                {{else Status==11}}<span class="nocheck">奖金不通过</span>
                {{else}} <span class="assigning">审核通过</span>
                {{/if}}
            </td>
            <td>
                <div class="operate" onclick="OpenIFrameWindow('业绩查看',{{if ResponsMan==$('#CreateUID').val()}} 'TeaAchManage/CheckAchieve.aspx?Id=${Id}&Type=View'{{else}}'TeaAchManage/AchieveView_Common.aspx?Id=${Id}'{{/if}}, '1000px', '700px')">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看</span>
                </div>
            </td>
        </tr>
    </script>
</head>
<body>
    <header id="header"></header>
    <input type="hidden" id="CreateUID" value="011" />
    <div style="margin-top: 120px;">
        <div class="index_admin">
            <div class="center clearfix">
                <dl class="fl clearfix">
                    <dt>
                        <img id="ren" /></dt>
                    <dd>
                        <h1 id="username1"></h1>
                        <h2>欢迎回来</h2>
                    </dd>
                </dl>
                <div class="track_record fr clearfix">
                    <a class="fl record_fl" href="javascript:;">
                        <h1>待审核</h1>
                        <h2>5</h2>
                    </a>
                    <a class="fl record_fl" href="javascript:;">
                        <h1>待评价</h1>
                        <h2>10</h2>
                    </a>
                    <a class="fl record_fl" href="javascript:;">
                        <h1>评价总数</h1>
                        <h2>340</h2>
                    </a>
                    <a class="fl record_fl" href="javascript:;">
                        <h1>业绩总数</h1>
                        <h2>220</h2>
                    </a>
                    <a class="fl record_fl" href="javascript:;">
                        <h1>我的业绩</h1>
                        <h2>5</h2>
                    </a>
                </div>
            </div>
        </div>
        <div style="background: #fff;" id="index_body">
            <div class="center query_lists clearfix">
                <a href="/TeaAchManage/AchManage.aspx?Id=2&Iid=3" ss="3" mcode="a_index_acheiveadd" style="display:none;">
                    <i>
                        <img src="images/shouye_01.jpg" alt="" />
                    </i>
                    <p>业绩录入</p>
                </a>
                <a href="/Evaluation/EvaluationInput.aspx?Id=7&Iid=8" ss="8" mcode="a_index_evaluateadd" style="display:none;">
                    <i>
                        <img src="images/shouye_01.jpg" alt="" />
                    </i>
                    <p>评价录入</p>
                </a>
                <a href="/Evaluation/ClassEval.aspx?Id=7&Iid=10" ss="10" mcode="a_index_classcode" style="display:none;">
                    <i>
                        <img src="images/shouye_02.jpg" alt="" />
                    </i>
                    <p>课堂扫码评价</p>
                </a>
                <a href="/Evaluation/EvalStatist.aspx?Id=7&Iid=11" ss="11" mcode="a_index_statistic" style="display:none;">
                    <i>
                        <img src="images/shouye_03.jpg" alt="" />
                    </i>
                    <p>统计结果查询</p>
                </a>
            </div>
            <div class="center">
                <div class="sort_nav">
                    <a href="javascript:;" class="selected">我的业绩</a>
                    <%--<a href="javascript:;">我的课程</a>--%>
                </div>
                <div class="sort_item">
                    <div class="table">
                        <table>
                            <thead>
                                <tr>
                                    <th>奖励项目</th>
                                    <th width="320px">获奖项目名称</th>
                                    <th>负责单位</th>
                                    <th>负责人</th>
                                    <th>获奖年度</th>                                    
                                    <th>个人分数</th>
                                    <th>状态</th>                                    
                                    <th>操作</th>
                                </tr>                               
                            </thead>
                            <tbody id="myPirze_table"></tbody>
                        </table>
                        <div  id="myTable" class="page"></div>
                    </div>                    
                </div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="Scripts/Common.js"></script>
    <script src="Scripts/layer/layer.js"></script>
    <script src="Scripts/public.js"></script>
    <script src="Scripts/linq.min.js"></script>
    <script src="Scripts/jquery.tmpl.js"></script>
    <script src="Scripts/laypage/laypage.js"></script>
    <script>
        var cookie_Userinfo = JSON.parse(localStorage.getItem('Userinfo_LG'));
        $('#username1').html(cookie_Userinfo.Name);
        $('#ren').attr('src', cookie_Userinfo.HeadPic);
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            $('#header').load('/headerIndex.html');
            $('#footer').load('/footer.html');
            Get_PageBtn("/Index.aspx");
            navTab('.sort_nav', '.sort_item');
            getmyPrize(1, 10);

            var lens = $('.query_lists>a:visible').length;
            $('.query_lists>a').width(100 / lens + '%');

        });
        //获取我的业绩数据
        function getmyPrize(startIndex, pageSize) {
            $("#tb_info").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", "MyUno": $("#CreateUID").val(), PageIndex: startIndex, pageSize: pageSize, "Name": $("#Name").val() },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#my_prize_detail_Item").tmpl(json.result.retData.PagedData).appendTo("#myPirze_table");
                       
                        laypage({
                            cont: 'myTable', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
                            pages: json.result.retData.PageCount, //通过后台拿到的总页数
                            curr: json.result.retData.PageIndex || 1, //当前页
                            skip: true, //是否开启跳页
                            skin: '#6a264b',
                            jump: function (obj, first) { //触发分页后的回调
                                if (!first) { //点击跳页触发函数自身，并传递当前页：obj.curr
                                    getmyPrize(obj.curr, pageSize)
                                }
                            }
                        });
                        tableSlide();
                    } else {
                        nomessage('#myPirze_table');
                    }
                },
                error: function () {
                    nomessage('#myPirze_table');
                }
            });
        }
    </script>
</body>
</html>

