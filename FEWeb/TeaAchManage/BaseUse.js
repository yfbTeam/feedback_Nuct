var loginUser = GetLoginUser();
var cur_ResponUID = "",cur_ResponName="",cur_AchieveType = 1,achie_Score=0,score_Words=0; //教材建设记分的总字数
function Num_Fixed(num, count) {
    count = arguments[1] || 2;
    return Number(num||0).toFixed(count);
}
function GetAchieveDetailById(type) { //获取业绩详情
    type = arguments[0] || 0; // type 0默认信息；1 AchieveView_Common ；2 CheckAchieve
    $("#div_Achieve").empty();
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        async: false,
        data: { "Func": "GetAcheiveRewardInfoData", "IsPage": "false", Id: cur_AchieveId },
        success: function (json) {
            if (json.result.errMsg == "success") {
                var model = json.result.retData[0];
                $("#div_AchInfo").tmpl(model).appendTo("#div_Achieve");
                cur_ResponUID = model.ResponsMan, cur_ResponName = model.ResponsName;
                cur_AchieveType = model.AchieveType;
                achie_Score = Num_Fixed(model.TotalScore);
                $(".score").html("分数：" + model.TotalScore + "分" + (model.AchieveType == "3" ? "/万字" : ""));
                if (type == 1) {
                  Get_RewardUserInfo(model);
                } else if (type == 2) {
                    cur_AchCreateUID = model.CreateUID;
                    View_CheckInit(model);
                    Get_RewardUserInfo(model);
                    Get_AchieveStatus(model.ComStatus, ".checkmes");
                }                
            }
        },
        error: function () { }
    });
}
function GetAchieveUser_Score(userdata) { //获取初始时业绩分数
    if (cur_AchieveType == "3") {
        var $span_Words = $('#span_Words');
        var curwords = 0, scorewords = 0;
        $(userdata).each(function (i, n) {
            if (n.WordNum) {
                curwords = numAdd(curwords, n.WordNum);
                if (n.ULevel != 3) { scorewords = numAdd(scorewords, n.WordNum); }
            }
        });
        $span_Words.html(Num_Fixed(curwords));
        score_Words = scorewords;
        $('#span_BookScore').html(Num_Fixed(scorewords * Number(achie_Score)));
    } else {
        var $span_CurScore = $('#span_CurScore');
        var curscore = 0;
        $(userdata).each(function (i, n) {
            if (n.Score) {
                curscore = numAdd(curscore, n.Score);                
            }
        });
        $span_CurScore.html(Num_Fixed(curscore));
    }
}
function BindDepart(id,val) {
    val=arguments[1]||"";
    $.ajax({
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        type: "post",
        dataType: "json",
        data: {
            func: "GetMajors"
        },
        async: false,
        success: function (json) {
            if (json.result.errNum.toString() == "0") {
                $(json.result.retData).each(function () {
                    $("#" + id).append('<option value="' + this.Id + '">' + this.Major_Name + '</option>');
                })
            }
            if (val) {
                Chose_Mult_set_ini("#" + id, val);
            }
            $("#" + id).chosen({
                allow_single_deselect: true,
                disable_search_threshold: 1,
                no_results_text: '未找到',
                search_contains: true,
                width: '270px'
            });                        
            $("#" + id).trigger("chosen:updated");
            $("#" + id).chosen();
        },
        error: function (errMsg) {}
    });
}
function Chose_Mult_set_ini(select, values) {
    var arr = values.split(',');
    var length = arr.length;
    var value = '';
    for (i = 0; i < length; i++) {
        value = arr[i];
        $(select + " option[value='" + value + "']").attr('selected', 'selected');
    }
    //$(select).trigger("liszt:updated");
}
//绑定用户
function BindUser(id) {
    $("#" + id).html('<option value="" selected="selected">请选择</option>');
    $.ajax({
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        type: "post",
        dataType: "json",
        async: false,
        data: {
            func: "GetTeachers"
        },
        success: function (json) {
            if (json.result.errNum.toString() == "0") {
                $(json.result.retData).each(function () {
                    $("#" + id).append('<option value="' + this.UniqueNo + '" mname="' + this.MajorName + '">' + this.Name + '</option>');
                })
            }
            $("#" + id).chosen({
                allow_single_deselect: true,
                disable_search_threshold: 1,
                no_results_text: '未找到',
                search_contains: true,
                width: '270px'
            });
            $("#" + id).trigger("chosen:updated");
            $("#" + id).chosen();
        },
        error: function (errMsg) {}
    });
}
/********************************************************教材作者信息开始***************************************************/
//绑定主编姓名
function Get_UserAndMajor(id, selval, oper, power_depart, power_all) {//power_depart院系权限，power_all全校权限
    selval = arguments[1] || "";//设置选中值
    oper = arguments[2] || "add";
    power_depart = arguments[3] || false;
    power_all = arguments[4] || false;
    var parmsData = { func: "GetTeachers" };
    if (power_depart && !power_all) {
        parmsData["Major_ID"] = loginUser.Major_ID;
    }
    $("#MEditor").html('<option value="" selected="selected">请选择</option>');
    $.ajax({
        url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
        type: "post",
        dataType: "json",
        async: false,
        data: parmsData,
        success: function (json) {
            if (json.result.errNum.toString() == "0") {
                $(json.result.retData).each(function () {
                    $("#" + id).append('<option value="' + this.UniqueNo + '" mid="' + this.Major_ID + '" mname="' + this.MajorName + '">' + this.Name + '</option>');
                })
            }
            $("#" + id).chosen({
                allow_single_deselect: true,
                disable_search_threshold: 1,
                no_results_text: '未找到',
                search_contains: true,
                width: '270px'
            });           
            if (selval) {
                if (!power_depart&&!power_all) {
                    $("#" + id).val(selval);
                    $("#" + id).attr("disabled", "disabled");
                    BindDepartInfo('MEditor', 'MEditorDepart', 'MEditorDepart_Name');
                } else {
                    if (oper == "edit") { $("#" + id).val(selval); }
                }                
            }           
            $("#" + id).trigger("chosen:updated");
            $("#" + id).chosen();
        },
        error: function (errMsg) {}
    });
}
//绑定作者信息
var RewardUserInfo_data = {};
function GetTPM_RewardUserInfo() {
    RewardUserInfo_data = {};
    $("#AuthorInfo").empty();
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        data: { "Func": "GetTPM_UserInfo", "IsPage": "false", RIId: "", BookId: $("#Id").val() },
        success: function (json) {
            if (json.result.errMsg == "success") {
                RewardUserInfo_data = json.result;
                $("#tr_Info").tmpl(json.result).appendTo("#AuthorInfo");
                GetInit_WordNum(json.result.retData);
            }
            IsOneAuthor();
            IsDisabled_IsOneAuthor();            
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}
//绑定主编单位，第一作者信息
function BindDepartInfo(selid, depid, depname) {
    var $curoption = $("#" + selid).find('option:selected');    
    if ($curoption.val() != "") {
        $("#" + depid).val($curoption.attr('mid'));
        $("#" + depname).val($curoption.attr('mname'));
        var first_tr = '<tr class="meditor memadd" un="' + $curoption.val() + '"><td></td><td>' + $curoption.text() + '</td>';
        if ($("input[name='IsOneAuthor']:checked").val() == "1") {
            first_tr += '<td>独著</td>';
        } else {
            first_tr += '<td><select><option value="1" selected="selected">主编</option></select></td>';
        }
        first_tr += '<td><input type="number" disabled="disabled" value="1"/></td><td mid=' + $curoption.attr('mid') + '>' + $curoption.attr('mname') + '</td><td><input type="number" value="" regtype="money" fl="贡献字数（万字）" step="0.01"/></td></tr>';
        var $existobj = $("#AuthorInfo tr[un='" + $curoption.val() + "']");
        if (!$existobj.length) { //列表中没有选择的用户
            $("#AuthorInfo .meditor").remove();
            $("#AuthorInfo").prepend(first_tr);     
        } else if (!$existobj.hasClass('meditor')) { //列表中有选择的用户，但是不是主编
            $("#AuthorInfo .meditor").remove();
            $existobj.remove(); $("#AuthorInfo").prepend(first_tr); 
          }         
    } else {
        $("#" + depid).val('');
        $("#" + depname).val('无');        
    }
    IsDisabled_IsOneAuthor();
}
//是否独著切换时，第一作者的设置
function Set_FirstAuthor() {
    var $first_tr = $("#AuthorInfo .meditor");
    if ($first_tr.length) {
        if ($("input[name='IsOneAuthor']:checked").val() == "1") {
            $first_tr.find('td').eq(2).html('独著');           
        } else {
            $first_tr.find('td').eq(2).html('<select><option value="1" selected="selected">主编</option></select>');           
        }
    }    
}
//是否开启/禁用 是否独著
function IsDisabled_IsOneAuthor() {
    GetCur_WordNum();
    var author_len = $("#AuthorInfo tr").length;
    if (author_len > 1) {
        $("input[name='IsOneAuthor']").attr("disabled", "disabled");
    } else {
        $("input[name='IsOneAuthor']").removeAttr("disabled");
    }
}
//删除作者
function Del_HtmlAuthor() {
    var del_tr = $("#AuthorInfo tr input[type=checkbox]:checked");
    if (del_tr.length <= 0) {
        layer.msg("请勾选要删除的作者!");
        return;
    }
    del_tr.parents('tr').remove();
    $("input:checkbox[name=ck_tball]").attr("checked", false);
    IsDisabled_IsOneAuthor();
}
//保存时，添加作者信息
function Rtn_AddAuthorArray() {
    var addArray = [];
    var add_tr = $("#AuthorInfo tr");
    $(add_tr).each(function (i, n) {
        if ($(this).hasClass('memadd')) {
            var sub_m = new Object();
            sub_m.UserNo = $(this).attr('un');           
            sub_m.ULevel = $(this).find('td').eq(2).find("select").val() || 0;
            sub_m.Sort =$(this).find('td').eq(3).find("input").val();
            sub_m.DepartMent = $(this).find('td').eq(4).attr('mid');
            sub_m.WordNum = $(this).find('td').eq(5).find("input").val();
            sub_m.CreateUID = loginUser.UniqueNo;
            addArray.push(sub_m);
        }
    });
    return addArray;
}
//保存时，修改的作者信息
function Rtn_EditAuthorArray() {
    var editArray = [];
    $("#AuthorInfo tr").each(function (i, n) {
        if ($(this).hasClass('memedit')) {
            var sub_e = new Object();
            sub_e.Id = n.id.replace('tr_auth_', '');           
            sub_e.ULevel = $(this).find('td').eq(2).find("select").val()||0;
            sub_e.Sort = $(this).find('td').eq(3).find("input").val();
            sub_e.WordNum = $(this).find('td').eq(5).find("input").val();
            sub_e.EditUID = loginUser.UniqueNo;
            editArray.push(sub_e);
        }
    });
    return editArray;
}
//初始化时，获取总贡献字数
function GetInit_WordNum(userdata) {
    var curwords = 0;
    $(userdata).each(function (i, n) {
        if (n.WordNum) {
            curwords = numAdd(curwords, n.WordNum);            
        }
    });
    $('#span_Words').html(Num_Fixed(curwords));
}
//作者信息变化时，获取当前总贡献字数
function GetCur_WordNum() {
    var curwords = 0;
    $("#AuthorInfo tr").each(function (i, n) {
        var c_word = $(this).find('td').eq(5).find("input").val();
        if (c_word) {
            curwords = numAdd(curwords, c_word);
        }
    });
    $('#span_Words').html(Num_Fixed(curwords));
}
/********************************************************教材作者信息结束***************************************************/
//绑定系(院)
function GetProfessInfo(objid) {
    objid = arguments[0] || 'college';
    var $obj = $("#" + objid);
    $obj.html("");
    $obj.append('<option value="">全部</option>');
    var postData = { func: "GetProfessInfo" };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/SysClass/ProfessInfoHandler.ashx",
        data: postData,
        dataType: "json",
        success: function (json) {
            if (json.result.errMsg == "success") {
                $(json.result.retData).each(function () {
                    $obj.append('<option value="' + this.Id + '">' + this.College_Name + '</option>');
                });
            }
        },
        error: function (errMsg) {
            layer.msg("绑定系(院)失败");
        }
    });
}
//认定日期修改时触发的方法
function ChangeLid() { 
    if ($("#DefindDate").val().trim() == "") {
        $("#Lid").html('<option value="">请选择</option>');
        $("#Rid").html('<option value="" ss="0">请选择</option>');
        $("#Sort").html('<option value="" ss="0">请选择</option>');
        SetScore();
    } else {
        if ($("#Gid").val() != "") {
            BindLinfo();
        }
    }    
}
/********************************************************业绩成员信息开始***************************************************/
//绑定成员信息
var AcheiveMember_data = {};
function Get_TPM_AcheiveMember(achid,tb_id) {
    tb_id = arguments[1] || 'tb_Member';
    var $tb_id = $("#" + tb_id);
    AcheiveMember_data = {};
    $tb_id.html("");   
    var postData = { func: "GetTPM_UserInfo", RIId: achid, IsPage: false };
    $.ajax({
        type: "Post",
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        data: postData,
        dataType: "json",
        success: function (json) {
            if (json.result.errNum.toString() == "0") {
                AcheiveMember_data = json.result;
                $("#tr_MemEdit").tmpl(json.result).appendTo("#" + tb_id);
                GetAchieveUser_Score(json.result.retData);
            }
        },
        error: function (errMsg) {
            layer.msg(errMsg);
        }
    });
}
//绑定教学成果，负责人信息
function Bind_ResponsMan(selid) {
    if (UrlDate.Type!="3") {
        var $curoption = $("#" + selid).find('option:selected');       
        if ($curoption.val() != "") {
            var first_tr = '<tr class="meditor memadd" un="' + $curoption.val() + '"><td></td><td>' + $curoption.text() + '</td>\
                        <td>' + $curoption.attr('mname') + '</td>\
                        <td><input type="number" value="" min="0" regtype="money" fl="分数" step="0.01" onblur="ChangeRankScore(this);"></td></tr>';
            var $existobj = $("#tb_Member tr[un='" + $curoption.val() + "']");
            if (!$existobj.length) {
                $("#tb_Member .meditor").remove();
                $("#tb_Member").prepend(first_tr);               
            } else if (!$existobj.hasClass('meditor')) {
                $("#tb_Member .meditor").remove();
                $existobj.remove(); $("#tb_Member").prepend(first_tr);
            }                 
        }
        GetCur_RankScore();
    }   
}
//删除成员
function Del_HtmlMember(type) {  //type 0删除；1隐藏
    type = arguments[0] || 0;
    var del_tr = $("#tb_Member tr input[type=checkbox]:checked");
    if (del_tr.length <= 0) {
        layer.msg("请勾选要删除的成员!");
        return;
    }
    var cur_tr = del_tr.parents('tr');
    if (type == 1 && cur_tr.hasClass('memedit')) {
        cur_tr.hide();
    } else {
        cur_tr.remove();
    }
    GetCur_RankScore();
}
//添加教学成果成员
function Rtn_AddMemArray(type) {
    var addArray = [];
    var add_tr = $("#tb_Member tr");
    $(add_tr).each(function (i, n) {
        if ($(this).hasClass('memadd')) {
            var sub_m = new Object();
            sub_m.UserNo = $(this).attr('un');
            sub_m.Score = $(this).find('input[type=number]').val();            
            sub_m.Sort = i + 1;
            sub_m.CreateUID = loginUser.UniqueNo;
            addArray.push(sub_m);
        }        
    });
    return addArray;
}
//为业绩赋总分
function SetScore() {
    var objid = cur_AchieveType == "2" ? "#Sort" : "#Rid";
    var Score = Num_Fixed($(objid).find("option:selected").attr("ss"));
    achie_Score = Score;
    var ScoreType = $(objid).find("option:selected").attr("st");    
    $(".score").html("分数：" + Score + "分" + (ScoreType == "3" ? "/万字" : ""));
    if (cur_AchieveType == "3") { //教材建设类 
        if ($(objid).val() == "") { $('#span_BookScore').html(0); }
        else if (ScoreType == "2") { $('#span_BookScore').html(Num_Fixed(score_Words * Number(Score))); }
        else { $('#span_BookScore').html(Score); }
    }
    $span_AllScore = $('#span_AllScore');
    if ($span_AllScore) {
        $span_AllScore.html(Score);
    }
}
//获取当前业绩分数
function GetCur_RankScore() { 
    var newScore = 0;
    var $span_CurScore = $('#span_CurScore');
    $('#tb_Member tr:visible').each(function (i, n) {
        var c_score = $(this).find('input[type=number]').val();
        if (c_score) {
            newScore = numAdd(newScore, c_score);
        }
    });
    newScore = Num_Fixed(newScore);
    $span_CurScore.html(newScore);
    return newScore;
}
//成员分数变化时
function ChangeRankScore(obj) {  
    var subscore = 0;
    var warning = '';
    if (obj.value) {
        subscore = Num_Fixed(obj.value);
    } else {
        warning='请输入数字';       
    }      
    var newScore = GetCur_RankScore();       
    if (Number($('#span_AllScore').html()) < Number(newScore)) {
        warning += warning.length > 0 ? ',且已分配分数不能大于总分！' : '已分配分数不能大于总分！';
    } 
    if (warning) {
        layer.msg(warning); 
    }  
}
//获取当前成员奖金
function GetCur_UserMoney(objnum) { 
    var newMoney = 0;
    var $span_HasAllot = $('#span_HasAllot_' + objnum);
    $('#tb_Member_' + objnum + ' tr:visible').each(function (i, n) {
        var c_score = $(this).find('.td_money input[type=number]').val();
        if (c_score) {
            newMoney = numAdd(newMoney, c_score);
        }
    });
    newMoney = Num_Fixed(newMoney);
    $span_HasAllot.html(newMoney);
    return newMoney;
}
//成员奖金变化时
function Change_UserMoney(obj) {
    objnum = $(obj).parent().parent().parent().attr('id').replace('tb_Member_', '');
    var subscore = 0;
    var warning = '';
    if (obj.value) {
        subscore = Num_Fixed(obj.value);
    } else {
        warning = '请输入奖金';
    }
    var newMoney = GetCur_UserMoney(objnum);
    if (Number($('#span_AllMoney_' + objnum).html()) < Number(newMoney)) {
        warning += warning.length > 0 ? ',且已分配奖金不能大于总奖金！' : '已分配奖金不能大于总奖金！';
    }
    if (warning) {
        layer.msg(warning);
    }
}
/********************************************************业绩成员信息结束***************************************************/
/********************************************************业绩-作者信息开始***************************************************/
function Get_OperReward_UserInfo() {
    $("#tb_info").empty();
    if ($("#BookId").val() != "") {
        $.ajax({
            url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
            type: "post",
            dataType: "json",
            data: { "Func": "GetTPM_UserInfo", "IsPage": "false", BookId: $("#BookId").val() },
            success: function (json) {
                if (json.result.errMsg == "success") {
                    var booktype = $("#BookId").find("option:selected").attr("bt");
                    $('#ISBN').val(booktype==1?'无':$("#BookId").find("option:selected").attr("isbn"));
                    $("#tr_Info").tmpl(json.result.retData).appendTo("#tb_info");                   
                    GetAchieveUser_Score(json.result.retData);
                }
            },
            error: function () {
                //接口错误时需要执行的
            }
        });
    } else {
        $('#ISBN').val('');
    }
}
/********************************************************业绩-作者信息结束***************************************************/
function Get_AchieveStatus(status,obj) {
    switch (status) {
        case "0":
            $(obj).html("待提交");
            break;
        case "1":
            $(obj).html("信息待审核");
            break;
        case "2":
            $(obj).html("信息不通过");
            break;
        case "3":
            $(obj).html("分数待分配");
            break;
        case "4":
            $(obj).html(cur_ResponUID == $('#CreateUID').val() ? "分数待提交" : "分数待分配");
            break;
        case "5":
            $(obj).html("分数待审核");
            break;
        case "6":
            $(obj).html("分数不通过");
            break;
        case "7":
            $(obj).html("审核通过");
            break;
        case "8":
            $(obj).html("奖金待分配");
            break;
        case "9":
            $(obj).html(cur_ResponUID == $('#CreateUID').val() ? "奖金待提交" : "奖金待分配");
            break;
        case "10":
            $(obj).html("奖金待审核");
            break;
        case "11":
            $(obj).html("奖金不通过");
            break;
        case "12":
            $(obj).html("审核通过");
            break;
        default:
            $(obj).html("状态错误：" + this.Status);
    }
}

/********************************************************业绩-奖金分配开始***************************************************/
//绑定奖项奖金信息
function Get_RewardBatchData(reasonobj, no_status) {
    reasonobj = arguments[0] || "";
    no_status = arguments[1] || ""; //不赋值的状态    
    $("#div_MoneyInfo").empty();
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        data: { "Func": "Get_RewardBatchData", "IsPage": "false", AchieveId: cur_AchieveId},
        success: function (json) {
            if (json.result.errMsg == "success") {
                $("#div_item").tmpl(json.result.retData).appendTo("#div_MoneyInfo");
                if (reasonobj != "" && json.result.retData.length == 0) {
                    reasonobj.hide();
                } else {
                    var auditlist=json.result.retData.filter(function (item) { return item.AuditStatus==3 })//查找审核通过的奖项
                    if (reasonobj != "" && auditlist.length>0) {
                        reasonobj.show();                        
                        BindFile_Plugin("#uploader_reward", "#filePicker_reward", "#dndArea_reward");//原因显示以后，再绑定文件控件 
                    }
                    Get_AllotReward(no_status);
                    Bind_AllotFile();
                }               
            }           
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}
//获取分配奖金信息
function Get_AllotReward(no_status) {
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        data: { "Func": "Get_AllotReward", "IsPage": "false", AchieveId: cur_AchieveId, No_Status: no_status },
        success: function (json) {
            if (json.result.errMsg == "success") {
                $(json.result.retData).each(function (i, n) {
                    var $td_money = $("tbody[autid='" + n.Audit_Id + "'] tr[uid='" + n.RewardUser_Id + "']").find('.td_money');
                    if ($td_money.length) {
                        var $con_input = $td_money.find('input');
                        if ($con_input.length) {
                            $con_input.val(n.AllotMoney);
                            if (typeof ($con_input.attr("oldre")) != "undefined") {
                                $con_input.attr("oldre", n.AllotMoney);
                            }
                        } else {
                            $td_money.html(n.AllotMoney);
                        }
                    }                                     
                });
            }
            if (cur_AchieveType == 5) {
                $("#div_MoneyInfo tbody").each(function (i, n) {
                    var tb_rownum= n.id.replace("tb_Member_", '');
                    var audid = $(this).attr("autid");
                    if (audid==0){GetCur_UserMoney(tb_rownum);}                        
                });                
            }
        },
        error: function () {
            //接口错误时需要执行的
        }
    });
}
function Bind_AllotFile() {
    $("#div_MoneyInfo .allot_file").each(function (i, n) {
        var auditid = $(this).attr('auid');
        if (n.id.indexOf('uploader_') != -1) {
            var dndid = $(this).find('.photo_lists').attr('id');
            BindFile_Plugin("#" + n.id, "#" + $("#" + dndid).children().eq(0).attr('id'), "#" + dndid);
            if (parseInt(auditid) > 0) {
                Get_Sys_Document(4, auditid, "#" + n.id);
            }
        } else {
            Get_LookPage_Document(4, auditid, $("#" + n.id));
        }
    });
}
/********************************************************业绩-奖金分配结束***************************************************/
/********************************************************分配历史记录开始***************************************************/
//绑定分配历史记录
function Get_ModifyRecordData(modifyuid) {
    modifyuid = arguments[0] || "";
    $("#ul_Record").empty();
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        data: { "Func": "Get_ModifyRecordData", "IsPage": "false", Acheive_Id: cur_AchieveId, ModifyUID: modifyuid },
        success: function (json) {
            if (json.result.errMsg == "success") {
                $("#li_Record").tmpl(json.result.retData).appendTo("#ul_Record");
            } 
        },
        error: function () { }
    });
}
function OpenDetail(editResult, Reason_Id) {
    var filestr = '';
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
        type: "post",
        dataType: "json",
        data: { Func: "Get_Sys_Document", Type: 5, RelationId: Reason_Id, IsPage: false },
        success: function (json) {
            if (json.result.errNum == 0) {
                $(json.result.retData).each(function (i, n) {
                    filestr += '<li id="file_' + n.Id + '" pt="' + n.Url + '">' +
                                   '<p class="title1">' + n.Name + '</p>' +
                                 '<div class="file-panel">' +
                                        '<span class="preview" onclick="File_Viewer(\'' + n.Url + '\');">预览</span>' +
                                 '</div></li>';
                });
            }
            var content = '<div style="padding:10px 20px;"><div class="editResult">' + editResult + '</div><div class="status-left clearfix"><label for="" class="fl">附件：</label>'
           + '<div class="fl"><ul id="ul_HistoryFile" class="clearfix file-ary allot_file">' + filestr + '</ul></div></div></div>';
            layer.open({
                type: 1,
                title: '修改原因',
                area: ['420px', '240px'], //宽高
                content: content
            });
        }
    });
}
/********************************************************分配历史记录结束***************************************************/
/********************************************************业绩-业绩类别、奖励项目、删除业绩开始***************************************************/
function Bind_SelAchieve() {
            $("#AcheiveType").html('<option value="">全部</option>');
            $.ajax({
                url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
                type: "post",
                dataType: "json",
                data: { "Func": "GetAcheiveLevelData", "IsPage": "false", "Pid": "0" },
                success: function (json) {
                    if (json.result.errMsg == "success") {
                        $.each(json.result.retData, function () {
                            $("#AcheiveType").append('<option value=' + this.Id + '>' + this.Name + '</option>');
                        });
                    }
                    Bind_SelGInfo();
                },
                error: function () {}
            });
}
//奖励项目
function Bind_SelGInfo() {
    $("#Gid").html('<option value="">全部</option>');
    $.ajax({
        url: HanderServiceUrl + "/TeaAchManage/AchManage.ashx",
        type: "post",
        dataType: "json",
        data: { "Func": "GetAcheiveLevelData", "IsPage": "false", "Pid": $("#AcheiveType").val() },
        success: function (json) {
            if (json.result.errMsg == "success") {
                $(json.result.retData).each(function () {
                    $("#Gid").append('<option value="' + this.Id + '">' + this.Name + '</option>');
                });
            }
            BindData(1, 10);
        },
        error: function () { }
    });
}
//删除业绩
function Del_Achieve(id) {
    layer.confirm('确定删除该业绩吗？', {
        btn: ['确定', '取消'],
        title: '操作'
    }, function (index) {
        $.ajax({
            url: HanderServiceUrl + "/TeaAchManage/AchRewardInfo.ashx",
            type: "post",
            async: false,
            dataType: "json",
            data: { Func: "DelAcheiveRewardInfo", ItemId: id },
            success: function (json) {
                if (json.result.errNum == 0) {
                    layer.msg('操作成功!');
                    BindData(1, 10);
                }
            },
            error: function () { }
        });
    }, function () { });
}
/********************************************************业绩-业绩类别、奖励项目、删除业绩结束***************************************************/
