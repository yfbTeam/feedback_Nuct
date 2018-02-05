<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeaRegEval_Single.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.TeaRegEval_Single" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价查看</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix" id="courseEvalSee">
            <div class="sort_nav" id="threenav">
            </div>

            <h1 class="title mb10" >
                 <div style="width: 1170px;cursor:pointer;  z-index: 99; background: #fff;  padding: 10px 0px;">
                <div class="crumbs">
                    <a onclick="window.location.href='indexqcode.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')" >课堂扫码评价</a>
                    <span>&gt;</span>
                    <a href="javascript:;" style="cursor:pointer;" onclick="window.location=window.location.href"  id="couse_name">详情</a>
                 
                </div>
            </div>
            </h1>           
        </div>
    </div>
    <footer id="footer"></footer>
  
<script src="../../Scripts/Common.js"></script>
    <script src="../../scripts/public.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../../Scripts/WebCenter/DatabaseMan.js"></script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
        })
    </script>
     


    
    <script>
        var pagecount = 0;
        var pagesize = 3;
        var retDataCache = null;
        var retData_type = null;
        //选择的指标库分类ID
        var type_id = 0;
        //选择的具体指定指标
        var type_child_id;
        var indicator_type_id = 0;//搜索时，需要类别id,此处点击左侧时进行赋值
        var pageIndex = 0;
        var pageSize = 10;
        var pageCount;
        var cookie_Userinfo = localStorage.getItem('Userinfo_LG');
        var Userinfo_json = JSON.parse(cookie_Userinfo);
        var Sys_Role = Userinfo_json.Sys_Role;
        var indicator_arr = [];
        //  [1,2,3,4]
        var reUserinfoByselect;
        $(function () {
            Type = 1;
            CreateUID = login_User.UniqueNo;
       

            $('#threenav').children().eq(0).addClass('selected');
        })

      
    </script>
</body>
</html>
