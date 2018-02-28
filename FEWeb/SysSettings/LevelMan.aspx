<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LevelMan.aspx.cs" Inherits="FEWeb.SysSettings.LevelMan" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>业绩等级管理</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link rel="stylesheet" href="../css/layout.css" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <script id="tr_Level" type="text/x-jquery-tmpl">
         {{each(i, lew) cur_RewardLevelData.retData}}          
        <li>
            <div class="version_header clearfix">
                <span>${lew.Name}</span>
                <i class="iconfont fr icond" id="${lew.Id}">&#xe643;</i>
                <input type="button" name="name" value="新增奖项" class="btn fr ml10" onclick="AddReward(${lew.Id})"/>            
                <div class="oprated fr">
                    <div class="operate" onclick="javascript:OpenIFrameWindow('编辑等级', '../TeaAchManage/LeveAdd.aspx?Id=${lew.Id}', '500px', '300px');">
                        <i class="iconfont color_purple">&#xe628;</i>
                        <span class="operate_none bg_purple">编辑</span>
                    </div>
                     {{if i==0}}
                    <div class="operate">
                        <i class="iconfont color_gray">&#xe629;</i>
                        <span class="operate_none bg_gray">上移</span>
                    </div>
                    {{else}}
                     <div class="operate" onclick="LeverSort('up',${lew.Id})">
                        <i class="iconfont color_purple">&#xe629;</i>
                        <span class="operate_none bg_purple">上移</span>
                    </div>
                    {{/if}}
                     {{if  i+1==cur_RewardLevelData.retData.length}}
                    <div class="operate">
                        <i class="iconfont color_gray">&#xe62d;</i>
                        <span class="operate_none bg_gray">下移</span>
                    </div>
                     {{else}}
                    <div class="operate" onclick="LeverSort('down',${lew.Id})">
                        <i class="iconfont color_purple">&#xe62d;</i>
                        <span class="operate_none bg_purple">下移</span>
                    </div>
                    {{/if}}
                </div>
            </div>
            {{if cur_AchieveType=="2"}}
             <div class="version_none" id="Leve${lew.Id}"></div>
            {{else}}
             <div class="version_none">
                 <div class="table">
                     <table>
                         <thead>
                             <tr>
                                 <th>奖项</th>
                                 <th>分数（分）</th>
                                 <th>奖金（万元）</th>
                                 <th>追加（万元）</th>
                                 <th id="ops" width="230px;">操作</th>
                             </tr>
                         </thead>
                         <tbody id="Leve${lew.Id}"></tbody>
                     </table>
                 </div>
             </div>
            {{/if}}             
        </li>
         {{/each}}   
    </script>
    <script id="tr_Reward" type="text/x-jquery-tmpl">
        {{each(i, rew) cur_RewardInfoData.retData}}  
        <tr>
            <td>${rew.Name}</td>
            <td>${rew.Score}</td>
            <td><%--${rew.FirstMoney}--%></td>
            <td><%--${rew.AddMoney}--%></td>
            <td class="operate_wrap">
                <div class="operate" onclick="javascript:OpenIFrameWindow('奖金管理', '../TeaAchManage/AddAward.aspx?Id=${rew.Id}&lid=${LID}', '700px', '480px');">
                    <i class="iconfont color_purple">&#xe623;</i>
                    <span class="operate_none bg_purple">奖金</span>
                </div>
                <div class="operate" onclick="javascript:OpenIFrameWindow('编辑奖项', '../TeaAchManage/RewardAdd.aspx?Id=${rew.Id}&batid=${rew.FirstId}&stype=1', '500px', '320px');">
                    <i class="iconfont color_purple">&#xe628;</i>
                    <span class="operate_none bg_purple">编辑</span>
                </div>
                {{if i==0}}
                 <div class="operate">
                    <i class="iconfont color_gray">&#xe629;</i>
                    <span class="operate_none bg_gray">上移</span>
                </div>
                {{else}}
                <div class="operate" onclick="RewardSort('up',${rew.Id})">
                    <i class="iconfont color_purple">&#xe629;</i>
                    <span class="operate_none bg_purple">上移</span>
                </div>
                {{/if}}
                {{if i+1==cur_RewardInfoData.retData.length}}
               <div class="operate">
                    <i class="iconfont color_gray">&#xe62d;</i>
                    <span class="operate_none bg_gray">下移</span>
                </div>
                {{else}}
                <div class="operate" onclick="RewardSort('down',${rew.Id})">
                    <i class="iconfont color_purple">&#xe62d;</i>
                    <span class="operate_none bg_purple">下移</span>
                </div>
                 {{/if}}                
            </td>
        </tr>
        {{/each}}   
    </script>
    <%--教学成果--%>
    <script id="tr_TeaResult" type="text/x-jquery-tmpl">
         {{each(i, rew) cur_RewardInfoData.retData}}  
        <div>
            <div class="version_header clearfix" style="padding-left:30px;border-top:1px solid #E3D5DC;background:#fff;">
                <span>${rew.Name}</span>
                <i class="iconfont fr icond" rid="${rew.Id}">&#xe643;</i>
                <input type="button" name="name" value="奖项排名" class="btn fr ml10" onclick="javascript:OpenIFrameWindow('奖项排名', '../TeaAchManage/RankSet.aspx?RId=${rew.Id}&Score=${rew.Score}', '500px', '550px');" />
                <div class="oprated fr">
                    <div class="operate" onclick="javascript:OpenIFrameWindow('编辑奖项', '../TeaAchManage/RewardAdd.aspx?Id=${rew.Id}&batid=${rew.FirstId}&stype=3', '500px', '240px');">
                        <i class="iconfont color_purple">&#xe628;</i>
                        <span class="operate_none bg_purple">编辑</span>
                    </div>
                    {{if i==0}}
                 <div class="operate">
                    <i class="iconfont color_gray">&#xe629;</i>
                    <span class="operate_none bg_gray">上移</span>
                </div>
                {{else}}
                <div class="operate" onclick="RewardSort('up',${rew.Id})">
                    <i class="iconfont color_purple">&#xe629;</i>
                    <span class="operate_none bg_purple">上移</span>
                </div>
                {{/if}}
                {{if i+1==cur_RewardInfoData.retData.length}}
               <div class="operate">
                    <i class="iconfont color_gray">&#xe62d;</i>
                    <span class="operate_none bg_gray">下移</span>
                </div>
                {{else}}
                <div class="operate" onclick="RewardSort('down',${rew.Id})">
                    <i class="iconfont color_purple">&#xe62d;</i>
                    <span class="operate_none bg_purple">下移</span>
                </div>
                 {{/if}}
                </div>
            </div>
            <div class="table version_none">
                <table>
                    <thead>
                        <tr>
                            <th style="text-align:left;text-indent:45px;">排名</th>
                            <th>分数（分）</th>
                            <th>奖金（万元）</th>
                            <th>追加（万元）</th>
                            <th id="ops" width="230px;">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb_RewRank_${rew.Id}"></tbody>
                </table>
            </div>
        </div>
        {{/each}}   
    </script>
    <%--教学成果奖排名--%>
    <script id="tr_RewRank" type="text/x-jquery-tmpl">
        <tr>
            <td style="padding-left:45px;text-align:left;">${Name}</td>
            <td>${Score}</td>
            <td>${FirstMoney}</td>
            <td>${AddMoney}</td>
            <td class="operate_wrap">
                <div class="operate" onclick="javascript:OpenIFrameWindow('奖金管理', '../TeaAchManage/AddAward.aspx?Id=${RId}&rank=${Id}', '700px', '480px');">
                    <i class="iconfont color_purple">&#xe623;</i>
                    <span class="operate_none bg_purple">奖金</span>
                </div> 
            </td>
        </tr>
    </script>
</head>
<body>
    <input id="LID" type="hidden" />
    <input id="ELID" type="hidden" />
    <input id="EID" type="hidden" />
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">            
            <div class="sortwrap clearfix">
                <div class="menu fl">
                    <h1 class="titlea">业绩等级管理</h1>
                    <ul class="menu_list" style="height:478px;overflow:auto"></ul>
                    <input type="button" name="name" value="设置" class="new" onclick="OpenIFrameWindow('菜单设置','MenuSetting.aspx','900px','680px')" />
                </div>
                <div class="sort_right fr">
                    <div class="nav_version_wrap clearfix">
                        <div class="nav_version_left fl"></div>
                        <div class="fr">
                            <input type="button" name="name" value="版本管理" class="btn2" id="EditEdition"/>                           
                        </div>
                    </div>
                    <div class="nav_title clearfix">
                        <span id="BigGroupName"></span>
                        <div class="fr clearfix">
                            <div class="input-wrap fl mr10" style="margin-bottom: 0;" onclick="ChangeRewardEditionAllot()">
                                <label for="" style="min-width: auto;">金额分配：</label>
                                <span class="switch-on" themecolor="#6a264b" id="IsMoneyAllot"></span>
                            </div>
                            <input type="button" name="name" value="新增等级" class="btn" id="NewLevel" />
                        </div>
                    </div>
                    <div class="">
                        <ul class="version_lists"></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../Scripts/Common.js"></script>
    <script src="../scripts/public.js"></script>
    <script src="../Scripts/linq.min.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../Scripts/pagination/pagination.css" rel="stylesheet" />
    <link href="../Scripts/HoneySwitch/honeySwitch.css" rel="stylesheet" />
    <script src="../Scripts/HoneySwitch/honeySwitch.js"></script>
    <script>
        $(function () {
            $("#CreateUID").val(GetLoginUser().UniqueNo);
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        })
    </script>
    <script>
        var UrlDate=new GetUrlDate(),cur_AchieveType="1";
        function AddReward(LID)        
        {
            var stype=1;
            var achievetype=$('.menu_list li.selected').parent('ul').attr('atype');
            if(achievetype=="2"){
                stype=3;
            }else if(achievetype=="3"){stype=2;}
            OpenIFrameWindow('新增奖项', '../TeaAchManage/RewardAdd.aspx?LID=' + LID+'&stype='+stype, '500px', stype==3?'240px':'320px');
        }
        //开启（关闭）金额分配
        function ChangeRewardEditionAllot()
        { 
            var IsMoneyAllot = 0;
            if ($("#IsMoneyAllot").hasClass("switch-on"))
            {
                IsMoneyAllot = 1;
            }
            var Id = $("#EID").val();
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "ChangeRewardEditionAllot", "IsPage": "false", Id: Id, IsMoneyAllot: IsMoneyAllot },
                success: function (json) {
                    if (json.result.errNum ==0) {
                        if (IsMoneyAllot == 1) {
                            honeySwitch.showOn("#IsMoneyAllot");
                            $(".nav_version_left").find("#" + Id).attr("switch", "1");
                        }
                        else
                        {
                            honeySwitch.showOff("#IsMoneyAllot");
                            $(".nav_version_left").find("#" + Id).attr("switch", "0");
                        }
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        $(function () {
            menu_list("");
            $("#NewLevel").click(function () {
                var EID=$("#EID").val();
                if (!EID) {
                    layer.msg("请选择一个版本");
                }
                else
                {
                    OpenIFrameWindow('新增等级', '../TeaAchManage/LeveAdd.aspx?EID=' +EID , '500px', '270px');
                }
            })
            Edition('#EditEdition', 'EditionEdit','版本管理','800','500');
        })
        function Edition(obj, src,name, width, height) {
            width = width || 600;
            height = height || 270;
            $(obj).click(function () {
                var LID = $("#ELID").val();
                if (!LID) {
                    layer.msg("请选择一个分类");
                }
                else {
                    OpenIFrameWindow(name, '../TeaAchManage/' + src + '.aspx?LID=' + LID + '&id=' + $(".nav_version_left .selected").attr('id'), '' + width + 'px', '' + height + 'px');
                }
            })
        }
        //业绩分类
        function menu_list(node) {
            if (node=="") {
                $.ajax({
                    url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                    type: "post",
                    dataType: "json",
                    data: { "Func": "GetAcheiveLevelData", "IsPage": "false" },
                    async:false,
                    success: function (json) {
                        if (json.result.errMsg == "success") {
                            AcheiveLevel = json.result.retData;
                        }
                    },
                    error: function () {}
                });
            }
            else{
                AcheiveLevel=node;
            }
            BindP();
        }
        function BindP()
        {
            $('.menu_list').html('');
            $(AcheiveLevel).each(function () {
                if (this.Pid == "0") {
                    var ulID = 'ul' + this.Id;
                    //$("#ELID").val(this.Id)
                    $(".menu_list").append("<li><span>" + this.Name + "<i class=\"iconfont\">&#xe643;</i></span><ul id=" + ulID + " atype="+this.Type+"></ul></li>")
                    BindChild(this.Id);
                }
            })
            InitClass();
        }
        function BindChild(Id) {
            var ulID = 'ul' + Id;
            $("#" + ulID).html("");
            $(AcheiveLevel).each(function () {
                if (this.Pid == Id) {
                    $("#" + ulID).append("<li id=" + this.Id + ">" + this.Name + "</li>")
                }
            })
        }        
        function InitClass() {
            $('.menu_list li:eq(0)').children('span').addClass('selected');
            $('.menu_list li:eq(0)').children('ul').slideDown();
            $('.menu_list li:eq(0)').children('ul').find("li:eq(0)").addClass('selected');
            var id=$('.menu_list li:eq(0)').children('ul').find("li:eq(0)").attr("id");
            var Name=$('.menu_list li:eq(0)').children('ul').find("li:eq(0)").html();            
            $("#BigGroupName").html(Name);
            $("#ELID").val(id)
            BindEdition(id);
            $('.menu_list>li>span').hover(function(){
                $(this).siblings('em').show();
            },function(){
                $(this).siblings('em').hide();
            })
            $('.menu_list').find('li:has(ul)').children('span').click(function () {
                var $next = $(this).next('ul');
                if ($next.is(':hidden')) {
                    $(this).addClass('selected');
                    $next.stop().slideDown();
                    $('.menu_list').find('li').removeClass('selected');
                    $(this).next('ul').find("li:eq(0)").addClass("selected");                    
                    var id= $(this).next('ul').find("li:eq(0)").addClass("selected").attr("id");
                    var Name=$(this).next('ul').find("li:eq(0)").html();                      
                    GroupSelected(id, Name);
                    if($(this).parent('li').siblings().children('ul').is(':visible')) {
                        $(this).parent('li').siblings().children('span').removeClass('selected');
                        $(this).parent('li').siblings().children('ul').stop().slideUp();
                    }
                } else {
                    $(this).removeClass('selected');
                    $next.stop().slideUp();
                }
            });
            $('.menu_list').find('li:has(ul)').find('li').click(function () {
                $('.menu_list').find('li').removeClass('selected');
                $(this).addClass('selected').siblings().removeClass('selected');                
                GroupSelected($(this).attr("id"),$(this).html());
            });
        }
        function GroupSelected(id, name)
        {
            $("#ELID").val(id);
            $("#BigGroupName").html(name);
            BindEdition(id);//绑定版本
        }

        //奖项版本
        function BindEdition(LID) {
            $(".nav_version_left").html("");
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetRewardEditionData", "LID": LID, "IsPage": "false" },
                success: function (json) {
                    var i = 0;
                    if (json.result.errMsg == "success") {
                        $(json.result.retData).each(function () {
                            if (i == 0) {
                                $(".nav_version_left").append('<a href="javascript:;" id=' + this.Id + ' switch=' + this.IsMoneyAllot + ' class="selected" onclick="BindRewardLevelData(' + this.Id + ',this)">' + this.Name + '</a>')
                                $("#EID").val(this.Id);                                
                                BindRewardLevelData(this.Id);
                            }
                            else {
                                $(".nav_version_left").append('<a href="javascript:;" id=' + this.Id + ' switch=' + this.IsMoneyAllot + ' onclick="BindRewardLevelData(' + this.Id + ',this)">' + this.Name + '</a>')
                            }
                            i++;
                        });
                    }
                    else{
                        $(".version_lists").html(""); 
                        $("#EID").val("");
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //奖项等级
        var cur_RewardLevelData=[];
        function BindRewardLevelData(EID,em) {
            $(em).addClass("selected").siblings().removeClass("selected");
            if (EID==undefined) {
                EID=$("#EID").val();
            }
            else{
                $("#EID").val(EID);
            }
            var IsMoneyAllot = $(".nav_version_left").find('#'+EID).attr('switch');
            if (IsMoneyAllot == "0") {
                honeySwitch.showOff("#IsMoneyAllot");
            }
            else {
                honeySwitch.showOn("#IsMoneyAllot");
            }
            cur_AchieveType=$('.menu_list li.selected').parent('ul').attr('atype');           
            $(".version_lists").html("");
            cur_RewardLevelData=[];
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetRewardLevelData", "EID": EID, "IsPage": "false" },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        cur_RewardLevelData=json.result;
                        $("#tr_Level").tmpl(cur_RewardLevelData).appendTo(".version_lists");
                        $('.oprated').find('.operate').hover(function () {
                            $(this).find('.operate_none').slideDown();
                        }, function () {
                            $(this).find('.operate_none').stop().slideUp();
                        });
                    }
                    get_animate();
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }        
        function get_animate() {
            $('.version_lists').find('li:has(.version_header)').find('.icond').click(function () {
                BindReward($(this).attr("id"));
                $("#LID").val($(this).attr("id"))
                var $next = $(this).parent().next();                
                if ($next.is(':hidden')) {
                    $(this).addClass('active');
                    $next.find('.icond').removeClass('active');
                    $next.find('.version_none').hide();
                    $next.show();
                    if ($(this).parent().parent().siblings().children('.version_none').is(":visible")) {
                        $(this).parent().parent().siblings().find('.icond').removeClass('active');
                        $(this).parent().parent().siblings().find('.version_none').hide();
                    }
                } else {
                    $(this).removeClass('active');
                    $(this).parent().find('.version_none').hide();
                    $next.hide();
                }
            })
        }
        function LeverSort(type,Id){
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "SortRewardLevelData", "Id": Id, "SortType": type },
                success: function (json) {
                    if (json.result.errMsg == "") {
                        BindRewardLevelData($("#EID").val());
                    }       
                    else{
                        layer.msg(json.result.errMsg);
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //奖项
        var cur_RewardInfoData=[];
        function BindReward(LID) {
            if (LID==undefined) {
                LID=$("#LID").val();
            }
            var Leveid = "Leve" + LID;
            cur_AchieveType=$('.menu_list li.selected').parent('ul').attr('atype');           
            $("#" + Leveid).html("");
            cur_RewardInfoData=[];
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetRewardInfoData", "LID": LID, "IsPage": "false" },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        cur_RewardInfoData=json.result;
                        $(cur_AchieveType=="2"?"#tr_TeaResult":"#tr_Reward").tmpl(cur_RewardInfoData).appendTo("#" + Leveid);                        
                    }
                    tableSlide();
                    if(cur_AchieveType=="2"){SetRewardSH(Leveid);}                    
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }  
        function SetRewardSH(Leveid){ //设置奖项展开关闭
            $('#'+ Leveid).find('.icond').click(function(){                        
                var $next = $(this).parent().next();
                if($next.is(':hidden')){
                    BindRank($(this).attr('rid'));
                    $(this).addClass('active');
                    $next.show();
                    if ($(this).parent().parent().siblings().children('.version_none').is(":visible")) {
                        $(this).parent().parent().siblings().find('.icond').removeClass('active');
                        $(this).parent().parent().siblings().find('.version_none').hide();
                    }
                }else{
                    $(this).removeClass('active');
                    $next.hide();
                }
            });
        }
        function RewardSort(type,Id){
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "SortRewardInfoData", "Id": Id, "SortType": type },
                success: function (json) {
                    if (json.result.errMsg == "") {
                        BindReward($("#LID").val());
                    }       
                    else{
                        layer.msg(json.result.errMsg);
                    }
                },
                error: function () {
                    //接口错误时需要执行的
                }
            });
        }
        //绑定排名
        function BindRank(rid)
        {   
            var rewoid="#tb_RewRank_"+rid;
            $(rewoid).empty();            
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
                type: "post",
                dataType: "json",
                data: {Func: "GetRank", IsPage: false,RId: rid,IsAward:"1"},
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $("#tr_RewRank").tmpl(json.result.retData).appendTo(rewoid);
                    } 
                    tableSlide();
                },
                error: function (errMsg) {}
            });            
        }
    </script>
</body>
</html>
