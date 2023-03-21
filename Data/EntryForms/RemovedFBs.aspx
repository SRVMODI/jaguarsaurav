<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="RemovedFBs.aspx.cs" Inherits="_RemovedFBs" ValidateRequest="false" %>

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
            $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
            $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));

            $("#ddlMonth").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonth").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);

            $("#ddlStatus").html($("#ConatntMatter_hdnProcessGrp").val().split("^")[0]);
            //$("#divLegends").html($("#ConatntMatter_hdnProcessGrp").val().split("^")[1]);

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

            fnShowHierFilter();
            fnGetReport(1);
        });

        function fnShowHierFilter() {
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            if (RoleID == "1" || RoleID == "2" || RoleID == "4") {
                $("#MSMPFilterBlock").show();
                $("#HierFilterBlock").attr("class", "col-7 pr-0");

                $("#divHierFilterBlock").css("width", "45%");
                $("#divTypeSearchFilterBlock").css("width", "15%");
            }
            else {
                $("#MSMPFilterBlock").hide();
                $("#HierFilterBlock").attr("class", "col-12 pr-0");

                $("#divHierFilterBlock").css("width", "26%");
                $("#divTypeSearchFilterBlock").css("width", "34%");
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
                        if ($(this).find("td").eq(12).html().toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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

                $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
                $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnResetFilter() {
            $("#txtProductHierSearch").attr("InSubD", "0");
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#btnClusterFilter").attr("selectedstr", "");
            $("#txtChannelHierSearch").attr("InSubD", "0");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");

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
            var FBType = $("#ConatntMatter_ddlFBType").val();
            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var FromDate = $("#ddlMonth").val().split("|")[0];
            var ToDate = $("#ddlMonth").val().split("|")[1];
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
                        "col2": "0",
                        "col3": "5"
                    });
                }
            }
            else {
                LocValues.push({ "col1": "0", "col2": "0", "col3": "5" });
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
            PageMethods.fnGetReport(LoginID, RoleID, UserID, FBType, FromDate, ToDate, ProdValues, LocValues, ChannelValues, ProcessGroup, ArrUser, fnGetReport_pass, fnfailed, flg);
        }
        function fnGetReport_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                $("#divRightReport").html(res.split("|^|")[1]);

                //$("#divButtons").html(res.split("|^|")[2]);
                //$("#divLegends").html(res.split("|^|")[3]);

                var leftfixed = "";
                trArr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']");
                leftfixed += "<table id='tblleftfixed' class='table table-striped table-bordered table-sm clsReport' style='width:99.8%;'>";
                leftfixed += "<thead>";
                leftfixed += "<tr>";
                for (var i = 0; i < 4; i++) {
                    leftfixed += "<th>" + $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(i).html() + "</th>";
                }
                leftfixed += "</tr>";
                leftfixed += "</thead>";
                leftfixed += "<tbody>";
                for (h = 0; h < trArr.length; h++) {
                    leftfixed += "<tr Init='" + trArr.eq(h).attr("Init") + "' INITName='" + trArr.eq(h).attr("INITName") + "' flgEdit='0'>";
                    for (var i = 0; i < 4; i++) {
                        if (i == 0) {
                            leftfixed += "<td>" + trArr.eq(h).find("td").eq(i).html() + "</td>";
                        }
                        else if (i == 1) {
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

                $("#tblReport").css("margin-left", "-426px");

                fnCreateHeader();
                if ($("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).attr("Init") == "0") {
                    $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(0).remove();
                    $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(0).remove();
                }

                if ($("#divLeftReport").find("tbody").eq(0).find("tr").length == 0) {
                    var ht = $(window).height();
                    $("#divRightReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
                    $("#divLeftReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 200));
                }

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
            for (var i = 0; i < 4; i++) {
                fixedHeader += "<th>" + $("#tblReport").find("thead").eq(0).find("tr").eq(0).find("th").eq(i).html() + "</th>";
            }
            fixedHeader += "</tr>";
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divLeftReportHeader").html(fixedHeader);



            fixedHeader = "";
            fixedHeader += "<table id='tblRightfixedHeader' class='table table-striped table-bordered table-sm clsReport' style='width:99.8%; margin-bottom: 0;'>";
            fixedHeader += "<thead>";
            fixedHeader += $("#tblReport").find("thead").eq(0).html();
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divRightReportHeader").html(fixedHeader);
            $("#tblRightfixedHeader").css("margin-left", "-422px");


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

            for (i = 0; i < $("#tblleftfixed").find("th").length; i++) {
                var th_wid = $("#tblleftfixed").find("th")[i].clientWidth;
                $("#tblleftfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblleftfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblleftfixed").find("th").eq(i).css("min-width", th_wid);
                $("#tblleftfixed").find("th").eq(i).css("width", th_wid);

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
            for (i = 4; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("min-width", "auto");
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("width", "auto");
            }

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblRightfixedHeader").css("min-width", wid);

            for (i = 4; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
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
        function fnChkUnchkInitAll(ctrl) {
            if ($(ctrl).is(":checked")) {
                $("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']").prop("checked", true);

                if ($("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']:checked").length > 0) {
                    $("#btnRestore").removeClass("btn-disabled");
                    $("#btnRestore").attr("onclick", "fnRestoreMultiple();");
                }
            }
            else {
                $("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']").removeAttr("checked");

                $("#btnRestore").addClass("btn-disabled");
                $("#btnRestore").removeAttr("onclick");
            }
        }
        function fnUnchkInitIndividual(ctrl) {
            if (!($(ctrl).is(":checked"))) {
                $("#tblleftfixedHeader").find("input[type='checkbox']").removeAttr("checked");
            }

            if ($("#tblleftfixed").find("tbody").eq(0).find("input[type='checkbox'][iden='chkInit']:checked").length > 0) {
                $("#btnRestore").removeClass("btn-disabled");
                $("#btnRestore").attr("onclick", "fnRestoreMultiple();");
            }
            else {
                $("#btnRestore").addClass("btn-disabled");
                $("#btnRestore").removeAttr("onclick");
            }
        }

    </script>
    <script type="text/javascript">
        function fnRestore(ctrl) {
            var INITID = $(ctrl).closest("tr").attr("Init");
            var initname = $(ctrl).closest("tr").attr("initname");

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure, you want to Restore this Focus Brand <br/><span style='color:#0000ff; font-weight: 700;'>" + initname + "</span></div>");
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
                        var RoleID = $("#ConatntMatter_hdnRoleID").val();
                        var FBType = $("#ConatntMatter_ddlFBType").val();

                        $("#dvloader").show();
                        PageMethods.fnRestore(INITID, UserID, LoginID, RoleID, FBType, fnRestore_pass, fnfailed);
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
        function fnRestoreMultiple() {
            var InitIds = "";
            $("#tblleftfixed").find("tbody").eq(0).find("tr").each(function () {
                if ($(this).find("input[type='checkbox'][iden='chkInit']").length > 0) {
                    if ($(this).find("input[type='checkbox'][iden='chkInit']").is(":checked")) {
                        InitIds += "^" + $(this).closest("tr").attr("Init");
                    }
                }
            });

            if (InitIds == "") {
                AutoHideAlertMsg("Please select atleast one Focus Brand for Action !");
            }
            else {
                InitIds = InitIds.substring(1);

                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are going to Restore <span style='color:#0000ff; font-weight: 700;'>" + InitIds.split("^").length + "</span> Focus Brand(s).<br/>Do you want to continue ?</div>");

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
                            var RoleID = $("#ConatntMatter_hdnRoleID").val();
                            var FBType = $("#ConatntMatter_ddlFBType").val();

                            $("#dvloader").show();
                            PageMethods.fnRestore(InitIds, UserID, LoginID, RoleID, FBType, fnRestore_pass, fnfailed);
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

        function fnRestore_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Focus Brand(s) restored successfully !");
                fnGetReport(0);
            }
            else {
                fnfailed();
            }
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
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed);
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
                title = "Product/s :";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                title = "Site/s :";
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
                        strtable += "<th style='width:20%;'>Branch</th>";
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
        function AddNewFBProdRow(ctrl, flgCall) {   // 1: First Row
            var str = "<tr strId='0' IsNew='1'>";
            str += "<td><div style='position: relative; box-sizing: border-box;'><div iden='content' style='width: 100%; padding-right: 50px;'>Select Products Applicable in Group</div><div style='position: absolute; right:5px; top:-3px;'><img src='../../Images/favBucket.png' title='Favourite Bucket' onclick='fnAppRuleShowCopyBucketPopup(this, 2);'/><img src='../../Images/edit.png' title='Define New Selection' iden='ProductHier' copybuckettd='0' prodlvl='' prodhier='' onclick='fnAppRuleShowProdHierPopup(this, 1, 2);' style='margin-left:5px;'/></div></div></td>";
            str += "<td><select onchange='fnConditionChkDropdown(this);'>" + $("#ConatntMatter_hdnInitType").val() + "</select></td>";
            str += "<td><input type='text' value='0'/></td>";
            str += "<td><select disabled>" + $("#ConatntMatter_hdnUOM").val() + "</select></td>";
            str += "<td style='text-align: center;'><i class='fa fa-plus clsExpandCollapse' onclick='AddNewFBProdRow(this, 2);'></i><i class='fa fa-minus clsExpandCollapse' onclick='RemoveFBProdRow(this);'></i></td>";
            str += "</tr>";

            if (flgCall == 1)
                $("#tblFBAppRule").find("tbody").eq(0).append(str);
            else
                $(ctrl).closest("tr").after(str);
        }
        function RemoveFBProdRow(ctrl) {
            $(ctrl).closest("tr").remove();
        }

        function fnConditionChkDropdown(ctrl) {
            var Inittype = $(ctrl).val();
            fnUOMbasedonType(ctrl);
        }
        function fnUOMbasedonType(ctrl) {
            var Inittype = $(ctrl).val();
            switch (Inittype) {
                case "0":
                    $(ctrl).closest("td").next().next().find("select").eq(0).val("0");           //UOM
                    $(ctrl).closest("td").next().find("input[type='text']").eq(0).val("0");      //Min
                    break;
                default:
                    var UOM = $(ctrl).closest("select").find("option[value='" + Inittype + "']").attr("uom");
                    $(ctrl).closest("td").next().next().find("select").eq(0).val(UOM);             //UOM
                    $(ctrl).closest("td").next().find("input[type='text']").eq(0).val("0");        //Min
                    break;
            }
        }

        function fnShowApplicationRulesPopup(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();

            var INITDescription = $(ctrl).closest("tr[iden='Init']").attr("Descr");
            $("#txtArINITDescription").val(INITDescription);
            $("#tblFBAppRule").find("tbody").eq(0).html("");

            var selectedstr = $(ctrl).closest("tr").attr("FBAppRule");
            if (selectedstr == "")
                $("#tblFBAppRule").find("tbody").eq(0).html("<tr><td colspan='5'>No Details Found !</td></tr>");
            else {
                for (var i = 0; i < selectedstr.split("##").length; i++) {
                    AddNewFBProdRow(null, 1);
                    var tr = $("#tblFBAppRule").find("tbody").eq(0).find("tr:last");

                    tr.find("td").eq(0).find("div[iden='content']").eq(0).html(selectedstr.split("##")[i].split("$$")[2]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier", selectedstr.split("##")[i].split("$$")[3]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodlvl", selectedstr.split("##")[i].split("$$")[4]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("copybuckettd", selectedstr.split("##")[i].split("$$")[5]);
                    tr.find("td").eq(1).find("select").eq(0).val(selectedstr.split("##")[i].split("$$")[6]);
                    fnConditionChkDropdown(tr.find("td").eq(1).find("select").eq(0));

                    tr.find("td").eq(2).find("input").eq(0).val(parseInt(selectedstr.split("##")[i].split("$$")[7]));

                }

                $("#tblFBAppRule").find("tbody").eq(0).find("img").remove();
                $("#tblFBAppRule").find("tbody").eq(0).find("select").prop("disabled", true);
                $("#tblFBAppRule").find("tbody").eq(0).find("input").prop("disabled", true);
                $("#tblFBAppRule").find("tbody").eq(0).find("textarea").prop("disabled", true);

                $("#tblFBAppRule").find("thead").eq(0).find("th:last").hide();
                $("#tblFBAppRule").find("tbody").eq(0).find("tr").each(function () {
                    $(this).find("td:last").remove();
                });
            }

            $("#divApplicationRulePopup").dialog({
                "modal": true,
                "width": "70%",
                "height": "540",
                "title": "FB Application Rules",
                open: function () {
                    //
                },
                close: function () {
                    $("#divApplicationRulePopup").dialog('destroy');
                }
            });
        }
        function fnShowApplicationRulesPopupEditable(ctrl) {
            var rowIndex = $(ctrl).closest("tr[iden='Init']").index();
            $("#tblFBAppRule").find("thead").eq(0).find("th:last").show();

            var INITDescription = $("#tblleftfixed").find("tbody").eq(0).find("tr").eq(rowIndex).find("td").eq(4).find("textarea").eq(0).val();
            $("#txtArINITDescription").val(INITDescription);
            $("#tblFBAppRule").find("tbody").eq(0).html("");

            if ($(ctrl).attr("selectedstr") == "")
                AddNewFBProdRow(null, 1);
            else {
                for (var i = 0; i < $(ctrl).attr("selectedstr").split("##").length; i++) {
                    AddNewFBProdRow(null, 1);
                    var tr = $("#tblFBAppRule").find("tbody").eq(0).find("tr:last");
                    tr.attr("strId", $(ctrl).attr("selectedstr").split("##")[i].split("$$")[0]);
                    tr.attr("IsNew", $(ctrl).attr("selectedstr").split("##")[i].split("$$")[1]);

                    tr.find("td").eq(0).find("div[iden='content']").eq(0).html($(ctrl).attr("selectedstr").split("##")[i].split("$$")[2]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier", $(ctrl).attr("selectedstr").split("##")[i].split("$$")[3]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodlvl", $(ctrl).attr("selectedstr").split("##")[i].split("$$")[4]);
                    tr.find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("copybuckettd", $(ctrl).attr("selectedstr").split("##")[i].split("$$")[5]);
                    tr.find("td").eq(1).find("select").eq(0).val($(ctrl).attr("selectedstr").split("##")[i].split("$$")[6]);
                    fnConditionChkDropdown(tr.find("td").eq(1).find("select").eq(0));
                    tr.find("td").eq(2).find("input").eq(0).val(parseInt($(ctrl).attr("selectedstr").split("##")[i].split("$$")[7]));
                }
            }

            $("#divApplicationRulePopup").dialog({
                "modal": true,
                "width": "70%",
                "height": "540",
                "title": "FB Application Rules",
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
                        var selectedstr = "", flgValidate = 0;
                        $("#tblFBAppRule").find("tbody").eq(0).find("tr").each(function () {
                            if ($(this).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier") != "") {
                                selectedstr += "##" + $(this).attr("strId");
                                selectedstr += "$$" + $(this).attr("IsNew");
                                selectedstr += "$$" + $(this).find("td").eq(0).find("div[iden='content']").eq(0).html();
                                selectedstr += "$$" + $(this).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodhier");
                                selectedstr += "$$" + $(this).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("prodlvl");
                                selectedstr += "$$" + $(this).find("td").eq(0).find("img[iden='ProductHier']").eq(0).attr("copybuckettd");
                                selectedstr += "$$" + $(this).find("td").eq(1).find("select").eq(0).val();
                                selectedstr += "$$" + $(this).find("td").eq(2).find("input").eq(0).val();
                                selectedstr += "$$" + $(this).find("td").eq(3).find("select").eq(0).val();

                                if ($(this).find("td").eq(1).find("select").eq(0).val() == "0")
                                    flgValidate = 1;
                            }

                        });

                        if (flgValidate == 0) {
                            if (selectedstr != "")
                                selectedstr = selectedstr.substring(2);

                            $(ctrl).attr("selectedstr", selectedstr);

                            $("#divApplicationRulePopup").dialog('close');
                        }
                        else
                            AutoHideAlertMsg("Please Select the Condition Check !");
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
        function fnShowApplicationRulesPopupNonEditable(ctrl) {
            var strBase = $(ctrl).closest("tr[iden='Init']").attr("BaseProd");
            var strInit = $(ctrl).closest("tr[iden='Init']").attr("InitProd");

            $("#txtApplicablePer").val($(ctrl).closest("tr[iden='Init']").attr("ApplicablePer"));

            if (strBase == "") {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>No Application Rules defined for this Focus Brand !</div>");
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
                    "title": "Focus Brands Application Rules",
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
                        msg = "Focus Brand Product Value for Slab " + trArr.eq(i).attr("slabno") + " can't be blank !";
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
    <script type="text/javascript">
        function fnShowClusterDetailPopupReadOnly(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex);
            var ClusterDetail = rttr.attr("CusterDetail");

            var strtable = "";
            if (ClusterDetail != "") {
                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:5%;'>#</th>";
                strtable += "<th style='width:30%;'>Cluster</th>";
                strtable += "<th style='width:25%;'>Target</th>";
                strtable += "<th style='width:15%;'>COH No</th>";
                strtable += "<th style='width:20%;'>Sector</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";

                var Arr = ClusterDetail.split("|");
                for (var i = 0; i < Arr.length; i++) {
                    strtable += "<tr clusterId='" + Arr[i].split("^")[0] + "'>";
                    strtable += "<td>" + (i + 1).toString() + "</td>";
                    strtable += "<td>" + Arr[i].split("^")[1] + "</td>";
                    strtable += "<td><input type='text' value='" + Arr[i].split("^")[2] + "' disabled/></td>";
                    strtable += "<td><select iden='coh' style='width:98%;' defval='" + Arr[i].split("^")[3] + "' disabled>" + $("#ConatntMatter_hdnCOHMstr").val() + "</select></td>";

                    var strSector = "";
                    for (var j = 0; j < Arr[i].split("^")[4].split("$").length; j++) {
                        if (j > 0)
                            strSector += ", ";
                        strSector += Arr[i].split("^")[4].split("$")[j].split("~")[1];
                    }

                    strtable += "<td><input type='text' title='" + strSector + "' value='" + strSector + "' disabled/></td>";
                    //strtable += "<td><select iden='sector' style='width: 98%;' defval='" + Arr[i].split("^")[4] + "' disabled>" + $("#ConatntMatter_hdnSectorMstr").val() + "</select></td>";
                    strtable += "</tr>";
                }

                strtable += "</tbody>";
                strtable += "</table>";
            }
            else {
                strtable = "<div style='padding: 10px 20px; color: #f00; font-weight: 600; font-size: 1rem;'>No Details Found !</div>";
            }
            $("#divClusterDetailPopup").html(strtable);

            $("#divClusterDetailPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "540",
                "title": "Cluster-wise Details",
                open: function () {
                    $("#divClusterDetailPopup").find("select").each(function () {
                        $(this).val($(this).attr("defval"));
                    })
                },
                close: function () {
                    $("#divClusterDetailPopup").dialog('destroy');
                }
            });
        }
        function fnShowClusterDetailPopupEditable(ctrl) {
            var rowIndex = $(ctrl).closest("tr").index();
            var rttr = $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex);

            var strtable = "";
            if ($(ctrl).closest("td[iden='Init']").prev().find("img[iden='ProductHier']").eq(0).attr("selectedstr") != "") {
                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:4%;'>#</th>";
                strtable += "<th style='width:30%;'>Cluster</th>";
                strtable += "<th style='width:25%;'>Target</th>";
                strtable += "<th style='width:15%;'>COH No</th>";
                strtable += "<th style='width:25%;'>Sector</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";

                var ClusterDetail = $(ctrl).attr("selectedstr");
                if (ClusterDetail != "") {
                    var Arr = ClusterDetail.split("|");
                    for (var i = 0; i < Arr.length; i++) {
                        strtable += "<tr clusterId='" + Arr[i].split("^")[0] + "' iden='cluster-mapping'>";
                        strtable += "<td iden='cluster-mapping'>" + (i + 1).toString() + "</td>";
                        strtable += "<td iden='cluster-mapping'>" + Arr[i].split("^")[1] + "</td>";
                        strtable += "<td iden='cluster-mapping'><input type='text' value='" + Arr[i].split("^")[2] + "'/></td>";
                        strtable += "<td iden='cluster-mapping'><select iden='coh' style='width:98%;' defval='" + Arr[i].split("^")[3] + "'>" + $("#ConatntMatter_hdnCOHMstr").val() + "</select></td>";

                        var strSector = "";
                        if (Arr[i].split("^")[4] != "") {
                            for (var j = 0; j < Arr[i].split("^")[4].split("$").length; j++) {
                                if (j > 0)
                                    strSector += ", ";
                                strSector += Arr[i].split("^")[4].split("$")[j].split("~")[1];
                            }
                        }

                        strtable += "<td iden='cluster-mapping'><div style='position: relative;'><input type='text' iden='sector' value='" + strSector + "' selectedstr='" + Arr[i].split("^")[4] + "' title='" + strSector + "' onkeyup='fnShowSectorPopup(this);' onclick='fnShowSectorPopup(this);' readonly='readonly'/><div class='popup-sector'>" + $("#ConatntMatter_hdnSectorMstr").val() + "<div style='text-align: right; margin: 0.1rem 0.3rem;'><a class='btn btn-primary btn-small' onclick='fnHideSectorPopup();'>OK</a></div></div></div></td>";
                        //strtable += "<td><select iden='sector' style='width: 98%;' defval='" + Arr[i].split("^")[4] + "'>" + $("#ConatntMatter_hdnSectorMstr").val() + "</select></td>";
                        strtable += "</tr>";
                    }
                }
                else {
                    var Arr = $(ctrl).closest("td[iden='Init']").prev().find("img[iden='ProductHier']").eq(0).attr("selectedstr").split("^");
                    for (var i = 0; i < Arr.length; i++) {
                        strtable += "<tr clusterId='" + Arr[i].split("|")[0] + "' iden='cluster-mapping'>";
                        strtable += "<td iden='cluster-mapping'>" + (i + 1).toString() + "</td>";
                        strtable += "<td iden='cluster-mapping'>" + Arr[i].split("|")[1] + "</td>";
                        strtable += "<td iden='cluster-mapping'><input type='text' value=''/></td>";
                        strtable += "<td iden='cluster-mapping'><select iden='coh' style='width:98%;' defval='0'>" + $("#ConatntMatter_hdnCOHMstr").val() + "</select></td>";

                        strtable += "<td iden='cluster-mapping'><div style='position: relative;'><input type='text' iden='sector' value='' selectedstr='' title='' onkeyup='fnShowSectorPopup(this);' onclick='fnShowSectorPopup(this);' readonly='readonly'/><div class='popup-sector'>" + $("#ConatntMatter_hdnSectorMstr").val() + "<div style='text-align: right; margin: 0.1rem 0.3rem;'><a class='btn btn-primary btn-small' onclick='fnHideSectorPopup();'>OK</a></div></div></div></td>";
                        strtable += "</tr>";
                    }
                }

                strtable += "</tbody>";
                strtable += "</table>";
                strtable += "<div id='hover' style='width: 100%; height: 100%; display: none; background: #000;'></div>";
            }
            else {
                strtable = "<div style='padding: 10px 20px; color: #f00; font-weight: 600; font-size: 1rem;'>Please select the Location !</div>";
            }


            $("#divClusterDetailPopup").html(strtable);
            $("#divClusterDetailPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "540",
                "title": "Cluster-wise Details",
                open: function () {
                    $("#divClusterDetailPopup").find("select").each(function () {
                        $(this).val($(this).attr("defval"));
                    })
                },
                close: function () {
                    $("#divClusterDetailPopup").dialog('destroy');
                },
                buttons: [{
                    text: 'Submit',
                    class: 'btn-primary',
                    click: function () {
                        var selectedstr = "", strValidateMsg = "";
                        $("#divClusterDetailPopup").find("table").eq(0).find("tbody").eq(0).find("tr[iden='cluster-mapping']").each(function () {
                            if (strValidateMsg == "") {
                                if ($(this).find("td[iden='cluster-mapping']").eq(2).find("input").eq(0).val() == "") {
                                    strValidateMsg = "Please enter Target for Cluster - " + $(this).find("td[iden='cluster-mapping']").eq(1).html();
                                }
                                else if ($(this).find("td[iden='cluster-mapping']").eq(3).find("select").eq(0).val() == "0") {
                                    strValidateMsg = "Please select COH No. for Cluster - " + $(this).find("td[iden='cluster-mapping']").eq(1).html();
                                }
                                else if ($(this).find("td[iden='cluster-mapping']").eq(4).find("input").eq(0).val() == "") {
                                    strValidateMsg = "Please select Sector(s) for Cluster - " + $(this).find("td[iden='cluster-mapping']").eq(1).html();
                                }
                                else {
                                    selectedstr += "|" + $(this).attr("clusterId") + "^" + $(this).find("td[iden='cluster-mapping']").eq(1).html() + "^" + $(this).find("td[iden='cluster-mapping']").eq(2).find("input").eq(0).val() + "^" + $(this).find("td[iden='cluster-mapping']").eq(3).find("select").eq(0).val() + "^" + $(this).find("td[iden='cluster-mapping']").eq(4).find("input").eq(0).attr("selectedstr");
                                }
                            }
                        });
                        if (selectedstr != "") {
                            selectedstr = selectedstr.substring(1);
                        }

                        if (strValidateMsg == "") {
                            $(ctrl).attr("selectedstr", selectedstr);
                            $("#divClusterDetailPopup").dialog('close');
                        }
                        else {
                            AutoHideAlertMsg(strValidateMsg);
                        }
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        $("#divClusterDetailPopup").find("select").val("0");
                        $("#divClusterDetailPopup").find("input[type='text']").val("");
                        $("#divClusterDetailPopup").find("input[type='text'][iden='sector']").attr("title", "");
                        $("#divClusterDetailPopup").find("input[type='text'][iden='sector']").attr("selectedstr", "");
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divClusterDetailPopup").dialog('close');
                    }
                }]
            });
        }

        function fnShowSectorPopup(ctrl) {
            fnHideSectorPopup();
            $(ctrl).next().show();
            if ($(ctrl).closest("tr[iden='cluster-mapping']").index() > 7)
                $(ctrl).next().css("top", "-" + $(ctrl).next().height() + "px");
            else
                $(ctrl).next().css("top", "20px");

            if ($(ctrl).attr("selectedstr") != "") {
                var Arr = [];
                for (var i = 0; i < $(ctrl).attr("selectedstr").split("$").length; i++)
                    Arr.push($(ctrl).attr("selectedstr").split("$")[i].split("~")[0]);

                $(ctrl).next().find("table").eq(0).find("tr").each(function () {
                    if (Arr.indexOf($(this).attr("strid")) > -1) {
                        $(this).attr("flg", "1");
                        $(this).find("td").eq(0).html("<img src='../../Images/checkbox-checked.png'/>");
                    }
                    else {
                        $(this).attr("flg", "0");
                        $(this).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png'/>");
                    }
                });
            }
        }
        function fnHideSectorPopup() {
            $("div.popup-sector").hide();
        }
        function fnSelectSector(ctrl) {
            var flgSelect = $(ctrl).attr("flg");
            if (flgSelect == "0") {
                $(ctrl).attr("flg", "1");
                $(ctrl).find("td").eq(0).html("<img src='../../Images/checkbox-checked.png'/>");
            }
            else {
                $(ctrl).attr("flg", "0");
                $(ctrl).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png'/>");
            }

            var selectedstring = "", selectedstr = "";
            $(ctrl).closest("tbody").find("tr[flg='1']").each(function () {
                selectedstring += "$" + $(this).attr("strid") + "~" + $(this).find("td").eq(1).html();
                selectedstr += ", " + $(this).find("td").eq(1).html();
            });

            if (selectedstring != "") {
                $(ctrl).closest("table").parent().prev().val(selectedstr.substring(2));
                $(ctrl).closest("table").parent().prev().attr("title", selectedstr.substring(2));
                $(ctrl).closest("table").parent().prev().attr("selectedstr", selectedstring.substring(1));
            }
            else {
                $(ctrl).closest("table").parent().prev().val("");
                $(ctrl).closest("table").parent().prev().attr("title", "");
                $(ctrl).closest("table").parent().prev().attr("selectedstr", "");
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
        function fnShowClusterPopup(ctrl, flg, IsImportPopup) {   // 1: filter, 2: In Tbl
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
                    var Qtr = MonthArr.indexOf($("#ddlMonth").val().split("|")[0].split("-")[1]) + 1;
                    var Yr = $("#ddlMonth").val().split("|")[0].split("-")[2];

                    if (IsImportPopup) {
                        var Qtr = MonthArr.indexOf($("#ddlMonthPopup").val().split("|")[0].split("-")[1]) + 1;
                        var Yr = $("#ddlMonthPopup").val().split("|")[0].split("-")[2];
                    }

                    $(ctrl).attr("mth", Qtr);
                    $(ctrl).attr("yr", Yr);
                    PageMethods.GetClusters(LoginID, RoleID, UserID, "5", Qtr, Yr, GetClusters_pass, GetClusters_failed, selectedstr);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var selectedstr = "", descr = "";
                        $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            selectedstr += "^" + $(this).attr("clusterid") + "|" + $(this).find("td").eq(1).html();
                            descr += ", " + $(this).find("td").eq(1).html();
                        });
                        if (selectedstr != "") {
                            selectedstr = selectedstr.substring(1);
                            descr = descr.substring(2);
                        }

                        $(ctrl).attr("selectedstr", selectedstr);
                        if (flg == 2) {
                            $(ctrl).closest("div").prev().html(descr);

                            if (selectedstr != "") {
                                var clusterArr = [];
                                var ClusterwiseCOHSector = $(ctrl).closest("td[iden='Init']").next().find("a").eq(0).attr("selectedstr");
                                for (var i = 0; i < ClusterwiseCOHSector.split("|").length; i++) {
                                    clusterArr.push({
                                        "col1": ClusterwiseCOHSector.split("|")[i].split("^")[0],
                                        "col2": ClusterwiseCOHSector.split("|")[i]
                                    });
                                }

                                var ModifiedClusterwiseCOHSector = "";
                                for (var i = 0; i < selectedstr.split("^").length; i++) {
                                    var clustertr = $.grep(clusterArr, function (abc, ind) {
                                        return abc['col1'].toString() == selectedstr.split("^")[i].split("|")[0].toString();
                                    });

                                    if (clustertr.length > 0)
                                        ModifiedClusterwiseCOHSector += "|" + clustertr[0].col2;
                                    else
                                        ModifiedClusterwiseCOHSector += "|" + selectedstr.split("^")[i].split("|")[0].toString() + "^" + selectedstr.split("^")[i].split("|")[1].toString() + "^0^0^";
                                }
                                if (ModifiedClusterwiseCOHSector != "")
                                    ModifiedClusterwiseCOHSector = ModifiedClusterwiseCOHSector.substring(1);

                                $(ctrl).closest("td[iden='Init']").next().find("a").eq(0).attr("selectedstr", ModifiedClusterwiseCOHSector);
                            }
                            else
                                $(ctrl).closest("td[iden='Init']").next().find("a").eq(0).attr("selectedstr", "");
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
                    var tr = $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[clusterid='" + selectedstr.split("^")[i].split("|")[0] + "']");
                    tr.eq(0).attr("flg", "1");
                    tr.eq(0).addClass("Active");
                    tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }
                fnGetSelClusterHierTbl();
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
            fnGetSelClusterHierTbl();
        }
        function fnGetSelClusterHierTbl() {
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
                PageMethods.GetSelHierTbl(BucketValues, "2", "0", GetSelHierClusterTbl_pass, GetSelHierClusterTbl_failed);
            }
            else {
                $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
        }
        function GetSelHierClusterTbl_pass(res) {
            $("#dvloader").hide();
            $("#divClusterSelectionTbl").html(res);
        }
        function GetSelHierClusterTbl_failed() {
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
    <script type="text/javascript">
        function fnShowSKUs(ctrl) {
            var AppRules = $(ctrl).closest("td").prev().find("a").eq(0).attr("selectedstr");
            if (AppRules != "") {
                var ArrSKU = [];
                for (var i = 0; i < AppRules.split("##").length; i++) {
                    for (var j = 0; j < AppRules.split("##")[i].split("$$")[3].split("^").length; j++) {
                        ArrSKU.push({
                            "col1": AppRules.split("##")[i].split("$$")[3].split("^")[j].split("|")[0],
                            "col2": AppRules.split("##")[i].split("$$")[3].split("^")[j].split("|")[1]
                        });
                    }
                }

                if (ArrSKU.length > 0) {
                    $("#dvloader").show();
                    PageMethods.GetSKUList(ArrSKU, GetSKUList_pass, GetSKUList_fail, ctrl);
                }
                else {
                    AutoHideAlertMsg("Please defined the Application Rules !");
                }
            }
            else {
                AutoHideAlertMsg("Please defined the Application Rules !");
            }
        }
        function GetSKUList_pass(res, ctrl) {
            $("#dvloader").hide();

            if (res.split("|^|")[0] == "0") {
                $("#divSKUPopupTbl").html(res.split("|^|")[1]);

                $("#divSKUPopup").dialog({
                    "modal": true,
                    "width": "50%",
                    "height": "560",
                    "title": "SKU(s)",
                    open: function () {
                        if ($(ctrl).attr("selectedstr") != "") {
                            var Arr = $(ctrl).attr("selectedstr").split("^");

                            for (var i = 0; i < Arr.length; i++) {
                                var tr = $("#divSKUPopupTbl").find("table").eq(0).find("tr[nid='" + Arr[i].split("|")[0] + "'][ntype='" + Arr[i].split("|")[1] + "']");
                                if (tr.length > 0) {
                                    fnSelectUnSelectSKU(tr.eq(0));

                                    var trHtml = tr[0].outerHTML;
                                    tr.eq(0).remove();
                                    $("#divSKUPopup").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                }
                            }
                        }
                    },
                    close: function () {
                        $("#divSKUPopup").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Submit',
                        class: 'btn-primary',
                        click: function () {
                            if ($("#divSKUPopup").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").length > 0) {
                                var descr = "", selectedstr = "";
                                $("#divSKUPopup").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                                    descr += ", " + $(this).find("td").eq(5).html();
                                    selectedstr += "^" + $(this).attr("nid") + "|" + $(this).attr("ntype");
                                });

                                $(ctrl).closest("div").prev().html(descr.substring(1));
                                $(ctrl).attr("selectedstr", selectedstr.substring(1));

                                fnAdjustRowHeight($(ctrl).closest("tr").index());
                                $("#divSKUPopup").dialog('close');
                            }
                            else {
                                AutoHideAlertMsg("Please select the SKU(s) !");
                            }
                        }
                    },
                    {
                        text: 'Reset',
                        class: 'btn-primary',
                        click: function () {
                            $("#divSKUPopup").find("input[type='text']").val("");

                            $("#divSKUPopup").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                                $(this).attr("flg", "0");
                                $(this).removeClass("Active");
                                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                            });

                            $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                            $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
                        }
                    },
                    {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divSKUPopup").dialog('close');
                        }
                    }]
                });
            }
            else {
                GetSKUList_fail(res.split("|^|")[1]);
            }
        }
        function GetSKUList_fail(error) {
            $("#divSKUPopupTbl").html("Due to some technical reasons, we are unable to process your request. Error : " + res.split("|^|")[1] + " !");
        }

        function fnSKUtypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
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
                $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divSKUPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnSelectUnSelectSKU(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            }
            else {
                if ($(ctrl).closest("tbody").find("tr[flg='1']").length < 6) {
                    $(ctrl).attr("flg", "1");
                    $(ctrl).addClass("Active");
                    $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }
                else {
                    AutoHideAlertMsg("You are only allowed to select upto 6 SKUs !");
                }
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

        #divSKUPopup table tr.Active {
            background: #aaaaff;
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
            height: 55px;
            min-height: 55px;
        }

        table.clsReport tr th {
            text-align: center;
            vertical-align: middle;
        }

        table.clsReport tr td:nth-child(1) {
            width: 40px;
            min-width: 40px;
        }

        table.clsReport tr td:nth-child(3) {
            width: 120px;
            min-width: 120px;
        }

        table.clsReport tr td:nth-child(5) {
            min-width: 100px;
        }

        table.clsReport tr td:nth-child(8) {
            width: 80px;
            min-width: 80px;
        }


        table.clsReport tr td:nth-child(11),
        table.clsReport tr td:nth-child(12) {
            width: 100px;
            min-width: 100px;
        }

        table.clsReport tr td:nth-child(10),
        table.clsReport tr td:nth-child(13),
        table.clsReport tr td:nth-child(14),
        table.clsReport tr td:nth-child(15),
        table.clsReport tr td:nth-child(16),
        table.clsReport tr td:nth-child(17) {
            width: 140px;
            min-width: 140px;
        }

        #divReport td.clstdAction {
            text-align: center;
            width: 60px;
            min-width: 60px;
        }

            #divReport td.clstdAction img {
                height: 18px;
                cursor: pointer;
            }

        table.clsReport tr td:nth-child(4),
        table.clsReport tr td:nth-child(5) {
            word-break: break-all;
        }

        table.clsReport tr td:nth-child(1),
        table.clsReport tr td:nth-child(2),
        table.clsReport tr td:nth-child(3),
        table.clsReport tr td:nth-child(7),
        table.clsReport tr td:nth-child(8),
        table.clsReport tr td:nth-child(10),
        table.clsReport tr td:nth-child(11),
        table.clsReport tr td:nth-child(12),
        table.clsReport tr td:nth-child(13) {
            text-align: center;
        }

            table.clsReport tr td:nth-child(11) input[type='checkbox'] {
                height: 11px;
                margin-right: 6px;
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
        div.popup-sector {
            z-index: 1;
            padding: 0;
            display: none;
            position: absolute;
            min-width: 145px;
            background: #fffbfb;
            border: 1px solid #ddd;
        }

            div.popup-sector a {
                /*float: right;
                color: #ff0000;
                font-size: 0.8rem;
                font-weight: 700;
                line-height: 0.5;
                text-decoration: none !important;*/
            }

        table.tbl-sector {
            width: 100%;
        }

            table.tbl-sector td {
                font-size: 0.66rem;
                font-weight: 600;
                border: none;
                border-bottom: 1px solid #ddd;
                padding: 0.2rem 0 0.1rem 0.5rem;
            }

                table.tbl-sector td img {
                    height: 9px;
                    margin-top: 2px;
                    vertical-align: top;
                }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="font-size: .92rem">
        FB Recycle Bin
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 12%;">
                    <div class="fsw-title">FB Type</div>
                    <div class="d-block">
                        <asp:DropDownList ID="ddlFBType" runat="server" CssClass="form-control form-control-sm" onchange="fnGetReport(0);">
                            <asp:ListItem Value="1">Base</asp:ListItem>
                            <asp:ListItem Value="2">Top-Up</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 11%;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonth" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 17%;">
                    <div class="fsw-title">Stage</div>
                    <div class="d-block">
                        <select id="ddlStatus" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divHierFilterBlock" style="width: 44%;">
                    <div class="row">
                        <div class="col-5" id="MSMPFilterBlock" style="display: none;">
                            <div class="fsw-title">ms&amp;P</div>
                            <div class="d-block">
                                <select id="ddlMSMPAlies" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="col-7 pr-0" id="HierFilterBlock">
                            <div class="fsw-title">Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem;">Product</a>
                                <a id="btnClusterFilter" class="btn btn-primary btn-sm" href="#" onclick="fnShowClusterPopup(this, 1, false);" title="Cluster Filter" selectedstr="" style="font-size: 0.8rem;">Cluster</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem; margin-right: 2%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters" style="font-size: 0.8rem;">Reset</a>
                                <a id="btnShowRpt" class="btn btn-primary btn-sm" href="#" onclick="fnGetReport(0);" title="Show Filtered Focus Brand(s)" style="font-size: 0.8rem;">Show</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 16%;">
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
        <div>
            <div class="fsw-title" style="margin-bottom: 0;">Description :</div>
            <textarea id="txtArINITDescription" style='width: 100%; box-sizing: border-box; overflow-y: auto; margin: 5px 0 10px 0;' rows='2' readonly="readonly"></textarea>
        </div>

        <div>
            <div class="clsAppRuleHeader" style="font-size: 0.9rem;">Products :</div>
            <div class="clsAppRuleSlabContainer" style="border-radius: 3px 3px 0 0; padding: 6px;">
                <table id="tblFBAppRule" class='table table-bordered table-sm' style="margin-bottom: 0;">
                    <thead>
                        <tr>
                            <th style="text-align: center; vertical-align: middle;">Product</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">Condition Check</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">Minimum</th>
                            <th style="width: 120px; text-align: center; vertical-align: middle;">UOM</th>
                            <th style="width: 80px; text-align: center; vertical-align: middle;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
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
    <div id="divClusterDetailPopup" style="display: none;"></div>
    <div id="divSKUPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-12">
                <div class="d-flex align-items-center justify-content-between producthrchy">
                    <div class="d-block">Please Select Top 3 SKUs :</div>
                </div>
                <div id="divSKUPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
            </div>
        </div>
    </div>

    <%--<div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divLegends" style="width: 67%; margin-left: 5px; padding: 5px 8px; background: #fff; border: 1px solid #bbb; border-radius: 4px; display: inline-block; float: left;"></div>
        <div id="divButtons" style="width: 32%; display: inline-block; text-align: right; padding-top: 8px;"></div>
    </div>--%>
    <div id="divFooter" class="text-right" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <a href='#' id="btnRestore" class='btn btn-primary btn-disabled btn-sm mr-3'>Restore Selected</a>
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
                    <a id="btnImportClusterHierFilter" class="btn btn-primary btn-sm mr-1" href="#" onclick="fnShowClusterPopup(this, 1, true);" title="Cluster Filter" mth="0" yr="0" selectedstr="" style="font-size: 0.8rem;">Cluster</a>
                    <a id="btnImportChannelHierFilter" class="btn btn-primary btn-sm mr-4" href="#" buckettype="3" prodlvl="210" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem;">Channel</a>
                    <a id="btnImportFB" class="btn btn-primary btn-sm" href="#" onclick="fnCopyMultiInitiative();" title="Get FB(s) for Import" style="font-size: 0.8rem;">Get FB(s) List</a>
                </div>
            </div>
            <div class="col-6 fsw" style="margin-bottom: 4px;">
                <div class="fsw_inputBox" style="width: 100%; display: inline-block; min-height: 46px;">
                    <%--<div class="fsw-title">Search Box</div>--%>
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
    <asp:HiddenField ID="hdnInitType" runat="server" />
    <asp:HiddenField ID="hdnUOM" runat="server" />
    <asp:HiddenField ID="hdnSectorMstr" runat="server" />
    <asp:HiddenField ID="hdnCOHMstr" runat="server" />
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
    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
</asp:Content>
