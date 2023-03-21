<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="frmDashboard.aspx.cs" Inherits="Data_Other_frmDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ht = 0;
        $(document).ready(function () {
            ht = $(window).height();
            
            $('.main-box').css({
                "position": "relative",
                "background": "none",
                "max-width": "1140px"
            });
            $(".txt-middle").css({
                "margin-top": ($(window).height() - ($(".txt-middle").outerHeight() + $("nav.navbar").outerHeight())) / 2 + "px"
            });

            //alert($("#ConatntMatter_hdnRoleID").val());
            $("#ddlMonth").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonth").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);

            $("#ddlMSMPAlies").html($("#ConatntMatter_hdnMSMPAlies").val());
            if ($("#ConatntMatter_hdnRoleID").val() == "1" || $("#ConatntMatter_hdnRoleID").val() == "2" || $("#ConatntMatter_hdnRoleID").val() == "4") {
                $("#MSMPFilterBlock").show();
                $("#ddlMSMPAlies").multiselect({
                    noneSelectedText: "--Select--"
                }).multiselectfilter();

                //$("#ddlMSMPAlies").next().css({
                //    "height": "calc(1.5em + .5rem + 2px)",
                //    "font-size": "0.8rem",
                //    "font-weight": "400",
                //    "width": "260",
                //    "padding": ".25rem .5rem",
                //    "border-radius": ".2rem",
                //    "border-color": "#ced4da"
                //});
                //$("#ddlMSMPAlies").next().find("span.ui-icon").eq(0).css({
                //    "margin": ".2rem",
                //    "margin-bottom": "0",
                //    "background-color": "transparent",
                //    "border": "none"
                //});
            }
            else {
                $("#MSMPFilterBlock").hide();
            }            

            fnGetTableData();
        });

        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        function fnGetTableData() {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var NodeID = $("#ConatntMatter_hdnNodeID").val();
            var NodeType = $("#ConatntMatter_hdnNodeType").val();
            var FromDate = $("#ddlMonth").val().split("|")[0];
            var EndDate = $("#ddlMonth").val().split("|")[1];
            var ArrUser = [];
            if ($("#ConatntMatter_hdnRoleID").val() == "1" || $("#ConatntMatter_hdnRoleID").val() == "2" || $("#ConatntMatter_hdnRoleID").val() == "4") {
                for (var i = 0; i < $("#ddlMSMPAlies option:selected").length; i++) {
                    ArrUser.push({ "col1": $("#ddlMSMPAlies option:selected").eq(i).val() });
                }
            }
            if (ArrUser.length == 0)
                ArrUser.push({"col1" : 0});

            $("#dvloader").show();
            PageMethods.fnGetTableData(LoginID, UserID, RoleID, NodeID, NodeType, FromDate, EndDate, ArrUser, fnGetTableData_pass, fnfailed);
        }
        function fnGetTableData_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                //var wid = $("#tblReport").width();
                //var thead = $("#tblReport").find("thead").eq(0).html();
                //$("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-top:100px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                //$("#tblReport").css("width", wid);
                //$("#tblReport").css("min-width", wid);
                //for (i = 0; i < $("#tblReport").find("th").length; i++) {
                //    var th_wid = $("#tblReport").find("th")[i].clientWidth;
                //    $("#tblReport_header").find("th").eq(i).css("min-width", th_wid);
                //    $("#tblReport_header").find("th").eq(i).css("width", th_wid);
                //    $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                //    $("#tblReport").find("th").eq(i).css("width", th_wid);
                //}
                //$("#tblReport").css("margin-top", "-" + $("#tblReport_header")[0].offsetHeight + "px");

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
    </script>
    <style type="text/css">
        table.tbl_report {
            width: 100%;
            margin-bottom: 1rem;
            background-color: transparent;
            border-collapse: collapse;
            border: 2px solid #393938;
        }

            table.tbl_report thead th {
                vertical-align: bottom;
                border-bottom: 2px solid #393938;
                color:#FFF;
                text-transform:uppercase;
            }

            table.tbl_report td, 
            table.tbl_report th {
                padding: .35rem;
                vertical-align: top;
                text-align:center;
            }
            table.tbl_report thead th,
            table.tbl_report tbody td{                
                border-left: 1px solid #393938;
                border-right: 1px solid #393938;
            }
            table.tbl_report thead th:nth-child(1){
                background:#A71380;
            }
            table.tbl_report thead th:nth-child(2){
                background:#008AD2;
            }
            table.tbl_report thead th:nth-child(3){
                background:#AECB06;
            }
            
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox" style="width: 100%;">
                <div class="row">
                    <div class="col-2">
                        <div class="fsw-title">Month</div>
                        <div class="form-row">
                            <select id="ddlMonth" class="form-control form-control-sm" onchange="fnGetReport(0);"></select>
                        </div>
                    </div>
                    <div class="col-3" id="MSMPFilterBlock">
                        <div class="fsw-title">MS&amp;P ALIAS</div>
                        <div class="d-block">
                            <select id="ddlMSMPAlies" multiple="multiple"></select>
                        </div>
                    </div>
                    <div class="col-5">
                        <a class="btn btn-primary btn-sm mt-4" href="#" onclick="fnGetTableData();" title="Show Filtered Bucket(s)">Show Report</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divReport"></div>
    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div class="clear"></div>
    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMainRoleID" runat="server" />

    <asp:HiddenField ID="hdnMonths" runat="server" />
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />
    <asp:HiddenField ID="hdnDashboardData" runat="server" />
</asp:Content>
