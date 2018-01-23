<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CheckFail.aspx.cs" Inherits="FEWeb.TeaAchManage.CheckFail" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>教材查看审核</title>
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <style>
        .area_form {
            padding: 0px 0px 20px 0px;
        }
    </style>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr>
            <td>${Name}</td>
            <td>{{if ULevel==0}}独著{{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Achieve">
        <tr>
            <td>${GidName}</td>
            <td>${LevelName}</td>
            <td>${Year}</td>          
        </tr>
    </script>
</head>
<body style="background: #fff;">
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <div class="checkmes none"></div>
    <div class="main" >
        <div class="cont">
            <h2 class="cont_title"><span>教材信息</span></h2>
            <div class="area_form clearfix">
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            书名：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="Name"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            分册情况：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="IsOneVolum"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            主编姓名：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="MEditor"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            主编单位：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="MEditorDepart_Name"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            使用对象：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="UseObj"></span>
                        </div>
                    </div>
                </div>                
                <div class="col-xs-6 edition">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            立项类型：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="ProjectType"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6 none publish">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            出版时间：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="PublisthTime"></span>
                        </div>
                    </div>
                </div>
                 <div class="col-xs-6 none publish">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            出版社：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="Publisher"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6 none publish">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            ISBN 号：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="ISBN"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6 none publish">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            版次：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="EditionNo"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6 input_lable2">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            扫描文件：
                        </div>
                        <div class="col-xs-7">
                            <div class="fl uploader_container" style="padding-left:0px;">
                            <div id="uploader">
                                <div class="queueList">
                                    <div id="dndArea" class="placeholder photo_lists">                                   
                                        <ul class="filelist clearfix"></ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
               <div class="col-xs-6 btnprojrct none">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            立项信息：
                        </div>
                        <div class="col-xs-7">
                            <input type="button" id="btn_Project" name="name" value="查看立项教材信息" class="btn"/>
                        </div>
                    </div>
                </div>
                          
            </div>
            <h2 class="cont_title none" id="congshut"><span>丛书信息</span></h2>
            <div class="area_form none clearfix" id="congshu">
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            丛书名称：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="SeriesBookName"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            代表ISBN号：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="MainISBN"></span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            本丛书本数：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span id="SeriesBookNum"></span>
                        </div>
                    </div>
                </div>
                
            </div>
            <h2 class="cont_title"><span>作者信息</span></h2>
            <div class="area_form clearfix">
                <div class="clearfix">
                    <div class="radio_wrap">
                        <span class="fl status mr10">是否独著：</span>
                        <label id="IsOneAuthor"></label>
                    </div>
                    <span class="fr status mr10">总贡献字数：<span id="span_Words">0</span>万字</span>
                </div>
                <table class="allot_table mt10  ">
                    <thead>
                        <tr>
                            <th>姓名</th>
                            <th>作者类型</th>
                            <th>排名</th>
                            <th>部门</th>
                            <th>贡献字数（万字）</th>
                        </tr>
                    </thead>
                    <tbody id="AuthorInfo"> </tbody>
                </table>
            </div>       
            <h2 class="cont_title achieveshow none"><span>获奖信息</span></h2>
            <div class="area_form clearfix achieveshow none"> 
                <table class="allot_table mt10  ">
                    <thead>
                        <tr>                         
                            <th>奖励项目</th>
                            <th>获奖级别</th>                 
                            <th>获奖年度</th>                                  
                        </tr>
                    </thead>
                    <tbody id="tb_Achieve"> </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="btnwrap2 none">
        <input type="button" value="通过" class="btn" onclick="Check(3)" />
        <input type="button" value="不通过" class="btnb ml10" onclick="Check(2)" />
    </div>
    <script src="../Scripts/Common.js"></script>
    <script src="../scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>    
    <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <link href="../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="BaseUse.js"></script>
    <script type="text/javascript">
        var UrlDate = new GetUrlDate();
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            if (UrlDate.Type == "Check") {
                $(".checkmes").hide();
                $(".btnwrap2").show();
            }
            else {
                $(".checkmes").show();
                $(".btnwrap2").hide();
            }
            if (UrlDate.Id != undefined) {
                GetBookDetailById();
                Get_LookPage_Document(2, UrlDate.Id);                
            }
        });
        function GetBookDetailById() {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetTPM_BookStory", "IsPage": "false", Id: UrlDate.Id },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        
                        $(json.result.retData).each(function () {
                            Init_Controls(this);
                            $("#Name").html(this.Name);
                            //$("#BookType").val(this.BookType);
                            $("#IsOneVolum").html(this.IsOneVolum == "1" ? "单册" : "多册");                           
                            $("#MEditor").html(this.EditName);
                            $("#MEditorDepart_Name").html(this.MEditorDepart_Name);                            
                            $("#UseObj").html(this.UseObj);                                                        
                            $("#IsOneAuthor").html(this.IsOneAuthor == "1" ? "是" : "否");
                            $("#ProjectType").html(this.ProjectType == "1" ? "北京市精品教材立项" : "国家级精品教材立项");                            
                            $("#SeriesBookName").html(this.SeriesBookName);
                            $("#MainISBN").html(this.MainISBN);
                            $("#SeriesBookNum").html(this.SeriesBookNum + "本");
                            $("#EditionNo").html("第 " + this.EditionNo + " 版");
                            $("#ISBN").html(this.ISBN);
                            $("#Publisher").html(this.Publisher);
                            $("#PublisthTime").html(DateTimeConvert(this.PublisthTime, 'yyyy-MM'));
                            GetTPM_UserInfo('', UrlDate.Id);                                                      
                            switch (this.Status) {
                                case "0":
                                    $(".checkmes").html("未提交");
                                    break;
                                case "1":
                                    $(".checkmes").html("待审核");
                                    break;
                                case "2":
                                    $(".checkmes").html("审核不通过");
                                    break;
                                case "3":
                                    $(".checkmes").html("审核通过");
                                    break;
                                default:
                                    $(".checkmes").html("状态错误：" + this.Status);
                            }
                            if (this.Status == "1") {
                                $(".checkmes").html();
                            }
                            if (this.PrizeCount > 0) {$(".achieveshow").show();BindAchieveData(); } 
                        });
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function Init_Controls(model) {
            if (model.BookType == 1) {
                $(".publish").hide();
                $(".edition").show();
            } else {
                $(".publish").show();
                $(".edition").hide();
            }
            if (model.BookType == 2 && model.IdentifyCol > 0) {
                $(".btnprojrct").show();
                $("#btn_Project").click(function () {
                    OpenIFrameWindow('立项教材信息', 'CheckFail.aspx?Id=' + model.IdentifyCol + '&Type=Look', '700px', '60%');
                });
            }
            if (model.IsOneVolum == "1") {
                $("#congshut").hide();
                $("#congshu").hide();
            } else {
                $("#congshut").show();
                $("#congshu").show();
            }
        }
        function GetTPM_UserInfo(RIId, BookId) {
            $("#AuthorInfo").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetTPM_UserInfo", "IsPage": "false", RIId: RIId, BookId: BookId },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#tr_Info").tmpl(json.result.retData).appendTo("#AuthorInfo");
                        GetInit_WordNum(json.result.retData);
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function Check(Status) {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "CheckTPM_BookStory", "Status": Status, Id: UrlDate.Id },
                success: function (json) {
                    if (json.result.errNum ==0) {
                        parent.layer.msg('操作成功!');
                        parent.Book(1, 10);
                        parent.CloseIFrameWindow();
                    } else {
                        layer.msg(json.result.errMsg);
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function BindAchieveData() {
            $("#tb_Achieve").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", IsPage: false, BookId: UrlDate.Id, Status_Com: '>2' },
                success: function (json) {
                    if (json.result.errNum == 0) {
                        $("#tr_Achieve").tmpl(json.result.retData).appendTo("#tb_Achieve");                       
                    } else {
                        $("#tb_Achieve").html('<tr><td colspan="3">暂无</td></tr>');
                    }
                },
                error: function () {}
            });
        }
    </script>
</body>
</html>
