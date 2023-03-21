<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="ExtendCreationDateSWB.aspx.cs" Inherits="ExtendCreationDateSWB" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
        var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

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
            if (dat < 10) {
                dat = "0" + dat.toString();
            }
            return (dat + "-" + MonthArr[d.getMonth()] + "-" + d.getFullYear());
        }
        function AddZero(str, len) {
            var newstr = "";
            if (str.toString().length < len) {
                for (var i = str.toString().length; i < len; i++) {
                    newstr += "0";
                }
            }
            newstr += str;
            return newstr;
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
                var mousey = ht - (e.pageY + $('.customtooltip').height() - 50) > 0 ? e.pageY : (e.pageY - $('.customtooltip').height() - 40);   //Get Y coordinates
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
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#AddNewBtn").height() + 150));

            fnGetReport();
        });


        function fnGetReport() {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, UserID, RoleID, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#ConatntMatter_hdnMonthMstr").val(res.split("|^|")[1]);
                $("#divReport").html(res.split("|^|")[2]);

                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm cls-Report' style='margin-bottom:0;'><thead>" + $("#tblReport").find("thead").eq(0).html() + "</thead></table>");
                $("#tblReport").css("margin-top", "-" + $("#tblReport").find("thead")[0].offsetHeight + "px");
                Tooltip(".custom-tooltip");

                $("#dvloader").hide();
            }
            else {
                $("#divReport").html("");
                $("#divHeader").html("");

                fnfailed(res.split("|^|")[1]);
            }
        }


        function fnMonth(ctrl) {
            if ($(ctrl).val() == "0") {
                $(ctrl).closest("td").next().html("<input type='text' class='cre-date' disabled='disabled'/><span>To</span><input type='text' class='cre-date' disabled='disabled'/>");
            }
            else {
                var selected = $(ctrl).val();
                var option = $(ctrl).find("option[value='" + selected + "']").eq(0);
                var month = option.attr("Month");
                var year = option.attr("Year");
                var descr = option.html();

                var isDuplicate = false;
                if ($("#tblReport").find("tbody").eq(0).find("tr[flgEdit='0'][Month='" + month + "'][Year='" + year + "']").length > 0) {
                    isDuplicate = true;
                }
                else if ($("#tblReport").find("tbody").eq(0).find("tr[flgEdit='1'][Month='" + month + "'][Year='" + year + "']").length > 0) {
                    isDuplicate = true;
                }
                else {
                    var cntr = 0;
                    $("#tblReport").find("tbody").eq(0).find("tr[flgEdit='2']").each(function () {
                        if ($(this).find("select").eq(0).val() != "0") {
                            if ($(this).find("select").eq(0).val() == (year + "|" + AddZero(month, 2)))
                                cntr++;
                        }
                    });

                    if (cntr > 1)
                        isDuplicate = true;
                }

                if (isDuplicate) {
                    $(ctrl).val("0");
                    $(ctrl).closest("td").next().html("<input type='text' class='cre-date' disabled='disabled'/><span>To</span><input type='text' class='cre-date' disabled='disabled'/>");

                    AutoHideAlertMsg(descr + " is already defined !");
                }
                else {
                    $(ctrl).closest("td").next().html("<input type='text' class='cre-date' readonly='readonly'/><span>To</span><input type='text' class='cre-date' readonly='readonly'/>");

                    var start = option.attr("start");
                    var end = option.attr("end");
                    $(ctrl).closest("tr").find("input.cre-date").datepicker({
                        dateFormat: 'dd-M-yy'
                        //minDate: start,
                        //maxDate: end
                    });
                }
            }
        }

        function fnAddNew() {
            var str = "";
            str += "<tr iden='creationdate' flgEdit='2'>";
            str += "<td iden='creationdate'></td>";
            str += "<td iden='creationdate'><select onchange='fnMonth(this);'>" + $("#ConatntMatter_hdnMonthMstr").val() + "</select></td>";
            str += "<td iden='creationdate'><input type='text' class='cre-date' disabled='disabled'/><span>To</span><input type='text' class='cre-date' disabled='disabled'/></td>";
            str += "<td iden='creationdate'><img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
            str += "</tr>";

            $("#tblReport").find("tbody").eq(0).prepend(str);
        }
        function fnEdit(ctrl) {
            $(ctrl).closest("tr").attr("flgEdit", "1");
            var startdate = $(ctrl).closest("tr").attr("startdate");
            var enddate = $(ctrl).closest("tr").attr("enddate");
            var Month = $(ctrl).closest("tr").attr("Month");
            var Year = $(ctrl).closest("tr").attr("Year");

            $(ctrl).closest("tr").find("td[iden='creationdate']").eq(2).html("<input type='text' class='cre-date' value='" + startdate + "' readonly='readonly'/><span>To</span><input type='text' class='cre-date' value='" + enddate + "' readonly='readonly'/>");
            $(ctrl).closest("tr").find("input.cre-date").datepicker({
                dateFormat: 'dd-M-yy'
                //minDate: '01-' + MonthArr[parseInt(Month) - 1] + "-" + Year,
                //maxDate: new Date(Year, parseInt(Month), 0)
            });

            $(ctrl).closest("td[iden='creationdate']").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");

        }
        function fnCancel(ctrl) {
            var strId = $(ctrl).closest("tr").attr("flgEdit");
            if (strId == "2") {
                $(ctrl).closest("tr").remove();
            }
            else {
                $(ctrl).closest("tr").attr("flgEdit", "0");
                var startdate = $(ctrl).closest("tr").attr("startdate");
                var enddate = $(ctrl).closest("tr").attr("enddate");

                $(ctrl).closest("tr").find("td[iden='creationdate']").eq(2).html(startdate + "<span>To</span>" + enddate);
                $(ctrl).closest("td[iden='creationdate']").html("<img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);'/>");
            }
        }
        function fnSave(ctrl) {
            var flgEdit = $(ctrl).closest("tr").attr("flgEdit");

            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var MonthVal = 0;
            var YearVal = 0;
            var StartDate = $(ctrl).closest("tr").find("td").eq(2).find("input").eq(0).val().trim();
            var EndDate = $(ctrl).closest("tr").find("td").eq(2).find("input").eq(1).val().trim();
            var numericStartDate = "", numericEndDate = "";


            if (flgEdit == "2" && $(ctrl).closest("tr").find("td").eq(1).find("select").eq(0).val() == "0") {
                AutoHideAlertMsg("Please select the Month-Year !");
                return false;
            }
            else if (StartDate == "") {
                AutoHideAlertMsg("Please enter the Start Date !");
                return false;
            }
            else if (EndDate == "") {
                AutoHideAlertMsg("Please enter the End Date !");
                return false;
            }
            else {
                numericStartDate = StartDate.split("-")[2] + AddZero(MonthArr.indexOf(StartDate.split("-")[1]) + 1, 2) + AddZero(StartDate.split("-")[0], 2);
                numericEndDate = EndDate.split("-")[2] + AddZero(MonthArr.indexOf(EndDate.split("-")[1]) + 1, 2) + AddZero(EndDate.split("-")[0], 2);

                if (parseInt(numericStartDate) > parseInt(numericEndDate)) {
                    AutoHideAlertMsg("Start Date shouldn't be greater than End Date !");
                    return false;
                }
                else if (flgEdit == "2") {
                    MonthVal = $(ctrl).closest("tr").find("td").eq(1).find("select").eq(0).val().split("|")[1];
                    YearVal = $(ctrl).closest("tr").find("td").eq(1).find("select").eq(0).val().split("|")[0];

                    $("#dvloader").show();
                    PageMethods.fnSave(UserID, RoleID, MonthVal, YearVal, StartDate, EndDate, fnSave_pass, fnfailed, ctrl);
                }
                else {
                    MonthVal = $(ctrl).closest("tr").attr("Month");
                    YearVal = $(ctrl).closest("tr").attr("Year");

                    $("#dvloader").show();
                    PageMethods.fnSave(UserID, RoleID, MonthVal, YearVal, StartDate, EndDate, fnSave_pass, fnfailed, ctrl);
                }                
            }
        }
        function fnSave_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                if ($(ctrl).closest("tr").attr("flgEdit") == "1")
                    AutoHideAlertMsg("Detail saved successfully !");
                else
                    AutoHideAlertMsg("Details updated successfully !");

                fnGetReport();
            }
            else {
                fnfailed();
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

        select {
            width: 90%;
        }

        input[type='text'] {
            width: 100%;
        }

        .custom-tooltip {
            cursor: pointer;
        }

        table.cls-Report th,
        table.cls-Report td {
            text-align: center;
            vertical-align: middle !important;
        }

        table.cls-Report tr th:nth-child(1) {
            width: 10%;
        }

        table.cls-Report tr th:nth-child(2),
        table.cls-Report tr th:nth-child(4) {
            width: 20%;
        }

        table.cls-Report tr td:nth-child(3) span {
            font-weight: bold;
            margin: 0 10px;
        }

        table.cls-Report tr td:nth-child(3) input[type='text'] {
            width: 120px;
            border: 1px solid #ddd;
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
    <h4 class="middle-title" id="Heading">EXTEND CREATION DATE - Site Channel wise SBF Priority</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-100 text-right" style="min-height: auto;">
                <a href="#" class="btn btn-primary btn-sm" id="btnAddNew" onclick="fnAddNew();" title="Add New Cluster"><i class="fa fa-plus-square"></i>&nbsp; Add New Month</a>
            </div>
        </div>
    </div>

    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active w-50" style="margin: 0 auto;">
            <div id="divHeader"></div>
            <div id="divReport"></div>
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

    <asp:HiddenField ID="hdnMonthMstr" runat="server" />
</asp:Content>
