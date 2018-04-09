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

        .allot_table .th_score {
            width:34px;
        }

        .page {
            padding: 0;
        }
    </style>
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap ">
            <div class="sort_nav" id="threenav">
            </div>
            <h1 class="title mb10" style="text-align: left;" >
                 <div style="width: 1170px;cursor:pointer;  z-index: 99; background: #fff;  padding: 10px 0px;">
                <div class="crumbs">
                    <a href="javascript:history.go(-1)" id="crumb"></a>
                    <span>&gt;</span>
                    <a href="javascript:;" style="cursor:pointer;" onclick="window.location=window.location.href"  id="couse_name">统计详情</a>                 
                </div>
            </div>
            </h1>
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
    <script src="../../Scripts/nav.js"></script>
    <script src="../../Scripts/WebCenter/TableDesigin.js"></script>
    <script src="../../Scripts/WebCenter/Evaluate.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <%--固定表头--%>
    <script type="text/x-jquery-tmpl" id="item_check">
        <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
            <label for="">${Value}：【<label id="${CustomCode}"></label>】</label>
        </div>
    </script>
    <script type="text/x-jquery-tmpl" id="itemdata">
        <li>
            <dl>
                <dt>${Root}</dt>
                <dd>{{if HasQue1 == true}}
                        <table class="allot_table mt10">
                            <thead>
                                <tr>
                                    <th>调查项目</th>                                    
                                    <th class="th_score">A</th>                                   
                                    <th class="th_score">B</th>                                    
                                    <th class="th_score">C</th>                                   
                                    <th class="th_score">D</th>                                    
                                    <th class="th_score">E</th>
                                    <th class="th_score">F</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{each Eva_TableDetail_List}}
                                    {{if QuesType_Id ==1}}
                                        <tr>
                                            <td class="tl">${Sort}.${Name}</td>
                                            <td id="${Id}_A">0</td>
                                            <td id="${Id}_B">0</td>
                                            <td id="${Id}_C">0</td>
                                            <td id="${Id}_D">0</td>
                                            <td id="${Id}_E">0</td>
                                            <td id="${Id}_F">0</td>
                                        </tr>
                                {{/if}}                            
                                {{/each}}                                   
                            </tbody>
                        </table>
                    {{/if}}
                    {{if HasQue2 == true}}
                        <table class="allot_table mt10">
                            <thead>
                                <tr>
                                    <th>调查项目</th>                                   
                                    <th class="th_score">A</th>                                    
                                    <th class="th_score">B</th>                                   
                                    <th class="th_score">C</th>                                   
                                    <th class="th_score">D</th>                                   
                                    <th class="th_score">E</th> 
                                    <th class="th_score">F</th>                                 
                                </tr>
                            </thead>
                            <tbody>
                                {{each Eva_TableDetail_List}}
                                    {{if QuesType_Id ==2}}
                                        <tr>
                                            <td class="tl">${Sort}.${Name}</td>
                                            <td id="${Id}_A">0</td>
                                            <td id="${Id}_B">0</td>
                                            <td id="${Id}_C">0</td>
                                            <td id="${Id}_D">0</td>
                                            <td id="${Id}_E">0</td>
                                            <td id="${Id}_F">0</td>                           
                                        </tr>
                                {{/if}}                            
                                {{/each}}                                   
                            </tbody>
                        </table>
                    {{/if}}
                    {{if HasQue4 == true}}
                        <table class="allot_table mt10">
                            <thead>
                                <tr>
                                    <th>调查项目</th>
                                    <th width="309px">平均分</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{each Eva_TableDetail_List}}
                                {{if QuesType_Id ==4}}
                                        <tr>
                                            <td class="tl">${Sort}.${Name}</td>
                                            <td id="${Id}_AnswerScore">0</td>

                                        </tr>
                                {{/if}}                            
                                {{/each}}                                   
                            </tbody>
                        </table>
                    {{/if}}
                    {{if HasQue3 == true}}
                    <ul class="objective_lists">
                        {{each Eva_TableDetail_List}}
                       {{if QuesType_Id ==3}}
                        <li>
                            <dt tabledetailid="${Id}" style="border: none;" class="clearfix">
                                <div class="objective_name fl">${Name}</div>
                                <div class="fl pagebar"></div>
                                <i class="toggle iconfont">&#xe643;</i>
                            </dt>
                            <dd>
                                <table class="allot_table mt10">
                                    <tbody id="${Id}_tbody">
                                    </tbody>
                                </table>
                                <div id="${Id}_pageBar" class="page"></div>
                            </dd>
                        </li>
                        {{/if}}                            
                        {{/each}}       
                    </ul>
                    {{/if}}
                </dd>
            </dl>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="border: 0; float: left">${Answer}</td>
            <td style="border: 0; width: 7%; float: right">${DateTimeConvert(CreateTime,'yyyy-MM-dd',true)}</td>
            <td style="border: 0; float: right">${AnswerName}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>
    <script>
        var table_Id = getQueryString('TableID');
        var Type = getQueryString('Type');
        SectionID = getQueryString('SectionID');
        ReguID = getQueryString('ReguID');
        CourseID = getQueryString('CourseID');
        TeacherUID = getQueryString('TeacherUID');
        RoomID = getQueryString('RoomID');        
        Eva_Role = Type;
        State = 2;
        //var pageIndex = 0;
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            if (Type == 3) {
                $('#crumb').html($('#threenav').children().eq(0).html())
                $('#threenav').children().eq(0).addClass('selected');
            }
            else {
                $('#crumb').html($('#threenav').children().eq(1).html())
                $('#threenav').children().eq(1).addClass('selected');
            }
            UI_Table_View.PageType = 'detailModal';
            UI_Table_View.IsPage_Display = true;
            UI_Table_View.Get_Eva_TableDetail_Compleate = function (retData) {
                var headerList = retData.Table_Header_List.filter(function (item) { return item.CustomCode != null && item.CustomCode != '' });
                $("#item_check").tmpl(headerList).appendTo("#list");
                var list = retData.Table_Detail_Dic_List;
                for (var i in list) {
                    list[i].HasQue1 = false;
                    list[i].HasQue2 = false;
                    list[i].HasQue3 = false;
                    list[i].HasQue4 = false;
                    for (var j in list[i].Eva_TableDetail_List) {
                        var child = list[i].Eva_TableDetail_List[j];
                        if (child.QuesType_Id == 3) {
                            list[i].HasQue3 = true;
                            list[i].Que3_M = child;
                        }
                        else if (child.QuesType_Id == 1) {
                            list[i].HasQue1 = true;
                            list[i].Que1_M = child;
                        }else if (child.QuesType_Id == 2) {
                            list[i].HasQue2 = true;
                            list[i].Que2_M = child;
                        }
                        else if (child.QuesType_Id == 4) {
                            list[i].HasQue4 = true;
                            list[i].Que4_M = child;
                        }
                    }
                }
                console.log(list)
                $("#itemdata").tmpl(list).appendTo(".details_lists");
                animate();
            };
            UI_Table_View.Get_Eva_TableDetail();
            Get_Eva_RegularData_RoomDetailListCompleate = function (data) {

                for (var i in data.HeaderModelList) {
                    var obj = data.HeaderModelList[i];
                    //
                    $('#' + obj.CustomCode).text(obj.Value);
                }
            };
            Get_Eva_RegularData_RoomDetailList();
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
                var $next = $(this).parent().find('dd').eq(0);
                if ($next.prop('clientHeight') == 1) {
                    var TableDetailID = $(this).attr('TableDetailID');
                    Get_Eva_RoomDetailAnswerList(0, TableDetailID);
                }
            })
        }
    </script>
</body>
</html>
