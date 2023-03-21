using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ClosedXML.Excel;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for clsExcelDownload
/// </summary>
public class clsExcelDownload
{
    public clsExcelDownload()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static void ConvertToExcelNew(DataSet Ds,string type,string ddlmonth)
    {

        string[] SkipColumn = new string[0];      

        try
        {



            //foreach (string col in SkipColumn)
            //{
            //    if (Ds.Tables[0].Columns.Contains(col.ToLower()))
            //    {
            //        Ds.Tables[0].Columns.Remove(col);
            //    }
            //}

            string strworkbook = "";

            if (type == "existing")
            {


                using (XLWorkbook wb = new XLWorkbook(HttpContext.Current.Server.MapPath("~/Uploads/") + Ds.Tables[0].Rows[0][0].ToString()))
                {
                    ////Start Chassiss
                    int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                    string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;
                    int resulsetcnt = 2;
                    //foreach (DataRow drowchasiss in Ds.Tables[0].Rows)//For SheetName
                    //{
                    //string strSheetName = filename.Length > 31 ? filename.Substring(0, 28) + "..." : filename;//drowchasiss["SheetName"].ToString();
                    DataTable dt = Ds.Tables[resulsetcnt];
                    resulsetcnt++;
                    var ws = wb.Worksheets.Add(Ds.Tables[1].Rows[0][0].ToString());

                    k = 1; j = 0; colFreeze = 2; colLeft = 3;
                    strold = ""; cntc = 0; colst = 2; flgb = true; bool flgm = false;
                    //int rowstart = 0; // for data part insertion
                    int noofsplit = 1; //Convert.ToInt16(drowchasiss["NoOfSplit"]);
                    int noofcolfreeze = 0;// Convert.ToInt16(drowchasiss["Noofcolfreeze"]);
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        if (!SkipColumn.Contains(dt.Columns[c].ColumnName.ToString().Trim()))
                        {
                            string[] ColSpliter = dt.Columns[c].ColumnName.ToString().Split('^');


                            flgm = true;

                            for (var i = 0; i < ColSpliter.Length; i++)
                            {
                                string sVal = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                                ws.Cell(k + i, j + 1).Value = sVal.Split('^')[0];
                            }
                            for (var i = 0; i < noofsplit; i++)
                            {
                                ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#337ab7");
                                ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml("#ffffff");
                                ws.Cell(k + i, j + 1).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                            }


                            j++;
                        }
                    }

                    for (var i = 0; i < noofsplit - 1; i++)
                    {
                        j = 0; colst = 1; k = 1; strold = "";
                        for (int c = 0; c < dt.Columns.Count; c++)
                        {
                            //if (strold != "")
                            //{
                            if (strold != dt.Columns[c].ColumnName.ToString().Split('^')[i])
                            {
                                flgb = true;
                                if (strold != "")
                                {
                                    ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j)).Merge();
                                }
                                cntc = 0;
                            }
                            //}
                            if (flgb == true)
                            {
                                colst = j + 1;
                            }
                            flgb = false;
                            strold = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                            cntc++;
                            if (c == dt.Columns.Count - 1)
                            {
                                ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j + 1)).Merge();
                                cntc = 0;
                            }

                            j++;
                        }
                    }


                    int rowst = 0;
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        strold = dt.Columns[c].ColumnName.ToString().Split('^')[0];
                        colst = 1; k = 1; flgb = false; rowst = 1;


                        for (var i = 0; i < noofsplit; i++)
                        {
                            //strold = "";                                                   
                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i, c + 1)).Merge();
                                flgb = false;
                                rowst++;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] == "")
                            {
                                flgb = true;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == false && i > 0)
                            {
                                rowst++;
                            }

                            if (i == noofsplit - 1 && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i + 1, c + 1)).Merge();
                            }
                        }
                    }
                    /**/


                    //var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            ws.Cell(noofsplit + i + 1, j + 1).Value = dt.Rows[i][j].ToString().Replace("amp;", "");
                        }
                    }

                    //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                    IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);

                    //ws.Range(ws.Cell(k, 5), cell4).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    ws.SheetView.FreezeRows(noofsplit);
                    ws.SheetView.FreezeColumns(noofcolfreeze);
                    //}
                    ws.Columns().AdjustToContents();
                    //ws.Rows().AdjustToContents();

                    //ws.Columns(1, 3).Width = 25;
                    ws.Column(2).Width = 35;
                    ws.Column(5).Width = 35;
                    ws.Column(7).Width = 35;
                    ws.Column(10).Width = 35;
                    ws.Column(12).Width = 35;
                    ws.Column(15).Width = 35;



                    ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;

                    //ws.Rows().AdjustToContents();

                    //Export the Excel file.
                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.Buffer = true;
                    HttpContext.Current.Response.Charset = "";
                    HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    //HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Unicode;

                    //Response.ContentType = "application/vnd.ms-excel";
                    HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + "Channel Summary "+ddlmonth+".xlsx");
                    using (MemoryStream MyMemoryStream = new MemoryStream())
                    {
                        wb.SaveAs(MyMemoryStream);
                        MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                        HttpContext.Current.Response.Flush();
                        HttpContext.Current.Response.End();
                    }
                }

            }
            else
            {
                using (XLWorkbook wb = new XLWorkbook())
                {
                    ////Start Chassiss
                    int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                    string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;
                    int resulsetcnt = 2;
                    //foreach (DataRow drowchasiss in Ds.Tables[0].Rows)//For SheetName
                    //{
                    //string strSheetName = filename.Length > 31 ? filename.Substring(0, 28) + "..." : filename;//drowchasiss["SheetName"].ToString();
                    DataTable dt = Ds.Tables[resulsetcnt];
                    resulsetcnt++;
                    var ws = wb.Worksheets.Add(Ds.Tables[1].Rows[0][0].ToString());

                    k = 1; j = 0; colFreeze = 2; colLeft = 3;
                    strold = ""; cntc = 0; colst = 2; flgb = true; bool flgm = false;
                    //int rowstart = 0; // for data part insertion
                    int noofsplit = 1; //Convert.ToInt16(drowchasiss["NoOfSplit"]);
                    int noofcolfreeze = 0;// Convert.ToInt16(drowchasiss["Noofcolfreeze"]);
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        if (!SkipColumn.Contains(dt.Columns[c].ColumnName.ToString().Trim()))
                        {
                            string[] ColSpliter = dt.Columns[c].ColumnName.ToString().Split('^');


                            flgm = true;

                            for (var i = 0; i < ColSpliter.Length; i++)
                            {
                                string sVal = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                                ws.Cell(k + i, j + 1).Value = sVal.Split('^')[0];
                            }
                            for (var i = 0; i < noofsplit; i++)
                            {
                                ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#337ab7");
                                ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml("#ffffff");
                                ws.Cell(k + i, j + 1).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                                ws.Cell(k + i, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                            }


                            j++;
                        }
                    }

                    for (var i = 0; i < noofsplit - 1; i++)
                    {
                        j = 0; colst = 1; k = 1; strold = "";
                        for (int c = 0; c < dt.Columns.Count; c++)
                        {
                            //if (strold != "")
                            //{
                            if (strold != dt.Columns[c].ColumnName.ToString().Split('^')[i])
                            {
                                flgb = true;
                                if (strold != "")
                                {
                                    ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j)).Merge();
                                }
                                cntc = 0;
                            }
                            //}
                            if (flgb == true)
                            {
                                colst = j + 1;
                            }
                            flgb = false;
                            strold = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                            cntc++;
                            if (c == dt.Columns.Count - 1)
                            {
                                ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j + 1)).Merge();
                                cntc = 0;
                            }

                            j++;
                        }
                    }


                    int rowst = 0;
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        strold = dt.Columns[c].ColumnName.ToString().Split('^')[0];
                        colst = 1; k = 1; flgb = false; rowst = 1;


                        for (var i = 0; i < noofsplit; i++)
                        {
                            //strold = "";                                                   
                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i, c + 1)).Merge();
                                flgb = false;
                                rowst++;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] == "")
                            {
                                flgb = true;
                            }

                            if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == false && i > 0)
                            {
                                rowst++;
                            }

                            if (i == noofsplit - 1 && flgb == true)
                            {
                                ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i + 1, c + 1)).Merge();
                            }
                        }
                    }
                    /**/


                    //var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        for (j = 0; j < dt.Columns.Count; j++)
                        {
                            ws.Cell(noofsplit + i + 1, j + 1).Value = dt.Rows[i][j].ToString().Replace("amp;", "");
                        }
                    }
                            //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                            IXLCell cell3 = ws.Cell(1, 1);
                    IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);

                    //ws.Range(ws.Cell(k, 5), cell4).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                    ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                    ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                    ws.SheetView.FreezeRows(noofsplit);
                    ws.SheetView.FreezeColumns(noofcolfreeze);
                    //}
                    ws.Columns().AdjustToContents();
                    //ws.Rows().AdjustToContents();

                    //ws.Columns(1, 3).Width = 25;
                    ws.Column(2).Width = 35;
                    ws.Column(5).Width = 35;
                    ws.Column(7).Width = 35;
                    ws.Column(10).Width = 35;
                    ws.Column(12).Width = 35;
                    ws.Column(15).Width = 35;



                    ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;

                    //ws.Rows().AdjustToContents();

                    //Export the Excel file.
                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.Buffer = true;
                    HttpContext.Current.Response.Charset = "";
                    HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                    //Response.ContentType = "application/vnd.ms-excel";
                    HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + "Channel Summary " + ddlmonth + ".xlsx");
                    using (MemoryStream MyMemoryStream = new MemoryStream())
                    {
                        wb.SaveAs(MyMemoryStream);
                        MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                        HttpContext.Current.Response.Flush();
                        HttpContext.Current.Response.End();
                    }
                }
            }


        }
        catch (Exception ex)
        {
            // string ProjectTitle = ConfigurationManager.AppSettings["Title"];
            //clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "FrmDownload Page", "Download Page", "Error in FrmDownload Page in " + ProjectTitle);
        }

    }


}