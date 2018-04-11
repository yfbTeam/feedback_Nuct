<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.index" %>

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
                                <th>教师姓名</th>
                                <th>专业部门</th>
                                <th>年级</th>
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
                <div class="operate" onclick="location.href='detailModal.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')+'&TableID='+'${TableID}'+'&SectionID='+'${SectionID}'+'&ReguID='+'${ReguID}'+'&CourseID='+'${CourseID}'+'&TeacherUID='+'${TeacherUID}'+'&RoomID='+'${RoomID}'+'&Type=2'">
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

    <script type="text/x-jquery-tmpl" id="item_mange_select">
        <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 148px;">
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">评价名称:</label>
                    <select class="select" id="Rg" style="width: 128px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">专业部门:</label>
                    <select class="select" style="width: 128px;" id="RP">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">年级:</label>
                    <select class="select" id="GD" style="width: 128px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">教师:</label>
                    <select class="select" id="TN" style="width: 128px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fr ml10">
                    <input type="text" name="Key" id="Key" placeholder="请输入课程名称" value="" class="text fl" style="width: 130px;">
                    <a href="javascript:;" class="search fl"><i class="iconfont">&#xe600;</i></a>
                </div>
    </script>

     <script type="text/x-jquery-tmpl" id="item_normal_select">
        <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 148px;">
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">评价名称:</label>
                    <select class="select" id="Rg" style="width: 128px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">专业部门:</label>
                    <select class="select" style="width: 128px;" id="RP">
                        <option value="">全部</option>
                    </select>
                </div>               
                <div class="fr ml10">
                    <input type="text" name="Key" id="Key" placeholder="请输入课程名称" value="" class="text fl" style="width: 130px;">
                    <a href="javascript:;" class="search fl"><i class="iconfont">&#xe600;</i></a>
                </div>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>
    <script>
        var pageIndex = 0;
        var rid = login_User.Sys_Role_Id;
        Get_PageBtn("/Evaluation/CourseEvalSee/index.aspx");
        var IsAdmin = JudgeBtn_IsExist("Manage"), IsNormal = JudgeBtn_IsExist("Normal")//普通教师
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            $(".search_toobar").empty();
                
            if (rid == 1)
            {
                $("#item_mange_select").tmpl(1).appendTo(".search_toobar");
            }
            else
            {
                $("#item_normal_select").tmpl(1).appendTo(".search_toobar");             
            }
            if (IsAdmin || rid == 1) {
            }
            else {
                TeacherUID = login_User.UniqueNo;
                Te = login_User.UniqueNo;
            }
            Base.bindStudySectionCompleate = function () {
                SectionID = $('#section').val();
                Type = 2;
                Get_Eva_Regular_Select();
                GetClassInfoSelect(SectionID);
                Get_Eva_RegularData_Room(pageIndex);
            };
            Base.bindStudySection();         
            $('#section').on('change', function () {
                SectionID = $('#section').val();
                Type = 2;

                $("#Rg").empty();
                $("#Rg").append("<option value=''>全部</option>");

               
                Get_Eva_Regular_Select();
                GetClassInfoSelect(SectionID);
                Refesh();

              
            });
            $('#Rg,#RP,#TN,#GD').on('change', Refesh);
            $('.search').on('click', Refesh);            
        })

        function Refesh() {
            pageIndex = 0;
            SectionID = $('#section').val();
            ReguID = $('#Rg').val();
            RP = $('#RP').val();
            Te = $('#TN').val();
            Gr = $('#GD').val();
         
            if (IsAdmin ) {
            }
            else {
                TeacherUID = login_User.UniqueNo;
                Te = login_User.UniqueNo;
            }
           
            Get_Eva_RegularData_Room(pageIndex);
        }

        //二维码
        function QRcode(id, RoomID, ReguID) {
           
            OpenIFrameWindow('二维码', 'Qcode.aspx?url=' + MobileUrl + 'Mobile/onlinetest.html?id=' + id + '&rId=' + RoomID + '&ReguID=' + ReguID + '&Eva_Role=2', '300px', '300px');
        }
    </script>
</body>
</html>
