<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="BucketMstr.aspx.cs" Inherits="_BucketMstr" %>

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
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#ConatntMatter_TabHead").height() + $("#AddNewBtn").height() + 170));

            $("#txtFromDate").datepicker({
                dateFormat: 'dd-M-yy',
                onSelect: function () {
                    //$("#txtToDate").datepicker('show');
                }
            });
            $("#txtToDate").datepicker({
                dateFormat: 'dd-M-yy'
            });

            fnBucketType();
        });

        function fnBucketTypeSel(ctrl) {
            $("#ConatntMatter_TabHead").find("a").removeClass("active");
            $(ctrl).find("a").eq(0).addClass("active");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("BucketTypeID"));

            fnBucketType();
        }
        function fnBucketType() {
            fnResetFilter();
            if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                $("#txtProductHierSearch").show();
                $("#txtLocationHierSearch").hide();
                $("#txtChannelHierSearch").hide();
                $("#ProdLvl").html($("#ConatntMatter_hdnProductLvl").val());
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                $("#txtProductHierSearch").hide();
                $("#txtLocationHierSearch").show();
                $("#txtChannelHierSearch").hide();
                $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
            }
            else {
                $("#txtProductHierSearch").hide();
                $("#txtLocationHierSearch").hide();
                $("#txtChannelHierSearch").show();
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
            }
            fnGetReport();
        }

        function fnSearch() {
            fnGetReport();
        }
        function fnResetFilter() {
            $("#txtFromDate").val("");
            $("#txtToDate").val("");
            $("#txtfilter").val("");// Add Code for reset the filter text box.(Abhishek)
            $("#txtProductHierSearch").attr("InSubD", "0");
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#txtLocationHierSearch").attr("InSubD", "0");
            $("#txtLocationHierSearch").attr("prodhier", "");
            $("#txtLocationHierSearch").attr("prodlvl", "");
            $("#txtChannelHierSearch").attr("InSubD", "0");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");
            fntypefilterReset(); // Add a new function for reset the filter text box and show the data in table.(Abhishek)
        }

        function fnGetReport() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var BucketValues = [];

            var PrdString = "";
            if (BucketType == "1")
                PrdString = $("#txtProductHierSearch").attr("prodhier");
            else if (BucketType == "2")
                PrdString = $("#txtLocationHierSearch").attr("prodhier");
            else if (BucketType == "3")
                PrdString = $("#txtChannelHierSearch").attr("prodhier");

            var Initiatives = [];
            var FromDate = $("#txtFromDate").val();
            var ToDate = $("#txtToDate").val();
            if (PrdString != "") {
                for (var i = 0; i < PrdString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": PrdString.split("^")[i].split("|")[0],
                        "col2": PrdString.split("^")[i].split("|")[1],
                        "col3": BucketType
                    });
                }
            }
            else {
                BucketValues.push({
                    "col1": "0",
                    "col2": "0",
                    "col3": "1"
                });
            }

            Initiatives.push({
                "col1": "0"
            });

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, UserID, BucketType, BucketValues, Initiatives, FromDate, ToDate, fnGetReport_pass, fnfailed);
        }
        function fnGetReport_pass(res) {
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
            str += "<tr bucket='0' style='display: table-row;'>";
            str += "<td></td>";
            str += "<td><input type='text' style='box-sizing: border-box;' value=''/></td>";
            str += "<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'></textarea></td>";
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                str += "<td><span><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='0' prodlvl='' prodhier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/></span><img src='../../Images/paste.png' title='paste' onclick='fnpasteprod(this);' style='float:right;'/></td>";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                str += "<td><span><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='1' prodlvl='' prodhier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Site..'/></span><img src='../../Images/paste.png' title='paste' onclick='fnpasteprod(this);' style='float:right;'/></td>";
            else
                str += "<td><span><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='0' prodlvl='' prodhier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Channel..'/></span><img src='../../Images/paste.png' title='paste' onclick='fnpasteprod(this);' style='float:right;'/></td>";
            str += "<td></td>";
            str += "<td></td>";
            str += "<td class='clstdAction'><img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
            str += "</tr>";
            if ($("#tblReport").find("tbody").eq(0).find("tr").length == 0) {
                $("#tblReport").find("tbody").eq(0).html(str);
            }
            else {
                $("#tblReport").find("tbody").eq(0).prepend(str);
            }

            $("#tblReport").find("tbody").eq(0).find("tr").eq(0).find("textarea").eq(0).on('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });
        }
        function fnEdit(ctrl) {
            var Descr = $(ctrl).closest("tr").find("td").eq(2).attr("title");
            var InSubD = $(ctrl).closest("tr").attr("InSubD");
            var ProdLvl = $(ctrl).closest("tr").attr("ProdLvl");
            var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
            var Bucketstr = $(ctrl).closest("tr").attr("Bucketstr");
            var Prodselstr = $(ctrl).closest("tr").attr("Prodselstr");

            $(ctrl).closest("tr").find("td").eq(1).html("<input type='text'  style='box-sizing: border-box;' value='" + Bucketstr + "' />");
            $(ctrl).closest("tr").find("td").eq(2).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + Descr + "</textarea>");
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                $(ctrl).closest("tr").find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                $(ctrl).closest("tr").find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Site..' value='" + Prodstr + "'/>");
            else
                $(ctrl).closest("tr").find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Channel..' value='" + Prodstr + "'/>");
            $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("title", "paste");
            $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("src", "../../Images/paste.png");
            $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("onclick", "fnpasteprod(this);");

            $(ctrl).closest("tr").find("textarea").eq(0).css("height", "auto");
            $(ctrl).closest("tr").find("textarea").eq(0).css("height", $(ctrl).closest("tr").find("textarea")[0].scrollHeight + "px");
            $(ctrl).closest("tr").find("textarea").eq(0).on('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this, 1);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");
        }
        function fnCopy(ctrl) {
            var Descr = $(ctrl).closest("tr").find("td").eq(2).attr("title");
            var InSubD = $(ctrl).closest("tr").attr("InSubD");
            var ProdLvl = $(ctrl).closest("tr").attr("ProdLvl");
            var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
            var Bucketstr = $(ctrl).closest("tr").attr("Bucketstr");
            var Prodselstr = $(ctrl).closest("tr").attr("Prodselstr");

            var str = "";
            str += "<tr bucket='0' style='display: table-row;'>";
            str += $(ctrl).closest("tr").html();
            str += "</tr>";
            $(ctrl).closest("tr").before(str);

            var tr = $(ctrl).closest("tr").prev();
            tr.find("td").eq(0).html("");
            tr.find("td").eq(1).html("<input type='text'  style='box-sizing: border-box;' value='" + Bucketstr + "' />");
            tr.find("td").eq(2).html("<textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'>" + Descr + "</textarea>");
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                tr.find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                tr.find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Site..' value='" + Prodstr + "'/>");
            else
                tr.find("td").eq(3).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Channel..' value='" + Prodstr + "'/>");
            tr.find("td").eq(3).find("img").eq(0).attr("title", "paste");
            tr.find("td").eq(3).find("img").eq(0).attr("src", "../../Images/paste.png");
            tr.find("td").eq(3).find("img").eq(0).attr("onclick", "fnpasteprod(this);");

            tr.find("textarea").eq(0).css("height", "auto");
            tr.find("textarea").eq(0).css("height", tr.find("textarea")[0].scrollHeight + "px");
            tr.find("textarea").eq(0).on('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            tr.find("td:last").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");
        }
        function fnCancel(ctrl) {
            var BucketID = $(ctrl).closest("tr").attr("bucket");
            if (BucketID == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var Descr = $(ctrl).closest("tr").attr("Descr");
                var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
                var Bucketstr = $(ctrl).closest("tr").attr("Bucketstr");

                $(ctrl).closest("tr").find("td").eq(1).html(Bucketstr);
                $(ctrl).closest("tr").find("td").eq(2).html(Descr);
                $(ctrl).closest("tr").find("td").eq(3).find("span").eq(0).html(Prodstr);
                $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("title", "copy");
                $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("src", "../../Images/copy.png");
                $(ctrl).closest("tr").find("td").eq(3).find("img").eq(0).attr("onclick", "fncopyprod(this);");
                $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/copy.png' title='copy' onclick='fnCopy(this);' style='margin-right: 12px;'/><img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);'/>");
            }
        }
        function fnSave(ctrl, flg) {
            var BucketID = $(ctrl).closest("tr").attr("bucket");
            var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var BucketName = $(ctrl).closest("tr").find("td").eq(1).find("input[type='text']").eq(0).val();
            var BucketDescr = $(ctrl).closest("tr").find("td").eq(2).find("textarea").eq(0).val();
            var BucketValues = [];
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var flgActive = "1";
            var InSubD = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("InSubD");
            var PrdLvl = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdLvl");
            var PrdString = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            var INITArr = [];

            if (BucketType == "0") {
                AutoHideAlertMsg("Please select the Bucket Type !");
                return false;
            }
            else if (BucketName == "") {
                AutoHideAlertMsg("Please enter the Bucket Name !");
                return false;
            }
            else if (BucketDescr == "") {
                AutoHideAlertMsg("Please enter the Bucket Description !");
                return false;
            }
            else if (PrdString == "") {
                if ($("#ConatntMatter_hdnBucketType").val() == "1")
                    AutoHideAlertMsg("Please select the Product/s !");
                else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                    AutoHideAlertMsg("Please select the Site/s !");
                else
                    AutoHideAlertMsg("Please select the Channel/s !");
                return false;
            }
            else {
                for (var i = 0; i < PrdString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": PrdString.split("^")[i].split("|")[0],
                        "col2": PrdString.split("^")[i].split("|")[1],
                        "col3": $("#ConatntMatter_hdnBucketType").val()
                    });
                }

                if (BucketID != "0" && flg == 1) {
                    $("#dvloader").show();
                    PageMethods.fnGetInitiativelst(BucketID, BucketType, fnGetInitiativelst_pass, fnfailed, ctrl);
                }
                else {
                    INITArr.push({
                        "col1": "0"
                    });

                    var flgExisting = 0
                    if (BucketID != "0")
                        flgExisting = 1;

                    $("#dvloader").show();
                    PageMethods.fnSave(BucketID, BucketName, BucketDescr, BucketType, flgActive, BucketValues, LoginID, PrdLvl, PrdString, InSubD, INITArr, fnSave_pass, fnfailed, flgExisting);
                }
            }
        }
        function fnGetInitiativelst_pass(res, ctrl) {
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1] != "") {
                    $("#dvloader").hide();
                    $("#divConfirm").html(res.split("|^|")[1]);
                    $("#divConfirm").dialog({
                        "modal": true,
                        "width": "340",
                        "maxheight": "400",
                        "title": "Message :",
                        close: function () {
                            $("#divConfirm").dialog('destroy');
                        },
                        buttons: [{
                            text: 'Yes',
                            class: 'btn-primary',
                            click: function () {
                                $("#divConfirm").dialog('close');

                                var BucketID = $(ctrl).closest("tr").attr("bucket");
                                var BucketType = $("#ConatntMatter_hdnBucketType").val();
                                var BucketName = $(ctrl).closest("tr").find("td").eq(1).find("input[type='text']").eq(0).val();
                                var BucketDescr = $(ctrl).closest("tr").find("td").eq(2).find("textarea").eq(0).val();
                                var BucketValues = [];
                                var LoginID = $("#ConatntMatter_hdnLoginID").val();
                                var flgActive = "1";
                                var InSubD = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("InSubD");
                                var PrdLvl = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdLvl");
                                var PrdString = $(ctrl).closest("tr").find("td").eq(3).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
                                var INITArr = [];

                                for (var i = 0; i < PrdString.split("^").length; i++) {
                                    BucketValues.push({
                                        "col1": PrdString.split("^")[i].split("|")[0],
                                        "col2": PrdString.split("^")[i].split("|")[1],
                                        "col3": $("#ConatntMatter_hdnBucketType").val()
                                    });
                                }

                                $("#divConfirm").find("li").each(function () {
                                    INITArr.push({
                                        "col1": $(this).attr("strId")
                                    });
                                });

                                $("#dvloader").show();
                                PageMethods.fnSave(BucketID, BucketName, BucketDescr, BucketType, flgActive, BucketValues, LoginID, PrdLvl, PrdString, InSubD, INITArr, fnSave_pass, fnfailed, 1);
                            }
                        },
                        {
                            text: 'No',
                            class: 'btn-primary',
                            click: function () {
                                $("#divConfirm").dialog('close');
                                fnSave(ctrl, 0);
                            }
                        }]
                    });
                }
                else {
                    fnSave(ctrl, 0);
                }
            }
            else {
                fnfailed();
            }
        }
        function fnSave_pass(res, flg) {
            if (res.split("|^|")[0] == "0") {
                if (flg == 0)
                    AutoHideAlertMsg("Bucket saved successfully !");
                else
                    AutoHideAlertMsg("Bucket details updated successfully !");
                fnGetReport();
            }
            else if (res.split("|^|")[0] == "1") {
                AutoHideAlertMsg("Bucket name already exist !");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }

        function fncopyprod(ctrl) {
            $(ctrl).closest("tbody").find("tr").attr("flgcopyprod", "0");
            $(ctrl).closest("tr").attr("flgcopyprod", "1");
        }
        function fnpasteprod(ctrl) {
            if ($(ctrl).closest("tbody").find("tr[flgcopyprod='1']").length > 0) {
                var tr = $(ctrl).closest("tbody").find("tr[flgcopyprod='1']").eq(0);

                var InSubD = tr.attr("InSubD");
                var ProdLvl = tr.attr("ProdLvl");
                var Prodstr = tr.attr("Prodstr");
                var Prodselstr = tr.attr("Prodselstr");
                if ($("#ConatntMatter_hdnBucketType").val() == "1")
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Site..' value='" + Prodstr + "'/>");
                else
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Channel..' value='" + Prodstr + "'/>");
            }
            else {
                var BucketType = $("#ConatntMatter_hdnBucketType").val();
                if (BucketType == "1")
                    AutoHideAlertMsg("Please select the Product/s for Mapping !");
                else if (BucketType == "2")
                    AutoHideAlertMsg("Please select the Site/s for Mapping !");
                else if (BucketType == "3")
                    AutoHideAlertMsg("Please select the Channel/s for Mapping !");

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

        function fntypefilterReset() {
            var flgtr = 0;
            var filter = ($("#txtfilter").val()).toUpperCase();

            $("#tblReport").find("tbody").eq(0).find("tr").css("display", "none");
            $("#tblReport").find("tbody").eq(0).find("tr").each(function () {
                if ($(this)[0].innerText.toUpperCase().indexOf(filter) > -1) {
                    $(this).css("display", "table-row");
                    flgtr = 1;
                }
            });

            $("#divHeader").show();
            $("#divReport").show();
            $("#divMsg").html('');
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
            $("#btnAddNewNode").hide();

            var title = "";
            if ($("#ConatntMatter_hdnBucketType").val() == "1")
                title = "Product/s :";
            else if ($("#ConatntMatter_hdnBucketType").val() == "2")
                title = "Site/s :";
            else
                title = "Channel/s :";

            $("#divHierPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
                    if ($("#ConatntMatter_hdnBucketType").val() == "1") {
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

                        $("#PopupHierlbl").html("Product Hierarchy");
                    }
                    else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
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
                        //$(".ui-dialog-buttonset").prepend("<div id='divIncludeSubd' style='text-transform: capitalize; display: inline-block; margin-right: 30px;'><input id='chkIncludeSubd' type='checkbox' checked onclick='fnSubdInclude();'/>&nbsp;SubD Included</div>");

                        //if ($(ctrl).attr("InSubD") == "0") {
                        //    $("#chkIncludeSubd").removeAttr("checked");
                        //}
                        //fnSubdInclude();
                    }
                    else {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:33%;'>Class</th>";
                        strtable += "<th style='width:34%;'>Channel</th>";
                        strtable += "<th style='width:33%;'>Store Type</th>";
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
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("ProdLvl") + "']").eq(0));
                    }
                    else
                        $("#ConatntMatter_hdnSelectedHier").val("");
                },
                close: function () {
                    //$("#divIncludeSubd").remove();
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

            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $(ctrl).closest("tr").addClass("Active");

            if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                if (ProdLvl == "30") {
                    $("#btnAddNewNode").show();
                    $("#btnAddNewNode").html("Add New BrandForm");
                    $("#btnAddNewNode").attr("onclick", "fnAddNewBrandForm(0);");

                    //$("#divIncludeSubd").hide();
                }
                else if (ProdLvl == "40") {
                    $("#btnAddNewNode").show();
                    $("#btnAddNewNode").html("Add New SubBrandForm");
                    $("#btnAddNewNode").attr("onclick", "fnAddNewSBF();");

                    //$("#divIncludeSubd").hide();
                }
                else if (ProdLvl == "100" || ProdLvl == "110" || ProdLvl == "120" || ProdLvl == "130" || ProdLvl == "140") {
                    $("#btnAddNewNode").hide();
                    //$("#divIncludeSubd").show();
                }
                else {
                    $("#btnAddNewNode").hide();
                    //$("#divIncludeSubd").hide();
                }
            }
            else {
                $("#btnAddNewNode").hide();

                //$("#divIncludeSubd").hide();
                //$("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='145']").eq(0).closest("tr").show();
            }

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

            //if ($("#ConatntMatter_hdnBucketType").val() == "2")
            //    $("#chkIncludeSubd").prop("checked", true);
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
                "height": "460",
                "title": "Add New SubBrandForm :",
                buttons: [{
                    text: 'Add New SubBrandForm',
                    class: 'btn-primary',
                    click: function () {
                        fnSaveNewNode(2, 0);
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divSBFPopup").dialog('close');
                    }
                }],
                close: function () {
                    //
                }
            });
        }

        function fnAddNewBrandForm(cntr) {
            $("#txtBrand").attr("sel", "");
            $("#txtBrand").val("");
            $("#txtBFCode").val("");
            $("#txtBFName").val("");

            fnShowBFPopup(cntr);
        }
        function fnShowBFPopup(cntr) {
            $("#divBFPopup").dialog({
                "modal": true,
                "width": "46%",
                "height": "460",
                "title": "Add New BrandForm :",
                buttons: [{
                    text: 'Add New BrandForm',
                    class: 'btn-primary',
                    click: function () {
                        fnSaveNewNode(1, cntr);
                    }
                },
                {
                    text: 'Cancel',
                    class: 'btn-primary',
                    click: function () {
                        $("#divBFPopup").dialog('close');
                    }
                }]
            });
        }

        function fnShowPopupforNewNode(ctrl, cntr) {
            $(ctrl).next("div.clsPopup").eq(0).show();

            if (cntr == 1) {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrand").val().split("|^|")[1]);
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrandForm").val().split("|^|")[1]);
            }

            if ($(ctrl).val() != "")
                fnPopupTypeSearchforNewNode(ctrl);
        }
        function fnPopupTypeSearchforNewNode(ctrl) {
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
        function fnSelectProdforNewNode(ctrl) {
            var nid = $(ctrl).attr("nid");
            var ntype = $(ctrl).attr("ntype");
            var str = $(ctrl).find("td:last").html();

            $(ctrl).closest("div.clsPopup").prev().val(str);
            $(ctrl).closest("div.clsPopup").prev().attr("sel", nid + "^" + ntype);
            fnHidePopupforNewNode();
        }
        function fnRemoveSelectionforNewNode(ctrl) {
            $(ctrl).attr("sel", "");
        }
        function fnHidePopupforNewNode() {
            $("div.clsPopup").hide();
        }

        function fnSaveNewNode(flg, cntr) {
            var ParentId = "";
            var ParentType = "";
            var Code = "";
            var Descr = "";

            if (flg == 1) {         //BF
                if ($("#txtBFName").val() == "") {
                    AutoHideAlertMsg("Please enter the BrandForm name !");
                    return false;
                }
                else if ($("#txtBrand").attr("sel") == "") {
                    AutoHideAlertMsg("Please select the Brand !");
                    return false;
                }

                ParentId = $("#txtBrand").attr("sel").split("^")[0];
                ParentType = $("#txtBrand").attr("sel").split("^")[1];
                Code = $("#txtBFCode").val();
                Descr = $("#txtBFName").val();
            }
            else {                   //SBF
                if ($("#txtSBFName").val() == "") {
                    AutoHideAlertMsg("Please enter the SubBrandForm name !");
                    return false;
                }
                else if ($("#txtBrandForm").attr("sel") == "") {
                    AutoHideAlertMsg("Please select the BrandForm !");
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
            PageMethods.fnSaveNewNode(ParentId, ParentType, Code, Descr, LoginID, UserID, RoleID, UserNodeID, UserNodeType, fnSaveNewNode_pass, fnfailed, flg + "|" + cntr);
        }
        function fnSaveNewNode_pass(res, flgCntr) {
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1].split("^")[0] == "-1") {
                    $("#dvloader").hide();
                    AutoHideAlertMsg("Name already exist !");
                }
                else {
                    $("#dvloader").hide();
                    if (flgCntr.split("|")[0] == "1") {
                        AutoHideAlertMsg("BrandForm added successfully !");
                        $("#ConatntMatter_hdnBrandForm").val(res.split("|^|")[3]);
                        $("#divBFPopup").dialog('close');

                        if (flgCntr.split("|")[1] == "1") {
                            $("#txtBrandForm").next().find("div.clsPopupBody").html(res.split("|^|")[3]);
                            $("#txtBrandForm").val(res.split("|^|")[2].toString().substr(0, res.split("|^|")[2].toString().length - 1));
                            $("#txtBrandForm").attr("sel", res.split("|^|")[1]);
                        }
                    }
                    else {
                        AutoHideAlertMsg("SubBrandForm added successfully !");
                        $("#divSBFPopup").dialog('close');
                    }

                    if (flgCntr.split("|")[1] == "0") {
                        var SelectedHier = "";
                        $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                        });
                        if (SelectedHier != "") {
                            SelectedHier = SelectedHier.substring(1);
                            $("#ConatntMatter_hdnSelectedHier").val(SelectedHier + "^" + res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        else {
                            $("#ConatntMatter_hdnSelectedHier").val(res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr[class='Active']").eq(0).find("td").eq(0));
                    }
                }
            }
            else {
                fnfailed();
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
        table.clsReport tr th:nth-child(1) {
            width: 5%;
        }

        table.clsReport tr th:nth-child(5),
        table.clsReport tr th:nth-child(7) {
            width: 10%;
        }

        table.clsReport tr th:nth-child(2),
        table.clsReport tr th:nth-child(3),
        table.clsReport tr th:nth-child(6) {
            width: 15%;
        }

        table.clsReport tr th:nth-child(4) {
            width: 20%;
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
                /*color: #003DA7;*/
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
    <h4 class="middle-title" id="Heading">Bucket Master</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-75">
                <div class="row">
                    <div class="col-7">
                        <div class="fsw-title">Date Range</div>
                        <div class="form-row">
                            <label class="col-form-label col-form-label-sm">From</label>
                            <div class="col-5">
                                <input id="txtFromDate" type="text" class="form-control form-control-sm clsDate" placeholder="From Date" />
                            </div>
                            <label class="col-form-label col-form-label-sm">To</label>
                            <div class="col-5">
                                <input id="txtToDate" type="text" class="form-control form-control-sm clsDate" placeholder="To Date" />
                            </div>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="fsw-title">Hierarchy Filter</div>
                        <div class="d-block">
                            <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" insubd="0" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Products Filter">Products</a>
                            <a id="txtLocationHierSearch" class="btn btn-primary btn-sm" href="#" insubd="0" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Location Filter">Location</a>
                            <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" insubd="0" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter">Channel</a>
                            <a class="btn btn-primary btn-sm" href="#" title="Initiatives Filter">Initiatives</a>
                        </div>
                    </div>
                    <div class="col-2">
                        <a class="btn btn-primary btn-sm mt-4" href="#" onclick="fnResetFilter();" title="Reset All Filters">Reset</a>
                        <a class="btn btn-primary btn-sm mt-4" href="#" onclick="fnSearch();" title="Show Filtered Bucket(s)">Show</a>
                    </div>
                </div>
            </div>
            <div class="fsw_inputBox w-25">
                <div class="fsw-title">Search Box</div>
                <div class="d-block">
                    <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
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
        <div role="tabpanel" class="tab-pane fade show active">
            <div class="text-right mb-2 mt-1" id="AddNewBtn">
                <a class="btn btn-primary btn-sm" href="#" onclick="fnAddNew();" title="Add New Bucket">Add New Bucket</a>
            </div>
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
                        <a id="btnAddNewNode" class="btns-outline" href="#" onclick="fnAddNewSBF();">Add New SubBrandForm</a>
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

    <div id="divSBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>SubBrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtSBFCode" />
            </div>
            <div class="form-group col-md">
                <label>SubBrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtSBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm</label>
                <div class="position-relative">
                    <input id="txtBrandForm" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 2)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec" style="padding: 0;"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-right">
            <a href="#" class="btn btn-primary btn-sm" onclick="fnAddNewBrandForm(1);">Add BrandForm</a>
        </div>
    </div>
    <div id="divBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtBFCode" />
            </div>
            <div class="form-group col-md">
                <label>BrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>Brand</label>
                <div class="position-relative">
                    <input id="txtBrand" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 1)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec p-0"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
