<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="FEWeb.Index" %>
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
            <td>${SelfScore}</td>
            <td>{{if ResponsMan == $('#CreateUID').val()}}                  
                    {{if ComStatus==0}}<span class="nosubmit">待提交</span>
                    {{else ComStatus==1}}<span class="checking1">信息待审核</span>
                    {{else ComStatus==2}}<span class="nocheck">信息不通过</span>
                    {{else ComStatus==3}}<span class="assigning">分数待分配</span>
                    {{else ComStatus==4}}<span class="nosubmit">分数待提交</span>
                    {{else ComStatus==5}}<span class="checking1">分数待审核</span>
                    {{else ComStatus==6}}<span class="nocheck">分数不通过</span>
                    {{else ComStatus==7}}<span class="assigning">审核通过</span>
                    {{else ComStatus==8}}<span class="assigning">奖金待分配</span>
                    {{else ComStatus==9}}<span class="nosubmit">奖金待提交</span>
                    {{else ComStatus==10}}<span class="checking1">奖金待审核</span>
                    {{else ComStatus==11}}<span class="nocheck">奖金不通过</span>
                    {{else}} <span class="assigning">审核通过</span>
                    {{/if}}
                {{else}}
                    <span class="assigning">审核通过</span>
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
                        <h1>待审核业绩</h1>
                        <h2 id="checkNumber"></h2>
                    </a>
                    <a class="fl record_fl">
                        <h1>我的业绩</h1>
                        <h2 id="myAcheiveNumber"></h2>
                    </a>
                    <a class="fl record_fl">
                        <h1>我的教材</h1>
                        <h2 id="myStoryNumber"></h2>
                    </a>
                </div>
            </div>
        </div>
        <div style="background: #fff;" id="index_body">
            <div class="center query_lists clearfix">
                <a href="/TeaAchManage/AchManage.aspx?Id=2&Iid=3" ss="3" mcode="a_index_AchManage" style="display:none;">
                    <i>
                        <img src="images/index_01.png" alt="" />
                    </i>
                    <p>业绩管理</p>
                </a>
                <a href="/TeaAchManage/MyPerformance.aspx?Id=2&Iid=4" ss="4" mcode="a_index_MyPerformance" style="display:none;">
                    <i>
                        <img src="images/index_02.png" alt="" />
                    </i>
                    <p>我的业绩</p>
                </a>
                <a href="/TeaAchManage/AcheveRewadSearch.aspx?Id=2&Iid=5" ss="5" mcode="a_index_AcheveRewadSearch" style="display:none;">
                    <i>
                        <img src="images/index_03.png" alt="" />
                    </i>
                    <p>业绩查询</p>
                </a>
                <a href="/Evaluation/EvaluationInput.aspx?Id=7&Iid=8" ss="8" mcode="a_index_EvaluationInput" style="display:none;">
                    <i>
                        <img src="images/index_04.png" alt="" />
                    </i>
                    <p>评价录入</p>
                </a>
                <a href="/Evaluation/TaskAllot.aspx?Id=7&Iid=9" ss="9" mcode="a_index_TaskAllot" style="display:none;">
                    <i>
                        <img src="images/index_05.png" alt="" />
                    </i>
                    <p>审核入库</p>
                </a>
                <a href="/Evaluation/ExpertEvalSee/index.aspx?Id=7&Iid=134" ss="134" mcode="a_index_ExpertEvalSee" style="display:none;">
                    <i>
                        <img src="images/index_06.png" alt="" />
                    </i>
                    <p>专家评价查看</p>
                </a>
                <a href="/Evaluation/CourseEvalSee/index.aspx?Id=7&Iid=135" ss="135" mcode="a_index_CourseEvalSee" style="display:none;">
                    <i>
                        <img src="images/index_07.png" alt="" />
                    </i>
                    <p>课堂评价查看</p>
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
            Get_IndexData();
            var lens = $('.query_lists>a:visible').length;
            if (lens < 4) {
                $('.query_lists>a').width(100 / lens + '%');
            }
        });
        //获取我的业绩数据
        function getmyPrize(startIndex, pageSize) {
            $("#myPirze_table").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", "MyUno": $("#CreateUID").val(), MyAch_LoginUID: $("#CreateUID").val(), PageIndex: startIndex, pageSize: pageSize, "Name": $("#Name").val() },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#my_prize_detail_Item").tmpl(json.result.retData.PagedData).appendTo("#myPirze_table");
                        $("#myTable").show();
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
                        $("#myTable").hide();
                        nomessage('#myPirze_table');
                    }
                },
                error: function () {
                    nomessage('#myPirze_table');
                }
            });
        }
        //获取统计信息
        function Get_IndexData() {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Get_IndexData", LoginUID: $("#CreateUID").val() },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        var model = json.result.retData[0];
                        $('#checkNumber').html(model.AuditCount);
                        $('#myAcheiveNumber').html(model.MyCount);
                        $('#myStoryNumber').html(model.BookCount);
                    } 
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
    </script>
</body>
</html>

