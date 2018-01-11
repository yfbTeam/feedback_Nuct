<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClassEval.aspx.cs" Inherits="FEWeb.SysSettings.ClassEval" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap clearfix">
            <div class="sort_nav" id="threenav">
            </div>
            <div class="search_toobar clearfix">
                <div class="fl">
                    <label for="">学年学期:</label>
                    <select class="select" id="section">
                    </select>
                </div>

                <div class="fr">
                    <input type="button" name="" id="" value="新增评价" class="btn" onclick="OpenIFrameWindow('新增评价', 'CreateModel.aspx', '545px', '450px')">
                </div>
            </div>
            <div class="table mt10">
                <table>
                    <thead>
                        <tr>
                            <th>评价名称</th>
                            <th>学年学期</th>
                            <th>创建人</th>
                            <th>开始时间</th>
                            <th>截止时间</th>
                            <th>状态</th>
                            <th>评价表</th>
                            <th>评价范围</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    </tbody>
                </table>
            </div>
            <div id="pageBar" class="page"></div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>
    <script src="../../Scripts/WebCenter/Base.js"></script>
    <script src="../../Scripts/linq.js"></script>
    <script src="../../Scripts/WebCenter/RegularEval.js"></script>
    <script src="../../Scripts/laypage/laypage.js"></script>
    <script type="text/x-jquery-tmpl" id="itemData">
        <tr>
            <td title="${ReguName}">${cutstr(ReguName,10)}</td>
            <td>${DisPlayName}</td>
            <td>${CreateName}</td>
            <td>${DateTimeConvert(StartTime,'yy-MM-dd',true)}</td>
            <td>${DateTimeConvert(EndTime,'yy-MM-dd',true)}</td>
            <td>${State}</td>
            <td style="width: 30%" title="${TableName}">${cutstr(TableName,40)}</td>
            {{if LookType == 0}}
             <td>全校</td>
            {{else LookType == 1}}
             <td>指定部门</td>
            {{/if}}

            <td>${DateTimeConvert(CreateTime,'yy-MM-dd',true)}</td>
            <td class="operate_wrap">
                <div class="operate" onclick="OpenIFrameWindow('查看评价','SeeModel.aspx?Id=${Id}','545px','450px')">
                    <i class="iconfont color_purple">&#xe60b;</i>
                    <span class="operate_none bg_purple">查看
                    </span>
                </div>

                <div class="operate" onclick="OpenIFrameWindow('编辑评价','EditModel.aspx?Id=${Id}','545px','450px')">
                    <i class="iconfont color_purple">&#xe602;</i>
                    <span class="operate_none bg_purple">编辑</span>
                </div>

                {{if ReguState == 2}}
                 <div class="operate" >
                    <i class="iconfont color_gray">&#xe61b;</i>
                    <span class="operate_none bg_gray">删除</span>
                </div>
                {{else}}
             <div class="operate" onclick="remove_data(${Id});">
                    <i class="iconfont color_purple">&#xe61b;</i>
                    <span class="operate_none bg_purple">删除</span>
                </div>
                {{/if}}
               
            </td>
        </tr>
    </script>
    <script type="text/x-jquery-tmpl" id="itemCount">
        <span style="margin-left: 5px; font-size: 14px;">共${RowCount}条，共${PageCount}页</span>
    </script>

    <script>

        var pageSize = 10;
        var pageIndex = 0;
        $(function () {

            $('#top').load('/header.html');
            $('#footer').load('/footer.html');

            Base.bindStudySectionCompleate = function () {
                select_sectionid = $('#section').val();
                Get_Eva_RegularS(select_sectionid, 2, pageIndex);

                $('#section').on('change', function () {
                    select_sectionid = $('#section').val();
                    Get_Eva_RegularS(select_sectionid, 2, pageIndex);
                });
            };
            Base.bindStudySection();


            Delete_Eva_RegularCompleate = function () {
                Reflesh();
            }
        })

        function Reflesh() {
            select_sectionid = $('#section').val();
            Get_Eva_RegularS(select_sectionid, 2, pageIndex);
        }

        function remove_data(Id) {
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'], //按钮
                title: '操作'
            }, function () { Delete_Eva_Regular(Id); });
        }
    </script>
</body>
</html>
