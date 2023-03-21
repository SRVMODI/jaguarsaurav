<%@ WebHandler Language="C#" Class="FileInitUploadHandler" %>

using System;
using System.IO;
using System.Web;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Runtime.Serialization.Formatters.Binary;
using System.Collections.Generic;

public class FileInitUploadHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState {

    public void ProcessRequest(HttpContext context)
    {

        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;
            string LoginId = context.Request.Form["LoginId"].ToString();
            string msg = UploadExcel(files, LoginId);//postedFile
            context.Response.Write(msg);
        }

    }

    private string UploadExcel(HttpFileCollection files, string LoginId)//, string FileSetType HttpPostedFile File_Up
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        try
        {
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile File_Up = files[i];

                string FileSetType = File_Up.FileName.Split('#')[1];
                string initid = File_Up.FileName.Split('#')[2];

                string filename = Path.GetFileName(File_Up.FileName.Split('#')[0]); //FileSetID + "_" +

                string filePath = HttpContext.Current.Server.MapPath("~/Uploads/InvoiceFiles/"+initid+"/") + filename;



                var directory = new DirectoryInfo( HttpContext.Current.Server.MapPath("~/Uploads/InvoiceFiles/"+initid+"/"));
                if (!directory.Exists)
                {
                    directory.Create();
                }

                File_Up.SaveAs(filePath);
            }


            return "0^Invoice File Uploaded Successfully..";


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