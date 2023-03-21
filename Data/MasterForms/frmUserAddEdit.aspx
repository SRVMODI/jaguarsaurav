<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="frmUserAddEdit.aspx.cs" Inherits="MasterForms_frmUserAddEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

        $(document).ready(function () {
            ht = $(window).height();
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + 160));

            fnGetTableData();
        });
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
                var mousey = ht - (e.pageY + $('.customtooltip').height() + 50) > 0 ? e.pageY : (e.pageY - $('.customtooltip').height() - 40);   //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }

        function fnGetTableData() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();

            $("#dvloader").show();
            PageMethods.fnGetTableData(LoginID, fnGetTableData_pass, fnfailed);
        }
        function fnGetTableData_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);
                // ------------- Fixed Header -------------------------
                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-top:-4px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
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
                // -------------- Custom Tooltip ------------------------
                Tooltip(".clsInform");

                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnAddNew() {
            var str = "";
            str += "<tr UserID='0'>";
            str += "<td></td>";
            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td><input id='chkUserActive' type='checkbox' checked='true'/></td>";
            str += "<td><select style='width:90%; box-sizing: border-box; margin-right: 1%;' onchange='fnCheckRole(this);'>" + $("#ConatntMatter_hdnMainRoleID").val() + "</select></td>";
            str += "<td><input id='chkCorpUser' type='checkbox' disabled onclick='fnSelectCorpUser(this);'/></td>";

            str += "<td><input type='checkbox' disabled onclick='fnSelectAll(this,1);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/></td>";
            str += "<td><input type='checkbox' disabled onclick='fnSelectAll(this,2);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..'/></td>";
            str += "<td><input type='checkbox' disabled onclick='fnSelectAll(this,3);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..'/></td>";
            str += "<td><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder=''/></td>";

            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td class='clstdAction'><img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
            str += "</tr>";

            if ($("#tblReport").find("tbody").eq(0).find("tr").length == 0) {
                $("#tblReport").find("tbody").eq(0).html(str);
            }
            else {
                $("#tblReport").find("tbody").eq(0).prepend(str);
            }
        }
        function fnEdit(ctrl) {            
            var UserID = $(ctrl).closest("tr").attr("UserID");
            var Name = $(ctrl).closest("tr").attr("Name");
            var EmailID = $(ctrl).closest("tr").attr("EmailID");
            var Active = $(ctrl).closest("tr").attr("Active");
            var Role = $(ctrl).closest("tr").attr("Role");
            var RoleId = $(ctrl).closest("tr").attr("RoleId");
            var CorpUser = $(ctrl).closest("tr").attr("CorpUser");
            var MSMPAlies = $(ctrl).closest("tr").attr("MSMPAlies");

            var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
            var Prodselstr = $(ctrl).closest("tr").attr("Prodselstr"); 
            var ProdLvl = Prodselstr.split('^')[0].split('|');
            if (Prodselstr == "" || Prodselstr == "0|0")
                ProdLvl = "";
            else
                ProdLvl = ProdLvl[1];

            var Locstr = $(ctrl).closest("tr").attr("Locationstr");
            var Locselstr = $(ctrl).closest("tr").attr("Locationselstr");
            var LocLvl = Locselstr.split('^')[0].split('|');
            if (Locselstr == "" || Locselstr == "0|0")
                LocLvl = "";
            else
                LocLvl = LocLvl[1];

            var Chanstr = $(ctrl).closest("tr").attr("Channelstr");
            var Chanselstr = $(ctrl).closest("tr").attr("Channelselstr");
            var ChanLvl = Chanselstr.split('^')[0].split('|');
            if (Chanselstr == "" || Chanselstr == "0|0")
                ChanLvl = "";
            else
                ChanLvl = ChanLvl[1];

            var ExtraProdstr = $(ctrl).closest("tr").attr("ExtraProdstr");
            var ExtraProdselstr = $(ctrl).closest("tr").attr("ExtraProdselstr");
            var ExtraProdLvl = ExtraProdselstr.split('^')[0].split('|');
            if (ExtraProdselstr == "" || ExtraProdselstr == "0|0")
                ExtraProdLvl = "";
            else
                ExtraProdLvl = ExtraProdLvl[1];

            $(ctrl).closest("tr").attr("Prodtooltip", $(ctrl).closest("tr").find("td").eq(6).find("span").eq(0).attr("title"));
            $(ctrl).closest("tr").attr("Locationtooltip", $(ctrl).closest("tr").find("td").eq(7).find("span").eq(0).attr("title"));
            $(ctrl).closest("tr").attr("Channeltooltip", $(ctrl).closest("tr").find("td").eq(8).find("span").eq(0).attr("title"));
            $(ctrl).closest("tr").attr("ExtraProdtooltip", $(ctrl).closest("tr").find("td").eq(9).find("span").eq(0).attr("title"));

            $(ctrl).closest("tr").find("td").eq(1).html("<input type='text' style='width:98%; box-sizing: border-box;' value='" + Name + "' />");
            $(ctrl).closest("tr").find("td").eq(2).html("<input type='text' style='width:98%; box-sizing: border-box;' value='" + EmailID + "' />");
            if (Active == "Yes") {
                $(ctrl).closest("tr").find("td").eq(3).html("<input id='chkUserActive' type='checkbox' checked='true'/>");
            }
            else {
                $(ctrl).closest("tr").find("td").eq(3).html("<input id='chkUserActive' type='checkbox'/>");
            }

            $(ctrl).closest("tr").find("td").eq(4).html("<select style='width:98%; box-sizing: border-box; margin-right: 1%;' onchange='fnCheckRole(this);'>" + $("#ConatntMatter_hdnMainRoleID").val() + "</select>");
            $(ctrl).closest("tr").find("td").eq(4).find("select").eq(0).val(RoleId);
            if (CorpUser == "1") {
                $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' onclick='fnSelectCorpUser(this);' checked/>");
            }
            else {
                $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' onclick='fnSelectCorpUser(this);'/>");
            }
            fnEnableDisableAccess(ctrl);

            if ((RoleId == "3" || RoleId == "1014" || RoleId == "4" || RoleId == "1012") && CorpUser != "1") {

                if (Prodselstr == "") { }           //Primary Product Access
                else if (Prodselstr == "0|0") {
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").eq(0).prop("checked", true);
                    fnSelectAll($(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").eq(0),1);
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").eq(0).val(Prodstr);
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").eq(0).attr("ProdLvl", ProdLvl);
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").eq(0).attr("ProdHier", Prodselstr);
                }

                if (Locselstr == "") { }           //Location Access
                else if (Locselstr == "0|0") {
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").eq(0).prop("checked", true);
                    fnSelectAll($(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").eq(0), 2);
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").eq(0).val(Locstr);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").eq(0).attr("ProdLvl", LocLvl);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").eq(0).attr("ProdHier", Locselstr);
                }


                if (Chanselstr == "") { }           //Channel Access
                else if (Chanselstr == "0|0") {
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").eq(0).prop("checked", true);
                    fnSelectAll($(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").eq(0), 3);
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").eq(0).val(Chanstr);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").eq(0).attr("ProdLvl", ChanLvl);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").eq(0).attr("ProdHier", Chanselstr);
                }

                if (ExtraProdselstr != "") {    //Sec Product Access
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").eq(0).val(ExtraProdstr);
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").eq(0).attr("ProdLvl", ExtraProdLvl);
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").eq(0).attr("ProdHier", ExtraProdselstr);
                }

            }

            $(ctrl).closest("tr").find("td").eq(10).html("<input type='text' style='width:98%; box-sizing: border-box;' value='" + MSMPAlies + "' />");
            $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");
        }
        function fnCancel(ctrl) {
            var UserID = $(ctrl).closest("tr").attr("UserID");
            if (UserID == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var Name = $(ctrl).closest("tr").attr("Name");
                var EmailID = $(ctrl).closest("tr").attr("EmailID");
                var Active = $(ctrl).closest("tr").attr("Active");
                var Role = $(ctrl).closest("tr").attr("Role");
                var RoleId = $(ctrl).closest("tr").attr("RoleId");
                var CorpUser = $(ctrl).closest("tr").attr("CorpUser");
                var MSMPAlies = $(ctrl).closest("tr").attr("MSMPAlies");

                var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
                var Prodtooltip = $(ctrl).closest("tr").attr("Prodtooltip");
                var Locstr = $(ctrl).closest("tr").attr("Locationstr");
                var Locationtooltip = $(ctrl).closest("tr").attr("Locationtooltip");
                var Chanstr = $(ctrl).closest("tr").attr("Channelstr");
                var Channeltooltip = $(ctrl).closest("tr").attr("Channeltooltip");
                var ExtraProdstr = $(ctrl).closest("tr").attr("ExtraProdstr");
                var ExtraProdtooltip = $(ctrl).closest("tr").attr("ExtraProdtooltip");

                $(ctrl).closest("tr").find("td").eq(1).html(Name);
                $(ctrl).closest("tr").find("td").eq(2).html(EmailID);
                $(ctrl).closest("tr").find("td").eq(3).html(Active);
                $(ctrl).closest("tr").find("td").eq(4).html(Role);
                if (CorpUser == 1) {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span>Yes</span>");
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span>No</span>");
                }

                if (Prodtooltip != "")
                    $(ctrl).closest("tr").find("td").eq(6).html("<span title='" + Prodtooltip + "' class='clsInform'>" + Prodstr + "</span>");
                else
                    $(ctrl).closest("tr").find("td").eq(6).html("<span>" + Prodstr + "</span>");

                if (Locationtooltip != "")
                    $(ctrl).closest("tr").find("td").eq(7).html("<span title='" + Locationtooltip + "' class='clsInform'>" + Locstr + "</span>");
                else
                    $(ctrl).closest("tr").find("td").eq(7).html("<span>" + Locstr + "</span>");

                if (Channeltooltip != "")
                    $(ctrl).closest("tr").find("td").eq(8).html("<span title='" + Channeltooltip + "' class='clsInform'>" + Chanstr + "</span>");
                else
                    $(ctrl).closest("tr").find("td").eq(8).html("<span>" + Chanstr + "</span>");

                if (ExtraProdtooltip != "")
                    $(ctrl).closest("tr").find("td").eq(9).html("<span title='" + ExtraProdtooltip + "' class='clsInform'>" + ExtraProdstr + "</span>");
                else
                    $(ctrl).closest("tr").find("td").eq(9).html("<span>" + ExtraProdstr + "</span>");

                $(ctrl).closest("tr").find("td").eq(10).html(MSMPAlies);
                $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/edit.png' onclick='fnEdit(this);'/>");

                Tooltip(".clsInform");
            }
        }

        function fnSave(ctrl) {
            var BucketValues = [];
            var BucketExtraBucket = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $(ctrl).closest("tr").attr("UserID");

            var Name = $(ctrl).closest("tr").find("td").eq(1).find("input[type='text']").eq(0).val();
            var EmailID = $(ctrl).closest("tr").find("td").eq(2).find("input[type='text']").eq(0).val();
            var Status = 0;
            if ($(ctrl).closest("tr").find("td").eq(3).find("input[type='checkbox']").is(':checked')) {
                Status = 1;
            }
            var Role = $(ctrl).closest("tr").find("td").eq(4).find("Select").eq(0).val();
            var CorpUser = 0;
            if ($(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").is(':checked')) {
                CorpUser = 1;
            }

            var SelectAllProduct = 0;
            var ProductString = $(ctrl).closest("tr").find("td").eq(6).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if ($(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").is(':checked')) {
                SelectAllProduct = 1;
                ProductString = "";
            }
            else {
                if (ProductString === undefined || ProductString === null) {
                    ProductString = "";
                }
            }

            var SelectAllLocation = 0;
            var LocationString = $(ctrl).closest("tr").find("td").eq(7).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if ($(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").is(':checked')) {
                SelectAllLocation = 1;
                LocationString = "";
            }
            else {
                if (LocationString === undefined || LocationString === null) {
                    LocationString = "";
                }
            }

            var SelectAllChannel = 0;
            var ChannelString = $(ctrl).closest("tr").find("td").eq(8).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if ($(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").is(':checked')) {
                SelectAllChannel = 1;
                ChannelString = "";
            }
            else {
                if (ChannelString === undefined || ChannelString === null) {
                    ChannelString = "";
                }
            }

            var ExtraProductString = $(ctrl).closest("tr").find("td").eq(9).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if (ExtraProductString === undefined || ExtraProductString === null) {
                ExtraProductString = "";
            }

            if (Name == "") {
                alert("Please enter the Name !");
                return false;
            }
            else if (EmailID == "") {
                alert("Please enter the EmailID !");
                return false;
            }
            else if (Role == "0") {
                alert("Please select the Role !");
                return false;
            }
            else if ((Role == "3" || Role == "1014" || Role == "4" || Role == "1012") && SelectAllProduct == "0" && ProductString == "") {
                alert("Please select the Accessible Product/s !");
                return false;
            }
            else if ((Role == "3" || Role == "1014" || Role == "4" || Role == "1012") && SelectAllLocation == "0" && LocationString == "") {
                alert("Please select the Accessible Location/s !");
                return false;
            }
            else if ((Role == "3" || Role == "1014" || Role == "4" || Role == "1012") && SelectAllChannel == "0" && ChannelString == "") {
                alert("Please select the Accessible Channel/s !");
                return false;
            }

            if (Role == "3" || Role == "1014" || Role == "4" || Role == "1012") {
                if (SelectAllProduct == "0") {
                    for (var i = 0; i < ProductString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": ProductString.split("^")[i].split("|")[0],
                            "col2": ProductString.split("^")[i].split("|")[1],
                            "col3": 1
                        });
                    }
                }
                else {
                    ProductString = "0|0";
                    BucketValues.push({ "col1": 0, "col2": 0, "col3": 1 });
                }

                if (SelectAllLocation == "0") {
                    for (var i = 0; i < LocationString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": LocationString.split("^")[i].split("|")[0],
                            "col2": LocationString.split("^")[i].split("|")[1],
                            "col3": 2
                        });
                    }
                }
                else {
                    LocationString = "0|0";
                    BucketValues.push({ "col1": 0, "col2": 0, "col3": 2 });
                }

                if (SelectAllChannel == "0") {
                    for (var i = 0; i < ChannelString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": ChannelString.split("^")[i].split("|")[0],
                            "col2": ChannelString.split("^")[i].split("|")[1],
                            "col3": 3
                        });
                    }
                }
                else {
                    ChannelString = "0|0";
                    BucketValues.push({ "col1": 0, "col2": 0, "col3": 3 });
                }

                if (ExtraProductString != "") {
                    for (var i = 0; i < ExtraProductString.split("^").length; i++) {
                        BucketExtraBucket.push({
                            "col1": ExtraProductString.split("^")[i].split("|")[0],
                            "col2": ExtraProductString.split("^")[i].split("|")[1],
                            "col3": 4
                        });
                    }
                }
                else {
                    BucketExtraBucket.push({ "col1": 0, "col2": 0, "col3": 0 });
                }

            }
            else {
                BucketValues.push({ "col1": 0, "col2": 0, "col3": 0 });
                BucketExtraBucket.push({ "col1": 0, "col2": 0, "col3": 0 });
            }

            var MSMPAlies = $(ctrl).closest("tr").find("td").eq(10).find("input[type='text']").eq(0).val();

            var flg = 0;
            if (UserID != "0")
                flg = 1;

            $("#dvloader").show();
            PageMethods.fnSave(LoginID, UserID, Name, EmailID, Status, Role, BucketValues, CorpUser, ProductString, LocationString, ChannelString, BucketExtraBucket, ExtraProductString, MSMPAlies, fnSave_pass, fnfailed, flg);
        }
        function fnSave_pass(res, flg) {
            if (res.split("|^|")[0] == "-1") {
                alert("User already exist !");
                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "-2") {
                alert("Please Contact the Administrator !");
                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "-3") {
                if (flg == 0) {
                    alert("User saved successfully !");
                }
                else {
                    alert("User updated successfully !");
                }
                fnGetTableData();
            }
            else {
                fnfailed();
            }
        }

        function fnCheckRole(ctrl) {
            $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' onclick='fnSelectCorpUser(this);'/>");
            fnEnableDisableAccess(ctrl);
        }
        function fnSelectCorpUser(ctrl) {
            fnEnableDisableAccess(ctrl);
        }
        function fnSelectAll(ctrl, cntr) {
            var colIndex = 0;
            var txt = "", txt2 = "";
            var RoleID = $(ctrl).closest("tr").find("td").eq(4).find("select").eq(0).val();

            switch (cntr) {
                case 1:
                    colIndex = 6;
                    txt = "Product";
                    txt2 = "All Products";
                    break;
                case 2:
                    colIndex = 7;
                    txt = "Location";
                    txt2 = "All India";
                    break;
                case 3:
                    colIndex = 8;
                    txt = "Channel";
                    txt2 = "All Channels";
                    break;
            }

            if ($(ctrl).is(':checked')) {
                $(ctrl).closest("td").find("input[type='text']").val(txt2);
                $(ctrl).closest("td").find("input[type='text']").attr("ProdLvl", "");
                $(ctrl).closest("td").find("input[type='text']").attr("ProdHier", "");
                $(ctrl).closest("td").find("input[type='text']").prop("disabled", true);

                if (cntr == 1 && (RoleID == "3" || RoleID == "1014")) {
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").val("");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("ProdLvl", "");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("ProdHier", "");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("placeholder", "");
                }
            }
            else {
                $(ctrl).closest("td").find("input[type='text']").val("");
                $(ctrl).closest("td").find("input[type='text']").attr("ProdLvl", "");
                $(ctrl).closest("td").find("input[type='text']").attr("ProdHier", "");
                $(ctrl).closest("td").find("input[type='text']").prop("disabled", false);

                if (cntr == 1 && (RoleID == "3" || RoleID == "1014")) {
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").val("");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("ProdLvl", "");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("ProdHier", "");
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(9).find("input[type='text']").attr("placeholder", "Click to select Product..");
                }
            }
        }
        function fnEnableDisableAccess(ctrl) {
            var RoleID = $(ctrl).closest("tr").find("td").eq(4).find("select").eq(0).val();
            var IsCorpUser = $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").eq(0).is(":checked");

            if ((RoleID == "3" || RoleID == "1014") && !IsCorpUser) {
                $(ctrl).closest("tr").find("td").eq(9).html("<input type='text' iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/>");
            }
            else {
                $(ctrl).closest("tr").find("td").eq(9).html("<input type='text' iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='' disabled/>");
            }

            if (IsCorpUser) {
                $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);' disabled checked/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='All Products'/>");
                $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);' disabled checked/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..' value='All India'/>");
                $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);' disabled checked/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..' value='All Channels'/>");
            }
            else {
                switch (RoleID) {
                    case "3":
                        $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/>");
                        $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..'/>");
                        $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..'/>");
                        break;
                    case "1014":
                        $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/>");
                        $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..'/>");
                        $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..'/>");
                        break;
                    case "4":
                        $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/>");
                        $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..'/>");
                        $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..'/>");
                        break;
                    case "1012":
                        $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text'  iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/>");
                        $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);' disabled checked/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Location..' value='All India'/>");
                        $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);' disabled checked/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..' value='All Channels'/>");
                        break;
                    default:
                        $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' disabled onclick='fnSelectCorpUser(this);'/>");
                        $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' disabled onclick='fnSelectAll(this,1);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder=''/>");
                        $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' disabled onclick='fnSelectAll(this,2);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder=''/>");
                        $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' disabled onclick='fnSelectAll(this,3);'/><input type='text' disabled iden='ProductHier' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder=''/>");
                        break;
                }
            }
        }
    </script>
    <script type="text/javascript">
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
        function fnProdPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#chkSelectAllProd").removeAttr("checked");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).attr("flgVisible", "1");
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnShowProdHierPopup(ctrl, cntr) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val(cntr);
            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");

            var title = "";
            if (cntr == "1") {
                title = "Product/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnProductLvl").val());
            }
            else if (cntr == "2") {
                title = "Site/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
            }
            else {
                title = "Channel/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
            }
            $("#divHierPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
                    if (cntr == "1") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:40%;'>Category</th>";
                        strtable += "<th style='width:60%;'>Brand</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Product Hierarchy");
                    }
                    else if (cntr == "2") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:15%;'>Country</th>";
                        strtable += "<th style='width:20%;'>Region</th>";
                        strtable += "<th style='width:30%;'>Site</th>";
                        strtable += "<th style='width:35%;'>Distributor</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Location Hierarchy");
                    }
                    else {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:40%;'>Class</th>";
                        strtable += "<th style='width:60%;'>Channel</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Channel Hierarchy");
                    }

                    if ($(ctrl).attr("ProdLvl") != "") {
                        $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("ProdHier"));
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("ProdLvl") + "']").eq(0), cntr);
                    }
                    else
                        $("#ConatntMatter_hdnSelectedHier").val("");

                },
                close: function () {
                    //
                },
                buttons: {
                    "Select": function () {
                        fnProdSelected(ctrl);
                        $("#divHierPopup").dialog('close');
                    },
                    "Reset": function () {
                        fnHierPopupReset();
                    },
                    "Cancel": function () {
                        $("#divHierPopup").dialog('close');
                    }
                }
            });
        }
        function fnProdLvl(ctrl, cntr) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();
            var ProdLvl = $(ctrl).attr("ntype");

            $(ctrl).closest("tr").addClass("Active").siblings().removeClass("Active");
            $("#divHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

            var BucketValues = [];
            if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                var Selstr = $("#ConatntMatter_hdnSelectedHier").val();
                for (var i = 0; i < Selstr.split("^").length; i++) {
                    BucketValues.push({
                        "col1": Selstr.split("^")[i].split("|")[0],
                        "col2": Selstr.split("^")[i].split("|")[1],
                        "col3": cntr
                    });
                }
            }

            if (cntr == "1") {
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed, cntr);
            }
            else if (cntr == "2") {
                PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, "0", fnProdHier_pass, fnProdHier_failed, cntr);
            }
            else {
                PageMethods.fnChannelHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed, cntr);
            }
        }
        function fnProdHier_pass(res, cntr) {
            if (res.split("|^|")[0] == "0") {
                $("#divHierPopupTbl").html(res.split("|^|")[1]);
                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    $("#divHierSelectionTbl").html(res.split("|^|")[2]);
                    $("#ConatntMatter_hdnSelectedHier").val("");
                }

                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length > 0) {
                    var PrevSelLvl = $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                    var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl)) && (cntr != "2")) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html("");
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").each(function () {
                            if (Lvl == $(this).attr("lvl")) {
                                var tr = $("#divHierPopupTbl").find("table").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']");
                                fnSelectHier(tr.eq(0), cntr);
                                var trHtml = tr[0].outerHTML;
                                tr.eq(0).remove();
                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                            }
                            else {
                                switch (Lvl) {
                                    case "20":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "110":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "120":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "130":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "210":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                }
                            }
                        });
                    }
                }
            }
            else {
                fnProdHier_failed(ProdLvl, cntr);
            }
        }
        function fnProdHier_failed(ProdLvl, cntr) {
            $("#divHierPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnHierPopupReset() {
            $("#divHierSelectionTbl").find("tbody").eq(0).html("");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            });
            $("#chkSelectAllProd").removeAttr("checked");
        }
        function fnSelectHier(ctrl, cntr) {
            $(ctrl).attr("flg", "1");
            $(ctrl).addClass("Active");
            $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

            fnAppendSelection(ctrl, 1, cntr);
        }
        function fnSelectAllProd(ctrl, cntr) {
            if ($(ctrl).is(":checked")) {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "1");
                    $(this).addClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                    fnAppendSelection(this, 1, cntr);
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "0");
                    $(this).removeClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                    fnAppendSelection(this, 0, cntr);
                });
            }
        }
        function fnSelectUnSelectProd(ctrl, cntr) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                fnAppendSelection(ctrl, 0, cntr);
                $("#chkSelectAllProd").removeAttr("checked");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                fnAppendSelection(ctrl, 1, cntr);
            }
        }
        function fnAppendSelection(ctrl, flgSelect, cntr) {
            var BucketType = cntr;
            var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");

            if (flgSelect == 1) {
                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").length == 0) {
                    var strtr = "";
                    if (BucketType == "1") {
                        switch (Lvl) {
                            case "10":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("cat") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='20'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "20":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("brand") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else if (BucketType == "2") {
                        switch (Lvl) {
                            case "100":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("cntry") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='110'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "110":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("reg") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "120":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("site") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][site='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "130":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("dbr") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else {
                        switch (Lvl) {
                            case "200":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("cls") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='210'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "210":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("channel") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }

                    if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length == 0) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html(strtr);
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).prepend(strtr);
                    }
                }
            }
            else {
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").eq(0).remove();
            }
        }

        function fnProdSelected(ctrl) {
            var SelectedLvl = "", SelectedHier = "", descr = "";
            if ($("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").length == 0) {
                if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                    SelectedLvl = "10";
                }
                else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                    SelectedLvl = "100";
                }
                else {
                    SelectedLvl = "200";
                }
            }
            else
                SelectedLvl = $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");

            $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
                    case "10":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "20":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "30":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                    case "40":
                        descr += "," + $(this).find("td").eq(3).html();
                        break;
                    case "100":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "110":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "120":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                    case "130":
                        descr += "," + $(this).find("td").eq(3).html();
                        break;
                    case "140":
                        descr += "," + $(this).find("td").eq(4).html();
                        break;
                    case "200":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "210":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "220":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                }
            });
            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                descr = descr.substring(1);
                if (descr.length > 30) {
                    descr = descr.substring(0, 30) + "...";
                }
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", SelectedHier);
                $(ctrl).val(descr);
            }
            else {
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", "");
                $(ctrl).val("");
            }
        }
    </script>
    <style type="text/css">
        #divReport {
            overflow-y: auto;
        }

            #divReport td.clstdAction {
                text-align: center;
            }

            #divReport img {
                cursor: pointer;
            }

        #divHierPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        .fixed-top {
            z-index: 99 !important;
        }

        #divHierSelectionTbl td,
        #divHierPopupTbl td {
            font-size: 0.7rem !important;
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
        table.table > thead > tr > th {
            text-align: center;
            vertical-align: middle;
        }

        table.clsReport tr th:nth-child(1) {
            width: 3%;
        }

        table.clsReport tr th:nth-child(2),
        table.clsReport tr th:nth-child(3) {
            width: 9%;
        }

        table.clsReport tr th:nth-child(4),
        table.clsReport tr th:nth-child(6) {
            width: 5%;
        }

        table.clsReport tr th:nth-child(5) {
            width: 6%;
        }

        table.clsReport tr th:nth-child(7),
        table.clsReport tr th:nth-child(8),
        table.clsReport tr th:nth-child(9),
        table.clsReport tr th:nth-child(10) {
            width: 12%;
        }

        table.clsReport tr th:nth-child(11) {
            width: 10%;
        }

        table.clsReport tr th:nth-child(12) {
            width: 5%;
            white-space: nowrap;
        }

        table.clsReport tr td {
            font-size: 0.70rem !important;
        }

            table.clsReport tr td:nth-child(1),
            table.clsReport tr td:nth-child(4),
            table.clsReport tr td:nth-child(5),
            table.clsReport tr td:nth-child(6),
            table.clsReport tr td:nth-child(12) {
                text-align: center;
            }

            table.clsReport tr td:nth-child(7) > span input[type='text'],
            table.clsReport tr td:nth-child(8) > span input[type='text'],
            table.clsReport tr td:nth-child(9) > span input[type='text'],
            table.clsReport tr td:nth-child(10) > span input[type='text'],
            table.clsReport tr td:nth-child(7) > input[type='text'],
            table.clsReport tr td:nth-child(8) > input[type='text'],
            table.clsReport tr td:nth-child(9) > input[type='text'],
            table.clsReport tr td:nth-child(10) > input[type='text'] {
                width: 80%;
                margin-left: 3%;
                font-size: 0.6rem;
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
                    padding: .2rem .4rem;
                    font-size: 0.66rem;
                    border: 1px solid #dee2e6;
                }

            .customtooltip table > tbody > tr:nth-of-type(2n+1) {
                background-color: rgba(0,61,167,.10);
            }

            /*.customtooltip table > thead > tr > th:nth-of-type(2n-1),
            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                border-left: 3px solid #4289FF;
            }*/

            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                color: #003DA7;
            }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="margin-bottom: 0;">User Management</h4>
    <div class="row no-gutters" id="Filter">
        <div class="fsw col-10">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 100%;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
                    </div>
                </div>
            </div>
        </div>
        <div class="fsw col-2" style="padding-left: 1%;">
            <div class="fsw_inner">
                <div class="fsw_inputBox">
                    <div class="fsw-title">User</div>
                    <div class="d-block">
                        <a class="btn btn-primary btn-sm" href="#" onclick="fnAddNew();">Add New User Inform.</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>

    <div id="divHierPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-2">
                <div id="ProdLvl" class="prodLvl"></div>
            </div>
            <div class="col-6">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div id="PopupHierlbl" class="d-block"></div>
                    </div>
                    <div id="divHierPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-4">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divHierSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="dvUserDetail" style="display: none; font-size: 8.5pt">
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMainRoleID" runat="server" />


    <asp:HiddenField ID="hdnBucketID" runat="server" />
    <asp:HiddenField ID="hdnBucketName" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    <asp:HiddenField ID="hdnBrand" runat="server" />
    <asp:HiddenField ID="hdnBrandForm" runat="server" />

</asp:Content>

