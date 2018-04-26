<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TableDesign.aspx.cs" Inherits="FEWeb.Evaluation.CourseEvalSee.TableDesign" %>

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
            <h1 class="title mb10">
                <div style="width: 1170px; cursor: pointer; z-index: 99; background: #fff; padding: 10px 0px;">
                    <div class="crumbs">
                        <a onclick="window.location.href='indexqcode.aspx?Id='+getQueryString('Id')+'&Iid='+getQueryString('Iid')">课堂扫码评价</a>
                        <span>&gt;</span>
                        <a href="javascript:;" style="cursor: pointer;" onclick="window.location=window.location.href" id="couse_name">评价表管理</a>

                    </div>
                </div>
            </h1>

            <div class="search_toobar clearfix mt10">
                <div class="fl">
                    <input type="text" name="key" id="key" placeholder="请输入关键字" value="" class="text fl" style="height: 31px;">
                    <a class="search fl" href="javascript:;" onclick="tool_search();" style="height: 31px;"><i class="iconfont">&#xe600;</i></a>
                </div>
                <div class="fr">
                    <input type="button" name="" id="tabledesign_add" style="" value="新增评价表" class="btn" onclick="NewEval()">
                </div>
            </div>
            <div class="table">
                <table>
                    <thead>
                        <tr>
                            <th style="text-align: left; padding-left: 20px;">评价表名称	    	 		 				 					 					   	
                            </th>
                            <th width="8%">是否记分
                            </th>
                            <th width="8%">引用次数
                            </th>
                            <th width="8%">状态
                            </th>
                            <th width="8%">创建人
                            </th>
                            <th width="8%">创建时间
                            </th>
                            <th width="20%">操作
                            </th>
                        </tr>
                    </thead>
                    <tbody id="tb_eva">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>

    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/WebCenter/TableDesigin.js"></script>

    <script type="text/x-jquery-tmpl" id="item_eva">

        <tr>
            <td style="text-align: left; padding-left: 20px;">${t.Name}</td>
            {{if t.IsScore ==0}}
            <td>是</td>
            {{else}}
            <td>否</td>
            {{/if}}            
            <td>${t.UseTimes}</td>

            {{if t.IsEnable ==0}}
            <td><span>启用</span></td>
            {{else}}
              <td><span>禁用</span></td>
            {{/if}}   

            <td>${u.Name}</td>
            <td>${DateTimeConvert(t.CreateTime,'yyyy-MM-dd',true)}</td>
            <td class="operate_wrap">
                <div onclick="table_view(${t.Id})" class="operate">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看
                    </span>
                </div>
                {{if t.UseTimes<=0}}
                <div class="operate" onclick="edit(${t.Id})">
                    <i class="iconfont color_purple">&#xe628;</i>
                    <span class="operate_none bg_purple">编辑
                    </span>
                </div>
                {{else}}
                <div class="operate">
                    <i class="iconfont color_gray">&#xe628;</i>
                    <span class="operate_none bg_gray">编辑
                    </span>
                </div>
                {{else}}
                {{/if}}
                <div class="operate" onclick="copy(${t.Id})">
                    <i class="iconfont color_purple">&#xe61e;</i>
                    <span class="operate_none bg_purple">复制
                    </span>
                </div>
                {{if t.UseTimes<=0}}
                <div class="operate" onclick="delete_table(${t.Id})">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <span class="operate_none bg_purple">删除
                    </span>
                </div>
                {{else}}
                <div class="operate">
                    <i class="iconfont color_gray">&#xe61b;</i>
                    <span class="operate_none bg_gray">删除
                    </span>
                </div>

                {{else}}
                 
                {{/if}}
                 {{if t.IsEnable ==0}}
                 <div class="operate" onclick="Enable_Eva_Table(${t.Id},${t.IsEnable})">
                     <i class="iconfont color_red">&#xe6e3;</i>
                     <span class="operate_none bg_red" style="display: none;">禁用
                     </span>
                 </div>
                {{else}}
               
                <div class="operate" onclick="Enable_Eva_Table(${t.Id},${t.IsEnable})">
                    <i class="iconfont color_green">&#xe6e3;</i>
                    <span class="operate_none bg_green">启用
                    </span>
                </div>
                {{/if}}
            </td>
        </tr>
    </script>


    <script>
        var Eva_Role = get_Eva_Role_by_rid();
        $(function () {

            $('#top').load('../../header.html');
            $('#footer').load('../../footer.html');

            Type = 1;
            CreateUID = login_User.UniqueNo;

            tableSlide();
            initdata();

            $('#threenav').children().eq(0).addClass('selected');
        })
        //搜索
        function tool_search() {
            initdata();
        }
        function NewEval() {
            var index = $('#threenav>a.selected').index();
            window.location.href = '../../SysSettings/Table/AddEvalTable.aspx' + '?Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid') + '&selected=' + index + '&_Type=' + Type;
        }
        function copy(id) {
            UI_Table.copy(id);
        }
        //删除表
        function delete_table(id) {
            UI_Table.delete_table(id);
        }

        function Enable_Eva_Table(id, IsEnable) {
            IsEnable = IsEnable ? 0 : 1;
            UI_Table.Enable_Eva_Table(id, IsEnable);
        }

        //评价表预览
        function table_view(table_Id) {
            OpenIFrameWindow('评价表详情', '../../SysSettings/Table/TableView.aspx?table_Id=' + table_Id + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid'), '1000px', '600px')
        };
        //新增表格 打开窗口页
        function AddEvalTable() {
            OpenIFrameWindow('新增表格', '../../SysSettings/Table/AddEvalTable.aspx?typeid=' + 1 + '&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid'), '800px', '800px')
        }
        function edit(id) {

            window.location.href = '../../SysSettings/Table/AddEvalTable.aspx' + '?selected=1&Id=' + getQueryString('Id') + '&Iid=' + getQueryString('Iid') + '&table_id=' + id + '&type=1' + '&_Type=' + Type;
        }
        //初始化表格列表
        function initdata() {
            UI_Table.initdata();
        }
    </script>
</body>
</html>

