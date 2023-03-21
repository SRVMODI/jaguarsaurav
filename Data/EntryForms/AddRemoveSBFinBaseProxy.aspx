<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="AddRemoveSBFinBaseProxy.aspx.cs" Inherits="Data_EntryForms_AddRemoveSBFinBaseProxy" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
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
    </script>
    <script type="text/javascript">
        var ht;
        $(document).ready(function () {
            ht = $(window).height();

            // 1 : Add,     2 : Remove
            if ($("#ConatntMatter_hdnPageType").val() == "1") {
                $("#Heading").html("Add SBF as Base/Proxy :");
                $("#lblStep1").html("Select SBF to be Added, in One or More Norm(s)");
                $("#lblStep2").html("SBF to be Added in Quarter");
                $("#lblStep3").html("SBF to be Added as Base or Proxy");
                $("#lblStep4").html("Filters for Norm(s) of Selected Cluster/Channel");
                $("#lblStep5").html("Maps to Existing SBF(s) as Base/Proxy");
                $("#btnBase").html("Add as Base SBF");
                $("#btnProxy").html("Add as Proxy SBF");

                $("#btnRemoveAsProxy").remove();
                $("#btnRemoveAsBase").remove();
                $("#btnReplaceAsBase").remove();
            }
            else {
                $("#Heading").html("Remove SBF as Base/Proxy :");
                $("#lblStep1").html("Select SBF to be Removed, in One or More Norm(s)");
                $("#lblStep2").html("SBF to be Removed in Quarter");
                $("#lblStep3").html("SBF to be Removed as Base or Proxy");
                $("#lblStep4").html("Filters for Norm(s) of Selected Cluster/Channel");
                $("#btnBase").html("Remove as Base SBF");
                $("#btnProxy").html("Remove as Proxy SBF");

                $("#lblStep5").parent("div").next().addClass("col-8").removeClass("col-2");
                $("#lblStep5").parent("div").remove();
                $("#btnAddSBF").remove();
            }

            $("#txtSBFSelection").next().html($("#ConatntMatter_hdnSBFMstr").val());
            $("#ddlQuarter").html($("#ConatntMatter_hdnQuarter").val().split("|^|")[0]);
            $("#ddlQuarter").val($("#ConatntMatter_hdnQuarter").val().split("|^|")[1]);
        });

        function fnGetDetails() {
            if ($("#txtSBFSelection").val() == "") {
                AutoHideAlertMsg("Please select the Sub-BrandForm !");
                return false;
            }

            var ProdValues = [], LocValues = [], ChannelValues = [];
            var LocString = $("#btnClusterFilter").attr("selectedstr");
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");

            var SBFNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
            var SBFNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            var Qtr = $("#ddlQuarter").val().split("|")[2];
            var Yr = $("#ddlQuarter").val().split("|")[3];
            $("#ConatntMatter_hdnQuarter").val($("#ddlQuarter").val());

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var flgPage = $("#ConatntMatter_hdnPageType").val();                    // 1 : Add, 2 : Remove
            var flgSBF = $("#ConatntMatter_hdnSBFType").val();


            $("#AdditionalSBFFilter").find("tbody").eq(0).find("tr[iden='trSBFAdvFilter']").each(function () {
                if ($(this).find("input[type='text']").eq(0).attr("selectedstr") != "") {
                    ProdValues.push({
                        "col1": $(this).find("input[type='text']").eq(0).attr("selectedstr").split("|")[0],
                        "col2": $(this).find("input[type='text']").eq(0).attr("selectedstr").split("|")[1],
                        "col3": "1",
                        "col4": $(this).find("input[type='radio']").eq(0).is(":checked") ? "0" : "1"
                    });
                }
            });
            if (ProdValues.length == 0) {
                ProdValues.push({ "col1": "0", "col2": "0", "col3": "3", "col4": "0" });
            }

            if (LocString != "") {
                for (var i = 0; i < LocString.split("^").length; i++) {
                    LocValues.push({
                        "col1": LocString.split("^")[i]
                    });
                }
            }
            else {
                LocValues.push({ "col1": "0" });
            }

            if (ChannelString != "") {
                for (var i = 0; i < ChannelString.split("^").length; i++) {
                    ChannelValues.push({
                        "col1": ChannelString.split("^")[i].split("|")[0],
                        "col2": ChannelString.split("^")[i].split("|")[1],
                        "col3": "3"
                    });
                }
            }
            else {
                ChannelValues.push({ "col1": "0", "col2": "0", "col3": "3" });
            }

            $("#dvloader").show();
            PageMethods.fnGetDetails(SBFNodeID, SBFNodeType, ProdValues, LocValues, ChannelValues, Qtr, Yr, LoginID, RoleID, UserID, flgPage, flgSBF, fnGetDetails_pass, fnfailed);
        }
        function fnGetDetails_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();

                $("#divReport").html(res.split("|^|")[1]);
                $("#dvSBDBody").height((ht - ($("#Filter").height() + 220)) + "px");

                fnUpdateBtnStatus();
                Tooltip(".clsInform");
            }
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();
                $("#divReport").html(res.split("|^|")[1]);
            }
            else {
                fnfailed();
            }
        }

        function fnSBDTypeSearch(ctrl) {
            var flgValid = 0;
            var colcntr = $("#tblSBDHeader").find("th").length;

            $("#tblSBDBody").find("tbody").eq(0).find("tr").css("display", "none");
            $("#tblSBDBody").find("tbody").eq(0).find("tr").each(function () {
                flgValid = 1;
                for (var i = 1; i < colcntr; i++) {
                    
                    var filter = $("#tblSBDHeader").find("th").eq(i).find("input[type='text']").eq(0).val().toString().toUpperCase().trim();
                    if (filter != "" && filter.length > 2) {
                        if (i > 2) {
                            var basesbf = "";
                            $(this).find("td").eq(i).find("span").each(function () {
                                basesbf += $(this).html() + " ";
                            });
                            if (basesbf.toUpperCase().indexOf(filter) == -1) {
                                flgValid = 0;
                            }
                        }
                        else {
                            if ($(this).find("td").eq(i).html().toUpperCase().indexOf(filter) == -1) {
                                flgValid = 0;
                            }
                        }
                    }
                }

                if (flgValid == 1) {
                    $(this).css("display", "table-row");
                }
            });
        }
        function fnCollapseExpand(ctrl) {
            var flgVisible = $(ctrl).attr("flgVisible");
            if (flgVisible == "1") {  //Visible
                $(ctrl).attr("flgVisible", "0");
                $(ctrl).closest("div").next().slideUp(1000);
                $(ctrl).addClass("fa-plus-square").removeClass("fa-minus-square");
            }
            else {   //Hide
                $(ctrl).attr("flgVisible", "1");
                $(ctrl).closest("div").next().slideDown(1000);
                $(ctrl).addClass("fa-minus-square").removeClass("fa-plus-square");
            }
        }

        function fnSBDSelectAll() {
            if ($("#chkSBDSelectAll").is(":checked"))
                $("#tblSBDBody").find("input[type='checkbox']").prop("checked", true);
            else
                $("#tblSBDBody").find("input[type='checkbox']").removeAttr("checked");

            fnUpdateBtnStatus();
        }
        function fnSelectSBD(ctrl) {
            if ($(ctrl).is(":checked")) {
                $(ctrl).closest("tr").find("input[type='checkbox']").prop("checked", true);
            }
            else {
                $(ctrl).closest("tr").find("input[type='checkbox']").removeAttr("checked");
                $("#chkSBDSelectAll").removeAttr("checked");
            }

            fnUpdateBtnStatus();
        }
        function fnSelectBaseSBF(ctrl) {
            if (!($(ctrl).is(":checked"))) {
                $(ctrl).closest("tr").find("td").eq(0).find("input[type='checkbox']").removeAttr("checked");
                $("#chkSBDSelectAll").removeAttr("checked");
            }

            fnUpdateBtnStatus();
        }

        function fnUpdateBtnStatus() {
            // 1 : Add,     2 : Remove
            if ($("#ConatntMatter_hdnPageType").val() == "1") {
                if ($("#divReport").find("input[type='checkbox']:checked").length == 0) {
                    $("#btnAddSBF").addClass("btn-disabled");
                    $("#btnAddSBF").removeAttr("onclick");
                }
                else {
                    $("#btnAddSBF").removeClass("btn-disabled");
                    $("#btnAddSBF").attr("onclick", "fnAddSBF()");
                }
            }
            else {
                if ($("#divReport").find("input[type='checkbox']:checked").length == 0) {
                    $("#btnRemoveAsProxy").addClass("btn-disabled");
                    $("#btnRemoveAsBase").addClass("btn-disabled");
                    $("#btnReplaceAsBase").addClass("btn-disabled");

                    $("#btnRemoveAsProxy").removeAttr("onclick");
                    $("#btnRemoveAsBase").removeAttr("onclick");
                    $("#btnReplaceAsBase").removeAttr("onclick");
                }
                else {
                    // 1 : Base,     0 : Proxy
                    if ($("#ConatntMatter_hdnSBFType").val() == "1") {
                        $("#btnRemoveAsBase").removeClass("btn-disabled");
                        $("#btnReplaceAsBase").removeClass("btn-disabled");

                        $("#btnRemoveAsBase").attr("onclick", "fnRemoveSBFAsBase()");
                        $("#btnReplaceAsBase").attr("onclick", "fnReplaceSBFAsBase()");

                        $("#btnRemoveAsProxy").addClass("btn-disabled");
                        $("#btnRemoveAsProxy").removeAttr("onclick");
                    }
                    else {
                        $("#btnRemoveAsProxy").removeClass("btn-disabled");
                        $("#btnRemoveAsProxy").attr("onclick", "fnRemoveSBFAsProxy()");

                        $("#btnRemoveAsBase").addClass("btn-disabled");
                        $("#btnReplaceAsBase").addClass("btn-disabled");

                        $("#btnRemoveAsBase").removeAttr("onclick");
                        $("#btnReplaceAsBase").removeAttr("onclick");
                    }
                }
            }
        }

        function fnAddSBF() {
            var selectedArr = [];
            var flgSBFType = $("#ConatntMatter_hdnSBFType").val();                  // 1 : Base, 0 : Proxy

            if (flgSBFType == "1") {
                $("#tblSBDBody").find("input[iden='SBD']:checked").each(function () {
                    selectedArr.push({ "col1": $(this).closest("tr").attr("strId") });
                });
            }
            else {
                $("#tblSBDBody").find("input[iden='BaseSBF']:checked").each(function () {
                    selectedArr.push({ "col1": $(this).closest("div").attr("strId") });
                });
            }
            if (selectedArr.length == 0) {
                AutoHideAlertMsg("Please make your selection for Action !");
                return false;
            }

            if (flgSBFType == "1") {
                $("#divSBFSelectionAsBaseProxy").html($("#ConatntMatter_hdnSBFMstr").val());
                $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr").each(function () {
                    $(this).attr("onclick", "fnSelectUnSelectSBF(this)");
                });

                var SBFNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
                var SBFNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
                $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").removeAttr("onclick");
                $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").addClass("Active-Base");

                var trhtml = $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']")[0].outerHTML;
                $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").remove();
                $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tbody").eq(0).prepend(trhtml);

                $("#divSBFSelectionAsBaseProxy").dialog({
                    "width": "60%",
                    "height": "560",
                    "title": "Select Proxy SBF :",
                    "modal": true,
                    open: function () {
                        //
                    },
                    close: function () {
                        $("#divSBFSelectionAsBaseProxy").dialog('destroy');
                    },
                    buttons: [{
                        text: 'Select',
                        class: 'btn-primary',
                        click: function () {
                            var ProxyArr = [];
                            ProxyArr.push({ "col1": SBFNodeID, "col2": SBFNodeType, "col3": SBFNodeID, "col4": SBFNodeType, "col5": "1" });
                            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[flg='1']").each(function () {
                                ProxyArr.push({ "col1": SBFNodeID, "col2": SBFNodeType, "col3": $(this).attr("nid"), "col4": $(this).attr("ntype"), "col5": "1" });
                            });

                            fnAddRemoveSBF(selectedArr, ProxyArr);
                            $("#divSBFSelectionAsBaseProxy").dialog('close');
                        }
                    },
                    {
                        text: 'Cancel',
                        class: 'btn-primary',
                        click: function () {
                            $("#divSBFSelectionAsBaseProxy").dialog('close');
                        }
                    }]
                });
            }
            else {
                var ProxyArr = [];
                ProxyArr.push({ "col1": "0", "col2": "0", "col3": "0", "col4": "0", "col5": "1" });

                fnAddRemoveSBF(selectedArr, ProxyArr);
            }
        }
        function fnSelectUnSelectSBF(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
            }
        }

        function fnRemoveSBFAsProxy() {
            var selectedArr = [];
            $("#tblSBDBody").find("input[iden='BaseSBF']:checked").each(function () {
                selectedArr.push({ "col1": $(this).closest("div").attr("strId") });
            });
            if (selectedArr.length == 0) {
                AutoHideAlertMsg("Please make your selection for Action !");
                return false;
            }

            var ProxyArr = [];
            ProxyArr.push({ "col1": "0", "col2": "0", "col3": "0", "col4": "0", "col5": "1" });

            fnAddRemoveSBF(selectedArr, ProxyArr);
        }
        function fnRemoveSBFAsBase() {
            var selectedArr = [];
            $("#tblSBDBody").find("input[iden='SBD']:checked").each(function () {
                selectedArr.push({ "col1": $(this).closest("tr").attr("strId") });
            });
            if (selectedArr.length == 0) {
                AutoHideAlertMsg("Please make your selection for Action !");
                return false;
            }

            var ProxyArr = [];
            ProxyArr.push({ "col1": "0", "col2": "0", "col3": "0", "col4": "0", "col5": "1" });

            fnAddRemoveSBF(selectedArr, ProxyArr);
        }
        function fnReplaceSBFAsBase() {
            var selectedArr = [];
            $("#tblSBDBody").find("input[iden='SBD']:checked").each(function () {
                selectedArr.push({ "col1": $(this).closest("tr").attr("strId") });
            });
            if (selectedArr.length == 0) {
                AutoHideAlertMsg("Please make your selection for Action !");
                return false;
            }

            $("#divSBFSelectionAsBaseProxy").html($("#ConatntMatter_hdnSBFMstr").val());
            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr").each(function () {
                $(this).attr("onclick", "fnReplaceBaseSBF(this)");
            });

            var SBFNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
            var SBFNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").removeAttr("onclick");
            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").addClass("Active");
            var trhtml = $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']")[0].outerHTML;
            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[nid='" + SBFNodeID + "']").remove();
            $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tbody").eq(0).prepend(trhtml);

            $("#divSBFSelectionAsBaseProxy").dialog({
                "width": "60%",
                "height": "560",
                "title": "Select Base SBF for Replacement :",
                "modal": true,
                open: function () {
                    //
                },
                close: function () {
                    $("#divSBFSelectionAsBaseProxy").dialog('destroy');
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var ProxyArr = [];
                        $("#divSBFSelectionAsBaseProxy").find("table").eq(0).find("tr[flg='1']").each(function () {
                            ProxyArr.push({ "col1": $(this).attr("nid"), "col2": $(this).attr("ntype"), "col3": "0", "col4": "0", "col5": "1" });
                        });

                        if (ProxyArr.length == 0) {
                            AutoHideAlertMsg("Please select Base SBF for Replacement !");
                            return false;
                        }
                        else {
                            fnAddRemoveSBF(selectedArr, ProxyArr);
                            $("#divSBFSelectionAsBaseProxy").dialog('close');
                        }
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divSBFSelectionAsBaseProxy").dialog('close');
                    }
                }]
            });
        }
        function fnReplaceBaseSBF(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active-Base");
            }
            else {
                $(ctrl).addClass("Active-Base").siblings().removeClass("Active-Base");
                $(ctrl).siblings().attr("flg", "0");
                $(ctrl).attr("flg", "1");
            }
        }

        function fnAddRemoveSBF(selectedArr, ProxyArr) {
            var SBFNodeID = $("#txtSBFSelection").attr("selectedstr").split("|")[0];
            var SBFNodeType = $("#txtSBFSelection").attr("selectedstr").split("|")[1];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var flgPage = $("#ConatntMatter_hdnPageType").val();                    // 1 : Add, 2 : Remove
            var flgSBFType = $("#ConatntMatter_hdnSBFType").val();                  // 1 : Base, 0 : Proxy

            var msg = "";
            // 1 : Add,     2 : Remove
            if (flgPage == "1") {
                if (flgSBFType == "1") {
                    msg = "Are you sure, you want to add <span style='color:#0000ff; font-weight: 700;'>" + $("#txtSBFSelection").val() + "</span> as Base, in selected SBD(s) ?";
                }
                else {
                    msg = "Are you sure, you want to add <span style='color:#0000ff; font-weight: 700;'>" + $("#txtSBFSelection").val() + "</span> as Proxy, in selected Base SBF(s) ?";
                }
            }
            else {
                if (flgSBFType == "1") {
                    msg = "Are you sure, you want to remove <span style='color:#0000ff; font-weight: 700;'>" + $("#txtSBFSelection").val() + "</span> as Base, in selected SBD(s) ?";
                }
                else {
                    msg = "Are you sure, you want to remove <span style='color:#0000ff; font-weight: 700;'>" + $("#txtSBFSelection").val() + "</span> as Proxy, in selected Base SBF(s) ?";
                }
            }

            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>" + msg + "</div>");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "320",
                "height": "200",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');

                        $("#dvloader").show();
                        PageMethods.fnAddRemoveSBF(SBFNodeID, SBFNodeType, LoginID, RoleID, UserID, flgPage, flgSBFType, selectedArr, ProxyArr, fnAddRemoveSBF_pass, fnfailed);
                    }
                },
                {
                    text: 'No',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
        }
        function fnAddRemoveSBF_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                if ($("#ConatntMatter_hdnPageType").val() == "1")
                    AutoHideAlertMsg("Sub-BrandForm added successfully !");
                else
                    AutoHideAlertMsg("Sub-BrandForm removed/replaced successfully !");

                fnGetDetails();
            }
            else if (res.split("|^|")[0] == "2") {
                $("#dvloader").hide();
                fnSBFInExistingSBD(res);
            }
            else {
                fnfailed();
            }
        }
        function fnSBFInExistingSBD(res) {
            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: justify;'>" + res.split("|^|")[1] + "</div>");

            $("#divConfirm").dialog({
                "modal": true,
                "width": "40%",
                "maxheight": "400",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Close',
                    class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');
                    }
                }]
            });
        }
    </script>
    <script type="text/javascript">
        function fnSBFPopuptypefilter(ctrl) {
            if ($(ctrl).attr("id") == "txtSBFSelection") {
                fnHideAdvFilter();
                $("#divbtnblock").find("a").removeClass("active");
            }

            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $(ctrl).next().show();
                //$("#bg").show();

                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[0].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
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
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $(ctrl).next().find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnSelectSBF(ctrl) {
            $(ctrl).closest("div").prev().val($(ctrl).find("td").eq(4).html().split("amp;").join(""));
            $(ctrl).closest("div").prev().attr("selectedstr", $(ctrl).attr("nid") + "|" + $(ctrl).attr("ntype"));

            if ($(ctrl).attr("id") == "txtSBFSelection" && $(ctrl).closest("div").prev().attr("selectedstr") != $(ctrl).attr("nid") + "|" + $(ctrl).attr("ntype")) {
                $("#btnClusterFilter").attr("selectedstr", "");
                $("#txtChannelHierSearch").attr("ProdHier", "")
                $("#rdManually").prop("checked", true);
                fnAdditionalSBFFilter(2);
            }
            $(ctrl).closest("div").hide();
        }
    </script>
    <script type="text/javascript">
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

        function fnShowProdHierPopup(ctrl) {
            var buckettype = $(ctrl).attr("buckettype");
            $("#ConatntMatter_hdnBucketType").val(buckettype);

            var title = "", strtable = "", width = "";
            if (buckettype == "1") {
                $("#ProdLvl").parent("div").next().next().addClass("col-6").removeClass("col-5");
                $("#ProdLvl").parent("div").next().addClass("col-6").removeClass("col-5");
                $("#ProdLvl").parent("div").hide();

                $("#divHierPopupTbl").html("");

                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:25%;'>Category</th>";
                strtable += "<th style='width:25%;'>Brand</th>";
                strtable += "<th style='width:25%;'>BrandForm</th>";
                strtable += "<th style='width:25%;'>SubBrandForm</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                width = "80%";
                title = "Sub-BrandForm(s) :";
                $("#PopupHierlbl").html("Sub-BrandForm");
            }
            else {
                $("#ProdLvl").parent("div").next().next().addClass("col-5").removeClass("col-6");
                $("#ProdLvl").parent("div").next().addClass("col-5").removeClass("col-6");
                $("#ProdLvl").parent("div").show();
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());

                $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
                $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");

                strtable += "<table class='table table-bordered table-sm table-hover'>";
                strtable += "<thead>";
                strtable += "<tr>";
                strtable += "<th style='width:30%;'>Class</th>";
                strtable += "<th style='width:35%;'>Channel</th>";
                strtable += "<th style='width:35%;'>Store Type</th>";
                strtable += "</tr>";
                strtable += "</thead>";
                strtable += "<tbody>";
                strtable += "</tbody>";
                strtable += "</table>";
                $("#divHierSelectionTbl").html(strtable);

                width = "96%";
                title = "Channel/s :";
                $("#PopupHierlbl").html("Channel Hierarchy");
            }

            $("#divHierPopup").dialog({
                "width": width,
                "height": "560",
                "title": title,
                "modal": true,
                open: function () {
                    if (buckettype == "1") {
                        fnProdLvl("40");
                    }
                    else {
                        if ($(ctrl).attr("ProdHier") != "") {
                            $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("ProdHier"));
                            fnProdLvl($(ctrl).attr("ProdHier").split("^")[0].split("|")[1]);
                        }
                        else
                            $("#ConatntMatter_hdnSelectedHier").val("");
                    }
                },
                close: function () {
                    //
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        fnProdSelected(ctrl);
                        $("#divHierPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        fnHierPopupReset();
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divHierPopup").dialog('close');
                    }
                }]
            });
        }
        function fnProdLvlSel(ctrl) {
            $(ctrl).closest("tr").addClass("Active").siblings().removeClass("Active");
            fnProdLvl($(ctrl).attr("ntype"));
        }
        function fnProdLvl(ProdLvl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            $("#divHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

            var BucketValues = [];
            if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                var Selstr = $("#ConatntMatter_hdnSelectedHier").val();
                for (var i = 0; i < Selstr.split("^").length; i++) {
                    BucketValues.push({
                        "col1": Selstr.split("^")[i].split("|")[0],
                        "col2": Selstr.split("^")[i].split("|")[1],
                        "col3": $("#ConatntMatter_hdnBucketType").val()
                    });
                }
            }

            if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                var InSubD = 0;
                //if ($("#chkIncludeSubd").is(":checked")) {
                //    InSubD = 1;
                //}

                PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, InSubD, fnProdHier_pass, fnProdHier_failed);
            }
            else {
                PageMethods.fnChannelHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
        }
        function fnProdHier_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divHierPopupTbl").html(res.split("|^|")[1]);
                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    $("#divHierSelectionTbl").html(res.split("|^|")[2]);
                    $("#ConatntMatter_hdnSelectedHier").val("");
                }

                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length > 0) {
                    var PrevSelLvl = $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                    var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl)) && ($("#ConatntMatter_hdnBucketType").val() != "2")) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html("");
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").each(function () {
                            if (Lvl == $(this).attr("lvl")) {
                                var tr = $("#divHierPopupTbl").find("table").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']");
                                fnSelectHier(tr.eq(0));
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
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "30":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "40":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "30") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[bf='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
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
                                                fnSelectHier(this);
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
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
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
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "140":
                                        if ($(this).attr("lvl") == "100") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cntry='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "110") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[reg='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "120") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[site='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        if ($(this).attr("lvl") == "130") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[dbr='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
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
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "220":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "210") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[channel='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this);
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
                fnProdHier_failed();
            }
        }
        function fnProdHier_failed() {
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
        function fnSelectHier(ctrl) {
            $(ctrl).attr("flg", "1");
            $(ctrl).addClass("Active");
            $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

            fnAppendSelection(ctrl, 1);
        }
        function fnSelectAllProd(ctrl) {
            if ($(ctrl).is(":checked")) {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "1");
                    $(this).addClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                    fnAppendSelection(this, 1);
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "0");
                    $(this).removeClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                    fnAppendSelection(this, 0);
                });
            }
        }
        function fnSelectUnSelectProd(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                fnAppendSelection(ctrl, 0);
                $("#chkSelectAllProd").removeAttr("checked");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                fnAppendSelection(ctrl, 1);
            }
        }
        function fnAppendSelection(ctrl, flgSelect) {
            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");

            if (flgSelect == 1) {
                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").length == 0) {
                    var strtr = "";
                    if (BucketType == "1") {
                        switch (Lvl) {
                            case "10":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("cat") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='20'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "20":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("brand") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "30":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("bf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][bf='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "40":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("sbf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else if (BucketType == "2") {
                        switch (Lvl) {
                            case "100":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("cntry") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='110'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][cntry='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "110":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("reg") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='120'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][reg='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "120":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("site") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>All</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130'][site='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][site='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "130":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("dbr") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td><td>All</td>";
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][dbr='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "140":
                                strtr += "<tr lvl='" + Lvl + "' cntry='" + $(ctrl).attr("cntry") + "' reg='" + $(ctrl).attr("reg") + "' site='" + $(ctrl).attr("site") + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' nid='" + $(ctrl).attr("branch") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td><td>" + $(ctrl).find("td").eq(6).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else {
                        switch (Lvl) {
                            case "200":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("cls") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='210'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "210":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("channel") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][channel='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "220":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("storetype") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";
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
                    $(ctrl).attr("InSubD", "0");
                }
                else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                    $(ctrl).attr("InSubD", "0");
                }
                else {
                    $(ctrl).attr("InSubD", "0");
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
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "110":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "120":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                    case "130":
                        descr += ", " + $(this).find("td").eq(3).html();
                        break;
                    case "140":
                        descr += ", " + $(this).find("td").eq(4).html();
                        break;
                    case "145":
                        descr += ", " + $(this).find("td").eq(5).html();
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
    <script type="text/javascript">
        function fnClusterPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
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
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnShowClusterPopup(ctrl) {
            $("#divClusterPopupTbl").html("<div style='margin-top: 25%; text-align: center;'><img alt='Loading...' title='Loading...' src='../../Images/loading.gif' /></div>");

            $("#divClusterPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": "Cluster(s) :",
                open: function () {
                    var strtable = "";
                    strtable += "<table class='table table-bordered table-sm table-hover'>";
                    strtable += "<thead>";
                    strtable += "<tr>";
                    strtable += "<th style='width:15%;'>Country</th>";
                    strtable += "<th style='width:25%;'>Region</th>";
                    strtable += "<th style='width:20%;'>Site</th>";
                    strtable += "<th style='width:35%;'>Distributor</th>";
                    strtable += "</tr>";
                    strtable += "</thead>";
                    strtable += "<tbody>";
                    strtable += "</tbody>";
                    strtable += "</table>";
                    $("#divClusterSelectionTbl").html(strtable);

                    var selectedstr = $(ctrl).attr("selectedstr");

                    var LoginID = $("#ConatntMatter_hdnLoginID").val();
                    var RoleID = $("#ConatntMatter_hdnRoleID").val();
                    var UserID = $("#ConatntMatter_hdnUserID").val();
                    var Qtr = $("#ddlQuarter").val().split("|")[2];
                    var Yr = $("#ddlQuarter").val().split("|")[3];

                    PageMethods.GetClusters(LoginID, RoleID, UserID, "4", Qtr, Yr, GetClusters_pass, GetClusters_failed, selectedstr);
                },
                buttons: [{
                    text: 'Select',
                    class: 'btn-primary',
                    click: function () {
                        var selectedstr = "";
                        $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
                            selectedstr += "^" + $(this).attr("clusterid");
                        });
                        if (selectedstr != "") {
                            selectedstr = selectedstr.substring(1);
                        }

                        $(ctrl).attr("selectedstr", selectedstr);
                        $("#divClusterPopup").dialog('close');
                    }
                },
                {
                    text: 'Reset',
                    class: 'btn-primary',
                    click: function () {
                        fnClusterPopupReset();
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divClusterPopup").dialog('close');
                    }
                }]
            });
        }
        function GetClusters_pass(res, selectedstr) {
            $("#divClusterPopupTbl").html(res)

            if (selectedstr != "") {
                for (var i = 0; i < selectedstr.split("^").length; i++) {
                    var tr = $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[clusterid='" + selectedstr.split("^")[i] + "']");
                    tr.eq(0).attr("flg", "1");
                    tr.eq(0).addClass("Active");
                    tr.eq(0).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
                }
                fnGetSelHierTbl();
            }
        }
        function GetClusters_failed() {
            $("#divClusterPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
        }

        function fnSelectUnSelectCluster(ctrl) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");
            }
            fnGetSelHierTbl();
        }
        function fnGetSelHierTbl() {
            var BucketValues = [];
            if ($("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").length > 0)
                $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                    var Selstr = $(this).attr("strvalue");
                    for (var i = 0; i < Selstr.split("^").length; i++) {
                        BucketValues.push({
                            "col1": Selstr.split("^")[i].split("|")[0],
                            "col2": Selstr.split("^")[i].split("|")[1],
                            "col3": "2"
                        });
                    }
                });

            if (BucketValues.length > 0) {
                $("#dvloader").show();
                PageMethods.GetSelHierTbl(BucketValues, "4", "0", GetSelHierTbl_pass, GetSelHierTbl_failed);
            }
            else {
                $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
            }
        }
        function GetSelHierTbl_pass(res) {
            $("#dvloader").hide();
            $("#divClusterSelectionTbl").html(res);
        }
        function GetSelHierTbl_failed() {
            $("#dvloader").hide();
            $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("<tr><td colspan='4' style='text-align: center; padding: 50px 10px 0 10px;'>Due to some technical reasons, we are unable to Process your request !</td></tr>");
        }

        function fnClusterPopupReset() {
            $("#divClusterPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");

            $("#divClusterPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").each(function () {
                $(this).attr("flg", "0");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
                $(this).removeClass("Active");
            });

            $("#divClusterSelectionTbl").find("table").eq(0).find("tbody").eq(0).html("");
        }
    </script>
    <script type="text/javascript">
        function fnShowAdvFilter(ctrl, flgSBF) {
            if ($("#txtSBFSelection").val() == "") {
                AutoHideAlertMsg("Please select the Sub-BrandForm !");
                return false;
            }
            else
                $("#txtSBFSelection").next().hide();

            var flg = $("#AdvFilter").attr("flgVisible");
            $("#AdvFilter").show();
            $("#AdvFilter").attr("flgVisible", "1");
            $("#ConatntMatter_hdnSBFType").val(flgSBF);                             // 1 : Base, 0 : Proxy
            $(ctrl).addClass("active").siblings().removeClass("active");
            $("#dvSBDBody").height((ht - ($("#Filter").height() + 220)) + "px");

            //setTimeout(function () {
            //    $("#divReport").height((ht - ($("#Filter").height() + 170)) + "px");
            //}, 1000);
        }
        function fnHideAdvFilter() {
            $("#AdvFilter").hide();
            $("#AdvFilter").attr("flgVisible", "0");
            $("#dvSBDBody").height((ht - ($("#Filter").height() + 220)) + "px");

            //setTimeout(function () {
            //    $("#divReport").height((ht - ($("#Filter").height() + 170)) + "px");
            //}, 1000);
        }

        function fnAdditionalSBFFilter(cntr) {
            var str = "";
            if (cntr == 1) {
                str += "<tr iden='trSBFAdvFilter'>";
                str += "<td>";
                str += "<div style='position: relative;'>";
                str += "Mapped with SBF : <input type='text' onclick='fnSBFPopuptypefilter(this);' onkeyup='fnSBFPopuptypefilter(this);' autocomplete='off' placeholder='Type atleast 3 character...' selectedstr=''>";
                str += "<div class='clsSBFPopup' style='position: fixed; margin-left: 121px;'>" + $("#ConatntMatter_hdnSBFMstr").val() + "</div>";
                str += "</div>";
                str += "<td>";
                str += "<td><input type='radio' name='SBFAdvFilter_0' checked>&nbsp; Add where as Proxy</td>";
                str += "<td><input type='radio' name='SBFAdvFilter_0'>&nbsp; Add where Used as Base</td>";
                str += "<td><i class='fa fa-plus' onclick='fnAddtrInAdditionalSBFFiltertbl(this);'></i>&nbsp;<i class='fa fa-minus'  onclick='fnRemovetrInAdditionalSBFFiltertbl(this);'></i></td>";
                str += "</tr>";

                $("#AdditionalSBFFilter").show();
                $("#AdditionalSBFFilter").find("tbody").eq(0).html(str);
            }
            else {
                $("#AdditionalSBFFilter").hide();
                $("#AdditionalSBFFilter").find("tbody").eq(0).html("");
            }
        }
        function fnAddtrInAdditionalSBFFiltertbl(ctrl) {
            if ($(ctrl).closest("tr").find("input[type='text']").eq(0).attr("selectedstr") != "") {
                var str = "<tr iden='trSBFAdvFilter'>";
                str += "<td>";
                str += "<div style='position: relative;'>";
                str += "Mapped with SBF : <input type='text' onclick='fnSBFPopuptypefilter(this);' onkeyup='fnSBFPopuptypefilter(this);' autocomplete='off' placeholder='Type atleast 3 character...' selectedstr=''>";
                str += "<div class='clsSBFPopup' style='position: fixed; margin-left: 121px;'>" + $("#ConatntMatter_hdnSBFMstr").val() + "</div>";
                str += "</div>";
                str += "<td>";
                if ($(ctrl).closest("tr").find("input[type='radio']").eq(0).is(":checked")) {
                    str += "<td><input type='radio' name='SBFAdvFilter_" + ($(ctrl).closest("tbody").eq(0).find("tr").length + 1) + "' checked>&nbsp; Add where as Proxy</td>";
                    str += "<td><input type='radio' name='SBFAdvFilter_" + ($(ctrl).closest("tbody").eq(0).find("tr").length + 1) + "'>&nbsp; Add where Used as Base</td>";
                }
                else {
                    str += "<td><input type='radio' name='SBFAdvFilter_" + ($(ctrl).closest("tbody").eq(0).find("tr").length + 1) + "'>&nbsp; Add where as Proxy</td>";
                    str += "<td><input type='radio' name='SBFAdvFilter_" + ($(ctrl).closest("tbody").eq(0).find("tr").length + 1) + "' checked>&nbsp; Add where Used as Base</td>";
                }
                str += "<td><i class='fa fa-plus' onclick='fnAddtrInAdditionalSBFFiltertbl(this);'></i>&nbsp;<i class='fa fa-minus'  onclick='fnRemovetrInAdditionalSBFFiltertbl(this);'></i></td>";
                str += "</tr>";

                $(ctrl).closest("tr").after(str);
            }
            else {
                AutoHideAlertMsg("Before adding a new filter, firstly made your selection in current row !");
            }
        }
        function fnRemovetrInAdditionalSBFFiltertbl(ctrl) {
            $(ctrl).closest("tr").remove();
        }
    </script>

    <style type="text/css">
        i {
            cursor: pointer;
        }

        .fsw {
            margin-bottom: 0;
        }

        .fsw-title {
            text-transform: none;
        }

        .fixed-top {
            z-index: 98;
        }

        .bg {
            z-index: 100;
            min-height: 100%;
            width: 100%;
            height: auto;
            top: 0px;
            left: 0px;
            position: fixed;
            display: none;
            background: rgba(0, 0, 0, 0.3);
        }

        .clsInform {
            word-break: break-all;
            white-space: inherit;
        }

        #divSBFSelectionAsBaseProxy table tr.Active,
        #divClusterPopupTbl table tr.Active,
        #divHierPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        #divSBFSelectionAsBaseProxy table tr.Active-Base {
            background: #AEAEFF;
        }
    </style>
    <style type="text/css">
        div.clsSBFPopup {
            width: 50%;
            height: 240px;
            display: none;
            z-index: 101;
            overflow-y: auto;
            background: #ffffff;
            border: 1px solid #444;
        }

            div.clsSBFPopup table td {
                padding: 0.1rem 0.3rem;
            }
    </style>
    <style type="text/css">
        div.clsSBD-block {
            margin: 0 0 10px 0;
            border-radius: 4px;
            border: 1px solid #D77100;
        }

            div.clsSBD-block i,
            div.clsSBD-block input[type='checkbox'] {
                height: 11px;
                cursor: pointer;
                margin-right: 10px;
            }

        div.clsSBD {
            color: #ffffff;
            padding: 4px 10px;
            font-size: 0.9rem;
            font-weight: 600;
            background: #FF8600;
        }

        div.clsBaseSBF {
            padding: 3px 12px;
            margin-right: 5px;
            border-radius: 5px;
            background: #eef4ff;
            display: inline-block;
            border: 1px solid #bfbfff;
        }

            div.clsBaseSBF > input[type='checkbox'] {
                height: 10px;
                margin-right: 3px;
            }

        #tblSBDHeader input[type='text'] {
            width: 100%;
            margin:3px 0;
            padding-left: 10px;
            border-radius: 3px;
        }

        #tblSBDHeader tr th {
            text-align: center;
            vertical-align: middle;
        }

            #tblSBDHeader tr th:nth-child(1),
            #tblSBDBody tr td:nth-child(1) {
                width: 50px;
                text-align: center;
            }

            #tblSBDHeader tr th:nth-child(2),
            #tblSBDBody tr td:nth-child(2),
            #tblSBDHeader tr th:nth-child(3),
            #tblSBDBody tr td:nth-child(3) {
                width: 200px;
            }
    </style>
    <style type="text/css">
        .btn-inactive {
            color: #F26156 !important;
            background: transparent !important;
        }

        .btn-disabled {
            cursor: not-allowed;
            color: #000 !important;
            box-shadow: none !important;
            background: #888 !important;
            border-color: #888 !important;
        }

        .btn-primary {
            background: #F26156;
            border-color: #F26156;
            color: #fff;
        }

            .btn-primary:focus {
                box-shadow: 0 0 0 0.2rem rgba(216,31,16,0.2) !important;
            }

            .btn-primary:not(:disabled):not(.disabled).active,
            .btn-primary:not(:disabled):not(.disabled):active,
            .show > .btn-primary.drop,
            .btn-primary:active,
            .btn-primary:hover {
                background: #be1b0e !important;
                border-color: #be1b0e;
                color: #fff !important;
            }

        a.btn-small {
            cursor: pointer;
            font-size: 0.6rem;
            margin: 0.2rem 0;
            padding: 0 0.4rem 0.1rem;
            color: #ffffff !important;
        }
    </style>
    <style type="text/css">
        .clsSec-AdvFilter {
            font-weight: 600;
        }

            .clsSec-AdvFilter > .d-block {
                color: #003DA7;
            }

            .clsSec-AdvFilter input[type='radio'],
            .clsSec-AdvFilter input[type='checkbox'] {
                height: 10px;
            }

        #AdditionalSBFFilter {
            border: 1px solid #009999;
            border-radius: 4px;
            margin: 5px 0 0;
            padding: 4px 8px 0;
            display: none;
        }

        table.clsAdditionalSBFFiltertbl {
            width: 100%;
            color: #444;
        }

            table.clsAdditionalSBFFiltertbl td {
                font-size: 0.7rem;
                padding-top: 3px;
                border-bottom: 1px solid #ddd;
            }

                table.clsAdditionalSBFFiltertbl td input[type='text'] {
                    width: 160px;
                    margin-left: 5px;
                }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="margin-bottom: 0.1rem;"></h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-100">
                <div class="row">
                    <div class="col-4">
                        <div class="fsw-title" id="lblStep1"></div>
                        <div class="d-block">
                            <div style="position: relative;">
                                <input id='txtSBFSelection' type='text' class='form-control form-control-sm' onclick='fnSBFPopuptypefilter(this);' onkeyup='fnSBFPopuptypefilter(this);' autocomplete="off" placeholder='Type atleast 3 character...' selectedstr="" style="width: 360px;" />
                                <div class="clsSBFPopup" style="position: fixed;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="fsw-title" id="lblStep2"></div>
                        <div class="d-block">
                            <select id="ddlQuarter" class="form-control form-control-sm" style="width: 200px;"></select>
                        </div>
                    </div>
                    <div class="col-5">
                        <div class="fsw-title" id="lblStep3"></div>
                        <div class="d-block" id="divbtnblock">
                            <a href='#' id="btnBase" onclick="fnShowAdvFilter(this, 1);" class="btn btn-primary btn-sm"></a>
                            <a href='#' id="btnProxy" onclick="fnShowAdvFilter(this, 0);" class="btn btn-primary btn-sm" style="margin-left: 20px;"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="AdvFilter" flgvisible="0" class="fsw_inner" style="margin-top: 5px; display: none;">
            <div class="fsw_inputBox w-100">
                <div class="row clsSec-AdvFilter">
                    <div class="col-4">
                        <div class="fsw-title" id="lblStep4"></div>
                        <div class="d-block">
                            <a id="btnClusterFilter" class="btn btn-primary btn-sm" href="#" selectedstr="" onclick="fnShowClusterPopup(this);" title="Cluster Filter">Cluster Filter</a>
                            <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this);" title="Channel Filter" style="margin-left: 20px;">Channel Hierarchy Filter</a>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="fsw-title" id="lblStep5"></div>
                        <div class="d-block">
                            <div style="color: #009999;">
                                <input id="rdManually" type="radio" name="advfilter" onclick="fnAdditionalSBFFilter(2);" checked />&nbsp;Manually Add.
                                <br />
                                <input id="rdAdditionalSBF" type="radio" name="advfilter" onclick="fnAdditionalSBFFilter(1);" />&nbsp;Add with Condition.
                            </div>
                            <div id="AdditionalSBFFilter">
                                <table class='clsAdditionalSBFFiltertbl'>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="fsw-title" style="text-align: right; margin-bottom: 0; font-size: 1rem;"><i class="fa fa-window-close" onclick="fnHideAdvFilter();"></i></div>
                        <div class="d-block">
                            <a href='#' onclick="fnGetDetails();" class="btn btn-primary btn-sm" style="margin-left: 10px;">Next ..</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="divReport"></div>
    <div id="divFooter" style="width: 100%; background: #ddd; border: 1px solid #ccc; position: fixed; bottom: 0; padding: 6px 0; margin-left: -23px;">
        <div id="divButtons" style="width: 100%; display: inline-block; text-align: right;">
            <a id="btnAddSBF" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnAddSBF();">Add Sub-BrandForm</a>
            <a id="btnReplaceAsBase" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnReplaceSBFAsBase();">Replace Base SBF</a>
            <a id="btnRemoveAsBase" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnRemoveSBFAsBase();">Remove Base SBF</a>
            <a id="btnRemoveAsProxy" href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 20px;' onclick="fnRemoveSBFAsProxy();">Remove Proxy SBF</a>
        </div>
    </div>
    <div id="divHierPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-2">
                <div id="ProdLvl" class="prodLvl"></div>
            </div>
            <div class="col-5">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div id="PopupHierlbl" class="d-block"></div>
                    </div>
                    <div id="divHierPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-5">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divHierSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divClusterPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-7">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div class="d-block">Cluster(s)</div>
                    </div>
                    <div id="divClusterPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-5">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divClusterSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="divSBFSelectionAsBaseProxy" style="display: none;"></div>

    <div id="divMsg" runat="server"></div>
    <div id="divConfirm" style="display: none;"></div>

    <div class="bg" id="bg"></div>
    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnPageType" runat="server" />
    <asp:HiddenField ID="hdnSBFType" runat="server" />

    <asp:HiddenField ID="hdnSBFMstr" runat="server" />
    <asp:HiddenField ID="hdnQuarter" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />

    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
</asp:Content>

