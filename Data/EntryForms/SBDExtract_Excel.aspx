<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="SBDExtract_Excel.aspx.cs" Inherits="_SBDMstr" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ht = 0;
        var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        function GetCurrentDate() {
            var d = new Date();
            var dat = d.getDate();
            var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            if (dat < 10) {
                dat = "0" + dat.toString();
            }
            return (dat + "-" + MonthArr[d.getMonth()] + "-" + d.getFullYear());
        }
        function AddZero(str) {
            if (str.toString().length == 1)
                return "0" + str;
            else
                return str;
        }
        function Maxlvl(str) {
            var lvl = "0";
            if (str != "") {
                lvl = str.split("^")[0].split("|")[1];
                for (var i = 0; i < str.split("^").length; i++) {
                    if (parseInt(str.split("^")[i].split("|")[1]) < parseInt(lvl))
                        lvl = str.split("^")[i].split("|")[1];
                }
            }
            return lvl;
        }
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

        $(document).ready(function () {
            ht = $(window).height();
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));

            $(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            $("#ddlStatus").html($("#ConatntMatter_hdnProcessGrp").val());

            $("#ddlQuarter").html($("#ConatntMatter_hdnQuarter").val().split("|^|")[0]);
            $("#ddlQuarter").val($("#ConatntMatter_hdnQuarter").val().split("|^|")[1]);
            $("#ConatntMatter_hdnQuarter").val($("#ddlQuarter").val());

            $("#ddlMSMPAlies").html($("#ConatntMatter_hdnMSMPAlies").val());
            $("#ddlMSMPAlies").multiselect({
                noneSelectedText: "--Select--"
            }).multiselectfilter();
            $("#ddlMSMPAlies").next().css({
                "height": "calc(1.5em + .5rem + 2px)",
                "font-size": "0.875rem",
                "font-weight": "400",
                "padding": "0.25rem 0 0 0.5rem",
                "padding-right": "0",
                "border-radius": ".2rem",
                "border-color": "#ced4da",
                "width": "90%"
            });
            $("#ddlMSMPAlies").next().find("span.ui-icon").eq(0).css({
                "margin": ".2rem 0",
                "margin-bottom": "0",
                "background-color": "transparent",
                "border": "none"
            });

            var RoleID = $("#ConatntMatter_hdnRoleID").val();
        });

        function fnResetFilter() {
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#btnClusterFilter").attr("selectedstr", "");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");
        }

        function fnGetReport(flg) {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var Qtr = $("#ddlQuarter").val().split("|")[2];
            var Yr = $("#ddlQuarter").val().split("|")[3];
            var ProcessGroup = ""; //$("#ddlStatus").val();

            $("#ConatntMatter_hdnQuarter").val($("#ddlQuarter").val());

            if (PrdString != "") {
                for (var i = 0; i < PrdString.split("^").length; i++) {
                    ProdValues.push({
                        "col1": PrdString.split("^")[i].split("|")[0],
                        "col2": PrdString.split("^")[i].split("|")[1],
                        "col3": "1"
                    });
                }
            }
            else {
                ProdValues.push({ "col1": "0", "col2": "0", "col3": "1" });
            }

            if (LocString != "") {
                for (var i = 0; i < LocString.split("^").length; i++) {
                    LocValues.push({
                        "col1": LocString.split("^")[i],
                        "col2": "0",
                        "col3": "4"
                    });
                }
            }
            else {
                LocValues.push({ "col1": "0", "col2": "0", "col3": "2" });
            }

            if (ChannelString != "") {
                for (var i = 0; i < ChannelString.split("^").length; i++) {
                    ChannelValues.push({
                        "col1": ChannelString.split("^")[i].split("|")[0],
                        "col2": ChannelString.split("^")[i].split("|")[1],
                        "col3": "3"
                    });
                }
            }
            else {
                ChannelValues.push({ "col1": "0", "col2": "0", "col3": "3" });
            }

            var ArrUser = [];
            for (var i = 0; i < $("#ddlMSMPAlies option:selected").length; i++) {
                ArrUser.push({ "col1": $("#ddlMSMPAlies option:selected").eq(i).val() });
            }
            if (ArrUser.length == 0)
                ArrUser.push({ "col1": 0 });

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, RoleID, UserID, ProdValues, LocValues, ChannelValues, ProcessGroup, ArrUser, Qtr, Yr, fnGetReport_pass, fnfailed, flg);
        }
        function fnGetReport_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);
                if (res.split("|^|")[2] == "") {
                    $("#divButtons").html('');
                }
                else {
                    $("#divButtons").html(res.split("|^|")[2]);
                }

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnDownload() {
            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");

            $("#ConatntMatter_hdnProductSelectedValue").val(PrdString);
            $("#ConatntMatter_hdnLocationSelectedValue").val(LocString);
            $("#ConatntMatter_hdnChannelSelectedValue").val(ChannelString);

            var strUser = "";
            for (var i = 0; i < $("#ddlMSMPAlies option:selected").length; i++) {
                strUser += $("#ddlMSMPAlies option:selected").eq(i).val() + "^";
            }
            $("#ConatntMatter_hdnUserSelectedValue").val(strUser);
            $("#ConatntMatter_hdnQuarterSelectedValue").val($("#ddlQuarter").val());
            $("#ConatntMatter_btnDownload").click();
        }
    </script>
    <script type="text/javascript">
        function fnProdPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#chkSelectAllProd").removeAttr("checked");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnShowProdHierPopup(ctrl, cntr) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val(cntr);
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("buckettype"));

            var title = "";
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                title = "Product";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                title = "Site";
            else
                title = "Channel";

            var strtable = "";
            if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:25%;'>Category</th>";
                strtable += "<th style='width:25%;'>Brand</th>";
                strtable += "<th style='width:25%;'>BrandForm</th>";
                strtable += "<th style='width:25%;'>SubBrandForm</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                $("#PopupHierlbl").html("Product Hierarchy");
                $("#ProdLvl").html($("#ConatntMatter_hdnProductLvl").val());
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:15%;'>Country</th>";
                strtable += "<th style='width:20%;'>Region</th>";
                strtable += "<th style='width:20%;'>Site</th>";
                strtable += "<th style='width:25%;'>Distributor</th>";
                strtable += "<th style='width:20%;'>Branch</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                $("#PopupHierlbl").html("Location Hierarchy");
                $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
            }
            else {
                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:33%;'>Class</th>";
                strtable += "<th style='width:34%;'>Channel</th>";
                strtable += "<th style='width:33%;'>Store Type</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                $("#PopupHierlbl").html("Channel Hierarchy");
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
            }

            if (cntr == 0) {
                $("#divHierPopup").dialog({
                    "modal": true,
                    "width": "92%",
                    "height": "560",
                    "title": title + " :",
                    open: function () {
                        if ($(ctrl).attr("ProdLvl") != "" && $(ctrl).attr("ProdLvl") != "0") {
                            $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("ProdHier"));
                            fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("ProdLvl") + "']").eq(0));
                        }
                        else
                            $("#ConatntMatter_hdnSelectedHier").val("");
                    },
                    close: function () {
                        $("#divHierPopup").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Select',
                        class: 'btn-primary',
                        click: function () {
                            var SelectedHierValues = fnProdSelected(ctrl).split("||||");

                            $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                            $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                            $(ctrl).attr("copybuckettd", "0");
                            if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                                $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                            }

                            if (cntr == 1) {
                                var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                                fnAdjustRowHeight(rowIndex);
                            }
                            $("#divHierPopup").dialog('close');
                        }
                    },
                    {
                        text: 'Reset',
                        class: 'btn-primary',
                        click: function () {
                            fnHierPopupReset();
                        }
                    }, {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divHierPopup").dialog('close');
                        }
                    }]
                });
            }
            else {
                $("#divHierPopup").dialog({
                    "modal": true,
                    "width": "92%",
                    "height": "560",
                    "title": title + " :",
                    open: function () {
                        if ($(ctrl).attr("ProdLvl") != "") {
                            $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("ProdHier"));
                            fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("ProdLvl") + "']").eq(0));
                        }
                        else
                            $("#ConatntMatter_hdnSelectedHier").val("");
                    },
                    close: function () {
                        $("#divHierPopup").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Add as New Bucket',
                        class: 'btn-primary',
                        click: function () {
                            if ($("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").length == 0) {
                                AutoHideAlertMsg("Please make your Selection !");
                            }
                            else {
                                $("#divAddNewBucketPopup").dialog({
                                    "modal": true,
                                    "width": "60%",
                                    "title": title + " Bucket :",
                                    open: function () {
                                        $("#txtBucketName").val("");
                                        $("#txtBucketDescription").val("");
                                    },
                                    close: function () {
                                        $("#divAddNewBucketPopup").dialog('destroy');
                                    },
                                    buttons: [{
                                        text: 'Save',
                                        class: 'btn-primary',
                                        click: function () {
                                            if ($("#txtBucketName").val() == "") {
                                                AutoHideAlertMsg("Please enter the Bucket Name !");
                                            }
                                            else if ($("#txtBucketDescription").val() == "") {
                                                AutoHideAlertMsg("Please enter the Bucket Description !");
                                            }
                                            else {
                                                fnSaveNewBucket(ctrl, 0);
                                            }
                                        }
                                    }, {
                                        text: 'Cancel',
                                        class: 'btn-primary',
                                        click: function () {
                                            $("#divAddNewBucketPopup").dialog('close');
                                        }
                                    }]
                                });
                            }

                        }
                    }, {
                        text: 'Select',
                        class: 'btn-primary',
                        click: function () {
                            var SelectedHierValues = fnProdSelected(ctrl).split("||||");
                            $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                            $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                            $(ctrl).attr("copybuckettd", "0");
                            if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                                $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                            }

                            if (cntr == 1) {
                                var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                                fnAdjustRowHeight(rowIndex);
                            }
                            $("#divHierPopup").dialog('close');
                        }
                    },
                    {
                        text: 'Reset',
                        class: 'btn-primary',
                        click: function () {
                            fnHierPopupReset();
                        }
                    }, {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divHierPopup").dialog('close');
                        }
                    }]
                });
            }
        }
        function fnProdLvl(ctrl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();
            var ProdLvl = $(ctrl).attr("ntype");

            $(ctrl).closest("tr").addClass("Active").siblings().removeClass("Active");
            $("#divHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

            var BucketValues = [];
            if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                var Selstr = $("#ConatntMatter_hdnSelectedHier").val();
                for (var i = 0; i < Selstr.split("^").length; i++) {
                    BucketValues.push({
                        "col1": Selstr.split("^")[i].split("|")[0],
                        "col2": Selstr.split("^")[i].split("|")[1],
                        "col3": $("#ConatntMatter_hdnBucketType").val()
                    });
                }
            }

            if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "0", BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                var InSubD = 0;
                PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, BucketValues, InSubD, fnProdHier_pass, fnProdHier_failed);
            }
            else {
                PageMethods.fnChannelHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
        }
        function fnProdHier_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divHierPopupTbl").html(res.split("|^|")[1]);
                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    $("#divHierSelectionTbl").html(res.split("|^|")[2]);
                    $("#ConatntMatter_hdnSelectedHier").val("");
                }

                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length > 0) {
                    var PrevSelLvl = $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                    var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl)) && ($("#ConatntMatter_hdnBucketType").val() == "3")) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html("");
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").each(function () {
                            if (Lvl == $(this).attr("lvl")) {
                                var tr = $("#divHierPopupTbl").find("table").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']");
                                fnSelectHier(tr.eq(0));
                                var trHtml = tr[0].outerHTML;
                                tr.eq(0).remove();
                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                            }
                            else {
                                switch (Lvl) {
                                    case "20":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "30":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "40":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "30") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[bf='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "110":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "120":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "130":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "140":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "130") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[dbr='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "210":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "220":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "210") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[channel='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                }
                            }
                        });
                    }
                }
            }
            else {
                fnProdHier_failed();
            }
        }
        function fnProdHier_failed() {
            $("#divHierPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnHierPopupReset() {
            $("#divHierSelectionTbl").find("tbody").eq(0).html("");

            $("#divHierPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            });
            $("#chkSelectAllProd").removeAttr("checked");

            //if ($("#ConatntMatter_hdnBucketType").val() == "2")
            //    $("#chkIncludeSubd").prop("checked", true);
        }
        function fnSelectHier(ctrl) {
            $(ctrl).attr("flg", "1");
            $(ctrl).addClass("Active");
            $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

            fnAppendSelection(ctrl, 1);
        }
        function fnSelectAllProd(ctrl) {
            if ($(ctrl).is(":checked")) {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "1");
                    $(this).addClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                    fnAppendSelection(this, 1);
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "0");
                    $(this).removeClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                    fnAppendSelection(this, 0);
                });
            }
        }
        function fnSelectUnSelectProd(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                fnAppendSelection(ctrl, 0);
                $("#chkSelectAllProd").removeAttr("checked");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                fnAppendSelection(ctrl, 1);
            }
        }
        function fnAppendSelection(ctrl, flgSelect) {
            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");

            if (flgSelect == 1) {
                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").length == 0) {
                    var strtr = "";
                    if (BucketType == "1") {
                        switch (Lvl) {
                            case "10":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("cat") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='20'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "20":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("brand") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "30":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("bf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][bf='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "40":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("sbf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else if (BucketType == "2") {
                        switch (Lvl) {
                            case "100":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("cntry") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='110'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "110":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("reg") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "120":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("site") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][site='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][site='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "130":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("dbr") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][dbr='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "140":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("branch") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td><td>" + $(ctrl).find("td").eq(6).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else {
                        switch (Lvl) {
                            case "200":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("cls") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='210'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "210":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("channel") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][channel='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "220":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("storetype") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }

                    if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length == 0) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html(strtr);
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).prepend(strtr);
                    }
                }
            }
            else {
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").eq(0).remove();
            }
        }
    </script>
    <script type="text/javascript">
        function fnCopyBucketPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnShowCopyBucketPopup(ctrl) {
            $("#divCopyBucketPopupTbl").html("<div style='margin-top: 25%; text-align: center;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif' /></div>");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("buckettype"));

            var title = "";
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                title = "Product(s) :";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                title = "Site(s) :";
            else if ($("#ConatntMatter_hdnBucketType").val() == "3")
                title = "Channel(s) :";
            else
                title = "Cluster(s) :";

            $("#divCopyBucketPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
                    if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:25%;'>Category</th>";
                        strtable += "<th style='width:25%;'>Brand</th>";
                        strtable += "<th style='width:25%;'>BrandForm</th>";
                        strtable += "<th style='width:25%;'>SubBrandForm</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divCopyBucketSelectionTbl").html(strtable);

                        $("#PopupCopyBucketlbl").html("Product Hierarchy");
                    }
                    else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:15%;'>Country</th>";
                        strtable += "<th style='width:20%;'>Region</th>";
                        strtable += "<th style='width:20%;'>Site</th>";
                        strtable += "<th style='width:25%;'>Distributor</th>";
                        strtable += "<th style='width:20%;'>Branch</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divCopyBucketSelectionTbl").html(strtable);

                        $("#PopupCopyBucketlbl").html("Location Hierarchy");
                    }
                    else if ($("#ConatntMatter_hdnBucketType").val() == "3") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:33%;'>Class</th>";
                        strtable += "<th style='width:34%;'>Channel</th>";
                        strtable += "<th style='width:33%;'>Store Type</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divCopyBucketSelectionTbl").html(strtable);

                        $("#PopupCopyBucketlbl").html("Channel Hierarchy");
                    }
                    else {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:15%;'>Country</th>";
                        strtable += "<th style='width:20%;'>Region</th>";
                        strtable += "<th style='width:20%;'>Site</th>";
                        strtable += "<th style='width:25%;'>Distributor</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divCopyBucketSelectionTbl").html(strtable);

                        $("#PopupCopyBucketlbl").html("Cluster Hierarchy");
                    }

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();
                    var Qtr = $("#ddlQuarter").val().split("|")[2];
                    var Yr = $("#ddlQuarter").val().split("|")[3];

                    var CopyBucketTD = $(ctrl).closest("td[iden='SBD']").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
                    PageMethods.GetBucketbasedonType(LoginID, RoleID, UserID, $("#ConatntMatter_hdnBucketType").val(), Qtr, Yr, GetBucketbasedonType_pass, GetBucketbasedonType_failed, CopyBucketTD);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        if ($("#ConatntMatter_hdnBucketType").val() != "4") {
                            var strCopyBucket = fnCopyBucketSelection();

                            $(ctrl).closest("div").prev().html(strCopyBucket.split("|||")[1]);
                            $(ctrl).closest("td[iden='SBD']").find("img[iden='ProductHier']").eq(0).attr("prodlvl", strCopyBucket.split("|||")[3]);
                            $(ctrl).closest("td[iden='SBD']").find("img[iden='ProductHier']").eq(0).attr("prodhier", strCopyBucket.split("|||")[2]);
                            $(ctrl).closest("td[iden='SBD']").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD", strCopyBucket.split("|||")[0]);
                        }
                        else {
                            var CopyBucketTD = "", descr = "";
                            $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                                CopyBucketTD += "|" + $(this).attr("bucketid");
                                descr += ", " + $(this).find("td").eq(1).html();
                            });
                            if (CopyBucketTD != "") {
                                CopyBucketTD = CopyBucketTD.substring(1);
                                descr = descr.substring(2);
                            }
                            else {
                                CopyBucketTD = "0";
                            }

                            $(ctrl).closest("div").prev().html(descr);
                            $(ctrl).attr("CopyBucketTD", CopyBucketTD);
                        }

                        var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                        fnAdjustRowHeight(rowIndex);
                        $("#divCopyBucketPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        fnCopyBucketPopupReset();
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divCopyBucketPopup").dialog('close');
                    }
                }]
            });
        }

        function fnSelectUnSelectBucket(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                //$("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
            else {
                //var tr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active");
                //tr.eq(0).attr("flg", "0");
                //tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                //tr.eq(0).removeClass("Active");
                //$("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("<tr><td colspan='3' style='text-align: center; padding: 50px 10px 0 10px;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif'/></td></tr>");

                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
            }
            fnGetCopySelHierTbl();
        }
        function fnGetCopySelHierTbl() {
            var BucketValues = [];
            if ($("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").length > 0)
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                    var Selstr = $(this).attr("strvalue");
                    for (var i = 0; i < Selstr.split("^").length; i++) {
                        BucketValues.push({
                            "col1": Selstr.split("^")[i].split("|")[0],
                            "col2": Selstr.split("^")[i].split("|")[1],
                            "col3": $("#ConatntMatter_hdnBucketType").val() == "4" ? "2" : $("#ConatntMatter_hdnBucketType").val()
                        });
                    }
                });

            if (BucketValues.length > 0) {
                $("#dvloader").show();
                PageMethods.GetSelHierTbl(BucketValues, $("#ConatntMatter_hdnBucketType").val(), "0", GetCopySelHierTbl_pass, GetCopySelHierTbl_failed);
            }
            else {
                $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
        }
        function GetCopySelHierTbl_pass(res) {
            $("#dvloader").hide();
            $("#divCopyBucketSelectionTbl").html(res);
        }
        function GetCopySelHierTbl_failed() {
            $("#dvloader").hide();
            $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("<tr><td colspan='3' style='text-align: center; padding: 50px 10px 0 10px;'>Due to some technical reasons, we are unable to Process your request !</td></tr>");
        }

        function fnCopyBucketPopupReset() {
            $("#divCopyBucketPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            var tr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active");
            tr.eq(0).attr("flg", "0");
            tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            tr.eq(0).removeClass("Active");

            $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
        }
    </script>
    <script type="text/javascript">
        function fnClusterPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnShowClusterPopup(ctrl) {
            $("#divClusterPopupTbl").html("<div style='margin-top: 25%; text-align: center;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif' /></div>");

            $("#divClusterPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": "Cluster(s) :",
                open: function () {
                    var strtable = "";
                    strtable += "<table class='table table-bordered table-sm table-hover'>";
                    strtable += "<thead>";
                    strtable += "<tr>";
                    strtable += "<th style='width:15%;'>Country</th>";
                    strtable += "<th style='width:25%;'>Region</th>";
                    strtable += "<th style='width:20%;'>Site</th>";
                    strtable += "<th style='width:35%;'>Distributor</th>";
                    strtable += "</tr>";
                    strtable += "</thead>";
                    strtable += "<tbody>";
                    strtable += "</tbody>";
                    strtable += "</table>";
                    $("#divClusterSelectionTbl").html(strtable);

                    var selectedstr = $(ctrl).attr("selectedstr");

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();
                    var Qtr = $("#ddlQuarter").val().split("|")[2];
                    var Yr = $("#ddlQuarter").val().split("|")[3];

                    PageMethods.GetClusters(LoginID, RoleID, UserID, "4", Qtr, Yr, GetClusters_pass, GetClusters_failed, selectedstr);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var selectedstr = "";
                        $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            selectedstr += "^" + $(this).attr("clusterid");
                        });
                        if (selectedstr != "") {
                            selectedstr = selectedstr.substring(1);
                        }

                        $(ctrl).attr("selectedstr", selectedstr);
                        $("#divClusterPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        fnClusterPopupReset();
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divClusterPopup").dialog('close');
                    }
                }]
            });
        }
        function GetClusters_pass(res, selectedstr) {
            $("#divClusterPopupTbl").html(res)

            if (selectedstr != "") {
                for (var i = 0; i < selectedstr.split("^").length; i++) {
                    var tr = $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[clusterid='" + selectedstr.split("^")[i] + "']");
                    tr.eq(0).attr("flg", "1");
                    tr.eq(0).addClass("Active");
                    tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }
                fnGetSelHierTbl();
            }
        }
        function GetClusters_failed() {
            $("#divClusterPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnSelectUnSelectCluster(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
            }
            fnGetSelHierTbl();
        }
        function fnGetSelHierTbl() {
            var BucketValues = [];
            if ($("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").length > 0)
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                    var Selstr = $(this).attr("strvalue");
                    for (var i = 0; i < Selstr.split("^").length; i++) {
                        BucketValues.push({
                            "col1": Selstr.split("^")[i].split("|")[0],
                            "col2": Selstr.split("^")[i].split("|")[1],
                            "col3": "2"
                        });
                    }
                });

            if (BucketValues.length > 0) {
                $("#dvloader").show();
                PageMethods.GetSelHierTbl(BucketValues, "4", "0", GetSelHierTbl_pass, GetSelHierTbl_failed);
            }
            else {
                $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
        }
        function GetSelHierTbl_pass(res) {
            $("#dvloader").hide();
            $("#divClusterSelectionTbl").html(res);
        }
        function GetSelHierTbl_failed() {
            $("#dvloader").hide();
            $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("<tr><td colspan='4' style='text-align: center; padding: 50px 10px 0 10px;'>Due to some technical reasons, we are unable to Process your request !</td></tr>");
        }

        function fnClusterPopupReset() {
            $("#divClusterPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");

            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                $(this).attr("flg", "0");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                $(this).removeClass("Active");
            });

            $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
        }
    </script>
    <script>
        function fnCollapsefilter(ctrl) {
            $("#Filter").hide();
            $("#divRightReport").height(ht - ($("#Heading").height() + 200));
            $("#divLeftReport").height(ht - ($("#Heading").height() + 200));

            $(ctrl).attr("class", "fa fa-arrow-circle-up");
            $(ctrl).attr("onclick", "fnExpandfilter(this);");
        }
        function fnExpandfilter(ctrl) {
            $("#Filter").show();
            $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
            $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));

            $(ctrl).attr("class", "fa fa-arrow-circle-down");
            $(ctrl).attr("onclick", "fnCollapsefilter(this);");
        }
    </script>
    <script>
        function GetBucketbasedonType_pass(res, CopyBucketTD) {
            $("#divCopyBucketPopupTbl").html(res)

            if (CopyBucketTD != "0") {
                for (var i = 0; i < CopyBucketTD.split("|").length; i++) {
                    var tr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[bucketid='" + CopyBucketTD.split("|")[i] + "']");
                    tr.eq(0).attr("flg", "1");
                    tr.eq(0).addClass("Active");
                    tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }
                fnGetCopySelHierTbl();
            }
        }
        function GetBucketbasedonType_failed() {
            $("#divCopyBucketPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }
        function fnCopyBucketSelection() {
            var IsFirst = true;
            var CopyBucketTD = "0", descr = "", SelectedHier = "", SelectedLvl = "0";

            var trArr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active");
            if (trArr.length > 0) {
                trArr.each(function () {
                    if (IsFirst) {
                        IsFirst = false;
                        CopyBucketTD = $(this).attr("bucketid");
                    }
                    else
                        CopyBucketTD += "|" + $(this).attr("bucketid");
                });

                if ($("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").length > 0) {
                    SelectedLvl = $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                }

                $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    if (parseInt($(this).attr("lvl")) < parseInt(SelectedLvl)) {
                        SelectedLvl = $(this).attr("lvl");
                    }

                    SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                    switch ($(this).attr("lvl")) {
                        case "10":
                            descr += ", " + $(this).find("td").eq(0).html();
                            break;
                        case "20":
                            descr += ", " + $(this).find("td").eq(1).html();
                            break;
                        case "30":
                            descr += ", " + $(this).find("td").eq(2).html();
                            break;
                        case "40":
                            descr += ", " + $(this).find("td").eq(3).html();
                            break;
                        case "100":
                            descr += ", " + $(this).find("td").eq(0).html();
                            break;
                        case "110":
                            descr += ", " + $(this).find("td").eq(1).html();
                            break;
                        case "120":
                            descr += ", " + $(this).find("td").eq(2).html();
                            break;
                        case "130":
                            descr += ", " + $(this).find("td").eq(3).html();
                            break;
                        case "140":
                            descr += ", " + $(this).find("td").eq(4).html();
                            break;
                        case "145":
                            descr += ", " + $(this).find("td").eq(5).html();
                            break;
                        case "200":
                            descr += ", " + $(this).find("td").eq(0).html();
                            break;
                        case "210":
                            descr += ", " + $(this).find("td").eq(1).html();
                            break;
                        case "220":
                            descr += ", " + $(this).find("td").eq(2).html();
                            break;
                    }
                });

                descr = descr.substring(2);
                SelectedHier = SelectedHier.substring(1);
            }

            return CopyBucketTD + "|||" + descr + "|||" + SelectedHier + "|||" + SelectedLvl;
        }
        function fnProdSelected(ctrl) {
            var SelectedLvl = "0", SelectedHier = "", descr = "";
            if ($("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").length > 0) {
                SelectedLvl = $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");
            }

            $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                if (parseInt($(this).attr("lvl")) < parseInt(SelectedLvl)) {
                    SelectedLvl = $(this).attr("lvl");
                }

                SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
                    case "10":
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "20":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "30":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                    case "40":
                        descr += ", " + $(this).find("td").eq(3).html();
                        break;
                    case "100":
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "110":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "120":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                    case "130":
                        descr += ", " + $(this).find("td").eq(3).html();
                        break;
                    case "140":
                        descr += ", " + $(this).find("td").eq(4).html();
                        break;
                    case "145":
                        descr += ", " + $(this).find("td").eq(5).html();
                        break;
                    case "200":
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "210":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "220":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                }
            });

            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                descr = descr.substring(2);
            }

            return SelectedLvl + "||||" + SelectedHier + "||||" + descr;
        }
    </script>
    <style type="text/css">
        table.clsBaseSBFDisable tbody tr {
            background: #ECECEC;
        }

        tr.clsActve {
            background-color: #FFD2A6;
        }
    </style>
    <style type="text/css">
        .clsInform {
            word-break: break-all;
            white-space: inherit;
        }

        i {
            cursor: pointer;
        }

        .d-block-none {
            display: none !important;
        }

        textarea,
        input[type="text"],
        input[type="number"] {
            outline: none;
            border: 1px solid #b5b5b5;
        }

        .fsw_inner {
            border: none !important;
            background: transparent !important;
        }

        .fsw_inputBox {
            background: #fff;
            border-radius: 3px;
            margin-right: 5px;
            border: solid 1px #b9c8e3;
            min-height: 76px;
        }

        .fsw .fsw_inputBox:last-child {
            border-right: solid 1px #b9c8e3;
        }

        .clsExpandCollapse {
            margin-right: 5px;
            margin-left: 5px;
            font-size: 0.8rem;
        }

        .producthrchy {
            background: #F07C00;
        }

        #divProxySBFTbl th {
            white-space: nowrap;
        }

        #divProxySBFTbl table tr.Active,
        #divCopyBucketPopupTbl table tr.Active,
        #divHierPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        #divProxySBFTbl table tr.ActiveBase,
        #divBaseProxySBFTbl table tr.ActiveBase {
            background: #AEAEFF !important;
        }

        .fixed-top {
            z-index: 99 !important;
        }

        #divProxySBFTbl td,
        #divHierSelectionTbl td,
        #divHierPopupTbl td {
            font-size: 0.7rem !important;
        }

        #divProxySBFTbl table tr td:nth-child(1),
        #divProxySBFTbl table tr td:nth-child(7) {
            text-align: center;
        }

        #divBaseSBFTbl table.clstbl-baseSBF th:nth-child(2),
        #divBaseSBFTbl table.clstbl-baseSBF th:nth-child(3),
        #divBaseSBFTbl table.clstbl-baseSBF th:nth-child(4) {
            text-align: center;
        }

        #divBaseSBFTbl table.clstbl-baseSBF tr td:nth-child(2),
        #divBaseSBFTbl table.clstbl-baseSBF tr td:nth-child(4) {
            text-align: center;
        }

        #divBaseSBFTbl table.clstbl-baseSBF tr td:nth-child(3) input {
            text-align: center;
            border-radius: 3px;
            border-color: transparent;
        }

        #divBaseSBFTbl table.clstbl-baseSBF tr td:nth-child(3) img {
            height: 12px;
        }

        input[type='text'] {
            width: 100%;
        }

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

            .btn-primary:not(:disabled):not(.disabled):active,
            .show > .btn-primary.drop,
            .btn-primary:active,
            .btn-primary:hover {
                background: #D81F10 !important;
                border-color: #D81F10;
                color: #fff !important;
            }

            .btn-primary:not(:disabled):not(.disabled).active {
                background: #AA180D !important;
            }

        a.btn-small {
            cursor: pointer;
            font-size: 0.6rem;
            margin: 0.2rem 0;
            padding: 0 0.4rem 0.1rem;
            color: #ffffff !important;
        }

        .btns-outline.active {
            background: #003da7;
            color: #ffffff !important;
        }
    </style>
    <style type="text/css">
        .clsPopup {
            position: absolute;
            display: none;
            z-index: 11;
            left: 0;
            width: 400px;
            background: #fff;
            border-radius: 2px;
            border: 1px solid #ddd;
        }

        .clsPopupSec {
            padding: 5px 10px;
            border-bottom: 2px solid #aaa;
        }

        .clsPopupFilter {
            background: #ccc;
        }

        .clsPopupTypeSearch {
            background: #eee;
        }

        .clsPopupBody {
            padding: 0 10px;
            height: 180px;
            overflow-y: auto;
            border-bottom: 3px solid #eee;
        }

            .clsPopupBody table th {
                font-size: 0.7rem;
                padding: 0.4rem;
            }

            .clsPopupBody table td {
                font-size: 0.6rem;
                padding: 0.2rem;
            }

            .clsPopupBody table tbody tr {
                cursor: pointer;
            }

                .clsPopupBody table tbody tr:hover {
                    background-color: #ccc;
                }

        .clsPopupFooter {
            text-align: right;
        }

            .clsPopupFooter .button1 {
                border-radius: 4px;
                font-weight: 700;
                float: none;
                color: #fff;
            }
    </style>
    <style type="text/css">
        #divReport img {
            cursor: pointer;
        }

        #tblleftfixed tr td:nth-child(1) {
            text-align: center;
        }

        table.clsReport tr td {
            height: 50px;
            min-height: 50px;
        }

        table.clsReport tr th {
            vertical-align: middle;
            box-sizing: border-box;
            white-space: nowrap;
        }

            table.clsReport tr th:nth-child(1) {
                width: 50px;
                min-width: 50px;
                text-align: center;
            }

        table.clsReport tr td:nth-child(1) {
            text-align: center;
        }

        table.clsReport tr th:nth-child(2) {
            width: 40%;
            min-width: 40%;
        }

        span.clstdExpandedContent {
            float: left;
            width: 120px;
            min-width: 120px;
            padding: 0 0 1px 0;
            white-space: normal;
            display: inline-block;
            text-align: left !important;
            font-size: .55rem !important;
        }
    </style>
    <style type="text/css">
        .customtooltip table {
            border-collapse: collapse;
            border-spacing: 0;
            width: 100%;
        }

            .customtooltip table > thead {
                background: #EDEEEE;
                /*color: #003DA7;*/
                text-align: left;
                border-bottom: 2px solid #003DA7 !important;
            }

                .customtooltip table > thead > tr > th,
                .customtooltip table > tbody > tr > td {
                    padding: .3rem;
                    border: 1px solid #dee2e6;
                }

            .customtooltip table > tbody > tr:nth-of-type(2n+1) {
                background-color: rgba(0,61,167,.10);
            }

            .customtooltip table > thead > tr > th:nth-of-type(2n-1),
            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                border-left: 3px solid #4289FF;
            }

            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                color: #003DA7;
            }
    </style>
    <style>
        div.clsAppRuleSlabContainer {
            width: 100%;
            margin-bottom: 2px;
            border: 1px solid #5e84ca;
        }

        div.clsAppRuleHeader {
            background: #044d91;
            color: #fff;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 3px 3px 0 0;
        }

        div.clsAppRuleSubHeader {
            background: #b9d2ff;
            color: #044d91;
            font-weight: 700;
            padding-left: 6px;
        }

            div.clsAppRuleSubHeader i {
                float: right;
                margin: 2px 5px;
                font-size: 0.6rem;
            }

        table.clsAppRule {
            font-size: 0.54rem;
            margin-bottom: 0.2rem;
        }

            table.clsAppRule tr:nth-child(1) th:nth-child(2),
            table.clsAppRule tr:nth-child(1) th:nth-child(3) {
                width: auto;
                min-width: auto;
                white-space: nowrap;
            }

            table.clsAppRule tr td {
                height: auto;
                min-height: auto;
                text-align: left !important;
            }

                table.clsAppRule tr td i {
                    margin: 2px 5px;
                }

        .slab-active {
            background: #F0F8FF !important;
        }
    </style>
    <style>
        table.clstbl-Reject th:nth-child(1) {
            width: 36px;
            text-align: center;
        }

        table.clstbl-Reject th:nth-child(2) {
            width: 200px;
        }

        table.clstbl-Reject tr td:nth-child(1) {
            text-align: center;
        }

        table.clstbl-Reject tr td:nth-child(3) textarea {
            border: none;
        }
    </style>
    <style type="text/css">
        table.clsInitiativeLst th {
            text-align: center;
        }

            table.clsInitiativeLst th:nth-child(1) {
                width: 4%;
            }

            table.clsInitiativeLst th:nth-child(2) {
                width: 8%;
            }

            table.clsInitiativeLst th:nth-child(3),
            table.clsInitiativeLst th:nth-child(4) {
                width: 22%;
            }

            table.clsInitiativeLst th:nth-child(5) {
                width: 28%;
            }

            table.clsInitiativeLst th:nth-child(6) {
                width: 4%;
            }

            table.clsInitiativeLst th:nth-child(7) {
                width: 10%;
            }

        table.clsInitiativeLst tr td:nth-child(1),
        table.clsInitiativeLst tr td:nth-child(2),
        table.clsInitiativeLst tr td:nth-child(6),
        table.clsInitiativeLst tr td:nth-child(7) {
            text-align: center;
        }
    </style>
    <style type="text/css">
        .clsdiv-legend-block {
            margin-right: 12px;
            display: inline-block;
        }

        .clsdiv-legend-color {
            width: 10px;
            height: 10px;
            margin-right: 3px;
            border-radius: 2px;
            border: 1px solid #888;
            display: inline-block;
        }

        .clsdiv-legend-text {
            font-size: 0.72rem;
            display: inline-block;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="font-size: .92rem">
        <i class="fa fa-arrow-circle-down" style="margin-right: 10px;" onclick="fnCollapsefilter(this);"></i>
        SBD Extract
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" id="divHierFilterBlock" style="width: 100%;">
                    <div class="row">
                        <div class="col-2" id="QuarterFilterBlock">
                            <div class="fsw-title">Quarter</div>
                            <div class="d-block">
                                <select id="ddlQuarter" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                            </div>
                        </div>
                        <div class="col-3" id="MSMPFilterBlock">
                            <div class="fsw-title">ms&amp;P</div>
                            <div class="d-block">
                                <select id="ddlMSMPAlies" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="col-3" id="HierFilterBlock">
                            <div class="fsw-title">Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="40" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter">Product</a>
                                <a id="btnClusterFilter" class="btn btn-primary btn-sm" href="#" onclick="fnShowClusterPopup(this);" title="Cluster Filter" selectedstr="">Cluster</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="margin-right: 2%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters">Reset</a>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="fsw-title">Download</div>
                            <div class="d-block">                                
                                <a class="btn btn-primary btn-sm" href="#" onclick="fnDownload();" title="Download SBD Extract">SBD Extract</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active">
            <div id="divReport" style="width: 70%; margin: 0 auto;"></div>
        </div>
    </div>
    <div id="divCopyBucketPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-7">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div id="PopupCopyBucketlbl" class="d-block"></div>
                    </div>
                    <div id="divCopyBucketPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-5">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divCopyBucketSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divHierPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-2">
                <div id="ProdLvl" class="prodLvl"></div>
            </div>
            <div class="col-6">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div id="PopupHierlbl" class="d-block"></div>
                        <a id="btnAddNewNode" class="btns-outline" href="#" onclick="fnAddNewSubBrandForm();" style="display: none;">Add New</a>
                    </div>
                    <div id="divHierPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-4">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divHierSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divClusterPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-7">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div class="d-block">Cluster(s)</div>
                    </div>
                    <div id="divClusterPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-5">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divClusterSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divButtons" style="width: 100%; display: inline-block; text-align: right;"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="divConfirm" style="display: none;"></div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />

    <asp:HiddenField ID="hdnSBDID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnQuarter" runat="server" />
    <asp:HiddenField ID="hdnProcessGrp" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />
    
    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />

    <asp:HiddenField ID="hdnProductSelectedValue" runat="server" />
    <asp:HiddenField ID="hdnLocationSelectedValue" runat="server" />
    <asp:HiddenField ID="hdnChannelSelectedValue" runat="server" />
    <asp:HiddenField ID="hdnUserSelectedValue" runat="server" />
    <asp:HiddenField ID="hdnQuarterSelectedValue" runat="server" />
    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
</asp:Content>
