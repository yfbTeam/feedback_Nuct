﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PowerAssign.aspx.cs" Inherits="FEWeb.SysSettings.PowerAssign" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>用户管理</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.8.3.min.js"></script>

    <style>
        .table table tbody tr td:nth-child(2n) {
            text-align: left;
            padding-left: 20px;
        }
    </style>
</head>
<body>
    <div class="main">
        <div class="ztree" id="table">
        </div>
    </div>
    <div class="btnwrap">
        <input type="button" value="保存" onclick="submit();" class="btn" />
        <input type="button" value="取消" onclick="javascript: parent.CloseIFrameWindow();" class="btna ml10" />
    </div>
    <script src="../Scripts/Common.js"></script>
    <script src="../Scripts/public.js"></script>
    <script src="../Scripts/layer/layer.js"></script>
    <script src="../Scripts/jquery.tmpl.js"></script>
    <script src="../Scripts/linq.js"></script>
    <link href="../Scripts/pagination/pagination.css" rel="stylesheet" />
    <script src="../Scripts/pagination/jquery.pagination.js"></script>
    <link href="../Scripts/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" />
    <script src="../Scripts/zTree/js/jquery.ztree.all.min.js"></script>
    <script>

        var adminalot = [ 196];

        var UrlDate = new GetUrlDate();
        var setting = {
            view: {
                selectedMulti: false,
                showIcon: false
            },
            edit: {
                enable: true,
                showRemoveBtn: false,
                showRenameBtn: false
            },
            data: {
                keep: {
                    parent: false,
                    leaf: false
                },
                key: {
                    name: "Name"
                },
                simpleData: {
                    enable: true,
                    idKey: "ID",
                    pIdKey: "Pid"
                }
            },
            callback: {
                onClick: function (e, treeId, treeNode, clickFlag) {
                    zTree.checkNode(treeNode, !treeNode.checked, true);
                   
                    if(treeNode.chkDisabled)
                    {
                        layer.msg('当前角色无法勾选' + treeNode.Name);
                    }
                }
            },
            check: {
                
                autoCheckTrigger: true,
                enable: true,
                chkStyle: "checkbox",
                chkboxType: { "Y": "p", "N": "ps" }
            }
        };
        $(document).ready(function () {
            var postData = { func: "GetAllMenuInfo" };
            $.ajax({
                type: "POST",
                url: HanderServiceUrl + "/SetMenu/SetMenuHandler.ashx",
                data: postData,
                dataType: "json",
                async: false,
                success: function (returnVal) {
                    if (returnVal.result.errMsg == "success") {
                        var trees = returnVal.result.retData;
                        zTree = $.fn.zTree.init($("#table"), setting, trees);

                    }
                },
                error: function (errMsg) {
                    alert("数据加载失败!");
                }
            });
           
            var roleid = UrlDate.type;
            var items = getMenuByRoleid(roleid, "");
            $(items).each(function () {
                var treeObj = $.fn.zTree.getZTreeObj("table");
                var node = treeObj.getNodeByParam("ID", this.ID, null);
                treeObj.checkNode(node, true, true);
            });
          
            if (roleid == 10 || roleid == 19) {              
            }
            else {
                for (var i = 0; i < adminalot.length; i++) {
                    var treeObj = $.fn.zTree.getZTreeObj("table");
                    var node = treeObj.getNodeByParam("ID", adminalot[i], null);
                    zTree.setChkDisabled(node, true);
                }
            }
         
           
        });


        function submit() {
            var zTree = $.fn.zTree.getZTreeObj("table");
            var nodes = zTree.getCheckedNodes(true);

            var ids = "";
            $(nodes).each(function () {
                ids = ids + this.ID + ",";
            });
            ids = ids.substring(0, ids.length - 1);

            var roleid = UrlDate.type;
            var postData = { func: "SetRole_MenuInfo", Rid: roleid, MenuId: ids };
            $.ajax({
                url: HanderServiceUrl + "/SetMenu/SetMenuHandler.ashx",
                data: postData,
                dataType: 'json',
                async: true,
                success: function (json) {
                    if (json.result.errMsg = "success") {
                        parent.layer.msg("设置成功");
                        parent.CloseIFrameWindow();
                    }
                },
                error: function (errMsg) {
                    parent.layer.msg("设置失败!");
                }
            })
        }
    </script>
</body>
</html>
