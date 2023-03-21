<%@ Page Title="" Language="VB" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="false" CodeFile="frmGetBrandCategory.aspx.vb" Inherits="Data_EntryForms_frmGetBrandCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function fnSaveBrand() {
            var ArrDataSaving = [];
            $("#ConatntMatter_dvBrandName").find("#tblMain tbody tr").each(function () {
                if ($(this).find("#ddlBrandForm").val() > 0)
                {

                    var ddlBrandForm = $(this).find("#ddlBrandForm option:selected").text();
                    var PrdType = "BF";
                    var BFNodeId = $(this).attr("BFNodeId")
                    var BFNodeType = $(this).attr("BFNodeType")

                    ArrDataSaving.push({ PrdName: ddlBrandForm, PrdType: PrdType, NodeID: BFNodeId, NodeType: BFNodeType });
                }
            });

            if (ArrDataSaving.length == 0) {
              //  alert("Kindly Select the data from the drop down")
                //if (window.confirm("You have not mapped anything! Are you sure you want to Save?"))
                //{
                //    var ddlBrandForm = "";
                //    var PrdType = "BF";
                //    var BFNodeId = "0";//$(this).attr("BFNodeId")
                //    var BFNodeType = "0"; //$(this).attr("BFNodeType")
                //    ArrDataSaving.push({ PrdName: ddlBrandForm, PrdType: PrdType, NodeID: BFNodeId, NodeType: BFNodeType });
                //}
                //else
                //{
                //    return false;
                //}


                $("#dvDialog").html("You have not mapped anything! Are you sure you want to Save?");
                $("#dvDialog").dialog({
                    modal: true,
                    title: "Alert",
                    width: '40%',
                    maxHeight: 'auto',
                    minHeight: 150,
                    buttons: {
                        "Yes": function () {
                            var ddlBrandForm = "";
                            var PrdType = "BF";
                            var BFNodeId = "0";//$(this).attr("BFNodeId")
                            var BFNodeType = "0"; //$(this).attr("BFNodeType")
                            ArrDataSaving.push({ PrdName: ddlBrandForm, PrdType: PrdType, NodeID: BFNodeId, NodeType: BFNodeType });
                            $("#dvloader").show();
                            PageMethods.fnSaveBrand(ArrDataSaving, fnSave_Success, fnFailed);
                        },
                        "No": function () {
                            $(this).dialog("close");
                        }
                    }
                });
             
            }
            else

            {
                $("#dvloader").show();

                PageMethods.fnSaveBrand(ArrDataSaving, fnSave_Success, fnFailed);
            }
               
           
        }


        function fnSaveSubBrand() {
            var ArrDataSaving = [];
            $("#ConatntMatter_dvSubBrandName").find("#tblMain tbody tr").each(function () {
                if ($(this).find("#ddlSubBrandForm").val() > 0) {

                    var ddlSubBrandForm = $(this).find("#ddlSubBrandForm option:selected").text();
                    var PrdType = "SBF";
                    var SBFNodeId = $(this).attr("SBFNodeId")
                    var SBFNodeType = $(this).attr("SBFNodeType")

                    ArrDataSaving.push({ PrdName: ddlSubBrandForm, PrdType: PrdType, NodeID: SBFNodeId, NodeType: SBFNodeType });
                }
            });

            if (ArrDataSaving.length == 0)
            {
                /* if (window.confirm("You have not mapped anything! Are you sure you want to Save?")) {
                    var ddlSubBrandForm = "";
                     var PrdType = "SBF";
                     var SBFNodeId = "0";//$(this).attr("BFNodeId")
                     var SBFNodeType = "0"; //$(this).attr("BFNodeType")
                     ArrDataSaving.push({ PrdName: ddlSubBrandForm, PrdType: PrdType, NodeID: SBFNodeId, NodeType: SBFNodeType });
                 }
                 else {
                     return false;
                 }*/
                
                $("#dvDialog").html("You have not mapped anything! Are you sure you want to Save?");
                $("#dvDialog").dialog({
                    modal: true,
                    title: "Alert",
                    width: '40%',
                    maxHeight: 'auto',
                    minHeight: 150,
                    buttons: {
                        "Yes": function () {
                            var ddlSubBrandForm = "";
                            var PrdType = "SBF";
                            var SBFNodeId = "0";//$(this).attr("BFNodeId")
                            var SBFNodeType = "0"; //$(this).attr("BFNodeType")
                            ArrDataSaving.push({ PrdName: ddlSubBrandForm, PrdType: PrdType, NodeID: SBFNodeId, NodeType: SBFNodeType });
                            $("#dvloader").show();
                             PageMethods.fnSaveSubBrand(ArrDataSaving, fnSave_Success, fnFailed);
                        },
                        "No": function () {
                            $(this).dialog("close");
                        }
                    }
                });
             
            }
            else

            {
                $("#dvloader").show();

                PageMethods.fnSaveSubBrand(ArrDataSaving, fnSave_Success, fnFailed);
            }
        }

        function fnSave_Success(result) {
            $("#dvloader").hide();
            $("#dvDialog").dialog("close");
            if (result.split("^")[0] == "1") {
                alert("Saved successfully");

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
      <script type="text/javascript">
        function fnGetBrand()
        {
            PageMethods.fnGetBrandDetails(fnSuccessBrand, fnfailed1)
        }


        function fnSuccessBrand(result)
        {
           if (result.split("~")[0] == "1")
                 {
                     $("#ConatntMatter_dvBrandName")[0].innerHTML = result.split("~")[1];
                     $("#dvBrandName").show();
                }               
           
            else {
                fnfailed1();
            }
        }
        function fnfailed1() {
            alert("Due to some technical reasons, we are unable to process your request !");
         //   $("#dvloader").hide();
        }
    </script>
    <script type="text/javascript">
        function fnGetSubBrand()
        {
            PageMethods.fnGetSubBrandDetails(fnSuccess, fnfailed)
        }

        function fnSuccess(result)
        {
            if (result.split("~")[0] == "2")
            {
               // alert(result.split("~")[1])
               
               
                $("#ConatntMatter_dvSubBrandName")[0].innerHTML = result.split("~")[1];
                    $("#dvSaveSubBrand").hide();
             }
              else if (result.split("~")[0] == "1")
                 {
                $("#ConatntMatter_dvSubBrandName")[0].innerHTML = result.split("~")[1];
                    $("#dvSaveSubBrand").show();
                }               
           
            else {
                fnfailed();
            }
        }
        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
         //   $("#dvloader").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title mb-3">Brand Category</h4>
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist" id="my-tab">
        <li><a class="nav-link active" href="#brand" data-toggle="tab" onclick="fnGetBrand()">Brand Form</a></li>
        <li><a class="nav-link" href="#subbrand" data-toggle="tab" onclick="fnGetSubBrand()">Sub Brand Form</a></li>
    </ul>
    <div id="tab-content" class="tab-content pt-2">
        <!--- Tab1----->
        <div role="tabpanel" id="brand" class="tab-pane fade show active">
            <div id="dvBrandName" runat="server"></div>
            <div class="text-center">
                <input type="button" id="btnSaveBrand" onclick="fnSaveBrand()" value="Save" class="btn btn-primary btn-sm" />
            </div>
        </div>
        
        <!--- Tab2----->
        <div role="tabpanel" id="subbrand" class="tab-pane fade">
            <div id="dvSubBrandName" runat="server"></div>
            <div class="text-center" id="dvSaveSubBrand" style="display:none">
                <input type="button" id="btnSaveSubBrand" onclick="fnSaveSubBrand()" value="Save" class="btn btn-primary btn-sm" />
            </div>
        </div>
    </div>

    <!----- End Tab2-----> 
    <div id="dvloader" class="loader_bg">
        <div class="loader"></div>
    </div>
    <div id="dvDialog" style="display: none"></div>
</asp:Content>

