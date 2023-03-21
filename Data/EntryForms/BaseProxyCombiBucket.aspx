<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="BaseProxyCombiBucket.aspx.cs" Inherits="_BaseProxyCombiBucket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
        function isNumberKeyNotDecimal(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
        function isNumericWithOneDecimal(evt, ctrl) {
            var msg = "Please enter only valid MOQ.";
            if (!(evt.keyCode == 46 || (evt.keyCode >= 48 && evt.keyCode <= 57))) {
                return false;
            }

            var parts = evt.srcElement.value.split('.');
            if (parts.length > 2) {
                return false;
            }

            if (evt.keyCode == 46)
                return (parts.length == 1);

            if (evt.keyCode != 46) {
                var currVal = String.fromCharCode(evt.keyCode);
                var strVal = parseFloat(String(parts[0]) + String(currVal));
                if (parts.length == 2)
                    strVal = parseFloat(String(parts[0]) + "." + String(currVal));
            }
            return true;
        }
        function GetCurrentDate() {
            var d = new Date();
            var dat = d.getDate();
            var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            if (dat < 10) {
                dat = "0" + dat.toString();
            }
            return (dat + "-" + MonthArr[d.getMonth()] + "-" + d.getFullYear());
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
                var mousey = (e.pageY - $('.customtooltip').height() - 20);   //Get Y coordinates
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
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#AddNewBtn").height() + 170));

            fnGetReport();
        });

        function fnColumnTypeSearch() {
            var flgValid = 0;
            var colcntr = $("#tblReport").find("th").length;
            
            $("#tblReport").find("tbody").eq(0).find("tr[flgEdit='0']").css("display", "none");
            $("#tblReport").find("tbody").eq(0).find("tr[flgEdit='0']").each(function () {
                flgValid = 1;
                for (var i = 1; i < colcntr; i++) {
                    if ($("#tblReport_header").find("th").eq(i).find("input[type='text']").length > 0) {
                        var filter = $("#tblReport_header").find("th").eq(i).find("input[type='text']").eq(0).val().toString().toUpperCase().trim();
                        if (filter != "" && filter.length > 2) {
                            if (i > 2) {
                                if ($(this).find("td").eq(i).attr("title").toUpperCase().indexOf(filter) == -1) {
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
                }

                if (flgValid == 1) {
                    $(this).css("display", "table-row");
                }
            });
        }

        function fnGetReport() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, UserID, RoleID, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm cls-Report' style='margin-bottom:0;'><thead>" + $("#tblReport").find("thead").eq(0).html() + "</thead></table>");
                $("#tblReport_header").find("th").eq(1).html($("#tblReport_header").find("th").eq(1).html() + "<br/><input type='text' onkeyup='fnColumnTypeSearch();' autocomplete='off' placeholder='Type atleast 3 character...'/>");
                $("#tblReport_header").find("th").eq(3).html($("#tblReport_header").find("th").eq(3).html() + "<br/><input type='text' onkeyup='fnColumnTypeSearch();' autocomplete='off' placeholder='Type atleast 3 character...'/>");

                $("#tblReport").css("margin-top", "-" + $("#tblReport").find("thead")[0].offsetHeight + "px");
                $("#divHeader").width($("#tblReport")[0].clientWidth + "px");
                Tooltip(".custom-tooltip");

                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();

                $("#divReport").html("");
                $("#divHeader").html("");
                AutoHideAlertMsg(res.split("|^|")[1]);
            }
            else {
                $("#divReport").html("");
                $("#divHeader").html("");
                fnfailed(res.split("|^|")[1]);
            }
        }
    </script>
    <script type="text/javascript">
        function fnAddNew() {
            var str = "";
            str += "<tr iden='sbf' strId='0' flgEdit='1'>";
            str += "<td iden='sbf'></td>";

            str += "<td iden='sbf'>";
            str += "<div style='position: relative;'>";
            str += "<input type='text' onkeyup='fnShowBaseSBFPopup(this);' autocomplete='off' placeholder='Type atleast 3 character...' BaseSBF=''/>";
            str += "<div class='cls-Popup'>" + $("#ConatntMatter_hdnSBFMstr").val() + "</div>";
            str += "</div>";
            str += "</td>";

            str += "<td iden='sbf'><input type='text' onkeypress='return isNumericWithOneDecimal(event, this)'/></td>";
            str += "<td iden='sbf'><span></span><img src='../../Images/edit.png' title='click to select Proxy SBF' ProxySBF='' onclick='fnShowProxySBFPopup(this);'  style='float:right;'/></td>";
            str += "<td iden='sbf'>0</td>";
            str += "<td iden='sbf'></td>";
            str += "<td iden='sbf'><img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
            str += "</tr>";

            $("#tblReport").find("tbody").eq(0).prepend(str);
        }
        function fnEdit(ctrl) {
            var BaseSBF = $(ctrl).closest("tr").attr("BaseSBF");
            var MOQ = $(ctrl).closest("tr").attr("MOQ");
            var ProxySBF = $(ctrl).closest("tr").attr("ProxySBF");
            var ProxySBFDescr = $(ctrl).closest("tr").find("td").eq(3).attr("title");

            var str = "";
            str += "<div style='position: relative;'>";
            str += "<input type='text' onkeyup='fnShowBaseSBFPopup(this);' autocomplete='off' placeholder='Type atleast 3 character...' BaseSBF='" + BaseSBF + "' value='" + BaseSBF.split("|")[2] + "'/>";
            str += "<div class='cls-Popup'>" + $("#ConatntMatter_hdnSBFMstr").val() + "</div>";
            str += "</div>";

            $(ctrl).closest("tr").find("td[iden='sbf']").eq(1).html(str);
            $(ctrl).closest("tr").find("td[iden='sbf']").eq(2).html("<input type='text' onkeypress='return isNumericWithOneDecimal(event, this)' value='" + MOQ + "' />");
            $(ctrl).closest("tr").find("td[iden='sbf']").eq(3).html("<span>" + ProxySBFDescr + "</span><img src='../../Images/edit.png' title='click to select Proxy SBF' ProxySBF='" + ProxySBF + "' onclick='fnShowProxySBFPopup(this);'  style='float:right;'/>");
            $(ctrl).closest("tr").find("td[iden='sbf']").eq(4).html(ProxySBF.trim() == "" ? 0 : ProxySBF.split("^").length);

            $(ctrl).closest("td[iden='sbf']").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");
        }
        function fnCancel(ctrl) {
            var strId = $(ctrl).closest("tr").attr("strId");
            if (strId == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var BaseSBF = $(ctrl).closest("tr").attr("BaseSBF");
                var MOQ = $(ctrl).closest("tr").attr("MOQ");
                var ProxySBF = $(ctrl).closest("tr").attr("ProxySBF");
                var ProxySBFDescr = $(ctrl).closest("tr").find("td[iden='sbf']").eq(3).attr("title");

                $(ctrl).closest("tr").find("td[iden='sbf']").eq(1).html(BaseSBF.split("|")[2]);
                $(ctrl).closest("tr").find("td[iden='sbf']").eq(2).html(MOQ);
                $(ctrl).closest("tr").find("td[iden='sbf']").eq(3).html(ProxySBFDescr.length > 52 ? ProxySBFDescr.substr(0, 50) + ".." : ProxySBFDescr);
                $(ctrl).closest("tr").find("td[iden='sbf']").eq(4).html(ProxySBF.trim() == "" ? 0 : ProxySBF.split("^").length);

                $(ctrl).closest("td[iden='sbf']").html("<img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);'/>");
            }
        }
        function fnSave(ctrl, flgOverwrite) {
            var FBBucketID = $(ctrl).closest("tr").attr("strId");
            var BaseSBF = $(ctrl).closest("tr").find("td[iden='sbf']").eq(1).find("input").eq(0).attr("BaseSBF");
            var MOQ = $(ctrl).closest("tr").find("td[iden='sbf']").eq(2).find("input").eq(0).val();
            var ProxySBF = $(ctrl).closest("tr").find("td[iden='sbf']").eq(3).find("img").eq(0).attr("ProxySBF");
            var ProxySBFArr = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();

            if (BaseSBF == "") {
                AutoHideAlertMsg("Please select the Base SBF !");
                return false;
            }
            else if (MOQ == "") {
                AutoHideAlertMsg("Please enter the MOQ !");
                return false;
            }
            else if (ProxySBF == "") {
                AutoHideAlertMsg("Please select the Proxy SBF(s) !");
                return false;
            }
            else {
                var flgIncludeBaseSBF = 0;
                for (var i = 0; i < ProxySBF.split("^").length; i++) {
                    if (ProxySBF.split("^")[i].split("|")[0] == BaseSBF.split("|")[0])
                        flgIncludeBaseSBF = 1;

                    ProxySBFArr.push({
                        "col1": ProxySBF.split("^")[i].split("|")[0],
                        "col2": ProxySBF.split("^")[i].split("|")[1]
                    });
                }

                if (flgIncludeBaseSBF == 0) {
                    ProxySBFArr.push({
                        "col1": BaseSBF.split("|")[0],
                        "col2": BaseSBF.split("|")[1]
                    });
                }

                $("#dvloader").show();
                PageMethods.fnSave(FBBucketID, BaseSBF, MOQ, ProxySBFArr, LoginID, fnSave_pass, fnfailed, ctrl);
            }
        }
        function fnSave_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                if ($(ctrl).closest("tr").attr("strId") == "0")
                    AutoHideAlertMsg("Base/Proxy Combi-bucket saved successfully !");
                else
                    AutoHideAlertMsg("Base/Proxy Combi-bucket details updated successfully !");

                fnGetReport();
            }
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();
                AutoHideAlertMsg("Selected Base SBF is already defined !");
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnShowBaseSBFPopup(ctrl) {
            var filter = $(ctrl).val().toUpperCase();
            if (filter.length > 2) {
                $(ctrl).next().show();

                var tbl = $(ctrl).next().find("table").eq(0);
                tbl.find("tbody").eq(0).find("tr").css("display", "none");
                tbl.find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("td")[0].innerText.toUpperCase().indexOf(filter) > -1) {
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $(ctrl).next().hide();
            }
        }

        function fnProxySBFPopuptypefilter(ctrl) {
            var filter = $(ctrl).val().toUpperCase();
            if (filter.length > 2) {
                $(ctrl).closest("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $(ctrl).closest("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");
                $(ctrl).closest("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter) > -1) {
                        $(this).css("display", "table-row");
                        $(this).attr("flgVisible", "1");
                    }
                });
            }
            else {
                $(ctrl).closest("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
                $(ctrl).closest("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            }
        }
        function fnShowProxySBFPopup(ctrl) {
            $("#divProxySBFPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "560",
                "title": "Sub-Brand Form",
                open: function () {
                    $("#divProxySBFPopup").find("table").eq(0).find("thead").eq(0).find("input").eq(0).val("");
                    $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                        $(this).attr("flg", "0");
                        $(this).removeClass("active");
                        $(this).attr("flgVisible", "1");
                        $(this).css("display", "table-row");
                        $(this).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png' />");
                    });

                    if ($(ctrl).attr("ProxySBF") != "") {
                        for (var i = 0; i < $(ctrl).attr("ProxySBF").split("^").length; i++) {
                            var tr = $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).find("tr[nid='" + $(ctrl).attr("ProxySBF").split("^")[i].split("|")[0] + "'][ntype='" + $(ctrl).attr("ProxySBF").split("^")[i].split("|")[1] + "']");

                            tr.eq(0).attr("flg", "1");
                            tr.eq(0).addClass("active");
                            tr.eq(0).find("td").eq(0).html("<img src='../../Images/checkbox-checked.png' />");

                            var tr_html = tr[0].outerHTML;
                            tr.eq(0).remove();
                            $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).prepend(tr_html);
                        }
                    }
                },
                close: function () {
                    //
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var SelectedSBF = "", descr = "";
                        var ProxyCntr = $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").length;
                        $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            SelectedSBF += "^" + $(this).attr("nid") + "|" + $(this).attr("ntype");
                            descr += "," + $(this).find("td").eq(5).html();
                        });

                        if (SelectedSBF != "") {
                            SelectedSBF = SelectedSBF.substring(1);
                            descr = descr.substring(1);
                            $(ctrl).attr("ProxySBF", SelectedSBF);
                            $(ctrl).prev().html(descr);
                        }
                        else {
                            $(ctrl).attr("ProxySBF", "");
                            $(ctrl).prev().html("");
                        }
                        $(ctrl).closest("td").next().html(ProxyCntr);

                        $("#divProxySBFPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        $("#divProxySBFPopup").find("table").eq(0).find("thead").eq(0).find("input").eq(0).val("");
                        $("#divProxySBFPopup").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            $(this).attr("flg", "0");
                            $(this).removeClass("active");
                            $(this).attr("flgVisible", "1");
                            $(this).css("display", "table-row");
                            $(this).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png' />");
                        });
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divProxySBFPopup").dialog('close');
                    }
                }]

            });
        }

        function fnSelectAllProxySBF(ctrl) {
            if ($(ctrl).is(":checked")) {
                $(ctrl).closest("table").find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "1");
                    $(this).addClass("active");
                    $(this).find("td").eq(0).html("<img src='../../Images/checkbox-checked.png' />");
                });
            }
            else {
                $(ctrl).closest("table").find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "0");
                    $(this).removeClass("active");
                    $(this).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png' />");
                });
            }
        }

        function fnSelectSBF(ctrl) {
            if ($(ctrl).attr("flgSBFType") == "1") {
                var SBF = $(ctrl).find("td").eq(4).html();
                $(ctrl).closest("table").parent().prev().val(SBF);
                $(ctrl).closest("table").parent().prev().attr("BaseSBF", $(ctrl).attr("nid") + "|" + $(ctrl).attr("ntype") + "|" + SBF);

                $(ctrl).closest("table").parent().hide();
            }
            else {
                if ($(ctrl).attr("flg") == "0") {
                    $(ctrl).attr("flg", "1");
                    $(ctrl).addClass("active");
                    $(ctrl).find("td").eq(0).html("<img src='../../Images/checkbox-checked.png' />");
                }
                else {
                    $(ctrl).attr("flg", "0");
                    $(ctrl).removeClass("active");
                    $(ctrl).find("td").eq(0).html("<img src='../../Images/checkbox-unchecked.png' />");

                    $(ctrl).closest("table").eq(0).find("thead").eq(0).find("tr").eq(1).find("th").eq(0).find("input").eq(0).removeAttr("checked");
                }
            }
        }
    </script>

    <style type="text/css">
        .fsw .fsw_inner {
            border: none;
        }

        .fsw_inputBox {
            background: #fff;
            border-radius: 3px;
            margin-right: 5px;
            border: solid 1px #b9c8e3;
            min-height: 76px;
        }

        .tab-content {
            padding-left: 0;
        }

        div.cls-Popup {
            width: 50%;
            z-index: 101;
            height: 180px;
            display: none;
            position: fixed;
            overflow-y: auto;
            background: #ffffff;
            border: 1px solid #444;
        }

            div.cls-Popup table td {
                padding: 0.1rem 0.3rem;
            }
    </style>
    <style type="text/css">
        
        #divReport {
            overflow-y: auto;
        }

        img {
            cursor: pointer;
        }

        input[type='text'] {
            width: 100%;
        }

        .custom-tooltip {
            cursor: pointer;
        }

        table.cls-Report th {
            text-align: center;
            vertical-align: middle !important;
        }

        table.cls-Report th > input[type='text'] {
            width: 90%;
        }

        table.cls-Report tr td:nth-child(1),
        table.cls-Report tr td:nth-child(3),
        table.cls-Report tr td:nth-child(5),
        table.cls-Report tr td:nth-child(6),
        table.cls-Report tr td:nth-child(7) {
            text-align: center;
        }

        table.cls-Report tr th:nth-child(1) {
            width: 5%;
        }

        table.cls-Report tr th:nth-child(2) {
            width: 20%;
        }

        table.cls-Report tr th:nth-child(3),
        table.cls-Report tr th:nth-child(5),
        table.cls-Report tr th:nth-child(6) {
            width: 9%;
        }

        table.cls-Report tr th:nth-child(7) {
            width: 12%;
        }

        table.cls-Report tr td:nth-child(4) span {
            display: inline-block;
            width: 90%;
        }

        table.cls-tblBaseSBf th:nth-child(2),
        table.cls-tblBaseSBf th:nth-child(3),
        table.cls-tblBaseSBf th:nth-child(4) {
            width: 20% !important;
        }

        table.cls-tblBaseSBf tr td:nth-child(5) {
            width: 40% !important;
            text-align: left;
        }

        table.cls-tblBaseSBf th,
        table.cls-tblBaseSBf td {
            font-size: 0.7rem;
        }

        table.cls-tblProxySBf th:nth-child(1) {
            width: 6%;
        }

        table.cls-tblProxySBf th:nth-child(3),
        table.cls-tblProxySBf th:nth-child(4),
        table.cls-tblProxySBf th:nth-child(5) {
            width: 20%;
        }

        table.cls-tblProxySBf tr.active {
            background-color: #cacaca;
        }
    </style>
    <style type="text/css">
        .btn-primary {
            background: #F26156 !important;
            border-color: #F26156;
            color: #fff !important;
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
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading">Base/Proxy Combi Bucket</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-100 text-right" style="min-height: auto;">
                <a href="#" class="btn btn-primary btn-sm" id="btnAddNew" onclick="fnAddNew();" title="Add New Cluster"><i class="fa fa-plus-square"></i>&nbsp; Add New Bucket</a>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active w-75" style="margin: 0 auto;">
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>

    <div id="divProxySBFPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-12">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div class="d-block">Please Select the Proxy SBF(s)</div>
                    </div>
                    <div id="divProxySBFPopupTbl" runat="server" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="divConfirm" style="display: none; font-size: 0.9rem; font-weight: 600; color: #7A7A7A;"></div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />

    <asp:HiddenField ID="hdnSBFMstr" runat="server" />
</asp:Content>
