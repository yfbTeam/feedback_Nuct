<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminAchieveEdit.aspx.cs" Inherits="FEWeb.TeaAchManage.AdminAchieveEdit" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>业绩查看审核</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .area_form {
            padding: 0px 0px 20px 0px;
        }

        .file-ary .title1 {
            float: left;
            line-height: 30px;
        }

        .file-ary .file-panel {
            float: left;
            margin-left: 10px;
            cursor: pointer;
        }
    </style>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit">
        {{each(i, mem) Member_Data.retData}}  
        <tr id="tr_mem_${mem.Id}" class="memedit" un="${mem.UserNo}">
            {{if $("#AchieveType").val()=="3"}}             
                    <td>${mem.Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
            <td class="td_score">{{if ULevel==3}}0{{else}}${Num_Fixed(mem.UnitScore* mem.WordNum)}{{/if}}</td>
            {{else}}          
                <td>{{if $("#AchieveType").val()=="2"}}
                        {{if i>4}}<input type="checkbox" name="ck_trsub" value="${mem.UserNo}" onclick="CheckSub(this);" />{{/if}}
                    {{else}}
                        {{if i!=0}}<input type="checkbox" name="ck_trsub" value="${mem.UserNo}" onclick="CheckSub(this);" />{{/if}}
                    {{/if}}
                </td>
            <td class="td_memname">${mem.Name}</td>
            <td>
                <input type="number" name="score" value="${mem.Score}" oldsc="${mem.Score}" isrequired="true" regtype="money" fl="分数" min="0" step="0.01" onblur="ChangeRankScore(this);"/></td>
            <td>${mem.Major_Name}</td>
            <td>${DateTimeConvert(mem.CreateTime,"yyyy-MM-dd")}</td>
            {{/if}}
        </tr>
        {{/each}}  
    </script>
    <%--成员信息(新添加的)--%>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr class="memadd" un="${UniqueNo}">
            <td>
                <input type='checkbox' value="${UniqueNo}" name="ck_trsub" onclick="CheckSub(this);" /></td>
            <td class="td_memname">${Name}</td>
            <td>
                <input type="number" name="score" value="" isrequired="true" regtype="money" fl="分数" min="0" step="0.01" onblur="ChangeRankScore(this);"></td>
            <td>${loginUser.Name}</td>
            <td>${DateTimeConvert(new Date(),"yyyy-MM-dd",false)}</td>
        </tr>
    </script>
    <%--分配历史记录--%>
    <script type="text/x-jquery-tmpl" id="li_Record">
        <li class="clearfix">
            <span class="fl">${Content} {{if Reason_Id>0}}<a href="javascript:;" onclick="OpenDetail('${EditReason}',${Reason_Id})">查看详情</a>{{/if}}</span>
            <span class="fr">${DateTimeConvert(CreateTime,"yyyy-MM-dd")}</span>
        </li>
    </script>
    <script type="text/x-jquery-tmpl" id="div_item">
        {{if AuditStatus==3}}
       <div class="clearfix allot_item">
           <div class="clearfix">
               <div class="fl status-left">
                   <label for="" style="margin-right: 20px;">第${rowNum}批奖金</label>
                   <label for="">状态：</label>
                   {{if AuditStatus==10||AuditStatus==0}}<span class="nosubmit">待分配</span>
                   {{else AuditStatus==1}}<span class="checking1">待审核</span>
                   {{else AuditStatus==2}}<span class="nocheck">审核不通过</span>
                   {{else}} <span class="assigning">审核通过</span>{{/if}}
               </div>
               <div class="fr status">奖金：<span id="span_AllMoney_${rowNum}">${Money}</span>万，已分：<span id="span_HasAllot_${rowNum}">{{if AuditStatus==10||AuditStatus==0}}0{{else}}${HasAllot}{{/if}}</span>万</div>
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
                       <th>奖金</th>
                       <th>部门</th>
                       <th>录入日期</th>
                       {{/if}}
                   </tr>
               </thead>
               <tbody id="tb_Member_${rowNum}" autid="${AuditId}" rewid="${Id}">
                   {{each(i, mem) Member_Data.retData}}                        
                            <tr un="${mem.UserNo}" uid="${mem.Id}">
                                <td class="td_memname">${mem.Name}</td>
                                {{if UrlDate.AchieveType==3}}
                                <td>{{if mem.ULevel==0}}独著 {{else mem.ULevel==1}}主编{{else mem.ULevel==2}}参编{{else}}其他人员{{/if}}</td>
                                <td>${mem.Sort}</td>
                                <td>${mem.Major_Name}</td>
                                <td>${mem.WordNum}</td>
                                <td class="td_money">
                                    <input type="number" isrequired="true" regtype="money" oldre="0" fl="奖金" min="0" step="0.01" onblur="Change_UserMoney(this);"></td>
                                {{else}}
                                <td class="td_money">
                                    <input type="number" isrequired="true" regtype="money" oldre="0" fl="奖金" min="0" step="0.01" onblur="Change_UserMoney(this);"></td>
                                <td>${mem.Major_Name}</td>
                                <td>${DateTimeConvert(mem.CreateTime,"yyyy-MM-dd")}</td>
                                {{/if}}     
                            </tr>
                   {{/each}}    
               </tbody>
           </table>
           <div class="clearfix mt10 Enclosure">
               <div class="status-left">
                   <label for="" class="fl">附件：</label>
                   <div class="fl">
                       <ul id="ul_ScoreFile_${rowNum}" auid="${AuditId}" class="clearfix file-ary allot_file"></ul>
                   </div>
               </div>
           </div>
       </div>
        {{/if}}
    </script>
</head>
<body style="background: #fff;">
    <input type="hidden" name="AchieveType" id="AchieveType" value="" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" id="hid_UploadFunc" value="Upload_AcheiveReward" />
    <div class="main" id="RewardAllot">
        <h2 class="cont_title"><span>基本信息</span></h2>
        <div class="area_form clearfix" style="min-height: 165px;">
            <div class="input_lable fl" v-if="Info.AchieveType==1||Info.AchieveType==2" v-cloak>
                <label for="">获奖项目名称：</label>
                <span id="Name">{{Info.AchiveName}}</span>
            </div>
            <div class="input_lable book fl" v-if="Info.AchieveType==3" v-cloak>
                <label for="">书名：</label>
                <span id="BookName">{{Info.BookName}}</span>
                <input type="hidden" id="BookId" name="BookId" v-model="Info.BookId" />
            </div>
            <div class="input_lable book fl" v-if="Info.AchieveType==3" v-cloak>
                <label for="">书号：</label>
                <span id="ISBN">{{Info.ISBN}}</span>
            </div>
            <div class="input_lable fl" v-cloak>
                <label for="">奖励项目：</label>
                <span id="Gid">{{Info.GidName}}</span>
            </div>
            <div class="input_lable fl" v-cloak>
                <label for="">获奖级别：</label>
                <span id="Lid">{{Info.LevelName}}</span>
            </div>
            <div class="input_lable fl" v-cloak>
                <label for="">奖励等级：</label>
                <span id="Rid">{{Info.RewadName}}</span>
            </div>
            <div class="input_lable fl" v-if="Info.AchieveType==2" v-cloak>
                <label for="">排名：</label>
                <span id="Sort">{{Info.RankName}}</span>
            </div>
            <div class="input_lable fl" v-cloak>
                <label for="">获奖年度：</label>
                <span id="Year">{{Info.Year}}</span>
            </div>
            <div class="input_lable fl" v-if="Info.AchieveType!=3" v-cloak>
                <label for="" v-if="Info.AchieveType==5">获奖教师：</label>
                <label for="" v-else>负责人：</label>
                <span id="ResponsMan">{{Info.ResponsMan}}</span>
            </div>
            <div class="input_lable fl" v-cloak>
                <label for="">负责单位：</label>
                <span id="DepartMent">{{Info.Major_Name}}</span>
            </div>
        </div>
        <div v-show="Info.Status>6" v-cloak>
            <h2 class="cont_title"><span>分数分配</span></h2>
            <div class="area_form clearfix">
                <div class="clearfix">
                    <input type="button" v-if="Info.AchieveType==1||Info.AchieveType==2" name="memberbtn" value="添加" class="btn ml" id="AddBtn" onclick="javascript: OpenIFrameWindow('添加成员', 'AddAchMember.aspx', '900px', '650px');" />
                    <input type="button" v-if="Info.AchieveType==1||Info.AchieveType==2" name="memberbtn" value="删除" class="btn ml10" onclick="Del_HtmlMember(1);" />
                    <span class="fr status" v-if="Info.AchieveType==3">总贡献字数：<span id="span_Words">0</span>万字，总分：<span id="span_BookScore">0</span>分</span>
                    <span class="fr status" v-else>总分：<span id="span_AllScore"></span>分，已分：<span id="span_CurScore"></span>分</span>
                </div>
                <table class="allot_table mt10  ">
                    <thead>
                        <tr v-if="Info.AchieveType==3">
                            <th>姓名</th>
                            <th>作者类型</th>
                            <th>排名</th>
                            <th>部门</th>
                            <th>贡献字数（万字）</th>
                            <th>分数</th>
                        </tr>
                        <tr v-else>
                            <th width="16px">
                                <input type="checkbox" name="ck_tball" onclick="CheckAll(this)" /></th>
                            <th>成员</th>
                            <th>分数</th>
                            <th>部门</th>
                            <th>录入日期</th>
                        </tr>
                    </thead>
                    <tbody id="tb_Member"></tbody>
                </table>
                <div class="clearfix mt10 Enclosure">
                    <div class="status-left">
                        <label for="" class="fl">附件：</label>
                        <div class="fl">
                            <ul id="ul_ScoreFile" class="clearfix file-ary"></ul>
                        </div>
                    </div>
                </div>
                <div class="EditResult">
                    <textarea id="txt_Reasonscore" class="textarea" placeholder="请输入修改原因" isrequired="true" fl="修改原因"></textarea>
                    <div class="input_lable input_lable2">
                        <label for="" style="min-width: 46px;">附件：</label>
                        <div class="fl uploader_container" style="padding-left: 55px;">
                            <div id="uploader">
                                <div class="queueList">
                                    <div id="dndArea" class="placeholder photo_lists">
                                        <div id="filePicker"></div>
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
                    <div class="reward_btn">
                        <input type="button" value="提交" class="btn" onclick="Save_Score();" />
                    </div>
                </div>
            </div>
        </div>
        <h2 class="cont_title none RewardReason"><span>奖金分配</span></h2>
        <div id="div_MoneyInfo" class="area_form clearfix"></div>
        <div class="EditResult none RewardReason">
            <textarea id="txt_Reasonreward" class="textarea" placeholder="请输入修改原因" isrequired="true" fl="修改原因"></textarea>
            <div class="input_lable input_lable2">
                <label for="" style="min-width: 46px;">附件：</label>
                <div class="fl uploader_container" style="padding-left: 55px;">
                    <div id="uploader_reward" class="allot_file">
                        <div class="queueList">
                            <div id="dndArea_reward" class="placeholder photo_lists">
                                <div id="filePicker_reward"></div>
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
            <div class="reward_btn">
                <input type="button" value="提交" class="btn" onclick="Save_Reward();" />
            </div>
        </div>
        <h2 class="cont_title re_reward none RewardReason"><span>分配历史</span></h2>
        <div class="area_form re_reward none RewardReason">
            <ul class="history" id="ul_Record"></ul>
        </div>
    </div>
    <script src="../js/vue.min.js"></script>
    <script src="../Scripts/Common.js"></script>
    <script src="../scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/Webuploader/dist/webuploader.js"></script>
    <link href="../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="./upload_batchfile.js"></script>
    <script src="./BaseUse.js"></script>
    <script type="text/javascript">
        var UrlDate = new GetUrlDate();
        var cur_AchieveId = UrlDate.AcheiveId;
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            BindFile_Plugin();
            Get_LookPage_Document(3, cur_AchieveId, $("#ul_ScoreFile"));
        });
        //基本信息
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
                        data: { "Func": "GetAcheiveRewardInfoData", "IsPage": "false", Id: cur_AchieveId },
                        success: function (json) {
                            if (json.result.errMsg == "success") {
                                that.Info = json.result.retData[0];
                                $('#span_AllScore').html(that.Info.TotalScore);
                                cur_ResponUID = that.Info.ResponsMan;
                                cur_AchieveType = that.Info.AchieveType;
                                $("#AchieveType").val(that.Info.AchieveType);
                                achie_Score = Num_Fixed(that.Info.TotalScore);
                                Get_RewardUserInfo(that.Info);
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
        function Get_RewardUserInfo(ach_model) {
            $("#tb_Member").empty();
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                data: { func: "GetTPM_UserInfo", RIId: cur_AchieveId, IsPage: false },
                dataType: "json",
                success: function (json) {
                    if (json.result.errNum.toString() == "0") {
                        Member_Data = json.result;
                        $("#tr_MemEdit").tmpl(json.result).appendTo("#tb_Member");
                        GetAchieveUser_Score(json.result.retData);
                    }
                    if (ach_model.ComStatus > 7){Get_RewardBatchData($(".RewardReason"));}                    
                },
                error: function (errMsg) {
                    layer.msg(errMsg);
                }
            });
        }
        /***********************************************分数开始*************************************************/        
        //保存分数
        function Save_Score() {
            var object = { Func: "Add_AcheiveAllot", Id: cur_AchieveId, EditReason: $("#txt_Reasonscore").val().trim(), CreateUID: loginUser.UniqueNo };
            var valid_flag = validateForm($('#tb_Member tr:visible input[type="number"],#txt_Reasonscore'));
            if (valid_flag != "0") {
                return false;
            }
            var add_path = Get_AddFile(5);
            if (add_path.length <= 0) {
                layer.msg("请上传附件!");
                return;
            }
            object.Reason_Path = add_path.length > 0 ? JSON.stringify(add_path) : "";
            if (Number($('#span_AllScore').html()) < Number(GetCur_RankScore())) {
                layer.msg("已分配分数不能大于总分！");
                return;
            }
            var addMemObj = Get_AddMember(), editMemObj = Get_EditMember();
            var addArray = addMemObj.addarray;
            object.MemberStr = addArray.length > 0 ? JSON.stringify(addArray) : '';
            var recordArray = addMemObj.edithis;
            var editArray = editMemObj.editarray;
            object.MemberEdit = editArray.length > 0 ? JSON.stringify(editArray) : '';
            recordArray = recordArray.concat(editMemObj.edithis);
            if (recordArray.length <= 0) {
                layer.msg("没有修改内容!");
                return;
            }
            object.ResonRecord = JSON.stringify(recordArray);
            var warnArray = [];
            $.each(recordArray, function (i, n) {
                warnArray.push(n.Content);
            });
            layer.confirm(warnArray.join('、'), {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function (index) {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                    type: "post",
                    dataType: "json",
                    data: object,
                    success: function (json) {
                        if (json.result.errNum == 0) {
                            layer.msg('操作成功!');
                            Get_RewardUserInfo();
                        } else if (json.result.errNum == -1) { }
                    },
                    error: function (errMsg) { alert(errMsg); }
                });
            }, function () { });
        }
        function Get_AddMember() {
            var addArray = [], edithis = [];
            var add_tr = $("#tb_Member tr");
            $(add_tr).each(function (i, n) {
                if ($(this).hasClass('memadd')) {
                    var userno = $(this).attr('un'), score = Num_Fixed($(this).find('input[type=number][name=score]').val());
                    addArray.push({ UserNo: userno, Score: score, Sort: i + 1, CreateUID: loginUser.UniqueNo });
                    var oldtr = $("#tb_Member tr.memedit[un='" + userno + "']");
                    var content = loginUser.Name + '添加新成员' + $(this).find('td.td_memname').html() + ",并分配" + score + "分";
                    if (oldtr.length > 0) {
                        content = loginUser.Name + '将' + $(this).find('td.td_memname').html() + oldtr.find('input[type=number][name=score]').attr('oldsc') + "分" + "改为" + score + "分";
                    }
                    edithis.push({
                        Type: 0, Acheive_Id: cur_AchieveId, RelationId: 0, Content: content
                         , ModifyUID: userno, CreateUID: loginUser.UniqueNo
                    });
                }
            });
            return { addarray: addArray, edithis: edithis };
        }
        function Get_EditMember() {
            var editArray = [], edithis = [];
            $("#tb_Member tr").each(function (i, n) {
                if ($(this).hasClass('memedit')) {
                    var id = n.id.replace('tr_mem_', ''), userno = $(this).attr('un')
                      , score = Num_Fixed($(this).find('input[type=number][name=score]').val())
                      , oldscore = Num_Fixed($(this).find('input[type=number][name=score]').attr('oldsc'));
                    if ($(this).is(":visible")) {
                        editArray.push({ Id: id, Score: score, Sort: i + 1, EditUID: loginUser.UniqueNo });
                        if (Number(score) != Number(oldscore)) { //修改的
                            edithis.push({
                                Type: 0, Acheive_Id: cur_AchieveId, RelationId: 0, Content: loginUser.Name + '将' + $(this).find('td.td_memname').html() + oldscore + "分" + "改为" + score + "分"
                                              , ModifyUID: userno, CreateUID: loginUser.UniqueNo
                            });
                        }
                    } else { //删除的
                        if ($("#tb_Member tr.memadd[un='" + userno + "']").length == 0) {
                            edithis.push({
                                Type: 0, Acheive_Id: cur_AchieveId, Content: loginUser.Name + '删除成员' + $(this).find('td.td_memname').html()
                                              , ModifyUID: userno, CreateUID: loginUser.UniqueNo
                            });
                        }
                    }
                }
            });
            return { editarray: editArray, edithis: edithis };
        }
        /***********************************************分数结束*************************************************/
        /***********************************************奖金开始*************************************************/
        function Save_Reward() {
            var valid_flag = validateForm($('#div_MoneyInfo tbody input[type="number"]'));
            if (valid_flag != "0") {
                return false;
            }
            if (Number($('#span_AllMoney_' + rownum).html()) < Number($('#span_HasAllot_' + rownum).html())) {
                layer.msg("已分配奖金不能大于总奖金！");
                return;
            }
            var object = { Func: "Admin_EditAllotReward", CreateUID: loginUser.UniqueNo, EditReason: $("#txt_Reasonreward").val().trim() };
            var add_path = Get_AddFile(5, '#uploader_reward');
            if (add_path.length <= 0) {
                layer.msg("请上传附件!");
                return;
            }
            object.Reason_Path = add_path.length > 0 ? JSON.stringify(add_path) : "";
            var rewardObj = Get_RewardMember();
            var allArray = rewardObj.editarray, recordArray = rewardObj.edithis;
            if (recordArray.length <= 0) {
                layer.msg("没有修改内容!");
                return;
            }
            object.ResonRecord = JSON.stringify(recordArray);
            var warnArray = [];
            $.each(recordArray, function (i, n) {
                warnArray.push(n.Content);
            });
            layer.confirm(warnArray.join('、'), {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function (index) {
                object.AllotUser = allArray.length > 0 ? JSON.stringify(allArray) : '';
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                    type: "post",
                    dataType: "json",
                    data: object,
                    success: function (json) {
                        if (json.result.errNum == 0) {
                            layer.msg('操作成功!');
                            Get_RewardUserInfo();
                        } else if (json.result.errNum == -1) { }
                    },
                    error: function (errMsg) { alert(errMsg); }
                });
            }, function () { });
        }
        function Get_RewardMember() {
            var editArray = [], edithis = [];
            $('#div_MoneyInfo tbody').each(function (i, n) {
                var $cur_tb = $("#" + n.id);
                var rownum = n.id.replace('tb_Member_', '');
                var rew_batchid = $cur_tb.attr('rewid'); //追加奖金Id                
                var auditid = $cur_tb.attr('autid'); //审核Id  
                var subarray = [];
                $cur_tb.find('tr').each(function () {
                    var userno = $(this).attr('un'), money = Num_Fixed($(this).find('.td_money input[type=number]').val())
                      , oldmoney = Num_Fixed($(this).find('.td_money input[type=number]').attr('oldre'));
                    subarray.push({ RewardUser_Id: $(this).attr('uid'), AllotMoney: money, CreateUID: loginUser.UniqueNo });
                    if (Number(money) != Number(oldmoney)) { //修改的
                        edithis.push({
                            Type: 1, Acheive_Id: cur_AchieveId, RelationId: rew_batchid, Content: "第" + rownum + "批奖金" + loginUser.Name + '将' + $(this).find('td.td_memname').html() + oldmoney + "万" + "改为" + money + "万"
                                          , ModifyUID: userno, CreateUID: loginUser.UniqueNo
                        });
                    }
                });
                editArray.push({ Id: $(this).attr('uid'), AllotInfo: subarray, EditUID: loginUser.UniqueNo });
            });
            return { editarray: editArray, edithis: edithis };
        }
        /***********************************************奖金结束*************************************************/
    </script>
</body>
</html>
