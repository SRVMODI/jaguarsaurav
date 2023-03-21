<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.IO;
using System.Web;
using System.Data;
using System.Linq;
using ClosedXML.Excel;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Runtime.Serialization.Formatters.Binary;

public class FileUploadHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState  {



    public void ProcessRequest (HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            string monthyear=context.Request.Form["monthyear"].ToString();
            string msg = UploadExcel(files,monthyear);//postedFile
            context.Response.Write(msg);
        }

    }




    private string UploadExcel(HttpFileCollection files,string monthyear)//, string FileSetType HttpPostedFile File_Up
    {
        StringBuilder strMessageSummary = new StringBuilder();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            HttpPostedFile File_Up = files[0];

            string FileSetType = File_Up.FileName.Split('#')[1];

            string filename =  Path.GetFileName(File_Up.FileName.Split('#')[0]); //FileSetID + "_" +
            string filePath = HttpContext.Current.Server.MapPath("~/Uploads/") + filename;
            File_Up.SaveAs(filePath);


             bool error = false;
            using (XLWorkbook workBook = new XLWorkbook(filePath))
            {
                if (workBook.Worksheets.Count == 7)
                {
                    string[] strArray = { "Important Disclaimers", "Consumer Promotions", "Corp Budgets SIDs", "Brand Budgets SIDs", "Focus Brands", "ITrial", "Counsellor Plans" };

                    bool validsheet = true;
                    int seq = 0;
                    error = false;
                    foreach (IXLWorksheet workSheet in workBook.Worksheets)
                    {

                        if (strArray[seq].ToString().ToLower() != workSheet.Name.ToString().ToLower())
                        {
                            validsheet = false;
                            strMessageSummary.Append("<br>");
                            strMessageSummary.Append("Wrong Sheet Name or Sequence for sheet name  " + workSheet.Name + " ");
                            error = true;
                        }
                        seq++;

                    }
                }
                else
                {
                    error = true;
                    strMessageSummary.Append("No Worksheet found or Invalid Worksheet Number !");                    
                }
            }

            if (error)
            {
                return "1^" + strMessageSummary + "";
            }



            DataSet ds = new DataSet();
            //SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spFileGetFileSetID]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@FileName", Path.GetFileName(File_Up.FileName.Split('#')[0]));
            //Scmd.Parameters.AddWithValue("@FileSetType", FileSetType);
            Scmd.Parameters.AddWithValue("@LoginId", HttpContext.Current.Session["LoginID"].ToString());
            Scmd.Parameters.Add("@FileSetId", SqlDbType.VarChar, 30);
            Scmd.Parameters["@FileSetId"].Direction = ParameterDirection.Output;
            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();

            string FileSetID = Scmd.Parameters["@FileSetId"].Value.ToString();



           

           



            Scmd = new SqlCommand();

            Scmd.Connection = Scon;
            Scmd.CommandText = "[spFileLoadFile]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@FileSetID", FileSetID);
            Scmd.Parameters.AddWithValue("@MonthVal", monthyear.Split('^')[0]);
            Scmd.Parameters.AddWithValue("@YEarVal", monthyear.Split('^')[1]);
            Scmd.Parameters.AddWithValue("@LoginID", HttpContext.Current.Session["LoginID"].ToString());
            Scmd.Parameters.AddWithValue("@FileName", filename);

            Scon.Open();
            Scmd.ExecuteNonQuery();
            Scon.Close();


            return "0^File Uploaded Successfully.";

        }
        catch (Exception ex)
        {
            return "1^Error:" + ex.Message.ToString();
        }
        finally
        {
            Scon.Dispose();
        }

    }


    public static string UploadData(DataTable dtRecords, int FileSetId, int flgFileType) //,string loginid
    {
        string strFile = "";
        try
        {
            string[] ArrMapping = null;
            //if (flgFileType == 10)
            {
                strFile = "OrderReport";
                ArrMapping = new string[11];
                ArrMapping[0] = "Site";
                ArrMapping[1] = "Distributor Name";
                ArrMapping[2] = "OH_Date";
                ArrMapping[3] = "Month";
                ArrMapping[4] = "Category";
                ArrMapping[5] = "Local Channel Name";
                ArrMapping[6] = "Account Name";
                ArrMapping[7] = "Order Value";
                ArrMapping[8] = "Order quantity";
                ArrMapping[9] = "Invoice Value";
                ArrMapping[10] = "Invoice Qty";
            }



            //dtRecords.Columns["LoginID"].DefaultValue = loginid;

            if (dtRecords != null && dtRecords.Rows.Count > 0)
            {
                string strcon = System.Configuration.ConfigurationManager.AppSettings["strConn"];

                if (dtRecords.Columns.Count - 2 != ArrMapping.Length - 2)
                {
                    return "1|Column count mis-match. It must be " + (ArrMapping.Length - 2) + " Columns in "+ strFile+" . Please check sample file and correct it then upload again.";
                }

                for (int j = 0; j < dtRecords.Columns.Count; j++)
                {
                    if (!ArrMapping.Contains(dtRecords.Columns[j].ColumnName.ToString().Trim()))
                    {
                        return "1|" + dtRecords.Columns[j].ColumnName.ToString().Trim() + " column is not a valid defined column in "+ strFile+" . Please check sample file and correct it then upload again.";
                    }
                }

                using (SqlBulkCopy bulkCopy = new SqlBulkCopy(strcon))
                {
                    bulkCopy.BatchSize = 1000;
                    bulkCopy.NotifyAfter = 1000;
                    //if (flgFileType == 10)
                    {

                        bulkCopy.DestinationTableName = "tmpOrderReport";
                        using (SqlConnection connection = new SqlConnection(strcon))
                        {
                            connection.Open();
                            // Delete old entries
                            SqlCommand truncate = new SqlCommand("TRUNCATE TABLE " + bulkCopy.DestinationTableName + "", connection);
                            truncate.ExecuteNonQuery();
                        }

                        bulkCopy.ColumnMappings.Add("[Site]", "[Site]");
                        bulkCopy.ColumnMappings.Add("[Distributor Name]", "[Distributor Name]");
                        bulkCopy.ColumnMappings.Add("[Month]", "[Month]");
                        bulkCopy.ColumnMappings.Add("[OH_Date]", "[Date]");
                        bulkCopy.ColumnMappings.Add("[Category]", "[Category]");
                        bulkCopy.ColumnMappings.Add("[Local Channel Name]", "[Local Channel Name]");
                        bulkCopy.ColumnMappings.Add("[Account Name]", "[Account Name]");
                        bulkCopy.ColumnMappings.Add("[Order Value]", "[Order Value]");
                        bulkCopy.ColumnMappings.Add("[Order quantity]", "[Order quantity]");
                        bulkCopy.ColumnMappings.Add("[Invoice Value]", "[Invoice Value]");
                        bulkCopy.ColumnMappings.Add("[Invoice Qty]", "[Invoice Qty]");

                    }

                    System.Data.SqlClient.SqlBulkCopyColumnMappingCollection sbcmc = bulkCopy.ColumnMappings;
                    bulkCopy.WriteToServer(dtRecords);
                }
            }
            return "0|";
        }
        catch (Exception ex)
        {
            //clsSendLogMail.SendErrorMail("Error while Updating Data in DB (UploadData-bulkCopy). \n Error : " + ex.Message, FileName);
            return "1|" + ex.Message+" while uploading Data of "+strFile;
        }
    }
    static bool validatefiledate(string date)
    {
        bool isValid = false;
        try
        {

            Regex regex = new Regex(@"^\d{4}((0\d)|(1[012]))(([012]\d)|3[01])$");///([12]\d{3}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01]))/

            //Verify whether date entered in dd/MM/yyyy format.
            isValid = regex.IsMatch(date.Trim());

            //Verify whether entered date is Valid date.
            //DateTime dt;
            //isValid = DateTime.TryParseExact(date, "dd/MM/yyyy", new System.Globalization.CultureInfo("en-GB"), System.Globalization.DateTimeStyles.None, out dt);
        }
        catch (Exception ex)
        {
            isValid = false;
        }

        return isValid;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}