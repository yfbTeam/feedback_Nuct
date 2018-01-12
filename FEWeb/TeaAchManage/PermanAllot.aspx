<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PermanAllot.aspx.cs" Inherits="FEWeb.TeaAchManage.PermanAllot" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>业绩分配</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link href="../css/layout.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .area_form {
            padding: 0px 0px 20px 0px;
        }
    </style>
     <%--业绩信息--%>
    <script type="text/x-jquery-tmpl" id="div_AchInfo">
        <h2 class="cont_title"><span>基本信息</span></h2>
        <input type="hidden" id="hid_Status" value="${Status}"/>
        <div class="area_form clearfix">
            {{if AchieveType==1||AchieveType==2}}             
                <div class="input_lable fl">
                    <label for="">获奖项目名称：</label>
                    <span>${AchiveName}</span>
                </div>
            {{/if}}
                {{if  AchieveType==3}}
                <div class="input_lable book fl">
                    <label for="">书名：</label>
                    <span>${BookName}</span>
                    <input type="hidden" id="BookId" name="BookId" value="${BookId}" />
                </div>
            <div class="input_lable book fl">
                <label for="">书号：</label>
                <span>${ISBN}</span>
            </div>
            {{/if}}
                <div class="input_lable fl">
                    <label for="">奖励项目：</label>
                    <span>${GidName}</span>
                </div>
            <div class="input_lable fl">
                <label for="">获奖级别：</label>
                <span>${LevelName}</span>
            </div>
            <div class="input_lable fl">
                <label for="">奖励等级：</label>
                <span>${RewadName}</span>
            </div>
            {{if AchieveType==2}}
                <div class="input_lable fl">
                    <label for="">排名：</label>
                    <span>${RankName}</span>
                </div>
            {{/if}}
                <div class="input_lable fl">
                    <label for="">获奖年度：</label>
                    <span>${Year}</span>
                </div>
             {{if AchieveType!=3}}
                <div class="input_lable fl">
                    <label for="">{{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}：</label>
                    <span>${ResponsName}</span>
                </div>
            {{/if}}
            <div class="input_lable fl">
                <label for="">负责单位：</label>
                <span>${Major_Name}</span>
            </div>
        </div>
        <h2 class="cont_title"><span>分数分配</span></h2>
        <div class="area_form clearfix">
                <div class="clearfix"> 
                    {{if AchieveType==1||AchieveType==2}}                  
                    <input type="button" name="memberbtn" value="添加" class="btn ml" id="AddBtn" onclick="javascript: OpenIFrameWindow('添加成员','AddAchMember.aspx', '80%', '70%');"/>
                    <input type="button" name="memberbtn" value="删除" class="btn ml10" onclick="Del_HtmlMember();"/>
                    {{/if}}
                    {{if AchieveType==3}}
                    <span class="fr status">总贡献字数：<span id="span_Words">0</span>万字，总分：<span id="span_BookScore">0</span>分</span>
                   {{else}}<span class="fr status">总分：<span id="span_AllScore">${TotalScore}</span>分，已分：<span id="span_CurScore">0</span>分</span>{{/if}}
                </div>
                <table class="allot_table mt10  ">
                    <thead>
                        <tr>
                            {{if AchieveType==3}}
                            <th>姓名</th>
                            <th>作者类型</th>
                            <th>排名</th>
                            <th>部门</th>
                            <th>贡献字数（万字）</th>
                            <th>分数</th>  
                            {{else}}
                            <th width="16px"><input type="checkbox" name="ck_tball" onclick="CheckAll(this)"/></th>
                            <th>成员</th>                                                  
                            <th>部门</th>
                            <th>分数</th>   
                            {{/if}}                                          
                        </tr>
                    </thead>
                    <tbody id="tb_Member"></tbody>
                </table>
                <div class="input_lable input_lable2">
                        <label for="" style="min-width:46px;">附件：</label>
                        <div class="fl uploader_container">
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
            </div>
    </script>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit">
        {{each(i, mem) AcheiveMember_data.retData}}  
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
                          {{if i>4}}<input type="checkbox" name="ck_trsub" value="${mem.UserNo}" onclick="CheckSub(this);"/>{{/if}}
                        {{else}}
                          {{if i!=0}}<input type="checkbox" name="ck_trsub" value="${mem.UserNo}" onclick="CheckSub(this);"/>{{/if}}
                        {{/if}}
                    </td>
                    <td>${mem.Name}</td>
                    <td>${mem.Major_Name}</td>
                    {{if $("#AchieveType").val()=="5"&&$('#hid_Status').val()=='3'}}
                       <td><input type="number" name="score" value="${UnitScore}" isrequired="true" regtype="money" fl="分数" min="0" step="0.01" onblur="ChangeRankScore(this);"/></td>
                    {{else}}
                      <td><input type="number" name="score" value="${mem.Score}" isrequired="true" regtype="money" fl="分数" min="0" step="0.01" onblur="ChangeRankScore(this);"/></td>
                    {{/if}}
                {{/if}}
            </tr>
        {{/each}}  
    </script>
     <%--成员信息(新添加的)--%>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr class="memadd" un="${UniqueNo}">
            <td><input type='checkbox' value="${UniqueNo}" name="ck_trsub" onclick="CheckSub(this);" /></td>
            <td>${Name}</td>           
            <td>${MajorName}</td>
            <td><input type="number" name="score" value="" min="0" isrequired="true" regtype="money" fl="分数" step="0.01" onblur="ChangeRankScore(this);"></td>          
        </tr>
    </script>
</head>
<body style="background: #fff;">
    <input type="hidden" name="AchieveType" id="AchieveType" value="" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" id="hid_UploadFunc" value="Upload_AcheiveReward"/>
    <div class="main" >
        <div id="div_Achieve" class="cont"></div>
    </div>
    <div class="btnwrap2">
        <input type="button" value="保存" onclick="submit(4)" class="btn" />
        <input type="button" value="提交" class="btn ml10" onclick="submit(5)"/>
    </div>
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
    <script type="text/javascript">
        var UrlDate = new GetUrlDate();
        var cur_AchieveId = UrlDate.AcheiveId;
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            $("#AchieveType").val(UrlDate.AchieveType);            
            GetAchieveDetailById();
            BindFile_Plugin();
            Get_TPM_AcheiveMember(cur_AchieveId);            
            Get_Sys_Document(3, cur_AchieveId);
        });              
        var object = { Func: "Add_AcheiveAllot", Id: cur_AchieveId };
        function submit(status) {
            var add_path = Get_AddFile(3);
            object.Add_Path = add_path.length > 0 ? JSON.stringify(add_path) : "";
            if (Number($('#span_AllScore').html()) < Number(GetCur_RankScore())) {
                layer.msg("已分配分数不能大于总分！");
                return;
            }
            if (status == 5) {
                if ($("#uploader .filelist li").length <= 0) {
                    layer.msg("请上传附件!");
                    return;
                }
                var valid_flag = validateForm($('#tb_Member tr:visible input[type="number"]'));
                if (valid_flag != "0") {
                    return false;
                }
                layer.confirm('确认提交吗？提交后将不能进行修改', {
                    btn: ['确定', '取消'], //按钮
                    title: '操作'
                }, function (index) {
                    LastSave(status);
                }, function () { });
            } else {
                LastSave(status);
            }
        }
        function LastSave(status) {            
            object.Status = status;
            var addArray = Get_AddMember();
            object.MemberStr = addArray.length > 0 ? JSON.stringify(addArray) : '';
            var editArray = Get_EditMember();
            object.MemberEdit = editArray.length > 0 ? JSON.stringify(editArray) : '';            
            object.Edit_PathId = Get_EditFileId();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: object,
                success: function (json) {
                    if (json.result.errNum == 0) {
                        parent.layer.msg('操作成功!');
                        Del_Document();
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
        function Get_AddMember() {
            var addArray = [];
            var add_tr = $("#tb_Member tr");
            $(add_tr).each(function (i, n) {
                if ($(this).hasClass('memadd')) {
                    var sub_m = new Object();
                    sub_m.UserNo = $(this).attr('un');
                    sub_m.Score =$(this).find('input[type=number][name=score]').val();                   
                    sub_m.Sort = i + 1;
                    sub_m.CreateUID = loginUser.UniqueNo;
                    addArray.push(sub_m);
                }
            });
            return addArray;
        }
        function Get_EditMember() {
            var editArray = [];
            $("#tb_Member tr").each(function (i, n) {
                if ($(this).hasClass('memedit')) {
                    var sub_e = new Object();
                    sub_e.Id = n.id.replace('tr_mem_', '');
                    sub_e.Score = cur_AchieveType == "3" ? $(this).find('td.td_score').html() : $(this).find('input[type=number][name=score]').val();
                    sub_e.Sort = i + 1;
                    sub_e.EditUID = loginUser.UniqueNo;
                    editArray.push(sub_e);
                }
            });
            return editArray;
        }
        function Check(Status) {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "CheckTPM_BookStory", "Status": Status, Id: cur_AchieveId },
                success: function (json) {
                    if (json.result.errMsg == "success") {
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
