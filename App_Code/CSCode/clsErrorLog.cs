using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
/// <summary>
/// Error Log Files
/// </summary>
public class clsErrorLog
{
    private static string strDocName = "";
    /// <summary>
    /// log error in xml file 
    /// </summary>
    /// <param name="ErrorMsg"></param>
    /// <param name="strModule"></param>
    public static void WriteErrorLog(string ErrorMsg, string strModule, bool IsWeb)
    {
        System.Xml.XmlDocument xmlDoc = new System.Xml.XmlDocument();
        System.Xml.XmlElement xmlErrorElemnt;
        System.Xml.XmlElement xmlErrorMsgElemnt;
        System.Xml.XmlElement xmlModuleElemnt;
        System.Xml.XmlElement xmlTimeElemnt;
        try
        {
            if (ErrorMsg == "Thread was being aborted.")
            {
                return;
            }
            CreateLogFile(IsWeb);
            xmlDoc.Load(strDocName);

            xmlErrorElemnt = xmlDoc.CreateElement("Error");

            xmlErrorMsgElemnt = xmlDoc.CreateElement("ErrorMsg");
            xmlErrorMsgElemnt.InnerText = ErrorMsg;
            xmlErrorElemnt.AppendChild(xmlErrorMsgElemnt);

            xmlModuleElemnt = xmlDoc.CreateElement("Module");
            xmlModuleElemnt.InnerText = strModule;
            xmlErrorElemnt.AppendChild(xmlModuleElemnt);

            xmlTimeElemnt = xmlDoc.CreateElement("DateTime");
            xmlTimeElemnt.InnerText = DateTime.Now.ToString();
            xmlErrorElemnt.AppendChild(xmlTimeElemnt);

            xmlDoc.DocumentElement.AppendChild(xmlErrorElemnt);
            xmlDoc.Save(strDocName);
        }

        catch
        {

        }
    }
    /// <summary>
    /// create a log file for every month.
    /// </summary>
    private static void CreateLogFile(bool IsWeb)
    {
        string strPath = string.Empty;
        string strDirectory = string.Empty;
        string strMonth = System.DateTime.Now.Month.ToString();
        string strYear = System.DateTime.Now.Year.ToString();
        string strMsg = "<CMS></CMS>";
        try
        {
            strDocName = strYear + "_" + strMonth + ".xml";
            if (IsWeb)
                strPath = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + "\\ErrorLog\\";
            else
                strPath = System.Environment.CurrentDirectory + "\\ErrorLog\\";
            if (!System.IO.Directory.Exists(strPath))
            {
                System.IO.Directory.CreateDirectory(strPath);
            }

            strDocName = strPath + strDocName;

            if (!System.IO.File.Exists(strPath + strYear + "_" + strMonth + ".xml"))
            {
                System.Xml.XmlDocument objXmlDoc = new System.Xml.XmlDocument();
                objXmlDoc.LoadXml(strMsg);
                objXmlDoc.Save(strDocName);
            }
        }
        catch
        {
        }

    }

    public static void CreateLogfile(string strMsg, bool IsWeb)
    {
        string strFilePath;
        string strDirectoryPath;
        if (IsWeb)
            strDirectoryPath = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath);
        else
            strDirectoryPath = System.Environment.CurrentDirectory;

        strFilePath = strDirectoryPath + "ErrorLog\\" + System.DateTime.Now.Day.ToString("00") + System.DateTime.Now.Month.ToString("00") + System.DateTime.Now.Year.ToString("0000") + ".log";
        StreamWriter strWrite = default(StreamWriter);
        try
        {
            if (!System.IO.Directory.Exists(strDirectoryPath + "ErrorLog\\"))
            {
                System.IO.Directory.CreateDirectory(strDirectoryPath + "ErrorLog\\");
            }

            if (System.IO.File.Exists(strFilePath))
            {
                strWrite = File.AppendText(strFilePath);
            }
            else
            {
                strWrite = File.CreateText(strFilePath);
                strWrite.WriteLine("DATE                  EVENT                  MESSAGE");
                strWrite.WriteLine("-------------------------------------------------------------------------------------------");
            }
            strWrite.WriteLine(strMsg);
            strWrite.Close();
        }
        catch
        {

            // CreateLogfile(ex.Message);
        }
        finally
        {
            strWrite = null;
            System.GC.Collect();
        }
    }
}