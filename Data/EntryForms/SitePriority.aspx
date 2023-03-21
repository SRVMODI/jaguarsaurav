<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="SitePriority.aspx.cs" Inherits="_BucketMstr" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <%--common functions--%>
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
    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#libtnHome").remove();

            ht = $(window).height();
            $("#divReportBody").height(ht - ($("#Heading").height() + $("#Filter").height() + 220));

            fnGetReport();
        });

        function fntypefilter() {
            var filter = $("#txtfilter").val().toUpperCase().split(",");

            if ($("#txtfilter").val().toUpperCase().length > 2) {
                $("#tblReport").find("tbody").eq(0).find("tr[iden='sitepriority']").css("display", "none");

                var flgValid = 0;
                $("#tblReport").find("tbody").eq(0).find("tr[iden='sitepriority']").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td").eq(5).html().toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }

                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                    }
                });

            }
            else {

                $("#tblReport").find("tbody").eq(0).find("tr[iden='sitepriority']").css("display", "table-row");
            }
        }
        function fnResetFilter() {

            $("#txtProductHierSearch").attr("lvl", "");
            $("#txtProductHierSearch").attr("selectedstr", "");
            $("#txtLocationHierSearch").attr("lvl", "");
            $("#txtLocationHierSearch").attr("selectedstr", "");
            $("#txtChannelHierSearch").attr("lvl", "");
            $("#txtChannelHierSearch").attr("selectedstr", "");

            $("#btnInitExpandedCollapseMode").show();
            $("#btnInitExpandedCollapseMode").html("Expanded Mode");
            $("#btnInitExpandedCollapseMode").attr("flgCollapse", "0");

            $("#txtfilter").val("");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#divReport").show();
            $("#divMsg").html('');

            fnGetReport();
        }

        function fnGetReport() {
            //var ProdValues = [];
            //var PrdString = $("#txtProductHierSearch").attr("prodhier");
            //if (PrdString != "") {
            //    for (var i = 0; i < PrdString.split("^").length; i++) {
            //        ProdValues.push({
            //            "col1": PrdString.split("^")[i].split("|")[0],
            //            "col2": PrdString.split("^")[i].split("|")[1],
            //            "col3": "1"
            //        });
            //    }
            //}
            //else {
            //    ProdValues.push({ "col1": "0", "col2": "0", "col3": "1" });
            //}
            //---------------------------------------------------------------------------
            //var LocValues = [];
            //var LocString = $("#txtLocationHierSearch").attr("prodhier");
            //if (LocString != "") {
            //    for (var i = 0; i < LocString.split("^").length; i++) {
            //        LocValues.push({
            //            "col1": LocString.split("^")[i].split("|")[0],
            //            "col2": LocString.split("^")[i].split("|")[1],
            //            "col3": "2"
            //        });
            //    }
            //}
            //else {
            //    LocValues.push({ "col1": "0", "col2": "0", "col3": "2" });
            //}
            //---------------------------------------------------------------------------
            //var ChannelValues = [];
            //var ChannelString = "";             //$("#txtChannelHierSearch").attr("prodhier");
            //if (ChannelString != "") {
            //    for (var i = 0; i < ChannelString.split("^").length; i++) {
            //        ChannelValues.push({
            //            "col1": ChannelString.split("^")[i].split("|")[0],
            //            "col2": ChannelString.split("^")[i].split("|")[1],
            //            "col3": "3"
            //        });
            //    }
            //}
            //else {
            //    ChannelValues.push({ "col1": "0", "col2": "0", "col3": "3" });
            //}
            //---------------------------------------------------------------------------
            //ArrUser = [];
            //for (var i = 0; i < $("#ddlMSMPAlies option:selected").length; i++) {
            //    ArrUser.push({ "col1": $("#ddlMSMPAlies option:selected").eq(i).val() });
            //}
            //if (ArrUser.length == 0)
            //    ArrUser.push({ "col1": 0 });



            $("#txtfilter").val('');
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var MonthVal = $("#ConatntMatter_ddlMonth").val().split("|")[0];
            var YearVal = $("#ConatntMatter_ddlMonth").val().split("|")[1];

            $("#dvloader").show();
            PageMethods.fnGetReport(UserID, LoginID, RoleID, MonthVal, YearVal, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReportBody").html(res.split("|^|")[1]);
                fnCreateHeader();

                Tooltip(".clsInform");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
        function fnCreateHeader() {
            var fixedHeader = "";
            fixedHeader += "<table id='tblfixedHeader' class='" + $("#tblReport").attr("class") + " mb-0 w-100'>";
            fixedHeader += "<thead>";
            fixedHeader += $("#tblReport").find("thead").eq(0).html();
            fixedHeader += "</thead>";
            fixedHeader += "</table>";
            $("#divReportHeader").html(fixedHeader);

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblfixedHeader").css("min-width", wid);
            for (i = 0; i < $("#tblReport").find("th").length - 1; i++) {
                var th_wid = $("#tblReport").find("th")[i].clientWidth;
                $("#tblfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                $("#tblReport").find("th").eq(i).css("width", th_wid);
            }
            $("#tblReport").css("margin-top", "-" + $("#tblfixedHeader")[0].offsetHeight + "px");
        }
        function fnAdjustColumnWidth() {
            $("#tblReport").css("width", "auto");
            for (i = 0; i < $("#tblReport").find("tr").eq(0).find("th").length; i++) {
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("min-width", "auto");
                $("#tblReport").find("tr").eq(0).find("th").eq(i).css("width", "auto");
            }

            var wid = $("#tblReport").width();
            $("#tblReport").css("width", wid);
            $("#tblfixedHeader").css("min-width", wid);

            for (i = 0; i < $("#tblReport").find("tr").eq(0).find("th").length - 1; i++) {
                var th_wid = $("#tblReport").find("th")[i].clientWidth;
                $("#tblfixedHeader").find("th").eq(i).css("min-width", th_wid);
                $("#tblfixedHeader").find("th").eq(i).css("width", th_wid);
                $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                $("#tblReport").find("th").eq(i).css("width", th_wid);

                $("#tblfixedHeader").find("th").eq(i).html($("#tblReport").find("th").eq(i).html());
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
                fnGetReport();
            }
            else {
                fnfailed();
            }
        }

    </script>
    <script type="text/javascript">
        function fnAddNew() {
            var str = "";
            str += "<tr iden='sitepriority' strId='0' flgEdit='1' style='display: table-row;'>";
            str += "<td iden='sitepriority' style='display: none;'></td>";            //Checkbox selection
            str += "<td iden='sitepriority'><div class='td-container w-100'><div iden='content' class='td-container-content w-100'></div><div class='td-container-btn'><img src='../../Images/edit.png' title='Select Location' iden='btn' buckettype='2' lvl='120' selectedstr='' onclick='fnShowHierPopup(this, 1);'/></div></div></td>";                //Location
            str += "<td iden='sitepriority'><div class='td-container w-100'><div iden='content' class='td-container-content w-100'></div><div class='td-container-btn'><img src='../../Images/edit.png' title='Select Channel' iden='btn' buckettype='3' lvl='210' selectedstr='' onclick='fnShowHierPopup(this, 1);'/></div></div></td>";                //Channel
            str += "<td iden='sitepriority'><div class='td-container w-100'><div iden='content' class='td-container-content w-100'></div><div class='td-container-btn'><img src='../../Images/edit.png' title='Select SBF Priority' iden='btn' buckettype='1' lvl='40' selectedstr='' onclick='fnShowSBFHierPopup(this);'/></div></div></td>";                //SBF
            str += "<td iden='sitepriority' class='cls-td-Action'><img src='../../Images/save.png' title='Save' onclick='fnSaveIndividual(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/></td>";
            str += "<td iden='sitepriority' style='display: none;'></td>";            //Search String
            str += "</tr>";

            if ($("#tblReport").find("tbody").eq(0).find("tr[iden='sitepriority']").length == 0) {
                $("#tblReport").find("tbody").eq(0).html(str);
            }
            else {
                $("#tblReport").find("tbody").eq(0).prepend(str);
            }
            fnAdjustColumnWidth();

            //$("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
        }
        function fnEditCopy(ctrl, cntr) {        // 1:Edit, 2:Copy
            var tr = $(ctrl).closest("tr[iden='sitepriority']");
            if (cntr == 2) {
                var str = "";
                str += "<tr iden='sitepriority' strId='0' flgEdit='1' style='display: table-row;'>";
                str += tr.html();
                str += "</tr>";
                tr.before(str);

                tr = tr.prev();
            }
            else {
                tr.attr("flgEdit", "1");

                tr.attr("location", tr.find("td[iden='sitepriority']").eq(1).find("div.td-container-btn").eq(0).attr("lvl") + "##" + tr.find("td[iden='sitepriority']").eq(1).find("div.td-container-btn").eq(0).attr("selectedstr") + "##" + tr.find("td[iden='sitepriority']").eq(1).find("div.td-container-content").eq(0).html());
                tr.attr("channel", tr.find("td[iden='sitepriority']").eq(2).find("div.td-container-btn").eq(0).attr("lvl") + "##" + tr.find("td[iden='sitepriority']").eq(2).find("div.td-container-btn").eq(0).attr("selectedstr") + "##" + tr.find("td[iden='sitepriority']").eq(2).find("div.td-container-content").eq(0).html());
                tr.attr("sbf", tr.find("td[iden='sitepriority']").eq(3).find("div.td-container-btn").eq(0).attr("lvl") + "##" + tr.find("td[iden='sitepriority']").eq(3).find("div.td-container-btn").eq(0).attr("selectedstr") + "##" + tr.find("td[iden='sitepriority']").eq(3).find("div.td-container-content").eq(0).html());
            }

            //tr.find("td[iden='sitepriority']").eq(0).html("");
            tr.find("td[iden='sitepriority']").eq(1).find("div.td-container-btn").eq(0).show();
            tr.find("td[iden='sitepriority']").eq(2).find("div.td-container-btn").eq(0).show();
            tr.find("td[iden='sitepriority']").eq(3).find("div.td-container-btn").eq(0).show();
            tr.find("td[iden='sitepriority']").eq(4).html("<img src='../../Images/save.png' title='Save' onclick='fnSaveIndividual(this, 2);'/><img src='../../Images/cancel.png' title='Cancel' onclick='fnCancel(this);'/>");

            fnAdjustColumnWidth();

            //$("#divButtons").find("a.btn[flgAction='100']").removeClass("btn-disabled").attr("onclick", "fnSaveFinalAction(this);");
        }
        function fnCancel(ctrl) {
            if ($(ctrl).closest("tr[iden='sitepriority']").attr("strId") == "0") {
                $(ctrl).closest("tr[iden='sitepriority']").remove();
            }
            else {
                var tr = $(ctrl).closest("tr[iden='sitepriority']");
                var location = tr.attr("location");
                var channel = tr.attr("channel");
                var sbf = tr.attr("sbf");

                tr.find("td[iden='sitepriority']").eq(1).html("<div class='td-container w-100'><div iden='content' class='td-container-content w-100'>" + location.split('##')[2] + "</div><div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select Location' iden='btn' buckettype='2' lvl='" + location.split('##')[0] + "' selectedstr='" + location.split('##')[1] + "' onclick='fnShowHierPopup(this, 1);'/></div></div>");
                tr.find("td[iden='sitepriority']").eq(2).html("<div class='td-container w-100'><div iden='content' class='td-container-content w-100'>" + channel.split('##')[2] + "</div><div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select Channel' iden='btn' buckettype='3' lvl='" + channel.split('##')[0] + "' selectedstr='" + channel.split('##')[1] + "' onclick='fnShowHierPopup(this, 1);'/></div></div>");
                tr.find("td[iden='sitepriority']").eq(3).html("<div class='td-container w-100'><div iden='content' class='td-container-content w-100'>" + sbf.split('##')[2] + "</div><div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select SBF Priority' iden='btn' buckettype='1' lvl='" + sbf.split('##')[0] + "' selectedstr='" + sbf.split('##')[1] + "' onclick='fnShowSBFHierPopup(this, 1);'/></div></div>");
                tr.find("td[iden='sitepriority']").eq(4).html("<img src='../../Images/edit.png' title='Edit' onclick='fnEditCopy(this, 1);'/>");
            }

            Tooltip(".clsInform");
            fnAdjustColumnWidth();

            //if ($("#tblleftfixed").find("tbody").eq(0).find("tr[flgEdit='1']").length == 0) {
            //    $("#divButtons").find("a.btn[flgAction='100']").addClass("btn-disabled").removeAttr("onclick", "fnSaveFinalAction(this);");
            //}
        }

        function fnSaveAllOpen(cntr) {
            SaveCntr = $("#tblReport").find("tbody").eq(0).find("tr[flgEdit='1']").length;
            if (SaveCntr != 0) {
                var flgSave = "1";

                var ctrl = $("#tblReport").find("tbody").eq(0).find("tr[flgEdit='1']").eq(cntr - 1).find("td.clstdAction").eq(0).find("img[title='Save']").eq(0);
                if (tr.attr("init") == "0") {
                    flgSave = "2";
                }
                fnSaveInitiative(ctrl, flgSave, cntr);
            }
            else {
                AutoHideAlertMsg("No Initiative details found for updation !");
            }
        }
        function fnSaveIndividual(ctrl, flgSave) {
            SaveCntr = 1;
            fnSaveSBFPriority(ctrl, flgSave, 0);
        }

        function fnSaveSBFPriority(ctrl, flgSave, cntr) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var MonthVal = $("#ConatntMatter_ddlMonth").val().split("|")[0];
            var YearVal = $("#ConatntMatter_ddlMonth").val().split("|")[1];
            var LocationArr = [];
            var ChannelArr = [];
            var SBFArr = [];

            var strId = $(ctrl).closest("tr").attr("strId");
            var strLocation = $(ctrl).closest("tr").find("td[iden='sitepriority']").eq(1).find("img[iden='btn']").eq(0).attr("selectedstr");
            var strChannel = $(ctrl).closest("tr").find("td[iden='sitepriority']").eq(2).find("img[iden='btn']").eq(0).attr("selectedstr");
            var strSBF = $(ctrl).closest("tr").find("td[iden='sitepriority']").eq(3).find("img[iden='btn']").eq(0).attr("selectedstr");

            if (strLocation == "" && strChannel == "" && strSBF == "") {
                AutoHideAlertMsg("Please select the Site, Channel & SBF Mapping !");
                $("#dvloader").hide();
                return false;
            }
            else {
                if (strLocation == "") {
                    AutoHideAlertMsg("Please select the Site !");
                    $("#dvloader").hide();
                    return false;
                }
                else if (strChannel == "") {
                    AutoHideAlertMsg("Please select the Channel !");
                    $("#dvloader").hide();
                    return false;
                }
                else if (strSBF == "") {
                    AutoHideAlertMsg("Please select & priority wise rank the SBFs !");
                    $("#dvloader").hide();
                    return false;
                }
                else {
                    for (var i = 0; i < strLocation.split("|").length; i++) {
                        LocationArr.push({
                            "col1": strLocation.split("|")[i].split("^")[0],
                            "col2": strLocation.split("|")[i].split("^")[1]
                        });
                    }
                    for (var i = 0; i < strChannel.split("|").length; i++) {
                        ChannelArr.push({
                            "col1": strChannel.split("|")[i].split("^")[0],
                            "col2": strChannel.split("|")[i].split("^")[1]
                        });
                    }

                    for (var i = 0; i < strSBF.split("|").length; i++) {
                        SBFArr.push({
                            "col1": strSBF.split("|")[i].split("^")[0],
                            "col2": strSBF.split("|")[i].split("^")[1],
                            "col3": strSBF.split("|")[i].split("^")[2]
                        });
                    }

                    $("#dvloader").show();
                    PageMethods.fnSave(LoginID, UserID, RoleID, MonthVal, YearVal, strId, LocationArr, ChannelArr, SBFArr, flgSave, fnSave_pass, fnfailed, cntr);
                }
            }
        }
        function fnSave_pass(res, cntr) {
            if (res.split("|^|")[0] == "0") {
                if (SaveCntr == (cntr + 1)) {
                    AutoHideAlertMsg("Site wise SBF priority details saved/updated successfully !");
                    fnGetReport();
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

                            $("#dvloader").show();
                            PageMethods.fnDeleteInitiative(InitIds, fnDeleteInitiative_pass, fnfailed);
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

                        $("#dvloader").show();
                        PageMethods.fnDeleteInitiative(INITID, fnDeleteInitiative_pass, fnfailed);
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
                fnGetReport();
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

    </script>
    <script type="text/javascript">
        function fnShowHierPopup(ctrl, flg) {
            $("#ConatntMatter_hdnCalledFrom").val(flg);
            $("#ConatntMatter_hdnSelectedHier").val("");

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
                strtable += "<th style='width:25%;'>Site</th>";
                strtable += "<th style='width:40%;'>Distributor</th>";
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
                strtable += "<th style='width:40%;'>Class</th>";
                strtable += "<th style='width:60%;'>Channel</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                $("#PopupHierlbl").html("Channel Hierarchy");
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
            }

            $("#divHierPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title + " :",
                open: function () {
                    if ($(ctrl).attr("selectedstr") != "")
                        $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("selectedstr"));

                    if ($(ctrl).attr("lvl") != "") {
                        fnBucketLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("lvl") + "']").eq(0));
                    }
                },
                close: function () {
                    $("#divHierPopup").dialog('destroy');
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var SelectedHierValues = fnProdSelected(ctrl, "divHierSelectionTbl").split("||||");
                        $(ctrl).attr("lvl", SelectedHierValues[0]);
                        $(ctrl).attr("selectedstr", SelectedHierValues[1]);
                        if ($("#ConatntMatter_hdnCalledFrom").val() == "1") {
                            $(ctrl).closest("div").prev().html(SelectedHierValues[2]);
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

        function fnBucketLvl(ctrl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var BucketLvl = $(ctrl).attr("ntype");

            $(ctrl).closest("tr").addClass("Active").siblings().removeClass("Active");

            $("#divHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

            var BucketValues = [];
            if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                var Selstr = $("#ConatntMatter_hdnSelectedHier").val();
                for (var i = 0; i < Selstr.split("|").length; i++) {
                    BucketValues.push({
                        "col1": Selstr.split("|")[i].split("^")[0],
                        "col2": Selstr.split("|")[i].split("^")[1],
                        "col3": $("#ConatntMatter_hdnBucketType").val()
                    });
                }
            }

            PageMethods.fnGetHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, BucketType, BucketLvl, BucketValues, fnGetHier_pass, fnGetHier_failed);
        }
        function fnGetHier_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divHierPopupTbl").html(res.split("|^|")[1]);

                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    $("#ConatntMatter_hdnSelectedHier").val("");
                    $("#divHierSelectionTbl").html(res.split("|^|")[2]);
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
                                fnHierExistingSelection(tr.eq(0));
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
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "30") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[bf='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "130") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[dbr='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
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
                                                fnHierExistingSelection(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "210") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[channel='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnHierExistingSelection(this);
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
                fnGetHier_failed();
            }
        }
        function fnGetHier_failed() {
            $("#divHierPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnHierExistingSelection(ctrl) {
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
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='110'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "110":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("reg") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "120":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("site") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][site='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][site='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "130":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("dbr") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][dbr='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            //case "140":
                            //    strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("branch") + "'>";
                            //    strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td><td>" + $(ctrl).find("td").eq(6).html() + "</td>";
                            //    break;
                        }
                        strtr += "</tr>";
                    }
                    else {
                        switch (Lvl) {
                            case "200":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("cls") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='210'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "210":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("channel") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][channel='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            //case "220":
                            //    strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("storetype") + "'>";
                            //    strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";
                            //    break;
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

        function fnProdPopuptypefilter(ctrl) {
            var tbl = $(ctrl).closest("table");
            var filter = ($(ctrl).val()).toUpperCase().split(",");

            if ($(ctrl).val().length > 2) {
                tbl.find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                tbl.find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                tbl.find("tbody").eq(0).find("tr").each(function () {
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
                tbl.find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                tbl.find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnHierPopupReset() {
            $("#divHierSelectionTbl").find("tbody").eq(0).html("");

            $("#divHierPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");

            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            });

            $("#chkSelectAllProd").removeAttr("checked");
        }

        function fnProdSelected(ctrl, selectedContainer) {
            var SelectedHier = "", descr = "";
            var SelectedLvl = $(ctrl).attr("lvl");
            if ($("#" + selectedContainer).find("table").eq(0).find("tbody").eq(0).find("tr").length > 0)
                SelectedLvl = $("#" + selectedContainer).find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");

            $("#" + selectedContainer).find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                if (parseInt($(this).attr("lvl")) > parseInt(SelectedLvl)) {
                    SelectedLvl = $(this).attr("lvl");
                }

                SelectedHier += "|" + $(this).attr("nid") + "^" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
                    case "10":                                                      // Product
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
                    case "100":                                                      // Site
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
                    case "200":                                                      // Channel
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
    <script type="text/javascript">
        function fnShowSBFHierPopup(ctrl) {
            $("#ConatntMatter_hdnSelectedHier").val("");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("buckettype"));

            $("#divSBFPriorityPopup").dialog({
                "modal": true,
                "width": "80%",
                "height": "560",
                "title": "SBF Priority Order :",
                open: function () {
                    if ($(ctrl).attr("lvl") != "") {
                        $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("selectedstr"));
                        $("#divSBFHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

                        var LoginID = $("#ConatntMatter_hdnLoginID").val();
                        var UserID = $("#ConatntMatter_hdnUserID").val();
                        var RoleID = $("#ConatntMatter_hdnRoleID").val();
                        var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
                        var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

                        var BucketType = $(ctrl).attr("buckettype");
                        var BucketLvl = $(ctrl).attr("lvl");
                        var BucketValues = [];

                        PageMethods.fnGetHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, BucketType, BucketLvl, BucketValues, fnSBFHier_pass, fnSBFHier_failed);
                    }
                },
                close: function () {
                    $("#divSBFPriorityPopup").dialog('destroy');
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var BucketLvl = $(ctrl).attr("lvl");

                        var selectedstr = "", descr = "";
                        $("#divSBFHierSelectionTbl").find("div.cls-div-drag-block").each(function () {
                            selectedstr += "|" + $(this).attr("nid") + "^" + BucketLvl + "^" + $(this).attr("rank");
                            descr += "<div class='cls-div-drag-block-mini cls-div-drag-block-" + $(this).attr("rank") + "' nid='" + $(this).attr("nid") + "' rank='" + $(this).attr("rank") + "'><div class='cls-div-drag-count-mini'>" + $(this).attr("rank") + "</div><div class='cls-div-drag-content-mini'>" + $(this).find("div.cls-div-drag-content").eq(0).html() + "</div></div>";
                        });

                        if (selectedstr == "")
                            $(ctrl).attr("selectedstr", "");
                        else
                            $(ctrl).attr("selectedstr", selectedstr.substring(1));

                        $(ctrl).closest("div").prev().html(descr);


                        //$(ctrl).closest("div").prev().html($("#divSBFHierSelectionTbl").html());
                        //$(ctrl).closest("div").prev().find("div.cls-div-drag-block").each(function () {
                        //    $(this).removeClass("cls-div-drag-block").addClass("cls-div-drag-block-mini");
                        //    $(this).find("div.cls-div-drag-count").eq(0).removeClass("cls-div-drag-count").addClass("cls-div-drag-count-mini");
                        //    $(this).find("div.cls-div-drag-content").eq(0).removeClass("cls-div-drag-content").addClass("cls-div-drag-content-mini");
                        //});

                        $("#divSBFPriorityPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        fnSBFHierPopupReset();
                    }
                }, {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divSBFPriorityPopup").dialog('close');
                    }
                }]
            });

            $("#divSBFHierSelectionTbl").sortable({
                update: function (event, ui) {
                    fnUpdateSeqNo();
                }
            });
        }
        function fnSBFHier_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divSBFHierPopupTbl").html(res.split("|^|")[1]);
                $("#divSBFHierSelectionTbl").html("");

                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    var selectedstr = $("#ConatntMatter_hdnSelectedHier").val();
                    for (var i = 0; i < selectedstr.split("|").length; i++) {
                        var tr = $("#divSBFHierPopupTbl").find("table").eq(0).find("tr[nid='" + selectedstr.split("|")[i].split("^")[0] + "'][ntype='" + selectedstr.split("|")[i].split("^")[1] + "']");
                        fnSBFHierExistingSelection(tr.eq(0));

                        var trHtml = tr[0].outerHTML;
                        tr.eq(0).remove();
                        $("#divSBFHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                    }
                    $("#ConatntMatter_hdnSelectedHier").val("");
                }
            }
            else {
                fnSBFHier_failed();
            }
        }
        function fnSBFHier_failed() {
            $("#divSBFHierPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnSBFHierExistingSelection(ctrl) {
            $(ctrl).attr("flg", "1");
            $(ctrl).addClass("Active");
            $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

            fnAppendSBFSelection(ctrl, 1);
        }
        function fnSelectUnSelectSBF(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                fnAppendSBFSelection(ctrl, 0);
                fnUpdateSeqNo();
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                fnAppendSBFSelection(ctrl, 1);
            }
        }
        function fnAppendSBFSelection(ctrl, flgSelect) {
            if (flgSelect == 1) {
                var cntr = $("#divSBFHierSelectionTbl").find("div.cls-div-drag-block").length + 1;
                $("#divSBFHierSelectionTbl").append("<div class='cls-div-drag-block cls-div-drag-block-" + cntr + "' nid='" + $(ctrl).attr("sbf") + "' rank='" + cntr + "'><div class='cls-div-drag-count'>" + cntr + "</div><div class='cls-div-drag-content'>" + $(ctrl).find("td").eq(5).html() + "</div></div>");
            }
            else {
                $("#divSBFHierSelectionTbl").find("div.cls-div-drag-block[nid='" + $(ctrl).attr("nid") + "']").eq(0).remove();
            }
        }

        function fnSBFPriorityPopuptypefilter(ctrl) {
            var tbl = $(ctrl).closest("table");
            var filter = ($(ctrl).val()).toUpperCase().split(",");

            if ($(ctrl).val().length > 2) {
                tbl.find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                tbl.find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                tbl.find("tbody").eq(0).find("tr").each(function () {
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
                tbl.find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                tbl.find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnSBFHierPopupReset() {
            $("#divSBFHierSelectionTbl").html("");

            $("#divSBFHierPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divSBFHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divSBFHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");

            $("#divSBFHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            });
        }
        function fnUpdateSeqNo() {
            var cntr = 0;
            $("#divSBFHierSelectionTbl").find("div.cls-div-drag-block").each(function () {
                cntr++;

                $(this).removeClass("cls-div-drag-block-" + $(this).attr("rank")).addClass("cls-div-drag-block-" + cntr);
                $(this).find("div.cls-div-drag-count").eq(0).html(cntr);
                $(this).attr("rank", cntr);
            });
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
                        $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("lvl", strCopyBucket.split("|||")[3]);
                        $(ctrl).closest("td[iden='Init']").find("img[iden='ProductHier']").eq(0).attr("selectedstr", strCopyBucket.split("|||")[2]);
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
                PageMethods.GetSelHierTbl(BucketValues, $("#ConatntMatter_hdnBucketType").val(), GetSelHierTbl_pass, GetSelHierTbl_failed);
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

        #divHierPopupTbl table tr.Active,
        #divSBFHierPopupTbl table tr.Active,
        #divCopyBucketPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        .fixed-top {
            z-index: 99 !important;
        }

        #divHierPopupTbl td,
        #divSBFHierPopupTbl td,
        #divHierSelectionTbl td {
            font-size: 0.7rem !important;
        }

        #divSBFHierSelectionTbl {
            padding: 10px;
            border: 1px solid #666;
            background-color: #f7f7f7;
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

        table.cls-tbl-Report tr td {
            height: 33px;
            min-height: 33px;
        }

        table.cls-tbl-Report tr th {
            text-align: center;
            vertical-align: middle;
        }

        table.cls-tbl-Report tr td:nth-child(1) {
            width: 7%;
            text-align: center;
        }

        table.cls-tbl-Report tr td:nth-child(2),
        table.cls-tbl-Report tr td:nth-child(3) {
            width: 25%;
            text-align: left;
        }

        table.cls-tbl-Report tr td:nth-child(4) {
            width: 40%;
            text-align: left;
        }

        table.cls-tbl-Report tr td.cls-td-Action {
            text-align: center;
            white-space: nowrap;
        }

            table.cls-tbl-Report tr td.cls-td-Action img {
                margin: 0 3px;
                height: 14px;
                cursor: pointer;
            }

        table.cls-tbl-Report tr td:nth-child(1) input[type='checkbox'] {
            height: 11px;
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

        table.cls-tbl-Report td.clstdExpandedContent {
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

            table.clsInitiativeLst th:nth-child(2) {
                width: 11%;
            }

        table.clsInitiativeLst tr td:nth-child(1) {
            text-align: center;
        }
    </style>

    <style type="text/css">
        .td-container {
            position: relative;
            box-sizing: border-box;
        }

        .td-container-content {
            font-size: 0.6rem;
            padding-right: 30px;
        }

        .td-container-btn {
            top: 0px;
            right: 5px;
            position: absolute;
        }

        div.cls-div-drag-block {
            cursor: move;
            color: #64270B;
            border-radius: 3px;
            margin: 2px 8px 5px;
            border: 1px solid #DA7112;
            background-color: #F7CFA8;
        }

        div.cls-div-drag-block-mini {
            width: 49%;
            color: #64270B;
            margin: 0.5% 0.5%;
            border-radius: 3px;
            display: inline-block;
            border: 1px solid #DA7112;
            background-color: #F7CFA8;
        }

        div.cls-div-drag-count {
            width: 10%;
            padding: 4px 12px;
            font-weight: 800;
            text-align: center;
            display: inline-block;
            border-right: 1px solid #DA7112;
        }

        div.cls-div-drag-count-mini {
            width: 10%;
            padding: 0 4px;
            font-weight: 800;
            font-size: 0.5rem;
            text-align: center;
            display: inline-block;
            border-right: 1px solid #DA7112;
        }

        div.cls-div-drag-content {
            width: 90%;
            padding: 4px 12px;
            font-weight: 600;
            display: inline-block;
        }

        div.cls-div-drag-content-mini {
            width: 90%;
            padding: 0 4px;
            font-weight: 600;
            font-size: 0.5rem;
            display: inline-block;
        }

        div.cls-div-drag-block-1,
        div.cls-div-drag-block-2 {
            background-color: #EF913A !important;
        }

        div.cls-div-drag-block-3,
        div.cls-div-drag-block-4,
        div.cls-div-drag-block-5 {
            background-color: #F3AB69 !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="font-size: .92rem">Site Priority
    </h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <%--<div class="fsw_inputBox" style="width: 12%; padding: 6px 10px;">
                    <div class="fsw-title">Stage</div>
                    <div class="d-block">
                        <select id="ddlStatus" class="form-control form-control-sm" onchange="fnGetReport();"></select>
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
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" lvl="" selectedstr="" onclick="fnShowHierPopup(this, 0);" title="Product Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Product</a>
                                <a id="txtLocationHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="2" lvl="" selectedstr="" onclick="fnShowHierPopup(this, 0);" title="Location Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Location</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" lvl="" selectedstr="" onclick="fnShowHierPopup(this, 0);" title="Channel Filter" style="font-size: 0.8rem; padding: 0.25rem 0.2rem; margin-right: 2%;">Channel</a>
                                <a id="btnReset" class="btn btn-primary btn-sm" href="#" onclick="fnResetFilter();" title="Reset All Filters" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Reset</a>
                                <a id="btnShowRpt" class="btn btn-primary btn-sm" href="#" onclick="fnGetReport();" title="Show Filtered Initiative(s)" style="font-size: 0.8rem; padding: 0.25rem 0.2rem;">Show</a>
                            </div>
                        </div>
                    </div>
                </div>--%>
                <div class="fsw_inputBox" style="width: 10%; padding: 6px;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonth" runat="server" class="form-control form-control-sm" onchange="fnGetReport();"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 75%;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Type atleast 3 characters .." />
                    </div>
                </div>
                <div class="fsw_inputBox" id="divAddNewFilterBlock" style="width: 15%;">
                    <div class="fsw-title">Site Priority</div>
                    <div class="d-block">
                        <a href="##" class="btn btn-primary btn-sm" id="btnAddNewINIT" onclick="fnAddNew();" title="Add New Initiative"><i class="fa fa-plus-square"></i>&nbsp; Add New Priority</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active">
            <div id="divReport" class="row m-0">
                <div class="col-9 m-auto" id="divReportHeader" style="overflow-x: hidden;"></div>
                <div class="col-9 m-auto" id="divReportBody" style="overflow-x: hidden; overflow-y: auto;"></div>
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
    <div id="divSBFPriorityPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-8">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy" style="background-color: #ED5D35;">
                        <div class="d-block">Sub-Brand Form</div>
                    </div>
                    <div id="divSBFHierPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-4">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy" style="background-color: #ED5D35;">
                        SBF Priority Order
                    </div>
                    <div id="divSBFHierSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>

    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divButtons" style="width: 100%; display: inline-block; text-align: center;"></div>
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
    <asp:HiddenField ID="hdnCalledFrom" runat="server" />
    <asp:HiddenField ID="hdnIsNewAdditionAllowed" runat="server" />
    <asp:HiddenField ID="hdnmonthyearexcel" runat="server" />
    <asp:HiddenField ID="hdnmonthyearexceltext" runat="server" />
    <asp:HiddenField ID="hdnjsonarr" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />

    <asp:HiddenField ID="hdnBrandlstforNewNode" runat="server" />
    <asp:HiddenField ID="hdnBrandFormlstforNewNode" runat="server" />

    <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" Style="visibility: hidden;" />
</asp:Content>
