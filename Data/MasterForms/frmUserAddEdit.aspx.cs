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

public partial class MasterForms_frmUserAddEdit : System.Web.UI.Page
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
        for (int i = 0; Ds.Tables[0].Rows.Count - 2 > i; i++)
        {
            if (i != 0)
                sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,1);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,1);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
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
        for (int i = 0; Ds.Tables[0].Rows.Count - 1 > i; i++)
        {
            if (i != 0)
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,2);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,2);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
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
        for (int i = 0; Ds.Tables[0].Rows.Count - 1 > i; i++)
        {
            if (i != 0)
                sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,3);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            else
                sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnProdLvl(this,3);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbChannelLvl.Append("</table>");
        hdnChannelLvl.Value = sbChannelLvl.ToString();


        //------- Bucket Type
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
        // TabHead.InnerHtml = sbBucketType.ToString();

        //  hdnBrand.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "20", "2", "");
        // hdnBrandForm.Value = fnProdHier(hdnLoginID.Value, hdnUserID.Value, hdnRoleID.Value, hdnNodeID.Value, hdnNodeType.Value, "30", "2", "");


        //------- ROLE Type
        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spRoleGetRoles";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbRoleType = new StringBuilder();
        //        ddlbucketType.Items.Add(new ListItem("--Select--", "0"));
        sbRoleType.Append("<option value='0'>--select--</option>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbRoleType.Append("<option value='" + Ds.Tables[0].Rows[i]["RoleId"].ToString() + "'>" + Ds.Tables[0].Rows[i]["RoleName"].ToString() + "</option>");
            //   ddlbucketType.Items.Add(new ListItem(Ds.Tables[0].Rows[i]["BucketType"].ToString(), Ds.Tables[0].Rows[i]["BucketTypeID"].ToString()));
        }
        hdnMainRoleID.Value = sbRoleType.ToString();


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
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this,1);' /></th>");
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
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this,1);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='0' bf='0' sbf='0' nid='" + dt.Rows[i]["CatNodeID"] + "' ntype='" + dt.Rows[i]["CatNodeType"] + "'>");
                    break;
                case "20":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this,1);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='0' sbf='0' nid='" + dt.Rows[i]["BrnNodeID"] + "' ntype='" + dt.Rows[i]["BrnNodeType"] + "'>");
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
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this,2);' /></th>");
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
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this, 2);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='0' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["CountryNodeID"] + "' ntype='" + dt.Rows[i]["CountryNodeType"] + "'>");
                    break;
                case "110":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this, 2);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='0' dbr='0' branch='0' nid='" + dt.Rows[i]["RegionNodeID"] + "' ntype='" + dt.Rows[i]["RegionNodeType"] + "'>");
                    break;
                case "120":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this, 2);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='0' branch='0' nid='" + dt.Rows[i]["SiteNodeID"] + "' ntype='" + dt.Rows[i]["SiteNodeType"] + "'>");
                    break;
                case "130":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this, 2);' flg='0' flgVisible='1' cntry='" + dt.Rows[i]["CountryNodeID"] + "' reg='" + dt.Rows[i]["RegionNodeID"] + "' site='" + dt.Rows[i]["SiteNodeID"] + "' dbr='" + dt.Rows[i]["DBRNodeId"] + "' branch='0' nid='" + dt.Rows[i]["DBRNodeId"] + "' ntype='" + dt.Rows[i]["DBRNodeType"] + "'>");
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
        }
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnProdPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'><input id='chkSelectAllProd' type='checkbox' onclick='fnSelectAllProd(this,3);' /></th>");
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
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this,3);' flg='0' flgVisible='1' cls='" + dt.Rows[i]["ClassID"] + "' channel='0' storetype='0' nid='" + dt.Rows[i]["ClassID"] + "' ntype='" + dt.Rows[i]["ClassNodeType"] + "'>");
                    break;
                case "210":
                    sb.Append("<tr onclick='fnSelectUnSelectProd(this,3);' flg='0' flgVisible='1' cls='" + dt.Rows[i]["ClassID"] + "' channel='" + dt.Rows[i]["ChannelID"] + "' storetype='0' nid='" + dt.Rows[i]["ChannelID"] + "' ntype='" + dt.Rows[i]["ChannelNodeType"] + "'>");
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
        if (BucketType == "1")
        {
            sb.Append("<th style='width:40%;'>Category</th>");
            sb.Append("<th style='width:60%;'>Brand</th>");
        }
        else if (BucketType == "2")
        {
            sb.Append("<th style='width:15%;'>Country</th>");
            sb.Append("<th style='width:20%;'>Region</th>");
            sb.Append("<th style='width:30%;'>Site</th>");
            sb.Append("<th style='width:35%;'>Distributor</th>");
        }
        else
        {
            sb.Append("<th style='width:40%;'>Class</th>");
            sb.Append("<th style='width:60%;'>Channel</th>");
        }
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            switch (dt.Rows[i]["NodeType"].ToString())
            {
                case "10":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='0' bf='0' sbf='0' nid='" + dt.Rows[i]["CatNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>All</td>");
                    break;
                case "20":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrandNodeID"] + "' bf='0' sbf='0' nid='" + dt.Rows[i]["BrandNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Category"] + "</td><td>" + dt.Rows[i]["Brand"] + "</td>");
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
                case "200":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cls='" + dt.Rows[i]["ClassNodeID"] + "' channel='0' storetype='0' nid='" + dt.Rows[i]["ClassNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Class"] + "</td><td>All</td>");
                    break;
                case "210":
                    sb.Append("<tr lvl='" + dt.Rows[i]["NodeType"] + "' cls='" + dt.Rows[i]["ClassNodeID"] + "' channel='" + dt.Rows[i]["ChannelNodeID"] + "' storetype='0' nid='" + dt.Rows[i]["ChannelNodeID"] + "'>");
                    sb.Append("<td>" + dt.Rows[i]["Class"] + "</td><td>" + dt.Rows[i]["Channel"] + "</td>");
                    break;
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnGetTableData(string LoginID)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spUserGetUsers";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[9];
            SkipColumn[0] = "UserID";
            SkipColumn[1] = "RoleId";
            SkipColumn[2] = "TimestampIns";
            SkipColumn[3] = "LoginIDUpd";
            SkipColumn[4] = "TimestampUpd";
            SkipColumn[5] = "strProduct";
            SkipColumn[6] = "strLocation";
            SkipColumn[7] = "strChannel";
            SkipColumn[8] = "strProductExtra";
            return "0|^|" + CreateMstrTbl(Ds, SkipColumn, "tblReport", "clsReport");
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    private static string CreateMstrTbl(DataSet Ds, string[] SkipColumn, string tblname, string cls)
    {
        DataTable dt = Ds.Tables[0];
        DataTable dtCursorData = Ds.Tables[1];

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
                if (dt.Columns[j].ColumnName.ToString().Trim() == "Product Access")
                    sb.Append("<th>Primary Product Access</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "Product Access Extra")
                    sb.Append("<th>Secondary Product Access</th>");
                else if (dt.Columns[j].ColumnName.ToString().Trim() == "MSMPAlies")
                    sb.Append("<th>MS&amp;P ALIAS</th>");
                else
                    sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            }
        }
        sb.Append("<th>Edit</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sbDescr.Clear();
            sb.Append("<tr UserID='" + dt.Rows[i]["UserID"] + "' Name='" + dt.Rows[i]["Name"] + "'  EmailID='" + dt.Rows[i]["Email ID"] + "' Active='" + dt.Rows[i]["Active"] + "' Role='" + dt.Rows[i]["Role"] + "' RoleId='" + dt.Rows[i]["RoleId"] + "' CorpUser='" + dt.Rows[i]["Corp User"] + "' Prodstr='" + dt.Rows[i]["Product Access"] + "' Prodselstr='" + dt.Rows[i]["strProduct"] + "' Locationstr='" + dt.Rows[i]["Location Access"] + "' Locationselstr='" + dt.Rows[i]["strLocation"] + "' Channelstr='" + dt.Rows[i]["Channel Access"] + "' Channelselstr='" + dt.Rows[i]["strChannel"] + "' ExtraProdstr='" + dt.Rows[i]["Product Access Extra"] + "' ExtraProdselstr='" + dt.Rows[i]["strProductExtra"] + "' MSMPAlies='" + dt.Rows[i]["MSMPAlies"] + "'>");
            sb.Append("<td>" + (i + 1).ToString() + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                    if (dt.Columns[j].ColumnName.ToString() == "Product Access")
                    {
                        if (dtCursorData.Select("UserID=" + dt.Rows[i]["UserID"].ToString() + " And HierTypeId=1").Length > 0)
                        {
                            sb.Append("<td><span title='" + customTooltip(dt.Rows[i]["UserID"].ToString(), "1", dtCursorData) + "' class='clsInform'>" + dt.Rows[i][j] + "</span></td>");
                        }
                        else
                        {
                            sb.Append("<td><span>" + dt.Rows[i][j] + "</span></td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Location Access")
                    {
                        if (dtCursorData.Select("UserID=" + dt.Rows[i]["UserID"].ToString() + " And HierTypeId=2").Length > 0)
                        {
                            sb.Append("<td><span title='" + customTooltip(dt.Rows[i]["UserID"].ToString(), "2", dtCursorData) + "' class='clsInform'>" + dt.Rows[i][j] + "</span></td>");
                        }
                        else
                        {
                            sb.Append("<td><span>" + dt.Rows[i][j] + "</span></td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Channel Access")
                    {
                        if (dtCursorData.Select("UserID=" + dt.Rows[i]["UserID"].ToString() + " And HierTypeId=3").Length > 0)
                        {
                            sb.Append("<td><span title='" + customTooltip(dt.Rows[i]["UserID"].ToString(), "3", dtCursorData) + "' class='clsInform'>" + dt.Rows[i][j] + "</span></td>");
                        }
                        else
                        {
                            sb.Append("<td><span>" + dt.Rows[i][j] + "</span></td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Product Access Extra")
                    {
                        if (Ds.Tables[2].Select("UserID=" + dt.Rows[i]["UserID"].ToString() + " And HierTypeId=4").Length > 0)
                        {
                            sb.Append("<td><span title='" + customTooltip(dt.Rows[i]["UserID"].ToString(), "4", Ds.Tables[2]) + "' class='clsInform'>" + dt.Rows[i][j] + "</span></td>");
                        }
                        else
                        {
                            sb.Append("<td><span>" + dt.Rows[i][j] + "</span></td>");
                        }
                    }
                    else if (dt.Columns[j].ColumnName.ToString() == "Corp User")
                    {
                        if (dt.Rows[i]["Corp User"].ToString() == "0")
                        {
                            sb.Append("<td>No</td>");
                        }
                        else
                        {
                            sb.Append("<td>Yes</td>");
                        }
                    }
                    else
                    {
                        sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                    }
                }
            }
            sb.Append("<td title='Edit User Details'><img src='../../Images/edit.png' onclick='fnEdit(this);'/></td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string customTooltip(string UserId, string HierId, DataTable dtCursorData)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = dtCursorData.Select("UserID=" + UserId + " And HierTypeId=" + HierId).CopyToDataTable();

        int cntr = 0;
        string strLevel = "";
        DataTable dtDistinctNodeType = dt.DefaultView.ToTable(true, "NodeType");
        for (int i = 0; i < dtDistinctNodeType.Rows.Count; i++)
        {
            switch (dtDistinctNodeType.Rows[i]["NodeType"].ToString())
            {
                case "10":
                    strLevel = "Category";
                    break;
                case "20":
                    strLevel = "Brand";
                    break;
                case "100":
                    strLevel = "Country";
                    break;
                case "110":
                    strLevel = "Region";
                    break;
                case "120":
                    strLevel = "Site";
                    break;
                case "130":
                    strLevel = "Distributor";
                    break;
                case "200":
                    strLevel = "Class";
                    break;
                case "210":
                    strLevel = "Channel";
                    break;
                default:
                    strLevel = "---";
                    break;
            }
            DataTable dtLevelBased = dt.Select("NodeType=" + dtDistinctNodeType.Rows[i]["NodeType"].ToString()).CopyToDataTable();

            sb.Append("<div>Selection Level :");
            sb.Append("<span>"+ strLevel + "</span>");
            sb.Append("</div>");

            sb.Append("<table>");
            sb.Append("<thead><tr>");
            switch (dtLevelBased.Rows.Count)
            {
                case 1:
                    sb.Append("<th>" + strLevel + "</th>");
                    break;
                case 2:
                    sb.Append("<th>" + strLevel + "</th><th>" + strLevel + "</th>");
                    break;
                default:
                    sb.Append("<th>" + strLevel + "</th><th>" + strLevel + "</th><th>" + strLevel + "</th>");
                    break;
            }

            sb.Append("</tr></thead>");
            sb.Append("<tbody>");
            sb.Append("<tr>");
            for (int j = 0; j < dtLevelBased.Rows.Count; j++) {
                sb.Append("<td>" + dtLevelBased.Rows[j]["Descr"].ToString() + "</td>");
                cntr++;

                if (cntr > 2)
                {
                    cntr = 0;
                    sb.Append("</tr><tr>");
                }
            }
            sb.Append("</tr>");
            sb.Append("</tbody>");
            sb.Append("</table>");
        }

        return sb.ToString();
    }
    private static string customTooltipforProd(string UserId, string HierId, DataTable dtCursorData)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        DataRow[] dr = dtCursorData.Select("UserID=" + UserId + " And HierTypeId=" + HierId);

        if (dr.Length > 0)
        {
            dt = dr.CopyToDataTable();
        }

        string NodeType = dt.Rows[0]["NodeType"].ToString();

        sb.Append("<div>Selection Level :");
        if (NodeType == "10")
        {
            sb.Append("<span>Category</span>");
        }
        else if (NodeType == "20")
        {
            sb.Append("<th>Brand</th>");
        }
        else
        {   
            sb.Append("<th>All</th>");
        }

        sb.Append("</div>");

        sb.Append("<table>");
        sb.Append("<thead>");
        sb.Append("<tr>");

        if (NodeType == "10")
        {
            sb.Append("<th>Category</th>");
        }
        else if (NodeType == "20")
        {
            sb.Append("<th>Brand</th>");
        }

        else
        {
            sb.Append("<th>All</th>");
        }
        sb.Append("</tr>");
        sb.Append("</thead>");


        //add rows
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
                if (dt.Columns[j].ColumnName.ToString() == "Descr")
                {
                    sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");

        return sb.ToString();

    }
    private static string customTooltipforLocation(string UserId, string HierId, DataTable dtCursorData)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        DataRow[] dr = dtCursorData.Select("UserID=" + UserId + " And HierTypeId=" + HierId);

        if (dr.Length > 0)
        {
            dt = dr.CopyToDataTable();
        }

        string NodeType = dt.Rows[0]["NodeType"].ToString();

        sb.Append("<div>Selection Level :");
        if (NodeType == "130")
        {
            sb.Append("<span>Distributor</span>");
        }
        else if (NodeType == "140")
        {
            sb.Append("<span>Branch</span>");
        }
        else
        {
            sb.Append("<span>All</span>");
        }

        sb.Append("</div>");


        sb.Append("<table>");
        sb.Append("<thead>");
        //add header row
        sb.Append("<tr>");

        if (NodeType == "130")
        {
            sb.Append("<th>Distributor</th>");
        }
        else if (NodeType == "140")
        {
            sb.Append("<th>Branch</th>");
        }
        else
        {
            sb.Append("<th>All</th>");
        }
        sb.Append("</tr>");
        sb.Append("</thead>");


        //add rows
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
                if (dt.Columns[j].ColumnName.ToString() == "Descr")
                {
                    sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");

        return sb.ToString();

    }
    private static string customTooltipforChannel(string UserId, string HierId, DataTable dtCursorData)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        DataRow[] dr = dtCursorData.Select("UserID=" + UserId + " And HierTypeId=" + HierId);

        if (dr.Length > 0)
        {
            dt = dr.CopyToDataTable();

            string NodeType = dt.Rows[0]["NodeType"].ToString();

            sb.Append("<div>Selection Level :");
            if (NodeType == "200")
            {
                sb.Append("<span>Class</span>");
            }
            else if (NodeType == "210")
            {
                sb.Append("<span>Channel</span>");
            }
            else
            {
                sb.Append("<span>All</span>");
            }

            sb.Append("</div>");

            sb.Append("<table>");
            sb.Append("<thead>");
            //add header row
            sb.Append("<tr>");

            if (NodeType == "200")
            {
                sb.Append("<th>Class</th>");
            }
            else if (NodeType == "210")
            {
                sb.Append("<th>Channel</th>");
            }
            else
            {
                sb.Append("<th>All</th>");
            }
            sb.Append("</tr>");
            sb.Append("</thead>");


            //add rows
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sb.Append("<tr>");
                for (int j = 0; j < dt.Columns.Count; j++)
                    if (dt.Columns[j].ColumnName.ToString() == "Descr")
                    {
                        sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
                    }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        return sb.ToString();

    }

    [System.Web.Services.WebMethod()]
    public static string fnSave(string LoginID, string UserID, string Name, string EmailID, string Status, string Role, object obj, string CorpUser, string strProduct, string strLocation, string strChannel, object objExtraProd, string strExtraProduct, string MSMPAlies)
    {
        DataTable tbl = new DataTable();
        string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        tbl = JsonConvert.DeserializeObject<DataTable>(str);

        DataTable tblExtraProd = new DataTable();
        string strExtraProd = JsonConvert.SerializeObject(objExtraProd, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        tblExtraProd = JsonConvert.DeserializeObject<DataTable>(strExtraProd);
        if(tblExtraProd.Rows[0][2].ToString() == "0")
        {
            tblExtraProd.Rows.RemoveAt(0);
        }

        try
        {
            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spUserSaveUsers";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@userID", UserID);
            Scmd.Parameters.AddWithValue("@EmpName", Name);
            Scmd.Parameters.AddWithValue("@Designation", "");
            Scmd.Parameters.AddWithValue("@EmpCode", "");
            Scmd.Parameters.AddWithValue("@PersonEmailID", EmailID);
            Scmd.Parameters.AddWithValue("@PersonPhone", "");
            Scmd.Parameters.AddWithValue("@flgActive", Status);
            Scmd.Parameters.AddWithValue("@RoleID", Role);
            Scmd.Parameters.AddWithValue("@ApplicableLvls", tbl);
            Scmd.Parameters.AddWithValue("@flgcorporateUser", CorpUser);
            Scmd.Parameters.AddWithValue("@strProduct", strProduct);
            Scmd.Parameters.AddWithValue("@strLocation", strLocation);
            Scmd.Parameters.AddWithValue("@strChannel", strChannel);
            Scmd.Parameters.AddWithValue("@ApplicableLvlsExtra", tblExtraProd);
            Scmd.Parameters.AddWithValue("@MSMPAlies", MSMPAlies);
            Scmd.Parameters.AddWithValue("@strExtraProduct", strExtraProduct);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) == -1)
            {
                return "-1|^|";
            }
            else if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) == -2)
            {
                return "-2|^|";
            }
            else
            {
                return "-3|^|";
            }
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
}