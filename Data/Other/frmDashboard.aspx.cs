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

public partial class Data_Other_frmDashboard : System.Web.UI.Page
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
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spINITGetDashboardMatser";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbMstr = new StringBuilder();
        StringBuilder sbSelectedstr = new StringBuilder();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[0].Rows[i]["Start Date"].ToString() + "|" + Ds.Tables[0].Rows[i]["End Date"].ToString() + "'>" + Ds.Tables[0].Rows[i]["Month"].ToString() + "</option>");
            if (Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
                sbSelectedstr.Append(Ds.Tables[0].Rows[i]["Start Date"].ToString() + "|" + Ds.Tables[0].Rows[i]["End Date"].ToString());
        }
        hdnMonths.Value = sbMstr.ToString() + "^" + sbSelectedstr.ToString();

        Ds.Clear();
        sbMstr = new StringBuilder();
        StringBuilder sbProcessGrpLegend = new StringBuilder();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetMSMPAliesFilter]";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@CalledFrom", "1");
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        sbMstr.Clear();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[0].Rows[i]["UserID"].ToString() + "'>" + Ds.Tables[0].Rows[i]["MSMPAlies"].ToString() + "</option>");
        }
        hdnMSMPAlies.Value = sbMstr.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetTableData(string LoginID, string UserID, string RoleID, string NodeID, string NodeType, string FromDate, string EndDate, object objUser)
    {
        try
        {
            string strUser = JsonConvert.SerializeObject(objUser, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtUser = JsonConvert.DeserializeObject<DataTable>(strUser);
            if (dtUser.Rows[0][0].ToString() == "0")
                dtUser.Rows.RemoveAt(0);

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spDashboard";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@NodeID", NodeID);
            Scmd.Parameters.AddWithValue("@NodeType", NodeType);
            Scmd.Parameters.AddWithValue("@FromDate", FromDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
            Scmd.Parameters.AddWithValue("@Users", dtUser);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "seqNo";
            return "0|^|" + CreateTbl(Ds.Tables[0], SkipColumn, "tblReport", "clsReport");

        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    private static string CreateTbl(DataTable dt, string[] SkipColumn, string tblname, string cls)
    {

        StringBuilder sb = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            sb.Append("<table id='" + tblname + "' class='tbl_report " + cls + "'>");
            sb.Append("<thead>");
            sb.Append("<tr>");
            //sb.Append("<th>#</th>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
                }
            }
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr>");
                //sb.Append("<td>" + (i + 1).ToString() + "</td>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        else
        {
            sb.Append("<table id='" + tblname + "' class='tbl_report " + cls + "'>");
            sb.Append("<thead>");
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
                }
            }
            sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");
            sb.Append("<tr>");
            sb.Append("<td colspan='" + (dt.Columns.Count - SkipColumn.Length) + "' style='color: #fff; font-size: 1rem; font-weight: 700; padding:10px 20px;'>No Dashboard details found !</td>");
            sb.Append("</tr>");
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        return sb.ToString();
    }

}