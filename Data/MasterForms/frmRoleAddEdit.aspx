<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="frmRoleAddEdit.aspx.cs" Inherits="MasterForms_frmRoleAddEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/style.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery-ui.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery-ui.min.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>


    <script type="text/javascript">
        var ht = 0;
        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        $(document).ready(function () {
            ht = $(window).height();
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
            //  alert(res);
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

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
            str += "<tr RoleID='0'  RoleName='' style='display: table-row;'>";
            str += "<td></td>";
            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td><select ID='ddlMenu' class='mySelectClass' multiple='multiple' style='width:20%; box-sizing: border-box; margin-right: 1%;'>" + $("#ConatntMatter_hdnMenuID").val() + "</select></td>";
            str += "<td class='clstdAction'><img src='../../Images/save.png' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/close_iconNew.png' onclick='fnCancel(this);'/></td>";
            str += "<td class='clstdAction'><img src='../../Images/person.png' onclick='fnUserDeatils(this);'/></td>";
            str += "</tr>";
            if ($("#tblReport").find("tbody").eq(0).find("tr").length == 0) {
                $("#tblReport").find("tbody").eq(0).html(str);
                fnMakeMultiSelectDropDown(this);
            }
            else {
                $("#tblReport").find("tbody").eq(0).prepend(str);
                fnMakeMultiSelectDropDown(this);
            }

        }

        function fnMakeMultiSelectDropDown(ctrl) {
            // $("#tblReport").find("tbody").find("tr").find("td").eq(2).find(".mySelectClass").multiselect({
            $(".mySelectClass").multiselect({
                position: { my: "left bottom", at: "left top", collision: "flip" },
                selectedList: $(this).find("option").length,
                noneSelectedText: "--Select--",
                height: 140,
                width: 160
            }).multiselectfilter();
            // $("#tblReport").find("tbody").find("tr").find("td").eq(2).find(".mySelectClass").multiselect('checkAll');

        }



        function fnEdit(ctrl) {

            var RoleID = $(ctrl).closest("tr").attr("RoleID");
            var RoleName = $(ctrl).closest("tr").attr("RoleName");
            var MenuDescription = $(ctrl).closest("tr").attr("MenuDescr");
            var MenuID = $(ctrl).closest("tr").attr("MenuID");
            var arraySelectedMenuID = MenuID.split(",");

            $(ctrl).closest("tr").find("td").eq(1).html("<input type='text' style='width:58%; box-sizing: border-box;' value='" + RoleName + "' />");

            // Start Binding MultiSelect Dropdown

            $(ctrl).closest("tr").find("td").eq(2).html("<select id='ddlMenu' class='mySelectClass' multiple='multiple'  style='width:20%; box-sizing: border-box; margin-right: 1%;'>" + $("#ConatntMatter_hdnMenuID").val() + "</select>");


            for (var i = 0; i < arraySelectedMenuID.length; i++) {
                $("#ddlMenu option[value='" + arraySelectedMenuID[i] + "']").prop("selected", true);
            }
            //$("#ddlOrderStatus").multiselect('refresh');


            //$.each(arraySelectedMenuID, function (i) {
            //    $("#ddlMenu option[value='" + arraySelectedMenuID[i] + "']").prop("selected", true);
            //});
            fnMakeMultiSelectDropDown(this);

            // End Binding MultiSelect Dropdown

            $(ctrl).closest("tr").find("td").eq(3).html("<img src='../../Images/save.png' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/close_iconNew.png' onclick='fnCancel(this);'/>");
            $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/person.png' onclick='fnUserDeatils(this);'/>");

        }



        function fnUserDeatils(ctrl) {
            var RoleID = $(ctrl).closest("tr").attr("RoleID");
            var RoleName = $(ctrl).closest("tr").attr("RoleName");
            var LoginID = $("#ConatntMatter_hdnLoginID").val();


            //  alert(RoleID);
            //  alert(RoleName);
            PageMethods.fnViewUserDetail(RoleID, LoginID, fnViewUserDetail_Pass, fnfailed);
        }
        function fnViewUserDetail_Pass(result) {
            $("#dvUserDetail").css("display", "block");
            $("#dvUserDetail").html(result);
            $("#dvUserDetail").dialog({
                modal: true,
                title: "User Detail",
                width: '60%',
                maxHeight: $(window).height() - 100,
                minHeight: 150,
                buttons: {
                    //"Save": function () {

                    //    //if ($("#tblBasicDetailsInfoDetails tbody").find("tr").length > 0) {
                    //    //    var tbl_tr_Count = $("#tblBasicDetailsInfoDetails tbody").find("tr").length;
                    //    //    var arrEditData = [];
                    //    //    // loop over each table row (tr)
                    //    //    $("#tblBasicDetailsInfoDetails tbody tr").each(function () {

                    //    //        ////  var expensedetailid = $(this).find("td:eq(0)").text(); //incase of cell
                    //    //        //var expensedetailid = $(this).find("td:eq(1)").text(); //incase of cell
                    //    //        //var txtApprovedClaim = $(this).find("#txtApprovedClaim").val();// incase of textbox and provide id to textbox
                    //    //        //var txtApprovedAmount = $(this).find("#txtApprovedAmount").val();// incase of textbox and provide id to textbox
                    //    //        //var txtApproverComment = $(this).find("#txtApproverComment").val();// incase of textbox and provide id to textbox

                    //    //        ////alert(expensedetailid);
                    //    //        ////alert(expensedetailid1);
                    //    //        ////alert(txtApprovedAmount);

                    //    //        // arrEditData.push({ ExpenseDetailID: expensedetailid, ApprovedClaim: txtApprovedClaim, ApprovedAmount: txtApprovedAmount, ApproverComment: txtApproverComment });

                    //    //    });

                    //    //    //   PageMethods.SaveEditDetailsData(arrEditData, loginId, NodeId, fnSuccessDetail, fnFailedFunction);
                    //    //}

                    //    alert("Working On It");
                    //},
                    //"Cancel": function () {
                    //    $(this).dialog("close");
                    //    $("#dvUserDetail").html('');
                    //}
                },
                close: function () {
                    $(this).dialog("close");
                    $(this).dialog("destroy");
                    $("#dvUserDetail").html('');
                }
            });
        }


        function fnActive_DActiveUser(ctrl) {
            var NodeID = $(ctrl).closest("tr").attr("NodeID");
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var flgActive = $(ctrl).closest("tr").attr("Active");
            var flgActiveValue;

            if (confirm('Are you sure you want to change the status of this user..')) {
                if (flgActive == "Yes") {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span><a href='#' style='color:blue;text-decoration:underline;'>In-Active</a></td></span>");
                    flgActiveValue = 0;
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span><a href='#' style='color:blue;text-decoration:underline;'>Active</a></td></span>");
                    flgActiveValue = 1;
                }
                PageMethods.fnActive_DActiveUser(NodeID, LoginID, flgActiveValue, fnActive_DActiveUser_Success, fnActive_DActiveUser_failed);
            }
        }



        function fnActive_DActiveUser_Success(result) {
            if (result.split("^")[0] == "1") {
                alert("User Status Change Successfully..");
                $("#dvUserDetail").dialog("close");
            }
            else {
                fnfailed();
            }

        }
        function fnActive_DActiveUser_failed(result) {
            fnfailed();
        }


        function fnCancel(ctrl) {
            var RoleID = $(ctrl).closest("tr").attr("RoleID");
            if (RoleID == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var RoleName = $(ctrl).closest("tr").attr("RoleName");
                var MenuID = $(ctrl).closest("tr").attr("MenuID");
                var MenuDescription = $(ctrl).closest("tr").attr("MenuDescr");
                $(ctrl).closest("tr").find("td").eq(1).html("<span>" + RoleName + "</span>");
                if (MenuDescription.length > 50) {
                    $(ctrl).closest("tr").find("td").eq(2).html("<span>" + MenuDescription.substring(0, 50) + "...</span>");
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(2).html("<span>" + MenuDescription + "</span>");
                }

                $(ctrl).closest("tr").find("td").eq(3).html("<img src='../../Images/edit.png' onclick='fnEdit(this);'/>");
                $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/person.png' onclick='fnUserDeatils(this);'/>");
            }
        }

        function fnGetSelectedMenu() {
            var strMenu = "";
            for (var i = 0; i < $("#ddlMenu option:selected").length; i++) {
                if (strMenu == "") {
                    strMenu = $("#ddlMenu option:selected").eq(i).val();
                }
                else {
                    strMenu += "," + $("#ddlMenu option:selected").eq(i).val();
                }
            }
            return strMenu;
        }

        function fnSave(ctrl) {
            var RoleID = $(ctrl).closest("tr").attr("RoleID");
            var RoleName = $(ctrl).closest("tr").find("td").eq(1).find("input[type='text']").eq(0).val();
            var MenuID = $(ctrl).closest("tr").find("td").eq(2).find("Select").eq(0).val();
            var LoginID = $("#ConatntMatter_hdnLoginID").val();

            var strSelectedMenuID = fnGetSelectedMenu();

            if (RoleName == "") {
                alert("Please enter the Role !");
                return false;
            }
            else if (MenuID == "0") {
                alert("Please select the Menu Screen !");
                return false;
            }
            var ArrMenuIDData = [];
            for (var i = 0; i < MenuID.length; i++) {
                ArrMenuIDData.push({
                    "MnID": MenuID[i],
                });
            }

            var flg = 0;
            if (RoleID != "0")
                flg = 1;

            $("#dvloader").show();
            PageMethods.fnSave(RoleID, RoleName, ArrMenuIDData, strSelectedMenuID, LoginID, fnSave_pass, fnfailed, flg);
        }
        function fnSave_pass(res, flg) {
            if (res.split("|^|")[0] == "-1") {
                alert("Role already exist !");
                $("#dvloader").hide();
            }
            else if (res.split("|^|")[0] == "-2") {
                alert("Please Contact Administrator");
                // fnGetTableData();
            }
            else if (res.split("|^|")[0] == "-3") {
                if (flg == 0) {
                    alert("Role saved successfully !");
                }
                else {
                    alert("Role update successfully !");
                }
                fnGetTableData();
            }
            else {
                fnfailed();
            }

        }


        function fnAddNewUser(ctrl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var NodeID = 0;// $("#ConatntMatter_hdnNodeID").val();
            var NodeType = 0;// $("#ConatntMatter_hdnNodeType").val();
            var BucketTypeID = 0;
            var RoleID = $(ctrl).closest("tr").attr("RoleID");
            var UserName = "";
            var Designation = "";
            var EmployeeCode = "";
            var EmailID = "";
            var PhoneNo = "";
            var UserStatus = "";
            var ArrTblData = [];
            //alert(LoginID);
            //alert(RoleID);
            //alert(NodeID);
            //alert(NodeType);

            $("#ConatntMatter_txtUserName").val(UserName);
            $("#ConatntMatter_txtDesignation").val(Designation);
            $("#ConatntMatter_txtEmpCode").val(EmployeeCode);
            $("#ConatntMatter_txtEmailID").val(EmailID);
            $("#ConatntMatter_txtPhoneNo").val(PhoneNo);
            $("#ConatntMatter_chkUserStatus").val(UserStatus);


            $("#dvAddUser").dialog({
                modal: true,
                title: "Add New User",
                width: '33%',
                maxHeight: $(window).height() - 100,
                minHeight: 150,
                buttons: {
                    "Add": function () {
                        UserName = $("#ConatntMatter_txtUserName").val();
                        Designation = $("#ConatntMatter_txtDesignation").val();
                        EmployeeCode = $("#ConatntMatter_txtEmpCode").val();
                        EmailID = $("#ConatntMatter_txtEmailID").val();
                        PhoneNo = $("#ConatntMatter_txtPhoneNo").val();
                        UserStatus = $("#ConatntMatter_chkUserStatus").val();

                        if (UserName == undefined || UserName.trim() == "") {
                            fnErrorColor(document.getElementById("ConatntMatter_txtUserName"));
                            document.getElementById("lblErrorUserName").innerText = "* Please Enter User Name.";
                            $("#ConatntMatter_txtUserName").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtUserName"));
                        }

                        if (Designation == undefined || Designation.trim() == "") {
                            fnErrorColor(document.getElementById("ConatntMatter_txtDesignation"));
                            document.getElementById("lblErrorDesignation").innerText = "* Please Enter Designation.";
                            $("#ConatntMatter_txtDesignation").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtDesignation"));
                        }

                        if (EmployeeCode == undefined || EmployeeCode.trim() == "") {
                            fnErrorColor(document.getElementById("ConatntMatter_txtEmpCode"));
                            document.getElementById("lblErrorEmpCode").innerText = "* Please Enter User Code.";
                            $("#ConatntMatter_txtEmpCode").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtEmpCode"));
                        }

                        if (EmailID == undefined || EmailID.trim() == "") {
                            fnErrorColor(document.getElementById("ConatntMatter_txtEmailID"));
                            document.getElementById("lblErrorEmailID").innerText = "* Please Enter Client Person Email ID.";
                            $("#ConatntMatter_txtEmailID").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtEmailID"));
                        }
                        if (IsEmail(EmailID) == false) {
                            fnErrorColor(document.getElementById("ConatntMatter_txtEmailID"));
                            document.getElementById("lblErrorEmailID").innerText = "* Please enter the correct Email-Id! : abc@gmail.com ";
                            $("#ConatntMatter_txtEmailID").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtEmailID"));
                        }

                        if (PhoneNo == undefined || PhoneNo.trim() == "") {
                            fnErrorColor(document.getElementById("ConatntMatter_txtPhoneNo"));
                            $("#ConatntMatter_txtPhoneNo").focus();
                            return false;
                        }
                        else {
                            fnOriginalColor(document.getElementById("ConatntMatter_txtPhoneNo"));
                        }

                        if ($("#ConatntMatter_chkUserStatus").is(':checked')) {
                            UserStatus = 1;
                        }
                        else {
                            UserStatus = 0;
                        }

                        //if (UserName == undefined || UserName.trim() == "") {
                        //    alert("Please enter User Name.");
                        //    $("#ConatntMatter_txtUserName").focus();
                        //    return false;
                        //}
                        //else if (Designation == undefined || Designation.trim() == "") {
                        //    alert("Please enter Designation.");
                        //    $("#ConatntMatter_txtDesignation").focus();
                        //    return false;
                        //}
                        //else if (EmployeeCode == undefined || EmployeeCode.trim() == "") {
                        //    alert("Please enter Employee Code.");
                        //    $("#ConatntMatter_txtEmpCode").focus();
                        //    return false;
                        //}
                        //else if (EmailID == undefined || EmailID.trim() == "") {
                        //    alert("Please enter Email ID.");
                        //    $("#ConatntMatter_txtEmailID").focus();
                        //    return false;
                        //}
                        //else if (PhoneNo == undefined || PhoneNo.trim() == "") {
                        //    alert("Please enter Phone No Name.");
                        //    $("#ConatntMatter_txtPhoneNo").focus();
                        //    return false;
                        //}

                        ArrTblData.push({ NodeID: NodeID, NOdeType: NodeType, BucketTypeID: BucketTypeID });

                        $("#dvloader").show();
                        PageMethods.fnAddNewUser(LoginID, NodeID, UserName, Designation, EmployeeCode, EmailID, PhoneNo, UserStatus, RoleID, ArrTblData, fnSaveSuccess_User, fnFailed_User);
                    },
                    "Cancel": function () {
                        $(this).dialog("close");
                    }
                },
                close: function () {
                    $(this).dialog("close");
                    $(this).dialog("destroy");
                }

            });
        }

        function fnSaveSuccess_User(result) {
            if (result.split("^")[0] == "-1") {
                alert("User already exists...");
                $("#dvloader").hide();
            }
            else if (result.split("^")[0] == "-2") {
                // fnfailed();
                alert("Please Contact Administrator...");
                $("#dvAddUser").dialog("close");
                $("#dvloader").hide();
            }
            else if (result.split("^")[0] == "-3") {
                alert("User Save Successfully...");
                $("#dvAddUser").dialog("close");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnFailed_User(result) {
            // alert(result._message);
            fnfailed();
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
    </script>

    <script type="text/javascript">
        //*************************for Email Validation*********************
        function IsEmail(email) {
            var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            if (!regex.test(email)) {
                return false;
            } else {
                return true;
            }
        }

        //*************************for Backgrouncolor*********************
        function fnErrorColor(obj) {
            obj.style.backgroundColor = "#ffffcc";
        }
        function fnOriginalColor(obj) {
            obj.style.backgroundColor = "#ffffff";
        }
        function fnClear(Obj) {
            document.getElementById(Obj).innerText = "";
        }
        //*************************Only Numeric Digit For Mob No*********************
        function isNumberKeyNotDecimal(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;

            return true;
        }


        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        //********************************************************

    </script>

    <%--  <style type="text/css">
        table.clsReport tr th:nth-child(1) {
            width: 2%;
        }

      

        table.clsReport tr th:nth-child(2) {
            width: 10%;
        }


     

        table.clsReport tr th:nth-child(3) {
            width: 30%;
        }

        table.clsReport tr th:nth-child(4),
        table.clsReport tr th:nth-child(5) {
            width: 5%;
        }

       
        table.clsReport tr th:nth-child(6) {
            width: 8%;
        }

  
    </style>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title">Role Management</h4>
    <div class="fsw">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-25">
                <div class="fsw-title">Search Box</div>
                <div class="d-block">
                    <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
                </div>

            </div>
        </div>
    </div>
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <div class="text-right mb-2 mt-1">
                <a class="btn btn-primary btn-sm" href="#" onclick="fnAddNew();">Add New Role</a>
            </div>
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>


    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="dvUserDetail" style="display: none; font-size: 8.5pt">
    </div>
    <div id="dvAddUser" style="display: none;" title="Add New User">
        <table style="width: 99%" class="table table-bordered table-sm">
            <tr>
                <td style="text-align: left; width: 30%">User Name</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <div class="input-group">
                        <asp:TextBox ID="txtUserName" CssClass="form-control" runat="server" MaxLength="20" onkeypress="fnClear('lblErrorUserName')"></asp:TextBox>
                        <span id="lblErrorUserName" class="lblError"></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; width: 30%">Designation</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <div class="input-group">
                        <asp:TextBox ID="txtDesignation" CssClass="form-control" runat="server" MaxLength="20" onkeypress="fnClear('lblErrorDesignation')"></asp:TextBox>
                        <span id="lblErrorDesignation" class="lblError"></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; width: 30%">Employee Code</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <div class="input-group">
                        <asp:TextBox ID="txtEmpCode" CssClass="form-control" runat="server" MaxLength="10" onkeypress="fnClear('lblErrorEmpCode')"></asp:TextBox>
                        <span id="lblErrorEmpCode" class="lblError"></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; width: 30%">Email ID</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <div class="input-group">
                        <asp:TextBox ID="txtEmailID" CssClass="form-control" runat="server" MaxLength="30" onkeypress="fnClear('lblErrorEmailID')"></asp:TextBox>
                        <span id="lblErrorEmailID" class="lblError"></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; width: 30%">Phone No</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <div class="input-group">
                        <asp:TextBox ID="txtPhoneNo" CssClass="form-control" runat="server" MaxLength="10" onkeypress="return isNumber(event)"></asp:TextBox>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; width: 30%">Status</td>
                <td style="width: 2%;">:</td>
                <td style="text-align: left;">
                    <asp:CheckBox ID="chkUserStatus" Checked="true" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div class="clear"></div>
    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMenuID" runat="server" />
</asp:Content>

