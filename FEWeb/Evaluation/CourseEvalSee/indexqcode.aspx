﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.index" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价查看</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix" id="courseEvalSee">
            <div class="sort_nav" id="threenav">
            </div>

            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 148px;">
                    </select>
                </div>

                <div class="fl ml10">
                    <label for="">课程:</label>
                    <select class="select" id="" style="width: 148px;">
                    </select>
                </div>

                <div class="fl ml10">
                    <label for="">合班:</label>
                    <select class="select" id="" style="width: 148px;">
                    </select>
                </div>

           
                <div class="fr pr ml10">
                    <button class="btn" >发起评价</button>
                    <b class="dian" style="display: none"></b>
                </div>

                <div class="fr pr ml10">
                    <button class="btn" onclick="window.location.href='TableDesign.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')">评价表管理</button>
                    <b class="dian" style="display: none"></b>
                </div>
               
                <div class="fr pr ml10">
                    <button class="btn" onclick="window.location.href='DatabaseMan.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')">指标库管理</button>
                    <b class="dian" style="display: none"></b>
                </div>
            </div>

            <div class="table mt10">
                <div>
                    <table>
                        <thead>
                            <tr>
                                <th>序号</th>
                                <th>学年学期</th>
                                <th>评价名称</th>
                                <th>课程名称</th>
                                <th>开始时间</th>
                                <th>结束时间</th>
                                <th>状态</th>
                                <th>合班</th>
                                <th>班级人数</th>
                                <th>参评人数</th>
                                <th>参评率</th>
                                <th>平均分</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="ShowCourseInfo">
                        </tbody>
                    </table>
                    <div id="pageBar" class="page"></div>
                </div>

            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/linq.js"></script>


    <link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
    <link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
    <script src="../../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../../Scripts/choosen/prism.js"></script>

    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>
    <script src="../../Scripts/WebCenter/Room.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>

    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td style="width: 5%">${Num}</td>
            <td style="width: 7%">${DisPlayName}</td>
            <td style="width: 7%" title="${ReguName}">${cutstr(ReguName,10)}</td>
            <td title="${CourseName}" style="width: 15%">${cutstr(CourseName,25)}</td>
            <td style="width: 7%">${TeacherName}</td>
            <td title="${RoomDepartmentName}" style="width: 15%">${cutstr(RoomDepartmentName,15)}</td>
            <td style="width: 6%">${GradeName}</td>
            <td title="${ClassName}" style="width: 10%">${cutstr(ClassName,10)}</td>
            <td style="width: 6%">${StudentCount}</td>
            <td style="width: 6%">${QuestionCount}</td>
            <td style="width: 4%">${QuestionAve*100}%</td>
            <td style="width: 5%">${ScoreAve}</td>


            <td class="operate_wrap">{{if QuestionCount >0}}
                <div class="operate" onclick="location.href='detailModal.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')+'&TableID='+'${TableID}'+'&SectionID='+'${SectionID}'+'&ReguID='+'${ReguID}'+'&CourseID='+'${CourseID}'+'&TeacherUID='+'${TeacherUID}'">
                    <i class="iconfont color_purple">&#xe606;</i>
                    <span class="operate_none bg_purple">详情</span>
                </div>
                {{else}}
                 <div class="operate">
                     <i class="iconfont color_gray">&#xe606;</i>
                     <span class="operate_none bg_gray">详情</span>
                 </div>
                {{/if}}
                {{if IsOverTime == true}}
                <div class="operate">
                    <i class="iconfont color_gray">&#xe609;</i>
                    <span class="operate_none bg_gray">扫码</span>
                </div>
                {{else IsOverTime == false}}
                <div class="operate" onclick="QRcode('${TableID}','${RoomID}','${ReguID}');">
                    <i class="iconfont color_purple">&#xe609;</i>
                    <span class="operate_none bg_purple">扫码</span>
                </div>
                {{/if}}
            </td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>
    <script>
        var pageIndex = 0;

        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            
        })

        function Refesh() {
            pageIndex = 0;
            SectionID = $('#section').val();
            ReguID = $('#Rg').val();
            RP = $('#RP').val();
            Te = $('#TN').val();
            Gr = $('#GD').val();


            Get_Eva_RegularData_Room(pageIndex);
        }

        //二维码
        function QRcode(id, RoomID, ReguID) {
            OpenIFrameWindow('二维码', 'Qcode.aspx?url=' + MobileUrl + 'Mobile/onlinetest.html?id=' + id + '&rId=' + RoomID + '&ReguID=' + ReguID, '300px', '300px');
        }

    </script>
</body>
</html>
