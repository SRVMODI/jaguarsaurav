using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using System.IO;

public partial class SWBExtract : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/frmLogin.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                hdnLoginID.Value = Session["LoginID"].ToString();
                hdnUserID.Value = Session["UserID"].ToString();
                hdnRoleID.Value = Session["RoleId"].ToString();
                hdnNodeID.Value = Session["NodeId"].ToString();
                hdnNodeType.Value = Session["NodeType"].ToString();

                GetMaster();
            }
        }
    }
    private void GetMaster()
    {

        //------- Month
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetMonthswithCM";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        ListItem itm = new ListItem();
        foreach (DataRow dr in Ds.Tables[0].Rows)
        {
            itm = new ListItem();
            itm.Text = dr["Month"].ToString();
            itm.Value = dr["MonthVal"].ToString() + "|" + dr["YEarVal"].ToString();
            ddlMonth.Items.Add(itm);
            if (dr["flgSelect"].ToString() == "1")
            {
                itm.Selected = true;
            }
        }
    }


    [System.Web.Services.WebMethod()]
    public static string fnDownloadCSVExtractReport(string Month, string Year, string LoginID, string UserID, string RoleID)
    {
        try
        {

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPExtract";
            Scmd.Parameters.AddWithValue("@MonthVal", Month);
            Scmd.Parameters.AddWithValue("@YearVal", Year);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] MonthArr = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
            string strFileName = "Site-Channel wise SBF Priority Extract - " + MonthArr[Convert.ToInt16(Month) - 1] + " " + Year;
            try
            {
                string[] SkipColumn = new string[0];
                saveCSVFile(Ds.Tables[0], SkipColumn, HttpContext.Current.Server.MapPath("~/Files/") + strFileName + ".csv");
            }
            catch (Exception ex)
            {
                classSendMail.fnSendmail("saurav@astix.in", "", "Jaguar : Error while Downloading SWB Extract", ex.Message, "");
            }
            finally
            {
                Sdap.Dispose();
                Scmd.Dispose();
                Scon.Dispose();
            }

            return "0|^|" + strFileName.ToString();
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static void saveCSVFile(DataTable dt, string[] SkipColumn, string Path)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    if (j != dt.Columns.Count - 1)
                        sb.Append(dt.Rows[i][j].ToString() + ", ");
                    else
                        sb.Append(dt.Rows[i][j].ToString());
                }
            }
            sb.Append(Environment.NewLine);
        }

        using (StreamWriter objWriter = new StreamWriter(Path, false, new UTF8Encoding(true)))
        {
            objWriter.WriteLine(sb);
            objWriter.Flush();
        }
        sb.Clear();
    }
}