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

public partial class _RemovedINITs : System.Web.UI.Page
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
        Scmd.CommandText = "spGetProdHierLvl";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@UserID", hdnUserID.Value);
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeID", hdnNodeID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeType", hdnNodeType.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbProductLvl = new StringBuilder();
        sbProductLvl.Append("<div class='producthrchy'>Product Level</div>");
        sbProductLvl.Append("<table class='productlvl_list'>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i != 0)
                sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbProductLvl.Append("</table>");
        hdnProductLvl.Value = sbProductLvl.ToString();

        //------- Location Lvl
        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetLocHierLvl";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@UserID", hdnUserID.Value);
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeID", hdnNodeID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeType", hdnNodeType.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbLocationLvl = new StringBuilder();
        sbLocationLvl.Append("<div class='producthrchy'>Location Level</div>");
        sbLocationLvl.Append("<table class='productlvl_list' style='margin-bottom: 12px;'>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i != 0)
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'><img src='../../Images/Down-Right-Arrow.png'/>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbLocationLvl.Append("</table>");
        hdnLocationLvl.Value = sbLocationLvl.ToString();

        //------- Channel Lvl
        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetChannelHierLvl ";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@UserID", hdnUserID.Value);
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeID", hdnNodeID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeType", hdnNodeType.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbChannelLvl = new StringBuilder();
        sbChannelLvl.Append("<div class='producthrchy'>Channel Level</div>");
        sbChannelLvl.Append("<table class='productlvl_list' style='margin-bottom: 12px;'>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i != 0)
                sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbChannelLvl.Append("</table>");
        hdnChannelLvl.Value = sbChannelLvl.ToString();

        //------- Masters -----------------------------------
        Ds.Clear();
        StringBuilder sbMstr = new StringBuilder();
        StringBuilder sbSelectedstr = new StringBuilder();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spINITGetINITMatser]";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        //------- Months
        sbMstr.Clear();
        sbSelectedstr.Clear();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[0].Rows[i]["Start Date"].ToString() + "|" + Ds.Tables[0].Rows[i]["End Date"].ToString() + "'>" + Ds.Tables[0].Rows[i]["Month"].ToString() + "</option>");
            if (Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
                sbSelectedstr.Append(Ds.Tables[0].Rows[i]["Start Date"].ToString() + "|" + Ds.Tables[0].Rows[i]["End Date"].ToString());
        }
        hdnMonths.Value = sbMstr.ToString() + "^" + sbSelectedstr.ToString();

        //------- Disburshment Type
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[1].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[1].Rows[i]["DisburshmentTypeID"].ToString() + "'>" + Ds.Tables[1].Rows[i]["DisburshmentType"].ToString() + "</option>");
        }
        hdnDisburshmentType.Value = sbMstr.ToString();

        //------- Multiplication Type
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[2].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[2].Rows[i]["MultiplicationTypeID"].ToString() + "'>" + Ds.Tables[2].Rows[i]["MultiplicationType"].ToString() + "</option>");
        }
        hdnMultiplicationType.Value = sbMstr.ToString();

        //------- Init Type
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[3].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[3].Rows[i]["INITTypeID"].ToString() + "' uom='" + Ds.Tables[3].Rows[i]["INITUOMID"].ToString() + "'>" + Ds.Tables[3].Rows[i]["INITType"].ToString() + "</option>");
        }
        hdnInitType.Value = sbMstr.ToString();

        //------- UOM 
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[4].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[4].Rows[i]["INITIOMID"].ToString() + "'>" + Ds.Tables[4].Rows[i]["INITUOM"].ToString() + "</option>");
        }
        hdnUOM.Value = sbMstr.ToString();

        //------- Benefit 
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[5].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[5].Rows[i]["INITBenefitID"].ToString() + "'>" + Ds.Tables[5].Rows[i]["INITBenefit"].ToString() + "</option>");
        }
        hdnBenefit.Value = sbMstr.ToString();

        //------- Applied On
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[6].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[6].Rows[i]["INITAppliedOnID"].ToString() + "'>" + Ds.Tables[6].Rows[i]["INITAppliedOn"].ToString() + "</option>");
        }
        hdnAppliedOn.Value = sbMstr.ToString();

        //------- Incentive Type
        sbMstr.Clear();
        sbMstr.Append("<option value='0'>--Select--</option>");
        for (int i = 0; Ds.Tables[7].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[7].Rows[i]["IncentiveTypeID"].ToString() + "'>" + Ds.Tables[7].Rows[i]["IncentiveType"].ToString() + "</option>");
        }
        hdnIncentiveType.Value = sbMstr.ToString();

        Ds.Clear();
        sbMstr = new StringBuilder();
        StringBuilder sbProcessGrpLegend = new StringBuilder();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spINITGetLeged]";
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        //------- Months
        sbMstr.Clear();
        sbProcessGrpLegend.Clear();
        sbMstr.Append("<option value=''>-- Select --</option>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMstr.Append("<option value='" + Ds.Tables[0].Rows[i]["Legend"].ToString() + "'>" + Ds.Tables[0].Rows[i]["Legend"].ToString() + "</option>");
            sbProcessGrpLegend.Append("<div class='clsdiv-legend-block'><div class='clsdiv-legend-color' style='background: " + Ds.Tables[0].Rows[i]["ColorCode"].ToString() + ";'></div><div class='clsdiv-legend-text'>" + Ds.Tables[0].Rows[i]["Legend"].ToString() + "</div></div>");
        }
        hdnProcessGrp.Value = sbMstr.ToString() + "^" + sbProcessGrpLegend.ToString();

        Ds.Clear();
        sbMstr = new StringBuilder();
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

        hdnBrandlstforNewNode.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "20", "2", "");
        hdnBrandFormlstforNewNode.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "30", "2", "");
    }
    [System.Web.Services.WebMethod()]
    public static string fnProdHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, string flg, object obj)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetPrdHierachyInTableFormat";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@UserNodeID", UserNodeID);
            Scmd.Parameters.AddWithValue("@UserNodeType", UserNodeType);
            Scmd.Parameters.AddWithValue("@ProdLvl", ProdLvl);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (flg == "1")
            {
                DataTable tbl = new DataTable();
                string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
                tbl = JsonConvert.DeserializeObject<DataTable>(str);
                if (tbl.Rows.Count > 0)
                {
                    return "0|^|" + GetProdTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(obj, "1", "0");
                }
                else
                    return "0|^|" + GetProdTbl(Ds.Tables[0], ProdLvl) + "|^|";
            }
            else
                return GetProdTblforNewNode(Ds.Tables[0], ProdLvl);
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string GetProdTbl(DataTable dt, string ProdLvl)
    {
        string[] SkipColumn = new string[9];
        SkipColumn[0] = "CatNodeID";
        SkipColumn[1] = "CatNodeType";
        SkipColumn[2] = "BrnNodeID";
        SkipColumn[3] = "BrnNodeType";
        SkipColumn[4] = "BFNodeID";
        SkipColumn[5] = "BFNodeType";
        SkipColumn[6] = "SBFNodeId";
        SkipColumn[7] = "SBFNodeType";
        SkipColumn[8] = "SearchString";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>"); //clsProduct clstable
        sb.Append("<thead>");

        sb.Append("<tr>");
        switch (ProdLvl)
        {
            case "10":
                sb.Append("<th colspan='2'>");
                break;
            case "20":
                sb.Append("<th colspan='3'>");
                break;
            case "30":
                sb.Append("<th colspan='4'>");
                break;
            case "40":
                sb.Append("<th colspan='5'>");
                break;
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this);' /></th>");
        sb.Append("<th style='display: none;'>SearchString</th>");
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
            switch (ProdLvl)
            {
                case "10":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='0' bf='0' sbf='0' nid='" + dt.Rows[i]["CatNodeID"] + "' ntype='" + dt.Rows[i]["CatNodeType"] + "'>");
                    break;
                case "20":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='0' sbf='0' nid='" + dt.Rows[i]["BrnNodeID"] + "' ntype='" + dt.Rows[i]["BrnNodeType"] + "'>");
                    break;
                case "30":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='0' nid='" + dt.Rows[i]["BFNodeID"] + "' ntype='" + dt.Rows[i]["BFNodeType"] + "'>");
                    break;
                case "40":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='" + dt.Rows[i]["SBFNodeId"] + "' nid='" + dt.Rows[i]["SBFNodeId"] + "' ntype='" + dt.Rows[i]["SBFNodeType"] + "'>");
                    break;
            }
            sb.Append("<td><img src='../../Images/checkbox-unchecked.png'/></td>");

            sb.Append("<td style='display: none;'>" + dt.Rows[i]["SearchString"] + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='clss-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string GetProdTblforNewNode(DataTable dt, string ProdLvl)
    {
        string[] SkipColumn = new string[9];
        SkipColumn[0] = "CatNodeID";
        SkipColumn[1] = "CatNodeType";
        SkipColumn[2] = "BrnNodeID";
        SkipColumn[3] = "BrnNodeType";
        SkipColumn[4] = "BFNodeID";
        SkipColumn[5] = "BFNodeType";
        SkipColumn[6] = "SBFNodeId";
        SkipColumn[7] = "SBFNodeType";
        SkipColumn[8] = "SearchString";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th style='display: none;'>#</th>");
        sb.Append("<th style='display: none;'>SearchString</th>");
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
            switch (ProdLvl)
            {
                case "10":
                    sb.Append("<tr onclick='fnSelectProdforNewNode(this);' flg='0' nid='" + dt.Rows[i]["CatNodeID"] + "' ntype='" + dt.Rows[i]["CatNodeType"] + "'>");
                    break;
                case "20":
                    sb.Append("<tr onclick='fnSelectProdforNewNode(this);' flg='0' nid='" + dt.Rows[i]["BrnNodeID"] + "' ntype='" + dt.Rows[i]["BrnNodeType"] + "'>");
                    break;
                case "30":
                    sb.Append("<tr onclick='fnSelectProdforNewNode(this);' flg='0' nid='" + dt.Rows[i]["BFNodeID"] + "' ntype='" + dt.Rows[i]["BFNodeType"] + "'>");
                    break;
                case "40":
                    sb.Append("<tr onclick='fnSelectProdforNewNode(this);' flg='0' nid='" + dt.Rows[i]["SBFNodeId"] + "' ntype='" + dt.Rows[i]["SBFNodeType"] + "'>");
                    break;
            }

            sb.Append("<td style='display: none;'>" + (i + 1).ToString() + "</td>");
            sb.Append("<td style='display: none;'>" + dt.Rows[i]["SearchString"] + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='cls-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnLocationHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, object obj, string InSubD)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetLocHierachyInTableFormat";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@UserNodeID", UserNodeID);
            Scmd.Parameters.AddWithValue("@UserNodeType", UserNodeType);
            Scmd.Parameters.AddWithValue("@ProdLvl", ProdLvl);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            DataTable tbl = new DataTable();
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows.Count > 0)
            {
                return "0|^|" + GetLocationTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(obj, "2", InSubD);
            }
            else
                return "0|^|" + GetLocationTbl(Ds.Tables[0], ProdLvl) + "|^|";
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string GetLocationTbl(DataTable dt, string ProdLvl)
    {
        string[] SkipColumn = new string[13];
        SkipColumn[0] = "CountryNodeID";
        SkipColumn[1] = "CountryNodeType";
        SkipColumn[2] = "RegionNodeID";
        SkipColumn[3] = "RegionNodeType";
        SkipColumn[4] = "SiteNodeID";
        SkipColumn[5] = "SiteNodeType";
        SkipColumn[6] = "DBRNodeId";
        SkipColumn[7] = "DBRNodeType";
        SkipColumn[8] = "BranchNodeId";
        SkipColumn[9] = "BranchNodeType";
        SkipColumn[10] = "SUBDNodeId";
        SkipColumn[11] = "SUBDNodeType";
        SkipColumn[12] = "SearchString";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>"); //clsProduct clstable
        sb.Append("<thead>");

        sb.Append("<tr>");
        switch (ProdLvl)
        {
            case "100":
                sb.Append("<th colspan='2'>");
                break;
            case "110":
                sb.Append("<th colspan='3'>");
                break;
            case "120":
                sb.Append("<th colspan='4'>");
                break;
            case "130":
                sb.Append("<th colspan='5'>");
                break;
            case "140":
                sb.Append("<th colspan='6'>");
                break;
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this);' /></th>");
        sb.Append("<th style='display: none;'>SearchString</th>");
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
            switch (ProdLvl)
            {
                case "100":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='0' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["CountryNodeID"] + "' ntype='" + dt.Rows[i]["CountryNodeType"] + "'>");
                    break;
                case "110":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["RegionNodeID"] + "' ntype='" + dt.Rows[i]["RegionNodeType"] + "'>");
                    break;
                case "120":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='0' branch='0' nid='" + dt.Rows[i]["SiteNodeID"] + "' ntype='" + dt.Rows[i]["SiteNodeType"] + "'>");
                    break;
                case "130":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='" + dt.Rows[i]["DBRNodeId"] + "' branch='0' nid='" + dt.Rows[i]["DBRNodeId"] + "' ntype='" + dt.Rows[i]["DBRNodeType"] + "'>");
                    break;
                case "140":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='" + dt.Rows[i]["DBRNodeId"] + "' branch='" + dt.Rows[i]["BranchNodeId"] + "' nid='" + dt.Rows[i]["BranchNodeId"] + "' ntype='" + dt.Rows[i]["BranchNodeType"] + "'>");
                    break;
            }
            sb.Append("<td><img src='../../Images/checkbox-unchecked.png' /></td>");

            sb.Append("<td style='display: none;'>" + dt.Rows[i]["SearchString"] + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='clss-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnChannelHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, object obj)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetChannelHierachyInTableFormat";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@UserNodeID", UserNodeID);
            Scmd.Parameters.AddWithValue("@UserNodeType", UserNodeType);
            Scmd.Parameters.AddWithValue("@ProdLvl", ProdLvl);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            DataTable tbl = new DataTable();
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tbl = JsonConvert.DeserializeObject<DataTable>(str);
            if (tbl.Rows.Count > 0)
            {
                return "0|^|" + GetChannelTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(obj, "3", "0");
            }
            else
                return "0|^|" + GetChannelTbl(Ds.Tables[0], ProdLvl) + "|^|";
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string GetChannelTbl(DataTable dt, string ProdLvl)
    {
        string[] SkipColumn = new string[7];
        SkipColumn[0] = "ClassID";
        SkipColumn[1] = "ClassNodeType";
        SkipColumn[2] = "ChannelID";
        SkipColumn[3] = "ChannelNodeType";
        SkipColumn[4] = "STNodeID";
        SkipColumn[5] = "STNodeType";
        SkipColumn[6] = "SearchString";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        switch (ProdLvl)
        {
            case "200":
                sb.Append("<th colspan='2'>");
                break;
            case "210":
                sb.Append("<th colspan='3'>");
                break;
            case "220":
                sb.Append("<th colspan='4'>");
                break;
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this);' /></th>");
        sb.Append("<th style='display: none;'>SearchString</th>");
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
            switch (ProdLvl)
            {
                case "200":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cls='" + dt.Rows[i]["ClassID"] + "' channel='0' storetype='0' nid='" + dt.Rows[i]["ClassID"] + "' ntype='" + dt.Rows[i]["ClassNodeType"] + "'>");
                    break;
                case "210":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cls='" + dt.Rows[i]["ClassID"] + "' channel='" + dt.Rows[i]["ChannelID"] + "' storetype='0' nid='" + dt.Rows[i]["ChannelID"] + "' ntype='" + dt.Rows[i]["ChannelNodeType"] + "'>");
                    break;
                case "220":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this);' flg='0' flgVisible='1' cls='" + dt.Rows[i]["ClassID"] + "' channel='" + dt.Rows[i]["ChannelID"] + "' storetype='" + dt.Rows[i]["STNodeID"] + "' nid='" + dt.Rows[i]["STNodeID"] + "' ntype='" + dt.Rows[i]["STNodeType"] + "'>");
                    break;
            }
            sb.Append("<td><img src='../../Images/checkbox-unchecked.png' /></td>");

            sb.Append("<td style='display: none;'>" + dt.Rows[i]["SearchString"] + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='clss-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string GetSelHierTbl(object obj, string BucketType, string InSubD)
    {
        DataTable tbl = new DataTable();
        string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        tbl = JsonConvert.DeserializeObject<DataTable>(str);

        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetHierDetails_New";
        Scmd.Parameters.AddWithValue("@PrdSelection", tbl);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        DataTable dt = Ds.Tables[0];
        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        if (BucketType == "1")
        {
            sb.Append("<th style='width:25%;'>Category</th>");
            sb.Append("<th style='width:25%;'>Brand</th>");
            sb.Append("<th style='width:25%;'>BrandForm</th>");
            sb.Append("<th style='width:25%;'>SubBrandForm</th>");
        }
        else if (BucketType == "2")
        {
            sb.Append("<th style='width:15%;'>Country</th>");
            sb.Append("<th style='width:20%;'>Region</th>");
            sb.Append("<th style='width:20%;'>Site</th>");
            sb.Append("<th style='width:25%;'>Distributor</th>");
            sb.Append("<th style='width:20%;'>Branch</th>");
            //sb.Append("<th style='width:25%;'>SubD</th>");
        }
        else
        {
            sb.Append("<th style='width:30%;'>Class</th>");
            sb.Append("<th style='width:35%;'>Channel</th>");
            sb.Append("<th style='width:35%;'>Store Type</th>");
        }
        sb.Append("</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            switch (dt.Rows[i]["NodeType"].ToString())
            {
                case "10":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='0' bf='0' sbf='0' nid='" + dt.Rows[i]["CatNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>All</td><td>All</td><td>All</td>");
                    break;
                case "20":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrandNodeID"] + "' bf='0' sbf='0' nid='" + dt.Rows[i]["BrandNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>" + dt.Rows[i]["Brand"] + "</td><td>All</td><td>All</td>");
                    break;
                case "30":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrandNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='0' nid='" + dt.Rows[i]["BFNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>" + dt.Rows[i]["Brand"] + "</td><td>" + dt.Rows[i]["BF"] + "</td><td>All</td>");
                    break;
                case "40":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrandNodeID"] + "' bf='" + dt.Rows[i]["BrandNodeID"] + "' sbf='" + dt.Rows[i]["SBFNodeID"] + "' nid='" + dt.Rows[i]["SBFNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>" + dt.Rows[i]["Brand"] + "</td><td>" + dt.Rows[i]["BF"] + "</td><td>" + dt.Rows[i]["SBF"] + "</td>");
                    break;
                case "100":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='0' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["CountryNodeId"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>All</td><td>All</td><td>All</td><td>All</td>");
                    break;
                case "110":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["RegionNodeId"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>All</td><td>All</td><td>All</td>");
                    break;
                case "120":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='" + dt.Rows[i]["SiteNodeId"] + "' dbr='0' branch='0' nid='" + dt.Rows[i]["SiteNodeId"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>" + dt.Rows[i]["Site"] + "</td><td>All</td><td>All</td>");
                    break;
                case "130":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='" + dt.Rows[i]["SiteNodeId"] + "' dbr='" + dt.Rows[i]["DBRNodeID"] + "' branch='0' nid='" + dt.Rows[i]["DBRNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>" + dt.Rows[i]["Site"] + "</td><td>" + dt.Rows[i]["DBR"] + "</td><td>All</td>");
                    break;
                case "140":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='" + dt.Rows[i]["DBRNodeID"] + "' branch='" + dt.Rows[i]["BranchNodeID"] + "' nid='" + dt.Rows[i]["BranchNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>" + dt.Rows[i]["Site"] + "</td><td>" + dt.Rows[i]["DBR"] + "</td><td>" + dt.Rows[i]["Branch"] + "</td>");
                    break;
                case "200":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cls='" + dt.Rows[i]["ClassNodeID"] + "' channel='0' storetype='0' nid='" + dt.Rows[i]["ClassNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Class"] + "</td><td>All</td><td>All</td>");
                    break;
                case "210":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cls='" + dt.Rows[i]["ClassNodeID"] + "' channel='" + dt.Rows[i]["ChannelNodeID"] + "' storetype='0' nid='" + dt.Rows[i]["ChannelNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Class"] + "</td><td>" + dt.Rows[i]["Channel"] + "</td><td>All</td>");
                    break;
                case "220":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cls='" + dt.Rows[i]["ClassNodeID"] + "' channel='" + dt.Rows[i]["ChannelNodeID"] + "' storetype='" + dt.Rows[i]["StoreTypeNodeID"] + "' nid='" + dt.Rows[i]["StoreTypeNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Class"] + "</td><td>" + dt.Rows[i]["Channel"] + "</td><td>" + dt.Rows[i]["StoreType"] + "</td>");
                    break;
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string GetBucketbasedonType(string LoginID, string RoleID, string UserID, string BucketType)
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetBucketbasedonType";
        Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
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

        DataTable dt = Ds.Tables[0];
        StringBuilder sb = new StringBuilder();
        sb.Append(GetCopyBucketTbl(dt));
        return sb.ToString();
    }
    private static string GetCopyBucketTbl(DataTable dt)
    {
        string[] SkipColumn = new string[3];
        SkipColumn[0] = "BucketID";
        SkipColumn[1] = "StrValue";
        SkipColumn[2] = "flgIncludeSubD";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");

        sb.Append("<tr>");
        sb.Append("<th colspan='2'>");
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnCopyBucketPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");
        sb.Append("<tr><th style='width: 30px;'></th><th>Bucket Name</th></tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr onclick='fnSelectUnSelectBucket(this);' flg='0' flgVisible='1' BucketID='" + dt.Rows[i]["BucketID"] + "' StrValue='" + dt.Rows[i]["StrValue"] + "' InSubD='" + dt.Rows[i]["flgIncludeSubD"] + "'>");
            sb.Append("<td><img src='../../Images/checkbox-unchecked.png' /></td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                {
                    sb.Append("<td class='clss-" + j + "'>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnSaveAsNewBucket(string BucketName, string BucketDescr, string BucketType, object obj, string LoginID, string PrdLvl, string PrdString)
    {
        DataTable tbl = new DataTable();
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tbl = JsonConvert.DeserializeObject<DataTable>(str);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spBucketSaveBucket";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@BucketID", "0");
            Scmd.Parameters.AddWithValue("@BucketName", BucketName);
            Scmd.Parameters.AddWithValue("@BucketDescr", BucketDescr);
            Scmd.Parameters.AddWithValue("@flgActive", "1");
            Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
            Scmd.Parameters.AddWithValue("@BucketValues", tbl);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@PrdLvl", PrdLvl);
            Scmd.Parameters.AddWithValue("@PrdString", PrdString);
            Scmd.Parameters.AddWithValue("@flgIncludeSubD", "0");
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) > -1)
            {
                return "0|^|" + Ds.Tables[0].Rows[0][0];
            }
            else if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) == -1)
            {
                return "1|^|";
            }
            else
            {
                return "2|^|";
            }
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnGetReport(string LoginID, string RoleID, string UserID, string FromDate, string ToDate, object objProd, object objLoc, object objChannel, string ProcessGroup, object objUser)
    {
        try
        {
            StringBuilder sbTimeChecker = new StringBuilder();
            string strUser = JsonConvert.SerializeObject(objUser, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable dtUser = JsonConvert.DeserializeObject<DataTable>(strUser);
            if (dtUser.Rows[0][0].ToString() == "0")
                dtUser.Rows.RemoveAt(0);

            sbTimeChecker.Append("SP Caliing Start : " + DateTime.Now.ToLongTimeString());

            DataTable tblProd = new DataTable();
            string str = JsonConvert.SerializeObject(objProd, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tblProd = JsonConvert.DeserializeObject<DataTable>(str);
            if (tblProd.Rows[0][0].ToString() == "0")
            {
                tblProd.Rows.RemoveAt(0);
            }

            DataTable tblLoc = new DataTable();
            string strLoc = JsonConvert.SerializeObject(objLoc, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tblLoc = JsonConvert.DeserializeObject<DataTable>(strLoc);
            if (tblLoc.Rows[0][0].ToString() == "0")
            {
                tblLoc.Rows.RemoveAt(0);
            }

            DataTable tblChannel = new DataTable();
            string strChannel = JsonConvert.SerializeObject(objChannel, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tblChannel = JsonConvert.DeserializeObject<DataTable>(strChannel);
            if (tblChannel.Rows[0][0].ToString() == "0")
            {
                tblChannel.Rows.RemoveAt(0);
            }

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandTimeout = 0;
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandText = "spINITGetInitiativeInfo_Deleted";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@PrdSelection", tblProd);
            Scmd.Parameters.AddWithValue("@LocSelection", tblLoc);
            Scmd.Parameters.AddWithValue("@ChannelSelection", tblChannel);
            Scmd.Parameters.AddWithValue("@FromDate", FromDate);
            Scmd.Parameters.AddWithValue("@EndDate", ToDate);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@Users", dtUser);
            if (ProcessGroup != "")
            {
                Scmd.Parameters.AddWithValue("@ProcessGroup", ProcessGroup);
            }
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string IsNewAdditionAllowed = "0";
            sbTimeChecker.Append("<br/>SP Caliing End : " + DateTime.Now.ToLongTimeString());
            return "0|^|" + CreateInitiativeMstrTbl(RoleID, Ds, "tblReport", "clsReport", IsNewAdditionAllowed) + "|^|" + CreateButtons(Ds.Tables[3]) + "|^|" + IsNewAdditionAllowed + "|^|" + CreateLegends(Ds.Tables[4]) + "|^|" + sbTimeChecker.ToString() + "<br/>HTML Format Created : " + DateTime.Now.ToLongTimeString();
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string CreateInitiativeMstrTbl(string RoleID, DataSet Ds, string tblname, string cls, string IsNewAdditionAllowed)
    {

        string[] SkipColumn = new string[20];
        SkipColumn[0] = "INITID";
        SkipColumn[1] = "AllLocation";
        SkipColumn[2] = "AllChannel";
        SkipColumn[3] = "LocStrValue";
        SkipColumn[4] = "ChannelStrValue";
        SkipColumn[5] = "FromDate";
        SkipColumn[6] = "flgIncludeSubD";
        SkipColumn[7] = "Name";
        SkipColumn[8] = "INITShortDescr";
        SkipColumn[9] = "DisburshmentTypeID";
        SkipColumn[10] = "MultiplicationTypeID";
        SkipColumn[11] = "Include SubD";
        SkipColumn[12] = "flgEdit";
        SkipColumn[13] = "flgRejectComment";
        SkipColumn[14] = "colorcode";
        SkipColumn[15] = "Applicable_Per";
        SkipColumn[16] = "flgBookmark";
        SkipColumn[17] = "flgCheckBox";
        SkipColumn[18] = "flgSettle";
        SkipColumn[19] = "IncentiveTypeId";

        DataTable dt = Ds.Tables[0];
        StringBuilder sb = new StringBuilder();
        StringBuilder sbLoc = new StringBuilder();
        StringBuilder sbChannel = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "' IsSchemeAppRule='1' IsLocExpand='1' IsChannelExpand='1'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th rowspan='2'><input type='checkbox' onclick='fnChkUnchkInitAll(this);'/></th>");
        sb.Append("<th rowspan='2'>Action</th>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            {
                if (dt.Columns[j].ColumnName.ToString().Trim() == "Code")
                {
                    if (RoleID != "3" && RoleID != "1014")
                        sb.Append("<th rowspan='2'>Recm. Trade Plan<br/>Short Details</th>");
                    else
                        sb.Append("<th rowspan='2'>Recm. Trade Plan</th>");
                }
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Description")
                    sb.Append("<th rowspan='2'>Details</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "ToDate")
                    sb.Append("<th rowspan='2'>Time Period</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Include Leap")
                    sb.Append("<th rowspan='2'>Include Leap/SubD</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Disburshment Limit Amount")
                    sb.Append("<th colspan='2'>Disb. Limit</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Disburshment Limit Count")
                    sb.Append("");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Initiatives Application Rules")
                    sb.Append("<th rowspan='2'><i iden='btnAppRuleExpandCollapse' class='fa fa-minus-square clsExpandCollapse' onclick='fnCollapseContent(1);'></i><span>Initiatives Application Rules</span></th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Location")
                    sb.Append("<th rowspan='2'><i iden='btnlocExpandCollapse' class='fa fa-minus-square clsExpandCollapse' onclick='fnCollapseContent(2);'></i><span>Location</span></th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Channel")
                    sb.Append("<th rowspan='2'><i iden='btnChannelExpandCollapse' class='fa fa-minus-square clsExpandCollapse' onclick='fnCollapseContent(3);'></i><span>Channel</span></th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "flgMixedCases")
                    sb.Append("<th rowspan='2'>Mixed Cases</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "strSearch")
                    sb.Append("<th rowspan='2' style='display: none;'>strSearch</th>");
                else
                    sb.Append("<th rowspan='2'>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            }
        }
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<th>Amount</th><th>Count</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string strInitAppRule = InitAppRules(dt.Rows[i]["INITID"].ToString(), Ds.Tables[1], Ds.Tables[2]);
                sb.Append("<tr Init='" + dt.Rows[i]["INITID"] + "' INITCode='" + dt.Rows[i]["Code"] + "' INITName='" + dt.Rows[i]["Name"] + "' ShortDescr='" + dt.Rows[i]["INITShortDescr"].ToString() + "' Descr='" + dt.Rows[i]["Description"].ToString() + "' lmlAmt='" + dt.Rows[i]["Disburshment Limit Amount"] + "' lmlCntr='" + dt.Rows[i]["Disburshment Limit Count"] + "' FromDate='" + dt.Rows[i]["FromDate"] + "' ToDate='" + dt.Rows[i]["ToDate"] + "' loc='" + dt.Rows[i]["AllLocation"].ToString() + "' locStr='" + dt.Rows[i]["LocStrValue"] + "' channel='" + dt.Rows[i]["AllChannel"].ToString() + "' channelStr='" + dt.Rows[i]["ChannelStrValue"] + "' InSubD='1' Distribution='" + dt.Rows[i]["DisburshmentTypeID"] + "^" + dt.Rows[i]["Method of Disb."] + "' Multiplication='" + dt.Rows[i]["MultiplicationTypeID"] + "^" + dt.Rows[i]["Multiplication Type"] + "' IncludeSubD='" + dt.Rows[i]["Include SubD"] + "' IncludeLeap='" + dt.Rows[i]["Include Leap"] + "' MixedCases='" + dt.Rows[i]["flgMixedCases"] + "' BaseProd='" + strInitAppRule.Split('~')[1] + "' InitProd='" + strInitAppRule.Split('~')[2] + "' ApplicablePer='" + dt.Rows[i]["Applicable_Per"].ToString() + "' ApplicableNewPer='" + dt.Rows[i]["Applicable_Per"].ToString() + "' IncentiveType='" + dt.Rows[i]["IncentiveTypeId"] + "^" + dt.Rows[i]["Type of Incentive"] + "' flgEdit='0' iden='Init' style='display: table-row;'>");

                sb.Append("<td iden='Init'>");
                sb.Append("<input iden='chkInit' type='checkbox' onclick='fnUnchkInitIndividual(this);'/>");
                sb.Append("</td>");

                sb.Append("<td iden='Init' class='clstdAction'>");
                sb.Append("<img src='../../Images/saveasdraft.png' title='Restore' onclick='fnRestore(this);'/>");
                sb.Append("</td>");

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        if (dt.Columns[j].ColumnName.ToString() == "Code")
                        {
                            if (RoleID != "3" && RoleID != "1014")
                            {
                                sb.Append("<td iden='Init' style='font-size: 0.7rem;'>" + (dt.Rows[i]["Name"].ToString().Length > 17 ? "<span title='" + dt.Rows[i]["Name"].ToString() + "' class='clsInform'>" + dt.Rows[i]["Name"].ToString().Substring(0, 15) + "..</span>" : dt.Rows[i]["Name"].ToString()) + "<br/>" + (dt.Rows[i]["INITShortDescr"].ToString().Length > 17 ? "<span title='" + dt.Rows[i]["INITShortDescr"].ToString() + "' class='clsInform'>" + dt.Rows[i]["INITShortDescr"].ToString().Substring(0, 15) + "..</span>" : dt.Rows[i]["INITShortDescr"].ToString()) + "</td>");
                            }
                            else
                                sb.Append("<td iden='Init' style='font-size: 0.7rem;'>" + (dt.Rows[i]["Name"].ToString().Length > 17 ? "<span title='" + dt.Rows[i]["Name"].ToString() + "' class='clsInform'>" + dt.Rows[i]["Name"].ToString().Substring(0, 15) + "..</span>" : dt.Rows[i]["Name"].ToString()) + "</td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "Description")
                        {
                            sb.Append("<td iden='Init' style='font-size: 0.7rem;'>" + (dt.Rows[i]["Description"].ToString().Length > 50 ? "<span title='" + dt.Rows[i]["Description"].ToString() + "' class='clsInform'>" + dt.Rows[i]["Description"].ToString().Substring(0, 48) + "..</span>" : dt.Rows[i]["Description"].ToString()) + "</td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "ToDate")
                            sb.Append("<td iden='Init'>" + dt.Rows[i]["FromDate"] + "<br/>to " + dt.Rows[i]["ToDate"] + "</td>");
                        else if (dt.Columns[j].ColumnName.ToString() == "Include Leap")
                        {
                            if (dt.Rows[i]["Include Leap"].ToString() == "1" && dt.Rows[i]["Include SubD"].ToString() == "1")
                                sb.Append("<td iden='Init'>Leap<br/>SubD</td>");
                            else if (dt.Rows[i]["Include Leap"].ToString() == "1")
                                sb.Append("<td iden='Init'>Leap</td>");
                            else if (dt.Rows[i]["Include SubD"].ToString() == "1")
                                sb.Append("<td iden='Init'>SubD</td>");
                            else
                                sb.Append("<td iden='Init'></td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "Initiatives Application Rules")
                        {
                            if (strInitAppRule.Split('~')[1] == "")
                                sb.Append("<td iden='Init'><div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-danger btn-small' style='cursor: default;'>No Rule Defined</a><div></td>");
                            else
                                sb.Append("<td iden='Init'><div style='width: 120px; min-width: 120px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopupNonEditable(this);'>View Details</a><div></td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "Location")
                        {
                            sb.Append("<td iden='Init'><div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + (dt.Rows[i]["AllLocation"].ToString().Length > 70 ? "<span title='" + dt.Rows[i]["AllLocation"].ToString() + "' class='clsInform'>" + dt.Rows[i]["AllLocation"].ToString().Substring(0, 68) + "..</span>" : dt.Rows[i]["AllLocation"].ToString()) + "</div></td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "Channel")
                        {
                            sb.Append("<td iden='Init'><div style='width: 202px; min-width: 202px; font-size:0.6rem;'>" + (dt.Rows[i]["AllChannel"].ToString().Length > 70 ? "<span title='" + dt.Rows[i]["AllChannel"].ToString() + "' class='clsInform'>" + dt.Rows[i]["AllChannel"].ToString().Substring(0, 68) + "..</span>" : dt.Rows[i]["AllChannel"].ToString()) + "</div></td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "flgMixedCases")
                        {
                            if (dt.Rows[i][j].ToString() == "1")
                                sb.Append("<td iden='Init'>Yes</td>");
                            else
                                sb.Append("<td iden='Init'>No</td>");
                        }
                        else if (dt.Columns[j].ColumnName.ToString() == "strSearch")
                            sb.Append("<td iden='Init' style='display: none;'>" + dt.Rows[i][j].ToString() + "</td>");
                        else
                            sb.Append("<td iden='Init'>" + dt.Rows[i][j] + "</td>");
                    }
                }

                sb.Append("</tr>");
            }
        }
        else
        {
            sb.Append("<tr iden='Init' Init='0' INITName=''>");
            sb.Append("<td style='background-color: transparent;'></td>");
            sb.Append("<td></td>");
            sb.Append("<td class='clstdAction'></td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                    if (dt.Columns[j].ColumnName.ToString() == "Code")
                    {
                        sb.Append("<td iden='Init' style='font-size: 0.7rem;'></td>");
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Description")
                    {
                        sb.Append("<td iden='Init' style='font-size: 0.7rem;'></td>");
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Initiatives Application Rules")
                    {
                        sb.Append("<td iden='Init'><div style='width: 120px; min-width: 120px; text-align: center;'><div></td>");
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Location")
                    {
                        sb.Append("<td iden='Init'><div style='width: 202px; min-width: 202px; font-size:0.6rem;'></div></td>");
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Channel")
                    {
                        sb.Append("<td iden='Init'><div style='width: 202px; min-width: 202px; font-size:0.6rem;'></div></td>");
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "strSearch")
                        sb.Append("<td iden='Init' style='display: none;'></td>");
                    else
                        sb.Append("<td iden='Init'></td>");
                }
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string ExtendContentBody(string strfull)
    {
        StringBuilder sb = new StringBuilder();
        if (strfull != "")
        {
            for (int i = 0; i < strfull.Split(',').Length; i++)
            {
                if (i != 0)
                    sb.Append(", ");
                sb.Append(strfull.Split(',')[i]);
            }
        }
        return sb.ToString();
    }
    private static string InitAppRules(string InitID, DataTable dtBase, DataTable dtInit)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sbBase = new StringBuilder();
        StringBuilder sbInit = new StringBuilder();

        sb.Append("<div style='width: 200px; min-width: 200px; text-align: center;'><a href='#' class='btn btn-primary btn-small' onclick='fnShowApplicationRulesPopup(this);'>View Details</a><div>");
        sb.Append("<div class='row no-gutters' style='width: 420px; min-width: 420px; display: none;'>");
        //-------
        sb.Append("<div class='col-6 clsBaseProd' style='padding-right: 1px; text-align: left; font-size:0.66rem;'>");
        sb.Append("<div class='clsAppRuleHeader'>Base Products :</div>");
        sb.Append("<div class='clsAppRuleSlabContainer'>");

        DataRow[] drInitiativeBase = dtBase.Select("INITID=" + InitID);
        if (drInitiativeBase.Length > 0)
        {
            DataTable dtInitiativeBase = drInitiativeBase.CopyToDataTable();
            DataTable dtDistinctSlab = dtInitiativeBase.DefaultView.ToTable(true, "SlabNo");
            for (int i = 0; i < dtDistinctSlab.Rows.Count; i++)
            {
                sbBase.Append("$$$" + dtDistinctSlab.Rows[i]["SlabNo"].ToString());
                sb.Append("<div iden='AppRuleSlabWiseContainer' slabno='" + dtDistinctSlab.Rows[i]["SlabNo"].ToString() + "' IsNewSlab='0'>");
                sb.Append("<div class='clsAppRuleSubHeader' flgExpandCollapse='1'><span onclick='fnAppRuleExpandCollapseSlab(this);' style='cursor: pointer;'>Slab " + (i + 1).ToString() + "</span></div>");
                sb.Append("<table class='table table-bordered clsAppRule'>");
                sb.Append("<tbody>");

                DataTable dtSlab = dtInitiativeBase.Select("SlabNo=" + dtDistinctSlab.Rows[i]["SlabNo"].ToString()).CopyToDataTable();
                DataTable dtDistinctGrp = dtSlab.DefaultView.ToTable(true, "INITSlabBasePrdGroupID");
                for (int j = 0; j < dtDistinctGrp.Rows.Count; j++)
                {
                    sbBase.Append("***");
                    sb.Append("<tr grpno='" + dtDistinctGrp.Rows[j]["INITSlabBasePrdGroupID"].ToString() + "' IsNewGrp='0'><td>Grp " + (j + 1).ToString() + "</td><td>");
                    DataTable dtGrp = dtSlab.Select("INITSlabBasePrdGroupID=" + dtDistinctGrp.Rows[j]["INITSlabBasePrdGroupID"].ToString()).CopyToDataTable();
                    sbBase.Append(dtGrp.Rows[0]["INITTypeID"].ToString() + "*$*" + dtGrp.Rows[0]["MinValue"].ToString() + "*$*" + dtGrp.Rows[0]["maxValue"].ToString() + "*$*" + dtGrp.Rows[0]["INITIOMID"].ToString() + "*$*");
                    for (int k = 0; k < dtGrp.Rows.Count; k++)
                    {
                        if (k != 0)
                        {
                            sbBase.Append("^");
                            sb.Append(", ");
                        }
                        sbBase.Append(dtGrp.Rows[k]["NodeID"].ToString() + "|" + dtGrp.Rows[k]["NodeType"].ToString() + "|" + dtGrp.Rows[k]["Descr"].ToString());
                        sb.Append(dtGrp.Rows[k]["Descr"].ToString());
                    }
                    sbBase.Append("*$*" + dtDistinctGrp.Rows[j]["INITSlabBasePrdGroupID"].ToString());
                    DataTable dtDistinctBucketID = dtSlab.DefaultView.ToTable(true, "BucketID");
                    for (int m = 0; m < dtDistinctBucketID.Rows.Count; m++)
                    {
                        if (m == 0)
                        {
                            sbBase.Append("*$*");
                        }
                        else
                        {
                            sbBase.Append("|");
                        }
                        sbBase.Append(dtDistinctBucketID.Rows[m]["BucketID"].ToString());
                    }
                    sb.Append("</td></tr>");
                }
                sb.Append("</tbody></table>");
                sb.Append("</div>");
            }
        }

        sb.Append("</div>");
        sb.Append("</div>");
        //------------------
        sb.Append("<div class='col-6 clsInitProd' style='text-align: left; font-size:0.66rem;'>");
        sb.Append("<div class='clsAppRuleHeader'>Initiative Products :</div>");
        sb.Append("<div class='clsAppRuleSlabContainer'>");
        DataRow[] drInitiativeInit = dtInit.Select("INITID=" + InitID);
        if (drInitiativeInit.Length > 0)
        {
            DataTable dtInitiativeInit = drInitiativeInit.CopyToDataTable();
            DataTable dtDistinctGrp = dtInitiativeInit.DefaultView.ToTable(true, "INITSlabBanefitPrdGroupID");

            sb.Append("<table class='table table-bordered clsAppRule'>");
            sb.Append("<tbody>");
            for (int j = 0; j < dtDistinctGrp.Rows.Count; j++)
            {
                sbInit.Append("***");
                DataTable dtGrp = dtInitiativeInit.Select("INITSlabBanefitPrdGroupID=" + dtDistinctGrp.Rows[j]["INITSlabBanefitPrdGroupID"].ToString()).CopyToDataTable();
                sbInit.Append(dtGrp.Rows[0]["INITBenefitID"].ToString() + "*$*" + dtGrp.Rows[0]["INITAppliedOnID"].ToString() + "*$*" + dtGrp.Rows[0]["Value"].ToString() + "*$*" + dtGrp.Rows[0]["SlabNo"].ToString() + "*$*");

                sb.Append("<tr slabno='" + dtGrp.Rows[0]["SlabNo"].ToString() + "' grpno='" + dtDistinctGrp.Rows[j]["INITSlabBanefitPrdGroupID"].ToString() + "' IsNewSlab='0' IsNewGrp='0'><td>");
                for (int k = 0; k < dtGrp.Rows.Count; k++)
                {
                    if (k != 0)
                    {
                        sbInit.Append("^");
                        sb.Append(", ");
                    }
                    sbInit.Append(dtGrp.Rows[k]["NodeID"].ToString() + "|" + dtGrp.Rows[k]["NodeType"].ToString() + "|" + dtGrp.Rows[k]["Descr"].ToString());
                    sb.Append(dtGrp.Rows[k]["Descr"].ToString());
                }
                sbInit.Append("*$*" + dtDistinctGrp.Rows[j]["INITSlabBanefitPrdGroupID"].ToString());
                sbInit.Append("*$*0");      // CopyBucketID
                sb.Append("</td></tr>");
            }
            sb.Append("</tbody></table>");
        }
        sb.Append("</div>");
        sb.Append("</div>");

        sb.Append("</div>");
        return sb.ToString() + "~" + sbBase.ToString() + "~" + sbInit.ToString();
    }
    private static string customTooltipBody(string Prods)
    {
        int cntr = 0;
        int rowsperator = 0;
        string locationlvl = "";
        if (Prods.Split(',').Length < 6)
            rowsperator = 0;
        else if (Prods.Split(',').Length < 11)
            rowsperator = 1;
        else
            rowsperator = 2;

        StringBuilder sb = new StringBuilder();
        locationlvl = Prods.Split(',')[0].Split('$')[0].Trim();
        sb.Append(customTooltipHeader(0, rowsperator, Prods));

        sb.Append("<tbody>");
        sb.Append("<tr>");
        for (int i = 0; i < Prods.Split(',').Length; i++)
        {

            if (locationlvl != Prods.Split(',')[i].Split('$')[0].Trim())
            {
                sb.Append("</tr>");
                sb.Append("</tbody>");
                sb.Append("</table>");
                sb.Append(customTooltipHeader(i, rowsperator, Prods));
                sb.Append("<tbody>");
                sb.Append("<tr>");
                cntr = 0;
                locationlvl = Prods.Split(',')[i].Split('$')[0].Trim();
            }
            cntr++;
            sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
            sb.Append("<td>" + Prods.Split(',')[i].Split('$')[2] + "</td>");
            if (cntr > rowsperator)
            {
                cntr = 0;
                sb.Append("</tr><tr>");
            }
        }
        sb.Append("</tr>");
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();

    }
    private static string customTooltipHeader(int i, int rowsperator, string Prods)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<div>Selection Level :<span>" + Prods.Split(',')[i].Split('$')[0] + "</span></div>");

        sb.Append("<table>");
        sb.Append("<thead>");
        switch (rowsperator)
        {
            case 0:
                if (Prods.Split(',')[i].Split('$')[0].Trim() == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "SubD")
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Class")
                {
                    sb.Append("<tr><th>Class</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Channel")
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Store Type")
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th></tr>");
                }
                break;
            case 1:
                if (Prods.Split(',')[i].Split('$')[0] == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0] == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0] == "SubD")
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Class")
                {
                    sb.Append("<tr><th>Class</th><th>Class</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Channel")
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Store Type")
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th></tr>");
                }
                break;
            case 2:
                if (Prods.Split(',')[i].Split('$')[0] == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0] == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0] == "SubD")
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Class")
                {
                    sb.Append("<tr><th>Class</th><th>Class</th><th>Class</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Channel")
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Store Type")
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th></tr>");
                }
                break;
        }
        sb.Append("</thead>");
        return sb.ToString();

    }
    private static string CreateButtons(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<a href='#' class='btn btn-primary btn-disabled btn-sm' style='margin-right: 10px;' flgAction='" + dt.Rows[i]["ButtonID"].ToString() + "'>" + dt.Rows[i]["Button"].ToString() + "</a>");
        }
        return sb.ToString();
    }
    private static string CreateLegends(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<div class='clsdiv-legend-block'><div class='clsdiv-legend-color' style='background: " + dt.Rows[i]["ColorCode"].ToString() + ";'></div><div class='clsdiv-legend-text'>" + dt.Rows[i]["Legend"].ToString() + "</div></div>");
        }
        return sb.ToString();
    }



    [System.Web.Services.WebMethod()]
    public static string fnRestore(string RoleID, string LoginID, string UserID, object objINIT)
    {
        try
        {
            string strINIT = JsonConvert.SerializeObject(objINIT, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblINIT = JsonConvert.DeserializeObject<DataTable>(strINIT);

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spINITRestoreINIT";
            Scmd.Parameters.AddWithValue("@INITIDs", tblINIT);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@USerID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            return "0";
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        DataTable tblLoc = new DataTable();
        //string strBucket = JsonConvert.SerializeObject(arr, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        tblLoc = JsonConvert.DeserializeObject<DataTable>(hdnjsonarr.Value);
        if (tblLoc.Rows[0][0].ToString() == "0")
            tblLoc.Rows.RemoveAt(0);

        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGenerateChannelSummary]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@MonthVal", hdnmonthyearexcel.Value.ToString().Split('^')[0]);
        Scmd.Parameters.AddWithValue("@YearVal", hdnmonthyearexcel.Value.ToString().Split('^')[1]);
        Scmd.Parameters.AddWithValue("@LoginID", Session["LoginID"].ToString());
        Scmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
        Scmd.Parameters.AddWithValue("@RoleID", Session["RoleId"].ToString());
        Scmd.Parameters.AddWithValue("@INITID", tblLoc);


        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);
        if (ds.Tables[0].Rows.Count > 0)
        {
            //if (File.Exists(Server.MapPath("~/Uploads/") + ds.Tables[0].Rows[0][0].ToString()))
            //{
            clsExcelDownload.ConvertToExcelNew(ds, "", hdnmonthyearexceltext.Value);
            //}
        }

        //ConvertToExcelNew(ds);
    }
}