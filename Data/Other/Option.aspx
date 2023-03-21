<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="Option.aspx.cs" Inherits="_BucketMstr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $(".middile-aligned").css({
                "margin-top": ($(".main-box").height() - $(".middile-aligned").outerHeight()) / 2 + "px"
            });
        });
        function fnBucket() {
            window.location.href = '../EntryForms/BucketMstr.aspx';
        }
		function fnInitiative() {
            window.location.href = '../EntryForms/Initiative.aspx';
        }
        function fnSubBrandForm() {
            window.location.href = '../EntryForms/SBFMstr.aspx';
        }
        function fnRoleManagement() {
            window.location.href = '../MasterForms/frmRoleAddEdit.aspx';
        }
        function fnUserManagement() {
            window.location.href = '../MasterForms/frmUserAddEdit.aspx';
        }
        function fnComingSoon() {
            alert("Coming Soon !");
        }
    </script>
    <style type="text/css">
        
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="middile-aligned">
        <div class="row absolute-center">
            <div class="col-3">
                <div class="btn-one fit" onclick="fnBucket();">Manage Buckets</div>
            </div>
            <div class="col-3">
                <div class="btn-one fit" onclick="fnSubBrandForm();">Manage SubBrandForm</div>
            </div>
            <div class="w-100"></div>
            <div class="col-3">
                <div class="btn-one fit" onclick="fnInitiative();">Manage Initiatives</div>
            </div>

            <div class="col-3">
                <div class="btn-one fit" onclick="fnComingSoon();">Generate Extracts</div>
            </div>
            <div class="w-100"></div>
            <div class="col-3">
                <div class="btn-one fit" onclick="fnRoleManagement();">Manage Roles</div>
            </div>
            <div class="col-3">
                <div class="btn-one fit" onclick="fnUserManagement();">Manage Users</div>
            </div>
            <div class="w-100"></div>
            <div class="col-3">
                <div class="btn-one fit" onclick="fnComingSoon();">Reports</div>
            </div>


        </div>
    </div>
    <asp:HiddenField ID="hdnLoginID" runat="server" />
</asp:Content>

