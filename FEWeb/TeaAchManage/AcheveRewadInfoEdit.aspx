<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AcheveRewadInfoEdit.aspx.cs" Inherits="FEWeb.TeaAchManage.AcheveRewadInfoEdit" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>修改教师业绩</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/x-jquery-tmpl" id="tr_Info">
        <tr un="${UserNo}">
            <td>${Name}</td>
            <td>{{if ULevel==0}}独著 {{else ULevel==1}}主编{{else ULevel==2}}参编{{else}}其他人员{{/if}}</td>           
            <td>${Sort}</td>
            <td>${Major_Name}</td>
            <td>${WordNum}</td>
        </tr>
    </script>
    <%--业绩信息--%>
    <script type="text/x-jquery-tmpl" id="div_AchInfo">
                <h2 class="cont_title"><span>获奖文件信息</span></h2>
                <div class="area_form clearfix">
                    <div class="input_lable fl">
                        <label for="">发文号：</label>
                        <input type="text" isrequired="true" fl="发文号" name="FileEdionNo" id="FileEdionNo" value="${FileEdionNo}" class="text" />
                    </div>
                    <div class="input_lable fl">
                        <label for="">文件名称：</label>
                        <input type="text" isrequired="true" fl="文件名称" name="FileNames" id="FileNames" value="${FileNames}" class="text" />
                    </div>
                    <div class="input_lable fl">
                        <label for="">认定机构：</label>
                        <input type="text" isrequired="true" fl="认定机构" name="DefindDepart" id="DefindDepart" value="${DefindDepart}" class="text" />
                    </div>
                    <div class="input_lable fl">
                        <label for="">认定日期：</label>
                        <input type="text" isrequired="true" fl="认定日期" name="DefindDate" id="DefindDate" value="${DateTimeConvert(DefindDate, '年月日')}" class="text Wdate" readonly="readonly" onclick="WdatePicker({ dateFmt: 'yyyy年MM月dd日', onpicked: function () { ChangeLid(); }, oncleared: function () { ChangeLid(); } });"/>
                    </div>
                    <div class="input_lable input_lable2">
                        <label for="">获奖文件：</label>
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
                <h2 class="cont_title"><span>基本信息</span></h2>
                <div class="area_form clearfix"> 
                    {{if AchieveType!=3&&GPid!=4}}                    
                    <div class="input_lable fl">
                        <label for="">获奖项目名称：</label>
                        <input type="text" isrequired="true" fl="获奖项目名称" class="text" name="Name" id="Name" value="${Name}" style="width: 694px" />
                    </div>
                    {{/if}}
                    {{if  AchieveType==3}}
                    <div class="input_lable book fl">
                        <label for="">书名：</label>
                        <select class="chosen-select" fl="书名" data-placeholder="书名" id="BookId" name="BookId" onchange="Get_OperReward_UserInfo();"></select>
                    </div>
                    <div class="input_lable book fl">
                        <label for="">书号：</label>
                        <input type="text" name="ISBN" id="ISBN" value="${ISBN}" class="text" readonly="readonly"/>
                    </div>
                     {{/if}}
                    <div class="input_lable fl">
                        <label for="">奖励项目：</label>
                        <select class="select" isrequired="true" fl="奖励项目" name="Gid" id="Gid" onchange="BindLinfo();SetScore();"></select>
                    </div>
                    <div class="input_lable fl">
                        <label for="">获奖级别：</label>
                        <select class="select" isrequired="true" fl="获奖级别" name="Lid" id="Lid" onchange="BindRewardInfo();SetScore();"></select>
                    </div>

                    <div class="input_lable fl">
                        <label for="">奖励等级：</label>
                        <select class="select" isrequired="true" fl="奖励等级" name="Rid" id="Rid" onchange="BindRank();SetScore();"></select>
                    </div>
                     {{if AchieveType==2}}
                    <div class="input_lable fl">
                        <label for="">排名：</label>
                        <select class="select" name="Sort" id="Sort" onchange="SetScore();"></select>
                    </div>
                     {{/if}}
                    <div class="input_lable fl">
                        <label for="">获奖年度：</label>
                        <input type="text" isrequired="true" fl="获奖年度" value="${Year}" class="text Wdate" name="Year" id="Year" onclick="WdatePicker({dateFmt:'yyyy年'})" />
                    </div>
                    {{if AchieveType!=3}}
                    <div class="input_lable fl {{if AchieveType==3}}none{{/if}}">
                        <label for="" id="lb_ResponsMan">{{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}：</label>
                        <select class="chosen-select" isrequired="true" fl="{{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}" data-placeholder="{{if AchieveType==5}}获奖教师{{else}}负责人{{/if}}" id="ResponsMan" name="ResponsMan" onchange="Bind_ResponsMan('ResponsMan');"></select>
                    </div>
                     {{/if}}
                    <div class="input_lable fl">
                        <label for="">负责单位：</label>
                        <select class="chosen-select" data-placeholder="负责单位" id="DepartMent" name="DepartMent" multiple="multiple"></select>
                    </div>
                    <div class="input_lable input_lable2">
                        <label for="">获奖证书：</label>                        
                        <div class="fl uploader_container">
                            <div id="uploader_certi6">
                                <div class="queueList">
                                    <div id="dndArea_certi6" class="placeholder photo_lists">
                                        <div id="filePicker_certi6"></div>
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
                <h2 class="cont_title members {{if AchieveType!=2}}none{{/if}}"><span>成员信息</span></h2>
                <div class="area_form members {{if AchieveType!=2}}none{{/if}}">
                    <div class="clearfix">
                        <input type="button" name="name" id="" value="添加" class="btn fl" onclick="javascript: OpenIFrameWindow('添加成员','AddAchMember.aspx', '1000px', '700px');">
                        <input type="button" name="name" id="" value="删除" class="btn fl ml20" onclick="Del_HtmlMember();">
                        <span class="fr status">已分：<span id="span_UnScore" style="color:#d02525;">未分：0分</span></span>
                        <span class="fr status">已分：<span id="span_CurScore">0</span>分，</span>
                        <span class="fr status">总分：<span id="span_AllScore">${TotalScore}</span>分，</span>
                    </div>
                    <table class="allot_table mt10">
                        <thead>
                            <tr>
                                <th width="40px;"><input type="checkbox" name="ck_tball" onclick="CheckAll(this)"/></th>
                                <th>姓名</th>
                                <th>部门</th>
                                <th>分数</th>
                            </tr>
                        </thead>
                        <tbody id="tb_Member"></tbody>
                    </table>
                </div>
         {{if AchieveType==3}}
                <h2 class="cont_title book"><span>作者信息</span></h2>
                <div class="area_form book">
                    <div class="clearfix">                       
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
         {{/if}}
    </script>
    <%--成员信息(已添加的)--%>
    <script type="text/x-jquery-tmpl" id="tr_MemEdit">
        {{each(i, mem) AcheiveMember_data.retData}}    
        <tr id="tr_mem_${mem.Id}" class="memedit {{if i==0&&cur_ResponUID==mem.UserNo}}meditor{{/if}}" un="${mem.UserNo}">
            <td>{{if cur_ResponUID!=mem.UserNo}}<input type='checkbox' value="${mem.UserNo}" name="ck_trsub" onclick="CheckSub(this);"/>{{/if}}</td>
            <td>${mem.Name}</td>
            <td>${mem.Major_Name}</td>
            <td><input type="number" value="${mem.Score}" min="0" regtype="money" fl="分数" step="0.01" onblur="ChangeRankScore(this);"></td>
        </tr>
        {{/each}}      
    </script>
     <%--成员信息(新添加的)--%>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr class="memadd" un="${UniqueNo}">
            <td><input type='checkbox' value="${UniqueNo}" name="ck_trsub" onclick="CheckSub(this);" /></td>
            <td>${Name}</td>
            <td>${MajorName}</td>
            <td><input type="number" value="" min="0" regtype="money" fl="分数" step="0.01" onblur="ChangeRankScore(this);"></td>
        </tr>
    </script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        });
    </script>
</head>
<body>
    <input type="hidden" name="Func" value="AddAcheiveRewardInfoData" />
    <input type="hidden" name="CreateUID" id="CreateUID" value="011" />
    <input type="hidden" name="Status" id="Status" value="0" />
    <input type="hidden" name="Id" id="Id" value="0" />
    <input type="hidden" id="Group" name="Group" />
    <input type="hidden" id="hid_UploadFunc" value="Upload_AcheiveReward"/>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix" style="padding-bottom: 0px;">
            <h1 class="title">
                <a href="#" id="a_ParUrl" style="cursor: pointer;">业绩修改</a><span>&gt;</span><a href="#" class="crumbs" id="GropName"></a>
            </h1>
            <div id="div_Achieve" class="cont"></div>
        </div>
        <div class="score"></div>
        <div class="btnwrap" style="background: #fafafa; padding: 15px 0px;">
            <input type="button" value="保存" onclick="Save(0);" class="btn" />
            <input type="button" value="提交" class="btn ml10" onclick="Save(1);"/>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script src="../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../Scripts/choosen/prism.js"></script>
    <script src="../Scripts/Webuploader/dist/webuploader.js"></script>
    <link href="../Scripts/Webuploader/css/webuploader.css" rel="stylesheet" />
    <script src="./upload_batchfile.js"></script>
    <script src="BaseUse.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script>
        var UrlDate = new GetUrlDate();
        var achieve_add_noaudit = false;//无需审核
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            $("#a_ParUrl").attr('href', UrlDate.Iid == 3 ? "AchManage.aspx?Id=2&Iid=3" : "MyPerformance.aspx?Id=2&Iid=4");
            Get_PageBtn("/TeaAchManage/AchManage.aspx");
            achieve_add_noaudit = JudgeBtn_IsExist("achieve_add_noaudit");
            $("#Group").val(UrlDate.Group);                     
            var itemId = UrlDate.itemId;
            if (itemId != undefined) {
                $("#Id").val(itemId);                
                GetDataById(itemId);
            } 
        });
        function GetDataById(itemId) {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveRewardInfoData", "IsPage": "false", Id: UrlDate.itemId },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        var model = json.result.retData[0];
                        $(".score").html("分数：" + model.TotalScore + "分" + (model.AchieveType == "3" ? "/万字" : ""));
                        achie_Score = Num_Fixed(model.TotalScore);
                        $("#div_AchInfo").tmpl(model).appendTo("#div_Achieve");
                        cur_ResponUID = model.ResponsMan;
                        cur_AchieveType = model.AchieveType;
                        $("#GropName").html(model.GName);
                        if (model.Status == "0" || model.Status == "2") {
                            $(".btn").show();
                        }
                        else {
                            $(".btn").hide();
                        }
                        BindDepart("DepartMent", model.DepartMent);
                        BindGInfo();//奖励项目
                        $("#Gid").val(model.Gid);
                        BindLinfo();
                        $("#Lid").val(model.Lid);
                        BindRewardInfo();
                        $("#Rid").val(model.Rid);
                        BindRank();
                        $("#Sort").val(model.Sort);                                                                 
                        BindFile_Plugin(); 
                        Get_Sys_Document(0, $("#Id").val());//获奖文件
                        BindFile_Plugin("#uploader_certi6", "#filePicker_certi6", "#dndArea_certi6");
                        Get_Sys_Document(6, $("#Id").val(), "#uploader_certi6");//获奖证书
                        BindUser("ResponsMan");
                        $("#ResponsMan").val(model.ResponsMan);
                        $("#ResponsMan").trigger("chosen:updated");
                        $("#ResponsMan").chosen();                       
                        if (cur_AchieveType == 3) {
                            BindBook();
                            $("#BookId").val(model.BookId);
                            $("#BookId").trigger("chosen:updated");
                            $("#BookId").chosen();
                            Get_OperReward_UserInfo();
                        } else {
                            Get_TPM_AcheiveMember(UrlDate.itemId);
                        }                                              
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        function BindBook() {
            $("#BookId").empty();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                async:false,
                data: {Func: "GetTPM_BookStory", IsPage: false,BookType:2,Status: "3" },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#BookId").append('<option value="">请选择教材</option>');
                        $.each(json.result.retData, function () {
                            $("#BookId").append('<option value="' + this.Id + '" isbn="' + this.ISBN + '" bt="' + this.BookType + '">' + this.Name + '</option>');
                        });
                    }
                    $("#BookId").chosen({
                        allow_single_deselect: true,
                        disable_search_threshold: 1,
                        no_results_text: '未找到',
                        search_contains: true,
                        width: '270px'
                    });
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }        
        function BindRank() {
            $("#Sort").html('<option value="" ss="0">请选择</option>');            
            if ($("#Rid").val() != "") {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: { "Func": "GetRank", "IsPage": "false", "RId": $("#Rid").val() },
                    success: function (json) {
                        if (json.result.errMsg == "success") {
                            $.each(json.result.retData, function () {
                                $("#Sort").append('<option value="' + this.Id + '" ss="' + this.Score + '">' + this.Name + '</option>');
                            });
                        }
                    },
                    error: function (errMsg) {
                        alert(errMsg);
                        //接口错误时需要执行的
                    }
                });
            }
        }            
        //提交按钮
        function Save(s_type) {
            var department = $("#DepartMent").val();
            if (s_type == 0) {
                $("#Status").val("0");                
                var judgeobj = $("#ResponsMan");
                if (UrlDate.Type == "1" || UrlDate.Type == "2") { judgeobj = $("#Name"); } else if (UrlDate.Type == "3") {
                    judgeobj = $("#BookId");
                }
                if (judgeobj.val() == undefined || !judgeobj.val().trim().length) {
                    layer.msg("请输入" + judgeobj.attr("fl")+ "!");
                    return;
                }
            } else {
                $("#Status").val(achieve_add_noaudit ? "3" : "1");
                //验证为空项或其他
                var valid_flag = validateForm($('select,input[type="text"]:visible'));
                if (valid_flag != "0")////验证失败的情况  需要表单的input控件 有 isrequired 值为true或false 和fl 值为不为空的名称两个属性
                {
                    return false;
                }
                if ($("#uploader .filelist li").length <= 0) {
                    layer.msg("请上传获奖文件!");
                    return;
                }
                if (UrlDate.Type == "2" && !$("#Sort").val().length) {
                    layer.msg("请选择排名!");
                    return;
                }
                if (UrlDate.Type == "3" && !$("#BookId").val().trim().length) {
                    layer.msg("请输入书名!");
                    return;
                }
                if (department == null || department == "") {
                    layer.msg("请输入负责单位!");
                    return;
                }                
            }
            if (UrlDate.Type == "2" && (Number($('#span_AllScore').html()) < Number($('#span_CurScore').html()))) {
                layer.msg("已分配分数不能大于总分！");
                return;
            }
            var object = getFromValue();//组合input标签   
            object.DepartMent = department ? $("#DepartMent").val().join(',') : "";                    
            object.MemberStr = '';
            object.MemberEdit = '';
            object.AchieveType = UrlDate.Type;
            if (UrlDate.Type == "3") {
                object.ResponsMan = $("#tb_info tr:first").attr('un');
            }
            var addArray = Rtn_AddMemArray(1);
            object.MemberStr = addArray.length > 0 ? JSON.stringify(addArray) : '';
            var editArray = [];
            $("#tb_Member tr").each(function (i, n) {
                if ($(this).hasClass('memedit')) {
                    var sub_e = new Object();
                    sub_e.Id = n.id.replace('tr_mem_', '');
                    sub_e.Score = $(this).find('input[type=number]').val();
                    sub_e.Sort = i + 1;
                    sub_e.EditUID = loginUser.UniqueNo;
                    editArray.push(sub_e);
                }
            });
            object.MemberEdit = editArray.length > 0 ? JSON.stringify(editArray) : '';
            var add_path = Get_AddFile(), cert_path = Get_AddFile(6, '#uploader_certi6');//获奖文件，获奖证书
            add_path = add_path.concat(cert_path);
            object.Add_Path = add_path.length > 0 ? JSON.stringify(add_path) : "";
            object.Edit_PathId = Get_EditFileId().concat(Get_EditFileId('#uploader_certi6'));
            if (s_type == 1) {
                layer.confirm('确认提交吗？提交后将不能进行修改', {
                    btn: ['确定', '取消'], //按钮
                    title: '操作'
                }, function (index) {
                    LastSave(object);
                }, function () { });
            } else {
                LastSave(object);
            }
        }
        function LastSave(object) {
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: object,
                success: function (json) {
                    if (json.result.errNum == 0) {
                        layer.msg('操作成功!');
                        Del_Document();
                        window.location.href = $("#a_ParUrl").attr('href');
                    } else if (json.result.errNum == -1) {}
                },
                error: function (errMsg) {}
            });
        }
        //奖励项目
        function BindGInfo() {
            $("#Gid").html('<option value="">请选择</option>');
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                async:false,
                data: { "Func": "GetAcheiveLevelData", "IsPage": "false", "Pid": UrlDate.Group },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $(json.result.retData).each(function () {
                            $("#Gid").append('<option value="' + this.Id + '">' + this.Name + '</option>');
                        })
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //获奖级别
        function BindLinfo() {           
            $("#Lid").html('<option value="">请选择</option>');
            $("#Rid").html('<option value="" ss="0">请选择</option>');
            $("#Sort").html('<option value="" ss="0">请选择</option>');            
            if (!$("#DefindDate").val().trim().length) {
                layer.msg("请先指定认定日期");
                return;
            }
            if ($("#Gid").val() != "") {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                    type: "post",
                    async: false,
                    dataType: "json",
                    data: { "Func": "GetRewardLevelData", "LID": $("#Gid").val(), DefindDate: $("#DefindDate").val().trim(), "IsPage": "false" },
                    success: function (json) {
                        if (json.result.errMsg == "success") {
                            $(json.result.retData).each(function () {
                                $("#Lid").append('<option value="' + this.Id + '">' + this.Name + '</option>');
                            })
                        } else {
                            layer.msg("该认定日期没有对应的业绩版本！");
                        }
                    },
                    error: function () {
                        //接口错误时需要执行的
                    }
                });
            }
        }
        //奖励等级
        function BindRewardInfo() {
            $("#Rid").html('<option value="" ss="0">请选择</option>');
            $("#Sort").html('<option value="" ss="0">请选择</option>');            
            if ($("#Lid").val() != "") {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: { "Func": "GetRewardInfoData", "LID": $("#Lid").val(), "IsPage": "false" },
                    success: function (json) {
                        if (json.result.errMsg == "success") {
                            $(json.result.retData).each(function () {
                                $("#Rid").append('<option value="' + this.Id + '" ss="' + this.Score + '">' + this.Name + '</option>');
                            })
                        }
                    },
                    error: function () {
                        //接口错误时需要执行的
                    }
                });
            }
        }        
    </script>
</body>
</html>
