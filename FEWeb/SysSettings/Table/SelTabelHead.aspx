<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SelTabelHead.aspx.cs" Inherits="FEWeb.SysSettings.SelTabelHead" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="/images/favicon.ico" rel="shortcut icon">
    <title>选择指标</title>
    <link rel="stylesheet" href="../../css/reset.css" />
    <link rel="stylesheet" href="../../css/layout.css" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .options label {
            display: inline-block;
            line-height: 33px;
        }
    </style>

    <script type="text/x-jquery-tmpl" id="item_check">
        <div class="options fl mr10">
            <input type="checkbox" description="${description}" name="ck_item" id="${id}" Code="${Code}" onclick="check('${id}')">
            <label for="${id}">${name}</label>
        </div>
    </script>

</head>


<body style="background: #FFF;">
    <div class="main clearfix" id="list">
      
    </div>
    <div class="btnwrap">
        <input type="button" value="确定" onclick="submit()" class="btn">
        <input type="button" value="取消" onclick="closeWindow()" class="btna ml10">
    </div>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/public.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/layer/layer.js"></script>
    <script src="../../Scripts/linq.min.js"></script>
    <script src="../../Scripts/jquery.tmpl.js"></script>  
    <script src="../../Scripts/WebCenter/TableDesigin.js"></script>
    <script type="text/javascript">
        var index = parent.layer.getFrameIndex(window.name);//弹框的索引
        var head_vs = parent.get_tablehead();
       
        $(function () {
            UI_Table_Create.Get_Eva_Table_Header_Custom_List(function (json) {
                if (json.result.errMsg == "success") {
                    retData = json.result.retData;
                    $("#item_check").tmpl(retData).appendTo("#list");
                    for (var i in head_vs) {
                        $('#' + head_vs[i].id).prop('checked', true);
                    }
                }
            })
        });
        function check(id) {
            if ($('#' + id).is(':checked')) {
                head_vs.push({
                    id: id,
                    description: $('#' + id).attr("description"),
                    name: $('#' + id).next().text(),
                    Code: $('#' + id).attr("Code")
                })
            } else {
                head_vs = head_vs.filter(function (item) {
                    return item.id !=id
                })
            }
        }
        function submit() {
            parent.tablehead(head_vs);
            closeWindow()
        }
        function closeWindow(){
            parent.layer.close(index);
        }
    </script>
</body>
</html>
