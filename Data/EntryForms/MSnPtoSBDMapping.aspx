<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="MSnPtoSBDMapping.aspx.cs" Inherits="_MSnPtoSBDMapping" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
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

        $(document).ready(function () {
            $("#ddlUser").html($("#ConatntMatter_hdnUser").val());
            $("#ddlUser").val($("#ConatntMatter_hdnSelectedUser").val());
        });

        function fnMappedUser() {
            var UserID = $("#ddlUser").val();
            var LoginID = $("#ConatntMatter_hdnLoginID").val();

            if (UserID == "0") {
                AutoHideAlertMsg("Please Select the User !");
            }
            else {
                $("#dvloader").show();
                PageMethods.MappedUser(LoginID, UserID, MappedUser_pass, fnfailed);
            }
        }
        function MappedUser_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                AutoHideAlertMsg("User mapped successfully !");
            }
            else
                fnfailed();
        }
        function fnfailed() {
            AutoHideAlertMsg("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading">MS&P to SBD & FB Mapping</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-100">
                <div class="row">
                    <div class="col-4" style="padding-right: 0;">
                        <div class="fsw-title">MS&P User </div>
                        <div class="d-block">
                            <select id="ddlUser" class="form-control form-control-sm" style="width: 320px;"></select>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="fsw-title">&nbsp;</div>
                        <div class="d-block">
                            <a href='#' onclick="fnMappedUser();" class="btn btn-primary btn-sm">Mapped User to SBD & FB</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divMsg" runat="server"></div>
    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    
    <asp:HiddenField ID="hdnUser" runat="server" />
    <asp:HiddenField ID="hdnSelectedUser" runat="server" />
</asp:Content>

