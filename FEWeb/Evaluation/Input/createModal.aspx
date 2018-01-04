<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="createModal.aspx.cs" Inherits="FEWeb.Evaluation.Input.createModal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="/images/favicon.ico" rel="shortcut icon" />
    <title>评价录入</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix" id="createInput">
            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section" style="width: 198px;">
                    </select>
                </div>

                <div class="fl ml10">
                    <label for="">评价名称:</label>
                    <select class="select" id="Rg" style="width: 198px;">
                        <option value="">全部</option>
                    </select>
                </div>
                <div class="fl ml10">
                    <label for="">教师姓名:</label>
                    <select class="select" id="Te" style="width: 198px;">
                        <option value="">全部</option>
                    </select>
                </div>

                <div class="fr" id="btCtrl">
                </div>
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th>序号</th>
                            <th>学年学期</th>
                            <th>评价名称</th>
                            <th>截止时间</th>
                            <th>评价课程</th>
                            <th>被评价教师</th>
                            <th>部门</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="ShowCourseInfo">
                    </tbody>
                </table>
                <div id="pageBar" class="page"></div>
            </div>
        </div>
        <footer id="footer"></footer>
        <script src="../../js/vue.min.js"></script>
        <script src="../../Scripts/Common.js"></script>
        <script src="../../Scripts/layer/layer.js"></script>
        <script src="../../Scripts/public.js"></script>
        <script src="../../Scripts/jquery.tmpl.js"></script>

        <link href="../../Scripts/choosen/prism.css" rel="stylesheet" />
        <link href="../../Scripts/choosen/chosen.css" rel="stylesheet" />
        <script src="../../Scripts/choosen/chosen.jquery.js"></script>
        <script src="../../Scripts/choosen/prism.js"></script>

        <script src="../../Scripts/WebCenter/Base.js"></script>
        <script src="../../Scripts/WebCenter/RegularEval.js"></script>
        <script src="../../Scripts/laypage/laypage.js"></script>

        <script type="text/x-jquery-tmpl" id="itembtn_Enable">
            <button class="btn ml10" onclick="OpenIFrameWindow('发起评教','StartEval.aspx','900px','650px')">发起评教</button>
            <button class="btn" onclick="window.history.go(-1);">返回上一步</button>
        </script>

        <script type="text/x-jquery-tmpl" id="itembtn_No_Enable">
            <button class="btn ml10" style="background: #A8A8A8">发起评教</button>
            <button class="btn" onclick="window.history.go(-1);">返回上一步</button>
        </script>

        <script type="text/x-jquery-tmpl" id="itemCount">
            <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
        </script>

        <script type="text/x-jquery-tmpl" id="itemData">
            <tr>
                <td style="width: 5%">${Num}</td>
                <td style="width: 10%">${DisPlayName}</td>
                <td style="width: 10%" title="${ReguName}">${cutstr(ReguName,10)}</td>
                <td style="width: 10%">${ DateTimeConvert(EndTime, 'yy-MM-dd', true)}</td>
                <td title="${Course_Name}" style="width: 20%">${cutstr(Course_Name,30)}</td>
                <td style="width: 7%">${TeacherName}</td>
                <td title="${Departent_Name}" style="width: 20%">${cutstr(Departent_Name,30)}</td>
                {{if StateType == 2}}
          <td style="width: 5%" class="operate_wrap">
              <div class="operate" onclick="window.location.href='./selectTable.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid') +'&TeacherUID='+'${TeacherUID}'+'&TeacherName='+'${TeacherName}'
                  +'&SectionID='+'${SectionID}'+'&DisPlayName='+'${DisPlayName}'+'&CourseID='+'${CourseID}'+'&CourseName='+'${Course_Name}'+'&ReguID='+'${ReguId}'+'&ReguName='+'${ReguName}'
                  +'&AnswerUID='+'${ExpertUID}'+'&AnswerName='+'${ExpertName}'">
                  <i class="iconfont color_purple">&#xe617;</i>
                  <span class="operate_none bg_purple">录入</span>
              </div>
          </td>
                {{else}}          
             <td style="width: 5%" class="operate_wrap">
                 <div class="operate">
                     <i class="iconfont color_gray">&#xe617;</i>
                     <span class="operate_none bg_gray">录入</span>
                 </div>
             </td>
                {{/if}}
            </tr>
        </script>

        <script>
            var reguType = 1;
            var select_sectionid = 0;
            var select_reguid = 0;
            var pageIndex = 0;
            $(function () {
                $('#top').load('/header.html');
                $('#footer').load('/footer.html');
            })
            var createInput = new Vue({
                el: '#createInput',
                data: {
                    list: [
                        {

                        }
                    ],
                    key: '',
                },
                methods: {
                    initList: function () {
                        var that = this;
                    }
                },
                mounted: function () {
                    var that = this;
                    Base.bindStudySectionCompleate = function () {
                        $('#section').on('change', function () {
                            Get_Eva_RegularDataSelect();
                            Reflesh();
                        });
                    };
                    Base.bindStudySection();

                    SelectUID = login_User.UniqueNo;
                    SectionID = select_sectionid

                    Get_Eva_RegularDataSelectCompleate = function () {
                        $('#Rg').on('change', function () {
                            Reflesh();
                        });

                        $('#Te').on('change', function () {
                            Reflesh();
                        });
                    };
                    Get_Eva_RegularDataSelect();

                    Base.CheckHasExpertReguCompleate = function (result, data) {
                        $('#btCtrl').empty();
                        if (result) {
                            $("#itembtn_Enable").tmpl(1).appendTo("#btCtrl");
                            select_sectionid = data[0].Section_Id;
                            select_reguid = data[0].Id;
                        }
                        else {
                            $("#itembtn_No_Enable").tmpl(1).appendTo("#btCtrl");
                        }
                    };
                    Base.CheckHasExpertRegu(reguType);

                    Get_Eva_RegularData(0, pageIndex);
                }
            })

            function Reflesh() {
                pageIndex = 0;
                Te = $('#Te').val();
                SectionID = $('#section').val();
                Get_Eva_RegularData($('#Rg').val(), pageIndex);
            }

        </script>
</body>
</html>
