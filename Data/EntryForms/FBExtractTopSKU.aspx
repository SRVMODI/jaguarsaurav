<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="FBExtractTopSKU.aspx.cs" Inherits="FBExtractTopSKU" ValidateRequest="false" EnableEventValidation="false" %>

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

            //$("#ConatntMatter_ddlQuarter").html($("#ConatntMatter_hdnQuarter").val().split("|^|")[0]);
            //$("#ConatntMatter_ddlQuarter").val($("#ConatntMatter_hdnQuarter").val().split("|^|")[1]);

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
                "width": "250px"
            });
            $("#ddlMSMPAlies").next().find("span.ui-icon").eq(0).css({
                "margin": ".2rem 0",
                "margin-bottom": "0",
                "background-color": "transparent",
                "border": "none"
            });

            var RoleID = $("#ConatntMatter_hdnRoleID").val();
        });

        function fntypefilter() {
            var flgtr = 0, rowindex = 0;
            var filter = $("#txtfilter").val().toUpperCase().split(",");

            if ($("#txtfilter").val().toUpperCase().length > 2) {
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "none");

                var flgValid = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td").eq(12).html().toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }

                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                        flgtr = 1;
                    }

                    rowindex++;
                });

                if (flgtr == 0) {
                    $("#divReport").hide();
                    $("#divMsg").html("No Records found for selected Filters !");
                }
                else {
                    $("#divReport").show();
                    $("#divMsg").html('');
                }
            }
            else {
                $("#divReport").show();
                $("#divMsg").html('');

                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "table-row");
            }
        }
        function fnResetFilter() {
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#btnClusterFilter").attr("selectedstr", "");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");

            $("#btnInitExpandedCollapseMode").show();
            $("#btnInitExpandedCollapseMode").html("Expanded Mode");
            $("#btnInitExpandedCollapseMode").attr("flgCollapse", "0");

            $("#txtfilter").val("");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "table-row");
            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#divReport").show();
            $("#divMsg").html('');
        }

        function fnDownloadCSVExtractReport(flg) {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var FBType = $("#ConatntMatter_ddlFBType").val();
            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var Qtr = MonthArr.indexOf($("#ConatntMatter_ddlQuarter").val().split("|")[0].split("-")[1]) + 1;
            var Yr = $("#ConatntMatter_ddlQuarter").val().split("|")[0].split("-")[2];
            var ProcessGroup = ""; //$("#ddlStatus").val();
            $("#ConatntMatter_hdnQuarter").val($("#ConatntMatter_ddlQuarter").val());

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
                        "col3": "5"
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
            PageMethods.fnDownloadCSVExtractReport(LoginID, RoleID, UserID, FBType, ProdValues, LocValues, ChannelValues, ProcessGroup, ArrUser, Qtr, Yr, fnDownloadCSVExtractReport_pass, fnfailed, flg);
        }
        function fnDownloadCSVExtractReport_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                var FileArr = res.split("|^|")[1].split("|");

                for (var i = 0; i < FileArr.length; i++) {
                    window.open("../../Files/" + FileArr[i] + ".csv");
                }

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnDownloadExcelExtractReport() {
            $("#ConatntMatter_hdnProcessGrpValue").val("");

            var strUser = "";
            for (var i = 0; i < $("#ddlMSMPAlies option:selected").length; i++) {
                strUser += "^" + $("#ddlMSMPAlies option:selected").eq(i).val();
            }
            if (strUser != "")
                strUser = strUser.substring(1);

            $("#ConatntMatter_hdnUserValue").val(strUser);
            $("#ConatntMatter_hdnChannelValue").val($("#txtChannelHierSearch").attr("prodhier"));
            $("#ConatntMatter_hdnProductValue").val($("#txtProductHierSearch").attr("prodhier"));
            $("#ConatntMatter_hdnLocationValue").val($("#btnClusterFilter").attr("selectedstr"));

            $("#ConatntMatter_btnDownload").click();
        }


        function fnExpandContent(cntr) {
            if (cntr == 1) {
                $("#tblReport").attr("IsSBDExpand", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    var sbd = ExtendContentBody($(this).attr("strsbd").split("~")[0]);
                    if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0")
                        $(this).find("td[iden='SBD']").eq(6).html("<div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + sbd + "</div>");
                    else
                        $(this).find("td[iden='SBD']").eq(6).html("<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (sbd.length > 70 ? "<span title='" + sbd + "' class='clsInform'>" + sbd.substring(0, 68) + "..</span>" : sbd) + "</div>");

                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).next().html("SubBrandForm");
            }
            else if (cntr == 2) {
                $("#tblReport").attr("IsLocExpand", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    var loc = ExtendContentBody($(this).attr("strloc").split("~")[0]);
                    if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0")
                        $(this).find("td[iden='SBD']").eq(5).html("<div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + loc + "</div>");
                    else
                        $(this).find("td[iden='SBD']").eq(5).html("<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>");

                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).next().html("Clusters");
            }
            else {
                $("#tblReport").attr("IsChannelExpand", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    var channel = ExtendContentBody($(this).attr("strchannel").split("~")[0]);
                    if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0")
                        $(this).find("td[iden='SBD']").eq(4).html("<div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + channel + "</div>");
                    else
                        $(this).find("td[iden='SBD']").eq(4).html("<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).next().html("Channel");
            }

            Tooltip(".clsInform");
            fnAdjustColumnWidth();
            var trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']");
            for (var i = 0; i < trArr.length; i++) {
                fnAdjustRowHeight(i);
            }
        }
        function fnCollapseContent(cntr) {
            if (cntr == 1) {
                $("#tblReport").attr("IsSBDExpand", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='SBD']").eq(6).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).attr("class", "fa fa-buysellads clsExpandCollapse");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnSBDExpandCollapse']").eq(0).next().html("");
            }
            else if (cntr == 2) {
                $("#tblReport").attr("IsLocExpand", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='SBD']").eq(5).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("class", "fa fa-map-marker clsExpandCollapse");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).next().html("");
            }
            else {
                $("#tblReport").attr("IsChannelExpand", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='SBD']").eq(4).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("class", "fa fa-sitemap clsExpandCollapse");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).next().html("");
            }

            fnAdjustColumnWidth();
            var trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']");
            for (var i = 0; i < trArr.length; i++) {
                fnAdjustRowHeight(i);
            }
        }
        function ExtendContentBody(strfull) {
            return strfull;
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
                    var Qtr = $("#ConatntMatter_ddlQuarter").val().split("|")[2];
                    var Yr = $("#ConatntMatter_ddlQuarter").val().split("|")[3];

                    var CopyBucketTD = $(ctrl).closest("td[iden='SBD']").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
                    PageMethods.GetBucketbasedonType(LoginID, RoleID, UserID, $("#ConatntMatter_hdnBucketType").val(), Qtr, Yr, GetBucketbasedonType_pass, GetBucketbasedonType_failed, CopyBucketTD);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        if ($("#ConatntMatter_hdnBucketType").val() != "5") {
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
                            "col3": $("#ConatntMatter_hdnBucketType").val() == "5" ? "2" : $("#ConatntMatter_hdnBucketType").val()
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
        function fnResetBaseSBFPopupAction() {
            $("#divProxySBFTbl").html($("#ConatntMatter_hdnSBFHierforBasePopup").val());
            $("#divProxySBFTbl").find("table").eq(0).addClass("clsBaseSBFDisable");
            $("#chkSelectAllProd").hide();

            $("#divBaseSBFTbl").show();
            $("#divBaseSBFlbl").show();
            $("#divBaseProxySBFTbl").show();
            $("#divBaseProxySBFlbl").show();
            $("#divBaseSBFTbl").css("height", "190px");
            $("#divBaseProxySBFTbl").css("height", "190px");
            $("#divBaseSBFTbl").find("table").eq(0).find("tbody").eq(0).html("");
            $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).html("");
        }
        function fnShowSBFHierPopup(ctrl) {
            var strtable = "<table class='table table-bordered table-sm table-hover clstbl-baseSBF'>";
            strtable += "<thead>";
            strtable += "<tr>";
            strtable += "<th style='width:50%;'>Base SBF</th>";
            strtable += "<th style='width:15%;'>Proxy SBF</th>";
            strtable += "<th style='width:15%;'>MOQ</th>";
            strtable += "<th style='width:20%;'>Action</th>";
            strtable += "</tr>";
            strtable += "</thead>";
            strtable += "<tbody>";
            strtable += "</tbody>";
            strtable += "</table>";
            $("#divBaseSBFTbl").html(strtable);
            $("#divSelectedBaseSBFTbl").html(strtable);

            strtable = "<table class='table table-bordered table-sm table-hover clstbl-baseProxySBF'>";
            strtable += "<thead>";
            strtable += "<tr>";
            strtable += "<th style='width:20%;'>Brand</th>";
            strtable += "<th style='width:35%;'>BrandForm</th>";
            strtable += "<th style='width:45%;'>SubBrandForm</th>";
            strtable += "</tr>";
            strtable += "</thead>";
            strtable += "<tbody>";
            strtable += "</tbody>";
            strtable += "</table>";
            $("#divBaseProxySBFTbl").html(strtable);

            if ($(ctrl).attr("sbfhiier") != "") {
                var strID = $(ctrl).attr("sbfhiier");
                var strDescr = $(ctrl).closest("div").prev().html();

                for (i = 0; i < strID.split("*").length; i++) {
                    var strBaseSBF = "";
                    strBaseSBF += "<tr strbase='" + strDescr.split(",")[i].trim() + "' nid='" + strID.split("*")[i].split("-")[0].split("|")[0] + "' ntype='" + strID.split("*")[i].split("-")[0].split("|")[1] + "' proxy='" + strID.split("*")[i].split("-")[1] + "' flgActive='0'>";
                    strBaseSBF += "<td>" + strDescr.split(",")[i].trim() + "</td>";
                    strBaseSBF += "<td>" + strID.split("*")[i].split("-")[0].split("|")[2] + "</td>";
                    strBaseSBF += "<td><input type='text' value='" + strID.split("*")[i].split("-")[0].split("|")[3] + "' onfocus='fnMOQFocus(this);' onblur='fnMOQBlur(this);'/></td>";
                    strBaseSBF += "<td><img src='../../Images/cancel.png' title='Remove' onclick='fnRemoveBaseSBF(this);' style='margin-left: 5px;'></td>";
                    strBaseSBF += "</tr>";

                    $("#divSelectedBaseSBFTbl").find("tbody").eq(0).append(strBaseSBF);
                }
            }

            $("#divBaseProxySBFPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "600",
                "title": "Base & Proxy SBF :",
                open: function () {
                    fnResetBaseSBFPopupAction();
                    $("#ConatntMatter_hdnBaseSBFAction").val("0");
                    $("#divBaseSBFActionbtns").find("a").removeClass("active");

                    if ($("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").length > 0) {
                        fnCombi($("#divBaseSBFActionbtns").find("a").eq(1), 2);
                    }

                    $("#divBaseProxySBFPopup").next().css("width", "100%");
                    $("#divBaseProxySBFPopup").next().prepend("<i class='fa fa-file-excel-o' onclick='fnSBDDownload();' style='font-size: 2.2em; color: #EF3A2C; margin-top: 0.3em; margin-left: 2%;'></i>");
                },
                close: function () {
                    $("#divBaseProxySBFPopup").dialog('destroy');
                },
                buttons: [{
                    text: 'Next ',
                    class: 'btn-primary',
                    click: function () {
                        if ($("#divBaseSBFTbl").find("tbody").eq(0).find("tr").length > 0) {
                            if ($("#ConatntMatter_hdnBaseSBFAction").val() == "2")
                                $("#divSelectedBaseSBFTbl").find("tbody").eq(0).html("");

                            $("#divBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                                var MOQ = $(this).find("td").eq(2).find("input[type='text']").eq(0).val();
                                $("#divSelectedBaseSBFTbl").find("tbody").eq(0).append($(this)[0].outerHTML);
                                $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr:last").find("td").eq(2).html("<input type='text' value='" + MOQ + "' onfocus='fnMOQFocus(this);' onblur='fnMOQBlur(this);'/>");
                            });

                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").attr("flgActive", "0");
                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").removeClass("clsActve");

                            fnResetBaseSBFPopupAction();
                            $("#ConatntMatter_hdnBaseSBFAction").val("0");
                            $("#divBaseSBFActionbtns").find("a").removeClass("active");
                        }
                        else
                            AutoHideAlertMsg("Please select the Base-SBF !");
                    }
                },
                {
                    text: 'Final Submit',
                    class: 'btn-primary',
                    click: function () {
                        if ($("#ConatntMatter_hdnBaseSBFAction").val() == "2")
                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).html("");

                        $("#divBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                            var MOQ = $(this).find("td").eq(2).find("input[type='text']").eq(0).val();
                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).append($(this)[0].outerHTML);
                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr:last").find("td").eq(2).html("<input type='text' value='" + MOQ + "' onfocus='fnMOQFocus(this);' onblur='fnMOQBlur(this);'/>");
                        });

                        if ($("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").length > 0) {
                            var strID = "";
                            var strDescr = "";
                            $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                                strID += "*" + $(this).attr("nid") + "|" + $(this).attr("ntype") + "|" + $(this).find("td").eq(1).html() + "|" + $(this).find("td").eq(2).find("input[type='text']").eq(0).val() + "-" + $(this).attr("proxy");
                                strDescr += ", " + $(this).find("td").eq(0).html();
                            });
                            $(ctrl).attr("sbfhiier", strID.substring(1));
                            $(ctrl).closest("div").prev().html(strDescr.substring(2));

                            var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                            fnAdjustRowHeight(rowIndex);
                        }
                        else {
                            $(ctrl).attr("sbfhiier", "");
                            $(ctrl).closest("div").prev().html("");
                        }
                        $("#divBaseProxySBFPopup").dialog('close');
                    }
                }, {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divBaseProxySBFPopup").dialog('close');
                    }
                }]
            });
        }
        function fnSBFTypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#chkSelectAllProd").removeAttr("checked");
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
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
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnCombi(ctrl, cntr) {
            $("#ConatntMatter_hdnBaseSBFAction").val(cntr);
            $(ctrl).addClass("active").siblings().removeClass("active");

            fnResetBaseSBFPopupAction();
            switch (cntr.toString()) {
                case "1":
                    $("#divProxySBFTbl").find("table").eq(0).removeClass("clsBaseSBFDisable");
                    $("#divBaseSBFTbl").css("height", "80px");
                    $("#divBaseProxySBFTbl").css("height", "300px");

                    $("#chkSelectAllProd").show();
                    $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                        $(this).find("td").eq(0).attr("onclick", "fnMarkProxy(this)");
                        $(this).find("td").eq(2).attr("onclick", "fnMarkProxy(this)");
                        $(this).find("td").eq(3).attr("onclick", "fnMarkProxy(this)");
                        $(this).find("td").eq(4).attr("onclick", "fnMarkProxy(this)");
                        $(this).find("td").eq(5).attr("onclick", "fnMarkProxy(this)");

                        if ($("#divSelectedBaseSBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + $(this).attr("ntype") + "']").length > 0) {

                            $(this).find("td").eq(6).attr("onclick", "fnMarkProxy(this)");
                            $(this).find("td").eq(6).html("");
                        }
                        else {
                            $(this).find("td").eq(6).attr("onclick", "fnMarkBaseSBF(this)");
                        }
                    });
                    break;
                case "2":
                    if ($("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").length > 0) {
                        $("#divBaseSBFTbl").find("tbody").eq(0).html($("#divSelectedBaseSBFTbl").find("tbody").eq(0).html());

                        $("#divBaseSBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            $(this).find("td").eq(0).attr("onclick", "fnEditBaseSBF(this)");
                            $(this).find("td").eq(1).attr("onclick", "fnEditBaseSBF(this)");
                            $(this).find("td").eq(3).html("<img src='../../Images/cancel.png' title='Remove' onclick='fnRemoveBaseSBF(this);'/>");
                        });

                        $("#chkSelectAllProd").show();
                        $("#divProxySBFTbl").find("table").eq(0).find("thead").eq(0).find("tr").eq(1).find("th").eq(6).hide();
                        $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            $(this).find("td").eq(6).hide();

                            $(this).find("td").eq(0).attr("onclick", "fnMarkProxy(this)");
                            $(this).find("td").eq(2).attr("onclick", "fnMarkProxy(this)");
                            $(this).find("td").eq(3).attr("onclick", "fnMarkProxy(this)");
                            $(this).find("td").eq(4).attr("onclick", "fnMarkProxy(this)");
                            $(this).find("td").eq(5).attr("onclick", "fnMarkProxy(this)");
                        });
                    }
                    else
                        AutoHideAlertMsg("No Base-SBF found for Editing !");
                    break;
                case "3":
                    $("#divProxySBFTbl").find("table").eq(0).removeClass("clsBaseSBFDisable");
                    $("#divBaseSBFTbl").css("height", "380px");
                    $("#divBaseProxySBFTbl").hide();
                    $("#divBaseProxySBFlbl").hide();

                    $("#divProxySBFTbl").find("table").eq(0).find("thead").eq(0).find("tr").eq(1).find("th").eq(0).hide();
                    $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                        $(this).find("td").eq(0).hide();

                        if ($("#divSelectedBaseSBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + $(this).attr("ntype") + "']").length > 0) {
                            $(this).find("td").eq(6).html("");
                        }
                        else {
                            $(this).find("td").eq(2).attr("onclick", "fnMarkBaseSBF(this)");
                            $(this).find("td").eq(3).attr("onclick", "fnMarkBaseSBF(this)");
                            $(this).find("td").eq(4).attr("onclick", "fnMarkBaseSBF(this)");
                            $(this).find("td").eq(5).attr("onclick", "fnMarkBaseSBF(this)");
                            $(this).find("td").eq(6).attr("onclick", "fnMarkBaseSBF(this)");
                        }
                    });
                    break;
            }
        }

        function fnSelectAllSBF(ctrl) {
            var IsActive = false;
            if ($("#ConatntMatter_hdnBaseSBFAction").val() == "1")
                IsActive = true;
            else if ($("#ConatntMatter_hdnBaseSBFAction").val() == "2" && $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[flgActive='1']").length > 0)
                IsActive = true;

            if (IsActive) {
                if ($(ctrl).is(":checked")) {
                    $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                        $(this).attr("flg", "1");
                        $(this).addClass("Active");
                        $(this).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                    });
                }
                else {
                    $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                        $(this).attr("flg", "0");
                        $(this).removeClass("Active");
                        $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                        if ($(this).attr("flgBase") == "1") {
                            $(this).attr("flgBase", "0");
                            $(this).removeClass("ActiveBase");
                            $(this).find("td").eq(6).html("<i class='fa fa-circle-o'></i>");
                        }
                    });
                }

                fnAddUpdateBaseProxySBF();
            }
        }
        function fnMarkProxy(ctrl) {
            var IsActive = false;
            if ($("#ConatntMatter_hdnBaseSBFAction").val() == "1")
                IsActive = true;
            else if ($("#ConatntMatter_hdnBaseSBFAction").val() == "2" && $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[flgActive='1']").length > 0)
                IsActive = true;

            if (IsActive) {
                if ($(ctrl).closest("tr").attr("flg") == "1") {
                    $(ctrl).closest("tr").attr("flg", "0");
                    $(ctrl).closest("tr").removeClass("Active");
                    $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                    if ($(ctrl).closest("tr").attr("flgBase") == "1") {
                        $(ctrl).closest("tr").attr("flgBase", "0");
                        $(ctrl).closest("tr").removeClass("ActiveBase");
                        $(ctrl).closest("tr").find("td").eq(6).html("<i class='fa fa-circle-o'></i>");
                    }

                    $("#chkSelectAllProd").removeAttr("checked");
                }
                else {
                    $(ctrl).closest("tr").attr("flg", "1");
                    $(ctrl).closest("tr").addClass("Active");
                    $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }

                fnAddUpdateBaseProxySBF();
            }
        }
        function fnMarkBaseSBF(ctrl) {
            var nid = $(ctrl).closest("tr").attr("nid");
            var ntype = $(ctrl).closest("tr").attr("ntype");

            if ($(ctrl).closest("tr").attr("flgBase") == "1") {
                $(ctrl).closest("tr").attr("flgBase", "0");
                $(ctrl).closest("tr").removeClass("ActiveBase");
                $(ctrl).closest("tr").find("td").eq(6).html("<i class='fa fa-circle-o'></i>");

                switch ($("#ConatntMatter_hdnBaseSBFAction").val()) {
                    case "1":
                        fnAddUpdateBaseProxySBF();
                        break;
                    case "3":
                        $(ctrl).closest("tr").attr("flg", "0");
                        $(ctrl).closest("tr").removeClass("Active");
                        $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                        $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[nid='" + nid + "'][ntype='" + ntype + "']").remove();
                        break;
                }
            }
            else {
                var trBase = $(ctrl).closest("tbody").find("tr[flgBase='1']");

                $(ctrl).closest("tr").attr("flg", "1");
                $(ctrl).closest("tr").addClass("Active");
                $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                $(ctrl).closest("tr").attr("flgBase", "1");
                $(ctrl).closest("tr").addClass("ActiveBase");
                $(ctrl).closest("tr").find("td").eq(6).html("<i class='fa fa-circle' style='color: #0000C4;'></i>");

                switch ($("#ConatntMatter_hdnBaseSBFAction").val()) {
                    case "1":
                        if (trBase.length > 0) {
                            trBase.eq(0).attr("flgBase", "0");
                            trBase.eq(0).removeClass("ActiveBase");
                            trBase.eq(0).find("td").eq(6).html("<i class='fa fa-circle-o'></i>");
                            $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[nid='" + trBase.eq(0).attr("nid") + "'][ntype='" + trBase.eq(0).attr("ntype") + "']").remove();
                        }

                        fnAddUpdateBaseProxySBF();
                        break;
                    case "3":
                        fnAddBaseSBFtr($(ctrl).closest("tr"), $(ctrl).closest("tr"), "1");
                        break;
                }
            }
        }

        function fnAddUpdateBaseProxySBF() {
            $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).html("");
            var ProxySBF = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']");
            var BaseSBF = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgBase='1']");

            if (BaseSBF.length > 0) {
                var MOQ = "1";
                if ($("#divBaseSBFTbl").find("tbody").eq(0).find("tr[nid='" + BaseSBF.eq(0).attr("nid") + "'][ntype='" + BaseSBF.eq(0).attr("ntype") + "']").length > 0) {
                    MOQ = $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[nid='" + BaseSBF.eq(0).attr("nid") + "'][ntype='" + BaseSBF.eq(0).attr("ntype") + "']").find("input[type='text']").val();
                }

                switch ($("#ConatntMatter_hdnBaseSBFAction").val()) {
                    case "1":
                        $("#divBaseSBFTbl").find("tbody").eq(0).html("");
                        break;
                    case "2":
                        $("#divBaseSBFTbl").find("tbody").eq(0).find("tr[flgActive='1']").remove();
                        break;
                }
                fnAddBaseSBFtr(BaseSBF, ProxySBF, MOQ);
            }
            if (ProxySBF.length > 0) {
                fnUpdateProxyList(ProxySBF);
            }
        }
        function fnUpdateProxyList(ProxySBF) {
            var str = "";
            ProxySBF.each(function () {
                str = "";
                if ($(this).attr("flgBase") == "1") {
                    str += "<tr class='ActiveBase'>";
                }
                else {
                    str += "<tr>";
                }
                str += "<td>" + $(this).find("td").eq(3).html() + "</td>";
                str += "<td>" + $(this).find("td").eq(4).html() + "</td>";
                str += "<td>" + $(this).find("td").eq(5).html() + "</td>";
                str += "<tr>";

                if ($(this).attr("flgBase") == "1") {
                    $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).prepend(str);
                }
                else {
                    $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).append(str);
                }
            });
        }
        function fnAddBaseSBFtr(BaseSBF, ProxySBF, MOQ) {
            var strProxySBF = "";
            for (var i = 0; i < ProxySBF.length; i++) {
                strProxySBF += "^" + ProxySBF.eq(i).attr("nid") + "|" + ProxySBF.eq(i).attr("ntype");
            }

            var strBaseSBF = "";
            if ($("#ConatntMatter_hdnBaseSBFAction").val() != "2") {
                strBaseSBF += "<tr strbase='" + BaseSBF.eq(0).find("td").eq(5).html() + "' nid='" + BaseSBF.eq(0).attr("nid") + "' ntype='" + BaseSBF.eq(0).attr("ntype") + "' proxy='" + strProxySBF.substring(1) + "' flgActive='1' class='clsActve'>";
                strBaseSBF += "<td>" + BaseSBF.eq(0).find("td").eq(5).html() + "</td>";
                strBaseSBF += "<td>" + ProxySBF.length + "</td>";
                strBaseSBF += "<td><input type='text' value='" + MOQ + "' onfocus='fnMOQFocus(this);' onblur='fnMOQBlur(this);'/></td>";
            }
            else {
                strBaseSBF += "<tr strbase='" + BaseSBF.eq(0).find("td").eq(5).html() + "' nid='" + BaseSBF.eq(0).attr("nid") + "' ntype='" + BaseSBF.eq(0).attr("ntype") + "' proxy='" + strProxySBF.substring(1) + "' flgActive='1' class='clsActve'>";
                strBaseSBF += "<td onclick='fnEditBaseSBF(this);'>" + BaseSBF.eq(0).find("td").eq(5).html() + "</td>";
                strBaseSBF += "<td onclick='fnEditBaseSBF(this);'>" + ProxySBF.length + "</td>";
                strBaseSBF += "<td><input type='text' value='" + MOQ + "' onfocus='fnMOQFocus(this);' onblur='fnMOQBlur(this);'/></td>";
            }
            strBaseSBF += "<td><img src='../../Images/cancel.png' title='Remove' onclick='fnRemoveBaseSBF(this);'></td>";
            strBaseSBF += "</tr>";

            $("#divBaseSBFTbl").find("tbody").eq(0).prepend(strBaseSBF);
        }
        function fnEditBaseSBF(ctrl) {
            fnClearProxySBFSel();
            $("#divProxySBFTbl").find("table").eq(0).removeClass("clsBaseSBFDisable");
            $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).html("");

            $(ctrl).closest("tr").attr("flgActive", "1").siblings().attr("flgActive", "0");
            $(ctrl).closest("tr").addClass("clsActve").siblings().removeClass("clsActve");


            var nid = $(ctrl).closest("tr").attr("nid");
            var proxy = $(ctrl).closest("tr").attr("proxy");
            for (var i = 0; i < proxy.split("^").length; i++) {
                var sbftr = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + proxy.split("^")[i].split("|")[0] + "'][ntype='" + proxy.split("^")[i].split("|")[1] + "']");

                var str = "";
                if (nid == proxy.split("^")[i].split("|")[0])
                    str += "<tr class='ActiveBase'>";
                else
                    str += "<tr>";
                str += "<td>" + sbftr.eq(0).find("td").eq(3).html() + "</td>";
                str += "<td>" + sbftr.eq(0).find("td").eq(4).html() + "</td>";
                str += "<td>" + sbftr.eq(0).find("td").eq(5).html() + "</td>";
                str += "<tr>";
                if (nid == proxy.split("^")[i].split("|")[0])
                    $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).prepend(str);
                else
                    $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).append(str);

                // ------------------------------------------------------------------------------------------
                sbftr.eq(0).attr("flg", "1");
                sbftr.eq(0).addClass("Active");
                sbftr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                if (nid == proxy.split("^")[i].split("|")[0]) {
                    sbftr.eq(0).attr("flgBase", "1");
                    sbftr.eq(0).addClass("ActiveBase");
                    sbftr.eq(0).find("td").eq(6).html("<i class='fa fa-circle' style='color: #0000C4;'></i>");
                }

                var trHTML = sbftr[0].outerHTML;
                sbftr.eq(0).remove();
                $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHTML);
            }
        }
        function fnClearProxySBFSel() {
            $("#divProxySBFTbl").find("table").eq(0).addClass("clsBaseSBFDisable");
            $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                if ($(this).attr("flgBase") == "1") {
                    $(this).attr("flgBase", "0");
                    $(this).removeClass("ActiveBase");
                    $(this).find("td").eq(6).html("<i class='fa fa-circle-o'></i>");
                }
            });
        }
        function fnRemoveBaseSBF(ctrl) {
            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to remove Base SBF - <span style='color:#0000ff; font-weight: 700;'>" + $(ctrl).closest("tr").attr("strBase") + "</span>.<br/>Do you want to continue ?</div>");

            $("#divConfirm").dialog({
                "modal": true,
                "width": "320",
                "height": "200",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        fnClearProxySBFSel();
                        $(ctrl).closest("tr").remove();
                        $("#divBaseProxySBFTbl").find("table").eq(0).find("tbody").eq(0).html("");

                        $("#divConfirm").dialog('close');
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

        function fnMOQFocus(ctrl) {

            if ($(ctrl).val() == "0")
                $(ctrl).val("");
        }
        function fnMOQBlur(ctrl) {
            if ($(ctrl).val() == "")
                $(ctrl).val("0");
        }

        function fnSBDDownload() {
            $("#dvloader").show();

            var Arr = [];

            if ($("#ConatntMatter_hdnBaseSBFAction").val() == "2") {
                $("#divBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                    var strBase = $(this).attr("strbase");
                    var proxy = $(this).closest("tr").attr("proxy");
                    var MOQ = $(this).closest("tr").find("input").eq(0).val();

                    Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": strBase });

                    for (var i = 0; i < proxy.split("^").length; i++) {
                        if ($(this).attr("nid") != proxy.split("^")[i].split("|")[0]) {
                            var proxySbf = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + proxy.split("^")[i].split("|")[0] + "'][ntype='" + proxy.split("^")[i].split("|")[1] + "']").eq(0).find("td").eq(5).html();

                            Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": proxySbf });
                        }
                    }
                });
            }
            else {
                $("#divSelectedBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                    var strBase = $(this).attr("strbase");
                    var proxy = $(this).closest("tr").attr("proxy");
                    var MOQ = $(this).closest("tr").find("input").eq(0).val();

                    Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": strBase });

                    for (var i = 0; i < proxy.split("^").length; i++) {
                        if ($(this).attr("nid") != proxy.split("^")[i].split("|")[0]) {
                            var proxySbf = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + proxy.split("^")[i].split("|")[0] + "'][ntype='" + proxy.split("^")[i].split("|")[1] + "']").eq(0).find("td").eq(5).html();

                            Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": proxySbf });
                        }
                    }
                });

                $("#divBaseSBFTbl").find("tbody").eq(0).find("tr").each(function () {
                    var strBase = $(this).attr("strbase");
                    var proxy = $(this).closest("tr").attr("proxy");
                    var MOQ = $(this).closest("tr").find("input").eq(0).val();

                    Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": strBase });

                    for (var i = 0; i < proxy.split("^").length; i++) {
                        if ($(this).attr("nid") != proxy.split("^")[i].split("|")[0]) {
                            var proxySbf = $("#divProxySBFTbl").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + proxy.split("^")[i].split("|")[0] + "'][ntype='" + proxy.split("^")[i].split("|")[1] + "']").eq(0).find("td").eq(5).html();

                            Arr.push({ "Base SBF": strBase, "MOQ": MOQ, "Proxy SBF": proxySbf });
                        }
                    }
                });
            }

            setTimeout(function () {
                $("#dvloader").hide();
            }, 1000);

            if (Arr.length == 0) {
                AutoHideAlertMsg("No Base-Proxy SBF Mapping Found !");
            }
            else {
                $("#ConatntMatter_hdnjsonarr").val(JSON.stringify(Arr));
                $("#ConatntMatter_btnSBDDownload").click();
            }

            return false;
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
        function fnShowClusterPopup(ctrl, flg) {   // 1: filter, 2: In Tbl
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
                    strtable += "<th style='width:15%;'>Region</th>";
                    strtable += "<th style='width:20%;'>Site</th>";
                    strtable += "<th style='width:35%;'>Distributor</th>";
                    strtable += "<th style='width:15%;'>Branch</th>";
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
                    var Qtr = MonthArr.indexOf($("#ConatntMatter_ddlQuarter").val().split("|")[0].split("-")[1]) + 1;
                    var Yr = $("#ConatntMatter_ddlQuarter").val().split("|")[0].split("-")[2];

                    PageMethods.GetClusters(LoginID, RoleID, UserID, "5", Qtr, Yr, GetClusters_pass, GetClusters_failed, selectedstr);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var selectedstr = "", descr = "";
                        $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            selectedstr += "^" + $(this).attr("clusterid");
                            descr += ", " + $(this).find("td").eq(1).html();
                        });
                        if (selectedstr != "") {
                            selectedstr = selectedstr.substring(1);
                            descr = descr.substring(2);
                        }

                        $(ctrl).attr("selectedstr", selectedstr);
                        if (flg == 2) {
                            $(ctrl).closest("div").prev().html(descr);
                        }
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
                PageMethods.GetSelHierTbl(BucketValues, "2", "0", GetSelHierTbl_pass, GetSelHierTbl_failed);
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

        function fnSaveNewBucket(ctrl, cntr) {
            var SelectedHierValues = fnProdSelected(ctrl).split("||||");

            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var BucketName = $("#txtBucketName").val();
            var BucketDescr = $("#txtBucketDescription").val();
            var BucketValues = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var PrdLvl = SelectedHierValues[0];
            var PrdString = SelectedHierValues[1];

            for (var i = 0; i < PrdString.split("^").length; i++) {
                BucketValues.push({
                    "col1": PrdString.split("^")[i].split("|")[0],
                    "col2": PrdString.split("^")[i].split("|")[1],
                    "col3": BucketType
                });
            }

            switch (cntr.toString()) {
                case "0":
                    $("#dvloader").show();
                    PageMethods.fnSaveAsNewBucket(BucketName, BucketDescr, BucketType, BucketValues, LoginID, PrdLvl, PrdString, fnSaveAsNewBucket_pass, fnfailed, ctrl);
                    break;
                case "1":
                    $("#dvloader").show();
                    PageMethods.fnSaveAsNewBucket(BucketName, BucketDescr, BucketType, BucketValues, LoginID, PrdLvl, PrdString, fnSaveAsNewBucketBaseProd_pass, fnfailed, ctrl);
                    break;
                case "2":
                    $("#dvloader").show();
                    PageMethods.fnSaveAsNewBucket(BucketName, BucketDescr, BucketType, BucketValues, LoginID, PrdLvl, PrdString, fnSaveAsNewBucketInitProd_pass, fnfailed, ctrl);
                    break;
            }
        }
        function fnSaveAsNewBucket_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                $(ctrl).attr("copybuckettd", res.split("|^|")[1]);

                var SelectedHierValues = fnProdSelected(ctrl).split("||||");
                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                }

                $("#divAddNewBucketPopup").dialog('close');
                $("#divHierPopup").dialog('close');
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("Bucket name already exist !");
            }
            else {
                AutoHideAlertMsg("Due to some technical reasons, we are unable to create new Bucket !");
            }
            $("#dvloader").hide();
        }
        function fnSaveAsNewBucketBaseProd_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                $(ctrl).attr("copybuckettd", res.split("|^|")[1]);

                var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                var SelectedHierValues = fnProdSelected(ctrl).split("||||");

                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                if (SelectedHierValues[2] != "") {
                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                    fnUpdateInitProdSel(ctrl, 2);

                    fnUpdateOtherSlabAndInitProdSel(ctrl, 2, "0||||" + SelectedHierValues[0] + "||||" + SelectedHierValues[1] + "||||" + SelectedHierValues[2]);
                }
                else {
                    $(ctrl).closest("div").prev().html("Select Products Applicable in Group");
                }

                fnAdjustRowHeight(rowIndex);

                $("#divAddNewBucketPopup").dialog('close');
                $("#divHierPopup").dialog('close');
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("Bucket name already exist !");
            }
            else {
                AutoHideAlertMsg("Due to some technical reasons, we are unable to create new Bucket !");
            }
            $("#dvloader").hide();
        }
        function fnSaveAsNewBucketInitProd_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                $(ctrl).attr("copybuckettd", res.split("|^|")[1]);

                var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                var SelectedHierValues = fnProdSelected(ctrl).split("||||");

                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                if (SelectedHierValues[2] != "") {
                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                }
                else {
                    $(ctrl).closest("div").prev().html("Select Products");
                }
                fnAdjustRowHeight(rowIndex);

                $("#divAddNewBucketPopup").dialog('close');
                $("#divHierPopup").dialog('close');
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("Bucket name already exist !");
            }
            else {
                AutoHideAlertMsg("Due to some technical reasons, we are unable to create new Bucket !");
            }
            $("#dvloader").hide();
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
        <%--<i class="fa fa-arrow-circle-down" style="margin-right: 10px;" onclick="fnCollapsefilter(this);"></i>--%>
        FOCUS BRAND EXTRACT TOP SKU
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 12%;">
                    <div class="fsw-title">FB Type</div>
                    <div class="d-block">
                        <asp:DropDownList ID="ddlFBType" runat="server" CssClass="form-control form-control-sm">
                            <asp:ListItem Value="1">Base</asp:ListItem>
                            <asp:ListItem Value="2">Top-Up</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 15%;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <asp:DropDownList ID="ddlQuarter" runat="server" CssClass="form-control form-control-sm"></asp:DropDownList>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 14%; padding: 6px 10px; display: none;">
                    <div class="fsw-title">Stage</div>
                    <div class="d-block">
                        <select id="ddlStatus" class="form-control form-control-sm"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divHierFilterBlock" style="width: 48%;">
                    <div class="row">
                        <div class="col-6" id="MSMPFilterBlock">
                            <div class="fsw-title">ms&amp;P</div>
                            <div class="d-block">
                                <select id="ddlMSMPAlies" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="col-6" id="HierFilterBlock">
                            <div class="fsw-title">Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="40" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter">Product</a>
                                <a id="btnClusterFilter" class="btn btn-primary btn-sm" href="#" onclick="fnShowClusterPopup(this);" title="Cluster Filter" selectedstr="">Cluster</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="margin-right: 2%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters">Reset</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 25%;">
                    <div class="fsw-title">&nbsp;</div>
                    <a id="btnShowRpt" class="btn btn-primary btn-sm" href="#" onclick="fnDownloadExcelExtractReport();" title="Download Focus Brand Extract">Download Focus Brand Top SKU Extract</a>
                    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
                </div>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active">
            <div id="divReport" style="width: 50%; margin: 0 auto;"></div>
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
    <asp:HiddenField ID="hdnBucketID" runat="server" />
    <asp:HiddenField ID="hdnBucketName" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />
    <asp:HiddenField ID="hdnProcessGrp" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    <asp:HiddenField ID="hdnIsNewAdditionAllowed" runat="server" />
    <asp:HiddenField ID="hdnjsonarr" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />
    <asp:HiddenField ID="hdnBaseSBFAction" runat="server" />

    <asp:HiddenField ID="hdnUserValue" runat="server" />
    <asp:HiddenField ID="hdnChannelValue" runat="server" />
    <asp:HiddenField ID="hdnProductValue" runat="server" />
    <asp:HiddenField ID="hdnLocationValue" runat="server" />
    <asp:HiddenField ID="hdnProcessGrpValue" runat="server" />
    <asp:HiddenField ID="hdnBrandFormlstforNewNode" runat="server" />
</asp:Content>
