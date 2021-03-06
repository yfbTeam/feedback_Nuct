﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CheckAchieve.aspx.cs" Inherits="FEWeb.TeaAchManage.CheckAchieve" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>业绩查看审核</title>
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <style>
        .area_form {
            padding: 0px 0px 20px 0px;
        } 
        .file-ary .title1{
            float:left;line-height:35px;
        } 
        .file-ary .file-panel{
            float:left;margin-left:10px;cursor:pointer;
        }      
    </style>
    <%--业绩信息--%>
    <script type="text/x-jquery-tmpl" id="div_AchInfo">
        {{if UrlDate.Type!='Check'||(UrlDate.Type=='Check'&&Status==1)}}
             <h2 class="cont_title re_view"><span>获奖文件信息</span></h2>
            <div class="area_form clearfix re_view">
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            发文号：
                        </div>
                        <div class="col-xs-7 msg_control">
                             <span>${FileEdionNo}</span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            文件名称：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span>${FileNames}</span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            认定机构：
                        </div>
                        <div class="col-xs-7 msg_control">
                            <span>${DefindDepart}</span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="row msg_item">
                        <div class="col-xs-5 msg_label">
                            认定日期：
                        </div>
                        <div class="col-xs-7 msg_control">
                           <span>${DateTimeConvert(DefindDate, '年月日')}</span>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12">
                    <div class="row msg_item">
                        <div class=" msg_label fl" style="width:200px;">
                            获奖文件：
                        </div>
                        <div class="col-xs-9">
                           <div class="uploader_container" style="padding-left:0px;">
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
                
            </div>
        {{/if}}
           <h2 class="cont_title"><span>基本信息</span></h2>
        <div class="area_form clearfix">
            {{if AchieveType!=3&&GPid!=4}}  
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖项目名称：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${AchiveName}</span>
                    </div>
                </div>
            </div>
            {{/if}}
            {{if  AchieveType==3}}
            <div class="col-xs-6 book">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        书名：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${BookName}</span>
                        <input type="hidden" id="BookId" name="BookId" value="${BookId}" />
                    </div>
                </div>
            </div>
            <div class="col-xs-6 book">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        书号：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${ISBN}</span>
                    </div>
                </div>
            </div>
            {{/if}}
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        奖励项目：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${GidName}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖级别：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${LevelName}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        奖励等级：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${RewadName}</span>
                    </div>
                </div>
            </div>
            {{if AchieveType==2}}
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        排名：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${RankName}</span>
                    </div>
                </div>
            </div>
            {{/if}}
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖年度：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${Year}</span>
                    </div>
                </div>
            </div>
            {{if AchieveType!=3}}
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        {{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${ResponsName}</span>
                    </div>
                </div>
            </div>
             {{/if}}
             <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        负责单位：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <span>${Major_Name}</span>
                    </div>
                </div>
            </div>           
            <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖证书：
                    </div>
                    <div class="col-xs-7 msg_control">
                        <div class="fl">
                            <ul id="ul_Certificate_6" class="clearfix file-ary"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>         
               <h2 class="cont_title members {{if AchieveType!=2||(UrlDate.Type=='Check'&&Status!=1)||(UrlDate.Type!='Check'&&((ResponsMan!=$('#CreateUID').val()&&Status>6)||(ResponsMan==$('#CreateUID').val()&&Status>3)))}}none{{/if}}"><span>成员信息</span></h2>
            <div class="area_form members {{if AchieveType!=2||(UrlDate.Type=='Check'&&Status!=1)||(UrlDate.Type!='Check'&&((ResponsMan!=$('#CreateUID').val()&&Status>6)||(ResponsMan==$('#CreateUID').val()&&Status>3)))}}none{{/if}}">
                <div class="clearfix {{if ResponsMan!=$('#CreateUID').val()&&CreateUID!=$('#CreateUID').val()&&UrlDate.Type!='Check'}}none{{/if}}" id="div_user_mem">                        
                    <span class="fr status"><span id="span_UnScore" style="color:#d02525;">未分：0分</span></span>
                    <span class="fr status">已分：<span id="span_CurScore">0</span>分，</span>
                    <span class="fr status">总分：<span id="span_AllScore">${TotalScore}</span>分，</span>
                </div>
                <table class="allot_table mt10">
                    <thead>
                        <tr>                               
                            <th>姓名</th>
                            <th>部门</th>
                            <th {{if ResponsMan!=$('#CreateUID').val()&&CreateUID!=$('#CreateUID').val()&&UrlDate.Type!='Check'}}style="display:none;"{{/if}}>分数</th>
                        </tr>
                    </thead>
                    <tbody id="tb_Member"></tbody>
                </table>
            </div>
            <h2 class="cont_title book {{if AchieveType!=3||(UrlDate.Type=='Check'&&Status!=1)||(UrlDate.Type!='Check'&&((ResponsMan!=$('#CreateUID').val()&&Status>6)||(ResponsMan==$('#CreateUID').val()&&Status>3)))}}none{{/if}}"><span>作者信息</span></h2>
            <div class="area_form book {{if AchieveType!=3||(UrlDate.Type=='Check'&&Status!=1)||(UrlDate.Type!='Check'&&((ResponsMan!=$('#CreateUID').val()&&Status>6)||(ResponsMan==$('#CreateUID').val()&&Status>3)))}}none{{/if}}" >
                <div class="clearfix" id="div_user_book"> 
                    <span class="fr status">总分：<span id="span_BookScore">0</span>分</span>                      
                    <span class="fr status">总贡献字数：<span id="span_Words">0</span>万字，</span>                       
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
                    <tbody id="tb_info"></tbody>
                </table>
            </div>    
            <h2 class="cont_title {{if Status < 4}}none{{/if}}"><span>分数分配</span></h2> 
            <div class="area_form {{if Status < 4}}none{{/if}}">
                <div class="clearfix">
                    <div class="fl status-left">
                         <label for="">状态：</label>
                        {{if Status==3}} <span class="assigning">待分配</span>
                        {{else Status==4}}<span class="nosubmit">{{if ResponsMan==$('#CreateUID').val()}}待提交{{else}}待分配{{/if}}</span>
                        {{else Status==5}}<span class="checking1">待审核</span>
                        {{else Status==6}}<span class="nocheck">审核不通过</span>
                        {{else}}<span class="pass">审核通过</span>{{/if}}
                    </div>
                    <div id="div_score_statis" class="fr status {{if ResponsMan!=$('#CreateUID').val()&&UrlDate.Type!='Check'&&Status<7}}none{{/if}}"></div>
                </div>
                <table class="allot_table mt10 {{if ResponsMan!=$('#CreateUID').val()&&UrlDate.Type!='Check'&&Status<7}}none{{/if}}">
                    <thead>
                        <tr class="user_mem none">
                            <th>成员</th>                            
                            <th>部门</th>  
                            <th>分数</th>                                        
                        </tr>
                        <tr class="user_book none">
                            <th>姓名</th>
                            <th>作者类型</th>
                            <th>排名</th>
                            <th>部门</th>
                            <th>贡献字数（万字）</th>
                            <th>分数</th>
                        </tr>
                    </thead>
                    <tbody id="tb_Member1"></tbody>
                </table>               
                <div class="clearfix mt10 Enclosure {{if ResponsMan!=$('#CreateUID').val()&&UrlDate.Type!='Check'&&Status<7}}none{{/if}}">
                    <div class="status-left clearfix">
                        <label for="" class="fl">附件：</label>
                        <div class="fl">
                            <ul id="ul_ScoreFile" class="clearfix file-ary"></ul>
                        </div>
                    </div>
                </div>
            </div>
            <h2 class="cont_title re_reward none"><span>奖金分配</span></h2> 
            <div class="area_form re_reward none" id="div_MoneyInfo"></div>        
            <h2 class="cont_title re_history none"><span>分配历史</span></h2>
            <div class="area_form re_history none">
                <ul class="history" id="ul_Record"></ul>
            </div>
    </script>
    <%--成员信息--%>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit">
        <tr class="memedit" un="${UserNo}">
            <td class="td_memname">${Name}</td>
            <td>${Major_Name}</td>
            <td class="td_score" {{if cur_ResponUID!=$('#CreateUID').val()&&cur_AchCreateUID!=$('#CreateUID').val()&&UrlDate.Type!='Check'}}style="display:none;"{{/if}}>${Score}</td>           
        </tr>
    </script>
    <%--成员信息--%>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit1">
        <tr id="tr_mem_${Id}" class="memedit" un="${UserNo}">
            <td class="td_memname">${Name}</td>           
            <td>${Major_Name}</td>
            <td class="td_score">${Score}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr>
            <td>${Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>            
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>           
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_Info1">
        <tr un="${UserNo}">
            <td class="td_memname">${Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>            
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
            <td class="td_score">{{if ULevel==3}}0{{else}}${Num_Fixed(UnitScore* WordNum)}{{/if}}</td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="div_item">
       <div class="clearfix allot_item">
            <div class="clearfix">
                <div class="fl status-left">
                    <label for="" style="margin-right:20px;">${BatName}</label>
                    <label for="">状态：</label>
                    {{if AuditStatus==10}}<span class="nosubmit">待分配</span>
                    {{else AuditStatus==0}}<span class="nosubmit">{{if cur_ResponUID==$('#CreateUID').val()}}待提交{{else}}待分配{{/if}}</span>
                    {{else AuditStatus==1}}<span class="checking1">待审核</span>
                    {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                    {{else}} <span class="assigning">审核通过</span>{{/if}}
                </div>
                <div class="fr status">奖金：<span id="span_AllMoney_${rowNum}">${Money}</span>元，已分：<span id="span_HasAllot_${rowNum}">{{if AuditStatus==0&&cur_ResponUID!=$('#CreateUID').val()}}0{{else}}${HasAllot}{{/if}}</span>元，<span id="span_UnAllot_${rowNum}" style="color:#d02525;">未分：{{if AuditStatus==0&&cur_ResponUID!=$('#CreateUID').val()}}${Money}{{else}}${Money-HasAllot}{{/if}}元</span></div>
            </div>
            <table class="allot_table mt10  ">
                <thead>
                    <tr>
                        {{if cur_AchieveType==3}}
                        <th>姓名</th>
                        <th>作者类型</th>
                        <th>排名</th>
                        <th>部门</th>
                        <th>贡献字数（万字）</th>
                        <th>奖金</th>
                        {{else}}
                        <th>成员</th>                       
                        <th>部门</th>   
                        <th>奖金</th>                    
                        {{/if}}
                    </tr>
                </thead>
                <tbody id="tb_Member_${rowNum}" autid="${Id}" rewid="${Id}" batname="${BatName}">
                    {{each(i, mem) Member_Data.retData}}                        
                            <tr un="${mem.UserNo}" uid="${mem.Id}">
                                <td class="td_memname">${mem.Name}</td>
                                {{if cur_AchieveType==3}}
                                <td>{{if mem.ULevel==0}}独著 {{else mem.ULevel==1}}主编{{else mem.ULevel==2}}参编{{else}}其他人员{{/if}}</td>
                                <td>${mem.Sort}</td>
                                <td>${mem.Major_Name}</td>
                                <td>${mem.WordNum}</td>                                
                                {{else}}
                                <td>${mem.Major_Name}</td>                                                                                
                                {{/if}}  
                                <td class="td_money"></td>   
                            </tr>
                    {{/each}}    
                </tbody>
            </table>
            <div class="clearfix mt10 Enclosure">
                <div class="status-left clearfix">
                    <label for="" class="fl">附件：</label>
                    <div class="fl">
                        <ul id="ul_ScoreFile_${rowNum}" auid="${Id}" class="clearfix file-ary allot_file"></ul>
                    </div>
                </div>
                {{if UrlDate.Type =='Check'&&AuditStatus==1}}
                <div class="reward_btn">
                    <input type="button" value="通过" onclick="AllotAudit(3,${Id},${rowNum});" class="btn" />
                    <input type="button" value="不通过" onclick="AllotAudit(2,${Id},${rowNum});" class="btnb" />
                </div>
                {{/if}} 
            </div>
        </div>
    </script>
    <%--分配历史记录--%>
    <script type="text/x-jquery-tmpl" id="li_Record">
        <li class="clearfix">
            <span class="fl">${Content} {{if Reason_Id>0}}<a href="javascript:;" onclick="OpenDetail('${EditReason}',${Reason_Id})">查看详情</a>{{/if}}</span>
            <span class="fr">${DateTimeConvert(CreateTime,"yyyy-MM-dd")}</span>
        </li>
    </script>
</head>
<body style="background: #fff;">
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <div class="checkmes none"></div>
    <div class="main" >
        <div id="div_Achieve" class="cont"></div>
    </div>
    <div class="score none"></div>
    <div class="btnwrap2 none">
        <input type="button" id="btn_Pass" value="通过" class="btn"/>
        <input type="button" id="btn_Nopass" value="不通过" class="btnb ml10"/>
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
        var cur_AchieveId = UrlDate.Id,cur_AchCreateUID="";
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);            
            var Id = UrlDate.Id;
            if (Id != undefined) {
                GetAchieveDetailById(2);                
                Get_LookPage_Document(0, Id);
            }
        });        
        function View_CheckInit(model) { //查看、审核初始化
            Get_LookPage_Document(6, model.Id, $("#ul_Certificate_6"));            
            var yesstatus = 3, nostatus = 2,yestwo_s=0,notwo_s=0;
            if (model.ComStatus >= 0 && model.ComStatus <= 3) {//信息
                yesstatus = 3, nostatus = 2; 
                if(model.GPid==2){
                    yestwo_s=3,notwo_s=2;
                    if(model.TwoAudit_Status==1){yesstatus=1;nostatus=1;}
                }
            } else{//分数
                yesstatus = 7, nostatus = 6;               
                Get_LookPage_Document(3, model.Id, $("#ul_ScoreFile"));
            }
            if(model.ComStatus>7){  //奖金               
                $(".re_reward").show();                
            }
            if (UrlDate.Type == "Check") {
                $("#btn_Pass").click(function () { Check(yesstatus,yestwo_s); });
                $("#btn_Nopass").click(function () { Check(nostatus,notwo_s); });
                $(".checkmes").hide();
                if (model.Status <= 6) {
                    $(".btnwrap2").show();
                }               
            }
            else {
                $(".checkmes").show();
                $(".btnwrap2").hide();
            }
            if (model.ComStatus > 6) { $(".re_history").show(); Get_ModifyRecordData("", model.IsMoneyAllot.indexOf('1')== -1?"0":""); }
        }       
        //绑定成员信息
        var Member_Data = [];
        function Get_RewardUserInfo(model) {
            $("#tb_Member,#tb_Info,#tb_Member1").html("");
            if (model.AchieveType == 3) {
                $(".user_book").show();
            } else {
                $(".user_mem").show();
            }
            var postData = { func: "GetTPM_UserInfo", RIId: model.Id, IsPage: false };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                data: postData,
                dataType: "json",
                success: function (json) {
                    if (json.result.errNum.toString() == "0") { 
                        Member_Data = json.result;
                        Get_RewardBatchDetailData("",cur_ResponUID==$('#CreateUID').val()?"":"0");
                        if (model.AchieveType == 3) { //教材建设类                          
                            $("#tr_Info").tmpl(json.result.retData).appendTo("#tb_info");                          
                            $("#tr_Info1").tmpl(json.result.retData).appendTo("#tb_Member1");
                            GetAchieveUser_Score(json.result.retData);
                            $("#div_score_statis").html($("#div_user_book").html());
                        } else {  //其他类型
                            $("#tr_MemEdit").tmpl(json.result.retData).appendTo("#tb_Member");
                            $("#tr_MemEdit1").tmpl(json.result.retData).appendTo("#tb_Member1");
                            GetAchieveUser_Score(json.result.retData);                           
                            $("#div_score_statis").html($("#div_user_mem").html());
                        }                        
                    }
                },
                error: function (errMsg) {
                    layer.msg(errMsg);
                }
            });
        }        
        function Check(Status,two_status) {
            var responName=cur_ResponName;
            var hisArray=[];
            if(Status==7){
                $("#tb_Member1 tr").each(function(){
                    var memname=$(this).find('td.td_memname').html(),score=$(this).find('td.td_score').html();
                    hisArray.push({
                        Type: 0, Acheive_Id: cur_AchieveId, Content: responName+"给"+memname+"分配了"+score+"分"
                         , ModifyUID: $(this).attr('un'), CreateUID: cur_ResponUID
                    });
                });
            }
            var hisrecord=hisArray.length > 0 ? JSON.stringify(hisArray) : '';
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { Func: "CheckAcheiveRewardInfoData", Status: Status,TwoAudit_Status:two_status, Id: cur_AchieveId,HisRecord: hisrecord,LoginUID:$("#CreateUID").val()},
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        parent.layer.msg('操作成功!');
                        parent.BindAchieve(1,10);
                        parent.CloseIFrameWindow();
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //奖金分配审核
        function AllotAudit(status,id,rownum){
            var responName=cur_ResponName;
            var $cur_tb=$("#tb_Member_"+rownum),rew_batchid=$cur_tb.attr('rewid');//追加奖金Id
            var batname = $cur_tb.attr('batname'); //奖金批次名称 
            var hisArray=[];
            if(status==3){
                $cur_tb.find('tr').each(function(){
                    var memname=$(this).find('td.td_memname').html(),money=$(this).find('td.td_money').html();
                    hisArray.push({
                        Type: 1, Acheive_Id: cur_AchieveId,RelationId: rew_batchid,Content:batname+ responName+"给"+memname+"分配了"+money+"元"
                         , ModifyUID: $(this).attr('un'), CreateUID: cur_ResponUID
                    });
                });
            }
            var hisrecord=hisArray.length > 0 ? JSON.stringify(hisArray) : '';
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "Check_AuditReward", Status: status,Id: id,Acheive_Id: cur_AchieveId,HisRecord: hisrecord },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        layer.msg('操作成功!');
                        //Get_RewardBatchDetailData("",cur_ResponUID==$('#CreateUID').val()?"":"0"); 
                        parent.BindAchieve(1, 10); 
                        parent.CloseIFrameWindow();
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
