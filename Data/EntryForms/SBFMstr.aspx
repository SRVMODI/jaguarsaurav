<%@ Page Title="" Language="C#"  MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true"
    CodeFile="SBFMstr.aspx.cs" Inherits="_BucketMstr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
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
        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

        $(document).ready(function () {
            ht = $(window).height();
            $("#divReport").height(ht - ($("#dvBanner").height() + $("div.clsfilter").height() + 140));
            $("div.mainpanel").css("margin-top", $("#dvBanner").height());
            fnGetReport();
        });
        function fnGetReport() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            var ProdLvl = "40";

            $("#dvloader").show();
            PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, 1, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#divReport").find("table").eq(0).width();
                var thead = $("#divReport").find("table").eq(0).find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='clstable clsReport' style='margin-top:-4px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                $("#divReport").find("table").eq(0).css("width", wid);
                $("#divReport").find("table").eq(0).css("min-width", wid);
                for (i = 0; i < $("#divReport").find("table").eq(0).find("th").length; i++) {
                    var th_wid = $("#divReport").find("table").eq(0).find("th")[i].clientWidth;
                    $("#tblReport_header").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport_header").find("th").eq(i).css("width", th_wid);
                    $("#divReport").find("table").eq(0).find("th").eq(i).css("min-width", th_wid);
                    $("#divReport").find("table").eq(0).find("th").eq(i).css("width", th_wid);
                }
                $("#divReport").find("table").eq(0).css("margin-top", "-" + $("#tblReport_header")[0].offsetHeight + "px");

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnSave(flg) {
            var ParentId = "";
            var ParentType = "";
            var Code = "";
            var Descr = "";

            if (flg == 1) {         //BF
                if ($("#txtBFCode").val() == "") {
                    alert("Please enter the BrandForm code !");
                    return false;
                }
                else if ($("#txtBFName").val() == "") {
                    alert("Please enter the BrandForm name !");
                    return false;
                }
                else if ($("#txtBrand").attr("sel") == "") {
                    alert("Please select the Brand !");
                    return false;
                } 

                ParentId = $("#txtBrand").attr("sel").split("^")[0];
                ParentType = $("#txtBrand").attr("sel").split("^")[1];
                Code = $("#txtBFCode").val();
                Descr = $("#txtBFName").val();
            }
            else {                   //SBF
                if ($("#txtSBFCode").val() == "") {
                    alert("Please enter the SubBrandForm code !");
                    return false;
                }
                else if ($("#txtSBFName").val() == "") {
                    alert("Please enter the SubBrandForm name !");
                    return false;
                }
                else if ($("#txtBrandForm").attr("sel") == "") {
                    alert("Please select the BrandForm !");
                    return false;
                }

                ParentId = $("#txtBrandForm").attr("sel").split("^")[0];
                ParentType = $("#txtBrandForm").attr("sel").split("^")[1];
                Code = $("#txtSBFCode").val();
                Descr = $("#txtSBFName").val();
            }

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            $("#dvloader").show();
            PageMethods.fnSave(ParentId, ParentType, Code, Descr, LoginID, UserID, RoleID, UserNodeID, UserNodeType, fnSave_pass, fnfailed, flg);
        }
        function fnSave_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1].split("^")[0] == "-1") {
                    $("#dvloader").hide();
                    alert("Code already exist !");
                }
                else {
                    if (flg == 1) {
                        alert("BrandForm added successfully !");
                        $("#divBFPopup").dialog('close');

                        $("#txtBrandForm").val(res.split("|^|")[2].toString().substr(0, res.split("|^|")[2].toString().length - 1));
                        $("#txtBrandForm").attr("sel", res.split("|^|")[1]);
                        $("#ConatntMatter_hdnBrand").val(res.split("|^|")[3]);
                        $("#dvloader").hide();
                    }
                    else {
                        alert("SubBrandForm added successfully !");
                        $("#divSBFPopup").dialog('close');

                        $("#ConatntMatter_hdnBrandForm").val(res.split("|^|")[3]);
                        fnGetReport();
                    }
                }
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnAddNewSBF() {
            $("#txtBrandForm").attr("sel", "");
            $("#txtBrandForm").val("");
            $("#txtSBFCode").val("");
            $("#txtSBFName").val("");

            fnShowSBFPopup();
        }
        function fnShowSBFPopup() {
            $("#divSBFPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "420",
                "title": "SubBrandForm :",
                buttons: {
                    "Add New SubBrandForm": function () {
                        fnSave(2);
                    },
                    "Cancel": function () {
                        $("#divSBFPopup").dialog('close');
                    }
                }
            });
        }

        function fnAddNewBrandForm() {
            $("#txtBrand").attr("sel", "");
            $("#txtBrand").val("");
            $("#txtBFCode").val("");
            $("#txtBFName").val("");

            fnShowBFPopup();
        }
        function fnShowBFPopup() {
            $("#divBFPopup").dialog({
                "modal": true,
                "width": "46%",
                "height": "420",
                "title": "SubBrandForm :",
                buttons: {
                    "Add New BrandForm": function () {
                        fnSave(1);
                    },
                    "Cancel": function () {
                        $("#divBFPopup").dialog('close');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function fntypefilter() {
            var flgtr = 0;
            var filter = $("#txtfilter").val().toUpperCase().split(",");
            if ($("#txtfilter").val().length > 2) {
                $("#divReport").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");
                $("#divReport").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
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
            else {
                $("#divHeader").show();
                $("#divReport").show();
                $("#divMsg").html('');
                $("#divReport").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnPopupTypeSearch(ctrl) {
            var filter = $(ctrl).val().toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "none");
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnRemoveSelection(ctrl) {
            $(ctrl).attr("sel", "");
        }

        function fnSelectProd(ctrl) {
            var nid = $(ctrl).attr("nid");
            var ntype = $(ctrl).attr("ntype");
            var str = $(ctrl).find("td:last").html();

            $(ctrl).closest("div.clsPopup").prev().val(str);
            $(ctrl).closest("div.clsPopup").prev().attr("sel", nid + "^" + ntype);
            fnHidePopup();
        }

        function fnShowPopup(ctrl, cntr) {
            $("#bg").show();
            $(ctrl).next("div.clsPopup").eq(0).show();

            if (cntr == 1) {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrand").val().split("|^|")[1]);
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrandForm").val().split("|^|")[1]);
            }

            if ($(ctrl).val() != "")
                fnPopupTypeSearch(ctrl);
        }
        function fnHidePopup() {
            $("#bg").hide();
            $("div.clsPopup").hide();
        }
    </script>

    <style type="text/css">
        h4 {
            margin: 0;
            font-size: 17px;
            padding: 0 0 10px 0;
            background-color: rgba(31, 164, 249, 0.48);
            color: White;
            font-weight: bold;
            padding-top: 5px;
            padding-left: 5px;
            text-shadow: 2px 2px 2px #333333;
            filter: progid:DXImageTransform.Microsoft.DropShadow(offX=2,offY=2,color=333333);
        }

        table {
            width: 100%;
        }

        .clstxt,
        .clsddl {
            width: 98%;
            padding: 3px;
            border-radius: 3px;
            box-sizing: border-box;
        }

        .buttonBlue {
            white-space: nowrap;
        }

        .clsfilter {
            margin-bottom: 10px;
            padding: 0 10px 4px;
            background: #efefef;
            box-sizing: border-box;
            border-bottom: 2px solid #ddd;
        }

        .clslbl {
            color: #777;
            font-size: 0.8rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .clslnk {
            color: #0080C0 !important;
            font-size: 0.66rem;
            font-weight: 700;
            text-decoration: underline;
        }

        .clsMsg {
            padding: 10px;
            color: #ff0000;
            font-size: 0.9rem;
            font-weight: 700;
        }

        .button1 {
            padding: 3px 30px !important;
            border-radius: 6px !important;
            border: 1px solid #273E88;
        }

        .clsProdContainer {
            float: left;
            display: inline-block;
            box-sizing: border-box;
            border: 1px solid #696969;
        }

        .clsProdHeader {
            color: #ffffff;
            padding: 5px 10px;
            background: #696969;
            border-radius: 4px 4px 0 0;
        }

        #divReport {
            padding: 0 0 10px 0;
            overflow-y: auto;
            overflow-x: hidden;
        }
    </style>
    <style type="text/css">
        table.clstable {
            width: 100%;
            border-collapse: collapse;
        }

            table.clstable th {
                color: #495057;
                padding: .8rem 0;
                font-weight: 700;
                font-size: 0.76rem;
                text-align: center;
                background: #EEF0F2;
                border: 1px solid #DEE2E6;
            }

            table.clstable td {
                padding: .4rem 0;
                font-size: 0.72rem;
                text-align: left;
                padding-left: 5px;
                border: 1px solid #DEE2E6;
            }

            table.clstable tr td:nth-child(1) {
                text-align: center;
            }

        table.clsReport tr td.clstdAction img {
            height: 14px;
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <div id="bg" style="position: fixed; z-index: 10; top: 0; left: 0; background-color: transparent; width: 100%; height: 100%; display: none;" onclick="fnHidePopup()"></div>
    <div id="dvloader" style="position: fixed; z-index: 9999; top: 0; left: 0; opacity: .80; -moz-opacity: 0.8; filter: alpha(opacity=80); background-color: #ccc; width: 100%; height: 100%; text-align: center;">
        <img alt="Loading..." title="Loading..." src="../Imgs/loading.gif" style="margin-top: 20%;" />
    </div>
    <h4>Product Master : </h4>
    <div class="clsfilter">
        <table>
            <tr>
                <td>
                    <input id="txtfilter" type="text" class="clstxt" onkeyup="fntypefilter();" placeholder="Type atleast 3 character to filter..." style="width: 400px" />
                </td>
                <td style="width: 150px; text-align: right;">
                    <a class="buttonBlue" href="#" onclick="fnAddNewSBF();">Add New SubBrandForm</a>
                </td>
            </tr>
        </table>
    </div>
    <div id="divHeader" style="width: 60%; margin: 0 auto;"></div>
    <div id="divReport" style="width: 60%; margin: 0 auto;"></div>
    <div id="divMsg" class="clsMsg" style="color: #aaa;"></div>
    <div id="divSBFPopup" style="display: none;">
        <div>
            <table>
                <tr>
                    <td class="clslbl">SBF Code :</td>
                    <td>
                        <input type="text" class="clstxt" id="txtSBFCode" style="width: 60%;" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td class="clslbl">SBF Name :</td>
                    <td>
                        <input type="text" class="clstxt" id="txtSBFName" /></td>
                    <td></td>
                </tr>
                <tr>
                    <td class="clslbl">BrandForm :</td>
                    <td>
                        <div style="position: relative;">
                            <input id="txtBrandForm" type="text" class="clstxt" sel="" autocomplete="off" onclick="fnShowPopup(this, 2)" onkeyup="fnPopupTypeSearch(this);" onchange="fnRemoveSelection(this);" placeholder="Type atleast 3 character to filter..." />
                            <div class="clsPopup">
                                <%--<div class="clsPopupTypeSearch clsPopupSec">
                                    <input type="text" onkeyup="fnPopupTypeSearch(this);" placeholder="Type atleast 3 character to filter..." style="width: 96%;" />
                                </div>--%>
                                <div class="clsPopupBody clsPopupSec" style="padding: 0;"></div>
                                <div class="clsPopupFooter clsPopupSec">
                                    <a class="button1" href="#" onclick="fnHidePopup();">Close</a>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td style="text-align: center;">
                        <a href="#" class="clslnk" onclick="fnAddNewBrandForm();">Add BrandForm</a></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="divBFPopup" style="display: none;">
        <div>
            <table>
                <tr>
                    <td class="clslbl">BrandForm Code :</td>
                    <td>
                        <input type="text" class="clstxt" id="txtBFCode" style="width: 60%;" /></td>
                </tr>
                <tr>
                    <td class="clslbl">BrandForm Name :</td>
                    <td>
                        <input type="text" class="clstxt" id="txtBFName" /></td>
                </tr>
                 <tr>
                    <td class="clslbl">Brand :</td>
                    <td>
                        <div style="position: relative;">
                            <input id="txtBrand" type="text" class="clstxt" sel="" autocomplete="off" onclick="fnShowPopup(this, 1)" onkeyup="fnPopupTypeSearch(this);" onchange="fnRemoveSelection(this);" placeholder="Type atleast 3 character to filter..." style="width: 410px;"/>
                            <div class="clsPopup">
                                <%--<div class="clsPopupTypeSearch clsPopupSec">
                                    <input type="text" onkeyup="fnPopupTypeSearch(this);" placeholder="Type atleast 3 character to filter..." style="width: 96%;" />
                                </div>--%>
                                <div class="clsPopupBody clsPopupSec" style="padding: 0;"></div>
                                <div class="clsPopupFooter clsPopupSec">
                                    <a class="button1" href="#" onclick="fnHidePopup();">Close</a>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />

    <asp:HiddenField ID="hdnBrand" runat="server" />
    <asp:HiddenField ID="hdnBrandForm" runat="server" />
</asp:Content>
