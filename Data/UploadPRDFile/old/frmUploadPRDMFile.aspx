<%@ Page Title="" Language="VB" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="false" CodeFile="frmUploadPRDMFile.aspx.vb" Inherits="Data_Upload_frmUploadPRDMFile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('input[type="file"]').change(function (e) {
                var fileName = e.target.files[0].name;
                $('.custom-file-label').html(fileName);
            });
        });
        function fnValidateFile() {
            var fileUpload = $("#ConatntMatter_FileUpload1").get(0);
            var files = fileUpload.files;
            var allowedExtensions = "";
            allowedExtensions = /(\.csv)$/i;
            if (files.length == 0) {
                alert("Please select the file!!!!");
                return false;
            }
            if (!allowedExtensions.exec($("#ConatntMatter_FileUpload1").val())) {
                alert('Please upload only csv file');
                fileUpload.value = '';
                return false;
            }

            document.getElementById("ConatntMatter_btnRead").click();
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div class="row mt-5">
        <div class="col-4 offset-3">
            <div class="custom-file">
                <asp:FileUpload ID="FileUpload1" runat="server" CssClass="custom-file-input" />
                <label class="custom-file-label" for="validatedCustomFile">Choose file...</label>
            </div>
        </div>
        <div class="col-2">
            <input type="button" id="btnImportFile" class="btn btn-primary btn-sm" value="Upload" onclick="fnValidateFile()" />
        </div>
    </div>
    <div style="text-align:center; color:red;">
         <asp:Label ID="lblMsg" runat="server" ></asp:Label>
    </div>
    <asp:Button ID="btnRead" CssClass="button" runat="server" Style="visibility: hidden" Text="Import File" />
   
</asp:Content>

