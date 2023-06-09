﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="Initiative.aspx.cs" Inherits="_BucketMstr" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ht = 0;
        var SaveCntr = 0;
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
            $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 220));
            $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 220));

            $(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            $("#ddlMonth").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonth").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);

            $("#ddlStatus").html($("#ConatntMatter_hdnProcessGrp").val().split("^")[0]);
            $("#divLegends").html($("#ConatntMatter_hdnProcessGrp").val().split("^")[1]);

            $("#ddlMonthPopup").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonthPopup").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);

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
                "width": "210px"
            });
            $("#ddlMSMPAlies").next().find("span.ui-icon").eq(0).css({
                "margin": ".2rem 0",
                "margin-bottom": "0",
                "background-color": "transparent",
                "border": "none"
            });

            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            if (RoleID == "2") {
                $("#divAddNewFilterBlock").css("display", "none");
                $("#divTypeSearchFilterBlock").css("width", "68%");
            }

            fnGetReport(1);
        });

        function fnShowHierFilter(ctrl) {
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var flgVisibleHierFilter = $(ctrl).attr("flgVisibleHierFilter");
            if (flgVisibleHierFilter == "0") {
                $(ctrl).css("color", "#0076FF");
                $(ctrl).attr("flgVisibleHierFilter", "1");

                if (RoleID == "1" || RoleID == "2" || RoleID == "4") {
                    $("#MSMPFilterBlock").show();
                    $("#HierFilterBlock").show();
                    $("#HierFilterBlock").attr("class", "col-5");
                    $("#BookmarkFilterBlock").attr("class", "col-3");

                    $("#divHierFilterBlock").css("width", "54%");
                    $("#divTypeSearchFilterBlock").css("width", "13%");
                    if (RoleID == "2") {
                        $("#divTypeSearchFilterBlock").css("width", "26%");
                    }
                }
                else {
                    $("#MSMPFilterBlock").hide();
                    $("#HierFilterBlock").show();
                    $("#HierFilterBlock").attr("class", "col-7");
                    $("#BookmarkFilterBlock").attr("class", "col-5");

                    $("#divHierFilterBlock").css("width", "39%");
                    $("#divTypeSearchFilterBlock").css("width", "28%");
                    if (RoleID == "2") {
                        $("#divTypeSearchFilterBlock").css("width", "41%");
                    }
                }
            }
            else {
                $(ctrl).css("color", "#666666");
                $(ctrl).attr("flgVisibleHierFilter", "0");

                $("#divHierFilterBlock").css("width", "12%");
                $("#divTypeSearchFilterBlock").css("width", "55%");
                if (RoleID == "2") {
                    $("#divTypeSearchFilterBlock").css("width", "68%");
                }

                $("#txtProductHierSearch").attr("InSubD", "0");
                $("#txtProductHierSearch").attr("prodhier", "");
                $("#txtProductHierSearch").attr("prodlvl", "");
                $("#txtLocationHierSearch").attr("InSubD", "0");
                $("#txtLocationHierSearch").attr("prodhier", "");
                $("#txtLocationHierSearch").attr("prodlvl", "");
                $("#txtChannelHierSearch").attr("InSubD", "0");
                $("#txtChannelHierSearch").attr("prodhier", "");
                $("#txtChannelHierSearch").attr("prodlvl", "");

                $("#MSMPFilterBlock").hide();
                $("#HierFilterBlock").hide();
                $("#BookmarkFilterBlock").attr("class", "col-12");
            }
        }
        function fntypefilter() {
            var flgtr = 0, rowindex = 0;
            var filter = $("#txtfilter").val().toUpperCase().split(",");

            if ($("#txtfilter").val().toUpperCase().length > 2) {
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "none");
                $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td").eq(18).html().toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }

                    if (flgValid == 1) {
                        $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).css("display", "table-row");
                        $(this).css("display", "table-row");
                        flgtr = 1;
                    }

                    rowindex++;
                });

                if (flgtr == 0) {
                    $("#btnInitExpandedCollapseMode").hide();
                    $("#divReport").hide();
                    $("#divMsg").html("No Records found for selected Filters !");
                }
                else {
                    $("#btnInitExpandedCollapseMode").show();
                    $("#divReport").show();
                    $("#divMsg").html('');
                }
            }
            else {
                $("#btnInitExpandedCollapseMode").show();
                $("#divReport").show();
                $("#divMsg").html('');

                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
                $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnResetFilter() {
            //$("#txtFromDate").val("");
            //$("#txtToDate").val("");
            $("#txtProductHierSearch").attr("InSubD", "0");
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#txtLocationHierSearch").attr("InSubD", "0");
            $("#txtLocationHierSearch").attr("prodhier", "");
            $("#txtLocationHierSearch").attr("prodlvl", "");
            $("#txtChannelHierSearch").attr("InSubD", "0");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");

            $("#btnInitExpandedCollapseMode").show();
            $("#btnInitExpandedCollapseMode").html("Expanded Mode");
            $("#btnInitExpandedCollapseMode").attr("flgCollapse", "0");

            $("#txtfilter").val("");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#divReport").show();
            $("#divMsg").html('');

            fnGetReport(0);
        }

        function fnGetReport(flg) {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#txtLocationHierSearch").attr("prodhier");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var FromDate = $("#ddlMonth").val().split("|")[0]; //$("#txtFromDate").val();
            var ToDate = $("#ddlMonth").val().split("|")[1]; //$("#txtToDate").val();
            var ProcessGroup = $("#ddlStatus").val();

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
                        "col1": LocString.split("^")[i].split("|")[0],
                        "col2": LocString.split("^")[i].split("|")[1],
                        "col3": "2"
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
            PageMethods.fnGetReport(LoginID, RoleID, UserID, FromDate, ToDate, ProdValues, LocValues, ChannelValues, ProcessGroup, ArrUser, fnGetReport_pass, fnfailed, flg);
        }
        function fnGetReport_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                $("#divRightReport").html(res.split("|^|")[1]);
                if (res.split("|^|")[2] == "") {
                    $("#divButtons").html('');
                }
                else {
                    $("#divButtons").html(res.split("|^|")[2]);
                }

                $("#ConatntMatter_hdnIsNewAdditionAllowed").val(res.split("|^|")[3]);
                if (res.split("|^|")[3] == "1") {
                    $("#btnAddNewINIT").removeClass("btn-disabled");
                    $("#btnAddNewINIT").attr("onclick", "fnAddNew();");

                    $("#btnCopyINIT").removeClass("btn-disabled");
                    $("#btnCopyINIT").attr("onclick", "fnCopyMultiInitiativePopup();");
                }
                else {
                    $("#btnAddNewINIT").addClass("btn-disabled");
                    $("#btnAddNewINIT").removeAttr("onclick");

                    $("#btnCopyINIT").addClass("btn-disabled");
                    $("#btnCopyINIT").removeAttr("onclick");
                }

                $("#divLegends").html(res.split("|^|")[4]);

                var leftfixed = "";
                trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']");
                leftfixed += "<table id='tblleftfixed' class='table table-striped table-bordered table-sm clsReport' style='width:99.8%;'>";
                leftfixed += "<thead>";
                leftfixed += "<tr>";
                for (var i = 0; i < 5; i++) {
                    leftfixed += "<th>" + $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(i).html() + "</th>";
                }
                leftfixed += "</tr>";
                leftfixed += "</thead>";
                leftfixed += "<tbody>";
                for (h = 0; h < trArr.length; h++) {
                    leftfixed += "<tr Init='" + trArr.eq(h).attr("Init") + "' INITName='" + trArr.eq(h).attr("INITName") + "' flgEdit='0'>";
                    for (var i = 0; i < 5; i++) {
                        if (i == 0) {
                            leftfixed += "<td style='background: " + trArr.eq(h).find("td").eq(i).css("background-color") + ";'>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
                        }
                        else if (i == 1) {
                            leftfixed += "<td>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
                        }
                        else if (i == 2) {
                            leftfixed += "<td class='clstdAction'>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
                        }
                        else {
                            leftfixed += "<td style='font-size: 0.7rem;'>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
                        }
                    }
                    leftfixed += "</tr>";
                }
                leftfixed += "</tbody>";
                leftfixed += "</table>";
                $("#divLeftReport").html(leftfixed);

                var ht = $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(0).height();
                $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(0).height(ht);
                $("#tblleftfixed").find("thead").eq(0).find("tr").eq(0).find("th").eq(0).height(ht);

                $("#divRightReport").scroll(function () {
                    $("#divLeftReport").scrollTop($(this).scrollTop());
                });

                $("#tblReport").css("margin-left", "-424px");

                fnCreateHeader();
                if ($("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).attr("Init") == "0") {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).remove();
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(0).remove();
                }

                if ($("#divLeftReport").find("tbody").eq(0).find("tr").length == 0) {
                    var ht = $(window).height();
                    $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 240));
                    $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 240));
                }

                $("#btnInitExpandedCollapseMode").html("Collapsed Mode");
                $("#btnInitExpandedCollapseMode").attr("flgCollapse", "1");

                Tooltip(".clsInform");
                $("#dvloader").hide();
                //AutoHideAlertMsg(res.split("|^|")[5]);
            }
            else {
                fnfailed();
            }
        }

        function fnCreateHeader() {
            var fixedHeader = "";
            fixedHeader += "<table id='tblleftfixedHeader' class='table table-striped table-bordered table-sm clsReport' style='width:99.8%; margin-bottom: 0;'>";
            fixedHeader += "<thead>";
            fixedHeader += "<tr>";
            for (var i = 0; i < 5; i++) {
                fixedHeader += "<th>" + $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(i).html() + "</th>";
            }
            fixedHeader += "</tr>";
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divLeftReportHeader").html(fixedHeader);

            for (i = 0; i < $("#tblleftfixed").find("th").length; i++) {
                var th_wid = $("#tblleftfixed").find("th")[i].clientWidth;
                $("#tblleftfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblleftfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblleftfixed").find("th").eq(i).css("min-width", th_wid);
                $("#tblleftfixed").find("th").eq(i).css("width", th_wid);
            }

            fixedHeader = "";
            fixedHeader += "<table id='tblRightfixedHeader' class='table table-striped table-bordered table-sm clsReport' style='width:99.8%; margin-bottom: 0;'>";
            fixedHeader += "<thead>";
            fixedHeader += $("#tblReport").find("thead").eq(0).html();
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divRightReportHeader").html(fixedHeader);
            $("#tblRightfixedHeader").css("margin-left", "-420px");

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblRightfixedHeader").css("min-width", wid);
            for (i = 0; i < $("#tblReport").find("th").length; i++) {
                var th_wid = $("#tblReport").find("th")[i].clientWidth;
                $("#tblRightfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblRightfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                $("#tblReport").find("th").eq(i).css("width", th_wid);
            }
            $("#tblleftfixed").css("margin-top", "-" + $("#tblRightfixedHeader")[0].offsetHeight + "px");
            $("#tblReport").css("margin-top", "-" + $("#tblRightfixedHeader")[0].offsetHeight + "px");

            $("#tblleftfixedHeader").find("th").eq(0).height($("#tblRightfixedHeader").find("th").eq(0).height());
            $("#divRightReport").scroll(function () {
                $("#divRightReportHeader").scrollLeft($(this).scrollLeft());
            });

            $("#divRightReport").scrollLeft(0);
            $("#divRightReportHeader").scrollLeft(0);

            $("#divRightReport").scrollTop(0);
            $("#divRightReportHeader").scrollTop(0);
        }
        function fnAdjustColumnWidth() {
            $("#tblReport").css("width", "auto");
            for (i = 5; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("min-width", "auto");
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("width", "auto");
            }

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblRightfixedHeader").css("min-width", wid);

            for (i = 5; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
                var th_wid = $("#tblReport").find("th")[i].clientWidth;
                $("#tblRightfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblRightfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                $("#tblReport").find("th").eq(i).css("width", th_wid);

                $("#tblRightfixedHeader").find("th").eq(i).html($("#tblReport").find("th").eq(i).html());
            }
        }
        function fnAdjustRowHeight(index) {
            leftfixedtr = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(index);
            tr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(index);

            tr.css("height", "auto");
            tr.css("min-height", "auto");
            leftfixedtr.css("height", "auto");
            leftfixedtr.css("min-height", "auto");

            if (leftfixedtr[0].offsetHeight != tr[0].offsetHeight) {
                if (leftfixedtr[0].offsetHeight > tr[0].offsetHeight) {
                    tr.css("height", leftfixedtr[0].offsetHeight + "px");
                    tr.css("min-height", leftfixedtr[0].offsetHeight + "px");
                    leftfixedtr.css("height", leftfixedtr[0].offsetHeight + "px");
                    leftfixedtr.css("min-height", leftfixedtr[0].offsetHeight + "px");
                }
                else if (leftfixedtr[0].offsetHeight < tr[0].offsetHeight) {
                    tr.css("height", tr[0].offsetHeight + "px");
                    tr.css("min-height", tr[0].offsetHeight + "px");
                    leftfixedtr.css("height", tr[0].offsetHeight + "px");
                    leftfixedtr.css("min-height", tr[0].offsetHeight + "px");
                }
            }
        }

        function fnInitExpandedCollapseMode() {
            if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0") {
                $("#btnInitExpandedCollapseMode").html("Collapsed Mode");
                $("#btnInitExpandedCollapseMode").attr("flgCollapse", "1");
            }
            else {
                $("#btnInitExpandedCollapseMode").html("Expanded Mode");
                $("#btnInitExpandedCollapseMode").attr("flgCollapse", "0");
            }
            fnInitExpandedCollapseModetbl();
        }
        function fnInitExpandedCollapseModetbl() {
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                var rowIndex = $(this).index();

                var InitName = $(this).attr("initname");
                var shortDescr = $(this).attr("ShortDescr");
                var Descr = $(this).attr("Descr");
                var loc = ExtendContentBody($(this).attr("loc"));
                var channel = ExtendContentBody($(this).attr("channel"));

                if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "1") {
                    InitName = InitName.length > 17 ? "<span title='" + InitName + "' class='clsInform'>" + InitName.substring(0, 15) + "..</span>" : InitName;
                    shortDescr = shortDescr.length > 17 ? "<span title='" + shortDescr + "' class='clsInform'>" + shortDescr.substring(0, 15) + "..</span>" : shortDescr;
                    Descr = Descr.length > 50 ? "<span title='" + Descr + "' class='clsInform'>" + Descr.substring(0, 48) + "..</span>" : Descr;
                    loc = "<div style='width: 202px; min-width: 202px;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>";
                }
                else {
                    loc = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + ExtendContentBody($(this).attr("loc")) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + ExtendContentBody($(this).attr("channel")) + "</div>";
                }

                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    $(this).find("td[iden='Init']").eq(3).html(InitName + "<br/>" + shortDescr);
                }
                else {
                    $(this).find("td[iden='Init']").eq(3).html(InitName);
                }
                $(this).find("td[iden='Init']").eq(4).html(Descr);

                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(3).html(InitName + "<br/>" + shortDescr);
                }
                else {
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(3).html(InitName);
                }
                $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(4).html(Descr);

                if ($("#tblReport").attr("IsChannelExpand") == "1")
                    $(this).find("td[iden='Init']").eq(5).html(channel);

                if ($("#tblReport").attr("IsLocExpand") == "1")
                    $(this).find("td[iden='Init']").eq(6).html(loc);

                fnAdjustRowHeight(rowIndex);
            });
            fnAdjustColumnWidth();

            Tooltip(".clsInform");
        }

        function fnDownload() {
            var Arr = [];
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                if ($(this).attr("Init") != "0" && $(this).css("display") != "none") {
                    Arr.push({ "INITID": $(this).attr("Init") });
                }
            });

            if (Arr.length == 0) {
                Arr.push({ "INITID": 0 });
            }


            $("#ConatntMatter_hdnjsonarr").val(JSON.stringify(Arr));
            var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

            var month = parseInt(MonthArr.indexOf($("#ddlMonth").val().split("|")[0].split('-')[1]) + 1);
            var year = "20" + $("#ddlMonth").val().split("|")[0].split('-')[2];

            $("#ConatntMatter_hdnmonthyearexceltext").val($("#ddlMonth option:selected").text());
            $("#ConatntMatter_hdnmonthyearexcel").val(month + "^" + year);
            $("#ConatntMatter_btnDownload").click();
            return false;
        }
    </script>
    <script type="text/javascript">
        function fnBookmarkFilter() {
            var Bookmark = $("#ddlBookmark").val();

            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
            switch (Bookmark) {
                case "0":
                    //
                    break;
                case "1":
                    var rowindex = 0;
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                        if ($(this).attr("flgBookmark") == 0) {
                            $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).css("display", "none");
                            $(this).css("display", "none");
                        }
                        rowindex++;
                    });
                    break;
                case "2":
                    var rowindex = 0;
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                        if ($(this).attr("flgBookmark") == 1) {
                            $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).css("display", "none");
                            $(this).css("display", "none");
                        }
                        rowindex++;
                    });
                    break;
            }
        }

        function fnManageBookMarkAll(ctrl) {
            var flgBookmark = "0";
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var ArrINIT = [];

            if ($(ctrl).attr("flgBookmark") == "0")
                flgBookmark = "1";
            else
                flgBookmark = "0";

            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                ArrINIT.push({
                    "col1": $(this).attr("Init")
                });
            });

            $("#dvloader").show();
            PageMethods.fnManageBookMark(flgBookmark, LoginID, UserID, ArrINIT, fnManageBookMarkAll_pass, fnfailed, flgBookmark);
        }
        function fnManageBookMarkAll_pass(res, flgBookmark) {
            if (res.split("|^|")[0] == "0") {
                var rowindex = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                    $(this).attr("flgBookmark", flgBookmark);
                    $(this).find("td[iden='Init']").eq(1).find("img").eq(0).attr("flgBookmark", flgBookmark);
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).find("td").eq(1).find("img").eq(0).attr("flgBookmark", flgBookmark);

                    if (flgBookmark == "1") {
                        $(this).find("td[iden='Init']").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark.png");
                        $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).find("td").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark.png");
                    }
                    else {
                        $(this).find("td[iden='Init']").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark-inactive.png");
                        $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).find("td").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark-inactive.png");
                    }

                    rowindex++;
                });

                if (flgBookmark == "1") {
                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("flgBookmark", "1");
                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("src", "../../Images/bookmark.png");

                }
                else {
                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("flgBookmark", "0");
                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("src", "../../Images/bookmark-inactive.png");

                }

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnManageBookMark(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();

            var flgBookmark = "0";
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var ArrINIT = [];

            if ($(ctrl).attr("flgBookmark") == "0")
                flgBookmark = "1";
            else
                flgBookmark = "0";

            ArrINIT.push({
                "col1": $(ctrl).closest("tr").attr("Init")   //$("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("Init")
            });

            $("#dvloader").show();
            PageMethods.fnManageBookMark(flgBookmark, LoginID, UserID, ArrINIT, fnManageBookMark_pass, fnfailed, rowIndex + "|" + flgBookmark);
        }
        function fnManageBookMark_pass(res, str) {
            if (res.split("|^|")[0] == "0") {
                var rowIndex = str.split("|")[0];
                var flgBookmark = str.split("|")[1];

                if (flgBookmark == "1") {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("flgBookmark", "1");
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).find("td[iden='Init']").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");

                }
                else {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("flgBookmark", "0");
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).find("td[iden='Init']").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='Active Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='Active Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");

                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("flgBookmark", "0");
                    $("#tblleftfixedHeader").find("thead").eq(0).find("img[iden='Bookmark']").eq(0).attr("src", "../../Images/bookmark-inactive.png");

                }

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnChkUnchkInitAll(ctrl) {
            if ($(ctrl).is(":checked")) {
                $("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']").prop("checked", true);

                if ($("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']:checked").length > 0) {
                    $("#divButtons").find("a.btn").removeClass("btn-disabled");
                    $("#divButtons").find("a.btn").attr("onclick", "fnSaveFinalAction(this);");
                }
            }
            else {
                $("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']").removeAttr("checked");

                $("#divButtons").find("a.btn").addClass("btn-disabled");
                $("#divButtons").find("a.btn").removeAttr("onclick");
            }

            if ($("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").length == 0) {
                $("#divButtons").find("a.btn[flgAction='100']").addClass("btn-disabled").removeAttr("onclick", "fnSaveFinalAction(this);");
            }
        }
        function fnUnchkInitIndividual(ctrl) {
            if (!($(ctrl).is(":checked"))) {
                $("#tblleftfixedHeader").find("input[type='checkbox']").removeAttr("checked");
            }

            if ($("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']:checked").length > 0) {
                $("#divButtons").find("a.btn").each(function () {
                    $(this).removeClass("btn-disabled");
                    $(this).attr("onclick", "fnSaveFinalAction(this);");
                });
            }
            else {
                $("#divButtons").find("a.btn").each(function () {
                    $(this).addClass("btn-disabled");
                    $(this).removeAttr("onclick");
                });
            }

            if ($("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").length == 0) {
                $("#divButtons").find("a.btn[flgAction='100']").addClass("btn-disabled").removeAttr("onclick", "fnSaveFinalAction(this);");
            }
        }

        function fnSaveFinalAction(ctrl) {
            var flgAction = $(ctrl).attr("flgAction");          // 1: Submit, 2: Approve, 3: Reject.

            var RoleID = $("#ConatntMatter_hdnRoleID").val();   // 2: Admin
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var ArrINIT = [];

            var InitName = "", flgShortDetail = 0, flgInitAppRule = 0;
            if (flgAction == "100") {
                fnSaveAllOpen(0);
            }
            else if (flgAction == "99") {
                fnDeleteSelected();
            }
            else if (flgAction == "3") {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                        if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                            var rowIndex = $(this).closest("tr").index();

                            ArrINIT.push({
                                "col1": $(this).closest("tr").attr("Init"), //$("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("Init")
                            });
                        }
                    }
                });

                if (ArrINIT.length > 0) {
                    PageMethods.fnGetAllRejectComments(RoleID, LoginID, UserID, ArrINIT, fnGetAllRejectComments_pass, fnfailed, flgAction);
                }
                else
                    AutoHideAlertMsg("Please select atleast one Initiative for Action !");
            }
            else {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                        if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                            var rowIndex = $(this).closest("tr").index();

                            ArrINIT.push({
                                "col1": $(this).closest("tr").attr("Init"), //$("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("Init"),
                                "col2": flgAction,
                                "col3": ""
                            });

                            if (RoleID == "2" && flgAction == "2" && $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("shortdescr") == "" && InitName == "") {
                                flgShortDetail = 1;
                                InitName = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("initname");
                            }
                            if (((RoleID == "2" && flgAction == "2") || (RoleID == "4" && flgAction == "1")) && $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("baseprod") == "" && InitName == "") {
                                flgInitAppRule = 1;
                                InitName = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("initname");
                            }
                        }
                    }
                });

                if (ArrINIT.length == 0) {
                    AutoHideAlertMsg("Please select atleast one Initiative for Action !");
                }
                else if (flgShortDetail == 1) {
                    AutoHideAlertMsg("Please enter Initiative Short Details for Recom. Trade Plan :  " + InitName + " !");
                }
                else if (flgInitAppRule == 1) {
                    AutoHideAlertMsg("Please define Initiative Application Rules for Recom. Trade Plan :  " + InitName + " !");
                }
                else {
                    if (flgAction == "1") {
                        $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Submit <span style='color:#0000ff; font-weight: 700;'>" + ArrINIT.length + "</span> Initiative(s) for further Approval.<br/>Do you want to continue ?</div>");
                    }
                    else {
                        $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Approved <span style='color:#0000ff; font-weight: 700;'>" + ArrINIT.length + "</span> Initiative(s).<br/>Do you want to continue ?</div>");
                    }

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
                                $("#divConfirm").dialog('close');

                                $("#dvloader").show();
                                PageMethods.fnSaveFinalAction(RoleID, LoginID, UserID, ArrINIT, fnSaveFinalAction_pass, fnfailed, flgAction);
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

            }
        }
        function fnGetAllRejectComments_pass(res, flgAction) {
            if (res.split("|^|")[0] == "0") {
                var strtbl = "";
                strtbl += "<table class='table table-striped table-bordered table-sm clstbl-Reject'>";
                strtbl += "<thead>";
                strtbl += "<tr><th>#</th><th>Rec. Trade Plan</th><th>Comments</th></tr>";
                strtbl += "</thead>";
                strtbl += "<tbody>";

                var jsonTbl = $.parseJSON(res.split("|^|")[1]).Table;
                for (var i = 0; i < jsonTbl.length; i++) {
                    strtbl += "<tr init='" + jsonTbl[i].INITID + "'>";
                    strtbl += "<td>" + (i + 1).toString() + "</td>";
                    strtbl += "<td>" + jsonTbl[i].INITName + "</td>";
                    strtbl += "<td><textarea style='width:100%; box-sizing: border-box;' rows='2'>" + jsonTbl[i].comments + "</textarea></td>";
                    strtbl += "</tr>";
                }
                strtbl += "</tbody>";
                strtbl += "</table>";

                $("#divConfirm").html(strtbl);
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "70%",
                    "height": "500",
                    "title": "Comments :",
                    close: function () {
                        $("#divConfirm").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Submit Request',
                        class: 'btn-primary',
                        click: function () {
                            var RoleID = $("#ConatntMatter_hdnRoleID").val();
                            var LoginID = $("#ConatntMatter_hdnLoginID").val();
                            var UserID = $("#ConatntMatter_hdnUserID").val();

                            var InitName = "", ArrINIT = [];
                            $("#divConfirm").find("tbody").eq(0).find("tr").each(function () {
                                ArrINIT.push({
                                    "col1": $(this).attr("Init"),
                                    "col2": flgAction,
                                    "col3": $(this).find("td").eq(2).find("textarea").eq(0).val()
                                });

                                if ($(this).find("td").eq(2).find("textarea").eq(0).val() == "" && InitName == "") {
                                    InitName = $(this).find("td").eq(1).html();
                                }
                            });

                            if (InitName == "") {
                                $("#divConfirm").dialog('close');

                                $("#dvloader").show();
                                PageMethods.fnSaveFinalAction(RoleID, LoginID, UserID, ArrINIT, fnSaveFinalAction_pass, fnfailed, flgAction);
                            }
                            else {
                                AutoHideAlertMsg("Please enter your Comments for " + InitName);
                            }
                        }
                    },
                    {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divConfirm").dialog('close');
                        }
                    }]
                });
            }
            else {
                fnfailed();
            }
        }
        function fnSaveFinalAction_pass(res, flgAction) {
            if (res.split("|^|")[0] == "0") {
                switch (flgAction) {
                    case "1":
                        AutoHideAlertMsg("Initiative(s) submitted successfully !");
                        break;
                    case "2":
                        AutoHideAlertMsg("Initiative(s) approved successfully !");
                        break;
                    case "3":
                        AutoHideAlertMsg("Change Request submitted successfully !");
                        break;
                }
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }

        function fnImportTypefilter() {
            var flgtr = 0, rowindex = 0;
            var filter = $("#txtImportfilter").val().toUpperCase().split(",");

            if ($("#txtImportfilter").val().toUpperCase().length > 2) {
                $("#tblInitiativeLst").find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#tblInitiativeLst").find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this)[0].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }

                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                        flgtr = 1;
                    }

                    rowindex++;
                });
            }
            else {
                $("#tblInitiativeLst").find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnCopyMultiInitiativePopup() {
            if ($("#ddlMonthPopup").find("option").length > 0) {
                $("#btnImportProductHierFilter").attr("prodhier", "");
                $("#btnImportLocationHierFilter").attr("prodhier", "");
                $("#btnImportChannelHierFilter").attr("prodhier", "");

                fnCopyMultiInitiative();
                $("#dvInitiativeListBody").html("<div style='text-align: center; padding-top: 20px;'><img src='../../Images/loading.gif'/></div>");

                $("#dvInitiativeList").dialog({
                    "modal": true,
                    "width": "96%",
                    "height": "600",
                    "title": "Copy Initiative(s) :",
                    close: function () {
                        $("#dvInitiativeList").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Paste Initiative(s)',
                        click: function () {
                            fnPasteInitiative();
                        },
                        class: 'btn-primary'
                    },
                    {
                        text: 'Reset Filter',
                        click: function () {
                            $("#btnImportProductHierFilter").attr("prodhier", "");
                            $("#btnImportLocationHierFilter").attr("prodhier", "");
                            $("#btnImportChannelHierFilter").attr("prodhier", "");

                            fnCopyMultiInitiative();
                            $("#dvInitiativeListBody").html("<div style='text-align: center; padding-top: 20px;'><img src='../../Images/loading.gif'/></div>");
                        },
                        class: 'btn-primary'
                    },
                    {
                        text: 'Cancel',
                        click: function () {
                            $("#dvInitiativeList").dialog('close');
                        },
                        class: 'btn-primary'
                    }]
                });
            }
            else {
                AutoHideAlertMsg("No Month(s) found for Importing !");
            }
        }
        function fnCopyMultiInitiative() {
            $("#txtImportfilter").val('');
            $("#dvInitiativeListBody").html("<div style='text-align: center; padding-top: 20px;'><img src='../../Images/loading.gif'/></div>");

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var FromDate = $("#ddlMonthPopup").val().split("|")[0];
            var ToDate = $("#ddlMonthPopup").val().split("|")[1];

            //var ProdValues = [], LocValues = [], ChannelValues = [];
            //ProdValues.push({ "col1": "0", "col2": "0", "col3": "1" });
            //LocValues.push({ "col1": "0", "col2": "0", "col3": "2" });
            //ChannelValues.push({ "col1": "0", "col2": "0", "col3": "3" });

            var ProdValues = [], LocValues = [], ChannelValues = [];
            var PrdString = $("#btnImportProductHierFilter").attr("prodhier");
            var LocString = $("#btnImportLocationHierFilter").attr("prodhier");
            var ChannelString = $("#btnImportChannelHierFilter").attr("prodhier");

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
                        "col1": LocString.split("^")[i].split("|")[0],
                        "col2": LocString.split("^")[i].split("|")[1],
                        "col3": "2"
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

            PageMethods.fnGetInitiativeList(LoginID, RoleID, UserID, FromDate, ToDate, ProdValues, LocValues, ChannelValues, fnCopyMultiInitiative_pass, fnfailed);
        }
        function fnCopyMultiInitiative_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvInitiativeListBody").html(res.split("|^|")[1]);
            }
            else {
                $("#dvInitiativeListBody").html("<div style='text-align: center; padding-top: 10px; font-size: 0.9rem;'>Due to some technical reasons, we are unable to process your request !</div>");
            }
        }

        function fnChkUnchkInitAllPopup(ctrl) {
            if ($(ctrl).is(":checked")) {
                $(ctrl).closest("table").find("tbody").eq(0).find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $(ctrl).closest("table").find("tbody").eq(0).find("input[type='checkbox']").removeAttr("checked");
            }
        }

        function fnPasteInitiative() {
            if ($("#dvInitiativeListBody").find("table").length > 0) {
                var RoleID = $("#ConatntMatter_hdnRoleID").val();
                var LoginID = $("#ConatntMatter_hdnLoginID").val();
                var UserID = $("#ConatntMatter_hdnUserID").val();
                var FromDate = $("#ddlMonth").val().split("|")[0];
                var ToDate = $("#ddlMonth").val().split("|")[1];
                var ArrINIT = [];

                $("#dvInitiativeListBody").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("input[type='checkbox']").is(":checked")) {
                        ArrINIT.push({
                            "col1": $(this).attr("Init")
                        });
                    }
                });

                if (ArrINIT.length > 0) {
                    $("#dvloader").show();
                    PageMethods.fnPasteInitiative(RoleID, LoginID, UserID, FromDate, ToDate, ArrINIT, fnPasteInitiative_pass, fnfailed);
                }
                else {
                    AutoHideAlertMsg("Please select Initiative(s) for Copy !");
                }
            }
        }
        function fnPasteInitiative_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Initiative(s) copied successfully !");
                $("#dvInitiativeList").dialog('close');
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnAddNew() {
            if ($("#ConatntMatter_hdnIsNewAdditionAllowed").val() == "0") {
                AutoHideAlertMsg("Creation of New Initiative is not Allowed !");
            }
            else {
                var defdate = GetNxtMonthToFromDate();

                var strleft = "";
                strleft += "<tr Init='0' flgEdit='1'>";
                strleft += "<td></td>";
                strleft += "<td></td>";
                strleft += "<td class='clstdAction'><img src='../../Images/save.png' title='Save' onclick='fnSave(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/></td>";
                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    strleft += "<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'></textarea><br/><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; margin-top:5px;' rows='1'></textarea></td>";
                }
                else {
                    strleft += "<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'></textarea><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; display: none;' rows='2'></textarea></td>";
                }
                strleft += "<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='2'></textarea></td>";
                str += "</tr>";

                var str = "";
                str += "<tr iden='Init' Init='0' ApplicablePer='' ApplicableNewPer='' flgEdit='1' style='display: table-row;'>";
                str += "<td iden='Init'></td>";
                str += "<td iden='Init'></td>";
                str += "<td iden='Init' class='clstdAction'><img src='../../Images/save.png' title='Save' onclick='fnSave(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/></td>";
                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    str += "<td iden='Init'><input type='text' style='box-sizing: border-box;' value='' placeholder='Name'/><br/><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; margin-top:5px;' rows='1'></textarea></td>";
                }
                else {
                    str += "<td iden='Init'><input type='text' style='box-sizing: border-box;' value='' placeholder='Name'/><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; display: none;' rows='2'></textarea></td>";
                }
                str += "<td iden='Init'><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='2'></textarea></td>";


                str += "<td iden='Init'><div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'></div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='3' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='3' CopyBucketTD='0' InSubD='0' prodlvl='' prodhier='' onclick='fnShowProdHierPopup(this, 1);'/></div></div></td>";
                str += "<td iden='Init'><div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>India</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='2' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='2' CopyBucketTD='0' InSubD='0' prodlvl='100' prodhier='1|100' onclick='fnShowProdHierPopup(this, 1);'/></div></div></td>";


                str += "<td iden='Init'>";
                str += fnInitAppRuleInitialStr();
                str += "</td>";

                str += "<td iden='Init'><input type='text' style='box-sizing: border-box;' value='0'/></td>";
                str += "<td iden='Init'><input type='text' style='box-sizing: border-box;' value='0'/></td>";
                str += "<td iden='Init'><input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + defdate.split("|")[0] + "' placeholder='From Date'/><br/><a herf='#' onclick='fnSetToFromDate(this);' class='btn btn-primary btn-small'>Default Month</a><br/><input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + defdate.split("|")[1] + "' placeholder='To Date'/></td>";
                str += "<td iden='Init'><select>" + $("#ConatntMatter_hdnDisburshmentType").val() + "</select></td>";
                str += "<td iden='Init'><select>" + $("#ConatntMatter_hdnIncentiveType").val() + "</select></td>";
                str += "<td iden='Init'><select>" + $("#ConatntMatter_hdnMultiplicationType").val() + "</select></td>";
                str += "<td iden='Init'><input type='checkbox' checked/>Leap<br/><input type='checkbox' checked/>SubD</td>";
                str += "<td iden='Init'><input type='checkbox'/></td>";
                str += "<td iden='Init'></td>";
                str += "<td iden='Init'></td>";
                str += "</tr>";

                if ($("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").length == 0) {
                    $("#tblReport").find("tbody").eq(0).html(str);
                    $("#tblleftfixed").find("tbody").eq(0).html(strleft);
                }
                else {
                    $("#tblReport").find("tbody").eq(0).prepend(str);
                    $("#tblleftfixed").find("tbody").eq(0).prepend(strleft);
                }
                fnAdjustColumnWidth();
                fnAdjustRowHeight(0);

                $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(0).find("textarea").on('input', function () {
                    this.style.height = 'auto';
                    this.style.height = (this.scrollHeight) + 'px';
                    fnAdjustRowHeight($(this).closest("tr").index());
                });

                $(".clsDate").datepicker({
                    dateFormat: 'dd-M-y'
                });

                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).find("td[iden='Init']").eq(11).find("select").eq(0).val("1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).find("td[iden='Init']").eq(13).find("select").eq(0).val("2");

                $("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
            }
        }
        function fnEditCopy(ctrl, cntr) {
            var lefttr = $(ctrl).closest("tr");
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex);

            var InitName = rttr.attr("initname");
            var shortDescr = rttr.attr("ShortDescr");
            var Descr = rttr.attr("Descr");
            var lmlamt = rttr.attr("lmlamt");
            var lmlcntr = rttr.attr("lmlcntr");
            var fromdate = rttr.attr("fromdate");
            var todate = rttr.attr("todate");
            if (cntr == 2) {
                var defdate = GetNxtMonthToFromDate();
                fromdate = defdate.split("|")[0];
                todate = defdate.split("|")[1];
            }
            var applicableper = rttr.attr("applicableper");
            var Distribution = rttr.attr("Distribution");
            var IncentiveType = rttr.attr("IncentiveType");
            var Multiplication = rttr.attr("Multiplication");
            var IncludeSubD = rttr.attr("IncludeSubD");
            var IncludeLeap = rttr.attr("IncludeLeap");
            var MixedCases = rttr.attr("MixedCases");
            var strBase = rttr.attr("BaseProd");
            var strInit = rttr.attr("InitProd");
            var loc = rttr.attr("loc");
            var locBucketstr = "0";
            var locstr = rttr.attr("locstr").split("|||")[0];
            if (rttr.attr("locstr").split("|||").length > 1) {
                locBucketstr = rttr.attr("locstr").split("|||")[1];
            }
            var loclvl = "";
            if (locstr != "")
                loclvl = Maxlvl(locstr);

            var channel = rttr.attr("channel");
            var channelBucketstr = "0";
            var channelstr = rttr.attr("channelstr").split("|||")[0];
            if (rttr.attr("channelstr").split("|||").length > 1) {
                channelBucketstr = rttr.attr("channelstr").split("|||")[1];
            }
            var channellvl = "";
            if (channelstr != "")
                channellvl = Maxlvl(channelstr);

            var InSubD = rttr.attr("InSubD");

            var strbtn = "";
            var flgRejectComment = rttr.attr("flgRejectComment");
            if (flgRejectComment == "1")
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/><img src='../../Images/comments.png' title='Comments' onclick='fnGetRejectComment(this);'/>";
            else
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/>";

            var tr = "", str = "";
            if (cntr == 2) {      // 1:Edit, 2:Copy
                str = "<tr iden='Init' Init='0' flgEdit='1' ApplicablePer='" + applicableper + "' ApplicableNewPer='" + applicableper + "' style='display: table-row;'>";
                str += rttr.html();
                str += "</tr>";
                rttr.before(str);

                str = "<tr iden='Init' Init='0' flgEdit='1'>";
                str += lefttr.html();
                str += "</tr>";
                lefttr.before(str);

                tr = rttr.prev();
                shortDescr = "";
            }
            else {
                tr = rttr;
                tr.attr("flgEdit", "1");
            }
            lefttr = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex);
            lefttr.attr("flgEdit", "1");


            tr.find("td[iden='Init']").eq(0).html("");
            tr.find("td[iden='Init']").eq(1).html("");
            tr.find("td[iden='Init']").eq(2).html(strbtn);
            lefttr.find("td").eq(0).html("");
            lefttr.find("td").eq(1).html("");
            lefttr.find("td").eq(2).html(strbtn);

            if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                tr.find("td[iden='Init']").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + InitName + "</textarea><br/><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; margin-top:5px;' rows='1'>" + shortDescr + "</textarea>");
            }
            else {
                tr.find("td[iden='Init']").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + InitName + "</textarea><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; display: none;' rows='2'>" + shortDescr + "</textarea>");
            }
            tr.find("td[iden='Init']").eq(4).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='2'>" + Descr + "</textarea>");

            if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                lefttr.find("td").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + InitName + "</textarea><br/><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; margin-top:5px;' rows='1'>" + shortDescr + "</textarea>");
            }
            else {
                lefttr.find("td").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + InitName + "</textarea><textarea style='width:100%; box-sizing: border-box; overflow-y: hidden; display: none;' rows='2'>" + shortDescr + "</textarea>");
            }
            lefttr.find("td").eq(4).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='2'>" + Descr + "</textarea>");

            tr.find("td[iden='Init']").eq(5).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(channel) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='3' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='3' CopyBucketTD='" + channelBucketstr + "' InSubD='0' prodlvl='" + channellvl + "' prodhier='" + channelstr + "' onclick='fnShowProdHierPopup(this, 1);'/></div></div>");
            tr.find("td[iden='Init']").eq(6).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(loc) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='2' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='2' CopyBucketTD='" + locBucketstr + "' InSubD='" + InSubD + "' prodlvl='" + loclvl + "' prodhier='" + locstr + "' onclick='fnShowProdHierPopup(this, 1);'/></div></div>");

            if (strBase != "") {
                tr.find("td[iden='Init']").eq(7).html(fnInitAppRuleEditable(strBase, strInit));
            } else {
                tr.find("td[iden='Init']").eq(7).html(fnInitAppRuleInitialStr());
            }


            tr.find("td[iden='Init']").eq(8).html("<input type='text' style='box-sizing: border-box;' value='" + lmlamt + "' />");
            tr.find("td[iden='Init']").eq(9).html("<input type='text' style='box-sizing: border-box;' value='" + lmlcntr + "' />");
            tr.find("td[iden='Init']").eq(10).html("<input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + fromdate + "' placeholder='From Date'/><br/><a herf='#' onclick='fnSetToFromDate(this);' class='btn btn-primary btn-small'>Default Month</a><br/><input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + todate + "' placeholder='To Date'/>");
            tr.find("td[iden='Init']").eq(11).html("<select>" + $("#ConatntMatter_hdnDisburshmentType").val() + "</select>");
            tr.find("td[iden='Init']").eq(11).find("select").eq(0).val(Distribution.split("^")[0]);
            tr.find("td[iden='Init']").eq(12).html("<select>" + $("#ConatntMatter_hdnIncentiveType").val() + "</select>");
            tr.find("td[iden='Init']").eq(12).find("select").eq(0).val(IncentiveType.split("^")[0]);
            tr.find("td[iden='Init']").eq(13).html("<select>" + $("#ConatntMatter_hdnMultiplicationType").val() + "</select>");
            tr.find("td[iden='Init']").eq(13).find("select").eq(0).val(Multiplication.split("^")[0]);
            if (IncludeLeap == "1" && IncludeSubD == "1")
                tr.find("td[iden='Init']").eq(14).html("<input type='checkbox' checked/>Leap<br/><input type='checkbox' checked/>SubD");
            else if (IncludeLeap == "1")
                tr.find("td[iden='Init']").eq(14).html("<input type='checkbox' checked/>Leap<br/><input type='checkbox'/>SubD");
            else if (IncludeSubD == "1")
                tr.find("td[iden='Init']").eq(14).html("<input type='checkbox'/>Leap<br/><input type='checkbox' checked/>SubD");
            else
                tr.find("td[iden='Init']").eq(14).html("<input type='checkbox'/>Leap<br/><input type='checkbox'/>SubD");

            if (MixedCases == "1")
                tr.find("td[iden='Init']").eq(15).html("<input type='checkbox' checked/>");
            else
                tr.find("td[iden='Init']").eq(15).html("<input type='checkbox'/>");

            if (cntr == 2) {
                tr.find("td[iden='Init']").eq(16).html("");
                tr.find("td[iden='Init']").eq(17).html("");
            }

            lefttr.find("textarea").eq(0).css("height", "auto");
            lefttr.find("textarea").eq(1).css("height", "auto");
            lefttr.find("textarea").eq(0).css("height", lefttr.find("textarea")[0].scrollHeight + "px");
            lefttr.find("textarea").eq(1).css("height", lefttr.find("textarea")[1].scrollHeight + "px");

            fnAdjustRowHeight(rowIndex);

            lefttr.find("textarea").on('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
                fnAdjustRowHeight($(this).closest("tr").index());
            });

            tr.find(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            fnAdjustColumnWidth();

            $("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
        }
        function fnCancel(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();
            var Init = $(ctrl).closest("tr").attr("Init");
            if (Init == "0") {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).remove();
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).remove();
            }
            else {
                var lefttr = $(ctrl).closest("tr");
                var tr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex);

                var InitCode = tr.attr("initcode");
                var InitName = tr.attr("initname");
                var shortDescr = tr.attr("ShortDescr");
                var Descr = tr.attr("Descr");
                var lmlamt = tr.attr("lmlamt");
                var lmlcntr = tr.attr("lmlcntr");
                var fromdate = tr.attr("fromdate");
                var todate = tr.attr("todate");
                var Distribution = tr.attr("Distribution");
                var IncentiveType = tr.attr("IncentiveType");
                var Multiplication = tr.attr("Multiplication");
                var IncludeSubD = tr.attr("IncludeSubD");
                var IncludeLeap = tr.attr("IncludeLeap");
                var MixedCases = tr.attr("MixedCases");
                var flgRejectComment = tr.attr("flgRejectComment");
                var flgBookmark = tr.attr("flgBookmark");
                var flgCheckBox = tr.attr("flgCheckBox");
                var flgSettle = tr.attr("flgSettle");

                var strAppRule = "<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopupNonEditable(this);'>View Details</a><div>";
                if (tr.attr("BaseProd") == "") {
                    strAppRule = "<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-danger btn-small' style='cursor: default;'>No Rule Defined</a><div>";
                }

                var loc = ExtendContentBody(tr.attr("loc"));
                var channel = ExtendContentBody(tr.attr("channel"));

                var strbtns = "";
                if ($("#ConatntMatter_hdnIsNewAdditionAllowed").val() == "1") {
                    strbtns += "<img src='../../Images/copy.png' title='Copy Initiative' onclick='fnEditCopy(this, 2);'/>";
                }
                strbtns += "<img src='../../Images/edit.png' title='Edit Initiative' onclick='fnEditCopy(this, 1);'/>";
                strbtns += "<img src='../../Images/delete.png' title='Delete Initiative' onclick='fnDelete(this);'/>";
                if (flgSettle == "1") {
                    strbtns += "<img src='../../Images/settle.png' title='Settle Initiative' onclick='fnSettle(this);'/>";
                }
                if (flgRejectComment == "1") {
                    strbtns += "<img src='../../Images/comments.png' title='Comments' onclick='fnGetRejectComment(this);'/>";
                }

                if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "1") {
                    InitName = InitName.length > 20 ? "<span title='" + InitName + "' class='clsInform'>" + InitName.substring(0, 18) + "..</span>" : InitName;
                    shortDescr = shortDescr.length > 20 ? "<span title='" + shortDescr + "' class='clsInform'>" + shortDescr.substring(0, 18) + "..</span>" : shortDescr;
                    Descr = Descr.length > 50 ? "<span title='" + Descr + "' class='clsInform'>" + Descr.substring(0, 48) + "..</span>" : Descr;
                    loc = "<div style='width: 202px; min-width: 202px;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>";
                }
                else {
                    loc = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + loc + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + channel + "</div>";
                }

                //-----------------------------------------------------------------------------------------------------------


                if (flgCheckBox == "1")
                    lefttr.find("td").eq(0).html("<input iden='chkInit' type='checkbox' onclick='fnUnchkInitIndividual(this);'/>");
                else
                    lefttr.find("td").eq(0).html("");

                if (flgBookmark == "1")
                    lefttr.find("td").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");
                else
                    lefttr.find("td").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='InActive Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");
                lefttr.find("td").eq(2).html(strbtns);

                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    lefttr.find("td").eq(3).html(InitName + "<br/>" + shortDescr);
                }
                else {
                    lefttr.find("td").eq(3).html(InitName);
                }
                lefttr.find("td").eq(4).html(Descr);




                if (flgCheckBox == "1")
                    tr.find("td[iden='Init']").eq(0).html("<input iden='chkInit' type='checkbox' onclick='fnUnchkInitIndividual(this);'/>");
                else
                    tr.find("td[iden='Init']").eq(0).html("");

                if (flgBookmark == "1")
                    tr.find("td[iden='Init']").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");
                else
                    tr.find("td[iden='Init']").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='InActive Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");
                tr.find("td[iden='Init']").eq(2).html(strbtns);

                if ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4") {
                    tr.find("td[iden='Init']").eq(3).html(InitName + "<br/>" + shortDescr);
                }
                else {
                    tr.find("td[iden='Init']").eq(3).html(InitName);
                }
                tr.find("td[iden='Init']").eq(4).html(Descr);



                if ($("#tblReport").attr("IsChannelExpand") == "0")
                    tr.find("td[iden='Init']").eq(5).html("");
                else
                    tr.find("td[iden='Init']").eq(5).html(channel);

                if ($("#tblReport").attr("IsLocExpand") == "0")
                    tr.find("td[iden='Init']").eq(6).html("");
                else
                    tr.find("td[iden='Init']").eq(6).html(loc);

                if ($("#tblReport").attr("IsSchemeAppRule") == "0")
                    tr.find("td[iden='Init']").eq(7).html("");
                else
                    tr.find("td[iden='Init']").eq(7).html(strAppRule);

                tr.find("td[iden='Init']").eq(8).html(lmlamt);
                tr.find("td[iden='Init']").eq(9).html(lmlcntr);
                tr.find("td[iden='Init']").eq(10).html(fromdate + "<br/>to " + todate);
                tr.find("td[iden='Init']").eq(11).html(Distribution.split("^")[1]);
                tr.find("td[iden='Init']").eq(12).html(IncentiveType.split("^")[1]);
                tr.find("td[iden='Init']").eq(13).html(Multiplication.split("^")[1]);
                if (IncludeLeap == "1" && IncludeSubD == "1")
                    tr.find("td[iden='Init']").eq(14).html("Leap<br/>SubD");
                else if (IncludeLeap == "1")
                    tr.find("td[iden='Init']").eq(14).html("Leap");
                else if (IncludeSubD == "1")
                    tr.find("td[iden='Init']").eq(14).html("SubD");
                else
                    tr.find("td[iden='Init']").eq(14).html("");

                if (MixedCases == "1")
                    tr.find("td[iden='Init']").eq(15).html("Yes");
                else
                    tr.find("td[iden='Init']").eq(15).html("No");

                tr.attr("flgEdit", "0");
                lefttr.attr("flgEdit", "0");
                fnAdjustRowHeight(rowIndex);
            }
            Tooltip(".clsInform");
            fnAdjustColumnWidth();

            if ($("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").length == 0) {
                $("#divButtons").find("a.btn[flgAction='100']").addClass("btn-disabled").removeAttr("onclick", "fnSaveFinalAction(this);");
            }
        }

        function fnSaveAllOpen(cntr) {
            SaveCntr = $("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").length;
            if (SaveCntr != 0) {
                var flgSave = "1";
                var ctrl = $("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").eq(cntr - 1).find("td.clstdAction").eq(0).find("img[title='Save']").eq(0);
                if (tr.attr("init") == "0") {
                    flgSave = "2";
                }
                fnSaveInitiative(ctrl, flgSave, cntr);
            }
            else {
                AutoHideAlertMsg("No Initiative details found for updation !");
            }
        }
        function fnSave(ctrl, flgSave) {
            SaveCntr = 1;
            fnSaveInitiative(ctrl, flgSave, 0);
        }

        function fnSaveInitiative(ctrl, flgSave, cntr) {
            var lefttr = $(ctrl).closest("tr");
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex);

            var INITID = lefttr.attr("Init");
            var INITCode = "";
            var INITName = lefttr.find("td").eq(3).find("textarea").eq(0).val();
            var INITShortDescr = lefttr.find("td").eq(3).find("textarea").eq(1).val();
            var INITDescription = lefttr.find("td").eq(4).find("textarea").eq(0).val();
            var AmtLimit = rttr.find("td[iden='Init']").eq(8).find("input[type='text']").eq(0).val();
            var CountLimit = rttr.find("td[iden='Init']").eq(9).find("input[type='text']").eq(0).val();
            var FromDate = rttr.find("td[iden='Init']").eq(10).find("input[type='text']").eq(0).val();
            var ToDate = rttr.find("td[iden='Init']").eq(10).find("input[type='text']").eq(1).val();
            var Disburshment = rttr.find("td[iden='Init']").eq(11).find("select").eq(0).val();
            var IncentiveType = rttr.find("td[iden='Init']").eq(12).find("select").eq(0).val();
            var Multiplication = rttr.find("td[iden='Init']").eq(13).find("select").eq(0).val();
            var IncudeLeap = 0;
            if (rttr.find("td[iden='Init']").eq(14).find("input[type='checkbox']").eq(0).is(":checked"))
                IncudeLeap = 1;
            var IncudeSubD = 0;
            if (rttr.find("td[iden='Init']").eq(14).find("input[type='checkbox']").eq(1).is(":checked"))
                IncudeSubD = 1;
            var MixedCases = 0;
            if (rttr.find("td[iden='Init']").eq(15).find("input[type='checkbox']").eq(0).is(":checked"))
                MixedCases = 1;
            var Bucket = [];
            var BucketValues = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var strLocation = rttr.find("td[iden='Init']").eq(6).find("img[iden='ProductHier']").eq(0).attr("ProdHier");
            var strChannel = rttr.find("td[iden='Init']").eq(5).find("img[iden='ProductHier']").eq(0).attr("ProdHier");
            var copyLocationBucketID = rttr.find("td[iden='Init']").eq(6).find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
            var copyChannelBucketID = rttr.find("td[iden='Init']").eq(5).find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
            var ApplicableNewPer = rttr.attr("ApplicableNewPer");

            var BasePrdMain = [];
            var BasePrdDetail = [];
            var BenefitPrdMain = [];
            var BenefitPrdDetail = [];

            if (INITName == "") {
                AutoHideAlertMsg("Please enter the Initiative Name !");
                return false;
            }
            //else if (INITShortDescr == "" && ($("#ConatntMatter_hdnRoleID").val() != "3" && $("#ConatntMatter_hdnRoleID").val() != "1014" && $("#ConatntMatter_hdnRoleID").val() != "4")) {
            //    alert("Please enter the Initiative Short Description !");
            //    return false;
            //}
            else if (INITDescription == "") {
                AutoHideAlertMsg("Please enter the Initiative Description !");
                return false;
            }
            else if (strChannel == "") {
                AutoHideAlertMsg("Please select the Channel/s !");
                return false;
            }
            else if (strLocation == "") {
                AutoHideAlertMsg("Please select the Location/s !");
                return false;
            }
            else if (AmtLimit == "") {
                AutoHideAlertMsg("Please enter the Disburshment Limit Amount !");
                return false;
            }
            else if (CountLimit == "") {
                AutoHideAlertMsg("Please enter the Disburshment Limit Count !");
                return false;
            }
            else if (FromDate == "") {
                AutoHideAlertMsg("Please select the From Date !");
                return false;
            }
            else if (ToDate == "") {
                AutoHideAlertMsg("Please select the To Date !");
                return false;
            }
            else if (parseInt(FromDate.split("-")[2] + AddZero(MonthArr.indexOf(FromDate.split("-")[1])) + FromDate.split("-")[0]) > parseInt(ToDate.split("-")[2] + AddZero(MonthArr.indexOf(ToDate.split("-")[1])) + ToDate.split("-")[0])) {
                AutoHideAlertMsg("To-Date must be Greater than From-Date !");
                return false;
            }
            else if (Disburshment == "0") {
                AutoHideAlertMsg("Please select the Method of Disburshment !");
                return false;
            }
            else if (IncentiveType == "0") {
                AutoHideAlertMsg("Please select the Incentive Type !");
                return false;
            }
            else if (Multiplication == "0") {
                AutoHideAlertMsg("Please select the To Multiplication Type !");
                return false;
            }
            else {
                for (var i = 0; i < copyLocationBucketID.split("|").length; i++) {
                    Bucket.push({
                        "col1": copyLocationBucketID.split("|")[i],
                        "col2": "2"
                    });
                }
                for (var i = 0; i < copyChannelBucketID.split("|").length; i++) {
                    Bucket.push({
                        "col1": copyChannelBucketID.split("|")[i],
                        "col2": "3"
                    });
                }

                for (var i = 0; i < strLocation.split("^").length; i++) {
                    BucketValues.push({
                        "col1": strLocation.split("^")[i].split("|")[0],
                        "col2": strLocation.split("^")[i].split("|")[1],
                        "col3": "2"
                    });
                }

                for (var i = 0; i < strChannel.split("^").length; i++) {
                    BucketValues.push({
                        "col1": strChannel.split("^")[i].split("|")[0],
                        "col2": strChannel.split("^")[i].split("|")[1],
                        "col3": "3"
                    });
                }

                var slab = 0;
                rttr.find("td[iden='Init']").eq(7).find("div.clsBaseProd").eq(0).find("div[iden='AppRuleSlabWiseContainer']").each(function () {
                    slab = $(this).attr("slabno");
                    var trArr = $(this).find("tbody").eq(0).find("tr");
                    for (i = 0; i < trArr.length; i++) {
                        if (trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodhier") != "") {

                            var copybuckettdArr = trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("copybuckettd").split("|");
                            for (var j = 0; j < copybuckettdArr.length; j++) {
                                BasePrdMain.push({
                                    "col1": slab,
                                    "col2": trArr.eq(i).attr("grpno"),
                                    "col3": trArr.eq(i).find("td").eq(0).html(),
                                    "col4": copybuckettdArr[j],
                                    "col5": trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("Inittype"),
                                    "col6": trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitMax"),
                                    "col7": trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitMin"),
                                    "col8": trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitApplied"),
                                    "col9": $(this).attr("isnewslab"),
                                    "col10": trArr.eq(i).attr("isnewgrp")
                                });
                            }

                            var prodhier = trArr.eq(i).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodhier");
                            for (var j = 0; j < prodhier.split("^").length; j++) {
                                BasePrdDetail.push({
                                    "col1": trArr.eq(i).attr("grpno"),
                                    "col2": prodhier.split("^")[j].split("|")[0],
                                    "col3": prodhier.split("^")[j].split("|")[1],
                                    "col4": slab
                                });
                            }
                        }
                    }
                });

                rttr.find("td[iden='Init']").eq(7).find("div.clsInitProd").eq(0).find("img[iden='ProductHier']").each(function () {
                    if ($(this).attr("prodhier") != "") {
                        BenefitPrdMain.push({
                            "col1": $(this).closest("tr").attr("slabno"),
                            "col2": $(this).closest("tr").attr("grpno"),
                            "col3": $(this).attr("copybuckettd"),
                            "col4": $(this).attr("Benefittype"),
                            "col5": $(this).attr("BenefitAppliedOn"),
                            "col6": $(this).attr("BenefitValue"),
                            "col7": $(this).closest("tr").attr("isnewgrp")
                        });

                        var prodhier = $(this).attr("prodhier");
                        for (var i = 0; i < prodhier.split("^").length; i++) {
                            BenefitPrdDetail.push({
                                "col1": $(this).closest("tr").attr("grpno"),
                                "col2": prodhier.split("^")[i].split("|")[0],
                                "col3": prodhier.split("^")[i].split("|")[1],
                                "col4": $(this).closest("tr").attr("slabno")
                            });
                        }
                    }
                });

                if (BasePrdMain.length == 0) {
                    BasePrdMain.push({ "col1": "0", "col2": "", "col3": "", "col4": "", "col5": "", "col6": "", "col7": "", "col8": "", "col9": "", "col10": "" });
                }
                if (BasePrdDetail.length == 0) {
                    BasePrdDetail.push({ "col1": "0", "col2": "", "col3": "", "col4": "" });
                }
                if (BenefitPrdMain.length == 0) {
                    BenefitPrdMain.push({ "col1": "0", "col2": "", "col3": "", "col4": "", "col5": "", "col6": "", "col7": "" });
                }
                if (BenefitPrdDetail.length == 0) {
                    BenefitPrdDetail.push({ "col1": "0", "col2": "", "col3": "", "col4": "" });
                }

                $("#dvloader").show();
                PageMethods.fnSave(INITID, INITCode, INITName, INITShortDescr, INITDescription, AmtLimit, CountLimit, FromDate, ToDate, Bucket, BucketValues, LoginID, strLocation + "|||" + copyLocationBucketID, strChannel + "|||" + copyChannelBucketID, Disburshment, Multiplication, IncudeLeap, IncudeSubD, BasePrdMain, BasePrdDetail, BenefitPrdMain, BenefitPrdDetail, UserID, MixedCases, flgSave, ApplicableNewPer, IncentiveType, fnSave_pass, fnfailed, cntr)
            }
        }
        function fnSave_pass(res, cntr) {
            if (res.split("|^|")[0] == "0") {
                if (SaveCntr == (cntr + 1)) {
                    AutoHideAlertMsg("Initiative details saved/updated successfully !");
                    fnGetReport(0);
                }
                else {
                    fnSaveAllOpen(cntr + 1);
                }
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("Initiative name already exist !");
                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "3") {
                AutoHideAlertMsg("Configuration is not allowed only on Secondary Product/s !");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }


        function fnDeleteSelected() {
            var InitIds = "";
            $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                        InitIds += "^" + $(this).closest("tr").attr("Init");
                    }
                }
            });

            if (InitIds == "") {
                AutoHideAlertMsg("Please select atleast one Initiative for Action !");
            }
            else {
                InitIds = InitIds.substring(1);

                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Delete <span style='color:#0000ff; font-weight: 700;'>" + InitIds.split("^").length + "</span> Initiative(s).<br/>Do you want to continue ?</div>");

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
                            $("#divConfirm").dialog('close');
                            var UserID = $("#ConatntMatter_hdnUserID").val();

                            $("#dvloader").show();
                            PageMethods.fnDeleteInitiative(InitIds, UserID, fnDeleteInitiative_pass, fnfailed);
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
        }

        function fnDelete(ctrl) {
            var INITID = $(ctrl).closest("tr").attr("Init");
            var initname = $(ctrl).closest("tr").attr("initname");

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to delete this Initiative <br/><span style='color:#0000ff; font-weight: 700;'>" + initname + "</span></div>");
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
                        $("#divConfirm").dialog('close');
                        var UserID = $("#ConatntMatter_hdnUserID").val();

                        $("#dvloader").show();
                        PageMethods.fnDeleteInitiative(INITID, UserID, fnDeleteInitiative_pass, fnfailed);
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
        function fnDeleteInitiative_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Initiative deleted successfully !");
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }

        function fnSettle(ctrl) {
            var INITID = $(ctrl).closest("tr").attr("Init");
            var initname = $(ctrl).closest("tr").attr("initname");

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to Settle this Initiative <br/><span style='color:#0000ff; font-weight: 700;'>" + initname + "</span></div>");
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
                        $("#divConfirm").dialog('close');

                        var UserID = $("#ConatntMatter_hdnUserID").val();
                        var LoginID = $("#ConatntMatter_hdnLoginID").val();

                        $("#dvloader").show();
                        PageMethods.fnSettle(INITID, UserID, LoginID, fnSettle_pass, fnfailed);
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
        function fnSettle_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Initiative settled successfully !");
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }

        function fnGetRejectComment(ctrl) {
            var INITID = $(ctrl).closest("tr").attr("Init");
            var rowIndex = $(ctrl).closest("tr").index();
            var flgDBEdit = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("flgDBEdit");

            $("#ConatntMatter_hdnInitID").val(INITID);
            var RoleID = $("#ConatntMatter_hdnRoleID").val();

            $("#dvloader").show();
            PageMethods.fnGetRejectComments(INITID, RoleID, fnGetRejectComments_pass, fnfailed, flgDBEdit);
        }
        function fnGetRejectComments_pass(res, flgDBEdit) {
            if (res.split("|^|")[0] == "0") {
                var NotEditablestr = "", Editablestr = "";
                if (res.split("|^|")[1] == "") {
                    NotEditablestr = "No Comment Found !";
                    Editablestr = ""
                }
                else {
                    var jsonTbl = $.parseJSON(res.split("|^|")[1]).Table;
                    for (var i = 0; i < jsonTbl.length; i++) {
                        if (jsonTbl[i].flgEdit.toString() == "0") {
                            NotEditablestr += "<span style='font-weight: 700;'>" + jsonTbl[i].CommentsBy.toString() + " :</span>";
                            NotEditablestr += "<div style='padding-bottom: 10px;'>" + jsonTbl[i].comments.toString() + "</div>";
                        }
                        else {
                            Editablestr = jsonTbl[i].comments.toString();
                        }
                    }
                }

                $("#dvPrevComment").html(NotEditablestr);

                if (flgDBEdit == "1") {
                    $("#dvPrevComment").next().show();
                    $("#dvRejectComment").find("textarea").eq(0).show();
                    $("#dvRejectComment").find("textarea").eq(0).val(Editablestr);
                    $("#dvRejectComment").dialog({
                        "modal": true,
                        "width": "640",
                        "title": "Message :",
                        close: function () {
                            $("#dvRejectComment").dialog('destroy');
                        },
                        buttons: [{
                            text: 'Save',
                            class: 'btn-primary',
                            click: function () {
                                if ($("#dvRejectComment").find("textarea").eq(0).val() != "") {
                                    $("#dvRejectComment").dialog('close');

                                    var INITID = $("#ConatntMatter_hdnInitID").val();
                                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                                    var UserID = $("#ConatntMatter_hdnUserID").val();
                                    var LoginID = $("#ConatntMatter_hdnLoginID").val();

                                    $("#dvloader").show();
                                    PageMethods.fnSaveRejectComments(INITID, RoleID, UserID, LoginID, $("#dvRejectComment").find("textarea").eq(0).val(), fnSaveRejectComments_pass, fnfailed);
                                }
                                else {
                                    AutoHideAlertMsg("Please enter your Comments !");
                                }
                            }
                        }, {
                            text: 'Cancel',
                            class: 'btn-primary',
                            click: function () {
                                $("#dvRejectComment").dialog('close');
                            }
                        }]
                    });
                }
                else {
                    $("#dvPrevComment").next().hide();
                    $("#dvRejectComment").find("textarea").eq(0).hide();
                    $("#dvRejectComment").dialog({
                        "modal": true,
                        "width": "640",
                        "title": "Message :",
                        close: function () {
                            $("#dvRejectComment").dialog('destroy');
                        }
                    });
                }
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
        function fnSaveRejectComments_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Comment saved successfully !");
            }
            else {
                fnfailed();
            }
            $("#dvloader").hide();
        }

        function fnExpandContent(cntr) {
            if (cntr == 1) {
                $("#tblReport").attr("IsSchemeAppRule", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    if ($(this).attr("BaseProd") == "") {
                        $(this).find("td[iden='Init']").eq(7).html("<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-danger btn-small' style='cursor: default;'>No Rule Defined</a><div>");
                    }
                    else {
                        $(this).find("td[iden='Init']").eq(7).html("<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopupNonEditable(this);'>View Details</a><div>");
                    }
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).next().html("Initiatives Application Rules");
            }
            else if (cntr == 2) {
                $("#tblReport").attr("IsLocExpand", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    var loc = ExtendContentBody($(this).attr("loc"));
                    if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0")
                        $(this).find("td[iden='Init']").eq(6).html("<div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + loc + "</div>");
                    else
                        $(this).find("td[iden='Init']").eq(6).html("<div style='width: 202px; min-width: 202px;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>");

                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).next().html("Location");
                Tooltip(".clsInform");
            }
            else {
                $("#tblReport").attr("IsChannelExpand", "1");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    var channel = ExtendContentBody($(this).attr("channel"));
                    if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "0")
                        $(this).find("td[iden='Init']").eq(5).html("<div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + channel + "</div>");
                    else
                        $(this).find("td[iden='Init']").eq(5).html("<div style='width: 202px; min-width: 202px;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("class", "fa fa-minus-square clsExpandCollapse");
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("onclick", "fnCollapseContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).next().html("Channel");
                Tooltip(".clsInform");
            }

            fnAdjustColumnWidth();
            var trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']");
            for (var i = 0; i < trArr.length; i++) {
                fnAdjustRowHeight(i);
            }
        }
        function ExtendContentBody(strfull) {
            var str = "";
            for (i = 0; i < strfull.split(",").length; i++) {
                //str += "<span class='clstdExpandedContent'>" + strfull.split(",")[i] + "</span>";
                if (i != 0)
                    str += ", ";
                str += strfull.split(",")[i];
            }
            return str;
        }
        function fnCollapseContent(cntr) {
            if (cntr == 1) {
                $("#tblReport").attr("IsSchemeAppRule", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='Init']").eq(7).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).attr("class", "fa fa-buysellads clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnAppRuleExpandCollapse']").eq(0).next().html("");
            }
            else if (cntr == 2) {
                $("#tblReport").attr("IsLocExpand", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='Init']").eq(6).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("class", "fa fa-map-marker clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnlocExpandCollapse']").eq(0).next().html("");
            }
            else {
                $("#tblReport").attr("IsChannelExpand", "0");
                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init'][flgEdit='0']").each(function () {
                    $(this).find("td[iden='Init']").eq(5).html("");
                });
                $("#tblReport").find("thead").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("class", "fa fa-sitemap clsExpandCollapse");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).attr("onclick", "fnExpandContent(" + cntr + ");");
                $("#tblReport").find("thead ").eq(0).find("i[iden='btnChannelExpandCollapse']").eq(0).next().html("");
            }

            fnAdjustColumnWidth();
            var trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']");
            for (var i = 0; i < trArr.length; i++) {
                fnAdjustRowHeight(i);
            }
        }

        function GetNxtMonthToFromDate() {
            var d = new Date();
            var NxtMnth = new Date(d.getFullYear(), d.getMonth() + 2, 0);
            return "01-" + MonthArr[NxtMnth.getMonth()] + "-" + NxtMnth.getFullYear() + "|" + NxtMnth.getDate() + "-" + MonthArr[NxtMnth.getMonth()] + "-" + NxtMnth.getFullYear();
        }
        function fnSetToFromDate(ctrl) {
            $(ctrl).closest("td[iden='Init']").find("input").eq(0).val($("#ddlMonth").val().split("|")[0]);
            $(ctrl).closest("td[iden='Init']").find("input").eq(1).val($("#ddlMonth").val().split("|")[1]);
        }

        function fnInitAppRuleInitialStr() {
            var str = "";
            str += "<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopup(this);'>Edit Details</a><div>";
            str += "<div style='width:420px; min-width:420px; display: none;'>";
            str += "<div class='row no-gutters'>"; // 1
            str += "<div class='col-6 clsBaseProd' style='padding-right: 1px; text-align: left; font-size:0.66rem;'>"; // 2
            str += "<div class='clsAppRuleHeader'>Base Products :</div>";
            str += "<div class='clsAppRuleSlabContainer'>";  //3
            str += "<div iden='AppRuleSlabWiseContainer' slabno='1' IsNewSlab='1'>";
            str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer;'>Slab 1</span><i class='fa fa-minus-square' onclick='fnAppRuleRemoveSlabMini(this);'></i><i class='fa fa-plus-square' onclick='fnAppRuleAddNewSlabMini(this);'></i></div>";
            str += "<table class='table table-bordered clsAppRule'>";
            //str += "<thead><tr><th>#</th><th style='width: 80%; min-width: 80%;'>Applicable Product</th><th style='width: 50px; min-width: 50px;'>Action</th></tr></thead>";
            str += "<tbody><tr grpno='1' IsNewGrp='1'><td>Grp 1</td><td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 16px;'>Select Products Applicable in Group</div><div style='position: absolute; right:5px; top:-3px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' onclick='fnAppRuleShowCopyBucketPopup(this, 1);' style='height: 12px;'/><br /><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='0' prodlvl='' prodhier='' Inittype='0' InitMax='0' InitMin='0' InitApplied='0' onclick='fnAppRuleShowProdHierPopup(this, 1, 1);' style='height: 12px;' /></div></div></td><td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewBasetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleRemoveBasetrMini(this);'></i></td></tr></tbody></table>";
            str += "</div>";
            str += "</div>";  // 3
            str += "</div>";  // 2
            str += "<div class='col-6 clsInitProd' style='text-align: left; font-size:0.66rem;'>"; // 2
            str += "<div class='clsAppRuleHeader'>Initiative Products :</div>";
            str += "<div class='clsAppRuleSlabContainer'>";  //3
            str += "<table class='table table-bordered clsAppRule'>";
            //str += "<thead><tr><th style='width: 80%; min-width: 80%;'>Applicable Product</th><th style='width: 50px; min-width: 50px;'>Action</th></tr></thead>";
            str += "<tbody><tr slabno='1' grpno='1' IsNewSlab='1' IsNewGrp='1'><td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 16px;'>Select Products</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier'  Benefittype='0' BenefitAppliedOn='0' BenefitValue='0' copybuckettd='0' prodlvl='' prodhier='' onclick='fnAppRuleShowProdHierPopup(this, 2, 1);' style='height: 12px;' /></div></div></td><td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewInitiativetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleReomveInitiativetr(this, 1);'></i></td></tr></tbody></table>";
            str += "</div>";  // 3
            //str += "<div style='float: right;'><a href='#' onclick='fnShowApplicationRulesPopup(this);'>Edit Details</a><div>";
            str += "</div>";  // 2
            str += "</div>";  // 1
            return str;
        }
        function fnInitAppRuleEditable(strBase, strInit) {
            var str = "";
            str += "<div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopup(this);'>Edit Details</a><div>";
            str += "<div class='row no-gutters' style='width: 420px; min-width: 420px; display: none;'>";
            //------------
            str += "<div class='col-6 clsBaseProd' style='padding-right: 1px; text-align: left; font-size:0.66rem;'>";
            str += "<div class='clsAppRuleHeader'>Base Products :</div>";
            str += "<div class='clsAppRuleSlabContainer'>";
            if (strBase != "") {
                var ArrSlab = strBase.split("$$$");
                for (i = 1; i < ArrSlab.length; i++) {
                    str += "<div iden='AppRuleSlabWiseContainer' slabno='" + ArrSlab[i].split("***")[0] + "' IsNewSlab='0'>";
                    str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer;'>Slab " + i + "</span><i class='fa fa-minus-square' onclick='fnAppRuleRemoveSlabMini(this);'></i><i class='fa fa-plus-square' onclick='fnAppRuleAddNewSlabMini(this);'></i></div>";
                    str += "<table class='table table-bordered clsAppRule'>";
                    str += "<tbody>";

                    var ArrGrp = ArrSlab[i].split("***");
                    for (j = 1; j < ArrGrp.length; j++) {
                        str += "<tr grpno='" + ArrGrp[j].split("*$*")[5] + "' IsNewGrp='0'><td>Grp " + j + "</td><td>";

                        str += "<div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 16px;'>";
                        var prodlvl = 0, prodhier = "";
                        var ArrPrd = ArrGrp[j].split("*$*")[4].split("^");
                        for (k = 0; k < ArrPrd.length; k++) {
                            if (parseInt(ArrPrd[k].split("|")[1]) > prodlvl)
                                prodlvl = parseInt(ArrPrd[k].split("|")[1]);
                            if (k != 0) {
                                prodhier += "^";
                                str += ", ";
                            }
                            prodhier += ArrPrd[k].split("|")[0] + "|" + ArrPrd[k].split("|")[1];
                            str += ArrPrd[k].split("|")[2];
                            //str += "<span class='clstdExpandedContent'>" + ArrPrd[k].split("|")[2] + "</span>";
                        }
                        str += "</div><div style='position: absolute; right:5px; top:-3px; '><img src='../../Images/favBucket.png' title='Favourite Bucket' onclick='fnAppRuleShowCopyBucketPopup(this, 1);' style='height: 12px;'/><br /><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='" + ArrGrp[j].split("*$*")[6] + "' prodlvl='" + prodlvl + "' prodhier='" + prodhier + "' Inittype='" + ArrGrp[j].split("*$*")[0] + "' InitMax='" + ArrGrp[j].split("*$*")[1] + "' InitMin='" + ArrGrp[j].split("*$*")[2] + "' InitApplied='" + ArrGrp[j].split("*$*")[3] + "' onclick='fnAppRuleShowProdHierPopup(this, 1, 1);' style='height: 12px;' /></div></div>";
                        str += "</td><td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewBasetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleRemoveBasetrMini(this);'></i></td></tr>";
                    }
                    str += "</tbody></table>";
                    str += "</div>";
                }
            }
            str += "</div>";
            str += "</div>";
            //--------------
            str += "<div class='col-6 clsInitProd' style='text-align: left; font-size:0.66rem;'>";
            str += "<div class='clsAppRuleHeader'>Initiative Products :</div>";
            str += "<div class='clsAppRuleSlabContainer'>";
            if (strInit != "") {
                str += "<table class='table table-bordered clsAppRule'>";
                //str += "<thead><tr><th style='width: 80%; min-width: 80%;'>Applicable Product</th><th style='width: 50px; min-width: 50px;'>Action</th></tr></thead>";
                str += "<tbody>";

                var ArrGrp = strInit.split("***");
                for (j = 1; j < ArrGrp.length; j++) {
                    str += "<tr slabno='" + ArrGrp[j].split("*$*")[3] + "' grpno='" + ArrGrp[j].split("*$*")[5] + "' IsNewSlab='0' IsNewGrp='0'><td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 16px;'>";

                    var prodlvl = 0, prodhier = "";
                    var ArrPrd = ArrGrp[j].split("*$*")[4].split("^");
                    for (k = 0; k < ArrPrd.length; k++) {
                        if (parseInt(ArrPrd[k].split("|")[1]) > prodlvl)
                            prodlvl = parseInt(ArrPrd[k].split("|")[1]);
                        if (k != 0) {
                            prodhier += "^";
                            str += ", ";
                        }
                        prodhier += ArrPrd[k].split("|")[0] + "|" + ArrPrd[k].split("|")[1];
                        str += ArrPrd[k].split("|")[2];
                        //str += "<span class='clstdExpandedContent'>" + ArrPrd[k].split("|")[2] + "</span>";
                    }
                    str += "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' Benefittype='" + ArrGrp[j].split("*$*")[0] + "' BenefitAppliedOn='" + ArrGrp[j].split("*$*")[1] + "' BenefitValue='" + ArrGrp[j].split("*$*")[2] + "' prodlvl='" + prodlvl + "' prodhier='" + prodhier + "' copybuckettd='" + ArrGrp[j].split("*$*")[6] + "' onclick='fnAppRuleShowProdHierPopup(this, 2, 1);' style='height: 12px;' /></div></div></td><td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewInitiativetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleReomveInitiativetr(this, 1);'></i></td></tr>";
                }
                str += "</tbody></table>";
            }
            str += "</div>";
            //str += "<div style='float: right;'><a href='#' onclick='fnShowApplicationRulesPopup(this);'>Edit Details</a><div>";
            str += "</div>";

            str += "</div>";
            return str;
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
                //strtable += "<th style='width:25%;'>SubD</th>";
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
                        $("#btnAddNewNode").hide();
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
                                var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
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
                        $("#btnAddNewNode").hide();
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
                                var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
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

            //$("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $(ctrl).closest("tr").addClass("Active").siblings().removeClass("Active");

            if (ProdLvl == "30") {
                $("#btnAddNewNode").show();
                $("#btnAddNewNode").html("Add New Brand Form");
                $("#btnAddNewNode").attr("onclick", "fnAddNewBrandForm(0);");
            }
            else if (ProdLvl == "40") {
                $("#btnAddNewNode").show();
                $("#btnAddNewNode").html("Add New Sub Brand Form");
                $("#btnAddNewNode").attr("onclick", "fnAddNewSubBrandForm();");
            }
            else
                $("#btnAddNewNode").hide();

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
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                var InSubD = 0;
                //if ($("#chkIncludeSubd").is(":checked")) {
                //    InSubD = 1;
                //}

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
                title = "Product/s :";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                title = "Site/s :";
            else
                title = "Channel/s :";

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
                        $("#divCopyBucketSelectionTbl").html(strtable);

                        $("#PopupCopyBucketlbl").html("Channel Hierarchy");
                    }

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();

                    var CopyBucketTD = $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
                    PageMethods.GetBucketbasedonType(LoginID, RoleID, UserID, $("#ConatntMatter_hdnBucketType").val(), GetBucketbasedonType_pass, GetBucketbasedonType_failed, CopyBucketTD);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var strCopyBucket = fnCopyBucketSelection();

                        $(ctrl).closest("div").prev().html(strCopyBucket.split("|||")[1]);
                        $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("prodlvl", strCopyBucket.split("|||")[3]);
                        $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("prodhier", strCopyBucket.split("|||")[2]);
                        $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD", strCopyBucket.split("|||")[0]);

                        var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
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
            fnGetSelHierTbl();
        }
        function fnGetSelHierTbl() {
            var BucketValues = [];
            if ($("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").length > 0)
                $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                    var Selstr = $(this).attr("strvalue");
                    for (var i = 0; i < Selstr.split("^").length; i++) {
                        BucketValues.push({
                            "col1": Selstr.split("^")[i].split("|")[0],
                            "col2": Selstr.split("^")[i].split("|")[1],
                            "col3": $("#ConatntMatter_hdnBucketType").val()
                        });
                    }
                });

            if (BucketValues.length > 0) {
                $("#dvloader").show();
                PageMethods.GetSelHierTbl(BucketValues, $("#ConatntMatter_hdnBucketType").val(), "0", GetSelHierTbl_pass, GetSelHierTbl_failed);
            }
            else {
                $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
        }
        function GetSelHierTbl_pass(res) {
            $("#dvloader").hide();
            $("#divCopyBucketSelectionTbl").html(res);
        }
        function GetSelHierTbl_failed() {
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
        function fnAppRuleUpdateGrpNo(tbody, lbl) {
            var cntr = 1;
            $(tbody).find("tr").each(function () {
                $(this).find("td").eq(0).html(lbl + " " + cntr);
                cntr++;
            });
        }
        function fnAppRuleUpdateSlabNo(container) {
            var cntr = 1;
            $(container).find("div.clsAppRuleSubHeader").each(function () {
                $(this).find("span").html("Slab " + cntr);
                cntr++;
            });
        }
        function fnAppRuleExpandCollapseSlab(ctrl) {
            var flgExpandCollapse = $(ctrl).closest("div.clsAppRuleSubHeader").attr("flgExpandCollapse");
            if (flgExpandCollapse == "1") {
                $(ctrl).closest("div.clsAppRuleSubHeader").attr("flgExpandCollapse", "0");
                $(ctrl).closest("div.clsAppRuleSubHeader").next().hide();
            }
            else {
                $(ctrl).closest("div.clsAppRuleSubHeader").attr("flgExpandCollapse", "1");
                $(ctrl).closest("div.clsAppRuleSubHeader").next().show();
            }
        }
        function fnAppRuleReomveInitiativetr(ctrl, cntr) {
            var slabno = $(ctrl).closest("tr").attr("slabno");
            var trArr = $(ctrl).closest("tbody").find("tr[slabno='" + slabno + "']");
            if (trArr.length > 1) {
                $(ctrl).closest("tr").remove();
            }
            else {
                var slabblock = "";
                if (cntr == 1) {
                    slabblock = $(ctrl).closest("div.clsInitProd").prev();
                }
                else {
                    slabblock = $(ctrl).closest("div.clsInitProd").prev().prev();
                }
                var lblSlabNo = slabblock.find("div[iden='AppRuleSlabWiseContainer'][slabno='" + slabno + "']").find("div.clsAppRuleSubHeader").eq(0).find("span").eq(0).html();

                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Deletion of this row, leads the deletion of <span style='color:#0000ff; font-weight: 700;'>" + lblSlabNo + "</span> in Base Products. Do you want to continue ?</div>");
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "300",
                    "height": "200",
                    "title": "Message :",
                    close: function () {
                        $("#divConfirm").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Yes',
                        class: 'btn-primary',
                        click: function () {
                            slabblock.find("div[iden='AppRuleSlabWiseContainer'][slabno='" + slabno + "']").remove();
                            $(ctrl).closest("tr").remove();
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
        }

        //----- In tbl
        function fnAppRuleAddNewSlabMini(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();

            var container = $(ctrl).closest("div.clsAppRuleSlabContainer");
            var lstSlabNo = 0;
            container.find("div[iden='AppRuleSlabWiseContainer']").each(function () {
                if (parseInt($(this).attr("slabno")) > lstSlabNo) {
                    lstSlabNo = parseInt($(this).attr("slabno"));
                }
            });
            var newSlabNo = lstSlabNo + 1;

            var str = "";
            str += "<div iden='AppRuleSlabWiseContainer' slabno='" + newSlabNo + "' IsNewSlab='1'>";
            str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1'>" + $(ctrl).closest("div").html() + "</div>";
            str += "<table class='table table-bordered clsAppRule'>";
            var cntr = 0;
            $(ctrl).closest("div").next().find("tr").each(function () {
                cntr++;
                str += "<tr grpno='" + cntr + "' IsNewGrp='1'>" + $(this).html() + "</tr>";
            });
            str += "</table>";
            str += "</div>";
            $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").after(str);

            str = "";
            str += "<tr slabno='" + newSlabNo + "' grpno='1' IsNewSlab='1' IsNewGrp='1'>";
            str += "<td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 16px;'>Select Products</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier'  Benefittype='0' BenefitAppliedOn='0' BenefitValue='0' copybuckettd='0' prodlvl='' prodhier='' onclick='fnAppRuleShowProdHierPopup(this, 2, 1);' style='height: 12px;' /></div></div></td>";
            str += "<td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewInitiativetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleReomveInitiativetr(this, 1);'></i></td>";
            str += "</tr>";
            $(ctrl).closest("div.clsBaseProd").next().find("table").eq(0).find("tbody").eq(0).append(str);

            fnAppRuleUpdateSlabNo(container);
            fnUpdateInitProdSel($(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("img[iden='ProductHier']").eq(0), 1);
            fnAdjustRowHeight(rowIndex);
        }
        function fnAppRuleRemoveSlabMini(ctrl) {
            var container = $(ctrl).closest("div.clsAppRuleSlabContainer");
            var SlabNo = $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").attr("slabno");

            $(ctrl).closest("div.clsBaseProd").next().find("table").eq(0).find("tr[slabno='" + SlabNo + "']").remove();
            $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").remove();
            fnAppRuleUpdateSlabNo(container);
        }

        function fnAppRuleAddNewBasetrMini(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();

            var tbody = $(ctrl).closest("tbody");
            var lstGrpNo = 0;
            tbody.find("tr").each(function () {
                if (parseInt($(this).attr("grpno")) > lstGrpNo) {
                    lstGrpNo = parseInt($(this).attr("grpno"));
                }
            });
            var newgrpno = lstGrpNo + 1;

            var str = "<tr grpno='" + newgrpno + "' IsNewGrp='1'>" + $(ctrl).closest("tr").html() + "</tr>";
            $(ctrl).closest("tr").after(str);

            fnAppRuleUpdateGrpNo(tbody, "Grp");
            fnAdjustRowHeight(rowIndex);
        }
        function fnAppRuleRemoveBasetrMini(ctrl) {
            var tbody = $(ctrl).closest("tbody");
            if ($(ctrl).closest("tbody").find("tr").length > 1) {
                $(ctrl).closest("tr").remove();
                fnAppRuleUpdateGrpNo(tbody, "Grp");
            }
            else {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Slab must have atleast one row. </div>");
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "300",
                    "height": "120",
                    "title": "Message :"
                });
            }
        }

        function fnAppRuleAddNewInitiativetrMini(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
            var slabno = $(ctrl).closest("tr").attr("slabno");

            var tbody = $(ctrl).closest("tbody");
            var lstGrpNo = 0;
            tbody.find("tr").each(function () {
                if (parseInt($(this).attr("grpno")) > lstGrpNo) {
                    lstGrpNo = parseInt($(this).attr("grpno"));
                }
            });
            var newgrpno = lstGrpNo + 1;

            var str = "<tr slabno='" + slabno + "' grpno='" + newgrpno + "' IsNewSlab='1' IsNewGrp='1'>" + $(ctrl).closest("tr").html() + "</tr>";
            $(ctrl).closest("tr").after(str);

            fnAdjustRowHeight(rowIndex);
        }

        //----
        function fnAppRuleShowCopyBucketPopup(ctrl, Callingbyflg) {
            $("#divCopyBucketPopupTbl").html("<div style='margin-top: 25%; text-align: center;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif' /></div>");
            $("#ConatntMatter_hdnBucketType").val("1");

            var title = "Product/s :";
            $("#divCopyBucketPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
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

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();

                    var CopyBucketTD = $(ctrl).closest("td").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
                    PageMethods.GetBucketbasedonType(LoginID, RoleID, UserID, $("#ConatntMatter_hdnBucketType").val(), GetBucketbasedonType_pass, GetBucketbasedonType_failed, CopyBucketTD);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var strCopyBucket = fnCopyBucketSelection();

                        $(ctrl).closest("div").prev().html(strCopyBucket.split("|||")[1]);
                        $(ctrl).closest("td").find("img[iden='ProductHier']").eq(0).attr("prodlvl", strCopyBucket.split("|||")[3]);
                        $(ctrl).closest("td").find("img[iden='ProductHier']").eq(0).attr("prodhier", strCopyBucket.split("|||")[2]);
                        $(ctrl).closest("td").find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD", strCopyBucket.split("|||")[0]);

                        fnUpdateInitProdSel(ctrl, Callingbyflg);
                        fnUpdateOtherSlabAndInitProdSel(ctrl, Callingbyflg, strCopyBucket.split("|||")[0] + "||||" + strCopyBucket.split("|||")[3] + "||||" + strCopyBucket.split("|||")[2] + "||||" + strCopyBucket.split("|||")[1]);

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

        function fnAppRuleShowProdHierPopup(ctrl, cntr, Callingbyflg) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val("1");
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");
            $("#ConatntMatter_hdnBucketType").val("1");

            var title = "Product";
            var strtable = "";
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

            if (Callingbyflg == "1") {
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
                        $("#btnAddNewNode").hide();
                        $("#divHierPopup").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Select',
                        class: 'btn-primary',
                        click: function () {
                            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
                            var SelectedHierValues = fnProdSelected(ctrl).split("||||");
                            if (cntr == 1) {
                                $(ctrl).attr("copybuckettd", "0");
                                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                                if (SelectedHierValues[2] != "") {
                                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                                    fnUpdateInitProdSel(ctrl, Callingbyflg);

                                    fnUpdateOtherSlabAndInitProdSel(ctrl, Callingbyflg, "0||||" + SelectedHierValues[0] + "||||" + SelectedHierValues[1] + "||||" + SelectedHierValues[2]);
                                }
                                else {
                                    $(ctrl).closest("div").prev().html("Select Products Applicable in Group");
                                }
                            }
                            else {
                                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                                if (SelectedHierValues[2] != "") {
                                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                                }
                                else {
                                    $(ctrl).closest("div").prev().html("Select Products");
                                }
                            }
                            fnAdjustRowHeight(rowIndex);
                            $("#divHierPopup").dialog('close');
                        }
                    },
                    {
                        text: 'Reset',
                        class: 'btn-primary',
                        click: function () {
                            fnHierPopupReset();
                        }
                    },
                    {
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
                        $("#btnAddNewNode").hide();
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
                                                fnSaveNewBucket(ctrl, cntr);
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
                            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
                            var SelectedHierValues = fnProdSelected(ctrl).split("||||");
                            if (cntr == 1) {
                                $(ctrl).attr("copybuckettd", "0");
                                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                                if (SelectedHierValues[2] != "") {
                                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                                    fnUpdateInitProdSel(ctrl, Callingbyflg);

                                    fnUpdateOtherSlabAndInitProdSel(ctrl, Callingbyflg, "0||||" + SelectedHierValues[0] + "||||" + SelectedHierValues[1] + "||||" + SelectedHierValues[2]);
                                }
                                else {
                                    $(ctrl).closest("div").prev().html("Select Products Applicable in Group");
                                }
                            }
                            else {
                                $(ctrl).attr("ProdLvl", SelectedHierValues[0]);
                                $(ctrl).attr("ProdHier", SelectedHierValues[1]);
                                if (SelectedHierValues[2] != "") {
                                    $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
                                }
                                else {
                                    $(ctrl).closest("div").prev().html("Select Products");
                                }
                            }
                            fnAdjustRowHeight(rowIndex);
                            $("#divHierPopup").dialog('close');
                        }
                    },
                    {
                        text: 'Reset',
                        class: 'btn-primary',
                        click: function () {
                            fnHierPopupReset();
                        }
                    },
                    {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divHierPopup").dialog('close');
                        }
                    }]
                });
            }
        }

        function fnUpdateInitProdSel(ctrl, Callingbyflg) {
            var SelectedHier = "", prodlvl = 10, descr = "", rowIndex = "0";
            var slabNo = $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").eq(0).attr("slabno");


            var SelectionArr = [];
            $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").find("img[iden='ProductHier']").each(function () {
                if ($(this).attr("prodhier") != "") {
                    var tempArr = $(this).attr("prodhier").split("^");
                    for (var i = 0; i < tempArr.length; i++) {
                        if (SelectionArr.indexOf(tempArr[i]) == -1) {
                            SelectionArr.push(tempArr[i]);
                            SelectedHier += "^" + tempArr[i];
                            descr += ", " + $(this).closest("div").prev().html().split(", ")[i];
                        }
                    }
                }
            });
            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                descr = descr.substring(2);
                for (var i = 0; i < SelectedHier.split("^").length; i++) {
                    if (parseInt(SelectedHier.split("^")[i].split("|")[1]) > prodlvl) {
                        prodlvl = parseInt(SelectedHier.split("^")[i].split("|")[1]);
                    }
                }
            }

            if (Callingbyflg == 1) {
                rowIndex = $(ctrl).closest("tr[iden='Init']").index();

                $(ctrl).closest("div.clsBaseProd").next().find("tr[slabno='" + slabNo + "']").each(function () {
                    $(this).find("img[iden='ProductHier']").attr("prodhier", SelectedHier);
                    $(this).find("img[iden='ProductHier']").closest("div").prev().html(descr);
                    $(this).find("img[iden='ProductHier']").attr("prodlvl", prodlvl);
                });
                fnAdjustRowHeight(rowIndex);
            }
            else {
                $(ctrl).closest("div.clsBaseProd").next().next().find("tr[slabno='" + slabNo + "']").each(function () {
                    $(this).find("img[iden='ProductHier']").attr("prodhier", SelectedHier);
                    $(this).find("img[iden='ProductHier']").closest("div").prev().html(descr);
                    $(this).find("img[iden='ProductHier']").attr("prodlvl", prodlvl);
                });
            }
        }

        function fnUpdateOtherSlabAndInitProdSel(ctrl, Callingbyflg, SelectedHierValues) {
            var grpno = $(ctrl).closest("tr").index();   // $(ctrl).closest("tr").attr("grpno");
            var slabno = $(ctrl).closest("tr").closest("div").attr("slabno");
            var SelectedHierValuesArr = SelectedHierValues.split("||||");

            $("#divAppRuleBaseProdSec").find("div[iden='AppRuleSlabWiseContainer']").each(function () {
                if ($(this).attr("slabno") != slabno) {
                    if ($(this).find("table").eq(0).find("tbody").eq(0).find("tr").length >= (grpno + 1)) {
                        var btnProdSel = $(this).find("table").eq(0).find("tbody").eq(0).find("tr").eq(grpno).find("img[iden='ProductHier']").eq(0);

                        $(btnProdSel).attr("copybuckettd", SelectedHierValuesArr[0]);
                        $(btnProdSel).attr("ProdLvl", SelectedHierValuesArr[1]);
                        $(btnProdSel).attr("ProdHier", SelectedHierValuesArr[2]);
                        $(btnProdSel).closest("div").prev().html(SelectedHierValuesArr[3]);

                        fnUpdateInitProdSel(btnProdSel, Callingbyflg);
                    }
                }
            });
        }

        //------ Popup
        function fnActivateSlab(ctrl, cntr) {
            var slabno = $(ctrl).attr("slabno");

            if (cntr == 1) {
                $(ctrl).addClass("slab-active").siblings().removeClass("slab-active");

                $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr").removeClass("slab-active");
                $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr[slabno='" + slabno + "']").addClass("slab-active");
            }
            else {
                $(ctrl).closest("tbody").find("tr").removeClass("slab-active");
                $(ctrl).closest("tbody").find("tr[slabno='" + slabno + "']").addClass("slab-active");

                $("#divAppRuleBaseProdSec").find("div[iden='AppRuleSlabWiseContainer'][slabno='" + slabno + "']").eq(0).addClass("slab-active").siblings().removeClass("slab-active")
            }
        }
        function fnConditionChkDropdown(ctrl) {
            var Inittype = $(ctrl).val();
            $(ctrl).closest("tbody").find("tr").each(function () {
                var ddl = $(this).find("td").eq(2).find("select").eq(0);
                ddl.val(Inittype);
                fnUOMbasedonType(ddl);
            });
        }
        function fnUOMbasedonType(ctrl) {
            var Inittype = $(ctrl).val();
            switch (Inittype) {
                case "0":
                    $(ctrl).closest("td").next().next().next().find("select").eq(0).val("0");           //UOM
                    $(ctrl).closest("td").next().next().find("input[type='text']").eq(0).val("0");      //Max
                    break;
                case "1":
                    var UOM = $(ctrl).closest("select").find("option[value='" + Inittype + "']").attr("uom");
                    $(ctrl).closest("td").next().next().next().find("select").eq(0).val(UOM);                       //UOM
                    $(ctrl).closest("td").next().next().find("input[type='text']").eq(0).val("9999999.99");         //Max
                    break;
                default:
                    var UOM = $(ctrl).closest("select").find("option[value='" + Inittype + "']").attr("uom");
                    $(ctrl).closest("td").next().next().next().find("select").eq(0).val(UOM);                   //UOM
                    $(ctrl).closest("td").next().next().find("input[type='text']").eq(0).val("9999999");        //Max
                    break;
            }

            if (Inittype != "0") {

            }
            else {

            }
        }
        function fnInitiativeTypeDropdown(ctrl) {
            var InitiativeType = $(ctrl).val();
            var slabno = $(ctrl).closest("tr").attr("slabno");
            $(ctrl).closest("tbody").find("tr[slabno='" + slabno + "']").each(function () {
                var ddl = $(this).find("td").eq(1).find("select").eq(0);
                ddl.val(InitiativeType);
            });
        }
        function fnAppliedOnDropdown(ctrl) {
            var AppliedOn = $(ctrl).val();
            var slabno = $(ctrl).closest("tr").attr("slabno");
            $(ctrl).closest("tbody").find("tr[slabno='" + slabno + "']").each(function () {
                var ddl = $(this).find("td").eq(2).find("select").eq(0);
                ddl.val(AppliedOn);
            });
        }

        function fnAppRuleAddNewSlab(slabno, IsNewSlab) {
            var str = "";
            str += "<div iden='AppRuleSlabWiseContainer' slabno='" + slabno + "' IsNewSlab='" + IsNewSlab + "' onclick='fnActivateSlab(this, 1);'>";
            str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1' style='margin-top: 5px;'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer; width: 88%;'></span><i class='fa fa-minus-square' onclick='fnAppRuleRemoveSlab(this);' style='font-size: 1rem;'></i><i class='fa fa-plus-square' onclick='fnAppRuleAddNewSlabbtnAction(this);' style='font-size: 1rem;'></i></div>";
            str += "<table class='table table-bordered table-sm' style='margin-bottom: 0;'><thead><tr><th style='width: 80px; text-align: center;'>#</th><th style='text-align: center;'>Product</th><th style='width: 100px; text-align: center;'>Condition Check</th><th style='width: 100px; text-align: center;'>Minimum</th><th style='width: 100px; text-align: center;'>Maximum</th><th style='width: 100px; text-align: center;'>UOM</th><th style='width: 80px; text-align: center;'>Action</th></tr></thead><tbody>";
            str += "<tr grpno='1' IsNewGrp='1'>";
            str += "<td style='text-align: center; font-weight: 700;'>Group 1</td>";
            str += "<td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 50px;'>Select Products Applicable in Group</div><div style='position: absolute; right:5px; top:-3px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' onclick='fnAppRuleShowCopyBucketPopup(this, 2);'/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='0' prodlvl='' prodhier='' onclick='fnAppRuleShowProdHierPopup(this, 1, 2);' style='margin-left:5px;'/></div></div></td>";
            str += "<td><select onchange='fnConditionChkDropdown(this);'>" + $("#ConatntMatter_hdnInitType").val() + "</select></td>";
            str += "<td><input type='text'/></td>";
            str += "<td><input type='text'/></td>";
            str += "<td><select disabled>" + $("#ConatntMatter_hdnUOM").val() + "</select></td>";
            str += "<td style='text-align: center;'><i class='fa fa-plus clsExpandCollapse' onclick='fnAppRuleAddNewBasetr(this);'></i><i class='fa fa-minus clsExpandCollapse' onclick='fnAppRuleRemoveBasetr(this);'></i></td>";
            str += "</tr>";
            str += "</tbody></table>";
            str += "</div>";

            var container = $("#divAppRuleBaseProdSec");
            container.append(str);
            fnAppRuleUpdateSlabNo(container);
        }
        function fnAppRuleAddNewInitiativetr(slabno) {
            var str = "<tr slabno='" + slabno + "' grpno='1' IsNewSlab='1' IsNewGrp='1' onclick='fnActivateSlab(this, 2);'>";
            str += "<td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 30px;'>Select Products</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='0' prodlvl='' prodhier='' onclick='fnAppRuleShowProdHierPopup(this, 2, 2);'/></div></div></td>";
            str += "<td><select onchange='fnInitiativeTypeDropdown(this);'>" + $("#ConatntMatter_hdnBenefit").val() + "</select></td>";
            str += "<td><select onchange='fnAppliedOnDropdown(this);'>" + $("#ConatntMatter_hdnAppliedOn").val() + "</select></td>";
            str += "<td><input type='text' value='0'/></td>";
            str += "<td style='text-align: center;'><i class='fa fa-plus clsExpandCollapse' onclick='fnAppRuleAddNewInitiativetrbtnAction(this);'></i><i class='fa fa-minus clsExpandCollapse' onclick='fnAppRuleReomveInitiativetr(this, 2);'></i></td>";
            str += "</tr>";
            $("#divAppRuleBenefitSec").find("tbody").eq(0).append(str);
        }
        function fnShowApplicationRulesPopup(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
            $("#txtApplicablePer").val($(ctrl).closest("tr[iden='Init']").attr("ApplicableNewPer"));

            var INITDescription = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(4).find("textarea").eq(0).val();
            $("#txtArINITDescription").val(INITDescription);

            // ---------
            $("#divAppRuleBaseProdSec").html("");
            $(ctrl).closest("td[iden='Init']").find("div.clsBaseProd").eq(0).find("div[iden='AppRuleSlabWiseContainer']").each(function () {
                fnAppRuleAddNewSlab($(this).attr("slabno"), $(this).attr("IsNewSlab"));

                var tr = "", trPopup = "", BaseProd = "", grpno = "", IsNewGrp = "";
                var copybuckettd = "", prodlvl = "", prodhier = "", Inittype = "", InitMax = "", InitMin = "", InitApplied = "";
                for (i = 0; i < $(this).find("table").eq(0).find("tbody").eq(0).find("tr").length; i++) {
                    tr = $(this).find("table").eq(0).find("tbody").eq(0).find("tr").eq(i);
                    grpno = tr.attr("grpno");
                    IsNewGrp = tr.attr("IsNewGrp");
                    BaseProd = tr.find("td").eq(1).find("div[iden='content']").eq(0).html();
                    copybuckettd = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("copybuckettd");
                    prodlvl = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodlvl");
                    prodhier = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodhier");
                    Inittype = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("Inittype");
                    InitMax = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitMax");
                    InitMin = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitMin");
                    InitApplied = tr.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("InitApplied");

                    if (i > 0) {
                        fnAppRuleAddNewBasetr($("#divAppRuleBaseProdSec").find("div[iden='AppRuleSlabWiseContainer'][slabno='" + $(this).attr("slabno") + "']").find("table").eq(0).find("tbody").eq(0).find("tr:last").find("td").eq(6).find("i").eq(0));
                    }
                    trPopup = $("#divAppRuleBaseProdSec").find("div[iden='AppRuleSlabWiseContainer'][slabno='" + $(this).attr("slabno") + "']").find("table").eq(0).find("tbody").eq(0).find("tr:last");

                    trPopup.attr("grpno", grpno);
                    trPopup.attr("IsNewGrp", IsNewGrp);
                    trPopup.find("td").eq(1).find("div[iden='content']").eq(0).html(BaseProd);
                    trPopup.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("copybuckettd", copybuckettd);
                    trPopup.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodlvl", prodlvl);
                    trPopup.find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodhier", prodhier);
                    trPopup.find("td").eq(2).find("select").eq(0).val(Inittype);
                    trPopup.find("td").eq(3).find("input[type='text']").eq(0).val(InitMax);
                    trPopup.find("td").eq(4).find("input[type='text']").eq(0).val(InitMin);
                    trPopup.find("td").eq(5).find("select").eq(0).val(InitApplied);
                }
            });

            // ---------
            $("#divAppRuleBenefitSec").find("thead").find("th:last").show();
            $("#divAppRuleBenefitSec").find("tbody").eq(0).html("");
            var slabno = "", grpno = "", IsNewSlab = "", IsNewGrp = "", BenefitProd = "", Benefittype = "", BenefitAppliedOn = "", BenefitValue = "", prodhier = "", prodlvl = "";
            $(ctrl).closest("td[iden='Init']").find("div.clsInitProd").eq(0).find("img[iden='ProductHier']").each(function () {
                slabno = $(this).closest("tr").attr("slabno");
                grpno = $(this).closest("tr").attr("grpno");
                IsNewSlab = $(this).closest("tr").attr("IsNewSlab");
                IsNewGrp = $(this).closest("tr").attr("IsNewGrp");
                BenefitProd = $(this).closest("td").find("div[iden='content']").eq(0).html();
                Benefittype = $(this).attr("Benefittype");
                BenefitAppliedOn = $(this).attr("BenefitAppliedOn");
                BenefitValue = $(this).attr("BenefitValue");
                prodhier = $(this).attr("prodhier");
                prodlvl = $(this).attr("prodlvl");
                copybuckettd = $(this).attr("copybuckettd");

                fnAppRuleAddNewInitiativetr(slabno);
                var tr = $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr:last");
                tr.attr("grpno", grpno);
                tr.attr("IsNewSlab", IsNewSlab);
                tr.attr("IsNewGrp", IsNewGrp);
                tr.find("td").eq(0).find("div[iden='content']").eq(0).html(BenefitProd);
                tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier", prodhier);
                tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodlvl", prodlvl);
                tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("copybuckettd", copybuckettd);
                tr.find("td").eq(1).find("select").eq(0).val(Benefittype);
                tr.find("td").eq(2).find("select").eq(0).val(BenefitAppliedOn);
                tr.find("td").eq(3).find("input[type='text']").eq(0).val(BenefitValue);
            });


            $("#txtApplicablePer").removeAttr("readonly");
            $("#divApplicationRulePopup").dialog({
                "modal": true,
                "width": "70%",
                "height": "540",
                "title": "Initiatives Application Rules",
                open: function () {
                    //
                },
                close: function () {
                    $("#divApplicationRulePopup").dialog('destroy');
                },
                buttons: [{
                    text: 'Submit',
                    class: 'btn-primary',
                    click: function () {
                        fnAppRulePopuptoTbl(ctrl);
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divApplicationRulePopup").dialog('close');
                    }
                }]
            });
        }
        function fnShowApplicationRulesPopupNonEditable(ctrl) {
            var strBase = $(ctrl).closest("tr[iden='Init']").attr("BaseProd");
            var strInit = $(ctrl).closest("tr[iden='Init']").attr("InitProd");

            $("#txtApplicablePer").val($(ctrl).closest("tr[iden='Init']").attr("ApplicablePer"));

            if (strBase == "") {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>No Application Rules defined for this Initiative !</div>");
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "300",
                    "height": "120",
                    "title": "Message :"
                });
            }
            else {
                var INITDescription = $(ctrl).closest("tr[iden='Init']").attr("Descr");
                $("#txtArINITDescription").val(INITDescription);

                // ---------
                var str = "";
                $("#divAppRuleBaseProdSec").html("");
                if (strBase != "") {
                    var ArrSlab = strBase.split("$$$");
                    for (i = 1; i < ArrSlab.length; i++) {
                        str = "";
                        str += "<div iden='AppRuleSlabWiseContainer' slabno='" + ArrSlab[i].split("***")[0] + "' onclick='fnActivateSlab(this, 1);'>";
                        str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1' style='margin-top: 5px;'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer; width: 88%;'>Slab " + i + "</span></div>";
                        str += "<table class='table table-bordered table-sm' style='margin-bottom: 0;'><thead><tr><th style='width: 80px; text-align: center;'>#</th><th style='text-align: center;'>Product</th><th style='width: 100px; text-align: center;'>Condition Check</th><th style='width: 100px; text-align: center;'>Minimum</th><th style='width: 100px; text-align: center;'>Maximum</th><th style='width: 100px; text-align: center;'>UOM</th></tr></thead><tbody>";

                        var ArrGrp = ArrSlab[i].split("***");
                        for (j = 1; j < ArrGrp.length; j++) {
                            str += "<tr>";
                            str += "<td>Group " + j + "</td><td>";

                            var ArrPrd = ArrGrp[j].split("*$*")[4].split("^");
                            for (k = 0; k < ArrPrd.length; k++) {
                                if (k != 0)
                                    str += ", ";
                                str += ArrPrd[k].split("|")[2];
                            }
                            str += "</td>";
                            str += "<td><select defval='" + ArrGrp[j].split("*$*")[0] + "' disabled>" + $("#ConatntMatter_hdnInitType").val() + "</select></td>";
                            str += "<td>" + ArrGrp[j].split("*$*")[1] + "</td>";
                            str += "<td>" + ArrGrp[j].split("*$*")[2] + "</td>";
                            str += "<td><select defval='" + ArrGrp[j].split("*$*")[3] + "' disabled>" + $("#ConatntMatter_hdnUOM").val() + "</select></td>";
                            str += "</tr>";
                        }
                        str += "</tbody></table>";
                        str += "</div>";
                        $("#divAppRuleBaseProdSec").append(str);
                    }
                }


                // ---------
                $("#divAppRuleBenefitSec").find("tbody").eq(0).html("");
                $("#divAppRuleBenefitSec").find("thead").find("th:last").hide();
                if (strInit != "") {
                    var ArrGrp = strInit.split("***");
                    for (j = 1; j < ArrGrp.length; j++) {
                        str = "";
                        str += "<tr slabno='" + ArrGrp[j].split("*$*")[3] + "' onclick='fnActivateSlab(this, 2);'>";
                        str += "<td>";
                        var ArrPrd = ArrGrp[j].split("*$*")[4].split("^");
                        for (k = 0; k < ArrPrd.length; k++) {
                            if (k != 0)
                                str += ", ";
                            str += ArrPrd[k].split("|")[2];
                        }
                        str += "</td>";
                        str += "<td><select defval='" + ArrGrp[j].split("*$*")[0] + "' disabled>" + $("#ConatntMatter_hdnBenefit").val() + "</select></td>";
                        str += "<td><select defval='" + ArrGrp[j].split("*$*")[1] + "' disabled>" + $("#ConatntMatter_hdnAppliedOn").val() + "</select></td>";
                        str += "<td>" + ArrGrp[j].split("*$*")[2] + "</td>";
                        str += "</tr>";
                        $("#divAppRuleBenefitSec").find("tbody").eq(0).append(str);
                    }
                }

                $("#divApplicationRulePopup").find("select").each(function () {
                    $(this).val($(this).attr("defval"));
                });
                $("#txtApplicablePer").prop("readonly", true);

                $("#divApplicationRulePopup").dialog({
                    "modal": true,
                    "width": "70%",
                    "height": "540",
                    "title": "Initiatives Application Rules",
                    open: function () {
                        //
                    },
                    close: function () {
                        $("#divApplicationRulePopup").dialog('destroy');
                    }
                });
            }
        }

        function fnAppRuleAddNewSlabbtnAction(ctrl) {
            var container = $("#divAppRuleBaseProdSec");
            var lstSlabNo = 0;
            container.find("div[iden='AppRuleSlabWiseContainer']").each(function () {
                if (parseInt($(this).attr("slabno")) > lstSlabNo) {
                    lstSlabNo = parseInt($(this).attr("slabno"));
                }
            });
            var newSlabNo = lstSlabNo + 1;

            var str = "";
            str += "<div iden='AppRuleSlabWiseContainer' slabno='" + newSlabNo + "' IsNewSlab='1' onclick='fnActivateSlab(this, 1);'>";
            str += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1' style='margin-top: 5px;'>" + $(ctrl).closest("div").html() + "</div>";
            str += "<table class='table table-bordered table-sm' style='margin-bottom: 0;'>";
            str += "<thead>" + $(ctrl).closest("div").next().find("thead").eq(0).html() + "</thead>";
            str += "<tbody>";
            var cntr = 0;
            $(ctrl).closest("div").next().find("tbody").eq(0).find("tr").each(function () {
                cntr++;
                str += "<tr grpno='" + cntr + "' IsNewGrp='1'>" + $(this).html() + "</tr>";
            });
            str += "</tbody>";
            str += "</table>";
            str += "</div>";
            $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").after(str);
            //container.append(str);

            var cntr = 0;
            $(ctrl).closest("div").next().find("tbody").eq(0).find("tr").each(function () {
                var type = $(this).find("td").eq(2).find("select").eq(0).val();
                var Max = $(this).find("td").eq(3).find("input[type='text']").eq(0).val();
                var Min = $(this).find("td").eq(4).find("input[type='text']").eq(0).val();
                var UOM = $(this).find("td").eq(5).find("select").eq(0).val();

                $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(2).find("select").eq(0).val(type);
                $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(3).find("input[type='text']").eq(0).val("0");
                switch (type.toString()) {
                    case "0":
                        $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(4).find("input[type='text']").eq(0).val("0");
                        break;
                    case "1":
                        $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(4).find("input[type='text']").eq(0).val("9999999.99");
                        break;
                    default:
                        $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(4).find("input[type='text']").eq(0).val("9999999");
                        break;
                }
                $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("tbody").eq(0).find("tr").eq(cntr).find("td").eq(5).find("select").eq(0).val(UOM);
                cntr++;
            });


            //fnAppRuleAddNewInitiativetr(newSlabNo);
            var Inittr = "";
            str = "", cntr = 1;
            var SlabNo = $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").attr("slabno");
            var PrevSlabInittr = $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr[slabno='" + SlabNo + "']");
            PrevSlabInittr.each(function () {
                str += "<tr slabno='" + newSlabNo + "' grpno='" + cntr + "' IsNewSlab='1' IsNewGrp='1' onclick='fnActivateSlab(this, 2);'>";
                str += $(this).html();
                str += "</tr>";
                cntr++;
            });
            PrevSlabInittr.eq(PrevSlabInittr.length - 1).after(str);
            var PrevSlabInittr_Inittype = PrevSlabInittr.eq(0).find("td").eq(1).find("select").eq(0).val();
            var PrevSlabInittr_AppliedOn = PrevSlabInittr.eq(0).find("td").eq(2).find("select").eq(0).val();
            $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr[slabno='" + newSlabNo + "']").each(function () {
                $(this).find("td").eq(1).find("select").eq(0).val(PrevSlabInittr_Inittype);
                $(this).find("td").eq(2).find("select").eq(0).val(PrevSlabInittr_AppliedOn);
            });

            fnAppRuleUpdateSlabNo(container);
            fnUpdateInitProdSel($(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next().find("img[iden='ProductHier']").eq(0), 2);
            //fnActivateSlab($(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").next(), 1);
        }
        function fnAppRuleRemoveSlab(ctrl) {
            var SlabNo = $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").attr("slabno");

            $(ctrl).closest("div.clsBaseProd").next().next().find("table").eq(0).find("tr[slabno='" + SlabNo + "']").remove();
            $(ctrl).closest("div[iden='AppRuleSlabWiseContainer']").remove();

            var container = $("#divAppRuleBaseProdSec");
            fnAppRuleUpdateSlabNo(container);
        }

        function fnAppRuleAddNewBasetr(ctrl) {
            var type = $(ctrl).closest("tr").find("td").eq(2).find("select").eq(0).val();
            var Max = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text']").eq(0).val();
            var Min = $(ctrl).closest("tr").find("td").eq(4).find("input[type='text']").eq(0).val();
            var UOM = $(ctrl).closest("tr").find("td").eq(5).find("select").eq(0).val();

            var tbody = $(ctrl).closest("tbody");
            var lstGrpNo = 0;
            tbody.find("tr").each(function () {
                if (parseInt($(this).attr("grpno")) > lstGrpNo) {
                    lstGrpNo = parseInt($(this).attr("grpno"));
                }
            });
            var newgrpno = lstGrpNo + 1;

            var str = "<tr grpno='" + newgrpno + "' IsNewGrp='1'>" + $(ctrl).closest("tr").html() + "</tr>";
            $(ctrl).closest("tr").after(str);
            $(ctrl).closest("tr").next().find("td").eq(2).find("select").eq(0).val(type);
            $(ctrl).closest("tr").next().find("td").eq(3).find("input[type='text']").eq(0).val("0");
            switch (type.toString()) {
                case "0":
                    $(ctrl).closest("tr").next().find("td").eq(4).find("input[type='text']").eq(0).val("0");
                    break;
                case "1":
                    $(ctrl).closest("tr").next().find("td").eq(4).find("input[type='text']").eq(0).val("9999999.99");
                    break;
                default:
                    $(ctrl).closest("tr").next().find("td").eq(4).find("input[type='text']").eq(0).val("9999999");
                    break;
            }
            $(ctrl).closest("tr").next().find("td").eq(5).find("select").eq(0).val(UOM);

            fnAppRuleUpdateGrpNo(tbody, "Group");
        }
        function fnAppRuleRemoveBasetr(ctrl) {
            var tbody = $(ctrl).closest("tbody");
            if ($(ctrl).closest("tbody").find("tr").length > 1) {
                $(ctrl).closest("tr").remove();
                fnAppRuleUpdateGrpNo(tbody, "Group");
            }
            else {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Slab must have atleast one row. </div>");
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "300",
                    "height": "120",
                    "title": "Message :"
                });
            }
        }

        function fnAppRuleAddNewInitiativetrbtnAction(ctrl) {
            var Benefittype = $(ctrl).closest("tr").find("td").eq(1).find("select").eq(0).val();
            var Applied = $(ctrl).closest("tr").find("td").eq(2).find("select").eq(0).val();
            var Val = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text']").eq(0).val();

            var slabno = $(ctrl).closest("tr").attr("slabno");
            var tbody = $(ctrl).closest("tbody");
            var lstGrpNo = 0;
            tbody.find("tr").each(function () {
                if (parseInt($(this).attr("grpno")) > lstGrpNo) {
                    lstGrpNo = parseInt($(this).attr("grpno"));
                }
            });
            var newgrpno = lstGrpNo + 1;

            var str = "<tr slabno='" + slabno + "' grpno='" + newgrpno + "' IsNewSlab='" + $(ctrl).closest("tr").attr("IsNewSlab") + "' IsNewGrp='1' onclick='fnActivateSlab(this, 2);'>" + $(ctrl).closest("tr").html() + "</tr>";
            $(ctrl).closest("tr").after(str);

            $(ctrl).closest("tr").next().find("td").eq(1).find("select").eq(0).val(Benefittype);
            $(ctrl).closest("tr").next().find("td").eq(2).find("select").eq(0).val(Applied);
            $(ctrl).closest("tr").next().find("td").eq(3).find("input[type='text']").eq(0).val("0");

            //fnActivateSlab($(ctrl).closest("tr").next(), 2);
        }
        //------
        function fnAppRulePopuptoTbl(ctrl) {
            var msg = "";
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();

            //---------------
            var strBase = "";
            var slabArr = $("#divAppRuleBaseProdSec").find("div[iden='AppRuleSlabWiseContainer']");
            for (i = 0; i < slabArr.length; i++) {
                strBase += "<div iden='AppRuleSlabWiseContainer' slabno='" + slabArr.eq(i).attr("slabno") + "' IsNewSlab='" + slabArr.eq(i).attr("IsNewSlab") + "'>";
                strBase += "<div class='clsAppRuleSubHeader' flgExpandCollapse='1'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer;'>Slab " + (i + 1).toString() + " :</span><i class='fa fa-minus-square' onclick='fnAppRuleRemoveSlabMini(this);'></i><i class='fa fa-plus-square' onclick='fnAppRuleAddNewSlabMini(this);'></i></div>";
                strBase += "<table class='table table-bordered clsAppRule'>";
                //strBase += "<thead><tr><th>#</th><th style='width: 80%; min-width: 80%;'>Applicable Product</th><th style='width: 50px; min-width: 50px;'>Action</th></tr></thead>";
                strBase += "<tbody>";

                var trArr = slabArr.eq(i).find("table").eq(0).find("tbody").eq(0).find("tr");
                for (j = 0; j < trArr.length; j++) {
                    strBase += "<tr grpno='" + trArr.eq(j).attr("grpno") + "' IsNewGrp='" + trArr.eq(j).attr("IsNewGrp") + "'>";
                    strBase += "<td>Grp " + (j + 1).toString() + "</td>";
                    strBase += "<td><div style='position: relative; height: 20px; box-sizing: border-box;'>";
                    strBase += "<div iden='content' style='width: 100%; padding-right: 30px;'>" + trArr.eq(j).find("td").eq(1).find("div[iden='content']").eq(0).html() + "</div>";
                    strBase += "<div style='position: absolute; right:5px; top:-3px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' onclick='fnAppRuleShowCopyBucketPopup(this, 1);' style='height: 12px;'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='" + trArr.eq(j).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("copybuckettd") + "' prodlvl='" + trArr.eq(j).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodlvl") + "' prodhier='" + trArr.eq(j).find("td").eq(1).find("img[iden='ProductHier']").eq(0).attr("prodhier") + "' Inittype='" + trArr.eq(j).find("td").eq(2).find("select").eq(0).val() + "' InitMax='" + trArr.eq(j).find("td").eq(3).find("input[type='text']").eq(0).val() + "' InitMin='" + trArr.eq(j).find("td").eq(4).find("input[type='text']").eq(0).val() + "' InitApplied='" + trArr.eq(j).find("td").eq(5).find("select").eq(0).val() + "' onclick='fnAppRuleShowProdHierPopup(this, 1, 1);' style='height: 12px;' /></div>";
                    strBase += "</div></td>";
                    strBase += "<td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewBasetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleRemoveBasetrMini(this);'></i></td>";
                    strBase += "</tr>";

                    if (msg == "") {
                        if (trArr.eq(j).find("td").eq(3).find("input[type='text']").eq(0).val() == "") {
                            msg = "Minimum value for Slab " + (i + 1).toString() + ", Group " + (j + 1).toString() + " can't be blank !";
                        }
                        else if (trArr.eq(j).find("td").eq(4).find("input[type='text']").eq(0).val() == "") {
                            msg = "Maximum value for Slab " + (i + 1).toString() + ", Group " + (j + 1).toString() + " can't be blank !";
                        }
                    }
                }

                strBase += "</tbody>";
                strBase += "</table>";
                strBase += "</div>";
            }

            //---------------
            var strbenefit = "";
            var trArr = $("#divAppRuleBenefitSec").find("tbody").eq(0).find("tr");
            for (i = 0; i < trArr.length; i++) {
                strbenefit += "<tr slabno='" + trArr.eq(i).attr("slabno") + "' grpno='" + trArr.eq(i).attr("grpno") + "' IsNewSlab='" + trArr.eq(i).attr("IsNewSlab") + "' IsNewGrp='" + trArr.eq(i).attr("IsNewGrp") + "'>";
                strbenefit += "<td>";
                strbenefit += "<div style='position: relative; box-sizing: border-box;'>";
                strbenefit += "<div iden='content' style='width: 100%; padding-right: 30px;'>" + trArr.eq(i).find("td").eq(0).find("div[iden='content']").eq(0).html() + "</div>";
                strbenefit += "<div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' Benefittype='" + trArr.eq(i).find("td").eq(1).find("select").eq(0).val() + "' BenefitAppliedOn='" + trArr.eq(i).find("td").eq(2).find("select").eq(0).val() + "' BenefitValue='" + trArr.eq(i).find("td").eq(3).find("input[type='text']").eq(0).val() + "' copybuckettd='" + trArr.eq(i).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("copybuckettd") + "' prodlvl='" + trArr.eq(i).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodlvl") + "' prodhier='" + trArr.eq(i).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier") + "' onclick='fnAppRuleShowProdHierPopup(this, 2, 1);' style='height: 12px;' /></div>";
                strbenefit += "</div>";
                strbenefit += "</td>";
                strbenefit += "<td style='width:35px; min-width:35px; padding:.3rem 0;'><i class='fa fa-plus' onclick='fnAppRuleAddNewInitiativetrMini(this);'></i><i class='fa fa-minus' onclick='fnAppRuleReomveInitiativetr(this, 1);'></i></td>";
                strbenefit += "</tr>";

                if (msg == "") {
                    if (trArr.eq(i).find("td").eq(3).find("input[type='text']").eq(0).val() == "") {
                        msg = "Initiative Product Value for Slab " + trArr.eq(i).attr("slabno") + " can't be blank !";
                    }
                }
            }

            if (msg == "") {
                $(ctrl).closest("td[iden='Init']").find("div.clsBaseProd").eq(0).find("div.clsAppRuleSlabContainer").eq(0).html(strBase);
                $(ctrl).closest("td[iden='Init']").find("div.clsInitProd").eq(0).find("div.clsAppRuleSlabContainer").eq(0).find("tbody").eq(0).html(strbenefit);

                $(ctrl).closest("tr[iden='Init']").attr("ApplicableNewPer", $("#txtApplicablePer").val());

                fnAdjustRowHeight(rowIndex);
                $("#divApplicationRulePopup").dialog('close');
            }
            else {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>" + msg + "</div>");
                $("#divConfirm").dialog({
                    "modal": true,
                    "width": "300",
                    "height": "120",
                    "title": "Message :"
                });
            }
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
                fnGetSelHierTbl();
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

                var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
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

                var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
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
    <script type="text/javascript">
        function fnAddNewSubBrandForm() {
            $("#txtBrandFormforNewNode").attr("sel", "");
            $("#txtBrandFormforNewNode").val("");
            $("#txtNewSBFCode").val("");
            $("#txtNewSBFName").val("");

            fnShowSBFPopup();
        }
        function fnShowSBFPopup() {
            $("#divNewSBFPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "460",
                "title": "Add New SubBrandForm :",
                buttons: [{
                    text: 'Add New SubBrandForm',
                    class: 'btn-primary',
                    click: function () {
                        fnSaveNewNode(2, 0);
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divNewSBFPopup").dialog('close');
                    }
                }],
                close: function () {
                    $("#divNewSBFPopup").dialog('destroy');
                }
            });
        }

        function fnAddNewBrandForm(cntr) {
            $("#txtBrandforNewNode").attr("sel", "");
            $("#txtBrandforNewNode").val("");
            $("#txtNewBFCode").val("");
            $("#txtNewBFName").val("");

            fnShowBFPopup(cntr);
        }
        function fnShowBFPopup(cntr) {
            $("#divNewBFPopup").dialog({
                "modal": true,
                "width": "44%",
                "height": "460",
                "title": "Add New BrandForm :",
                buttons: [{
                    text: 'Add New BrandForm',
                    class: 'btn-primary',
                    click: function () {
                        fnSaveNewNode(1, cntr);
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divNewBFPopup").dialog('close');
                    }
                }],
                close: function () {
                    $("#divNewBFPopup").dialog('destroy');
                }
            });
        }

        function fnShowPopupforNewNode(ctrl, cntr) {
            $(ctrl).next("div.clsPopup").eq(0).show();
            if (cntr == 1) {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrandlstforNewNode").val());
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrandFormlstforNewNode").val());
            }

            if ($(ctrl).val() != "")
                fnPopupTypeSearchforNewNode(ctrl);
        }
        function fnPopupTypeSearchforNewNode(ctrl) {
            var filter = $(ctrl).val().toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "none");
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnSelectProdforNewNode(ctrl) {
            var nid = $(ctrl).attr("nid");
            var ntype = $(ctrl).attr("ntype");
            var str = $(ctrl).find("td:last").html();

            $(ctrl).closest("div.clsPopup").prev().val(str);
            $(ctrl).closest("div.clsPopup").prev().attr("sel", nid + "^" + ntype);
            fnHidePopupforNewNode();
        }
        function fnRemoveSelectionforNewNode(ctrl) {
            $(ctrl).attr("sel", "");
        }
        function fnHidePopupforNewNode() {
            $("div.clsPopup").hide();
        }

        function fnSaveNewNode(flg, cntr) {
            var ParentId = "";
            var ParentType = "";
            var Code = "";
            var Descr = "";

            if (flg == 1) {         //BF
                if ($("#txtNewBFName").val() == "") {
                    AutoHideAlertMsg("Please enter the BrandForm name !");
                    return false;
                }
                else if ($("#txtBrandforNewNode").attr("sel") == "") {
                    AutoHideAlertMsg("Please select the Brand !");
                    return false;
                }

                ParentId = $("#txtBrandforNewNode").attr("sel").split("^")[0];
                ParentType = $("#txtBrandforNewNode").attr("sel").split("^")[1];
                Code = $("#txtNewBFCode").val();
                Descr = $("#txtNewBFName").val();
            }
            else {                   //SBF
                if ($("#txtNewSBFName").val() == "") {
                    AutoHideAlertMsg("Please enter the SubBrandForm name !");
                    return false;
                }
                else if ($("#txtBrandFormforNewNode").attr("sel") == "") {
                    AutoHideAlertMsg("Please select the BrandForm !");
                    return false;
                }

                ParentId = $("#txtBrandFormforNewNode").attr("sel").split("^")[0];
                ParentType = $("#txtBrandFormforNewNode").attr("sel").split("^")[1];
                Code = $("#txtNewSBFCode").val();
                Descr = $("#txtNewSBFName").val();
            }

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            $("#dvloader").show();
            PageMethods.fnSaveNewNode(ParentId, ParentType, Code, Descr, LoginID, UserID, RoleID, UserNodeID, UserNodeType, fnSaveNewNode_pass, fnfailed, flg + "|" + cntr);
        }
        function fnSaveNewNode_pass(res, flgCntr) {
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1].split("^")[0] == "-1") {
                    $("#dvloader").hide();
                    AutoHideAlertMsg("Name already exist !");
                }
                else {
                    $("#dvloader").hide();
                    if (flgCntr.split("|")[0] == "1") {
                        AutoHideAlertMsg("BrandForm added successfully !");
                        $("#ConatntMatter_hdnBrandFormlstforNewNode").val(res.split("|^|")[3]);
                        $("#divNewBFPopup").dialog('close');

                        if (flgCntr.split("|")[1] == "1") {
                            $("#txtBrandFormforNewNode").next().find("div.clsPopupBody").html(res.split("|^|")[3]);
                            $("#txtBrandFormforNewNode").val(res.split("|^|")[2].toString());
                            $("#txtBrandFormforNewNode").attr("sel", res.split("|^|")[1]);
                        }
                    }
                    else {
                        AutoHideAlertMsg("SubBrandForm added successfully !");
                        $("#divNewSBFPopup").dialog('close');
                    }

                    if (flgCntr.split("|")[1] == "0") {
                        var SelectedHier = "";
                        $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                        });
                        if (SelectedHier != "") {
                            SelectedHier = SelectedHier.substring(1);
                            $("#ConatntMatter_hdnSelectedHier").val(SelectedHier + "^" + res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        else {
                            $("#ConatntMatter_hdnSelectedHier").val(res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr[class='Active']").eq(0).find("td").eq(0));
                    }
                }
            }
            else {
                fnfailed();
            }
        }
    </script>
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

        #divCopyBucketPopupTbl table tr.Active,
        #divHierPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        .fixed-top {
            z-index: 99 !important;
        }

        #divHierSelectionTbl td,
        #divHierPopupTbl td {
            font-size: 0.7rem !important;
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

            .btn-primary:not(:disabled):not(.disabled).active,
            .btn-primary:not(:disabled):not(.disabled):active,
            .show > .btn-primary.drop,
            .btn-primary:active,
            .btn-primary:hover {
                background: #D81F10 !important;
                border-color: #D81F10;
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

        table.clsReport tr td {
            height: 50px;
            min-height: 50px;
        }

        table.clsReport tr th {
            text-align: center;
            vertical-align: middle;
        }

        table.clsReport tr td:nth-child(1),
        table.clsReport tr td:nth-child(2) {
            width: 30px;
            min-width: 30px;
        }

        table.clsReport tr td:nth-child(4) {
            width: 120px;
            min-width: 120px;
            text-align: left;
        }

        table.clsReport tr td:nth-child(5) {
            width: 170px;
            min-width: 170px;
            max-width: 170px;
        }

        table.clsReport tr td:nth-child(4),
        table.clsReport tr td:nth-child(5) {
            word-break: break-all;
        }

        table.clsReport tr td:nth-child(11),
        table.clsReport tr td:nth-child(12),
        table.clsReport tr td:nth-child(13),
        table.clsReport tr td:nth-child(14) {
            width: 110px;
            min-width: 110px;
        }

        table.clsReport tr td:nth-child(15),
        table.clsReport tr td:nth-child(16) {
            width: 72px;
            min-width: 72px;
        }

        table.clsReport tr td:nth-child(17),
        table.clsReport tr td:nth-child(18) {
            width: 140px;
            min-width: 140px;
        }

        #divReport td.clstdAction {
            text-align: center;
            width: 74px;
            min-width: 74px;
        }

            #divReport td.clstdAction img {
                margin: 0 3px;
                height: 14px;
                cursor: pointer;
            }

        table.clsReport tr td:nth-child(2),
        table.clsReport tr td:nth-child(8),
        table.clsReport tr td:nth-child(9),
        table.clsReport tr td:nth-child(10),
        table.clsReport tr td:nth-child(11),
        table.clsReport tr td:nth-child(12),
        table.clsReport tr td:nth-child(13),
        table.clsReport tr td:nth-child(14),
        table.clsReport tr td:nth-child(15),
        table.clsReport tr td:nth-child(16) {
            text-align: center;
        }

            table.clsReport tr td:nth-child(13) input[type='checkbox'] {
                height: 11px;
                margin-right: 10px;
                margin-bottom: 6px;
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

        table.clsReport td.clstdExpandedContent {
            border: none;
            width: 126px;
            height: auto;
            min-width: 100px;
            min-height: auto;
            white-space: normal;
            padding: 1px 0 0 3px;
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
            width: 17%;
            text-align: center;
        }

            table.clsInitiativeLst th:nth-child(1) {
                width: 4%;
            }

            table.clsInitiativeLst th:nth-child(2),
            table.clsInitiativeLst th:nth-child(3) {
                width: 10%;
            }
            
            table.clsInitiativeLst th:nth-child(2),
            table.clsInitiativeLst th:nth-child(3) {
                width: 10%;
            }
            
            table.clsInitiativeLst th:nth-child(6),
            table.clsInitiativeLst th:nth-child(7) {
                width: 24%;
            }

        table.clsInitiativeLst tr td:nth-child(1) {
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
        Initiative Master
        <span style="font-size: .7rem; margin-left: 20px; color: #666; cursor: pointer;" flgvisiblehierfilter="0" onclick="fnShowHierFilter(this);">Hierarchy Filter</span>
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 8%; padding: 6px;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonth" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 12%; padding: 6px 10px;">
                    <div class="fsw-title">Stage</div>
                    <div class="d-block">
                        <select id="ddlStatus" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divHierFilterBlock" style="width: 12%; padding: 6px;">
                    <div class="row">
                        <div class="col-4" id="MSMPFilterBlock" style="display: none; padding-right: 0;">
                            <div class="fsw-title">ms&amp;P</div>
                            <div class="d-block">
                                <select id="ddlMSMPAlies" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="col-5" id="HierFilterBlock" style="display: none; padding-right: 0;">
                            <div class="fsw-title">Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Product</a>
                                <a id="txtLocationHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="2" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Location Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Location</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem; margin-right: 2%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Reset</a>
                                <a id="btnShowRpt" class="btn btn-primary btn-sm" href="#" onclick="fnGetReport(0);" title="Show Filtered Initiative(s)" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Show</a>
                            </div>
                        </div>
                        <div class="col-12" id="BookmarkFilterBlock">
                            <div class="fsw-title">Bookmark</div>
                            <select id="ddlBookmark" class="form-control form-control-sm" style="display: inline-block; width: 66%;" onchange="fnBookmarkFilter();">
                                <option value="0">All</option>
                                <option value="1">Bookmark</option>
                                <option value="2">Not Bookmark</option>
                            </select>
                            <img id="btnExcel" src="../../Images/excel.png" onclick="return fnDownload();return false;" title="Download Report" style="margin-left: 10px; cursor: pointer;" />
                        </div>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 55%; padding: 6px 8px;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Type atleast 3 characters .." />
                    </div>
                </div>
                <div class="fsw_inputBox" id="divAddNewFilterBlock" style="width: 13%; padding: 6px 2px 0 6px;">
                    <div class="fsw-title">Initiative</div>
                    <div class="d-block">
                        <a href="##" class="btn btn-primary btn-sm" id="btnAddNewINIT" onclick="fnAddNew();" title="Add New Initiative"><i class="fa fa-plus-square"></i>&nbsp; Add</a>
                        <a href="##" class="btn btn-primary btn-sm" id="btnCopyINIT" onclick="fnCopyMultiInitiativePopup();" title="Import initiative from previous month to current month" style="margin-left: 1%;"><i class="fa fa-clone"></i>&nbsp; Import</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active">
            <div><a id="btnInitExpandedCollapseMode" flgcollapse="1" href="#" style="color: #80BDFF;" onclick="fnInitExpandedCollapseMode();">Collapsed Mode</a></div>
            <div id="divReport" class="row">
                <div class="col-4" id="divLeftReportHeader" style="padding-right: 0; overflow: hidden;"></div>
                <div class="col-8" id="divRightReportHeader" style="overflow-x: hidden; overflow-y: scroll; padding-left: 0;"></div>
                <div class="col-4" id="divLeftReport" style="padding-right: 0; overflow-y: hidden; overflow-x: scroll;"></div>
                <div class="col-8" id="divRightReport" style="overflow-y: scroll; overflow-x: scroll; padding-left: 0;"></div>
            </div>
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
    <div id="divApplicationRulePopup" style="display: none;">
        <div class="fsw-title" style="margin-bottom: 0;">Description :</div>
        <textarea id="txtArINITDescription" style='width: 100%; box-sizing: border-box; overflow-y: auto; margin: 5px 0 10px 0;' rows='2' readonly="readonly"></textarea>

        <div class="fsw-title" style="margin-bottom: 0;">Applicable (%) :</div>
        <textarea id="txtApplicablePer" style='width: 100%; box-sizing: border-box; overflow-y: auto; margin: 5px 0 10px 0;' rows='2' readonly="readonly"></textarea>

        <div class="clsBaseProd">
            <div class="clsAppRuleHeader" style="font-size: 0.9rem;">Base Products :</div>
            <div id="divAppRuleBaseProdSec" class="clsAppRuleSlabContainer" style="padding: 0 6px 6px;">
            </div>
        </div>

        <hr style="border-top: 3px solid #70baff;">

        <div class="clsInitProd">
            <div class="clsAppRuleHeader" style="font-size: 0.9rem;">Initiative Products :</div>
            <div id="divAppRuleBenefitSec" class="clsAppRuleSlabContainer" style="border-radius: 3px 3px 0 0; padding: 6px;">
                <table class='table table-bordered table-sm' style="margin-bottom: 0;">
                    <thead>
                        <tr>
                            <th style="text-align: center; vertical-align: middle;">Product</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">Initiative Type</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">Applied On</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">Value/Percentage</th>
                            <th style="width: 80px; text-align: center; vertical-align: middle;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divLegends" style="width: 67%; margin-left: 5px; padding: 5px 8px; background: #fff; border: 1px solid #bbb; border-radius: 4px; display: inline-block; float: left;"></div>
        <div id="divButtons" style="width: 32%; display: inline-block; text-align: right;"></div>
    </div>

    <div id="divNewSBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>SubBrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtNewSBFCode" />
            </div>
            <div class="form-group col-md">
                <label>SubBrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtNewSBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm</label>
                <div class="position-relative">
                    <input id="txtBrandFormforNewNode" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 2)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec" style="padding: 0;"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-right">
            <a href="#" class="btn btn-primary btn-sm" onclick="fnAddNewBrandForm(1);">Add BrandForm</a>
        </div>
    </div>
    <div id="divNewBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtNewBFCode" />
            </div>
            <div class="form-group col-md">
                <label>BrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtNewBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>Brand</label>
                <div class="position-relative">
                    <input id="txtBrandforNewNode" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 1)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec p-0"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="dvInitiativeList" style="display: none;">
        <div class="row no-gutters">
            <%--<div class="col-12 fsw">
                <div class="fsw_inputBox" style="width: 20%; display: inline-block;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonthPopup" class="form-control form-control-sm" onchange="fnCopyMultiInitiative();"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 78%; display: inline-block;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtImportfilter" type="text" class="form-control form-control-sm" onkeyup="fnImportTypefilter();" placeholder="Type atleast 3 characters .." />
                    </div>
                </div>
            </div>--%>
            <div class="col-6 fsw" style="margin-bottom: 4px;">
                <div class="fsw_inputBox" style="width: 100%; display: inline-block; min-height: 46px;">
                    <div class="fsw-title" style="display: inline;">Month</div>
                    <select id="ddlMonthPopup" class="form-control form-control-sm ml-2 mr-4" style="width: 100px; display: inline;"></select>
                    <a id="btnImportProductHierFilter" class="btn btn-primary btn-sm mr-1" href="#" buckettype="1" prodlvl="40" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem;">Product</a>
                    <a id="btnImportLocationHierFilter" class="btn btn-primary btn-sm mr-1" href="#" buckettype="2" prodlvl="120" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Location Filter" style="font-size: 0.8rem;">Location</a>
                    <a id="btnImportChannelHierFilter" class="btn btn-primary btn-sm mr-4" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem;">Channel</a>
                    <a id="btnImportFB" class="btn btn-primary btn-sm" href="#" onclick="fnCopyMultiInitiative();" title="Get Initiative(s) for Import" style="font-size: 0.8rem;">Get Initiative(s) List</a>
                </div>
            </div>
            <div class="col-6 fsw" style="margin-bottom: 4px;">
                <div class="fsw_inputBox" style="width: 100%; display: inline-block; min-height: 46px;">
                    <div class="d-block">
                        <input id="txtImportfilter" type="text" class="form-control form-control-sm" onkeyup="fnImportTypefilter();" placeholder="Type atleast 3 characters to Search .." />
                    </div>
                </div>
            </div>
        </div>
        <div id="dvInitiativeListBody" style="max-height: 424px; overflow-y: auto;"></div>
    </div>
    <div id="dvRejectComment" style="display: none;">
        <div id="dvPrevComment" style="max-height: 300px; overflow-y: auto;"></div>
        <div style="width: 100%; border-bottom: 1px solid #ddd; font-weight: 700; padding-top: 10px;">Your Comments :</div>
        <textarea rows="6" style="width: 100%; border: none;"></textarea>
    </div>
    <div id="divAddNewBucketPopup" style="display: none;">
        <div class="fsw-title" style="margin-bottom: 0;">Name :</div>
        <input id="txtBucketName" style='width: 100%; box-sizing: border-box; margin: 5px 0 10px 0; border: 1px solid #ccc;' />

        <div class="fsw-title" style="margin-bottom: 0;">Description :</div>
        <textarea id="txtBucketDescription" style='width: 100%; box-sizing: border-box; overflow-y: auto; margin: 5px 0 10px 0;' rows='4'></textarea>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="divConfirm" style="display: none;"></div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />

    <asp:HiddenField ID="hdnInitID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMonths" runat="server" />
    <asp:HiddenField ID="hdnProcessGrp" runat="server" />
    <asp:HiddenField ID="hdnDisburshmentType" runat="server" />
    <asp:HiddenField ID="hdnIncentiveType" runat="server" />
    <asp:HiddenField ID="hdnMultiplicationType" runat="server" />
    <asp:HiddenField ID="hdnInitType" runat="server" />
    <asp:HiddenField ID="hdnUOM" runat="server" />
    <asp:HiddenField ID="hdnBenefit" runat="server" />
    <asp:HiddenField ID="hdnAppliedOn" runat="server" />
    <asp:HiddenField ID="hdnBucketID" runat="server" />
    <asp:HiddenField ID="hdnBucketName" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    <asp:HiddenField ID="hdnIsNewAdditionAllowed" runat="server" />
    <asp:HiddenField ID="hdnmonthyearexcel" runat="server" />
    <asp:HiddenField ID="hdnmonthyearexceltext" runat="server" />
    <asp:HiddenField ID="hdnjsonarr" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />

    <asp:HiddenField ID="hdnBrandlstforNewNode" runat="server" />
    <asp:HiddenField ID="hdnBrandFormlstforNewNode" runat="server" />

    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
</asp:Content>
