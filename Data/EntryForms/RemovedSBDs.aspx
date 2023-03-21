<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="RemovedSBDs.aspx.cs" Inherits="RemovedSBDs" ValidateRequest="false" %>

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
            $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
            $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));

            $(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            $("#ddlStatus").html($("#ConatntMatter_hdnProcessGrp").val());

            $("#ddlQuarter").html($("#ConatntMatter_hdnQuarter").val().split("|^|")[0]);
            $("#ddlQuarter").val($("#ConatntMatter_hdnQuarter").val().split("|^|")[1]);
            //$("#ddlQuarter").find("option[Qtrtype='2']").remove();

            $("#ddlQuarterPopup").html($("#ConatntMatter_hdnQuarter").val().split("|^|")[0]);
            $("#ddlQuarterPopup").find("option[Qtrtype='0']").remove();
            $("#ddlQuarterPopup").find("option[Qtrtype='3']").remove();

            $("#ConatntMatter_hdnQuarter").val($("#ddlQuarter").val());

            $("#ddlMSMPAlies").html($("#ConatntMatter_hdnMSMPAlies").val());
            $("#ddlMSMPAlies").multiselect({
                noneSelectedText: "--Select--"
            }).multiselectfilter();
            $("#ddlMSMPAlies").next().css({
                "height": "calc(1.5em + .5rem + 2px)",
                "font-size": "0.76rem",
                "font-weight": "400",
                "width": "200px",
                "padding-right": "0",
                "border-radius": ".2rem",
                "border-color": "#ced4da",
                "padding": "0.25rem 0 0 0.5rem"
            });
            $("#ddlMSMPAlies").next().find("span.ui-icon").eq(0).css({
                "border": "none",
                "margin": ".2rem 0",
                "margin-bottom": "0",
                "background-color": "transparent"
            });

            fnShowHierFilter();
            fnGetReport(1);
        });

        function fnShowHierFilter() {
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            
            if (RoleID == "1" || RoleID == "2" || RoleID == "4") {
                $("#MSMPFilterBlock").show();
                $("#HierFilterBlock").attr("class", "col-7");

                $("#divHierFilterBlock").css("width", "47%");
                $("#divTypeSearchFilterBlock").css("width", "23%");
            }
            else {
                $("#MSMPFilterBlock").hide();
                $("#HierFilterBlock").show();
                $("#HierFilterBlock").attr("class", "col-12");

                $("#divHierFilterBlock").css("width", "28%");
                $("#divTypeSearchFilterBlock").css("width", "42%");
            }
        }
        function fntypefilter() {
            var flgtr = 0, rowindex = 0;
            var filter = $("#txtfilter").val().toUpperCase().split(",");

            if ($("#txtfilter").val().toUpperCase().length > 2) {
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "none");
                $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td").eq(11).html().toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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

                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "table-row");
                $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
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
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var Qtr = $("#ddlQuarter").val().split("|")[2];
            var Yr = $("#ddlQuarter").val().split("|")[3];
            var ProcessGroup = $("#ddlStatus").val();

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

            if (Qtr == $("#btnClusterFilter").attr("mth") && Yr == $("#btnClusterFilter").attr("yr")) {
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
            }
            else {
                LocValues.push({ "col1": "0", "col2": "0", "col3": "2" });
                $("#btnClusterFilter").attr("selectedstr", "");
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
                    $("#btnCopyINIT").attr("onclick", "fnImportPrevQtrSBDPopup();");
                }
                else {
                    $("#btnAddNewINIT").addClass("btn-disabled");
                    $("#btnAddNewINIT").removeAttr("onclick");

                    $("#btnCopyINIT").addClass("btn-disabled");
                    $("#btnCopyINIT").removeAttr("onclick");
                }

                $("#divLegends").html(res.split("|^|")[4]);

                var leftfixed = "";
                trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']");
                leftfixed += "<table id='tblleftfixed' class='table table-striped table-bordered table-sm clsReport' style='width:99.6%;'>";
                leftfixed += "<thead>";
                leftfixed += "<tr>";
                for (var i = 0; i < 2; i++) {
                    leftfixed += "<th>" + $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(i).html() + "</th>";
                }
                leftfixed += "</tr>";
                leftfixed += "</thead>";
                leftfixed += "<tbody>";
                for (h = 0; h < trArr.length; h++) {
                    leftfixed += "<tr SBD='" + trArr.eq(h).attr("SBD") + "' SBDName='" + trArr.eq(h).attr("SBDName") + "' flgEdit='0'>";
                    for (var i = 0; i < 2; i++) {
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
                            leftfixed += "<td>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
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

                $("#tblReport").css("margin-left", "-198px");

                fnCreateHeader();
                if ($("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(0).attr("Init") == "0") {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(0).remove();
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(0).remove();
                }

                if ($("#divLeftReport").find("tbody").eq(0).find("tr").length == 0) {
                    var ht = $(window).height();
                    $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
                    $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
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
            for (var i = 0; i < 2; i++) {
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
            fixedHeader += "<table id='tblRightfixedHeader' class='table table-striped table-bordered table-sm clsReport' style='margin-bottom: 0;'>";
            fixedHeader += "<thead>";
            fixedHeader += $("#tblReport").find("thead").eq(0).html();
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divRightReportHeader").html(fixedHeader);
            $("#tblRightfixedHeader").css("margin-left", "-198px");

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
            for (i = 0; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("min-width", "auto");
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("width", "auto");
            }

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblRightfixedHeader").css("min-width", wid);

            for (i = 0; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
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
            tr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(index);

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
            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD'][flgEdit='0']").each(function () {
                var rowIndex = $(this).index();

                var SBDName = $(this).attr("SBDName");
                var loc = ExtendContentBody($(this).attr("strloc").split("~")[0]);
                var channel = ExtendContentBody($(this).attr("strchannel").split("~")[0]);
                var strsbd = ExtendContentBody($(this).attr("strsbd").split("~")[0]);

                if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "1") {
                    SBDName = SBDName.length > 20 ? "<span title='" + SBDName + "' class='clsInform'>" + SBDName.substring(0, 18) + "..</span>" : SBDName;
                    loc = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>";
                    strsbd = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (strsbd.length > 70 ? "<span title='" + strsbd + "' class='clsInform'>" + strsbd.substring(0, 68) + "..</span>" : strsbd) + "</div>";
                }
                else {
                    loc = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + ExtendContentBody(loc) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + ExtendContentBody(channel) + "</div>";
                    strsbd = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + ExtendContentBody(strsbd) + "</div>";
                }


                $(this).find("td[iden='SBD']").eq(3).html(SBDName);
                //$("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(3).html(SBDName);

                if ($("#tblReport").attr("IsChannelExpand") == "1")
                    $(this).find("td[iden='SBD']").eq(4).html(channel);

                if ($("#tblReport").attr("IsLocExpand") == "1")
                    $(this).find("td[iden='SBD']").eq(5).html(loc);

                if ($("#tblReport").attr("IsSBDExpand") == "1")
                    $(this).find("td[iden='SBD']").eq(6).html(strsbd);

                fnAdjustRowHeight(rowIndex);
            });
            fnAdjustColumnWidth();

            Tooltip(".clsInform");
        }

        function fnDownload() {
            var Arr = [];
            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                if ($(this).attr("SBD") != "0" && $(this).css("display") != "none") {
                    Arr.push({ "SBD": $(this).attr("SBD") });
                }
            });
            if (Arr.length == 0) {
                Arr.push({ "SBDID": 0 });
            }
            $("#ConatntMatter_hdnjsonarr").val(JSON.stringify(Arr));
            $("#ConatntMatter_btnDownload").click();
            return false;
        }
        function fnChangeLogDownload() {
            var Arr = [];
            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                if ($(this).attr("SBD") != "0" && $(this).css("display") != "none") {
                    Arr.push({ "SBD": $(this).attr("SBD") });
                }
            });
            if (Arr.length == 0) {
                Arr.push({ "SBDID": 0 });
            }
            $("#ConatntMatter_hdnjsonarr").val(JSON.stringify(Arr));
            $("#ConatntMatter_btnChangeLogDownload").click();
            return false;
        }
    </script>
    <script type="text/javascript">
        function fnBookmarkFilter() {
            var Bookmark = $("#ddlBookmark").val();

            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").css("display", "table-row");
            switch (Bookmark) {
                case "0":
                    //
                    break;
                case "1":
                    var rowindex = 0;
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                        if ($(this).attr("flgBookmark") == 0) {
                            $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).css("display", "none");
                            $(this).css("display", "none");
                        }
                        rowindex++;
                    });
                    break;
                case "2":
                    var rowindex = 0;
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
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
            var ArrSBD = [];

            if ($(ctrl).attr("flgBookmark") == "0")
                flgBookmark = "1";
            else
                flgBookmark = "0";

            $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                ArrSBD.push({
                    "col1": $(this).attr("SBD")
                });
            });

            $("#dvloader").show();
            PageMethods.fnManageBookMark(flgBookmark, LoginID, UserID, ArrSBD, fnManageBookMarkAll_pass, fnfailed, flgBookmark);
        }
        function fnManageBookMarkAll_pass(res, flgBookmark) {
            if (res.split("|^|")[0] == "0") {
                var rowindex = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").each(function () {
                    $(this).attr("flgBookmark", flgBookmark);
                    $(this).find("td[iden='SBD']").eq(1).find("img").eq(0).attr("flgBookmark", flgBookmark);
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).find("td").eq(1).find("img").eq(0).attr("flgBookmark", flgBookmark);

                    if (flgBookmark == "1") {
                        $(this).find("td[iden='SBD']").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark.png");
                        $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowindex).find("td").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark.png");
                    }
                    else {
                        $(this).find("td[iden='SBD']").eq(1).find("img").eq(0).attr("src", "../../Images/bookmark-inactive.png");
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
            var ArrSBD = [];

            if ($(ctrl).attr("flgBookmark") == "0")
                flgBookmark = "1";
            else
                flgBookmark = "0";

            ArrSBD.push({
                "col1": $(ctrl).closest("tr").attr("SBD")   //$("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).attr("SBD")
            });

            $("#dvloader").show();
            PageMethods.fnManageBookMark(flgBookmark, LoginID, UserID, ArrSBD, fnManageBookMark_pass, fnfailed, rowIndex + "|" + flgBookmark);
        }
        function fnManageBookMark_pass(res, str) {
            if (res.split("|^|")[0] == "0") {
                var rowIndex = str.split("|")[0];
                var flgBookmark = str.split("|")[1];

                if (flgBookmark == "1") {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).attr("flgBookmark", "1");
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).find("td[iden='SBD']").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");

                }
                else {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).attr("flgBookmark", "0");
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).find("td[iden='SBD']").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='Active Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");
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
            var ArrSBD = [];

            var SBDName = "";
            if (flgAction == "100") {
                fnSaveAllOpen(0);
            }
            else if (flgAction == "99") {
                fnDeleteSelected();
            }
            else if (flgAction == "101") {
                fnRestoreSelected();
            }
            else if (flgAction == "5") {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                        if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                            var rowIndex = $(this).closest("tr").index();

                            ArrSBD.push({
                                "col1": $(this).closest("tr").attr("sbd")
                            });
                        }
                    }
                });

                if (ArrSBD.length > 0) {
                    PageMethods.fnGetAllRejectComments(RoleID, LoginID, UserID, ArrSBD, fnGetAllRejectComments_pass, fnfailed, flgAction);
                }
                else
                    AutoHideAlertMsg("Please select atleast one SBD for Action !");
            }
            else {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                        if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                            var rowIndex = $(this).closest("tr").index();

                            ArrSBD.push({
                                "col1": $(this).closest("tr").attr("sbd"),
                                "col2": flgAction,
                                "col3": ""
                            });

                        }
                    }
                });

                if (ArrSBD.length == 0) {
                    AutoHideAlertMsg("Please select atleast one SBD for Action !");
                }
                else {
                    if (flgAction == "4") {
                        $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Approved <span style='color:#0000ff; font-weight: 700;'>" + ArrSBD.length + "</span> SBD(s).<br/>Do you want to continue ?</div>");
                    }
                    else {
                        $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Submit <span style='color:#0000ff; font-weight: 700;'>" + ArrSBD.length + "</span> SBD(s) for further Approval.<br/>Do you want to continue ?</div>");
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
                                PageMethods.fnSaveFinalAction(RoleID, LoginID, UserID, ArrSBD, fnSaveFinalAction_pass, fnfailed, flgAction);
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
                strtbl += "<tr><th>#</th><th>SBD Name</th><th>Comments</th></tr>";
                strtbl += "</thead>";
                strtbl += "<tbody>";

                var jsonTbl = $.parseJSON(res.split("|^|")[1]).Table;
                for (var i = 0; i < jsonTbl.length; i++) {
                    strtbl += "<tr SBD='" + jsonTbl[i].SBDID + "'>";
                    strtbl += "<td>" + (i + 1).toString() + "</td>";
                    strtbl += "<td>" + jsonTbl[i].SBDName + "</td>";
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

                            var SBDName = "", ArrSBD = [];
                            $("#divConfirm").find("tbody").eq(0).find("tr").each(function () {
                                ArrSBD.push({
                                    "col1": $(this).attr("SBD"),
                                    "col2": flgAction,
                                    "col3": $(this).find("td").eq(2).find("textarea").eq(0).val()
                                });

                                if ($(this).find("td").eq(2).find("textarea").eq(0).val() == "" && SBDName == "") {
                                    SBDName = $(this).find("td").eq(1).html();
                                }
                            });

                            if (SBDName == "") {
                                $("#divConfirm").dialog('close');

                                $("#dvloader").show();
                                PageMethods.fnSaveFinalAction(RoleID, LoginID, UserID, ArrSBD, fnSaveFinalAction_pass, fnfailed, flgAction);
                            }
                            else {
                                AutoHideAlertMsg("Please enter your Comments for " + SBDName);
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
                    case "4":
                        AutoHideAlertMsg("Norms has been successfully submitted for further processing !");
                        break;
                    case "5":
                        AutoHideAlertMsg("Change Request submitted successfully !");
                        break;
                    default:
                        AutoHideAlertMsg("SBD(s) submitted successfully !");
                        break;
                }
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }

        function fnSBDImportTypeSearch(ctrl) {
            $("#tblClusterChannelMappingforImport").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#tblClusterChannelMappingforImport").find("tbody").eq(0).find("tr").attr("flgClusterVisible", "1");

            var flgValidate = 0;
            $("#tblClusterChannelMappingforImportHeader").find("thead").find("input[type='text']").each(function () {
                if ($(this).val().trim().length > 1) {
                    var ind = $(this).closest("th").index();
                    var searchtxt = $(this).val().toUpperCase().trim();
                    $("#tblClusterChannelMappingforImport").find("tbody").eq(0).find("tr[flgChannelVisible='1']").each(function () {
                        flgValidate = 0;
                        
                        $(this).find("td").eq(ind).find("span").each(function () {
                            if ($(this).html().toUpperCase().indexOf(searchtxt) > -1) {
                                flgValidate = 1;
                            }
                        });

                        if (flgValidate == 0) {
                            $(this).css("display", "none");
                            $(this).attr("flgClusterVisible", "0");
                        }
                    });
                }
            });
        }
        function fnNormSelectAll(ctrl) {
            if ($(ctrl).is(":checked")) {
                $(ctrl).closest("table").next().find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $(ctrl).closest("table").next().find("input[type='checkbox']").removeAttr("checked");
            }
        }
        function fnIndividualNormSelect(ctrl) {
            if ($(ctrl).is(":checked")) {
                $(ctrl).closest("tr").find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $(ctrl).closest("tr").find("input[type='checkbox']").removeAttr("checked");
            }
        }

        function fnExpandCollapseClusterChannelTbl(ctrl) {
            if ($(ctrl).attr("flgExpand") == "1") {
                $(ctrl).next().slideUp(1000);
                $(ctrl).attr("flgExpand", "0");
                $(ctrl).find("i").eq(0).addClass("fa-plus-square").removeClass("fa-minus-square");
            }
            else {
                $(ctrl).next().slideDown(1000);
                $(ctrl).attr("flgExpand", "1");
                $(ctrl).find("i").eq(0).addClass("fa-minus-square").removeClass("fa-plus-square");
            }
        }
    </script>
    <script type="text/javascript">
        function fnEdit(ctrl) {
            var lefttr = $(ctrl).closest("tr");
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex);

            var SBDName = rttr.attr("SBDName");
            var fromdate = rttr.attr("fromdate");
            var todate = rttr.attr("todate");
            var Frequency = rttr.attr("Frequency");

            var locArr = rttr.attr("strloc").split("~");
            var channelArr = rttr.attr("strchannel").split("~");
            channellvl = Maxlvl(channelArr[1]);
            var BaseSBFArr = rttr.attr("strSBD").split("~");

            var strbtn = "";
            var flgRejectComment = rttr.attr("flgRejectComment");
            if (flgRejectComment == "1")
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 0);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/><img src='../../Images/comments.png' title='Comments' onclick='fnGetRejectComment(this);'/>";
            else
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 0);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/>";

            var tr = rttr;
            tr.attr("flgEdit", "1");
            var lefttr = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex);
            lefttr.attr("flgEdit", "1");

            lefttr.find("td").eq(0).html("");
            lefttr.find("td").eq(1).html("");
            lefttr.find("td").eq(2).html(strbtn);
            tr.find("td[iden='SBD']").eq(0).html("");
            tr.find("td[iden='SBD']").eq(1).html("");
            tr.find("td[iden='SBD']").eq(2).html(strbtn);

            tr.find("td[iden='SBD']").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='3'>" + SBDName + "</textarea>");
            //lefttr.find("td").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='3'>" + SBDName + "</textarea>");

            tr.find("td[iden='SBD']").eq(4).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(channelArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='3' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='3' CopyBucketTD='" + channelArr[2] + "' prodlvl='" + channellvl + "' prodhier='" + channelArr[1] + "' onclick='fnShowProdHierPopup(this, 1);'/></div></div>");

            tr.find("td[iden='SBD']").eq(5).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(locArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' iden='ProductHier' buckettype='4' CopyBucketTD='" + locArr[1] + "' onclick='fnShowCopyBucketPopup(this);' /></div></div>");

            tr.find("td[iden='SBD']").eq(6).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(BaseSBFArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' iden='ProductHier'  buckettype='6' BucketId='" + BaseSBFArr[1] + "' BrandId='" + BaseSBFArr[3] + "' onclick='fnShowBaseSBFBucketPopup(this);' /></div></div>");

            //tr.find("td[iden='SBD']").eq(6).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(BaseSBFArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define Base SBF' iden='BaseSBF' SBFHiier='" + BaseSBFArr[1] + "' onclick='fnShowSBFHierPopup(this);'/></div></div>");

            tr.find("td[iden='SBD']").eq(7).html("<input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + fromdate + "' placeholder='From Date'/><br/><a herf='#' onclick='fnSetToFromDate(this);' class='btn btn-primary btn-small'>Default Month</a><br/><input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + todate + "' placeholder='To Date'/>");
            tr.find("td[iden='SBD']").eq(8).html("<select>" + $("#ConatntMatter_hdnFrequency").val() + "</select>");
            tr.find("td[iden='SBD']").eq(8).find("select").eq(0).val(Frequency);

            //lefttr.find("textarea").eq(0).css("height", "auto");
            //lefttr.find("textarea").eq(0).css("height", lefttr.find("textarea")[0].scrollHeight + "px");

            fnAdjustRowHeight(rowIndex);

            //lefttr.find("textarea").on('input', function () {
            //    this.style.height = 'auto';
            //    this.style.height = (this.scrollHeight) + 'px';
            //    fnAdjustRowHeight($(this).closest("tr").index());
            //});

            tr.find(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            fnAdjustColumnWidth();

            $("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
        }
        function fnShowChannelClusterforCopy(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex);

            $("#divChannelClusterforCopy").dialog({
                "modal": true,
                "width": "60%",
                "height": "560",
                "title": "Channel - Cluster for Copy :",
                open: function () {
                    var locArr = rttr.attr("strloc").split("~");
                    var channelArr = rttr.attr("strchannel").split("~");

                    var str = "<table class='table table-striped table-bordered table-sm'>";
                    for (var i = 0; i < locArr[1].split("|").length; i++) {
                        str += "<tr strId='" + locArr[1].split("|")[i] + "'><td><input type='checkbox' checked/></td><td>" + locArr[0].split(",")[i].trim() + "</td></tr>";
                    }
                    str += "</table>";
                    $("#divClusterTblforCopy").html(str);

                    str = "<table class='table table-striped table-bordered table-sm'>";
                    for (var i = 0; i < channelArr[1].split("^").length; i++) {
                        str += "<tr strId='" + channelArr[1].split("^")[i] + "'><td><input type='checkbox' checked/></td><td>" + channelArr[0].split(",")[i].trim() + "</td></tr>";
                    }
                    str += "</table>";
                    $("#divChannelTblforCopy").html(str);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var strId = "", descr = "";
                        var strCluster = "", strChannel = "";

                        $("#divClusterTblforCopy").find("input[type='checkbox']:checked").each(function () {
                            strId += "|" + $(this).closest("tr").attr("strId");
                            descr += ", " + $(this).closest("tr").find("td").eq(1).html();
                        });
                        if (strId != "") {
                            strCluster = descr.substring(2) + "~" + strId.substring(1) + "~0";
                        }
                        else {
                            strCluster = "~0~0";
                        }

                        strId = "", descr = "";
                        $("#divChannelTblforCopy").find("input[type='checkbox']:checked").each(function () {
                            strId += "^" + $(this).closest("tr").attr("strId");
                            descr += ", " + $(this).closest("tr").find("td").eq(1).html();
                        });
                        if (strId != "") {
                            strChannel = descr.substring(2) + "~" + strId.substring(1) + "~0";
                        }
                        else {
                            strChannel = "~~0";
                        }

                        fnCopy(ctrl, strCluster, strChannel);

                        var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                        fnAdjustRowHeight(rowIndex);
                        $("#divChannelClusterforCopy").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        $("#divChannelClusterforCopy").find("input[type='checkbox']").removeAttr("checked");
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divChannelClusterforCopy").dialog('close');
                    }
                }]
            });
        }
        function fnCopy(ctrl, strCluster, strChannel) {
            var lefttr = $(ctrl).closest("tr");
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex);

            var defdate = $("#ddlQuarter").val();  //GetNxtMonthToFromDate();
            var fromdate = defdate.split("|")[0];
            var todate = defdate.split("|")[1];
            var SBDName = rttr.attr("SBDName");
            var Frequency = rttr.attr("Frequency");

            var locArr = strCluster.split("~"); //rttr.attr("strloc").split("~");
            var channelArr = strChannel.split("~"); //rttr.attr("strchannel").split("~");
            channellvl = Maxlvl(channelArr[1]);
            var BaseSBFArr = rttr.attr("strSBD").split("~");

            var strbtn = "";
            var flgRejectComment = rttr.attr("flgRejectComment");
            if (flgRejectComment == "1")
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 0);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/><img src='../../Images/comments.png' title='Comments' onclick='fnGetRejectComment(this);'/>";
            else
                strbtn = "<img src='../../Images/save.png' title='Save' onclick='fnSave(this, 0);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/>";

            var tr = "", str = "";
            str = "<tr iden='SBD' SBD='0' flgEdit='1' style='display: table-row;'>";
            str += rttr.html();
            str += "</tr>";
            rttr.before(str);

            str = "<tr iden='SBD' SBD='0' flgEdit='1'>";
            str += lefttr.html();
            str += "</tr>";
            lefttr.before(str);

            tr = rttr.prev();
            shortDescr = "";
            lefttr = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex);

            lefttr.find("td").eq(0).html("");
            lefttr.find("td").eq(1).html("");
            lefttr.find("td").eq(2).html(strbtn);
            tr.find("td[iden='SBD']").eq(0).html("");
            tr.find("td[iden='SBD']").eq(1).html("");
            tr.find("td[iden='SBD']").eq(2).html(strbtn);

            tr.find("td[iden='SBD']").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='3'>" + SBDName + "</textarea>");
            //lefttr.find("td").eq(3).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='3'>" + SBDName + "</textarea>");

            tr.find("td[iden='SBD']").eq(4).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(channelArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' buckettype='3' onclick='fnShowCopyBucketPopup(this);'/><br/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' buckettype='3' CopyBucketTD='" + channelArr[2] + "' prodlvl='" + channellvl + "' prodhier='" + channelArr[1] + "' onclick='fnShowProdHierPopup(this, 1);'/></div></div>");

            tr.find("td[iden='SBD']").eq(5).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(locArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' iden='ProductHier' buckettype='4' CopyBucketTD='" + locArr[1] + "' onclick='fnShowCopyBucketPopup(this);' /></div></div>");

            tr.find("td[iden='SBD']").eq(6).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(BaseSBFArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' iden='ProductHier' buckettype='6' BucketId='" + BaseSBFArr[1] + "' BrandId='" + BaseSBFArr[3] + "' onclick='fnShowBaseSBFBucketPopup(this);' /></div></div>");

            //tr.find("td[iden='SBD']").eq(6).html("<div style='position: relative; width: 202px; min-width: 202px; box-sizing: border-box;'><div iden='content' style='font-size:0.6rem; width: 100%; padding-right: 30px;'>" + ExtendContentBody(BaseSBFArr[0]) + "</div><div style='position: absolute; right:5px; top:0px;'><img src='../../Images/edit.png' title='Define Base SBF' iden='BaseSBF' SBFHiier='" + BaseSBFArr[1] + "' onclick='fnShowSBFHierPopup(this);'/></div></div>");

            tr.find("td[iden='SBD']").eq(7).html("<input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + fromdate + "' placeholder='From Date'/><br/><a herf='#' onclick='fnSetToFromDate(this);' class='btn btn-primary btn-small'>Default Month</a><br/><input type='text' class='clsDate' style='box-sizing: border-box; width:96%;' value='" + todate + "' placeholder='To Date'/>");
            tr.find("td[iden='SBD']").eq(8).html("<select>" + $("#ConatntMatter_hdnFrequency").val() + "</select>");
            tr.find("td[iden='SBD']").eq(8).find("select").eq(0).val(Frequency);

            tr.find("td[iden='SBD']").eq(9).html("");
            tr.find("td[iden='SBD']").eq(10).html("");
            tr.find("td[iden='SBD']").eq(11).html("");

            //lefttr.find("textarea").eq(0).css("height", "auto");
            //lefttr.find("textarea").eq(0).css("height", lefttr.find("textarea")[0].scrollHeight + "px");

            fnAdjustRowHeight(rowIndex);

            //lefttr.find("textarea").on('input', function () {
            //    this.style.height = 'auto';
            //    this.style.height = (this.scrollHeight) + 'px';
            //    fnAdjustRowHeight($(this).closest("tr").index());
            //});

            tr.find(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            fnAdjustColumnWidth();

            $("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
        }
        function fnCancel(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();
            var SBD = $(ctrl).closest("tr").attr("SBD");
            if (SBD == "0") {
                $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).remove();
                $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).remove();
            }
            else {
                var lefttr = $(ctrl).closest("tr");
                var tr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex);

                var SBDName = tr.attr("SBDName");
                var fromdate = tr.attr("fromdate");
                var todate = tr.attr("todate");
                var Frequency = tr.attr("Frequency");

                var locArr = tr.attr("strloc").split("~");
                var loclvl = Maxlvl(locArr[1]);
                var loc = locArr[0];
                var channelArr = tr.attr("strchannel").split("~");
                channellvl = Maxlvl(channelArr[1]);
                var channel = channelArr[0];
                var BaseSBFArr = tr.attr("strSBD").split("~");
                var baseSBF = BaseSBFArr[0];

                var flgRejectComment = tr.attr("flgRejectComment");
                var flgBookmark = tr.attr("flgBookmark");
                var flgCheckBox = tr.attr("flgCheckBox");

                var strbtns = "";
                if ($("#ConatntMatter_hdnIsNewAdditionAllowed").val() == "1") {
                    strbtns += "<img src='../../Images/copy.png' title='Copy SBD' onclick='fnShowChannelClusterforCopy(this);'/>";
                }
                strbtns += "<img src='../../Images/edit.png' title='Edit SBD' onclick='fnEdit(this);'/>";
                strbtns += "<img src='../../Images/delete.png' title='Delete SBD' onclick='fnDelete(this);'/>";
                if (flgRejectComment == "1") {
                    strbtns += "<img src='../../Images/comments.png' title='Comments' onclick='fnGetRejectComment(this);'/>";
                }

                if ($("#btnInitExpandedCollapseMode").attr("flgCollapse") == "1") {
                    SBDName = SBDName.length > 20 ? "<span title='" + SBDName + "' class='clsInform'>" + SBDName.substring(0, 18) + "..</span>" : SBDName;
                    loc = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (loc.length > 70 ? "<span title='" + loc + "' class='clsInform'>" + loc.substring(0, 68) + "..</span>" : loc) + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (channel.length > 70 ? "<span title='" + channel + "' class='clsInform'>" + channel.substring(0, 68) + "..</span>" : channel) + "</div>";
                    baseSBF = "<div style='width: 202px; min-width: 202px; font-size:0.7rem;'>" + (baseSBF.length > 70 ? "<span title='" + baseSBF + "' class='clsInform'>" + baseSBF.substring(0, 68) + "..</span>" : baseSBF) + "</div>";
                }
                else {
                    loc = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + loc + "</div>";
                    channel = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + channel + "</div>";
                    baseSBF = "<div style='width: 202px; min-width: 202px; font-size: 0.6rem;'>" + baseSBF + "</div>";
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
                //lefttr.find("td").eq(3).html(SBDName);

                if (flgCheckBox == "1")
                    tr.find("td[iden='SBD']").eq(0).html("<input iden='chkInit' type='checkbox' onclick='fnUnchkInitIndividual(this);'/>");
                else
                    tr.find("td[iden='SBD']").eq(0).html("");

                if (flgBookmark == "1")
                    tr.find("td[iden='SBD']").eq(1).html("<img src='../../Images/bookmark.png' title='Active Bookmark' flgBookmark='1' onclick='fnManageBookMark(this);'/>");
                else
                    tr.find("td[iden='SBD']").eq(1).html("<img src='../../Images/bookmark-inactive.png' title='InActive Bookmark' flgBookmark='0' onclick='fnManageBookMark(this);'/>");
                tr.find("td[iden='SBD']").eq(2).html(strbtns);
                tr.find("td[iden='SBD']").eq(3).html(SBDName);

                if ($("#tblReport").attr("IsChannelExpand") == "0")
                    tr.find("td[iden='SBD']").eq(4).html("");
                else
                    tr.find("td[iden='SBD']").eq(4).html(channel);

                if ($("#tblReport").attr("IsLocExpand") == "0")
                    tr.find("td[iden='SBD']").eq(5).html("");
                else
                    tr.find("td[iden='SBD']").eq(5).html(loc);

                if ($("#tblReport").attr("IsSBDExpand") == "0")
                    tr.find("td[iden='SBD']").eq(6).html("");
                else
                    tr.find("td[iden='SBD']").eq(6).html(baseSBF);

                tr.find("td[iden='SBD']").eq(7).html(fromdate + "<br/>to " + todate);
                tr.find("td[iden='SBD']").eq(8).html(Frequency);

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
                var ctrl = $("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").eq(cntr - 1).find("td.clstdAction").eq(0).find("img[title='Save']").eq(0);
                fnSaveSBD(ctrl, 0, cntr);
            }
            else {
                AutoHideAlertMsg("No SBD details found for updation !");
            }
        }
        function fnSave(ctrl, flgDuplicate) {
            SaveCntr = 1;
            fnSaveSBD(ctrl, flgDuplicate, 0);
        }

        function fnSaveSBD(ctrl, flgDuplicate, cntr) {
            var lefttr = $(ctrl).closest("tr");
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex);

            var SBDID = lefttr.attr("SBD");
            var SBDName = "";                                           //lefttr.find("td").eq(3).find("textarea").eq(0).val();
            var strChannel = rttr.find("td[iden='SBD']").eq(4).find("img[iden='ProductHier']").eq(0).attr("ProdHier");
            var strLocation = rttr.find("td[iden='SBD']").eq(5).find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
            var strBrand = rttr.find("td[iden='SBD']").eq(6).find("img[iden='ProductHier']").eq(0).attr("BrandId");
            var FromDate = rttr.find("td[iden='SBD']").eq(7).find("input[type='text']").eq(0).val();
            var EndDate = rttr.find("td[iden='SBD']").eq(7).find("input[type='text']").eq(1).val();
            var Frequency = rttr.find("td[iden='SBD']").eq(8).find("select").eq(0).val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var QtrNo = $("#ddlQuarter").val().split("|")[2];
            var QtrYear = $("#ddlQuarter").val().split("|")[3];
            var MOQ = [];
            var Buckets = [];
            var BucketValues = [];

            var copyChannelBucketID = rttr.find("td[iden='SBD']").eq(4).find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
            var copyLocationBucketID = rttr.find("td[iden='SBD']").eq(5).find("img[iden='ProductHier']").eq(0).attr("CopyBucketTD");
            var BaseSBFBucket = rttr.find("td[iden='SBD']").eq(6).find("img[iden='ProductHier']").eq(0).attr("BucketId");

            if (strChannel == "") {
                AutoHideAlertMsg("Please select the Channel(s) !");
                return false;
            }
            else if (copyLocationBucketID == "0") {
                AutoHideAlertMsg("Please select the Cluster(s) !");
                return false;
            }
            else if (BaseSBFBucket == "") {
                AutoHideAlertMsg("Please select the SBF(s) !");
                return false;
            }
            else if (FromDate == "") {
                AutoHideAlertMsg("Please select the From Date !");
                return false;
            }
            else if (EndDate == "") {
                AutoHideAlertMsg("Please select the To Date !");
                return false;
            }
            else if (Frequency == "0") {
                AutoHideAlertMsg("Please select the Frequency !");
                return false;
            }
            else if (parseInt(FromDate.split("-")[2] + AddZero(MonthArr.indexOf(FromDate.split("-")[1])) + FromDate.split("-")[0]) > parseInt(EndDate.split("-")[2] + AddZero(MonthArr.indexOf(EndDate.split("-")[1])) + EndDate.split("-")[0])) {
                AutoHideAlertMsg("To-Date must be Greater than From-Date !");
                return false;
            }
            else {
                for (var i = 0; i < copyLocationBucketID.split("|").length; i++) {
                    Buckets.push({
                        "col1": copyLocationBucketID.split("|")[i],
                        "col2": "4"
                    });
                }
                for (var i = 0; i < copyChannelBucketID.split("|").length; i++) {
                    Buckets.push({
                        "col1": copyChannelBucketID.split("|")[i],
                        "col2": "3"
                    });
                }
                for (var i = 0; i < BaseSBFBucket.split("|").length; i++) {
                    MOQ.push({
                        "col1": BaseSBFBucket.split("|")[i].split("^")[0],
                        "col2": BaseSBFBucket.split("|")[i].split("^")[1]
                    });

                    Buckets.push({
                        "col1": BaseSBFBucket.split("|")[i].split("^")[0],
                        "col2": "6"
                    });
                }

                for (var i = 0; i < strChannel.split("^").length; i++) {
                    BucketValues.push({
                        "col1": strChannel.split("^")[i].split("|")[0],
                        "col2": strChannel.split("^")[i].split("|")[1],
                        "col3": "3"
                    });
                }

                $("#dvloader").show();
                PageMethods.fnSave(SBDID, SBDName, FromDate, EndDate, strChannel, strLocation, UserID, LoginID, RoleID, QtrNo, QtrYear, Buckets, BucketValues, MOQ, flgDuplicate, Frequency, strBrand, cntr, fnSave_pass, fnfailed, ctrl);
            }
        }
        function fnSave_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                if (SaveCntr == (parseInt(res.split("|^|")[1]) + 1)) {
                    AutoHideAlertMsg("SBD details saved/updated successfully !");
                    fnGetReport(0);
                }
                else {
                    fnSaveAllOpen(parseInt(res.split("|^|")[1]) + 1);
                }
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("SBD already exist !");
                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "3") {
                $("#dvloader").hide();
                fnExistingCombinationAtSBD(res, ctrl);
            }
            else {
                fnfailed();
            }
        }
        function fnExistingCombinationAtSBD(res, ctrl) {
            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: justify;'>" + res.split("|^|")[2] + "</div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "40%",
                "maxheight": "400",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        fnSaveSBD(ctrl, 1, parseInt(res.split("|^|")[1]));
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


        function fnRestoreSelected() {
            var ArrSBD = [];
            $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                        ArrSBD.push({
                            "col1": $(this).closest("tr").attr("sbd")
                        });
                    }
                }
            });

            if (ArrSBD.length == 0) {
                AutoHideAlertMsg("Please select atleast one SBD for Action !");
            }
            else {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Restore <span style='color:#0000ff; font-weight: 700;'>" + ArrSBD.length + "</span> SBD(s).<br/>Do you want to continue ?</div>");

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

                            var RoleID = $("#ConatntMatter_hdnRoleID").val();   // 2: Admin
                            var LoginID = $("#ConatntMatter_hdnLoginID").val();
                            var UserID = $("#ConatntMatter_hdnUserID").val();

                            $("#dvloader").show();
                            PageMethods.fnRestore(RoleID, LoginID, UserID, ArrSBD, fnRestore_pass, fnfailed);
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
        function fnRestore(ctrl) {
            var ArrSBD = [];
            ArrSBD.push({
                "col1": $(ctrl).closest("tr").attr("SBD")
            });

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to Restore this SBD ?</div>");

            $("#divConfirm").dialog({
                "modal": true,
                "width": "260",
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

                        var RoleID = $("#ConatntMatter_hdnRoleID").val();   // 2: Admin
                        var LoginID = $("#ConatntMatter_hdnLoginID").val();
                        var UserID = $("#ConatntMatter_hdnUserID").val();

                        $("#dvloader").show();
                        PageMethods.fnRestore(RoleID, LoginID, UserID, ArrSBD, fnRestore_pass, fnfailed);
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
        function fnRestore_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("SBD(s) restored successfully !");
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
        }


        function fnGetRejectComment(ctrl) {
            var SBDID = $(ctrl).closest("tr").attr("sbd");
            var rowIndex = $(ctrl).closest("tr").index();
            var flgDBEdit = $("#tblReport").find("tbody").eq(0).find("tr[iden='SBD']").eq(rowIndex).attr("flgDBEdit");

            $("#ConatntMatter_hdnSBDID").val(SBDID);
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();

            $("#dvloader").show();
            PageMethods.fnGetRejectComments(SBDID, RoleID, UserID, fnGetRejectComments_pass, fnfailed, flgDBEdit);
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

                                    var INITID = $("#ConatntMatter_hdnSBDID").val();
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

        function GetNxtMonthToFromDate() {
            var d = new Date();
            var NxtMnth = new Date(d.getFullYear(), d.getMonth() + 2, 0);
            return "01-" + MonthArr[NxtMnth.getMonth()] + "-" + NxtMnth.getFullYear() + "|" + NxtMnth.getDate() + "-" + MonthArr[NxtMnth.getMonth()] + "-" + NxtMnth.getFullYear();
        }
        function fnSetToFromDate(ctrl) {
            $(ctrl).closest("td[iden='SBD']").find("input").eq(0).val($("#ddlQuarter").val().split("|")[0]);
            $(ctrl).closest("td[iden='SBD']").find("input").eq(1).val($("#ddlQuarter").val().split("|")[1]);
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
                strtable += "<th style='width:20%;'>Category</th>";
                strtable += "<th style='width:20%;'>Brand</th>";
                strtable += "<th style='width:25%;'>BrandForm</th>";
                strtable += "<th style='width:35%;'>SubBrandForm</th>";
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
                        strtable += "<th style='width:20%;'>Category</th>";
                        strtable += "<th style='width:20%;'>Brand</th>";
                        strtable += "<th style='width:25%;'>BrandForm</th>";
                        strtable += "<th style='width:35%;'>SubBrandForm</th>";
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
            if ($(ctrl).closest("tr").attr("flg") == "1") {
                $(ctrl).closest("tr").attr("flg", "0");
                $(ctrl).closest("tr").removeClass("Active");
                $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                if ($("#ConatntMatter_hdnBucketType").val() == "6") {
                    $(ctrl).closest("tr").find("input[type='text']").eq(0).val($(ctrl).closest("tr").attr("MOQ"));
                    $(ctrl).closest("tr").find("input[type='text']").eq(0).prop("disabled", true);
                }
            }
            else {
                $(ctrl).closest("tr").attr("flg", "1");
                $(ctrl).closest("tr").addClass("Active");
                $(ctrl).closest("tr").find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                if ($("#ConatntMatter_hdnBucketType").val() == "6") {
                    $(ctrl).closest("tr").find("input[type='text']").eq(0).removeAttr("disabled");
                }
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

            $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                $(this).eq(0).attr("flg", "0");
                $(this).eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                $(this).eq(0).removeClass("Active");
            });

            $("#divCopyBucketSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
        }
    </script>
    <script type="text/javascript">
        function fnResetBaseSBFPopupAction() {
            $("#divProxySBFTbl").html($("#ConatntMatter_hdnSBFHierforBasePopup").val());
            $("#divProxySBFTbl").find("table").eq(0).addClass("clsBaseSBFDisable");

            var brand = $("#divProxySBFTbl").attr("brand");
            if (brand != "") {
                var trbrandwise = "";
                for (var i = 0; i < brand.split("^").length; i++) {
                    $("#divProxySBFTbl").find("tbody").eq(0).find("tr[brand='" + brand.split("^")[i] + "']").each(function () {
                        trbrandwise += $(this)[0].outerHTML;
                    });
                }
                $("#divProxySBFTbl").find("tbody").eq(0).html(trbrandwise);
            }
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

        function fnSBFHierPopup(ctrl) {
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
                    $("#divBaseProxySBFPopup").next().prepend("<i class='fa fa-file-excel-o' onclick='fnSBDDownload();' style='font-size: 2.5em; color: #EF3A2C; vertical-align: top; margin-top: 12px; margin-left: 2%;'></i><fieldset style='display: inline-block; margin-left: 26px; padding: 0px 20px  6px; border: 1px solid #ddd;'><Legend style='width: auto; padding: 0 5px; font-size: .9rem; font-weight: 500;   margin-bottom: 0;'>Legend</Legend><div style='color: #000; font-weight: 400;'><i class='fa fa-square' style='margin-right: 10px; color: #0000C4;'></i>Base SBF <i class='fa fa-square' style='margin:0 10px 0 30px; color: #C0C0C0;'></i>Combi SBF</div></fieldset>");
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
                            $(ctrl).attr("sbfhiier", strID.substring(1) + "||||" + $("#divProxySBFTbl").attr("brand"));
                            $(ctrl).closest("div").prev().html(strDescr.substring(2));

                            var rowIndex = $(ctrl).closest("tr[iden='SBD']").index();
                            fnAdjustRowHeight(rowIndex);
                        }
                        else {
                            $(ctrl).attr("sbfhiier", "||||" + $("#divProxySBFTbl").attr("brand"));
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
        function fnShowBaseSBFBucketPopup(ctrl) {
            if ($(ctrl).attr("BucketId") == "0") {
                var LoginID = $("#ConatntMatter_hdnLoginID").val();
                var RoleID = $("#ConatntMatter_hdnRoleID").val();
                var UserID = $("#ConatntMatter_hdnUserID").val();

                if (RoleID == "4") {
                    $("#dvloader").show();
                    PageMethods.fnGetBrandlst(LoginID, RoleID, UserID, fnGetBrandlst_pass, fnfailed, ctrl);
                }
                else {
                    fnBaseProxySBFBucketPopup(ctrl, $(ctrl).attr("BrandId"));
                }
            }
            else {
                fnBaseProxySBFBucketPopup(ctrl, $(ctrl).attr("BrandId"));
            }
        }
        function fnGetBrandlst_pass(res, ctrl) {
            $("#dvloader").hide();
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1] != "") {
                    $("#divConfirm").html(res.split("|^|")[1]);

                    $("#divConfirm").dialog({
                        "modal": true,
                        "width": "50%",
                        "title": "Select Brand :",
                        close: function () {
                            $("#divConfirm").dialog('destroy');
                        },
                        buttons: [{
                            text: 'Submit',
                            class: 'btn-primary',
                            click: function () {
                                if ($("#divConfirm").find("input[type='radio']:checked").length > 0) {
                                    fnBaseProxySBFBucketPopup(ctrl, $("#divConfirm").find("input[type='radio']:checked").eq(0).closest("tr").attr("brand"));
                                    $(ctrl).attr("BrandId", $("#divConfirm").find("input[type='radio']:checked").eq(0).closest("tr").attr("brand"));
                                    $("#divConfirm").dialog('close');
                                }
                                else {
                                    AutoHideAlertMsg("Please select the MS&P - Brand Mapping !");
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
                    AutoHideAlertMsg("No MS&P - Brand Mapping Found !");
                }
            }
            else {
                fnfailed();
            }
        }
        function fnBaseProxySBFBucketPopup(ctrl, strBrand) {
            $("#divCopyBucketPopupTbl").html("<div style='margin-top: 25%; text-align: center;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif' /></div>");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("buckettype"));

            var title = "Base Proxy SBF Combi-bucket(s) :";
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
                    strtable += "<th style='width:20%;'>Category</th>";
                    strtable += "<th style='width:20%;'>Brand</th>";
                    strtable += "<th style='width:25%;'>BrandForm</th>";
                    strtable += "<th style='width:35%;'>SubBrandForm</th>";
                    strtable += "</tr>";
                    strtable += "</thead>";
                    strtable += "<tbody>";
                    strtable += "</tbody>";
                    strtable += "</table>";
                    $("#divCopyBucketSelectionTbl").html(strtable);
                    $("#PopupCopyBucketlbl").html("Base SBF");

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();
                    var Qtr = $("#ddlQuarter").val().split("|")[2];
                    var Yr = $("#ddlQuarter").val().split("|")[3];

                    PageMethods.GetBaseSBFBucket(LoginID, RoleID, UserID, $("#ConatntMatter_hdnBucketType").val(), Qtr, Yr, strBrand, GetBucketbasedonType_pass, GetBucketbasedonType_failed, $(ctrl).attr("BucketId"));
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var BucketId = "", descr = "";
                        $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            BucketId += "|" + $(this).attr("bucketid") + "^" + $(this).find("input[type='text']").eq(0).val();
                            descr += ", " + $(this).find("td").eq(1).html();
                        });
                        if (BucketId != "") {
                            BucketId = BucketId.substring(1);
                            descr = descr.substring(2);
                        }
                        else {
                            BucketId = "0";
                        }

                        $(ctrl).closest("div").prev().html(descr);
                        $(ctrl).attr("BucketId", BucketId);

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
        function fnShowClusterPopup(ctrl, IsMain) {
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
                    if (!IsMain) {
                        Qtr = $("#ddlQuarterPopup").val().split("|")[2];
                        Yr = $("#ddlQuarterPopup").val().split("|")[3];
                    }

                    $(ctrl).attr("mth", Qtr);
                    $(ctrl).attr("yr", Yr);
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

                    var tr = "";
                    if ($("#ConatntMatter_hdnBucketType").val() == "6") {
                        tr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[bucketid='" + CopyBucketTD.split("|")[i].split("^")[0] + "']");
                        tr.find("input[type='text']").eq(0).removeAttr("disabled");
                        tr.find("input[type='text']").eq(0).val(CopyBucketTD.split("|")[i].split("^")[1]);
                    }
                    else {
                        tr = $("#divCopyBucketPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[bucketid='" + CopyBucketTD.split("|")[i] + "']");
                    }
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
        #divRightReport {
            background-color: #fffaf5;
        }

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
            text-align: center;
            vertical-align: middle;
            box-sizing: border-box;
            white-space: nowrap;
        }

        table.clsReport tr td {
            width: 100px;
            min-width: 100px;
        }

            table.clsReport tr td:nth-child(1) {
                width: 35px;
                min-width: 35px;
            }
            table.clsReport tr td:nth-child(2) {
                width: 60px;
                min-width: 60px;
            }

            table.clsReport tr td:nth-child(12) {
                width: 120px;
                min-width: 120px;
                text-align: left;
            }

        #divReport td.clstdAction {
            text-align: center;
            width: 70px;
            min-width: 70px;
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

        #divChannelTblforCopy table tr td:nth-child(1),
        #divClusterTblforCopy table tr td:nth-child(1) {
            width: 30px;
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
    <style type="text/css">
        #tblClusterChannelMappingforImportHeader th {
            text-align: center;
            vertical-align: middle;
        }

            #tblClusterChannelMappingforImportHeader th:nth-child(1),
            #tblClusterChannelMappingforImport tr td:nth-child(1) {
                width: 140px;
            }

            #tblClusterChannelMappingforImportHeader th:nth-child(2),
            #tblClusterChannelMappingforImport tr td:nth-child(2) {
                width: 200px;
            }

        #tblClusterChannelMappingforImport td {
            padding-left: 10px;
        }

        #tblClusterChannelMappingforImport tr td:nth-child(1) {
            color: #0080FF;
            font-weight: 600;
            font-size: 0.9rem;
            padding-left: 5px;
        }

        #tblClusterChannelMappingforImport input[type=checkbox],
        #tblClusterChannelMappingforImportHeader input[type=checkbox] {
            margin-right: 10px;
            display: inline-block;
        }

        #tblClusterChannelMappingforImport input[type=text],
        #tblClusterChannelMappingforImportHeader input[type=text] {
            width: 90%;
            font-size: 0.76rem;
            border-radius: 4px;
            padding: 0 0 0 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="font-size: .92rem">
        <i class="fa fa-arrow-circle-down" style="margin-right: 10px;" onclick="fnCollapsefilter(this);"></i>
        Deleted SBD(s)
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 12%; padding: 6px 10px;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlQuarter" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 18%; padding: 6px 10px;">
                    <div class="fsw-title">Stage</div>
                    <div class="d-block">
                        <select id="ddlStatus" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divHierFilterBlock" style="width: 28%;">
                    <div class="row">
                        <div class="col-5" id="MSMPFilterBlock" style="display: none;">
                            <div class="fsw-title">ms&amp;P</div>
                            <div class="d-block">
                                <select id="ddlMSMPAlies" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="col-12" id="HierFilterBlock">
                            <div class="fsw-title">Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="40" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem;">Product</a>
                                <a id="btnClusterFilter" class="btn btn-primary btn-sm" href="#" onclick="fnShowClusterPopup(this, true);" title="Cluster Filter" mth="0" yr="0" selectedstr="" style="font-size: 0.8rem;">Cluster</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem; margin-right: 4%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters" style="font-size: 0.8rem;">Reset</a>
                                <a id="btnShowRpt" class="btn btn-primary btn-sm" href="#" onclick="fnGetReport(0);" title="Show Filtered Initiative(s)" style="font-size: 0.8rem;">Show</a>
                            </div>
                        </div>
                        <%--<div class="col-12" id="BookmarkFilterBlock">
                            <div class="fsw-title">Bookmark</div>
                            <select id="ddlBookmark" class="form-control form-control-sm" style="display: inline-block; width: 54%;" onchange="fnBookmarkFilter();">
                                <option value="0">All</option>
                                <option value="1">Bookmark</option>
                                <option value="2">Not Bookmark</option>
                            </select>
                            <img id="btnExcel" src="../../Images/excel.png" onclick="return fnDownload(); return false;" title="Download Report" style="margin-left: 10px; cursor: pointer;" />
                            <img id="btnChangeLogExcel" src="../../Images/excel-log.png" onclick="return fnChangeLogDownload(); return false;" title="Download Change Log" style="width: 35px; margin-left: 5px; cursor: pointer;" />
                        </div>--%>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 42%;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Type atleast 3 characters .." />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active">
            <%--<div><a id="btnInitExpandedCollapseMode" flgcollapse="1" href="#" style="color: #80BDFF;" onclick="fnInitExpandedCollapseMode();">Collapsed Mode</a></div>--%>
            <div id="divReport" class="row">
                <div class="col-1" id="divLeftReportHeader" style="padding-right: 0; overflow: hidden;"></div>
                <div class="col-11" id="divRightReportHeader" style="overflow-x: hidden; overflow-y: scroll; padding-left: 0; margin-left: -2px;"></div>
                <div class="col-1" id="divLeftReport" style="padding-right: 0; overflow-y: hidden; overflow-x: scroll;"></div>
                <div class="col-11" id="divRightReport" style="overflow-y: scroll; overflow-x: scroll; padding-left: 0; margin-left: -3px;"></div>
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
    <div id="divBaseProxySBFPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-12">
                <div class="d-flex" style="padding: 4px 12px; margin-bottom: 6px; border: 2px solid #F07C00; border-radius: 4px;">
                    <div class="d-block" style="width: 55%; color: #F07C00; font-size: 1.3rem; font-weight: 700; text-align: right;">What do you wish to do ?</div>
                    <div id="divBaseSBFActionbtns" class="d-block" style="width: 45%; text-align: right;">
                        <a class="btn btn-primary btn-sm" href="#" onclick="fnCombi(this,1);" style="border-color: #003da7; margin-right: 1%;">Add Individual Combi</a>
                        <a class="btn btn-primary btn-sm" href="#" onclick="fnCombi(this,2);" style="border-color: #003da7; margin-right: 1%;">Modify Individual Combi</a>
                        <a class="btn btn-primary btn-sm" href="#" onclick="fnCombi(this,3);" style="border-color: #003da7;">Add Multiple Base</a>
                    </div>
                </div>
            </div>
            <div class="col-5">
                <div class="prodLvl">
                    <div id="divBaseSBFlbl" class="align-items-center justify-content-between producthrchy">
                        <div>Base Sub-BrandForm</div>
                    </div>
                    <div id="divBaseSBFTbl" style="height: 190px; overflow-y: auto; width: 100%;"></div>
                    <div id="divSelectedBaseSBFTbl" style="display: none;"></div>
                    <div id="divBaseProxySBFlbl" class="align-items-center producthrchy">
                        <div class="d-block">Proxy Sub-BrandForm</div>
                    </div>
                    <div id="divBaseProxySBFTbl" style="height: 190px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-7">
                <div class="pl-2">
                    <div class="d-flex align-items-center producthrchy">
                        <div class="d-block">Sub-BrandForm</div>
                    </div>
                    <div id="divProxySBFTbl" brand="0" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divLegends" style="width: 67%; margin-left: 5px; padding: 5px 8px; background: #fff; border: 1px solid #bbb; border-radius: 4px; display: inline-block; float: left;"></div>
        <div id="divButtons" style="width: 32%; display: inline-block; text-align: right;"></div>
    </div>
    <div id="dvSBDListforImport" style="display: none;">
        <div class="row no-gutters">
            <div class="col-12 fsw" style="margin-bottom: 4px;">
                <div class="fsw_inputBox" style="width: 100%; display: inline-block; min-height: 46px;">
                    <div class="fsw-title" style="display: inline;">Quater</div>
                    <select id="ddlQuarterPopup" class="form-control form-control-sm ml-2 mr-4" style="width: 100px; display: inline;"></select>
                    <a id="btnImportProductHierFilter" class="btn btn-primary btn-sm mr-1" href="#" buckettype="1" prodlvl="40" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem;">Product</a>
                    <a id="btnImportClusterHierFilter" class="btn btn-primary btn-sm mr-1" href="#" onclick="fnShowClusterPopup(this, false);" title="Cluster Filter" mth="0" yr="0" selectedstr="" style="font-size: 0.8rem;">Cluster</a>
                    <a id="btnImportChannelHierFilter" class="btn btn-primary btn-sm mr-4" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem;">Channel</a>
                    <a id="btnImportSBD" class="btn btn-primary btn-sm" href="#" onclick="fnImportPrevQtrSBD();" title="Get SBD(s) for Import" style="font-size: 0.8rem; ">Get SBD(s) List</a>
                </div>
            </div>
        </div>
        <div id="dvSBDListforImportBody"></div>
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
    <div id="divChannelClusterforCopy" style="display: none;">
        <div class="row no-gutters">
            <div class="col-6">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Channel :
                    </div>
                    <div id="divChannelTblforCopy" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-6">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Cluster :
                    </div>
                    <div id="divClusterTblforCopy" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divSBDWiseChannelClusterforImport" style="display: none;"></div>

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
    <asp:HiddenField ID="hdnjsonarr" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />
    <asp:HiddenField ID="hdnFrequency" runat="server" />
    <asp:HiddenField ID="hdnBaseSBFAction" runat="server" />
    <asp:HiddenField ID="hdnBrandlstforNewNode" runat="server" />
    <asp:HiddenField ID="hdnBrandFormlstforNewNode" runat="server" />

    <asp:HiddenField ID="hdnSBFHierforBasePopup" runat="server" />

    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
    <asp:Button ID="btnSBDDownload" runat="server" Text="." OnClick="btnSBDDownload_Click" Style="visibility: hidden;" />
    <asp:Button ID="btnChangeLogDownload" runat="server" Text="." OnClick="btnChangeLogDownload_Click" Style="visibility: hidden;" />
</asp:Content>
