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

public partial class ExtendCreationDateSBD : System.Web.UI.Page
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
            }
        }
    }


    [System.Web.Services.WebMethod()]
    public static string fnGetReport(string LoginID, string UserID, string RoleID)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSBDGetLockingPeriod";
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[3];
            SkipColumn[0] = "EndDate";
            SkipColumn[1] = "MonthVal";
            SkipColumn[2] = "YearVal";

            return "0|^|" + CreateMonthMstr(Ds.Tables[0]) + "|^|" + CreateTbl(Ds.Tables[1], SkipColumn, "Report");
        }
        catch (Exception ex)
        {
            return "2|^|" + ex.Message;
        }
    }


    private static string CreateMonthMstr(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<option value='0'>--Select--</option>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<option value='" + dt.Rows[i]["YearVal"].ToString() + "|" + AddZero(dt.Rows[i]["MonthVal"].ToString(), 2) + "' start='" + dt.Rows[i]["StartDate"].ToString() + "' end='" + dt.Rows[i]["EndDate"].ToString() + "' Month='" + AddZero(dt.Rows[i]["MonthVal"].ToString(), 2) + "' Year='" + dt.Rows[i]["YearVal"] + "'>" + dt.Rows[i]["Month_Name"] + "</option>");
        }
        return sb.ToString();
    }
    private static string AddZero(string str, int len)
    {
        StringBuilder sb = new StringBuilder();
        if (str.Length < len)
        {
            for (int i = str.Length; i < len; i++)
            {
                sb.Append("0");
            }
        }
        sb.Append(str);
        return sb.ToString();
    }
    private static string CreateTbl(DataTable dt, string[] SkipColumn, string Name)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table id='tbl" + Name + "' class='table table-bordered table-sm cls-" + Name + "'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th>#</th>");
        sb.Append("<th>Quarter</th>");
        sb.Append("<th>Time Period</th>");
        //for (int j = 0; j < dt.Columns.Count; j++)
        //{
        //    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
        //    {
        //        sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
        //    }
        //}
        sb.Append("<th>Action</th>");


        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr iden='creationdate' startdate='" + dt.Rows[i]["StartDate"] + "' enddate='" + dt.Rows[i]["EndDate"] + "' Month='" + AddZero(dt.Rows[i]["MonthVal"].ToString(), 2) + "' Year='" + dt.Rows[i]["YearVal"] + "' flgEdit='0'>");
            sb.Append("<td iden='creationdate'>" + (i + 1).ToString() + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                    if (dt.Columns[j].ColumnName.ToString() == "StartDate")
                    {
                        sb.Append("<td iden='creationdate'>" + dt.Rows[i]["StartDate"] + "<span>To</span>" + dt.Rows[i]["EndDate"] + "</td>");
                    }
                    else
                        sb.Append("<td iden='creationdate'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("<td iden='creationdate'><img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);'/></td>");

            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    

    [System.Web.Services.WebMethod()]
    public static string fnSave(string UserID, string RoleID, string MOnthVal, string YearVal, object StartDate, string EndDate)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSBDManageLockingPeriod";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@MOnthVal", MOnthVal);
            Scmd.Parameters.AddWithValue("@YearVal", YearVal);
            Scmd.Parameters.AddWithValue("@StartDate", StartDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            return "0|^|";
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }

}