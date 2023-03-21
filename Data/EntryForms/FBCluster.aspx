<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="FBCluster.aspx.cs" Inherits="_FBCluster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
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
                var mousey = ht - (e.pageY + $('.customtooltip').height() - 50) > 0 ? e.pageY : (e.pageY - $('.customtooltip').height() - 40);   //Get Y coordinates
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

        $(document).ready(function () {
            ht = $(window).height();
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#ConatntMatter_TabHead").height() + $("#AddNewBtn").height() + 150));

            $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
            fnGetReport();
        });

        function fnMonth(ctrl) {
            $("#ConatntMatter_TabHead").find("a").removeClass("active");
            $(ctrl).find("a").eq(0).addClass("active");
            $("#ConatntMatter_hdnMonth").val($(ctrl).attr("StartDate") + "|" + $(ctrl).attr("EndDate") + "|" + $(ctrl).attr("flgEdit"));

            fnGetReport();
        }

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
        function fnSearch() {
            fnGetReport();
        }
        function fnResetFilter() {
            $("#txtLocationHierSearch").attr("selhier", "");
            $("#txtLocationHierSearch").attr("lvl", "");

            fnGetReport();
        }

        function fnGetReport() {
            $("#txtfilter").val('');

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var FromDate = $("#ConatntMatter_hdnMonth").val().split("|")[0];
            var EndDate = $("#ConatntMatter_hdnMonth").val().split("|")[1];
            var FlgEdit = $("#ConatntMatter_hdnMonth").val().split("|")[2];

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, UserID, RoleID, FromDate, EndDate, FlgEdit, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
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
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();

                $("#divReport").html("");
                $("#divHeader").html("");
                AutoHideAlertMsg(res.split("|^|")[1]);
            }
            else {
                $("#divReport").html("");
                $("#divHeader").html("");
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnAddNew() {
            var FlgEdit = $("#ConatntMatter_hdnMonth").val().split("|")[2];
            if (FlgEdit == "1") {
                var str = "";
                str += "<tr strId='0' style='display: table-row;'>";
                str += "<td></td>";
                str += "<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'></textarea></td>";
                str += "<td><span></span><img src='../../Images/edit.png' title='click to select Branch' selhier='' onclick='fnShowLocHierPopup(this, 1);'  style='float:right;'/></td>";
                str += "<td class='clstdAction'><img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
                str += "</tr>";

                $("#tblReport").find("tbody").eq(0).prepend(str);
                $("#tblReport").find("tbody").eq(0).find("tr").eq(0).find("textarea").eq(0).on('input', function () {
                    this.style.height = 'auto';
                    this.style.height = (this.scrollHeight) + 'px';
                });
            }
            else {
                AutoHideAlertMsg("This functionality is not allowed for Selected Quarter !");
            }
        }
        function fnEdit(ctrl) {
            var str = $(ctrl).closest("tr").attr("str");
            var strLoc = $(ctrl).closest("tr").attr("strLoc");

            $(ctrl).closest("tr").find("td").eq(1).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + str + "</textarea>");
            $(ctrl).closest("tr").find("td").eq(2).html("<span>" + strLoc.split("~")[0] + "</span><img src='../../Images/edit.png' title='click to select Branch' selhier='" + strLoc.split("~")[1] + "' onclick='fnShowLocHierPopup(this, 1);'  style='float:right;'/>");

            $(ctrl).closest("tr").find("textarea").eq(0).css("height", "auto");
            $(ctrl).closest("tr").find("textarea").eq(0).css("height", $(ctrl).closest("tr").find("textarea")[0].scrollHeight + "px");
            $(ctrl).closest("tr").find("textarea").eq(0).on('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");
        }
        function fnCancel(ctrl) {
            var strId = $(ctrl).closest("tr").attr("strId");
            if (strId == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var str = $(ctrl).closest("tr").attr("str");
                var strLoc = $(ctrl).closest("tr").attr("strLoc");
                var strLocDsply = strLoc.split("~")[0].length > 70 ? strLoc.split("~")[0].substr(0, 68) + ".." : strLoc.split("~")[0];

                $(ctrl).closest("tr").find("td").eq(1).html(str);
                $(ctrl).closest("tr").find("td").eq(2).html(strLocDsply);
                $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);' style='margin-right: 12px;'/>");
            }
        }

        // ----- Not In Use ---------------
        function fnDelete(ctrl) {
            var ClusterID = $(ctrl).closest("tr").attr("strId");
            var ClusterName = $(ctrl).closest("tr").attr("str");

            $("#divConfirm").html("Are you sure, you want to remove <span style='color: #00f;'>" + ClusterName + "</span>.");
            $("#divConfirm").dialog({
                "modal": true,
                "width": "20%",
                "maxheight": "400",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                },
                buttons: [{
                    text: 'Yes',
                    class: 'btn-primary',
                    click: function () {
                        $("#dvloader").show();
                        PageMethods.fnRemoveCluster(ClusterID, fnRemoveCluster_pass, fnfailed);
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
        function fnRemoveCluster_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divConfirm").dialog('close');
                AutoHideAlertMsg("Cluster removed successfully !");
                fnGetReport();
            }
            else {
                fnfailed();
            }
        }

        function fnSave(ctrl, flgOverwrite) {
            var ClusterID = $(ctrl).closest("tr").attr("strId");
            var ClusterName = $(ctrl).closest("tr").find("td").eq(1).find("textarea").eq(0).val();
            var LocList = [];
            var strLocList = $(ctrl).closest("tr").find("td").eq(2).find("img").eq(0).attr("selhier");
            var StartDate = $("#ConatntMatter_hdnMonth").val().split("|")[0];
            var EndDate = $("#ConatntMatter_hdnMonth").val().split("|")[1];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();

            if (ClusterName == "") {
                AutoHideAlertMsg("Please enter the Cluster Name !");
                return false;
            }
            else if (strLocList == "") {
                AutoHideAlertMsg("Please select the Branch(s) !");
                return false;
            }
            else {
                for (var i = 0; i < strLocList.split("^").length; i++) {
                    LocList.push({
                        "col1": ClusterID,
                        "col2": strLocList.split("^")[i].split("|")[0],
                        "col3": strLocList.split("^")[i].split("|")[1]
                    });
                }

                $("#dvloader").show();
                PageMethods.fnSave(ClusterID, ClusterName, LocList, StartDate, EndDate, LoginID, UserID, RoleID, flgOverwrite, fnSave_pass, fnfailed, ctrl);
            }
        }
        function fnLocInExistingCluster(res, ctrl) {
            $("#divConfirm").html(res.split("|^|")[1]);

            $("#divConfirm").dialog({
                "modal": true,
                "width": "50%",
                "maxheight": "400",
                "title": "Message :",
                close: function () {
                    $("#divConfirm").dialog('destroy');
                }
                //buttons: [{
                //    text: 'Yes',
                //    class: 'btn-primary',
                //    click: function () {
                //        $("#divConfirm").dialog('close');
                //        fnSave(ctrl, "1");
                //    }
                //},
                //{
                //    text: 'No',
                //    class: 'btn-primary',
                //    click: function () {
                //        $("#divConfirm").dialog('close');
                //    }
                //}]
            });
        }
        function fnSave_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                if ($(ctrl).closest("tr").attr("strId") == "0")
                    AutoHideAlertMsg("Cluster saved successfully !");
                else
                    AutoHideAlertMsg("Cluster details updated successfully !");

                fnGetReport();
            }
            else if (res.split("|^|")[0] == "1") {
                $("#dvloader").hide();
                fnLocInExistingCluster(res, ctrl);
            }
            else if (res.split("|^|")[0] == "2") {
                AutoHideAlertMsg("Cluster name already exist !");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
    </script>
    <script type="text/javascript">
        function fnImportPrevMonthCluster() {
            $("#divPrevMonthCluster").dialog({
                "modal": true,
                "width": "96%",
                "height": "550",
                "title": "Import Cluster(s) from Previous Month(s) :",
                close: function () {
                    $("#divPrevMonthCluster").dialog('destroy');
                },
                buttons: [{
                    text: 'Submit',
                    class: 'btn-primary',
                    click: function () {
                        fnSubmitPrevMonthCluster();
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divPrevMonthCluster").dialog('close');
                    }
                }]
            });

            fnPrevMonth($("#ConatntMatter_PopupTab").find("li"));
        }

        function fnPrevMonth(ctrl) {
            $("#ConatntMatter_PopupTab").find("a").removeClass("active");
            $(ctrl).find("a").eq(0).addClass("active");

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var FromDate = $(ctrl).attr("StartDate");
            var EndDate = $(ctrl).attr("EndDate");

            $("#ConatntMatter_hdnImportPrevMonthtoCurrent").val(FromDate + "|" + EndDate);

            $("#dvloader").show();
            PageMethods.fnGetPrevMonthClusters(LoginID, UserID, RoleID, FromDate, EndDate, fnGetPrevMonthClusters_pass, fnfailed);
        }
        function fnGetPrevMonthClusters_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divExistingCluster").html(res.split("|^|")[1]);
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fnSubmitPrevMonthCluster() {
            var PrevMonthStartDate = $("#ConatntMatter_hdnImportPrevMonthtoCurrent").val().split("|")[0];
            var PrevMonthEndDate = $("#ConatntMatter_hdnImportPrevMonthtoCurrent").val().split("|")[1];
            var StartDate = $("#ConatntMatter_hdnMonth").val().split("|")[0];
            var EndDate = $("#ConatntMatter_hdnMonth").val().split("|")[1];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var Arr = [];

            $("#divExistingCluster").find("input[type='checkbox']:checked").each(function () {
                Arr.push({
                    "col1": $(this).closest("tr").attr("strid"),
                    "col2": "0",
                    "col3": "0"
                });
            });

            if (Arr.length > 0) {
                $("#dvloader").show();
                PageMethods.fnImportPrevMonthCluster(PrevMonthStartDate, PrevMonthEndDate, Arr, StartDate, EndDate, LoginID, UserID, RoleID, fnImportPrevMonthCluster_pass, fnfailed);
            }
            else
                AutoHideAlertMsg("Please select Cluster(s) for Importing !");
        }
        function fnImportPrevMonthCluster_pass(res) {
            if (res.split("|^|")[0] == "0") {
                $("#divPrevMonthCluster").dialog('close');
                fnGetReport();
            }
            else {
                fnfailed();
            }
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

        function fnShowLocHierPopup(ctrl, cntr) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val(cntr);
            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");

            var title = "Branch";
            $("#divHierPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
                    strtable += "<table class='table table-bordered table-sm table-hover'>";
                    strtable += "<thead>";
                    strtable += "<tr>";
                    strtable += "<th style='width:15%;'>Country</th>";
                    strtable += "<th style='width:20%;'>Region</th>";
                    strtable += "<th style='width:20%;'>Site</th>";
                    strtable += "<th style='width:25%;'>Distributor</th>";
                    strtable += "<th style='width:20%;'>Branch</th>";
                    strtable += "</tr>";
                    strtable += "</thead>";
                    strtable += "<tbody>";
                    strtable += "</tbody>";
                    strtable += "</table>";
                    $("#divHierSelectionTbl").html(strtable);
                    $("#PopupHierlbl").html("Location Hierarchy");

                    if ($(ctrl).attr("selhier") != "") {
                        $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("selhier"));
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("selhier").split("^")[0].split("|")[1] + "']").eq(0));
                    }
                    else
                        $("#ConatntMatter_hdnSelectedHier").val("");
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
        function fnProdLvl(ctrl) {
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
                        "col3": "2"
                    });
                }
            }

            PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed);
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
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl))) {
                        //$("#divHierSelectionTbl").find("tbody").eq(0).html("");
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
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flg='1']").each(function () {
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
            var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");

            if (flgSelect == 1) {
                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").length == 0) {
                    var strtr = "";
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
            var SelectedHier = "", descr = "";
            $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
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
                }
            });
            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                descr = descr.substring(1);
            }

            $(ctrl).attr("selhier", SelectedHier);
            $(ctrl).prev().html(descr);
        }
    </script>

    <style type="text/css">
        .fsw .fsw_inner {
            border: none;
        }

        .fsw_inputBox {
            background: #fff;
            border-radius: 3px;
            margin-right: 5px;
            border: solid 1px #b9c8e3;
            min-height: 76px;
        }

        .tab-content {
            padding-left: 0;
        }
    </style>
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
        #tblReport_header th {
            text-align: center;
        }

        table.clsReport tr td:nth-child(1) {
            width: 5%;
            text-align: center;
        }

        table.clsReport tr td:nth-child(2) {
            width: 30%;
        }

        table.clsReport tr td:nth-child(3) {
            width: 55%;
            font-size: 0.65rem;
        }

            table.clsReport tr td:nth-child(3) span {
                display: inline-block;
                width: 90%;
            }

        table.clsReport tr td:nth-child(4) {
            width: 15%;
            text-align: center;
        }

        #tblPrevQtrCluster th,
        #tblPrevQtrCluster td {
            font-size: 0.8rem;
        }

        #tblPrevQtrCluster tr td:nth-child(1) {
            width: 5%;
            text-align: center;
        }
        #tblPrevQtrCluster tr td:nth-child(2) {
            width: 30%;
        }
        #tblPrevQtrCluster tr td:nth-child(3) {
            font-size: 0.7rem;
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
                    font-size: .62rem;
                    padding: .1rem .3rem;
                    border: 1px solid #dee2e6;
                }

            .customtooltip table > tbody > tr:nth-of-type(2n+1) {
                background-color: rgba(0,61,167,.10);
            }

            .customtooltip table > thead > tr > th:nth-of-type(2n-1),
            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                border-left: 3px solid #4289FF;
            }

            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                color: #003DA7;
            }
    </style>
    <style type="text/css">
        .btn-primary {
            background: #F26156 !important;
            border-color: #F26156;
            color: #fff !important;
        }

            .btn-primary:focus {
                box-shadow: 0 0 0 0.2rem rgba(216,31,16,0.2) !important;
            }

            .btn-primary:not(:disabled):not(.disabled).active,
            .btn-primary:not(:disabled):not(.disabled):active,
            .show > .btn-primary.drop,
            .btn-primary:active,
            .btn-primary:hover {
                background: #D81F10 !important;
                border-color: #D81F10;
                color: #fff !important;
            }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading">FB Cluster Master</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox" id="divTypeSearchFilterBlock" style="width: 80%;">
                <div class="fsw-title">Search Box</div>
                <div class="d-block">
                    <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Type atleast 3 characters .." />
                </div>
            </div>
            <div class="fsw_inputBox" id="divAddNewCopyBtnBlock" style="width: 20%;">
                <div class="fsw-title">Cluster</div>
                <div class="d-block">
                    <a href="#" class="btn btn-primary btn-sm" id="btnAddNew" onclick="fnAddNew();" title="Add New Cluster"><i class="fa fa-plus-square"></i>&nbsp; Add New</a>
                    <a href="#" class="btn btn-primary btn-sm" id="btnCopy" onclick="fnImportPrevMonthCluster();" title="Import Cluster from Previous Mont(s) to Current Month" style="margin-left: 5%;"><i class="fa fa-clone"></i>&nbsp; Import</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist" id="TabHead" runat="server">
        <%--<li><a class="nav-link active" href="#">Product Bucket</a></li>--%>
    </ul>
    <!-- Tab panes -->
    <div id="tab-content" class="tab-content">
        <div role="tabpanel" class="tab-pane fade show active w-75" style="margin: 0 auto;">
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
    <div id="divPrevMonthCluster" style="display: none; font-size: 0.9rem; font-weight: 600; color: #7A7A7A;">
        <ul class="nav nav-tabs" id="PopupTab" runat="server"></ul>
        <div id="divExistingCluster" style="height: 400px; overflow-y: auto;"></div>
    </div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="divConfirm" style="display: none; font-size: 0.9rem; font-weight: 600; color: #7A7A7A;"></div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />

    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    
    <asp:HiddenField ID="hdnMonth" runat="server" />
    <asp:HiddenField ID="hdnImportPrevMonthtoCurrent" runat="server" />
</asp:Content>
