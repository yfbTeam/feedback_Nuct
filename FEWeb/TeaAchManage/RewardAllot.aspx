﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RewardAllot.aspx.cs" Inherits="FEWeb.TeaAchManage.RewardAllot" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>业绩分配</title>
    <link href="../css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
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
    <script type="text/x-jquery-tmpl" id="div_item">
       <div class="clearfix allot_item">
            <div class="clearfix">
                <div class="fl status-left">
                    <label for="" style="margin-right:20px;">${BatName}</label>
                    <label for="">状态：</label>
                    {{if AuditStatus==10}}<span class="nosubmit">待分配</span>
                    {{else AuditStatus==0}}<span class="nosubmit">待提交</span>
                    {{else AuditStatus==1}}<span class="checking1">待审核</span>
                    {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                    {{else}} <span class="assigning">审核通过</span>{{/if}}
                </div>
                <div class="fr status">奖金：<span id="span_AllMoney_${rowNum}">${Money}</span>元，已分：<span id="span_HasAllot_${rowNum}">${HasAllot}</span>元，<span id="span_UnAllot_${rowNum}" style="color:#d02525;">未分：${Money-HasAllot}元</span></div>
            </div>
            <table class="allot_table mt10  ">
                <thead>
                    <tr>
                        {{if UrlDate.AchieveType==3}}
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
                <tbody id="tb_Member_${rowNum}" autid="${Id}" rewid="${Id}">
                    {{each(i, mem) Member_Data.retData}}                        
                            <tr un="${mem.UserNo}" uid="${mem.Id}">
                                <td>${mem.Name}</td>
                                {{if UrlDate.AchieveType==3}}
                                <td>{{if mem.ULevel==0}}独著 {{else mem.ULevel==1}}主编{{else mem.ULevel==2}}参编{{else}}其他人员{{/if}}</td>
                                <td>${mem.Sort}</td>
                                <td>${mem.Major_Name}</td>
                                <td>${mem.WordNum}</td>
                                <td class="td_money">{{if  AuditStatus==10||AuditStatus==0||AuditStatus==2}}<input type="number" isrequired="true" regtype="money" fl="奖金" min="0" step="0.01" onblur="Change_UserMoney(this);">{{/if}}</td>
                                {{else}}
                                 <td>${mem.Major_Name}</td>
                                 {{if UrlDate.AchieveType==5&&AuditStatus==10}}
                                   <td class="td_money"><input type="number" value="${Money}" isrequired="true" regtype="money" fl="奖金" min="0" step="0.01" onblur="Change_UserMoney(this);"></td>
                                 {{else}}
                                 <td class="td_money">{{if  AuditStatus==10||AuditStatus==0||AuditStatus==2}}<input type="number" isrequired="true" regtype="money" fl="奖金" min="0" step="0.01" onblur="Change_UserMoney(this);">{{/if}}</td>
                                 {{/if}}                                
                                
                                {{/if}}     
                            </tr>
                    {{/each}}    
                </tbody>
            </table>
            <div class="clearfix mt10 Enclosure">
                {{if  AuditStatus==10||AuditStatus==0||AuditStatus==2}}
                <div class="input_lable input_lable2">
                    <label for="" style="min-width:46px;color:#731F4F">附件：</label>
                    <div class="fl uploader_container" style="padding-left:56px;">
                        <div id="uploader_${rowNum}" auid="${Id}" class="allot_file">
                            <div class="queueList">
                                <div id="dndArea_${rowNum}" class="placeholder photo_lists">
                                    <div id="filePicker_${rowNum}"></div>
                                    <ul class="filelist clearfix"></ul>
                                </div>
                            </div>
                            <div class="statusBar" style="display: none;">
                                <div class="progress">
                                    <span class="text">0%</span>
                                    <span class="percentage"></span>
                                </div>
                                <div class="info"></div>                                
                            </div>
                        </div>
                    </div>
                </div>
                    {{else}}
                      <div class="status-left">
                        <label for="" class="fl">附件：</label>
                        <div class="fl">
                            <ul id="ul_ScoreFile_${rowNum}" auid="${Id}" class="clearfix file-ary allot_file"></ul>
                        </div>
                    </div>
                    {{/if}} 
                 {{if AuditStatus==10||AuditStatus==0||AuditStatus==2}}
                <div class="reward_btn">
                    <input type="button" value="保存" onclick="SaveAllot(0,${rowNum});" class="btn" />
                    <input type="button" value="提交" onclick="SaveAllot(1,${rowNum});" class="btn" />
                </div>
                {{/if}} 
            </div>
        </div>
    </script>   
</head>
<body style="background: #fff;">
     <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" id="hid_UploadFunc" value="Upload_AuditReward"/>
    <div class="main" id="RewardAllot">
        <h2 class="cont_title"><span>基本信息</span></h2>
        <div class="area_form clearfix">
            <div class="col-xs-6" v-if="Info.AchieveType!=3&&Info.GPid!=4" v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖项目名称：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Name" >{{Info.AchiveName}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6 book" v-if="Info.AchieveType==3"v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        书名：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="BookName" >{{Info.BookName}}</span> 
                       <input type="hidden" id="BookId" name="BookId" v-model="Info.BookId"/>
                    </div>
                </div>
            </div>
           <div class="col-xs-6 book" v-if="Info.AchieveType==3"  v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        书号：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="ISBN">{{Info.ISBN}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6"  v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        奖励项目：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Gid">{{Info.GidName}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6"  v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖级别：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Lid" >{{Info.LevelName}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6"  v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        奖励等级：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Rid" >{{Info.RewadName}}</span>
                    </div>
                </div>
            </div>
           <div class="col-xs-6" v-if="Info.AchieveType==2" v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        排名：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Sort">{{Info.RankName}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6"  v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        获奖年度：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="Year" >{{Info.Year}}</span>
                    </div>
                </div>
            </div>
            <div class="col-xs-6" v-if="Info.AchieveType!=3" v-cloak>
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label" v-if="Info.AchieveType==5">
                        获奖教师：
                    </div>
                    <div class="col-xs-5 msg_label" v-else>
                        负责人：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="ResponsMan" >{{Info.ResponsMan}}</span>
                    </div>
                </div>
            </div>
           <div class="col-xs-6">
                <div class="row msg_item">
                    <div class="col-xs-5 msg_label">
                        负责单位：
                    </div>
                    <div class="col-xs-7 msg_control">
                       <span id="DepartMent" >{{Info.Major_Name}}</span>
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
        <h2 class="cont_title"><span>奖金分配</span></h2>
        <div id="div_MoneyInfo" class="area_form clearfix"> </div>        
    </div>
     <script src="../js/vue.min.js"></script>
    <script src="../Scripts/Common.js"></script>
    <script src="../scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../Scripts/choosen/prism.js"></script>
    <script src="../Scripts/Webuploader/dist/webuploader.js"></script>
    <link href="../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="upload_batchfile.js"></script>
    <script src="BaseUse.js"></script>   
    <script>
        var UrlDate = new GetUrlDate();
        var cur_AchieveId = UrlDate.AcheiveId;
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            $("#AchieveType").val(UrlDate.AchieveType);                                           
        });        
        var RewardAllot = new Vue({
            el: '#RewardAllot',
            data: {
                Info: {},
            },
            methods: {
                GetDateById: function () {
                    var that = this;
                    $.ajax({
                        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                        type: "post",
                        dataType: "json",
                        data: { "Func": "GetAcheiveRewardInfoData", "IsPage": "false", Id: cur_AchieveId},
                        success: function (json) {
                            if (json.result.errMsg == "success") {
                                that.Info = json.result.retData[0];
                                cur_AchieveType = that.Info.AchieveType;
                                cur_ResponUID = that.Info.ResponsMan;
                                Get_RewardUserInfo();  
                                Get_LookPage_Document(6, cur_AchieveId, $("#ul_Certificate_6"));
                            }
                        },
                        error: function () {
                            //接口错误时需要执行的
                        }
                    })
                },

            },
            mounted: function () {
                var that = this;
                that.GetDateById();
            }
        });
        //绑定成员信息
        var Member_Data = [];
        function Get_RewardUserInfo() {
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                data: { func: "GetTPM_UserInfo", RIId: cur_AchieveId, IsPage: false },
                dataType: "json",
                success: function (json) {
                    if (json.result.errNum.toString() == "0") {
                        Member_Data = json.result;
                    }
                    Get_RewardBatchDetailData();       
                },
                error: function (errMsg) {
                    layer.msg(errMsg);
                }
            });
        }        
        function SaveAllot(status,rownum){
            if (Number($('#span_AllMoney_'+rownum).html()) < Number($('#span_HasAllot_'+rownum).html())) {
                layer.msg("已分配奖金不能大于总奖金！");
                return;
            }
            if (status == 1) {
                var valid_flag = validateForm($('#tb_Member_'+rownum+' input[type="number"]'));
                if (valid_flag != "0")
                {
                    return false;
                }
                layer.confirm('确认提交吗？提交后将不能进行修改', {
                    btn: ['确定', '取消'], //按钮
                    title: '操作'
                }, function (index) {
                    LastSave(status,rownum);
                }, function () { });
            } else {
                LastSave(status,rownum);
            } 
        }
        function LastSave(status,rownum) {
            var $cur_tb=$("#tb_Member_"+rownum),upfileid="#uploader_"+rownum;
            var rew_batchid=$cur_tb.attr('rewid'); //追加奖金Id
            var auditid=$cur_tb.attr('autid'); //审核Id           
            var object = { Func: "Oper_AuditAllotReward", BatchDetail_Id: auditid, Status: status, CreateUID: loginUser.UniqueNo };
            var allotArray=[];
            $cur_tb.find('tr').each(function(){
                allotArray.push({RewardUser_Id:$(this).attr('uid'),AllotMoney:$(this).find('.td_money input[type=number]').val(),CreateUID:loginUser.UniqueNo});
            });
            object.AllotUser = allotArray.length > 0 ? JSON.stringify(allotArray) : '';
            var add_path = Get_AddFile(4,upfileid);
            object.Add_Path = add_path.length > 0 ? JSON.stringify(add_path) : "";           
            object.Edit_PathId = Get_EditFileId("#uploader_"+rownum); 
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: object,
                success: function (json) {
                    if (json.result.errNum == 0) {
                        parent.layer.msg('操作成功!');
                        Del_Document(upfileid);                       
                        parent.BindData(1, 10);
                        parent.CloseIFrameWindow();
                    } else if (json.result.errNum == -1) {

                    }
                },
                error: function (errMsg) {
                    //接口错误时需要执行的
                    alert(errMsg);
                }
            });
        }
    </script>
</body>
</html>
