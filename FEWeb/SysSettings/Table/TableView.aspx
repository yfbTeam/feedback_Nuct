<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TableView.aspx.cs" Inherits="FEWeb.Evaluation.TableView" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价</title>
    <link href="../../css/reset.css" rel="stylesheet" />
    <link href="../../css/layout.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.11.2.min.js"></script>

    <style>
        .test_module {
            border: none;
        }

        .test_lists ul li {
            padding-right: 0;
        }

        .tableheader .evalmes {
            text-align: center;
        }

        .h1_div {
            margin-top: 0;
            background: #f9f4f8;
            height: 40px;
        }

            .h1_div h1 {
                margin-top: -9px;
                margin-left: 20px;
            }
    </style>


</head>
<body>  
     <div class="main">
        <div class="tableheader" style="margin-bottom: 20px">
            <h1 class="tablename" style="font-weight: bold;"></h1>

            <div class="table_header_left clearfix" style="min-height: 49px" id="list">
            </div>

            <div class="evalmes">
                <span id="sp_total" style="float: left; margin-left: 20px"></span>
                <span id="remark"></span>
            </div>
        </div>

        <div class="content">
            <ul id="table_view">
            </ul>
        </div>
    </div>

</body>
</html>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/public.js"></script>

<script src="../../Scripts/jquery.linq.js"></script>
<script src="../../Scripts/linq.min.js"></script>
<script src="../../Scripts/layer/layer.js"></script>
<script src="../../Scripts/jquery.tmpl.js"></script>
<link href="../../Scripts/kkPage/Css.css" rel="stylesheet" />
<script src="../../Scripts/kkPage/jquery.kkPages.js"></script>
<script src="../../Scripts/WebCenter/TableDesigin.js"></script>

<script type="text/x-jquery-tmpl" id="item_table_view">
    <div class="content">
        <div class="h1_div">
            <h1 class="test_title" style="display: inline-block">
                <b class="order_num"></b><b>${Root}</b>
                <%--<b class="isscore">(<span id="h_${indicator_type_tid}"></span> 分)</b>--%>
            </h1>
        </div>
        <div class="test_module">
            <input type="hidden" value="${indicator_type_tid}" name="name_title" />
            <div class="test_lists">
                <ul>
                    {{each Eva_TableDetail_List}}
                <li>
                    <input type="hidden" name="name_in" value="{{= $value.Id}}" />
                    <input type="hidden" name="name_QuesType_Id" value="{{= $value.QuesType_Id}}" />
                    <h2 class="title">${Sort}、${$value.Name}
                    {{if $value.QuesType_Id!=3}}
                       <b class="isscore">（<span class="isscore">${OptionF_S_Max}分</span>）</b>
                        {{/if}}
                    </h2>
                    {{if $value.QuesType_Id!=3}}
                    <div class="test_desc">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>A${$value.OptionA}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionA_S}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>B${$value.OptionB}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionB_S}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>C${$value.OptionC}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionC_S}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>D${$value.OptionD}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionD_S}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>E${$value.OptionE}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionE_S}</span>分)</b>
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>F${$value.OptionF}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionF_S}</span>分)</b>
                        </span>
                        {{/if}}
                    </div>
                    {{else $value.QuesType_Id==3}}
                    <div class="test_desc">
                        <textarea readonly="readonly"></textarea>
                    </div>

                    {{else}}
                    {{/if}}
                </li>
                    {{/each}}
                </ul>
            </div>
        </div>
    </div>
</script>

<%--固定表头--%>
<script type="text/x-jquery-tmpl" id="item_check">
    <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
        <label for="">${Value}：【${Header}】</label>
    </div>
</script>

<%--自由表头--%>
<script type="text/x-jquery-tmpl" id="item_check2">
    <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
        <label for="">
            ${Header}：____________
        </label>
    </div>
</script>

<script>
    var table_Id = getQueryString("table_Id");
    //求分类的总分
    var total = 0;

    $(function () {
        ;
        //$('#header').load('../../header.html');
        $('#footer').load('../../footer.html');
        UI_Table_View.PageType = 'TableView';
        UI_Table_View.IsPage_Display = true;
        UI_Table_View.Get_Eva_TableDetail();


    })

</script>


