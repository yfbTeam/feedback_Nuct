﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Power.aspx.cs" Inherits="FEWeb.SysSettings.Power" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>权限分配</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .menu .menu_lists li {
            position: relative;
        }

            .menu .menu_lists li .operates {
                position: absolute;
                right: 10px;
                top: 8px;
                line-height: 22px;
                z-index: 11;
            }


        .search_toobar .text {
            margin-top: 1px;
        }

        .search_toobar .search {
            margin-top: 1px;
        }
    </style>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">

            <div class="sortwrap clearfix">
                <div class="menu fl">
                    <h1 class="titlea">用户组管理
                    </h1>
                    <ul class="menu_lists" id="ShowUserGroup" style="height: 510px; overflow: auto;">
                    </ul>

                </div>
                <div class="sort_right fr">
                    <div class="search_toobar clearfix">
                        <div id="div_Unit" class=" fl">
                            <label style="min-width: 20px">部门：</label>
                            <select class="select" id="college" style="width: 190px">
                                <option value="">全部</option>
                            </select>
                        </div>
                        <div id="div_Class" class="ml10 fl">
                            <label>班级：</label>
                            <select class="select" id="class" style="width: 178px;">
                                <option value="">全部</option>
                            </select>
                        </div>

                        <div class="fl ml10">
                            <input type="text" name="" id="key" placeholder="请输入学号或者姓名关键字" value="" style="width: 220px" class="text fl">
                            <a class="search fl" href="javascript:;" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                        </div>
                        <div class="fr" id="btnpanel">
                        </div>
                    </div>
                    <div class="table">
                        <table id="fenyeShowUserInfo">
                            <thead id="header_th">
                            </thead>
                            <tbody id="ShowUserInfo">
                            </tbody>
                        </table>
                    </div>
                    <div id="pageBar" class="page"></div>
                </div>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/linq.js"></script>
    <script src="../Scripts/pinying/pinyin_dict_firstletter.js"></script>
    <script src="../Scripts/pinying/pinyin_dict_notone.js"></script>
    <script src="../Scripts/pinying/pinyin_dict_polyphone.js"></script>
    <script src="../Scripts/pinying/pinyin_dict_withtone.js"></script>
    <script src="../Scripts/pinying/pinyinUtil.js"></script>

    <link href="../Scripts/choosen/prism.css" rel="stylesheet" />
    <link href="../Scripts/choosen/chosen.css" rel="stylesheet" />
    <script src="../Scripts/choosen/chosen.jquery.js"></script>
    <script src="../Scripts/choosen/prism.js"></script>

    <link href="../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../Scripts/pagination/jquery.pagination.js"></script>
    <script src="../Scripts/WebCenter/Power.js"></script>
    <script src="../Scripts/laypage/laypage.js"></script>

    <script type="text/x-jquery-tmpl" id="item_tr">
        <tr>
            <td>${Num}</td>
            <td>${UniqueNo}</td>
            <td>${Name}</td>
            {{if Sex == 0}}
          <td>男 </td>
            {{else}}
         <td>女 </td>
            {{/if}}

            <td>${TeacherBirthday}</td>
            <td>${TeacherSchooldate}</td>

            <td>${DepartmentName}</td>
            <td>${SubDepartmentName}</td>
            <td>${Status}</td>
            {{if CurrentRoleid!=3}}
            <td>
                <div class="operate" onclick="Remove_RoleUser(${RoleUser_Id});">
                     <i class="iconfont color_purple">&#xe798;</i>
                     <span class="operate_none bg_purple" style="display: none;">移除      
                     </span>
                 </div>
            </td>
            {{/if}}
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="item_tr_stu">
        <tr>
            <td>${Num}</td>
            <td>${UniqueNo}</td>
            <td>${Name}</td>
            {{if Sex == 0}}
          <td>男 </td>
            {{else}}
         <td>女 </td>
            {{/if}}
            <td>${DepartmentName}</td>
            <td>${SubDepartmentName}</td>
            <td>${ClassName}</td>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>

    <script type="text/x-jquery-tmpl" id="li_role">
        {{if all || rid ==1}}
        <li roleid="${RoleId}" rolename="${RoleName}" onclick="BindDataTo_GetUserinfo(${RoleId},'${RoleName}');">
            <em title="${RoleName}">${RoleName}</em>

            {{if Solid ==0}}
            <div class="operates">
                <div class="operate">
                    <i class="iconfont color_purple">&#xe62b;</i>
                </div>
            </div>
            {{else}}
            <div class="operates">
                <div class="operate" onclick="Group_User_Add(2,'${RoleId}','${RoleName}');">
                    <i class="iconfont color_purple">&#xe632;</i>
                    <a class='operate_none bg_purple'>设置</a>
                </div>
                <div class="operate ml5" onclick="remove(${RoleId});">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <a class='operate_none bg_purple'>删除</a>
                </div>
            </div>
            {{/if}}            
        </li>
        {{else department  && (RoleId ==2 || RoleId ==3|| RoleId ==16)}}
         <li roleid="${RoleId}" rolename="${RoleName}" onclick="BindDataTo_GetUserinfo(${RoleId},'${RoleName}');">
             <em title="${RoleName}">${RoleName}</em>
         </li>

        {{else school && (RoleId ==2 || RoleId ==3|| RoleId ==17) }}
         <li roleid="${RoleId}" rolename="${RoleName}" onclick="BindDataTo_GetUserinfo(${RoleId},'${RoleName}');">
             <em title="${RoleName}">${RoleName}</em>
         </li>
        {{else RoleId ==2 || RoleId ==3}}        
         <li roleid="${RoleId}" rolename="${RoleName}" onclick="BindDataTo_GetUserinfo(${RoleId},'${RoleName}');">
             <em title="${RoleName}">${RoleName}</em>
         </li>

        {{/if}} 
    </script>

    <script type="text/x-jquery-tmpl" id="item_College">
        <option value="${Major_ID}">${DepartmentName}</option>
    </script>

    <script type="text/x-jquery-tmpl" id="item_Class">
        <option value="${ClassID}">${ClassName}</option>
    </script>

    <script type="text/x-jquery-tmpl" id="header_stu">
        <tr>
            <th style="width: 5%">序号	</th>
            <th style="width: 15%">学号</th>
            <th style="width: 10%">姓名</th>
            <th style="width: 10%">性别</th>
            <th style="width: 25%">部门</th>
            <th style="width: 25%">子部门</th>
            <th style="width: 10%">班级</th>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="header_tea">
        <tr>
            <th style="width: 5%">序号</th>
            <th style="width: 15%">教职工号</th>
            <th style="width: 10%">姓名</th>
            <th style="width: 6%">性别</th>
            <th style="width: 6%">年龄</th>
            <th style="width: 6%">校龄</th>
            <th style="width: 18%">部门</th>
            <th style="width: 18%">子部门</th>
            <th style="width: 8%">教师状态</th>
            <th style="width:6%;display:none;" class="tea_operate">操作</th>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="btnitem1">
        {{if all || rid ==1}}
        <input type="button" name="" id="allotlimit" value="权限分配" class="btn" onclick="PowerAssign();">
        {{else}}
        {{/if}} 
    </script>

    <script type="text/x-jquery-tmpl" id="btnadditem">
        {{if all || rid ==1}}
        <input type="button" value="新增用户组管理" class="new" onclick="Group_User_Add(1);" />
        {{else}}
        {{/if}} 
    </script>

    <script type="text/x-jquery-tmpl" id="btnitem2">
        <input type="button" name="" id="allot" value="分配人员" class="btn ml10" onclick="allotpeople()">
    </script>

    <script>
        var colloge = '';
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            limitreflesh();
            ShowUserGroup();

            Get_UserByRole_SelectCompleate = function () {
                departmentreflesh();
                $('#college').on('change', function () {
                    departmentreflesh();
                    BindDataTo_GetUserinfo(CurrentRoleid, CurrentRoleName);
                });

                $('#class').on('change', function () {
                    pageIndex = 0;
                    BindDataTo_GetUserinfo(CurrentRoleid, CurrentRoleName);
                });

                $('#ShowUserGroup').find('li[roleid=' + CurrentRoleid + ']').trigger("click");
            };
            Get_UserByRole_Select();


        })

        function departmentreflesh() {
            pageIndex = 0;
            $('#class').empty();
            $("#class").append("<option value=''>全部</option>");
            colloge = $('#college').val();

            if (colloge != '') {
                var list = ClsList.filter(function (item) { return item.Major_ID == colloge });
                $("#item_Class").tmpl(list).appendTo($('#class'));
            }
            else {
                $("#item_Class").tmpl(ClsList).appendTo($('#class'));
            }
            ChosenInit($('#class'));

        }

        //搜索
        function SelectByWhere() {
            pageIndex = 0;
            BindDataTo_GetUserinfo(CurrentRoleid, CurrentRoleName);
        }

        var pageIndex = 0;
        //添加用户组
        function Group_User_Add(type, RoleId, RoleName) {
            switch (type) {
                case 1:
                    OpenIFrameWindow('新增用户组', 'Group_User_Add.aspx', '550px', '260px');
                    break;
                case 2:
                    BindDataTo_GetUserinfo(RoleId, RoleName);
                    OpenIFrameWindow('编辑用户组', 'Group_User_Add.aspx?type=' + type + '&CurrentRoleid=' + CurrentRoleid + '&CurrentRoleName=' + CurrentRoleName, '550px', '260px')
                    break;
                default:
            }
        }
        function remove(Id) {
            Ope_UserGourp_Compleate = function () {
                ShowUserGroup();
            };
            Ope_UserGourp(Id, '', 3);
        }
        function PowerAssign() {
            if (CurrentRoleid != null) {
                OpenIFrameWindow('权限分配', 'PowerAssign.aspx?type=' + CurrentRoleid + '', '600px', '500px')
            }
        };

        function Reflesh() {
            pageIndex = 0;
            BindDataTo_GetUserinfo(CurrentRoleid, CurrentRoleName);
        }

        //绑定用户信息
        function BindDataTo_GetUserinfo(RoleId, RoleName) {

            CurrentRoleName = RoleName;
            CurrentRoleid = RoleId;

            $('#header_th').empty();
            if (CurrentRoleid == 2) {
                $('#header_stu').tmpl(1).appendTo('#header_th');
                $('#key').prop('placeholder', '请输入学号或者姓名关键字');
            }
            else {
                $('#header_tea').tmpl(1).appendTo('#header_th');
                $('#key').prop('placeholder', '请输入教职工号或者姓名关键字');
            }
            $('#btnpanel').empty();
            //教师不可进行分配人员
            if (CurrentRoleid == 3) {
                $("#btnitem1").tmpl(1).appendTo('#btnpanel');
                $('#div_Class').hide();
                $('#div_Unit').show();
                $("#header_th th.tea_operate").hide();
            }
            else if (CurrentRoleid == 2) {
                $('#div_Class,#div_Unit').show();
            }
            else {
                $("#btnitem1").tmpl(1).appendTo('#btnpanel');
                $("#btnitem2").tmpl(1).appendTo('#btnpanel');
                $('#div_Unit').show();
                $('#div_Class').hide();
                $("#header_th th.tea_operate").show();
            }
            pageIndex = 0;
            Get_UserByRoleID(pageIndex);
        };

        function allotpeople() {
            if (department && rid != 1) {
                OpenIFrameWindow('分配人员', 'AllotPeople.aspx?CurrentRoleid=' + CurrentRoleid + '&CurrentRoleName=' + CurrentRoleName + '&DepartmentID=' + login_User.Major_ID, '1000px', '700px')
            }
            else {
                OpenIFrameWindow('分配人员', 'AllotPeople.aspx?CurrentRoleid=' + CurrentRoleid + '&CurrentRoleName=' + CurrentRoleName, '1000px', '700px')
            }
        }
        function limitreflesh() {
            Get_PageBtn("/SysSettings/Power.aspx");
            department = JudgeBtn_IsExist("department");
            school = JudgeBtn_IsExist("school");
            all = JudgeBtn_IsExist("all");

            rid = login_User.Sys_Role_Id;
        }
        function Remove_RoleUser(roleuser_id) { //删除角色成员
            layer.confirm('确认要把该用户移出？', {
                btn: ['确定', '取消'],
                title: '操作'
            }, function (index) {
                $.ajax({
                    url: HanderServiceUrl + "/UserMan/UserManHandler.ashx",
                    type: "post",
                    async: false,
                    dataType: "json",
                    data: { Func: "Remove_RoleUser", RoleUser_Id: roleuser_id },
                    success: function (json) {
                        if (json.result.errNum == 0) {
                            layer.msg('操作成功!');
                            Get_UserByRoleID(0);
                        } else {
                            layer.msg(json.result.errMsg);
                        }
                    },
                    error: function () { }
                });
            }, function () { });
        }
    </script>

</body>
</html>
