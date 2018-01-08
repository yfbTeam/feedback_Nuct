<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoMessage.aspx.cs" Inherits="FEWeb.NoMessage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>没有内容</title>
    <link href="./css/reset.css" rel="stylesheet" />
    <link href="./css/layout.css" rel="stylesheet" />
    <script src="./Scripts/jquery-1.11.2.min.js"></script>   
</head>
<body>
    <div id="top"></div>
    <div class="center" id="centerwrap">
        <div class="wrap">
            <div class="sort_nav" id="threenav"></div>
            <div id="nomessage"></div>
        </div>
    </div>
    <footer id="footer"></footer>
    <script src="./Scripts/Common.js"></script>
    <script src="./Scripts/public.js"></script>
    <script>
        $(function () {
            $('#top').load('/header.html');
            $('#footer').load('/footer.html');
            nomessage('#nomessage','div')
        });
    </script>
</body>
</html>
