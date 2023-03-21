<%@ Page Title="" Language="VB" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="false" CodeFile="frmUploadPRDMFile.aspx.vb" Inherits="Data_Upload_frmUploadPRDMFile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .popup-dialog-bg {
            background: rgba(0,0,0,.5);
            position: fixed;
            content: "";
            z-index: 90;
            height: 100%;
            width: 100%;
            top: 0px;
            bottom: 0px;
            left: 0px;
            right: 0px;
            /*opacity: 0.5;
            filter: alpha(opacity=0.5);*/
        }

        .popup-dialog {
            position: absolute;
            width: 900px;
            max-width: 80%;
            height: 450px;
            left: 50%;
            top: 50%;
            margin-top: -200px;
            margin-left: -450px;
            display: block;
            background: #fff;
            border: 1px solid #999;
            border-radius: 6px;
            z-index: 99;
        }

        .popup-dialog-header {
            padding: 15px;
            border-bottom: 1px solid #e5e5e5;
        }

            .popup-dialog-header .close {
                float: right;
                font-size: 30px;
                font-weight: bold;
                line-height: 1;
                color: #000;
                text-shadow: 0 1px 0 #fff;
                filter: alpha(opacity=20);
                opacity: .2;
                cursor: pointer;
                margin-top: -5px;
            }

            .popup-dialog-header .popup-title {
                margin: 0;
                line-height: 1.42857143;
                font-size: 1rem;
                font-weight: 600;
            }

        .popup-dialog-body {
            position: relative;
            padding: 15px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $('input[type="file"]').change(function (e) {
                var fileName = e.target.files[0].name;
                $('.custom-file-label').html(fileName);
            });

            //$("#tblbrand-popup").dialog({
            //    title: "Brand Name",
            //    resizable: false,
            //    width: "75%",
            //    height: "400",
            //    modal: true
            //});
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

    <script>
        function fnSaveSubBrand() {
            var ArrDataSaving = [];
            // debugger;
            $("#ConatntMatter_dvSubBrandName").find("#tblMain tbody tr").each(function () {
                if ($(this).find("#ddlSubBrandForm").val() != 'NA') {

                    var ddlSubBrandForm = $(this).find("#ddlSubBrandForm option:selected").text();
                    var PrdType = "SBF";
                    var SBFNodeId = $(this).attr("NodeId")
                    var SBFNodeType = $(this).attr("NodeType")

                    ArrDataSaving.push({ PrdName: ddlSubBrandForm, PrdType: PrdType, NodeID: SBFNodeId, NodeType: SBFNodeType });
                }
            });

            if (ArrDataSaving.length == 0) {
                alert("Kindly Select the data from the drop down")
                return false;
            }

            $("#dvloader").show();

            PageMethods.fnSaveSubBrand(ArrDataSaving, fnSave_Success, fnFailed);
        }


        function fnSave_Success(result) {
            $("#dvloader").hide();
            if (result.split("^")[0] == "1") {
                alert("Saved successfully");
                fnClose();

            }
            else {
                alert("Some techical error. " + result.split("^")[1]);
            }

        }
        function fnFailed(result) {
            alert("Oops! Something went wrong. Please try again.");
            $("#dvloader").hide();
        }
      
    </script>
    <script>
        function fnClose(){
            // alert("here")
            $("#ConatntMatter_lblMsg").html("");
            $("#ConatntMatter_tblbrandpopup").hide();
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
        <div style="text-align: center; color: green;">
        <asp:Label ID="lblMsg" runat="server"></asp:Label>
    </div>

    <div id="tblbrandpopup" class="popup-dialog-bg" style="display: none;" runat="server">
        <div class="popup-dialog">
            <div class="popup-dialog-header"><span class="popup-title">Title</span><span class="close" title="Close" onclick="fnClose()" style="cursor:pointer">×</span></div>
            <div class="popup-dialog-body">
                <div id="dvSubBrandName" runat="server" class="clearfix" style="overflow-y: auto;height:336px;"></div>
                <div class="text-center">
                    <input type="button" id="btnSaveSubBrand" class="btn btn-primary btn-sm" value="Save" onclick="fnSaveSubBrand()" />
                </div>
            </div>
        </div>
    </div>

    <asp:Button ID="btnRead" CssClass="button" runat="server" Style="visibility: hidden" Text="Import File" />

</asp:Content>

