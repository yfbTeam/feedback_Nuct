/// <reference path="../public.js" />
/// <reference path="../layer/layer.js" />
/// <reference path="../jquery-1.11.2.min.js" />
/// <reference path="../public.js" />
/// <reference path="../Common.js" />
var DPList = [];
var ClsList = [];
var UI_Power =
    {
        PageType: 'Power',  //Power用户组管理


        CurrentRoleid: null,
        CurrentRoleName: '',


        CurrentRoleid: null,
        CurrentRoleName: '',

        num: function () {
            return pageNum++;
        },

        BeginInit: function () {

            UI_Power.GetUserinfoCompleate = function () {
                UI_Power.BindDataTo_GetUserinfo(UI_Power.CurrentRoleid, UI_Power.CurrentRoleName);
            }

            //显示用户组
            UI_Power.ShowUserGroup();
            //获取用户信息
            UI_Power.GetUserinfo();
            //获取学生
            UI_Power.GetStudents();
            //获取教师
            UI_Power.GetTeachers();


            $('#ShowUserGroup').find('li[roleid=' + UI_Power.CurrentRoleid + ']').trigger("click");     

            $('#ShowUserGroup').find('li[roleid=' + UI_Power.CurrentRoleid + ']').trigger("click");

        },

        //显示用户组
        ShowUserGroup: function () {
            var that = this;
            var postData = { func: "Get_UserGroup" };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                async: true,
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        $('#ShowUserGroup').empty();
                        var lists = returnVal.result.retData;
                        if (lists != null && lists.length > 0) {
                            $('#li_role').tmpl(lists).appendTo('#ShowUserGroup');
                            $('#header_stu').tmpl(1).appendTo('#header_th');
                            $('.menu_lists li:eq(0)').addClass('selected');


                            that.CurrentRoleid = lists[0].RoleId;
                            that.CurrentRoleName = lists[0].RoleName;


                            that.CurrentRoleid = lists[0].RoleId;
                            that.CurrentRoleName = lists[0].RoleName;

                            $('.menu_lists li').click(function () {
                                $(this).addClass('selected').siblings().removeClass('selected');

                                $('#header_th').empty();

                                if (UI_Power.CurrentRoleid == 2) {
                                    $('#header_stu').tmpl(1).appendTo('#header_th');                                   
                                }
                                else {
                                    $('#header_tea').tmpl(1).appendTo('#header_th');                                   
                                }
                            })
                            tableSlide();
                        }
                    }
                },
                error: function (errMsg) {
                    alert("失败2");
                }
            });
        },
        ShowUserGroup_Compleate: function () { },
        //供子窗体使用
        GetCurrentRoleid: function () {
            return UI_Power.CurrentRoleid;
        },
        //供子窗体使用
        GetCurrentRoleName: function () {
            return UI_Power.CurrentRoleName;
        },


        //获取用户信息
        GetUserinfo: function () {

            layer_index = layer.load(1, {
                shade: [0.1, '#fff'],   //0.1透明度的白色背景        

            });

            var postData = { func: "Get_UserInfo_List" };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        reUserinfo = returnVal.result.retData.MainData;
                        DPList = returnVal.result.retData.DPList;
                        ClsList = returnVal.result.retData.ClsList;

                        debugger;
                        $("#item_College").tmpl(DPList).appendTo($('#college'));
                        $("#item_Class").tmpl(ClsList).appendTo($('#class'));
                        ChosenInit($('#class'));
                        ChosenInit($('#college'));

                        $('#college').on('change', function () {
                            $('#class').empty();
                            $("#class").append("<option value=''>全部</option>");
                            var colloge = $('#college').val();
                            if (colloge != '') {
                                var list = ClsList.filter(function (item) { return item.Major_ID == colloge });
                                $("#item_Class").tmpl(list).appendTo($('#class'));
                            }
                            else {
                                $("#item_Class").tmpl(ClsList).appendTo($('#class'));

                            }
                            ChosenInit($('#class'));

                            SelectByWhere();
                        });

                        $('#class').on('change', function () {
                            SelectByWhere();
                        });

                        UI_Power.GetUserinfoCompleate();
                    }
                    layer.close(layer_index);

                },
                error: function (errMsg) {

                }
            });
        },
        GetUserinfoCompleate: function () {

            UI_Power.BindDataTo_GetUserinfo(this.CurrentRoleid, this.CurrentRoleName);
        },
        //绑定用户信息
        BindDataTo_GetUserinfo: function (RoleId, RoleName) {

            UI_Power.CurrentRoleName = RoleName;
            UI_Power.CurrentRoleid = RoleId;

            //教师不可进行分配人员
            if (UI_Power.CurrentRoleid == 3) {               
                $('#allot').hide();
                $('#allotlimit').show();            
            }
            else if (UI_Power.CurrentRoleid == 2) {
                $('#allot,#allotlimit').hide();             
            }
            else {
                $('#allot,#allotlimit').show();
            }

            if (UI_Power.CurrentRoleid == 2) {
                $('#div_Class,#div_Unit').show();
            }
            else {
                $('#div_Class').hide();
                $('#div_Unit').show();
            }

            reUserinfoByselect = Enumerable.From(reUserinfo).Where("x=>x.Roleid=='" + RoleId + "'").ToArray();
            pageCount = reUserinfoByselect.length;
            UI_Power.fenye(pageCount);
        },
        fenye: function (pageCount) {
            $("#test1").pagination(pageCount, {
                callback: UI_Power.PageCallback,
                prev_text: '上一页',
                next_text: '下一页',
                items_per_page: pageSize,
                num_display_entries: 4,//连续分页主体部分分页条目数
                current_page: pageIndex,//当前页索引
                num_edge_entries: 1//两侧首尾分页条目数
            });
        },
        initclear: function (index, arrRes) {
            $("#ShowUserInfo").html('');
            if (reUserinfoByselect.length < pageSize) {
                $('.pagination').hide();
            }
            else {
                $('.pagination').show();
            }
            if (arrRes.length == 0) {
                nomessage('#ShowUserInfo');
                return;
            }
            if (index == 0) {
                pageNum = 1;
            }
            else {
                pageNum = pageSize * (index + 1) + 1;
            }

          
            if (UI_Power.CurrentRoleid == 2) {
                $('#item_tr_stu').tmpl(arrRes).appendTo('#ShowUserInfo');
            }
            else {
                $('#item_tr').tmpl(arrRes).appendTo('#ShowUserInfo');
            }

        },
        //翻页调用
        PageCallback: function (index, jq) {
            var arrRes = Enumerable.From(reUserinfoByselect).Skip(index * pageSize).Take(pageSize).ToArray();
            UI_Power.initclear(index, arrRes);
        },
        PowerAssign: function () {
            if (UI_Power.CurrentRoleid != null) {
                OpenIFrameWindow('权限分配', 'PowerAssign.aspx?type=' + UI_Power.CurrentRoleid + '', '600px', '500px')
            }
        },
        //搜索
        SelectByWhere: function () {
            var sw = $("#select_where").val();

            allDataMain_select = reUserinfoByselect.filter(function (item) { return item.Name.indexOf(sw) != -1 || item.UniqueNo.indexOf(sw) != -1 });

            var colloge = $('#college').val();
            if (colloge != "") {
                allDataMain_select = allDataMain_select.filter(function (item) { return item.Major_ID == colloge });
            }
            var cls = $('#class').val();
            if (cls != "") {
                allDataMain_select = allDataMain_select.filter(function (item) { return item.ClassID == cls });
            }

            $("#test1").pagination(allDataMain_select.length, {
                callback: function (index, jq) {
                    var arrRes = Enumerable.From(allDataMain_select).Skip(index * pageSize).Take(pageSize).ToArray();
                    UI_Power.initclear(index, arrRes);
                },
                prev_text: '上一页',
                next_text: '下一页',
                items_per_page: pageSize,
                num_display_entries: 4,//连续分页主体部分分页条目数
                current_page: pageIndex,//当前页索引
                num_edge_entries: 1//两侧首尾分页条目数
            });
        },
     
        get_teachers: function () {
            return teachers;

        },
      
        GetTeachers: function () {

            var postData = { func: "GetTeachers" };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        teachers = returnVal.result.retData;
                        for (var i = 0; i < teachers.length; i++) {
                            allDataMain.push(teachers[i]);
                            allDataMain_select.push(teachers[i]);
                        }
                    }
                },
                error: function (errMsg) {
                }
            });
        },

        GetStudentsCompleate: function () { },
        //-----------获取学生、教师---------------------------------------------------------------------------------------
        GetStudents: function () {
            var postData = { func: "GetStudents" };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        students = returnVal.result.retData;
                        students = Enumerable.From(students).OrderBy(function (item) { return pinyinUtil.getFirstLetter(item.Name, ' ', true, false); }).ToArray();

                        for (var i = 0; i < students.length; i++) {
                            allDataMain.push(students[i]);

                            allDataMain_select.push(students[i]);
                        }
                        UI_Power.GetStudentsCompleate();
                    }
                },
                error: function (errMsg) {
                }
            });
        },

        //-----//获取用户信息[配合子窗体]-------------------------------------------------------------------------      
        GetUserinfo_Select: function () {

            allDataMain = [];
            allDataMain_select = []
            other_data_otherRole = []
            other_data_otherRole = []

            UI_Power.ShowUserGroup();
            UI_Power.GetTeachers();
            UI_Power.GetStudents();
            //获取用户信息
            UI_Power.GetUserinfo();

        },

        remove: function (Id) {
            layer.confirm('确定要删除？', {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function () {
                var postData = { func: "Ope_UserGourp", Type: 3, Id: Id, UniqueNo: cookie_Userinfo.UniqueNo };
                $.ajax({
                    type: "Post",
                    url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                    data: postData,
                    dataType: "json",
                    success: function (returnVal) {
                        if (returnVal.result.errMsg == "success") {
                            layer.msg('操作成功!');
                            UI_Power.remove_Compleate();
                        }
                        else {
                            layer.msg(returnVal.result.errMsg);
                        }
                        layer.close();
                    },
                    error: function (errMsg) {
                    }
                });
            });

        },
        remove_Compleate: function () { },
        Edit: function (Id, Name) {

            var postData = { func: "Ope_UserGourp", Type: 2, Id: Id, Name: Name, UniqueNo: cookie_Userinfo.UniqueNo };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        UI_Power.Edit_Compleate();
                    }
                },
                error: function (errMsg) {
                }
            });
        },
        Edit_Compleate: function () { },
        Add: function (Name) {

            var postData = { func: "Ope_UserGourp", Type: 1, Name: Name, UniqueNo: cookie_Userinfo.UniqueNo };
            $.ajax({
                type: "Post",
                url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                data: postData,
                dataType: "json",
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        UI_Power.Add_Compleate();
                    }
                },
                error: function (errMsg) {
                }
            });
        },
        Add_Compleate: function () { },

        Save: function () {
            sessionStorage.setItem('UI_Power', JSON.stringify(UI_Power));
        },
        Get: function () {
            var data = JSON.parse(sessionStorage.getItem('UI_Power'));
            UI_Power.CurrentRoleid = data.CurrentRoleid;
            UI_Power.CurrentRoleName = data.CurrentRoleName;
            UI_Power.Type = data.Type;
        },

    };

