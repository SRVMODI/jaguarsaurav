using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Data.SqlClient;
using System.Text;
using System.Net.Mail;


/// <summary>
/// Summary description for classSendMail
/// </summary>
public class classSendMail
{
    public classSendMail()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string fnSendmail(string mailTo, string mailCc, string MailSubject, string MailBody, string MailAttachment)
    {
        MailMessage mail = new MailMessage();
        mail = new MailMessage();
        StringBuilder mailString = new StringBuilder();

        string hostname = ConfigurationManager.AppSettings["MailServerString"];
        SmtpClient SmtpServer = new SmtpClient(hostname);
        string mailfrom = ConfigurationManager.AppSettings["DMSUser"];
        mail.From = new MailAddress(mailfrom);
        if (mailTo != "")
        {
            mail.To.Add(mailTo);
        }
        if (mailCc != "")
        {
            mail.CC.Add(mailCc);
        }
        mail.Subject = MailSubject;
        // var pathlocal = "E:/Server Prject/TJUKDMS_Dev/ManufacturerAttachement"+ MailAttachment; 

        // var path = HttpContext.Current.Server.MapPath("~/ManufacturerAttachement/" + MailAttachment);


        mailString.Append("<font  style='COLOR: #000080; FONT-FAMILY: Arial'  size=2>");
        mailString.Append("<p>Dear,</p>");
        mailString.Append("<p>" + MailBody + "</p>");
        mailString.Append("<p>Warm Regards</p>");
        mailString.Append("<br>Helpdesk");
        mailString.Append("<br>TJUK DMS</p>");
        mailString.Append("</font>");

        mail.IsBodyHtml = true;
        mail.Body = mailString.ToString();

        //Attachment tt=new Attachment(MailAttachment);
        //mail.Attachments.Add(tt);
        //string path = HttpContext.Current.Server.MapPath("~/ManufacturerAttachement/" + MailAttachment);

        if (MailAttachment != "")
        {
            Attachment at = new Attachment(HttpContext.Current.Server.MapPath("~/ManufacturerAttachement/" + MailAttachment));
            mail.Attachments.Add(at);
        }

        //SmtpServer.Port = 25;
        SmtpServer.Host = "smtp.gmail.com"; //"192.168.1.2"
        SmtpServer.Port = 587;
        string User = ConfigurationManager.AppSettings["DMSUser"];
        string Pass = ConfigurationManager.AppSettings["DMSGPassword"];
        SmtpServer.Credentials = new System.Net.NetworkCredential(User, Pass);
        //SmtpServer.Credentials = new System.Net.NetworkCredential("astix@astixsolutions.com", "guruonline");

        SmtpServer.EnableSsl = true;
        string sstrp = "";
        try
        {
            SmtpServer.Send(mail);
            sstrp = "Mail Sent Successfully^1";
        }
        catch (Exception ex)
        {
            sstrp = ex.Message + "^2";
        }
        return sstrp;
    }



}