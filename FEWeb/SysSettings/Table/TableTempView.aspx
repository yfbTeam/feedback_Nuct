<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TableTempView.aspx.cs" Inherits="FEWeb.SysSettings.Table.TableTempView" %>

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
                margin-top: 15px;
                margin-left: 20px;
            }

        .tableheader .tablename {
            height: 20px;
        }

        .tableheader .evalmes span {
            line-height: 40px;
        }
    </style>


</head>
<body>
    <div class="main">
        <div class="tableheader">
            <h1 class="tablename" style="font-weight: bold;"></h1>
            <div class="evalmes" style="color: #999999; font-size: 14px">
                <span id="sp_total"></span>
                <span id="remark"></span>
            </div>
            <div class="table_header_left clearfix" style="min-height: 49px" id="list">
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

<script src="../../Scripts/WebCenter/TableDesigin.js"></script>

<script type="text/x-jquery-tmpl" id="item_table_view">
    {{if Root.trim() !=''}}
      <div class="content ">
          <div class="h1_div">
              <h1 class="test_title " style="display: inline-block">
                  <b class="order_num"></b><b>${Root}</b>
                  <b class="isscore">(<span>${Score}</span> 分)</b>
              </h1>
          </div>
          {{else}}
            <div class="content " style="margin-top: -20px;">
                {{/if}}    
        <div class="test_module">
            <input type="hidden" value="${indicator_type_tid}" name="name_title" />
            <div class="test_lists">
                <ul>
                    {{each Eva_TableDetail_List}}
                <li>
                    <h2 class="title">${Sort}、${$value.Name}
                    {{if $value.QuesType_Id =="1"  ||$value.QuesType_Id =="4" }}
                      <b class="isscore">（<span class="isscore">${OptionF_S_Max}分</span>）</b>
                        {{/if}}
                          {{if $value.QuesType_Id ==1 }}
                             【单选题】
                             {{else $value.QuesType_Id ==2 }}
                             【多选题】
                             {{else $value.QuesType_Id ==3 }}
                             【问答题】
                             {{else $value.QuesType_Id ==4 }}
                             【选分题】
                             {{/if}} 
                    </h2>
                    {{if $value.QuesType_Id ==1}}
                    <div class="test_desc">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>A${$value.OptionA}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionA_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>B${$value.OptionB}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionB_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>C${$value.OptionC}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionC_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>D${$value.OptionD}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionD_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>E${$value.OptionE}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionE_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>F${$value.OptionF}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionF_S.toFixed(2)}</span>分)</b>
                        </span>
                        {{/if}}
                    </div>
                     {{else  $value.QuesType_Id =="2" }}
                        <%--/////////////////////////////////////////////////////////////--%>
                         <div class="test_desc">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>A${$value.OptionA}</label>
                           
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>B${$value.OptionB}</label>                          
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>C${$value.OptionC}</label>                           
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>D${$value.OptionD}</label>                           
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>E${$value.OptionE}</label>                            
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input type="radio" disabled="disabled" name="" id="" value="" />
                            <label>F${$value.OptionF}</label>                            
                        </span>
                        {{/if}}
                    </div>
                    {{else $value.QuesType_Id==3 }}
                    <div class="test_desc">
                        <textarea readonly="readonly"></textarea>
                    </div>

                    {{else $value.QuesType_Id==4 }}
                    <div class="test_desc">
                         <input type="text" class="text" name="Name" style="width: 98%; height: 35px;" readonly="readonly" />
                    </div>
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
        <label for="">${name}：【${description}】</label>
    </div>
</script>

<%--自由表头--%>
<script type="text/x-jquery-tmpl" id="item_check2">
    <div class="fl" style="margin-bottom: 20px; margin-left: 20px">
        <label for="">
            ${title}：____________
        </label>
    </div>
</script>
<script>

    $(function () {
        parent.Refresh_View_Display();

        $('.tablename').text(parent.TableName);
        var head_value = parent.head_value;
        var headerList = parent.lisss;

        $("#item_check").tmpl(head_value).appendTo("#list");
        $("#item_check2").tmpl(headerList).appendTo("#list");
        

        var All_Array = parent.All_Array;
        var objArray = [];
        var sp_total = 0;
        for (var i in All_Array) {
            var obj = new Object();
            if (All_Array[i].indicator_list.length > 0) {
                obj.Root = All_Array[i].indicator_list[0].Root;
                obj.Eva_TableDetail_List = All_Array[i].indicator_list;
                obj.Score = 0;
            }
            for (var h in All_Array[i].indicator_list) {
                var hv = All_Array[i].indicator_list[h];
                obj.Score += Number(hv.OptionF_S_Max);
               
            }
            sp_total += obj.Score;
            objArray.push(obj);
        }
        $("#item_table_view").tmpl(objArray).appendTo("#table_view");
        if (!parent.IsScore) {
            $('.isscore').hide();
            $('#sp_total').text("总分：不计分");
        }
        else {
            $('#sp_total').text("总分：" + sp_total);
        }

    })

</script>
