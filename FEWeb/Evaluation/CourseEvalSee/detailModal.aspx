<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detailModal.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.detailModal" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>评价统计</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
        .test_module {
            border: none;
        }

        .test_lists ul li {
            padding-right: 0;
        }

        .tableheader .evalmes {
            text-align: center;
        }

        .h1_div {
            margin-top: 0;
            background: #f9f4f8;
            height: 40px;
        }

            .h1_div h1 {
                margin-top: -9px;
                margin-left: 20px;
            }


        .tableheader .tablename {
            height: 20px;
        }

        .tableheader .evalmes span {
            line-height: 40px;
        }

        .wrap h1 {
            vertical-align: middle;
            text-align: center;
            font-size: 20px;
            margin: 15px 0 15px 0;
        }

        .evalmes {
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap ">
            <h1 class="tablename" style="font-weight: bold;"></h1>

            <div class="evalmes" style="color: #999999; font-size: 14px">
                <span id="sp_total"></span>
                <span id="remark"></span>
            </div>
            <div class="table_header_left clearfix" style="min-height: 49px" id="list">
            </div>
            <div class="mt10">
                <ul class="details_lists">
                </ul>
            </div>

        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/WebCenter/TableDesigin.js"></script>

    <%--固定表头--%>
    <script type="text/x-jquery-tmpl" id="item_check">
        <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
            {{if CustomCode == ""|| CustomCode == null}}
             <label for="">${Header}：【】</label>
            {{else  1==1}}
             <label for="">${Value}：【】</label>
            {{/if}}
           
        </div>
    </script>

    <script type="text/x-jquery-tmpl" id="itemdata">
        <li>
            <dl>
                <dt>${Root}</dt>
                <dd>
                    {{each Eva_TableDetail_List}}

                    <table class="allot_table mt10">
                        <thead>
                            <tr>
                                <th>调查项目</th>
                                <th width="5%">A</th>
                                <th width="5%">B</th>
                                <th width="5%">C</th>
                                <th width="5%">D</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="tl">1.按时上下课</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                            </tr>
                            <tr>
                                <td class="tl">1.按时上下课</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                            </tr>
                            <tr>
                                <td class="tl">1.按时上下课</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                                <td>12人</td>
                            </tr>
                        </tbody>
                    </table>
                    <ul class="objective_lists">
                        <li>
                            <dt style="border: none;" class="clearfix">
                                <div class="objective_name fl">7.希望与要求</div>
                                <div class="fl pagebar" id="page_top"></div>
                                <i class="toggle iconfont">&#xe643;</i>
                            </dt>
                            <dd>
                                <div class="lists_row">
                                    <span>11111111111111111111111111111<b class="fr">2017-08-12</b></span>
                                </div>
                                <div class="lists_row">
                                    <span>11111111111111111111111111111<b class="fr">2017-08-12</b></span>
                                </div>
                                <div class="pagebar" id="page_bottom"></div>
                            </dd>
                        </li>
                    </ul>

                    {{/each}}
                </dd>
            </dl>
        </li>
    </script>


    <script>

        var table_Id = getQueryString('TableID');
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            UI_Table_View.PageType = 'detailModal';
            UI_Table_View.IsPage_Display = true;
            UI_Table_View.Get_Eva_TableDetail_Compleate = function (retData) {

                var headerList = retData.Table_Header_List.filter(function (item) { return item.CustomCode != null && item.CustomCode != '' });
                var head_value = retData.Table_Header_List.filter(function (item) { return item.CustomCode == null || item.CustomCode == '' });

                $("#item_check").tmpl(headerList).appendTo("#list");
                $("#item_check").tmpl(head_value).appendTo("#list");

                $("#itemdata").tmpl(retData.Table_Detail_Dic_List).appendTo(".details_lists");
                
            };
            UI_Table_View.Get_Eva_TableDetail();

            animate();
        })
        function animate() {
            $('.objective_lists').find('li:has(dt)').find('dt').click(function () {
                var $next = $(this).next('dd');
                if ($next.is(':hidden')) {
                    $(this).parent().siblings('li').removeClass('active');
                    $(this).parent('li').addClass('active');
                    $next.stop().slideDown();

                    if ($(this).parent('li').siblings('li').children('dd').is(':visible')) {
                        $(this).parent("li").siblings("li").removeClass('active');
                        $(this).parent("li").siblings("li").find("dd").slideUp();
                    }

                } else {
                    $(this).parent('li').removeClass('active');
                    $next.stop().slideUp();
                }

            })
        }
    </script>
</body>
</html>
