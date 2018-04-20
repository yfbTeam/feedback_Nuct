<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EvalDetail.aspx.cs" Inherits="FEWeb.Evaluation.EvalDetail" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>课堂评价</title>
    <link href="../css/reset.css" rel="stylesheet" />
    <link href="../css/layout.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.11.2.min.js"></script>
    <style>
        .test_module {
            border: none;
        }

        .test_lists ul li {
            padding-right: 0;
        }

        .tableheader {
            margin-top: 20px;
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
                margin-top: 13px;
                margin-left: 20px;
            }


        .tableheader .tablename1 {
            height: 32px;
            text-align: center;
        }

        .tableheader .evalmes span {
            line-height: 40px;
        }

        .test_desc label {
            cursor: pointer;
        }

        .div_header {
           
            margin-bottom: 20px;
            margin-left: 20px;
        }

          
       .input_bottom {
            height:34px;
            width: 100px;
            border: 0;
            border-bottom: 1px solid #000;
            text-align: center;
        }


        #table_view {
            margin-top: 30px;
        }

        .div_header select {
            min-width: 120px;
            height:35px;
            border-radius:3px;
        }

        input[Type="radio"] {
            vertical-align: middle;
        }

        .lbl {
            vertical-align: middle;
        }
    </style>
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
           
            <div class="table_header_left clearfix" style="min-height: 49px;margin-top:25px" id="list">
            </div>
             <div class="evalmes fr" style="color: #999999; font-size: 14px">
                <span id="sp_total"></span>
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
<script src="../Scripts/Common.js"></script>
<script src="../Scripts/public.js"></script>

<script src="../Scripts/jquery.linq.js"></script>
<script src="../Scripts/linq.min.js"></script>
<script src="../Scripts/layer/layer.js"></script>
<script src="../Scripts/jquery.tmpl.js"></script>
<link href="../Scripts/kkPage/Css.css" rel="stylesheet" />
<script src="../Scripts/kkPage/jquery.kkPages.js"></script>
<script src="../Scripts/WebCenter/TableDesigin.js"></script>
<script src="../Scripts/WebCenter/Evaluate.js"></script>
<script type="text/x-jquery-tmpl" id="item_table_view">
    {{if Root.trim() !=''}}
    <div class="content">
        <div class="h1_div">
            <h1 class="test_title" style="display: inline-block">
                <b class="order_num"></b><b>${Root}</b>
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
                    <h2 class="title">${Sort}、{{if $value.QuesType_Id ==1 }}
                             【单选题】
                             {{else $value.QuesType_Id ==2 }}
                             【多选题】
                             {{else $value.QuesType_Id ==3 }}
                             【问答题】
                             {{else $value.QuesType_Id ==4 }}
                             【评分题】
                             {{/if}} ${$value.Name}
                    {{if $value.QuesType_Id ==1 || $value.QuesType_Id ==4}}
                       <b class="isscore">（<span class="isscore">${OptionF_S_Max}分</span>）</b>
                        {{/if}}
                         
                    </h2>
                    {{if $value.QuesType_Id ==1}}
                    <div class="test_desc" DetailID="${Id}">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionA" id="inp_${$value.Id}-1" value="${$value.OptionA_S}" />
                            <label class="lbl" for="inp_${$value.Id}-1">
                                A${$value.OptionA}
                            <b class="isscore">(<span class="numbers">${$value.OptionA_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionB" id="inp_${$value.Id}-2" value="${$value.OptionB_S}" />
                            <label class="lbl" for="inp_${$value.Id}-2">
                                B${$value.OptionB}
                            <b class="isscore">(<span class="numbers">${$value.OptionB_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionC" id="inp_${$value.Id}-3" value="${$value.OptionC_S}" />
                            <label class="lbl" for="inp_${$value.Id}-3">
                                C${$value.OptionC}
                            <b class="isscore">(<span class="numbers">${$value.OptionC_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionD" id="inp_${$value.Id}-4" value="${$value.OptionD_S}" />
                            <label class="lbl" for="inp_${$value.Id}-4">
                                D${$value.OptionD}
                                
                            <b class="isscore">(<span class="numbers">${$value.OptionD_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionE" id="inp_${$value.Id}-5" value="${$value.OptionE_S}" />
                            <label class="lbl" for="inp_${$value.Id}-5">E${$value.OptionE}</label>
                            <b class="isscore">(<span class="numbers">${$value.OptionE_S}</span>分)</b>
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input disabled="disabled" type="radio" name="inp_${$value.Id}" flv="OptionF" id="inp_${$value.Id}-6" value="${$value.OptionF_S}" />
                            <label class="lbl" for="inp_${$value.Id}-6">
                                F${$value.OptionF}
                               
                            <b class="isscore">(<span class="numbers">${$value.OptionF_S}</span>分)</b></label>
                        </span>
                        {{/if}}
                    </div>
                     {{else $value.QuesType_Id ==2}}
                    
                    <div class="test_desc test_desc2" DetailID="${Id}">
                        {{if $value.OptionA!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"  flv="OptionA" id="inp_${$value.Id}-1" value="${$value.OptionA_S}" />
                            <label class="lbl" for="inp_${$value.Id}-1">
                                A${$value.OptionA}                           
                        </span>
                        {{/if}}
                        {{if $value.OptionB!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"   flv="OptionB" id="inp_${$value.Id}-2" value="${$value.OptionB_S}" />
                            <label class="lbl" for="inp_${$value.Id}-2">
                                B${$value.OptionB}                          
                        </span>
                        {{/if}}
                        {{if $value.OptionC!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"  flv="OptionC" id="inp_${$value.Id}-3" value="${$value.OptionC_S}" />
                            <label class="lbl" for="inp_${$value.Id}-3">
                                C${$value.OptionC}                           
                        </span>
                        {{/if}}
                        {{if $value.OptionD!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"   flv="OptionD" id="inp_${$value.Id}-4" value="${$value.OptionD_S}" />
                            <label class="lbl" for="inp_${$value.Id}-4">
                                D${$value.OptionD}                                                           
                        </span>
                        {{/if}}
                        {{if $value.OptionE!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"   flv="OptionE" id="inp_${$value.Id}-5" value="${$value.OptionE_S}" />
                            <label class="lbl" for="inp_${$value.Id}-5">E${$value.OptionE}</label>                        
                        </span>
                        {{/if}}
                         {{if $value.OptionF!=""}}
                        <span>
                            <input disabled="disabled" type="checkbox"   flv="OptionF" id="inp_${$value.Id}-6" value="${$value.OptionF_S}" />
                            <label class="lbl" for="inp_${$value.Id}-6">
                                F${$value.OptionF}                                                        
                        </span>
                        {{/if}}
                    </div>
                    {{else $value.QuesType_Id==3}}
                    <div class="test_desc" DetailID="${Id}">
                        <textarea readonly="readonly"></textarea>
                    </div>

                    {{else $value.QuesType_Id==4 }}
                    <div class="test_desc" detailid="${Id}" maxscore="${OptionF_S_Max}">
                        <input  readonly="readonly" name="Name" class="text" style="width:99%;"/>
                    </div>
                   
                    {{/if}}
                </li>
                    {{/each}}
                </ul>
            </div>
        </div>
            </div>
</script>


<script type="text/x-jquery-tmpl" id="item_check">
    <div class="fl div_header">
        <label class="lblheader" customcode="${CustomCode}" name="${Value}">
            ${Name}：
                <input readonly="readonly" class="input_bottom" value="${Value}" id="teacher" />
        </label>
    </div>
</script>



<script>
    var table_Id = getQueryString("table_Id");
    var QuestionID = getQueryString("QuestionID");
    //求分类的总分
    var total = 0;

    var IsScore = 0;

    $(function () {
        PageType = "EvalDetail";
        //$('#header').load('../../header.html');
        $('#footer').load('../../footer.html');
        UI_Table_View.PageType = 'EvalDetail';
        UI_Table_View.IsPage_Display = true;       
        UI_Table_View.Get_Eva_TableDetail();
        IsScore = UI_Table_View.IsScore;

        Get_Eva_QuestionAnswerDetail(QuestionID)
    })

</script>
