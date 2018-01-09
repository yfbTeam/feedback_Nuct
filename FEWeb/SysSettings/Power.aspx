<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Power.aspx.cs" Inherits="FEWeb.SysSettings.Power" %>

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
                    <ul class="menu_lists" id="ShowUserGroup">
                    </ul>
                    <input type="button" value="新增用户组管理" class="new" onclick="Group_User_Add(1);" />
                </div>
                <div class="sort_right fr">
                    <div class="search_toobar clearfix">
                        <div id="div_Unit" class=" fl">
                            <label style="min-width: 20px">所属院(系、部)：</label>
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
                            <input type="text" name="" id="select_where" placeholder="请输入用户名" value="" class="text fl">
                            <a class="search fl" href="javascript:;" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                        </div>
                        <div class="fr" id="">
                            <input type="button" name="" id="allotlimit" value="权限分配" class="btn" onclick="PowerAssign();" style="display: none;">
                            <input type="button" name="" id="allot" value="分配人员" class="btn ml10" onclick="OpenIFrameWindow('分配人员', 'AllotPeople.aspx', '1000px', '700px')" style="display: none;">
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
                    <div id="test1" class="pagination"></div>
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

    <script type="text/x-jquery-tmpl" id="item_tr">
        <tr>
            <td >${num()}</td>
            <td >${UniqueNo}</td>
            <td >${Name}</td>
            <td >${Sex}</td>
            <td >${DepartmentName}</td>
            <td >${SubDepartmentName}</td>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="item_tr_stu">
        <tr>
            <td >${num()}</td>
            <td >${UniqueNo}</td>
            <td >${Name}</td>
            <td >${Sex}</td>
            <td >${DepartmentName}</td>
            <td >${SubDepartmentName}</td>
            <td >${ClassName}</td>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="li_role">
        <li roleid="${RoleId}" rolename="${RoleName}" onclick="BindDataTo_GetUserinfo(${RoleId},'${RoleName}');">
            <em title="${RoleName}">${RoleName}</em>

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

        </li>
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
            <th style="width: 10%">用户名</th>
            <th style="width: 10%">性别</th>
            <th style="width: 25%">部门</th>
            <th style="width: 25%">子部门</th>
            <th style="width: 10%">班级</th>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="header_tea">
        <tr>
            <th style="width: 5%">序号	</th>
            <th style="width: 15%">教职工号</th>
            <th style="width: 10%">用户名</th>
            <th style="width: 10%">性别</th>
            <th style="width: 30%">部门</th>
            <th style="width: 30%">子部门</th>
        </tr>
    </script>

    <script>
        var reUserinfo,
            //点击选中的用户数据
            reUserinfoByselect,
            pageNum = 1,
            pageIndex = 0,
            pageSize = 10,
            pageCount,
            students,
            teachers,
            allDataMain = [],
            allDataMain_select = [],
            other_data_otherRole = [];

        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
           
            UI_Power.BeginInit();
        })

        function num() {
            return UI_Power.num();
        }
        //绑定用户信息
        function BindDataTo_GetUserinfo(RoleId, RoleName) {

            UI_Power.BindDataTo_GetUserinfo(RoleId, RoleName);
        }

        function PowerAssign() {
            UI_Power.PowerAssign();
        }
        //搜索
        function SelectByWhere() {
            UI_Power.SelectByWhere();
        }

        function get_reUserinfoByselect_Ids() {
            var UniqueNos = [];
            reUserinfoByselect.forEach(function (item) { UniqueNos.push(item.UniqueNo) });
            return UniqueNos;
        }

        //供子窗体使用
        function get_teachers() {
            return UI_Power.get_teachers();
        }
        //供子窗体使用
        function GetCurrentRoleid() {
            return UI_Power.GetCurrentRoleid();
        }
        //供子窗体使用
        function GetCurrentRoleName() {
            return UI_Power.GetCurrentRoleName();
        }
        //-----//获取用户信息[配合子窗体]-------------------------------------------------------------------------    

        function SelectGourp_Init() {
            UI_Power.GetUserinfo_Select();
        }

        //添加用户组
        function Group_User_Add(type, RoleId, RoleName) {
            switch (type) {
                case 1:
                    OpenIFrameWindow('新增用户组', 'Group_User_Add.aspx?type=' + type, '550px', '260px');
                    break;
                case 2:

                    BindDataTo_GetUserinfo(RoleId, RoleName);
                    UI_Power.Save();
                    OpenIFrameWindow('编辑用户组', 'Group_User_Add.aspx?type=' + type, '550px', '260px')
                    break;
                default:
            }
        }

        function remove(Id) {
            UI_Power.remove_Compleate = function () {
                SelectGourp_Init();
            };
            UI_Power.remove(Id);
        }
    </script>

</body>
</html>
