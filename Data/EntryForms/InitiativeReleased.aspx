<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="InitiativeReleased.aspx.cs" Inherits="Data_EntryForms_InitiativeReleased" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Styles/Multiselect/jquery.multiselect.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/Multiselect/jquery.multiselect.filter.css" rel="stylesheet" type="text/css" />

    <script src="../../Scripts/MultiSelect/jquery.multiselect.js" type="text/javascript"></script>
    <script src="../../Scripts/MultiSelect/jquery.multiselect.filter.js" type="text/javascript"></script>

    <script type="text/javascript">
        var ht = 0;
        var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

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
            $("#divReport").height(ht - ($("#Heading").height() + $("#Filter").height() + $("#ConatntMatter_TabHead").height() + $("#AddNewBtn").height() + 170));

            $(".clsDate").datepicker({
                dateFormat: 'dd-M-y'
            });

            $("#ddlMonth").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonth").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);
            fnGetReport();

            //-------- Multiselect MS&P Allias Filter
            $("#ddlMSMP").html($("#ConatntMatter_hdnMSMPAlies").val());
            $("#ddlMSMP").multiselect({
                noneSelectedText: "--Select--"
            }).multiselectfilter();
            $("#ddlMSMP").next().css({
                "height": "calc(1.5em + .5rem + 2px)",
                "font-size": "0.8rem",
                "font-weight": "400",
                "width": "260px",
                "padding": ".25rem 0 .25rem .5rem",
                "border-radius": ".2rem",
                "border-color": "#ced4da"
            });
            $("#ddlMSMP").next().find("span.ui-icon").eq(0).css({
                "margin": ".2rem",
                "margin-bottom": "0",
                "background-color": "transparent",
                "border": "none"
            });

            $("#ConatntMatter_hdnMSMPAlies").val('');
        });


        function fnGetReport() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();            
            var UserID = $("#ConatntMatter_hdnUserID").val();            
            var FromDate = $("#ddlMonth").val().split("|")[0]; //$("#txtFromDate").val();
            var ToDate = $("#ddlMonth").val().split("|")[1]; //$("#txtToDate").val();

            var ProdValues = [];
            var PrdString = $("#txtProductHierSearch").attr("prodhier");
            var LocValues = [];
            var LocString = $("#txtLocationHierSearch").attr("prodhier");
            var ChannelValues = [];
            var ChannelString = $("#txtChannelHierSearch").attr("prodhier");
            var MSMPValues = [];

            if (PrdString != "") {
                for (var i = 0; i < PrdString.split("^").length; i++) {
                    ProdValues.push({
                        "col1": PrdString.split("^")[i].split("|")[0],
                        "col2": PrdString.split("^")[i].split("|")[1],
                        "col3": "1"
                    });
                }
            }
            else {
                ProdValues.push({ "col1": "0", "col2": "0", "col3": "1" });
            }

            if (LocString != "") {
                for (var i = 0; i < LocString.split("^").length; i++) {
                    LocValues.push({
                        "col1": LocString.split("^")[i].split("|")[0],
                        "col2": LocString.split("^")[i].split("|")[1],
                        "col3": "2"
                    });
                }
            }
            else {
                LocValues.push({ "col1": "0", "col2": "0", "col3": "2" });
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

            if ($("#ddlMSMP option:selected").length > 0) {
                for (var i = 0; i < $("#ddlMSMP option:selected").length; i++) {
                    MSMPValues.push({ "col1": $("#ddlMSMP option:selected").eq(i).val() });
                }
            }
            else {
                MSMPValues.push({ "col1": "0" });
            }

            $("#dvloader").show();
            PageMethods.fnGetReport(LoginID, FromDate, ToDate, UserID, ProdValues, LocValues, ChannelValues, MSMPValues, fnGetReport_pass, fnfailed);
        }

        var tabledata = null;

        var fileList = [];

        function fnGetReport_pass(res) {

            var RoleID = $("#ConatntMatter_hdnRoleID").val();
           
                if (res.split("|^|")[0] == "0") {
                    $("#divReport").html(res.split("|^|")[1]);

                    

                    if (res.split("|^|")[2].length > 0) {
                        
                        $("#divbtns").html(res.split("|^|")[2]);
                        
                    }
                  
                    $("#dvloader").hide();
                }
                else {
                    fnfailed();
                }

        }


        function fnShowPDF(ctrl) {

            var rowinitid = $(ctrl).closest("tr").attr("initid");
            var imgname = $(ctrl).attr("imgname");
            //alert(rowinitid);
            //alert(imgname);
            // alert(initid + '_' + imgname);
            //alert(cntr);
            // var filename = $(ctrl).attr("file");
            document.getElementById("iFramePdf").src = "../../Uploads/InvoiceFiles/" + rowinitid + "/" + imgname;
            $("#dvPdfDialog")[0].style.display = "block";
            $("#dvPdfDialog").dialog({
                title: "Invoice Details :",
                resizable: false,
                height: $(window).height() - 150,
                width: "90%",
                modal: true,
                open: function () {
                    $("body").css("overflow", "hidden");
                    $("#iFramePdf").height(($(window).height() - 250) + "px");
                },
                close: function () {
                    document.getElementById("iFramePdf").src = "";
                }
            });

            $("#dvPdfDialog").dialog("option", "title", "Invoice Details");
        }


        function fntypefilter() {

            var flgtr = 0, rowindex = 0;
            var filter = ($("#txtfilter").val()).toUpperCase().split(",");

            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "none");
            $("#tblReport").find("tbody").eq(0).find("tr").css("display", "none");

            var flgValid = 0;
            $("#tblReport").find("tbody").eq(0).find("tr").each(function () {
                // $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").each(function () {
                flgValid = 1;
                for (var t = 0; t < filter.length; t++) {
                    if ($(this)[0].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                        flgValid = 0;
                    }
                }

                if (flgValid == 1) {
                    $("#tblReport").find("tbody").eq(0).find("tr").eq(rowindex).css("display", "table-row");
                    $(this).css("display", "table-row");
                    flgtr = 1;
                }

                rowindex++;
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


        function fnResetFilter() {
            //$("#txtFromDate").val("");
            //$("#txtToDate").val("");
            $("#txtProductHierSearch").attr("InSubD", "0");
            $("#txtProductHierSearch").attr("prodhier", "");
            $("#txtProductHierSearch").attr("prodlvl", "");
            $("#txtLocationHierSearch").attr("InSubD", "0");
            $("#txtLocationHierSearch").attr("prodhier", "");
            $("#txtLocationHierSearch").attr("prodlvl", "");
            $("#txtChannelHierSearch").attr("InSubD", "0");
            $("#txtChannelHierSearch").attr("prodhier", "");
            $("#txtChannelHierSearch").attr("prodlvl", "");

            $("#btnInitExpandedCollapseMode").show();
            $("#btnInitExpandedCollapseMode").html("Expanded Mode");
            $("#btnInitExpandedCollapseMode").attr("flgCollapse", "0");

            $("#txtfilter").val("");
            $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").css("display", "table-row");
            $("#tblleftfixed").find("tbody").eq(0).find("tr").css("display", "table-row");
            $("#divReport").show();
            $("#divMsg").html('');

            fnGetReport();
        }

        function fndeletefile(ctrl) {
            var rowinitid = $(ctrl).closest("tr").attr("initid");
            var imgname = $(ctrl).attr("imgname");

            //if (ArrINIT.length > 0) {
            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure you want to delete <span style='color:#0000ff; font-weight: 700;'>" + imgname + "</span> invoice...<br/>Do you want to continue ?</div>");
            // }
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
                        //alert(initid + '_' + imgname);
                        for (var i = 0; i < fileList.length; i++) {
                            if (fileList[i]["initid"] == rowinitid && fileList[i]["filename"] == imgname) {
                                if (fileList[i]["flag"] == "1") {
                                    var InvoiceMapID = fileList[i]["INITInvoiceMapID"];
                                    var initid = fileList[i]["initid"];
                                    PageMethods.fnDeleteFile(InvoiceMapID, initid, imgname, delete_success, delete_falied);
                                }
                                fileList.splice(i, 1);

                            }
                        }

                        var singlefilelist = fileList.filter(function (n, i) {
                            return n.initid == rowinitid;
                        });

                        var filename = "";

                        for (var f = 0; f < singlefilelist.length; f++) {
                            // filename += '<p class="p_btn" imgname="' + singlefilelist[f].filename + '" onclick="fnShowPDF(this);">' + singlefilelist[f].filename.split(".")[0].substring(0, 10) + '.' + singlefilelist[f].filename.split(".")[1] + '&nbsp;&nbsp;<i class="fa fa-close" title="Delete Invoice.." imgname="' + singlefilelist[f].filename + '" onclick="fndeletefile(this);"></i></p>' + ' ';
                            if (singlefilelist[f].filename.indexOf('.') != -1) {
                                filename += '<p class="p_btn"><span imgname="' + singlefilelist[f].filename + '" onclick="fnShowPDF(this);">' + (singlefilelist[f].filename.indexOf('.') == -1 ? "" : singlefilelist[f].filename.split(".")[0].substring(0, 10) + '.' + singlefilelist[f].filename.split(".")[1]) + '&nbsp;&nbsp;</span><i class="fa fa-close" title="Delete Invoice.." imgname="' + singlefilelist[f].filename + '" onclick="fndeletefile(this);"></i></p>' + ' ';
                            }
                        }

                        $(ctrl).closest("tr").find('td:eq(5)').html(filename);
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

        function delete_success(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                //fnGetReport();
            }
            else {
                fnfailed();
            }
        }

        function delete_falied() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }






        /* ---------------------------------Upload------------------------ */

        function progressHandler(event) {
            $("#loaded_n_total").html("Uploaded " + event.loaded + " bytes of " + event.total);
            var percent = (event.loaded / event.total) * 100;
            $("#progressBar").val(Math.round(percent));
            $("#status").html(Math.round(percent) + "% uploaded... please wait");
        }

        function completeHandler(event) {
            counter++
            $("#status").html(counter + " " + event.target.responseText);
        }

        function errorHandler(event) {
            $("#status").html("Upload Failed");
        }

        function abortHandler(event) {
            $("#status").html("Upload Aborted");
        }
        function OnError(xhr, errorType, exception) {
            //$("#cphRight_divRptFinelhead").find("table[id='tblstatus']").append("<tr><td style='color:#ff0000;'>Error in uploading due to connection failure, please try again</td></tr>");
            $('#progressBar').css("display", "none");
            //$('#dvProgressPrcent').html('0%');
            //$("#cphRight_btnUpload").removeAttr('disabled');
            //$("#cphRight_btnUpload").val('Upload File');
        }
        function trackUploadProgress(e) {
            if (e.lengthComputable) {
                currentProgress = (e.loaded / e.total) * 100; // Amount uploaded in percent
                $('#progressBar').width(currentProgress + '%');
                $('#dvProgressPrcent').html(currentProgress.toFixed(2) + '%');//dvProgressPrcent
                //if (currentProgress == 100)
                // $("#divsaving")[0].innerHTML = "<div><img valign='middle' src='../Images/preloader_18.gif' alt='loading gif' />Saving Files...Please Wait</div>";
            }
        }

        //var fileList = [];
        var successAll = true; var SuccessCount = 0; var TotalFileCount = 0; var groupids = ""; var objINIT = [];
        function fnUploadFilesSingle(ctrl) {
            // alert("1");
            var filesUpload = $(ctrl).closest("tr").find('input[type=file][flgUpload="1"]');

            var rowinitid = $(ctrl).closest("tr").attr('initid');
            var singlefilelist = fileList.filter(function (n, i) {
                return n.initid == rowinitid && n.flag == "0";
            });



            //if (singlefilelist.length == 0) {
            //    alert("Kindly select file first!!");
            //    return false
            //}


            var IsValidFiles = true;
            successAll = false;


            $("#cphRight_divRptFinelhead").css("color", "blue");
            $("#cphRight_divRptFinelhead").html("<table id='tblstatus' style='width:100%;text-align:center;'></table>");

            SuccessCount = 0;
            TotalFileCount = singlefilelist.length;
            objINIT = [];
            var formdata = new FormData();
            for (var i = 0; i < singlefilelist.length ; i++) {


                //$(ctrl).closest("tr").find("td:eq(6)").html("Pending..");
                //var files = singlefilelist[i].File;//$("#" + filesUpload[i].id).get(0).files;
                var LoginId = $("#cphRight_hdnLoginId").val();
                var filesettype = "1"//$("#" + filesUpload[i].id).siblings('input[type=hidden]').val();

                //for (var f = 0; f < singlefilelist.length ; f++) {
                formdata.append(singlefilelist[i].File.name, singlefilelist[i].File, singlefilelist[i].File.name + '#' + filesettype + '#' + singlefilelist[i].initid);
                formdata.append("LoginId", LoginId);
                //}
                if (singlefilelist[i].filechanged == "0") {
                    objINIT.push({ "INITID": singlefilelist[i].initid, "ButtonID": "5", "comments": singlefilelist[i].File.name });
                }
            }
            if (filesUpload.length > 0) {
                postFile(1, formdata, filesUpload[0].id, singlefilelist.length);
            }
            else {
                postFile(1, formdata, $(ctrl).id, singlefilelist.length);
            }
           

        }

        function fnUploadFiles(ctrl) {

            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            
                objINIT = [];
                var allfilesUpload = $('#tblReport tbody input[type=checkbox]:checked');
                for (var i = 0; i < allfilesUpload.length ; i++) {
                    var rowinitid = $(allfilesUpload[i]).closest("tr").attr('initid');
                    objINIT.push({ "INITID": rowinitid, "ButtonID": $(ctrl).attr("savebuttontype"), "comments": "" });
                }

                if (allfilesUpload.length > 0)
                {
                    fnApprove(ctrl);
                }

           
           

        }


        function finalupload() {
            // alert("finalupload");
            var ArrINIT = [];
            $("#tblReport").find("tbody").eq(0).find("tr").each(function () {
                if ($(this).find("input[type='checkbox']").length > 0) {
                    if ($(this).find("input[type='checkbox']").is(":checked")) {
                        var rowIndex = $(this).closest("tr").index();

                        ArrINIT.push({
                            "col1": $("#tblReport").find("tbody").eq(0).find("tr[iden='Init']").eq(rowIndex).attr("Init"),
                            "col2": "",
                            "col3": ""
                        });
                    }
                }
            });

            if (ArrINIT.length > 0) {
                $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>You are sending <span style='color:#0000ff; font-weight: 700;'>" + ArrINIT.length + "</span> Initiative(s).<br/>Do you want to continue ?</div>");
            }
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
                        PageMethods.fnFinalSaving(objINIT, finalsuccess, finalfalied);
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

            // $("#divsaving")[0].innerHTML = "<div><img valign='middle' src='../../Images/preloader_18.gif' alt='loading gif' />Processing Data...Please Wait</div>";
            //PageMethods.fnFinalSaving(objINIT, finalsuccess, finalfalied);
        }

        function finalsuccess(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                //$("#divsaving")[0].innerHTML = "";
                // alert(res.split("|^|")[1])
                // alert("Invoices Send for approval successfully..")
                fnGetReport();
            }
            else {
                $("#dvloader").hide();
                fnfailed();
            }
        }



        function finalSingleupload() {

            PageMethods.fnFinalSaving(objINIT, finalSinglesuccess, finalfalied);


        }


        function fnApprove(ctrl) {
           
            $("#divConfirm").html("<div style='font-size: 0.9rem; font-weight: 600; text-align: center;'>Are you sure you want to " + $(ctrl).text() + " selected Initiative(s)..</div>");
           
            $("#divConfirm").dialog({
                "modal": true,
                "width": "320",
                "height": "200",
                "title": "Message :",
                buttons: [{
                    text: 'Yes',
                    //class: 'btn-primary',
                    click: function () {
                        

                        $("#dvloader").show();
                        
                        PageMethods.fnFinalSaving(objINIT, approve_success, finalfalied);

                    }
                },
                {
                    text: 'No',
                    //class: 'btn-primary',
                    click: function () {
                        $("#divConfirm").dialog('close');                     

                    }
                }
                ]
            });



        }


        function approve_success(res)
        {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                $("#divConfirm").dialog('close');
                fnGetReport();
            }
            else {
                $("#divConfirm").dialog('close');
                $("#dvloader").hide();
                fnfailed();
            }
        }

        function finalSinglesuccess(res) {
            if (res.split("|^|")[0] == "0") {
                $("#dvloader").hide();
                // $("#divsaving")[0].innerHTML = "";
                alert('File Saved Successfully.')
                 //fnGetReport();
            }
            else {
                $("#dvloader").hide();
                fnfailed();
            }
        }




        function finalfalied(res) {
            //$("#divsaving")[0].innerHTML = "";
            $("#cphRight_divRptFinelhead").find("table[id='tblstatus']").append("<tr><td style='color:#ff0000;'>Error in uploading due to connection failure, please try again</td></tr>");
        }


        function postFile(X, data, id, filecount) {
            // Make the Ajax call
            $.ajax({
                url: "FileInitUploadHandler.ashx",
                type: 'POST',
                data: data,
                contentType: false,
                processData: false,
                xhr: function () {
                    var req = $.ajaxSettings.xhr();
                    if (req.upload) {
                        // Setup event listener for any progress info
                        // returned from the Web API
                        req.upload.addEventListener('progress', function (e) {
                            if (e.lengthComputable) {
                                // Update the progress bar
                                updateProgressBar(e, id);
                            }
                        }, false);
                    }
                    return req;
                },
            }).done(function (response) {
                fnSuccess(X, response, id, filecount);
            }).fail(function (error) {
                fnError(response, id);
            });
        }
        function updateProgressBar(e, id) {
            // Calculate current percentage
            var percentage = (e.loaded * 100) / e.total;
            /*
            // Modify the progress bar
            $("#" + id).closest("tr").find("td:eq(6)").html(Math.round(percentage) + "% uploaded... please wait");

            // Are we done?
            if (percentage >= 100) {
                $("#" + id).closest("tr").find("td:eq(6)").html(100 + "% uploaded but wait for further process..");
            }*/
        }
        function fnSuccess(X, response, id, filecount) {
            //alert("ABC");
            if (response.split("^")[0] == "0" || response.split("^")[0] == "2") {
                //SuccessCount += filecount;
                SuccessCount++;
                //$("#" + id).closest("tr").find("td:eq(6)").html(response.split("^")[1]);
                
                $("#" + id).val("");
                $("#" + id).attr("flgUpload", "0");


            } else {
                $("#" + id).attr("flgUpload", "0");
                $("#" + id).val("");
                $("#" + id).closest("tr").find("td:eq(6)").html(response.split("^")[1]);
                // $("#" + id).closest("tr").find("td:eq(6)").html(response.split("^")[1] + "<img src='../../Images/save.png' onclick='fnSave(this);' style='margin-right: 12px;'/>");
            }
            // if (SuccessCount == TotalFileCount) {
            if (X == 1) {
                if (objINIT.length > 0) {
                    finalSingleupload();
                }
                else {
                    alert('File Saved Successfully.');
                }
            }
            else {
                if (SuccessCount == TotalFileCount) {
                    finalupload();
                }
            }
            //  }


        }
        function fnError(response, id) {
            $("#" + id).attr("flgUpload", "0");
            $("#" + id).val("");
            $("#" + id).closest("td").next().html("Error-" + response);
        }

        /*---------------------------------end Upload----------------------*/


        function fnInv(ctrl) {
            $(ctrl).siblings('input[type=file]').click();
        }

        function fnSelectAll(sender, flg) {
            //debugger;
            if (flg == 1) {
                if ($("#chkAll").is(":checked")) {
                    //$("#chkAll").prop("checked", false);
                    $("#tblReport input[type=checkbox]").prop("checked", true);
                    fnsameigst(sender);
                } else {
                    //$("#chkAll").prop("checked", true);
                    $("#tblReport input[type=checkbox]").prop("checked", false);
                    fnsameigst(sender);
                }
            }
        }


        function fnsameigst(sender) {
            //$("#btnUpload").hide();
            $("#divbtns").find("a.btn").addClass("btn-disabled");
            $("#divbtns").find("a.btn").removeAttr("onclick");
           
            if ($("#tblReport tbody input[type=checkbox]:checked").length > 0) {
                //$("#btnUpload").show();
                $("#divbtns").find("a.btn").removeClass("btn-disabled");
                $("#divbtns").find("a.btn").attr("onclick", "fnUploadFiles(this);");
                
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
        function fnShowProdHierPopup(ctrl, cntr) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val(cntr);
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");
            $("#ConatntMatter_hdnBucketType").val($(ctrl).attr("buckettype"));

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
                        $("#ProdLvl").html($("#ConatntMatter_hdnProductLvl").val());
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
                        //strtable += "<th style='width:25%;'>SubD</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Location Hierarchy");
                        $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
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
                        $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
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

        function fnProdLvl(ctrl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();
            var ProdLvl = $(ctrl).attr("ntype");

            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $(ctrl).closest("tr").addClass("Active");

            //if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
            //    if (ProdLvl != "145") {
            //        $("#divIncludeSubd").show();
            //    }
            //    else {
            //        $("#divIncludeSubd").hide();
            //    }
            //}
            //else {
            //    $("#divIncludeSubd").hide();
            //}

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
                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, BucketValues, fnProdHier_pass, fnProdHier_failed);
            }
            else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                var InSubD = 0;
                //if ($("#chkIncludeSubd").is(":checked")) {
                //    InSubD = 1;
                //}

                PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, BucketValues, InSubD, fnProdHier_pass, fnProdHier_failed);
            }
            else {
                PageMethods.fnChannelHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, BucketValues, fnProdHier_pass, fnProdHier_failed);
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
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl)) && ($("#ConatntMatter_hdnBucketType").val() == "3")) {
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

            $("#divHierPopupTbl").find("table").eq(0).find("thead").eq(0).find("input[type='text']").val("");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
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
            else {
                SelectedLvl = $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                    $(ctrl).attr("InSubD", "0");

                    //if ($("#chkIncludeSubd").is(":checked"))
                    //    $(ctrl).attr("InSubD", "1");
                    //else
                    //    $(ctrl).attr("InSubD", "0");
                }
            }

            $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
                    case "10":
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "20":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "30":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                    case "40":
                        descr += ", " + $(this).find("td").eq(3).html();
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
                        descr += ", " + $(this).find("td").eq(0).html();
                        break;
                    case "210":
                        descr += ", " + $(this).find("td").eq(1).html();
                        break;
                    case "220":
                        descr += ", " + $(this).find("td").eq(2).html();
                        break;
                }
            });
            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", SelectedHier);

                if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                    $(ctrl).closest("div").prev().html(descr.substring(2));
                }
            }
            else {
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", "");

                if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                    $(ctrl).closest("div").prev().html("");
                }
            }
        }




    </script>




    <style type="text/css">
        i {
            cursor: pointer;
        }

        textarea,
        input[type="text"],
        input[type="number"] {
            outline: none;
            border: 1px solid #b5b5b5;
        }

        .fsw_inner {
            border: none !important;
            background: transparent !important;
        }

        .fsw_inputBox {
            background: #eef4ff;
            border-radius: 3px;
            margin-right: 5px;
            border: solid 1px #b9c8e3;
        }

        .fsw .fsw_inputBox:last-child {
            border-right: solid 1px #b9c8e3;
        }

        .clsExpandCollapse {
            margin-right: 5px;
            margin-left: 5px;
            font-size: 0.8rem;
        }

        #divCopyBucketPopupTbl table tr.Active,
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

        input[type='text'] {
            width: 100%;
        }

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
                background: #D81F10 !important;
                border-color: #D81F10;
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
        #divReport img {
            cursor: pointer;
        }

        table.clsReport tr td {
            height: 46px;
            min-height: 46px;
        }

        table.clsReport tr th {
            text-align: center;
            vertical-align: middle;
        }

        /*table.clsReport tr:nth-child(1) th:nth-child(1) {
            width: 2%;
            min-width: 2%;
        }*/

        table.clsReport tr td:nth-child(1) {
            width: 1%;
            min-width: 1%;
        }

        table.clsReport tr td:nth-child(2) {
            width: 5%;
            min-width: 5%;
        }

        table.clsReport tr td:nth-child(3) {
            width: 15%;
            min-width: 15%;
        }

        table.clsReport tr td:nth-child(4) {
            width: 25%;
            min-width: 25%;
        }

        table.clsReport tr td:nth-child(5) {
            width: 10%;
            min-width: 10%;
        }

        table.clsReport tr td:nth-child(6) {
            width: 40%;
            min-width: 40%;
        }

        table.clsReport tr td:nth-child(7) {
            width: 5%;
            min-width: 5%;
            text-align: center;
        }


        #divReport td.clstdAction {
            text-align: center;
            width: 100px;
            min-width: 100px;
        }

            #divReport td.clstdAction img {
                margin: 0 4px;
                cursor: pointer;
            }



        table.clsReport tr td:nth-child(12) input[type='checkbox'] {
            height: 11px;
            margin-right: 10px;
            margin-bottom: 6px;
        }

        span.clstdExpandedContent {
            float: left;
            width: 120px;
            min-width: 120px;
            padding: 0 0 1px 0;
            white-space: normal;
            display: inline-block;
            text-align: left !important;
            font-size: .55rem !important;
        }

        table.clsReport td.clstdExpandedContent {
            border: none;
            width: 126px;
            height: auto;
            min-width: 100px;
            min-height: auto;
            white-space: normal;
            padding: 1px 0 0 3px;
            text-align: left !important;
            font-size: .55rem !important;
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
                    padding: .3rem;
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
    <style>
        div.clsAppRuleSlabContainer {
            width: 100%;
            margin-bottom: 2px;
            border: 1px solid #5e84ca;
        }

        div.clsAppRuleHeader {
            background: #044d91;
            color: #fff;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 3px 3px 0 0;
        }

        div.clsAppRuleSubHeader {
            background: #b9d2ff;
            color: #044d91;
            font-weight: 700;
            padding-left: 6px;
        }

            div.clsAppRuleSubHeader i {
                float: right;
                margin: 2px 5px;
                font-size: 0.6rem;
            }

        table.clsAppRule {
            font-size: 0.54rem;
            margin-bottom: 0.2rem;
        }

            table.clsAppRule tr:nth-child(1) th:nth-child(2),
            table.clsAppRule tr:nth-child(1) th:nth-child(3) {
                width: auto;
                min-width: auto;
                white-space: nowrap;
            }

            table.clsAppRule tr td {
                height: auto;
                min-height: auto;
                text-align: left !important;
            }

                table.clsAppRule tr td i {
                    margin: 2px 5px;
                }

        .slab-active {
            background: #F0F8FF !important;
        }
    </style>
    <style>
        /*.btn-disabled {
            cursor: default;
            color: #000 !important;
            box-shadow: none !important;
            background: #666 !important;
            border-color: #666 !important;
        }*/

        table.clstbl-Reject th:nth-child(1) {
            width: 36px;
            text-align: center;
        }

        table.clstbl-Reject th:nth-child(2) {
            width: 200px;
        }

        table.clstbl-Reject tr td:nth-child(1) {
            text-align: center;
        }

        table.clstbl-Reject tr td:nth-child(3) textarea {
            border: none;
        }
    </style>
    <style>
        .img-with-text {
            text-align: justify;
            width: 20px;
        }

            .img-with-text img {
                /*display: block;
                margin: 0 auto;*/
            }

        .p_btn {
            background-color: none;
            border: 1px solid #0673D9;
            color: #0673D9;
            padding: 4px 8px;
            font-size: 12px;
            cursor: pointer;
            display: inline-block;
            border-radius: .25rem;
            -moz-border-radius: .25rem;
            -webkit-border-radius: .25rem;
        }

            .p_btn > .fa {
                color: #f80808;
            }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title" id="Heading" style="font-size: .92rem">Initiative Released</h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 13%;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonth" class="form-control form-control-sm" onchange="fnGetReport();"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 22%;">
                    <div class="fsw-title">MS&P ALIAS</div>
                    <div class="d-block">
                        <select id="ddlMSMP" multiple="multiple"></select>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 35%;" >
                    <div class="row">

                        <div class="col-8">
                            <div class="fsw-title">Hierarchy Filter</div>
                            <div class="d-block">
                                <a id="txtProductHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="1" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Product Filter">Products</a>
                                <a id="txtLocationHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="2" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Location Filter">Location</a>
                                <a id="txtChannelHierSearch" class="btn btn-primary btn-sm" href="#" buckettype="3" prodlvl="" prodhier="" onclick="fnShowProdHierPopup(this, 0);" title="Channel Filter">Channel</a>
                            </div>
                        </div>
                        <div class="col-4" style="text-align: right;">
                            <a class="btn btn-primary btn-sm mt-4" href="#" onclick="fnResetFilter();">Reset</a>
                            <a class="btn btn-primary btn-sm mt-4" href="#" onclick="fnGetReport();">Show</a>
                            <img src="../../Images/excel.png" style="margin-top: 20px; margin-left: 10px; display: none;" />
                        </div>
                    </div>
                </div>
                <div class="fsw_inputBox" style="width: 30%;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
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

    <%--  <div id="divDRCPPlanBrnWise" style="margin-top: 0px">
    </div>--%>

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
    <div id="divbtns" style="width: 100%; background: #ccc; border: 1px solid #666; border-left: none; border-right: none; text-align: right; position: fixed; bottom: 0; padding: 8px 0; margin-left: -23px;">
        
        <%--<input type="button" id="btnUpload" value="Upload" onclick="fnUploadFiles()" class="btn btn-primary btn-disabled btn-sm" style="margin-right: 20px;" />--%>
    </div>
    <div id="dvPdfDialog" style="display: none">
        <iframe src="" id="iFramePdf" style="vertical-align: middle; background-color: White; width: 100%; border: 0;"></iframe>
    </div>

    <div id="divMsg" class="clsMsg"></div>
    <div id="divConfirm" style="display: none;"></div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />

    <asp:HiddenField ID="hdnInitID" runat="server" />

    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMonths" runat="server" />


    <asp:HiddenField ID="hdnBucketID" runat="server" />
    <asp:HiddenField ID="hdnBucketName" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />

    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />

    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    
    <asp:HiddenField ID="hdnMSMPAlies" runat="server" />
    <asp:HiddenField ID="hdnDisburshmentType" runat="server" />
    <asp:HiddenField ID="hdnMultiplicationType" runat="server" />
    <asp:HiddenField ID="hdnInitType" runat="server" />
    <asp:HiddenField ID="hdnUOM" runat="server" />
    <asp:HiddenField ID="hdnBenefit" runat="server" />
    <asp:HiddenField ID="hdnAppliedOn" runat="server" />


</asp:Content>
