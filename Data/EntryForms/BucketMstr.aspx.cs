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

public partial class _BucketMstr : System.Web.UI.Page
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
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
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

        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spBucketGetBucketType";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbBucketType = new StringBuilder();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i == 0)
            {
                sbBucketType.Append("<li BucketTypeID='" + Ds.Tables[0].Rows[i]["BucketTypeID"].ToString() + "' onclick='fnBucketTypeSel(this);'><a class='nav-link active' href='#'>" + Ds.Tables[0].Rows[i]["BucketType"].ToString() + "</a></li>");
                hdnBucketType.Value = Ds.Tables[0].Rows[i]["BucketTypeID"].ToString();
            }
            else
                sbBucketType.Append("<li BucketTypeID='" + Ds.Tables[0].Rows[i]["BucketTypeID"].ToString() + "' onclick='fnBucketTypeSel(this);'><a class='nav-link' href='#'>" + Ds.Tables[0].Rows[i]["BucketType"].ToString() + "</a></li>");
        }
        TabHead.InnerHtml = sbBucketType.ToString();

        hdnBrand.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "20", "2", "");
        hdnBrandForm.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "30", "2", "");
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

                    return "0|^|" + GetProdTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(DsSelHier.Tables[0], "1", "0");
                }
                else
                    return "0|^|" + GetProdTbl(Ds.Tables[0], ProdLvl) + "|^|";
            }
            else
                return "0|^|" + GetProdTblforNewNode(Ds.Tables[0], ProdLvl) + "|^|";

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
    private static string GetSelHierTbl(DataTable dt, string BucketType, string InSubD)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        if(BucketType == "1") {
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
            sb.Append("<th style='width:50%;'>Class</th>");
            sb.Append("<th style='width:25%;'>Channel</th>");
            sb.Append("<th style='width:25%;'>Store Type</th>");
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
    public static string fnGetReport(string LoginID, string UserID, string BucketType, object objProd, object objInit, string FromDate, string ToDate)
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

            DataTable tblInit = new DataTable();
            string strInit = JsonConvert.SerializeObject(objInit, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            tblInit = JsonConvert.DeserializeObject<DataTable>(strInit);
            if (tblInit.Rows[0][0].ToString() == "0")
            {
                tblInit.Rows.RemoveAt(0);
            }

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spGetBucketInfo";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
            Scmd.Parameters.AddWithValue("@PrdSelection", tblProd);
            Scmd.Parameters.AddWithValue("@INITCodes", tblInit);
            Scmd.Parameters.AddWithValue("@FromDate", FromDate);
            Scmd.Parameters.AddWithValue("@EndDate", ToDate);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[6];
            SkipColumn[0] = "BucketID";
            SkipColumn[1] = "LvlNodeType";
            SkipColumn[2] = "StrValue";
            SkipColumn[3] = "AllProducts";
            SkipColumn[4] = "BucketType";
            SkipColumn[5] = "flgIncludeSubD";
            return "0|^|" + CreateBucketMstrTbl(Ds.Tables[0], SkipColumn, "tblReport", "clsReport");
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string CreateBucketMstrTbl(DataTable dt, string[] SkipColumn, string tblname, string cls)
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
            if (dt.Rows[i]["Description"].ToString().Length > 20)
                sbDescr.Append(dt.Rows[i]["Description"].ToString().Substring(0, 18) + "..");
            else
                sbDescr.Append(dt.Rows[i]["Description"].ToString());

            if(dt.Rows[i]["BucketType"].ToString() == "1")
                sb.Append("<tr Bucket='" + dt.Rows[i]["BucketID"] + "' BucketType='1' Bucketstr='" + dt.Rows[i]["BucketName"] + "' Descr='" + sbDescr.ToString() + "' InSubD='0' Prodstr='" + dt.Rows[i]["Products"] + "' ProdLvl='" + dt.Rows[i]["LvlNodeType"] + "' Prodselstr='" + dt.Rows[i]["StrValue"] + "' flgcopyprod='0'>");
            else if (dt.Rows[i]["BucketType"].ToString() == "2")
                sb.Append("<tr Bucket='" + dt.Rows[i]["BucketID"] + "' BucketType='2' Bucketstr='" + dt.Rows[i]["BucketName"] + "' Descr='" + sbDescr.ToString() + "' InSubD='" + dt.Rows[i]["flgIncludeSubD"] + "' Prodstr='" + dt.Rows[i]["Sites"] + "' ProdLvl='" + dt.Rows[i]["LvlNodeType"] + "' Prodselstr='" + dt.Rows[i]["StrValue"] + "' flgcopyprod='0'>");
            else
                sb.Append("<tr Bucket='" + dt.Rows[i]["BucketID"] + "' BucketType='2' Bucketstr='" + dt.Rows[i]["BucketName"] + "' Descr='" + sbDescr.ToString() + "' InSubD='0' Prodstr='" + dt.Rows[i]["Channels"] + "' ProdLvl='" + dt.Rows[i]["LvlNodeType"] + "' Prodselstr='" + dt.Rows[i]["StrValue"] + "' flgcopyprod='0'>");

            sb.Append("<td>" + (i + 1).ToString() + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                    if (dt.Columns[j].ColumnName.ToString() == "Description")
                        sb.Append("<td title='" + dt.Rows[i][j] + "' class='clsInform'>" + sbDescr.ToString() + "</td>");
                    else if (dt.Columns[j].ColumnName.ToString() == "Products")
                        sb.Append("<td><span title='" + customTooltipforProd(dt.Rows[i]["LvlNodeType"].ToString(), dt.Rows[i]["AllProducts"].ToString()) + "' class='clsInform'>" + dt.Rows[i][j] + "</span><img src='../../Images/copy.png' title='copy' onclick='fncopyprod(this);' style='float: right;'/></td>");
                    else if (dt.Columns[j].ColumnName.ToString() == "Sites")
                        sb.Append("<td><span title='" + customTooltipforSite(dt.Rows[i]["LvlNodeType"].ToString(), dt.Rows[i]["AllProducts"].ToString()) + "' class='clsInform'>" + dt.Rows[i][j] + "</span><img src='../../Images/copy.png' title='copy' onclick='fncopyprod(this);' style='float: right;'/></td>");
                    else if (dt.Columns[j].ColumnName.ToString() == "Channels")
                        sb.Append("<td><span title='" + customTooltipforChannel(dt.Rows[i]["LvlNodeType"].ToString(), dt.Rows[i]["AllProducts"].ToString()) + "' class='clsInform'>" + dt.Rows[i][j] + "</span><img src='../../Images/copy.png' title='copy' onclick='fncopyprod(this);' style='float: right;'/></td>");
                    else
                        sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                }
            }
            sb.Append("<td class='clstdAction'><img src='../../Images/copy.png' title='copy' onclick='fnCopy(this);' style='margin-right: 12px;'/><img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);'/></td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string customTooltipforProd(string Prodlvl, string Prods)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<div>Selection Level :");
        switch (Prodlvl)
        {
            case "10":
                sb.Append("<span>Category</span>");
                break;
            case "20":
                sb.Append("<span>Brand</span>");
                break;
            case "30":
                sb.Append("<span>BrandForm</span>");
                break;
            case "40":
                sb.Append("<span>SubBrandForm</span>");
                break;
        }
        sb.Append("</div>");

        int cntr = 0;
        sb.Append("<table>");
        sb.Append("<thead>");
        switch (Prodlvl)
        {
            case "10":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Category</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Category</th><th>Category</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Category</th><th>Category</th><th>Category</th></tr>");
                }
                break;
            case "20":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Category</th><th>Brand</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Category</th><th>Brand</th><th>Category</th><th>Brand</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Category</th><th>Brand</th><th>Category</th><th>Brand</th><th>Category</th><th>Brand</th></tr>");
                }
                break;
            case "30":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Brand</th><th>BrandForm</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Brand</th><th>BrandForm</th><th>Brand</th><th>BrandForm</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Brand</th><th>BrandForm</th><th>Brand</th><th>BrandForm</th><th>Brand</th><th>BrandForm</th></tr>");
                }
                break;
            case "40":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>BrandForm</th><th>SubBrandForm</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>BrandForm</th><th>SubBrandForm</th><th>BrandForm</th><th>SubBrandForm</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>BrandForm</th><th>SubBrandForm</th><th>BrandForm</th><th>SubBrandForm</th><th>BrandForm</th><th>SubBrandForm</th></tr>");
                }
                break;
        }
        sb.Append("</thead>");

        int rowsperator = 0;
        if (Prods.Split(',').Length < 6)
            rowsperator = 0;
        else if (Prods.Split(',').Length < 11)
            rowsperator = 1;
        else
            rowsperator = 2;

        sb.Append("<tbody>");
        sb.Append("<tr>");
        for (int i = 0; i < Prods.Split(',').Length; i++)
        {
            cntr++;
            switch (Prodlvl)
            {
                case "10":
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
                    if (cntr > rowsperator)
                    {
                        cntr = 0;
                        sb.Append("</tr><tr>");
                    }
                    break;
                default:
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[2] + "</td>");
                    if (cntr > rowsperator)
                    {
                        cntr = 0;
                        sb.Append("</tr><tr>");
                    }
                    break;
            }
        }
        sb.Append("</tr>");
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();

    }
    private static string customTooltipforSite(string Prodlvl, string Prods)
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
        sb.Append(customTooltipforSiteHeader(0, rowsperator, Prods));

        sb.Append("<tbody>");
        sb.Append("<tr>");
        for (int i = 0; i < Prods.Split(',').Length; i++)
        {

            if (locationlvl != Prods.Split(',')[i].Split('$')[0].Trim())
            {
                sb.Append("</tr>");
                sb.Append("</tbody>");
                sb.Append("</table>");
                sb.Append(customTooltipforSiteHeader(i, rowsperator, Prods));
                sb.Append("<tbody>");
                sb.Append("<tr>");
                cntr = 0;
                locationlvl = Prods.Split(',')[i].Split('$')[0].Trim();
            }
            cntr++;
            if (Prods.Split(',')[i].Split('$')[0].Trim() == "Country")
                sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
            else
            {
                sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
                sb.Append("<td>" + Prods.Split(',')[i].Split('$')[2] + "</td>");
            }
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
    private static string customTooltipforChannel(string Prodlvl, string Prods)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<div>Selection Level :");
        switch (Prodlvl)
        {
            case "200":
                sb.Append("<span>Class</span>");
                break;
            case "210":
                sb.Append("<span>Channel</span>");
                break;
            case "220":
                sb.Append("<span>Store Type</span>");
                break;
        }
        sb.Append("</div>");

        int cntr = 0;
        sb.Append("<table>");
        sb.Append("<thead>");
        switch (Prodlvl)
        {
            case "200":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Class</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Class</th><th>Class</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Class</th><th>Class</th><th>Class</th></tr>");
                }
                break;
            case "210":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th><th>Class</th><th>Channel</th></tr>");
                }
                break;
            case "220":
                if (Prods.Split(',').Length < 6)
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th></tr>");
                }
                else if (Prods.Split(',').Length < 11)
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th><th>Channel</th><th>Store Type</th></tr>");
                }
                break;
        }
        sb.Append("</thead>");

        int rowsperator = 0;
        if (Prods.Split(',').Length < 6)
            rowsperator = 0;
        else if (Prods.Split(',').Length < 11)
            rowsperator = 1;
        else
            rowsperator = 2;

        sb.Append("<tbody>");
        sb.Append("<tr>");
        for (int i = 0; i < Prods.Split(',').Length; i++)
        {
            cntr++;
            switch (Prodlvl)
            {
                case "200":
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[2] + "</td>");
                    if (cntr > rowsperator)
                    {
                        cntr = 0;
                        sb.Append("</tr><tr>");
                    }
                    break;
                default:
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[1] + "</td>");
                    sb.Append("<td>" + Prods.Split(',')[i].Split('$')[2] + "</td>");
                    if (cntr > rowsperator)
                    {
                        cntr = 0;
                        sb.Append("</tr><tr>");
                    }
                    break;
            }
        }
        sb.Append("</tr>");
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();

    }
    private static string customTooltipforSiteHeader(int i, int rowsperator, string Prods)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<div>Selection Level :<span>" + Prods.Split(',')[i].Split('$')[0] + "</span></div>");

        sb.Append("<table>");
        sb.Append("<thead>");
        switch (rowsperator)
        {
            case 0:
                if (Prods.Split(',')[i].Split('$')[0].Trim() == "Country")
                {
                    sb.Append("<tr><th>Country</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Region")
                {
                    sb.Append("<tr><th>Country</th><th>Region</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Site")
                {
                    sb.Append("<tr><th>Region</th><th>Site</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th></tr>");
                }
                break;
            case 1:
                if (Prods.Split(',')[i].Split('$')[0].Trim() == "Country")
                {
                    sb.Append("<tr><th>Country</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Region")
                {
                    sb.Append("<tr><th>Country</th><th>Region</th><th>Country</th><th>Region</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Site")
                {
                    sb.Append("<tr><th>Region</th><th>Site</th><th>Region</th><th>Site</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th></tr>");
                }
                break;
            case 2:
                if (Prods.Split(',')[i].Split('$')[0].Trim() == "Country")
                {
                    sb.Append("<tr><th>Country</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Region")
                {
                    sb.Append("<tr><th>Country</th><th>Region</th><th>Country</th><th>Region</th><th>Country</th><th>Region</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Site")
                {
                    sb.Append("<tr><th>Region</th><th>Site</th><th>Region</th><th>Site</th><th>Region</th><th>Site</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Distributor")
                {
                    sb.Append("<tr><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th><th>Site</th><th>Distributor</th></tr>");
                }
                else if (Prods.Split(',')[i].Split('$')[0].Trim() == "Branch")
                {
                    sb.Append("<tr><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th><th>Distributor</th><th>Branch</th></tr>");
                }
                else
                {
                    sb.Append("<tr><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th><th>Branch</th><th>SubD</th></tr>");
                }
                break;
        }
        sb.Append("</thead>");
        return sb.ToString();

    }
    [System.Web.Services.WebMethod()]
    public static string fnGetInitiativelst(string BucketId, string BucketType)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spBucketcheckBucketUsedinINIT";
            Scmd.Parameters.AddWithValue("@BucketID", BucketId);
            Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            StringBuilder sb = new StringBuilder();
            if (Ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("Selected Bucket is already used in following Initiative(s) : ");
                sb.Append("<ul>");
                for (int i=0; i < Ds.Tables[0].Rows.Count; i++)
                {
                    sb.Append("<li strId='" + Ds.Tables[0].Rows[i]["INITID"]  + "' style='color: #5F68BC;'>");
                    sb.Append(Ds.Tables[0].Rows[i]["Recm. Trade Plan"]);
                    sb.Append("</li>");
                }
                sb.Append("</ul>");
                sb.Append("Do you want to reflect the changes in all above Initiative(s) ?");
            }

            return "0|^|" + sb.ToString();
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string BucketID, string BucketName, string BucketDescr, string BucketType, string flgActive, object obj, string LoginID, string PrdLvl, string PrdString, string InSubD, object objINIT)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            string strINIT = JsonConvert.SerializeObject(objINIT, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblINIT = JsonConvert.DeserializeObject<DataTable>(strINIT);
            if(tblINIT.Rows[0][0].ToString() == "0")
            {
                tblINIT.Rows.RemoveAt(0);
            }

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spBucketSaveBucket";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@BucketID", BucketID);
            Scmd.Parameters.AddWithValue("@BucketName", BucketName);
            Scmd.Parameters.AddWithValue("@BucketDescr", BucketDescr);
            Scmd.Parameters.AddWithValue("@flgActive", flgActive);
            Scmd.Parameters.AddWithValue("@BucketTypeID", BucketType);
            Scmd.Parameters.AddWithValue("@BucketValues", tbl);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@PrdLvl", PrdLvl);
            Scmd.Parameters.AddWithValue("@PrdString", PrdString);
            Scmd.Parameters.AddWithValue("@flgIncludeSubD", InSubD);
            Scmd.Parameters.AddWithValue("@INITIDs", tblINIT);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) > -1)
            {
                return "0|^|";
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
    public static string fnSaveNewNode(string ParentId, string ParentType, string Code, string Descr, string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType)
    {
        string NodeType = "40";
        if (ParentType == "20")
            NodeType = "30";

        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spPrdAddBFSBF";
            Scmd.Parameters.AddWithValue("@Code", Code);
            Scmd.Parameters.AddWithValue("@Descr", Descr);
            Scmd.Parameters.AddWithValue("@PNodeID", ParentId);
            Scmd.Parameters.AddWithValue("@PNodeType", ParentType);
            Scmd.Parameters.AddWithValue("@NodeType", NodeType);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            return "0|^|" + Ds.Tables[0].Rows[0][0].ToString() + "^" + NodeType + "|^|" + Descr + fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, NodeType, "2", "");
        }
        catch (Exception ex)
        {
            return "2|^|" + ex.Message;
        }
    }
}