using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.IO;
using ClosedXML.Excel;


public partial class _MSnPtoSBDMapping : System.Web.UI.Page
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
        Scmd.CommandText = "spSBDMSMP_SBD_FBMapping";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sb = new StringBuilder();
        hdnSelectedUser.Value = "0";

        sb.Append("<option value='0'>-- Select User --</option>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sb.Append("<option value='" + Ds.Tables[0].Rows[i]["UserID"].ToString() + "'>" + Ds.Tables[0].Rows[i]["MS&P Name"].ToString() + "</option>");
            if(Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
                hdnSelectedUser.Value = Ds.Tables[0].Rows[i]["UserID"].ToString();
        }
        hdnUser.Value = sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string MappedUser(string LoginID, string UserID)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSBDSaveMSMP_SBDMapping";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@USerID", UserID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();
            
            return "0|^|";

        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
}