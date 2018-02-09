<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllotPeople.aspx.cs" Inherits="FEWeb.SysSettings.AllotPeople" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>用户管理</title>
    <link rel="stylesheet" href="../css/reset.css" />
    <link rel="stylesheet" href="../css/layout.css" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>

</head>

<%--开课单位--%>
<script type="text/x-jquery-tmpl" id="item_College">
    <option value="${Id}">${College_Name}</option>
</script>
<%--Roleid ==  CurrentRoleid--%>
<script type="text/x-jquery-tmpl" id="itemData">
    <tr  >
        {{if isHasElement (RoleList,CurrentRoleid) >-1 }}
           <td>
               <input  type='checkbox' uniqueno="${UniqueNo}" name='se' checked="checked" /></td>
        {{else}}
         <td>
             <input type='checkbox' uniqueno="${UniqueNo}" name='se' /></td>
        {{/if}}
        <td>${UniqueNo}</td>
        <td>${Name} </td>
        <td>${Sex} </td>
        <td>${TeacherBirthday} </td>
        <td>${TeacherSchooldate} </td>

        <td>${MajorName}  </td>
        <td>${SubDepartmentName}  </td>
        <td>${Status} </td>
    </tr>
</script>


<body>
    <div class="main">
        <div class="search_toobar clearfix">
            <div class="fl">
                <label for="" class="fl">当前选择角色:</label>
                <span style="line-height: 35px; margin-left: 10px; display: inline-block; color: #6a264b" class="fl" id="rolenametext">学生</span>
            </div>
            <div class="fr">
                <div class="fl ml10">
                    <label for="">部门：</label>
                    <select class="select" id="college" style="width: 178px">
                        <option value="">全部</option>
                    </select>
                </div>


                <%--href="javascript:search();"--%>
                <div class="fl ml10">
                    <input type="text" name="key" id="key" placeholder="请输入教职工号或者姓名关键字" value="" style="width: 220px" class="text fl">
                    <a class="search fl" href="javascript:search();" onclick="SelectByWhere()"><i class="iconfont">&#xe600;</i></a>
                </div>
            </div>
        </div>
        <%--出生年月  教学日期   部门  子部门  教师状态--%>
        <div class="table">
            <table>
                <thead>
                    <tr>
                        <th style="text-align: center; width: 40px;">
                            <input type="checkbox" id="cb_all" onclick="Check_All()" />
                        </th>
                        <th>教职工号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>年龄</th>
                        <th>校龄</th>
                        <th>部门</th>
                        <th>子部门</th>
                        <th>教师状态</th>
                    </tr>
                </thead>
                <tbody id="tb_indicator">
                </tbody>
            </table>
            <div id="test1" class="pagination"></div>
        </div>
    </div>
    <div class="btnwrap">
        <input type="button" value="确定" class="btn" onclick="SubmitUserinfo()" />
        <input type="button" value="取消" class="btna" onclick="quxiao()" />
    </div>

</body>
</html>
<script src="../Scripts/Common.js"></script>
<script src="../scripts/public.js"></script>
<script src="../Scripts/linq.min.js"></script>
<script src="../Scripts/layer/layer.js"></script>
<script src="../Scripts/jquery.tmpl.js"></script>
<link href="../Scripts/kkPage/Css.css" rel="stylesheet" />
<script src="../Scripts/kkPage/jquery.kkPages.js"></script>
<link href="../Scripts/pagination/pagination.css" rel="stylesheet" />
<script src="../Scripts/pagination/jquery.pagination.js"></script>
<script src="../Scripts/WebCenter/AllotPeople.js"></script>
<script>

    var CurrentRoleid = getQueryString('CurrentRoleid');
    var CurrentRoleName = getQueryString('CurrentRoleName');
    var DepartmentID = getQueryString('DepartmentID');
    var DepartmentName = login_User.DepartmentName;
    //从子窗体筛选之后获取的数据【未处理】
    var reUserinfoAll = [];


    var index = parent.layer.getFrameIndex(window.name);
    //从子窗体获取相关角色已有的用户
    var reUserinfoByselect_uniques = [];
    //选中的用户
    var select_uniques = [];
    //绑定的数据【UI】
    var reUserinfoByselect;
    //从子窗体筛选之后获取的数据【已处理】
    var selectreUserinfoAll;
    var roleid = 3;

    var pageIndex = 0;
    var pageSize = 10;
    var pageCount;

    var IsAll_Select = false;


    //-----------初始化--------------------------------------------------------------------------------------
    $(function () {

        GetTeachers_NewCompleate = function () {
            UI_Allot.prepare_init();
            UI_Allot.data_init(roleid);
            UI_Allot.PageType = 'AllotPeople';
          
            if (DepartmentID != '' && DepartmentID != null && DepartmentID != undefined) {
                var obj = { Id: DepartmentID, College_Name: DepartmentName };
                $("#college").empty();
                $("#item_College").tmpl(obj).appendTo("#college");

                UI_Allot.all_change();
            }
            else {
                UI_Allot.GetProfessInfo();
            }

        };
        GetTeachers_New();


        UI_Allot.SubmitUserinfo_Compleate = function (result) {
            if (result) {
                parent.layer.msg('分配成功');
                parent.Reflesh();
                parent.layer.close(index);
            }
            else {
                alert("分配失败");
                parent.layer.close(index);
            }
        };
      
    })

    //-----------提交信息---------------------------------------------------------------------------------------  
    function SubmitUserinfo() {
        IsMutexCompleate = function (data) {
            if (!data.IsMutex) {
                var info = '';
                for (var i = 0; i < data.inf.length; i++) {
                    var obj = data.inf[i];
                    info += obj.UserName + "已分配在" + obj.RoleName + ";"
                }
                IsMutexCombine = true;
                layer.confirm(info + '确定重新分配到' + $('#rolenametext').text() + '吗？', {
                    btn: ['确定', '取消'], //按钮
                    title: '操作'
                }, function () { UI_Allot.SubmitUserinfo(); });

            }
            else {
                
                UI_Allot.SubmitUserinfo();
            }
        };
        IsMutex();
    }
    //-----------取消---------------------------------------------------------------------------------------
    function quxiao() {
        parent.layer.close(index);
    }
    //-----------搜索---------------------------------------------------------------------------------------
    function SelectByWhere() {
        UI_Allot.all_change();
    }

    function Check_All() {
        UI_Allot.Check_All();
    }
</script>

