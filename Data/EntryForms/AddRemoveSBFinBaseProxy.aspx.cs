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

public partial class Data_EntryForms_AddRemoveSBFinBaseProxy : System.Web.UI.Page
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
                hdnPageType.Value = Request.QueryString["pg"].ToString();       // 1:Add ,2:Delete

                hdnLoginID.Value = Session["LoginID"].ToString();
                hdnUserID.Value = Session["UserID"].ToString();
                hdnRoleID.Value = Session["RoleId"].ToString();
                hdnNodeID.Value = Session["NodeId"].ToString();
                hdnNodeType.Value = Session["NodeType"].ToString();
                GetMaster();

                hdnSBFMstr.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "40");
            }
        }
    }
    private void GetMaster()
    {
        DataSet Ds = new DataSet();
        StringBuilder sb = new StringBuilder();
        StringBuilder sbSelected = new StringBuilder();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);

        //------- Channel Lvl
        Ds.Clear();
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetChannelHierLvl ";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@UserID", hdnUserID.Value);
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeID", hdnNodeID.Value);
        Scmd.Parameters.AddWithValue("@UserNodeType", hdnNodeType.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        sb.Append("<div class='producthrchy'>Channel Level</div>");
        sb.Append("<table class='productlvl_list' style='margin-bottom: 12px;'>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i != 0)
                sb.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvlSel(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sb.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvlSel(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sb.Append("</table>");
        hdnChannelLvl.Value = sb.ToString();

        //------- Quarter
        Ds.Clear();
        sb.Clear();

        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spSBDGetQtr]";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@UserID", hdnUserID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sb.Append("<option value='" + Ds.Tables[0].Rows[i]["FromDate"].ToString() + "|" + Ds.Tables[0].Rows[i]["ToDate"].ToString() + "|" + Ds.Tables[0].Rows[i]["QtrNo"].ToString() + "|" + Ds.Tables[0].Rows[i]["Year"].ToString() + "'>" + Ds.Tables[0].Rows[i]["QrtName"].ToString() + "</option>");

            if (Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
                sbSelected.Append(Ds.Tables[0].Rows[i]["FromDate"].ToString() + "|" + Ds.Tables[0].Rows[i]["ToDate"].ToString() + "|" + Ds.Tables[0].Rows[i]["QtrNo"].ToString() + "|" + Ds.Tables[0].Rows[i]["Year"].ToString());
        }
        hdnQuarter.Value = sb.ToString() + "|^|" + sbSelected.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnProdHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl)
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

            return GetProdTbl(Ds.Tables[0], ProdLvl);

        }
        catch (Exception ex)
        {
            return "Due to some technical reasons, we are unable to process your request !";
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

        //sb.Append("<tr>");
        //switch (ProdLvl)
        //{
        //    case "10":
        //        sb.Append("<th colspan='2'>");
        //        break;
        //    case "20":
        //        sb.Append("<th colspan='3'>");
        //        break;
        //    case "30":
        //        sb.Append("<th colspan='4'>");
        //        break;
        //    case "40":
        //        sb.Append("<th colspan='5'>");
        //        break;
        //}
        //sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        //sb.Append("</th>");
        //sb.Append("</tr>");

        sb.Append("<tr>");
        //sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this);' /></th>");
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
                    sb.Append("<tr onclick='fnSelectSBF(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='0' bf='0' sbf='0' nid='" + dt.Rows[i]["CatNodeID"] + "' ntype='" + dt.Rows[i]["CatNodeType"] + "'>");
                    break;
                case "20":
                    sb.Append("<tr onclick='fnSelectSBF(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='0' sbf='0' nid='" + dt.Rows[i]["BrnNodeID"] + "' ntype='" + dt.Rows[i]["BrnNodeType"] + "'>");
                    break;
                case "30":
                    sb.Append("<tr onclick='fnSelectSBF(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='0' nid='" + dt.Rows[i]["BFNodeID"] + "' ntype='" + dt.Rows[i]["BFNodeType"] + "'>");
                    break;
                case "40":
                    sb.Append("<tr onclick='fnSelectSBF(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='" + dt.Rows[i]["SBFNodeId"] + "' nid='" + dt.Rows[i]["SBFNodeId"] + "' ntype='" + dt.Rows[i]["SBFNodeType"] + "'>");
                    break;
            }
            //sb.Append("<td><img src='../../Images/checkbox-unchecked.png' /></td>");

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
    public static string fnLocationHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, string flg, object obj, string InSubD)
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
                Scmd = new SqlCommand();
                Scmd.Connection = Scon;
                Scmd.CommandText = "spGetHierDetails";
                Scmd.Parameters.AddWithValue("@PrdSelection", tbl);
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.CommandTimeout = 0;
                Sdap = new SqlDataAdapter(Scmd);
                DataSet DsSelHier = new DataSet();
                Sdap.Fill(DsSelHier);
                Scmd.Dispose();
                Sdap.Dispose();

                return "0|^|" + GetLocationTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(DsSelHier.Tables[0], "2", InSubD);
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
    public static string fnChannelHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, string flg, object obj)
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
                Scmd = new SqlCommand();
                Scmd.Connection = Scon;
                Scmd.CommandText = "spGetHierDetails";
                Scmd.Parameters.AddWithValue("@PrdSelection", tbl);
                Scmd.CommandType = CommandType.StoredProcedure;
                Scmd.CommandTimeout = 0;
                Sdap = new SqlDataAdapter(Scmd);
                DataSet DsSelHier = new DataSet();
                Sdap.Fill(DsSelHier);
                Scmd.Dispose();
                Sdap.Dispose();

                return "0|^|" + GetChannelTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(DsSelHier.Tables[0], "3", "0");
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
    public static string GetClusters(string LoginID, string RoleID, string UserID, string BucketType, string QtrNo, string QtrYear)
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetBucketbasedonType";
        Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
        Scmd.Parameters.AddWithValue("@LoginID", LoginID);
        Scmd.Parameters.AddWithValue("@UserID", UserID);
        Scmd.Parameters.AddWithValue("@RoleID", RoleID);
        Scmd.Parameters.AddWithValue("@QtrNo", QtrNo);
        Scmd.Parameters.AddWithValue("@QtrYear", QtrYear);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        DataTable dt = Ds.Tables[0];
        StringBuilder sb = new StringBuilder();
        sb.Append(GetClusterTbl(dt));
        return sb.ToString();
    }
    private static string GetClusterTbl(DataTable dt)
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
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnClusterPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");
        sb.Append("<tr><th style='width: 30px;'></th><th>Name</th></tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr onclick='fnSelectUnSelectCluster(this);' flg='0' flgVisible='1' clusterid='" + dt.Rows[i]["BucketID"] + "' StrValue='" + dt.Rows[i]["StrValue"] + "'>");
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
        else if (BucketType == "3")
        {
            sb.Append("<th style='width:30%;'>Class</th>");
            sb.Append("<th style='width:35%;'>Channel</th>");
            sb.Append("<th style='width:35%;'>Store Type</th>");
        }
        else
        {
            sb.Append("<th style='width:15%;'>Country</th>");
            sb.Append("<th style='width:25%;'>Region</th>");
            sb.Append("<th style='width:20%;'>Site</th>");
            sb.Append("<th style='width:40%;'>Distributor</th>");
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
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>All</td><td>All</td><td>All</td>");
                    break;
                case "110":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["RegionNodeId"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>All</td><td>All</td>");
                    break;
                case "120":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='" + dt.Rows[i]["SiteNodeId"] + "' dbr='0' branch='0' nid='" + dt.Rows[i]["SiteNodeId"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>" + dt.Rows[i]["Site"] + "</td><td>All</td>");
                    break;
                case "130":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cntry='" + dt.Rows[i]["CountryNodeId"] + "' reg='" + dt.Rows[i]["RegionNodeId"] + "' site='" + dt.Rows[i]["SiteNodeId"] + "' dbr='" + dt.Rows[i]["DBRNodeID"] + "' branch='0' nid='" + dt.Rows[i]["DBRNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Country"] + "</td><td>" + dt.Rows[i]["Region"] + "</td><td>" + dt.Rows[i]["Site"] + "</td><td>" + dt.Rows[i]["DBR"] + "</td>");
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
    public static string fnGetDetails(string SBFNodeID, string SBFNodeType, object objProd, object objLoc, object objChannel, string Qtr, string Yr, string LoginID, string RoleID, string UserID, string flgPage, string flgSBF)
    {
        try
        {
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

            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spSBDGetSBDForAddRemoveSBF]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@SBFNodeID", SBFNodeID);
            Scmd.Parameters.AddWithValue("@SBFNodeType", SBFNodeType);
            Scmd.Parameters.AddWithValue("@QtrNo", Qtr);
            Scmd.Parameters.AddWithValue("@QtrYear", Yr);
            Scmd.Parameters.AddWithValue("@Clusters", tblLoc);
            Scmd.Parameters.AddWithValue("@ChannelSelection", tblChannel);
            Scmd.Parameters.AddWithValue("@PrdFilter", tblProd);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@flgAddDelete", flgPage);
            Scmd.Parameters.AddWithValue("@flgBaseProxy", flgSBF);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            if (ds.Tables[0].Rows.Count > 0)
                return "0|^|" + GetSBDlst(ds, flgSBF);
            else
                return "1|^|<div style='font-size: 1rem; font-weight: 600; padding: 5px 20px;'>No SBD(s) Found !</div>";
        }
        catch (Exception ex)
        {
            return "2|^|" + ex.Message;
        }
    }
    private static string GetSBDlst(DataSet Ds, string flgSBF)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table id='tblSBDHeader' class='table table-striped table-bordered table-sm mb-0'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th><input type='checkbox' id='chkSBDSelectAll' onclick='fnSBDSelectAll(this);'/></th>");
        sb.Append("<th>Cluster<br/><input type='text' iden='cluster' placeholder='Type atleast 3 characters' onkeyup='fnSBDTypeSearch(this);'/></th>");
        sb.Append("<th>Channel<br/><input type='text' iden='channel' placeholder='Type atleast 3 characters' onkeyup='fnSBDTypeSearch(this);'/></th>");
        sb.Append("<th>Base SBF<br/><input type='text' iden='basesbf' placeholder='Type atleast 3 characters' onkeyup='fnSBDTypeSearch(this);'/></th>");
        //sb.Append("<th>Proxy SBF<br/><input type='text' iden='proxysbf' placeholder='Type atleast 2 characters' onkeyup='fnSBDTypeSearch(this);'/></th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("</table>");
        sb.Append("<div id='dvSBDBody' style='overflow-y: auto;'>");
        sb.Append("<table id='tblSBDBody' class='table table-striped table-bordered table-sm'>");
        sb.Append("<tbody>");
        for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        {
            sb.Append("<tr strId='" + Ds.Tables[0].Rows[i]["SBDID"].ToString() + "'>");
            sb.Append("<td><input type='checkbox' iden='SBD' onclick='fnSelectSBD(this);'/></td>");
            sb.Append("<td>" + Ds.Tables[0].Rows[i]["channel"].ToString() + "</td>");
            sb.Append("<td>" + Ds.Tables[0].Rows[i]["ClusterName"].ToString() + "</td>");
            sb.Append("<td>" + GetBaseSBFlst(Ds.Tables[0].Rows[i]["SBDID"].ToString(), Ds, flgSBF) + "</td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        sb.Append("</div>");

        return sb.ToString();


        //----------------------------------------------------------------------------------------------------------------------------------//

        //for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
        //{
        //    sb.Append("<div class='clsSBD-block'>");
        //    sb.Append("<div class='clsSBD' strId='" + Ds.Tables[0].Rows[i]["SBDID"].ToString() + "' class='clsBaseSBF'>");
        //    if (flgSBF == "1")
        //    {
        //        sb.Append("<i class='fa fa-plus-square' flgVisible='0' onclick='fnCollapseExpand(this);'></i>");
        //        sb.Append("<input type='checkbox' iden='SBD' onclick='fnSelectSBD(this);'/>");
        //        sb.Append(Ds.Tables[0].Rows[i]["SBD Name"].ToString());
        //        sb.Append("</div>");
        //        sb.Append("<div class='clsBaseSBF-block row' style='display: none;'>");
        //    }
        //    else
        //    {
        //        sb.Append("<i class='fa fa-minus-square' flgVisible='1' onclick='fnCollapseExpand(this);'></i>");
        //        sb.Append(Ds.Tables[0].Rows[i]["SBD Name"].ToString());
        //        sb.Append("</div>");
        //        sb.Append("<div class='clsBaseSBF-block row'>");
        //    }
        //    sb.Append(GetBaseSBFlst(Ds.Tables[0].Rows[i]["SBDID"].ToString(), Ds, flgSBF));
        //    sb.Append("</div>");
        //    sb.Append("</div>");
        //}
        //return sb.ToString();
    }
    private static string GetBaseSBFlst(string SBDID, DataSet Ds, string flgSBF)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dttemp = Ds.Tables[1].Select("SBDID=" + SBDID).CopyToDataTable();
        for (int i = 0; i < dttemp.Rows.Count; i++)
        {
            sb.Append("<div class='clsBaseSBF' BaseSBFID='" + dttemp.Rows[i]["BaseNodeID"].ToString() + "' strId='" + dttemp.Rows[i]["SBDBaseSBFID"].ToString() + "' strType='" + dttemp.Rows[i]["BaseNodeType"].ToString() + "'>");

            if (flgSBF != "1")            
                sb.Append("<input type='checkbox' iden='BaseSBF' onclick='fnSelectBaseSBF(this);'/>");

            sb.Append("<span class='clsInform' title='" + GetProxySBFlst(SBDID, dttemp.Rows[i]["SBDBaseSBFID"].ToString(), Ds.Tables[2]) + "'>" + dttemp.Rows[i]["BaseSBF"].ToString() + "</span>");
            sb.Append("</div>");
        }
        return sb.ToString();

        //--------------------------------------------------------------------------------------------------------------------------------//

        //int Cell_Index = 0;
        //int rows = (dttemp.Rows.Count % 4) == 0 ? (dttemp.Rows.Count / 4) : (dttemp.Rows.Count / 4) + 1;
        //for (int i = 0; i < rows; i++)
        //{
        //    for (int j = 0; j < 4; j++)
        //    {
        //        Cell_Index = (rows * j) + i;
        //        if (Cell_Index > (dttemp.Rows.Count - 1))
        //        {
        //            sb.Append("<div class='clsBaseSBF'>&nbsp;</div>");
        //        }
        //        else
        //        {
        //            sb.Append("<div class='clsBaseSBF' BaseSBFID='" + dttemp.Rows[Cell_Index]["BaseNodeID"].ToString() + "' strId='" + dttemp.Rows[Cell_Index]["SBDBaseSBFID"].ToString() + "' strType='" + dttemp.Rows[Cell_Index]["BaseNodeType"].ToString() + "'>");
        //            if (flgSBF == "1")
        //            {
        //                //sb.Append((i + 1).ToString() + ".  ");
        //            }
        //            else
        //                sb.Append("<input type='checkbox' iden='BaseSBF' onclick='fnSelectBaseSBF(this);'/>");

        //            sb.Append("<span class='clsInform' title='" + GetProxySBFlst(SBDID, dttemp.Rows[Cell_Index]["SBDBaseSBFID"].ToString(), Ds.Tables[2]) + "'>" + dttemp.Rows[Cell_Index]["BaseSBF"].ToString() + "</span>");
        //            sb.Append("</div>");
        //        }
        //    }
        //}
        //return sb.ToString();
    }
    private static string GetProxySBFlst(string SBDID, string SBDBaseSBFID, DataTable dt)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dttemp = dt.Select("SBDID=" + SBDID + " And SBDBaseSBFID=" + SBDBaseSBFID).CopyToDataTable();

        for (int i = 0; i < dttemp.Rows.Count; i++)
        {
            sb.Append(", " + dttemp.Rows[i]["ProxySBF"].ToString());
        }
        return sb.ToString().Substring(2);
    }

    [System.Web.Services.WebMethod()]
    public static string fnAddRemoveSBF(string SBFNodeID, string SBFNodeType, string LoginID, string RoleID, string UserID, string flgPage, string flgSBF, object objSelected, object objProxy)
    {
        try
        {
            string strSelected = JsonConvert.SerializeObject(objSelected, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblSelected = JsonConvert.DeserializeObject<DataTable>(strSelected);
            if (tblSelected.Rows[0][0].ToString() == "0")
            {
                tblSelected.Rows.RemoveAt(0);
            }

            DataTable tblLoc = new DataTable();
            string strProxy = JsonConvert.SerializeObject(objProxy, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblProxy = JsonConvert.DeserializeObject<DataTable>(strProxy);
            if (tblProxy.Rows[0][0].ToString() == "0")
            {
                tblProxy.Rows.RemoveAt(0);
            }

            DataSet ds = new DataSet();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "[spSBDAddRemoveSBFFromNorm]";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            Scmd.Parameters.AddWithValue("@SBFNodeID", SBFNodeID);
            Scmd.Parameters.AddWithValue("@SBFNodeType", SBFNodeType);
            Scmd.Parameters.AddWithValue("@IDs", tblSelected);
            Scmd.Parameters.AddWithValue("@SBF", tblProxy);
            Scmd.Parameters.AddWithValue("@flgBaseProxy", flgSBF);
            Scmd.Parameters.AddWithValue("@flgAddDelete", flgPage);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            Sdap.Fill(ds);

            if (ds.Tables[0].Rows[0][0].ToString() == "1")
                return "0|^|";
            else if (Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString()) == -2)
            {
                StringBuilder sb = new StringBuilder();
                if (ds.Tables[1].Rows.Count > 0)
                {
                    sb.Append("Selected SBF, used as a replacement of Removing Base SBF is already used in given SBD(s) : ");
                    sb.Append("<table class='table table-striped table-bordered table-sm' style='margin-top: 6px;'>");
                    sb.Append("<thead>");
                    sb.Append("<tr>");
                    sb.Append("<th>#</th>");
                    for (int j = 0; j < ds.Tables[1].Columns.Count; j++)
                    {
                        sb.Append("<th>" + ds.Tables[1].Columns[j].ColumnName.ToString() + "</th>");
                    }
                    sb.Append("</tr>");
                    sb.Append("</thead>");
                    sb.Append("<tbody>");
                    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td>" + (i + 1).ToString() + "</td>");
                        for (int j = 0; j < ds.Tables[1].Columns.Count; j++)
                        {
                            sb.Append("<td>" + ds.Tables[1].Rows[i][j] + "</td>");
                        }
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody>");
                    sb.Append("</table>");
                    sb.Append("Plz select a New SBF for replacement .");
                }

                return "2|^|" + sb.ToString();
            }
            else
                return "1|^|";
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
}