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

public partial class Data_EntryForms_frmExtendCreationDate : System.Web.UI.Page
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
                hdnProcessType.Value = "1";                             // 1: Initiative,   2: SBD,   3: FB
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

        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGetMonthswithCM]";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;

        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
   
   
        StringBuilder sbMstr = new StringBuilder();
        StringBuilder sbSelectedstr = new StringBuilder();
  
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        //------- Months
        sbMstr.Clear();
        sbSelectedstr.Clear();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[0].Rows[i]["MonthVal"].ToString() + "|" + Ds.Tables[0].Rows[i]["YEarVal"].ToString() + "'>" + Ds.Tables[0].Rows[i]["Month"].ToString() + "</option>");
            if (Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
                sbSelectedstr.Append(Ds.Tables[0].Rows[i]["MonthVal"].ToString() + "|" + Ds.Tables[0].Rows[i]["YEarVal"].ToString());
        }
        hdnMonths.Value = sbMstr.ToString() + "^" + sbSelectedstr.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetTableData(string MonthVal, string YearVal, string ProcessType)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spINITGetDataForExtendedDate";
            Scmd.Parameters.AddWithValue("@MonthVal", MonthVal);
            Scmd.Parameters.AddWithValue("@YearVal", YearVal);
            Scmd.Parameters.AddWithValue("@ProcessType", ProcessType);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[2];
            SkipColumn[0] = "NodeID";
            SkipColumn[1] = "UserID";
   
            return "0|^|" + CreateMstrTbl(Ds.Tables[0],  SkipColumn, "tblReport", "clsReport");

        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    private static string CreateMstrTbl(DataTable dt,  string[] SkipColumn, string tblname, string cls)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sbDescr = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th>#</th>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            {
                sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            }
        }
        sb.Append("<th>Action</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sbDescr.Clear();
            sb.Append("<tr NodeID='" + dt.Rows[i]["NodeID"] + "' UserID='" + dt.Rows[i]["UserID"] + "' UserName='" + dt.Rows[i]["User Name"] + "' EmailID='" + dt.Rows[i]["Email ID"] + "' Role='" + dt.Rows[i]["Role"] + "' ExtendedTill='" + dt.Rows[i]["Extended Till"] + "' >");
            sb.Append("<td>" + (i + 1).ToString() + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                  if (dt.Columns[j].ColumnName.ToString().ToLower() == "extended till")
                    {
                        if (dt.Rows[i]["Extended Till"].ToString().Length > 0)
                        {
                          sb.Append("<td><input type='text' class='clsDate' style='box-sizing: border-box;width:100px' value='" + dt.Rows[i]["Extended Till"].ToString() + "'  placeholder='Extended Date'/></td>");
                        }
                        else
                        {
                            sb.Append("<td><input type='text' class='clsDate' style='box-sizing: border-box;width:100px' placeholder='Extended Date'/></td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                    }
                }
            }

            sb.Append("<td title='Save'><img src='../../Images/save.png' onclick='fnSave(this, 0);'/></td>");

            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnSave(string NodeID,  string date, string month, string year, string useridextend, string ProcessType)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spINITExtendCreationDate";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@UserID", useridextend);
            Scmd.Parameters.AddWithValue("@NodeID", NodeID);
            Scmd.Parameters.AddWithValue("@LoginID", HttpContext.Current.Session["LoginID"].ToString());
            Scmd.Parameters.AddWithValue("@Date", date);
            Scmd.Parameters.AddWithValue("@MonthVal", month);
            Scmd.Parameters.AddWithValue("@YearVal", year);
            Scmd.Parameters.AddWithValue("@ProcessType", ProcessType);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();


            return "0|^|" + "Saved successfully.";
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
}