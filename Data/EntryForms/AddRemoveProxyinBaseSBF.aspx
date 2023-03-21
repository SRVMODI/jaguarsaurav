<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="AddRemoveProxyinBaseSBF.aspx.cs" Inherits="AddRemoveProxyinBaseSBF" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
        function Tooltip(container) {
            $(container).hover(function () {
                // Hover over code
                var title = $(this).attr('title');
                if (title != '' && title != undefined) {
                    $(this).data('tipText', title).removeAttr('title');
                    $('<p class="customtooltip"></p>')
                        .appendTo('body')
                        .css("display", "block")
                        .html(title);
                }
            }, function () {
                // Hover out code
                $(this).attr('title', $(this).data('tipText'));
                $('.customtooltip').remove();
            }).mousemove(function (e) {
                var mousex = e.pageX;   //Get X coordinates
                var mousey = ht - (e.pageY + $('.customtooltip').height() + 50) > 0 ? e.pageY : (e.pageY - $('.customtooltip').height() - 40);   //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }
        function AutoHideAlertMsg(msg) {
            var str = "<div id='divAutoHideAlertMsg' style='width: 100%; background-color: transparent; top: 0; position: fixed; z-index: 999; text-align: center; opacity: 0;'>";
            str += "<span style='font-size: 0.9rem; font-weight: 700; color: #fff; padding: 6px 16px; border-radius: 4px; background-color: #202020; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.6), 0 6px 20px 0 rgba(0, 0, 0, 0.2)'>";
            str += msg;
            str += "</span>";
            str += "</div>";
            $("body").append(str);

            $("#divAutoHideAlertMsg").animate({
                top: '100px',
                opacity: '1'
            }, "slow");

            //---------------------------------------------
            setTimeout(function () {
                $("#divAutoHideAlertMsg").animate({
                    top: '0px',
                    opacity: '0'
                }, "slow");
            }, 3000);
            setTimeout(function () {
                $("#divAutoHideAlertMsg").remove();
            }, 3500);

        }
        function fnfailed() {
            AutoHideAlertMsg("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
    </script>
    <script type="text/javascript">
        var ht;
        $(document).ready(function () {
            ht = $(window).height();

            // 1 : Add,     2 : Remove
            if ($("#ConatntMatter_hdnPageType").val() == "1") {
                $("#Heading").html("Add Proxy SBF in Base SBF :");
                $("#lblStep1").html("Select Proxy SBF to be Added, in One or More Base SBF(s)");

                $("#btnRemoveAsProxy").remove();
            }
            else {
                $("#Heading").html("Reemove Proxy SBF from Base SBF :");
                $("#lblStep1").html("Select Proxy SBF to be Removed, in One or More Base SBF(s)");

                $("#btnAddAsProxy").remove();
            }

            $("#txtSBFSelection").next().html($("#ConatntMatter_hdnSBFMstr").val());

            fnGetDetails();
        });

        function fnGetBaseSBFlist() {
            if ($("#txtSBFSelection").val() == "") {
                AutoHideAlertMsg("Please select the Proxy SBF !");
                return false;
            }

            fnGetDetails();
        }

        function fnGetDetails() {
            var SBFNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
            var SBFNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            var flgPage = $("#ConatntMatter_hdnPageType").val();                    // 1 : Add, 2 : Remove

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();

            $("#dvloader").show();
            PageMethods.fnGetDetails(SBFNodeID, SBFNodeType, LoginID, RoleID, UserID, flgPage, fnGetDetails_pass, fnfailed);
        }
        function fnGetDetails_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();

                $("#divReport").html(res.split("|^|")[1]);

                fnUpdateBtnStatus();
            }
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();
                $("#divReport").html(res.split("|^|")[1]);
            }
            else {
                fnfailed();
            }
        }

        function fnSBDTypeSearch(ctrl) {
            var flgValid = 0;
            var colcntr = $("#tblSBDHeader").find("th").length;

            //$("#tblSBDBody").find("tbody").eq(0).find("tr").css("display", "none");
            $("#tblSBDBody").find("tbody").eq(0).find("tr").each(function () {
                flgValid = 1;
                for (var i = 1; i < colcntr; i++) {
                    var filter = $("#tblSBDHeader").find("th").eq(i).find("input[type='text']").eq(0).val().toString().toUpperCase().trim();
                    if (filter != "" && filter.length > 2) {
                        if (i > 1) {
                            var proxysbf = "";
                            $(this).find("td").eq(i).find("span").each(function () {
                                proxysbf += $(this).html() + " ";
                            });
                            if (proxysbf.toUpperCase().indexOf(filter) == -1) {
                                flgValid = 0;
                            }
                        }
                        else {
                            if ($(this).find("td").eq(i).html().toUpperCase().indexOf(filter) == -1) {
                                flgValid = 0;
                            }
                        }
                    }
                }

                if (flgValid == 1) {
                    $(this).attr("flgVisible", "1");
                    $(this).css("display", "table-row");
                }
                else {
                    $(this).attr("flgVisible", "0");
                    $(this).css("display", "none");
                    $(this).find("input[type='checkbox']").removeAttr("checked");
                }
            });
        }

        function fnSBDSelectAll() {
            if ($("#chkSBDSelectAll").is(":checked")) {
                $("#tblSBDBody").find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).find("input[type='checkbox']").prop("checked", true);
                });
            }                
            else
                $("#tblSBDBody").find("input[type='checkbox']").removeAttr("checked");

            fnUpdateBtnStatus();
        }
        function fnSelectSBD(ctrl) {
            if (!($(ctrl).is(":checked"))) {
                $("#chkSBDSelectAll").removeAttr("checked");
            }

            fnUpdateBtnStatus();
        }

        function fnUpdateBtnStatus() {
            // 1 : Add,     2 : Remove
            if ($("#ConatntMatter_hdnPageType").val() == "1") {
                if ($("#divReport").find("input[type='checkbox']:checked").length == 0) {
                    $("#btnAddAsProxy").addClass("btn-disabled");
                    $("#btnAddAsProxy").removeAttr("onclick");
                }
                else {
                    $("#btnAddAsProxy").removeClass("btn-disabled");
                    $("#btnAddAsProxy").attr("onclick", "fnAddProxy()");
                }
            }
            else {
                if ($("#divReport").find("input[type='checkbox']:checked").length == 0) {
                    $("#btnRemoveAsProxy").addClass("btn-disabled");
                    $("#btnRemoveAsProxy").removeAttr("onclick");
                }
                else {
                    $("#btnRemoveAsProxy").removeClass("btn-disabled");
                    $("#btnRemoveAsProxy").attr("onclick", "fnRemoveProxy()");
                }
            }
        }


        function fnAddProxy() {
            var ProxyNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
			if(ProxyNodeID != "0"){
            var ProxyNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var ArrBucket = [];

            $("#tblSBDBody").find("input[iden='SBD']:checked").each(function () {
                ArrBucket.push({
                    "col1": $(this).closest("tr").attr("strId"),
                    "col2": "6"
                });
            });
                        

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to Add <span style='color: #044d91;'>" + $("#txtSBFSelection").val() + "</span> in <span style='color: #044d91;'>" + ArrBucket.length + " Selected Buckets </span> ? </div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "400",
                "height": "200",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        $("#dvloader").show();
                        PageMethods.fnAddProxySBF(ProxyNodeID, ProxyNodeType, ArrBucket, LoginID, fnAddProxySBF_pass, fnfailed);
                    }
                },
                {
                    text: 'No',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
			}
			else {
			$("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Please select the Proxy SBF ! </div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "400",
                "height": "160",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Close',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
			}
        }
        function fnAddProxySBF_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg($("#txtSBFSelection").val() + " successfully added in selected Base SBF(s) !");

                $("#txtSBFSelection").attr("selectedstr", "0|0");
                $("#txtSBFSelection").val("");
                fnGetDetails();

                $("#divConfirm").dialog('destroy');
            }
            else {
                fnfailed();
            }
        }

        function fnRemoveProxy() {
            var ProxyNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
			if(ProxyNodeID != "0"){
            var ProxyNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var ArrBucket = [];

            $("#tblSBDBody").find("input[iden='SBD']:checked").each(function () {
                ArrBucket.push({
                    "col1": $(this).closest("tr").attr("strId"),
                    "col2": "6"
                });
            });


            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to Remove <span style='color: #044d91;'>" + $("#txtSBFSelection").val() + "</span> from <span style='color: #044d91;'>" + ArrBucket.length + " Selected Buckets </span> ? </div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "400",
                "height": "200",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        $("#dvloader").show();
                        PageMethods.fnRemoveProxySBF(ProxyNodeID, ProxyNodeType, ArrBucket, LoginID, fnRemoveProxy_pass, fnfailed);
                    }
                },
                {
                    text: 'No',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
			}
			
			else {
			$("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Please select the Proxy SBF ! </div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "400",
                "height": "160",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Close',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
			}
        }
        function fnRemoveProxy_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg($("#txtSBFSelection").val() + " successfully removed from selected Base SBF(s) !");

                $("#txtSBFSelection").attr("selectedstr", "0|0");
                $("#txtSBFSelection").val("");
                fnGetDetails();

                $("#divConfirm").dialog('destroy');
            }
            else {
                fnfailed();
            }
        }

        function fnRemoveProxySBF(ctrl) {
            var ProxyNodeID = $(ctrl).closest("div").attr("strId");
            var ProxyNodeType = $(ctrl).closest("div").attr("strType");
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var ArrBucket = [];

            ArrBucket.push({
                "col1": $(ctrl).closest("tr").attr("strId"),
                "col2": "6"
            });

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to remove <span style='color: #044d91;'>" + $(ctrl).closest("div").find("span").eq(0).html() + "</span> from <span style='color: #044d91;'>" + $(ctrl).closest("tr").find("td").eq(1).html() +"</span> ? </div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "400",
                "height": "200",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        $("#dvloader").show();
                        PageMethods.fnRemoveProxySBF(ProxyNodeID, ProxyNodeType, ArrBucket, LoginID, fnRemoveProxySBF_pass, fnfailed, ctrl);
                    }
                },
                {
                    text: 'No',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
        }
        function fnRemoveProxySBF_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                $(ctrl).closest("div").remove();

                $("#divConfirm").dialog('destroy');
            }
            else {
                fnfailed();
            }            
        }
    </script>
    <script type="text/javascript">
        function fnSBFPopuptypefilter(ctrl) {
            if ($(ctrl).attr("id") == "txtSBFSelection") {
                $("#divbtnblock").find("a").removeClass("active");
            }

            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $(ctrl).next().show();

                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[0].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).attr("flgVisible", "1");
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
                $(ctrl).next().hide();
            }
        }
        function fnSelectSBF(ctrl) {
            $(ctrl).closest("div").prev().val($(ctrl).find("td").eq(4).html().split("amp;").join(""));
            $(ctrl).closest("div").prev().attr("selectedstr", $(ctrl).attr("nid") + "|" + $(ctrl).attr("ntype"));
			
			$("#divReport").find("input[type='checkbox']").prop("disabled", true);
			$("#divReport").find("input[type='checkbox']").removeAttr("checked");
            $(ctrl).closest("div").hide();
        }
    </script>



    <style type="text/css">
        i {
            cursor: pointer;
        }

        .fsw {
            margin-bottom: 0;
        }

        .fsw-title {
            text-transform: none;
        }

        .fixed-top {
            z-index: 98;
        }

        .bg {
            z-index: 100;
            min-height: 100%;
            width: 100%;
            height: auto;
            top: 0px;
            left: 0px;
            position: fixed;
            display: none;
            background: rgba(0, 0, 0, 0.3);
        }

        .clsInform {
            word-break: break-all;
            white-space: inherit;
        }
    </style>
    <style type="text/css">
        div.clsSBFPopup {
            width: 50%;
            height: 240px;
            display: none;
            z-index: 101;
            overflow-y: auto;
            background: #ffffff;
            border: 1px solid #444;
        }

            div.clsSBFPopup table td {
                padding: 0.1rem 0.3rem;
            }
    </style>
    <style type="text/css">
        div.clsSBD-block {
            margin: 0 0 10px 0;
            border-radius: 4px;
            border: 1px solid #D77100;
        }

            div.clsSBD-block i,
            div.clsSBD-block input[type='checkbox'] {
                height: 11px;
                cursor: pointer;
                margin-right: 10px;
            }

        div.clsSBD {
            color: #ffffff;
            padding: 4px 10px;
            font-size: 0.9rem;
            font-weight: 600;
            background: #FF8600;
        }

        div.clsProxySBF {
            padding: 3px 12px;
            margin: 0 5px 5px 0;
            border-radius: 5px;
            background: #eef4ff;
            display: inline-block;
            border: 1px solid #bfbfff;
        }

            div.clsProxySBF > i {
                height: 10px;
                margin-left: 8px;
                color: #f04f42;
            }

        #tblSBDHeader input[type='text'] {
            width: 100%;
            margin: 3px 0;
            padding-left: 10px;
            border-radius: 3px;
        }

        #tblSBDHeader tr th {
            text-align: center;
            vertical-align: middle;
        }

            #tblSBDHeader tr th:nth-child(1),
            #tblSBDBody tr td:nth-child(1) {
                width: 50px;
                text-align: center;
            }

            #tblSBDHeader tr th:nth-child(2),
            #tblSBDBody tr td:nth-child(2) {
                width: 20%;
            }

        #tblSBDBody tr td:nth-child(2) {
            font-weight: 700;
        }

        #tblSBDBody tr td {
            padding-bottom: 0 !important;
        }
    </style>
    <style type="text/css">
        .btn-inactive {
            color: #F26156 !important;
            background: transparent !important;
        }

        .btn-disabled {
            cursor: not-allowed;
            color: #000 !important;
            box-shadow: none !important;
            background: #888 !important;
            border-color: #888 !important;
        }

        .btn-primary {
            background: #F26156;
            border-color: #F26156;
            color: #fff;
        }

            .btn-primary:focus {
                box-shadow: 0 0 0 0.2rem rgba(216,31,16,0.2) !important;
            }

            .btn-primary:not(:disabled):not(.disabled).active,
            .btn-primary:not(:disabled):not(.disabled):active,
            .show > .btn-primary.drop,
            .btn-primary:active,
            .btn-primary:hover {
                background: #be1b0e !important;
                border-color: #be1b0e;
                color: #fff !important;
            }

        a.btn-small {
            cursor: pointer;
            font-size: 0.6rem;
            margin: 0.2rem 0;
            padding: 0 0.4rem 0.1rem;
            color: #ffffff !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="margin-bottom: 0.1rem;"></h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner pb-2">
            <div class="fsw_inputBox w-100">
                <div class="row">
                    <div class="col-4">
                        <div class="fsw-title" id="lblStep1"></div>
                        <div class="d-block">
                            <div style="position: relative;">
                                <input id='txtSBFSelection' type='text' class='form-control form-control-sm' onclick='fnSBFPopuptypefilter(this);' onkeyup='fnSBFPopuptypefilter(this);' autocomplete="off" placeholder='Type atleast 3 character...' selectedstr="0|0" style="width: 360px;" />
                                <div class="clsSBFPopup" style="position: fixed;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-8">
                        <div class="fsw-title">&nbsp;</div>
                        <div class="d-block">
                            <a href='#' id="btnProxy" onclick="fnGetBaseSBFlist();" class="btn btn-primary btn-sm" style="margin-left: 20px;">Get Base SBF(s)</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divReport"></div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divButtons" style="width: 100%; display: inline-block; text-align: right;">
            <a id="btnAddAsProxy" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnAddSBF();">Add Proxy SBF</a>
            <a id="btnRemoveAsProxy" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnRemoveSBFAsProxy();">Remove Proxy SBF</a>
        </div>
    </div>

    <div id="divMsg" runat="server"></div>
    <div id="divConfirm" style="display: none;"></div>

    <div class="bg" id="bg"></div>
    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnPageType" runat="server" />
    <asp:HiddenField ID="hdnSBFType" runat="server" />

    <asp:HiddenField ID="hdnSBFMstr" runat="server" />
    <asp:HiddenField ID="hdnQuarter" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />

    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
</asp:Content>

