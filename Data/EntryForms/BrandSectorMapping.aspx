<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="BrandSectorMapping.aspx.cs" Inherits="_BrandSectorMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
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
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#divFooter").height() + 160));

            fnGetReport();
        });

        function fntypefilter() {
            var flgtr = 0;
            var filter = ($("#txtfilter").val()).toUpperCase();

            $("#tblReport").find("tbody").eq(0).find("tr").css("display", "none");
            $("#tblReport").find("tbody").eq(0).find("tr").each(function () {
                if ($(this)[0].innerText.toUpperCase().indexOf(filter) > -1) {
                    $(this).css("display", "table-row");
                    flgtr = 1;
                }
            });

            if (flgtr == 0) {
                $("#divHeader").hide();
                $("#divReport").hide();
                $("#divMsg").html("No Records found for selected Filters !");
            }
            else {
                $("#divHeader").show();
                $("#divReport").show();
                $("#divMsg").html('');
            }
        }

        function fnGetReport() {
            $("#txtfilter").val('');

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();

            $("#dvloader").show();
            PageMethods.fnGetReport(fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                $("#tblReport").css("width", wid);
                $("#tblReport").css("min-width", wid);
                for (i = 0; i < $("#tblReport").find("th").length; i++) {
                    var th_wid = $("#tblReport").find("th")[i].clientWidth;
                    $("#tblReport_header").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport_header").find("th").eq(i).css("width", th_wid);
                    $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport").find("th").eq(i).css("width", th_wid);
                }
                $("#tblReport").css("margin-top", "-" + $("#tblReport_header")[0].offsetHeight + "px");
                Tooltip(".clsInform");

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
                fnfailed();
            }
        }

        function fnSaveMapping() {
            var Arr = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();

            var brand = "";
            $("#tblReport").find("tbody").eq(0).find("input[type='checkbox']:checked").each(function () {
                if (brand == "" && $(this).closest("tr").find("td").eq(2).find("input").eq(0).val() != "") {
                    Arr.push({
                        "col1": $(this).closest("tr").find("td").eq(2).find("input").eq(0).val(),
                        "col2": "",
                        "col3": $(this).closest("tr").attr("strid"),
                        "col4": "0"
                    });
                }
                else
                    brand = $(this).closest("tr").find("td").eq(1).html();
            });

            if (brand != "") {
                AutoHideAlertMsg("Please enter the Sector Name for Brand - " + brand + " !");
                return false;
            }
            else if (Arr.length == 0) {
                AutoHideAlertMsg("Please Select the Brand(s) for Mapping  !");
                return false;
            }
            else {
                $("#dvloader").show();
                PageMethods.fnSaveMapping(Arr, LoginID, RoleID, UserID, fnSaveMapping_pass, fnfailed);
            }
        }

        function fnSaveMapping_pass(res) {
            if (res.split("|^|")[0] == "0") {
                AutoHideAlertMsg("Brand-Sector mapped successfully !");
                fnGetReport();
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnUpdateButtonStatus() {
            if ($("#tblReport").find("tbody").eq(0).find("input[type='checkbox']:checked").length > 0) {
                $("#btnSaveMapping").attr("onclick", "fnSaveMapping();");
                $("#btnSaveMapping").removeClass("btn-secondary").addClass("btn-primary");
            }
            else {
                $("#btnSaveMapping").removeAttr("onclick");
                $("#btnSaveMapping").removeClass("btn-primary").addClass("btn-secondary");
            }
        }
        function fnChkAll() {
            if ($("#chkAll").is(":checked")) {
                $("#tblReport").find("tbody").eq(0).find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $("#tblReport").find("tbody").eq(0).find("input[type='checkbox']").removeAttr("checked");
            }

            fnUpdateButtonStatus();
        }
        function fnChk(ctrl) {
            $("#chkAll").removeAttr("checked");
            fnUpdateButtonStatus();
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
    </style>
    <style type="text/css">
        #divReport {
            overflow-y: auto;
        }

            #divReport img {
                cursor: pointer;
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
        #tblReport_header th {
            text-align: center;
        }

        table.clsReport tr td:nth-child(1) {
            width: 5%;
            text-align: center;
        }

        table.clsReport tr td:nth-child(2) {
            width: 40%;
        }

        table.clsReport tr td:nth-child(3) {
            width: 60%;
        }

            table.clsReport tr td:nth-child(3) input {
                width: 99%;
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
                text-align: left;
                border-bottom: 2px solid #003DA7 !important;
            }

                .customtooltip table > thead > tr > th,
                .customtooltip table > tbody > tr > td {
                    font-size: .62rem;
                    padding: .1rem .3rem;
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
    <h4 class="middle-title" id="Heading">Brand-Sector Mapping</h4>
    <div class="fsw" id="Filter" style="margin: 0 auto; width: 60%;">
        <div class="fsw_inner">
            <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 100%;">
                <div class="fsw-title">Search Box</div>
                <div class="d-block">
                    <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Type atleast 3 characters .." />
                </div>
            </div>
        </div>
    </div>

    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active" style="margin: 0 auto; width: 60%;">
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divButtons" style="width: 100%; display: inline-block; text-align: right; padding-right: 30px;">
            <a id="btnSaveMapping" class="btn btn-secondary btn-sm" href="#">Save Brand-Sector Mapping</a>
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
</asp:Content>
