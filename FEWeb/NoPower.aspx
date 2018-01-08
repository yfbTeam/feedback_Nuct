<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoPower.aspx.cs" Inherits="FEWeb.NoPower" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>无权限访问</title>
    <link href="./css/reset.css" rel="stylesheet" />
    <link href="./css/layout.css" rel="stylesheet" />
    <script src="./Scripts/jquery-1.11.2.min.js"></script>   
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap">
            <div class="sort_nav" id="threenav"></div>
            <div style="width:100%;background:url(/images/nostart.jpg) no-repeat center center;height:480px;background-size:20% auto;position:relative">
                <p style="text-align:center;line-height:30px;color:#999;width:100%;position:absolute;top:350px;">您无权限访问！！！</p>
            </div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="./Scripts/Common.js"></script>
    <script src="./Scripts/public.js"></script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            
        });
    </script>
</body>
</html>