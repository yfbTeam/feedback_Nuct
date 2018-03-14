﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DatabaseMan.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.DatabaseMan" %>

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
                    <a href="javascript:;" style="cursor:pointer;" onclick="window.location=window.location.href"  id="couse_name">指标库分类管理</a>
                 
                </div>
            </div>
            </h1>
           

           <div class="sortwrap clearfix mt20">
                <div class="menu fl">
                    <h1 class="titlea">
                        指标库管理
                    </h1>
                    <ul class="menu_list" style="height:478px;overflow:auto">

                    </ul>
                    <input type="button" value="指标库分类管理"  class="new" onclick="newIndicator_type()"  id="Indicator_Add" />
                  
                </div>
                <div class="sort_right fr" style="overflow:auto">
                    <div class="search_toobar clearfix">
                        <div class="fl">
                            <input type="text" name="key" id="key" placeholder="请输入关键字" value="" class="text fl">
                            <a class="search fl" href="javascript:search();"><i class="iconfont">&#xe600;</i></a>
                        </div>
                        <div id="btndiv" class="fr">
                           
                        </div>
                    </div>
                    <div class="table">
                        <table>
                            <thead>
                                <tr>
                                    <th style="text-align: left; padding-left: 20px;width:50%">指标名称	 	    	 		 				 					 					   	
                                    </th>
                                    <th width="60px">题型</th>
                                    
                                    <th width="80px">引用次数 </th>
                                   
                                    <th width="80px">修改时间</th>
                                    
                                    <th width="120px" style="display:none;" id="ss">操作</th>
                                    
                                </tr>
                            </thead>
                            <tbody id="tb_indicator">
                            </tbody>
                        </table>

                    </div>
                     <div class="pagination"" id="test1">
                    </div>
                </div>
            </div>
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
      <script type="text/x-jquery-tmpl" id="item_indicator">
       
        <tr>
            <td style="text-align: left; padding-left: 20px; padding-right: 20px; width: 430px; line-height: 20px;">${Name}</td>
            <td>${txing(QuesType_Id)}</td>
            <td>${UseTimes}</td>       
            <td>${DateTimeConvert(EditTime,'yyyy-MM-dd',true)}</td>
            <td class="operate_wrap">

                 <div onclick="sea(${Id})" class="operate">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看
                    </span>
                </div>

                <div class="operate" onclick="copy(${Id})">
                    <i class="iconfont color_purple">&#xe61e;</i>
                    <span class="operate_none bg_purple">复制
                    </span>
                </div>
                {{if UseTimes<=0}}
                <div class="operate"  onclick="edit(${Id})">
                    <i class="iconfont color_purple">&#xe628;</i>
                    <span class="operate_none bg_purple">编辑
                    </span>
                </div>
                {{else}}
                <div class="operate" >
                    <i class="iconfont color_gray">&#xe628;</i>
                    <span class="operate_none bg_gray">编辑
                    </span>
                </div>
                {{else}}
                {{/if}}
                {{if UseTimes<=0}}
                <div class="operate"  onclick="delete_indicator(${Id})">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <span class="operate_none bg_purple">删除
                    </span>
                </div>
                {{else}}
                <div class="operate" >
                    <i class="iconfont color_gray">&#xe61b;</i>
                    <span class="operate_none bg_gray">删除
                    </span>
                </div>
                {{else}}
                {{/if}}
            </td>
            
        </tr>
       
    </script>


    <script type="text/x-jquery-tmpl" id="item_indicatorType">
        <li>
            <span title="${self.Name}" onclick="indicator_type_Parent_click('${self.Id}');" t_Id="${self.Id}">${self.Name}<i class="iconfont">&#xe643;</i></span>
            <ul>
                {{each child_list}}
                <li onclick="indicator_type_click('{{= $value.Id}}');">
                    <input type="hidden" value="{{= $value.Id}}" />
                    <input type="hidden" value="{{= $value.Parent_Id}}" />
                    ${$value.Name}
                </li>
                {{/each}}
            </ul>
        </li>
    </script>    

    <script type="text/x-jquery-tmpl" id="itemYes">
         <input type="button" name="" id="database_add" style="" value="新增指标" class="btn" onclick="newIndicator()">
    </script>

    <script type="text/x-jquery-tmpl" id="itemNo">
         <input type="button" name="" id="database_add2" style="background:#A8A8A8" value="新增指标" class="btn"  >
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
            reflesh_Left(type_id);

            $('#threenav').children().eq(0).addClass('selected');
        })

        //编辑指标
        function sea(id) {
            OpenIFrameWindow('查看指标', '../../SysSettings/Indicate/SeaDatabase.aspx?id=' + id + '&Type=' + 1, '900px', '500px');
        }

        //编辑指标
        function edit(id) {
            OpenIFrameWindow('编辑指标', '../../SysSettings/Indicate/EditDatabase.aspx?id=' + id + '&Type=' + 1, '900px', '500px');
        }
        function reflesh_Left(t_Id) {
            DataBaseMainModel.PageType = 'DatabaseMan';
            //初始化指标库分类
            DataBaseMainModel.init_IndicatorType_data();

            if (LeftList.length == 0) {
                nomessage('#test1', 'no', 19, 480);
                $("#itemNo").tmpl(1).appendTo("#btndiv");
            }
            else
            {
                $("#itemYes").tmpl(1).appendTo("#btndiv");              
            }

        }
        //删除指标
        function delete_indicator(id) {
            DataBaseMainModel.delete_indicator(id);
        }
        //复制指标
        function copy(id) {
            DataBaseMainModel.copy(id);
        }
        //指标库分类点击获取指标列表
        function indicator_type_click(Id) {
            indicator_type_id = Id;
            DataBaseMainModel.initdata(indicator_type_id);
        }
        function indicator_type_Parent_click(Id) {
            type_id = Id;
        }
        function initdata(indicator_type_id) {
            DataBaseMainModel.initdata(indicator_type_id);
        }
        //新增指标 打开窗口页
        function newIndicator() {

            OpenIFrameWindow('新增指标', '../../SysSettings/Indicate/AddDatabase.aspx?typeid=' + type_child_id + '&Type=' + 1 + '&page=0', '950px', '500px')
        }
        //新增指标分类 打开窗口页
        function newIndicator_type() {
            OpenIFrameWindow('新增指标分类', '../../SysSettings/Indicate/DataBaseSort.aspx?type_id=' + type_id + '&Type=' + 1, '950px', '650px')
        }
        function search() {
            DataBaseMainModel.initdata(indicator_type_id);
        }
        //暂时使用 题型的转换
        function txing(_val) {
            return DataBaseMainModel.txing(_val);
        }
        //获取指定指标项的指标内容【供子窗体使用】
        function get_indicalist() {
            return retDataCache;
        }
    </script>
</body>
</html>

