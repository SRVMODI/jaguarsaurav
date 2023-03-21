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

public partial class SWB : System.Web.UI.Page
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
                GetLastDate();
            }
        }
    }
    private void GetMaster()
    {
        //------- Product Lvl -----------------------------------------------
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
            if (Ds.Tables[0].Rows[i]["NodeType"].ToString() == "40")
                sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");

            //if (i != 0)
            //    sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            //else
            //    sbProductLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbProductLvl.Append("</table>");
        hdnProductLvl.Value = sbProductLvl.ToString();


        //------- Location Lvl ---------------------------------------------
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
            if (Ds.Tables[0].Rows[i]["NodeType"].ToString() == "120")
                sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");            

            //if (i != 0)
            //    sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'><img src='../../Images/Down-Right-Arrow.png'/>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            //else
            //    sbLocationLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbLocationLvl.Append("</table>");
        hdnLocationLvl.Value = sbLocationLvl.ToString();


        //------- Channel Lvl ------------------------------------------------
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
            if (Ds.Tables[0].Rows[i]["NodeType"].ToString() == "210")
                sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");

            //if (i != 0)
            //    sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'><img src='../../Images/Down-Right-Arrow.png' />" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
            //else
            //    sbChannelLvl.Append("<tr><td ntype='" + Ds.Tables[0].Rows[i]["NodeType"].ToString() + "' onclick='fnBucketLvl(this);'>" + Ds.Tables[0].Rows[i]["lvl"].ToString() + "</td></tr>");
        }
        sbChannelLvl.Append("</table>");
        hdnChannelLvl.Value = sbChannelLvl.ToString();


        //------- Months -----------------------------------------
        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spSWPGetMonthswithCM";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        bool isSelected = true;
        ListItem itm = new ListItem();
        foreach (DataRow dr in Ds.Tables[0].Rows)
        {
            itm = new ListItem();
            itm.Text = dr["Month"].ToString();
            itm.Value = dr["MonthVal"].ToString() + "|" + dr["YEarVal"].ToString() + "|" + dr["flgAddNew"].ToString();
            ddlMonth.Items.Add(itm);
            if (dr["flgSelect"].ToString() == "1" && isSelected)
            {
                itm.Selected = true;
                isSelected = false;
            }
        }

        isSelected = true;
        ListItem itmImport = new ListItem();
        foreach (DataRow dr in Ds.Tables[0].Rows)
        {
            itmImport = new ListItem();
            itmImport.Text = dr["Month"].ToString();
            itmImport.Value = dr["MonthVal"].ToString() + "|" + dr["YEarVal"].ToString();
            ddlImportMonth.Items.Add(itmImport);
            if (dr["flgSelect"].ToString() == "1" && isSelected)
            {
                itmImport.Selected = true;
                isSelected = false;
            }
        }
    }
    private void GetLastDate()
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spSWPGetMOnthForDisclaimer";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.Parameters.AddWithValue("@RoleID", hdnRoleID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        lblLastDate.Text = Ds.Tables[0].Rows[0][0].ToString();
    }



    [System.Web.Services.WebMethod()]
    public static string fnGetHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string BucketType, string BucketLvl, object obj)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;

            if (BucketType == "1")
                Scmd.CommandText = "spGetPrdHierachyInTableFormat";
            else if (BucketType == "2")
                Scmd.CommandText = "spGetLocHierachyInTableFormat";
            else
                Scmd.CommandText = "spGetChannelHierachyInTableFormat";

            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@UserNodeID", UserNodeID);
            Scmd.Parameters.AddWithValue("@UserNodeType", UserNodeType);
            Scmd.Parameters.AddWithValue("@ProdLvl", BucketLvl);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            StringBuilder sb = new StringBuilder();
            if (BucketType == "1")
            {
                sb.Append("0|^|" + GetSBFTbl(Ds.Tables[0]) + "|^|");
                //sb.Append("0|^|" + GetProdTbl(Ds.Tables[0], BucketLvl) + "|^|");
            }
            else if (BucketType == "2")
                sb.Append("0|^|" + GetLocationTbl(Ds.Tables[0], BucketLvl) + "|^|");
            else
                sb.Append("0|^|" + GetChannelTbl(Ds.Tables[0], BucketLvl) + "|^|");


            if (BucketType != "1")
            {
                string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
                DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);
                if (tbl.Rows.Count > 0)
                    sb.Append(GetSelHierTbl(obj, BucketType));
            }

            return sb.ToString();
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string GetSBFTbl(DataTable dt)
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
        sb.Append("<th colspan='5'>");
        sb.Append("<input type='text' class='form-control form-control-sm' onkeyup='fnSBFPriorityPopuptypefilter(this);' placeholder='Type atleast 3 character to filter...'/>");
        sb.Append("</th>");
        sb.Append("</tr>");

        sb.Append("<tr>");
        sb.Append("<th style='width: 30px;'></th>");
        sb.Append("<th style='display: none;'>SearchString</th>");
        for (int j = 0; j < dt.Columns.Count; j++)
            if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");

        sb.Append("</tr>");

        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr onclick='fnSelectUnSelectSBF(this);' flg='0' flgVisible='1' cat='" + dt.Rows[i]["CatNodeID"] + "' brand='" + dt.Rows[i]["BrnNodeID"] + "' bf='" + dt.Rows[i]["BFNodeID"] + "' sbf='" + dt.Rows[i]["SBFNodeId"] + "' nid='" + dt.Rows[i]["SBFNodeId"] + "' ntype='" + dt.Rows[i]["SBFNodeType"] + "'>");
            sb.Append("<td><img src='../../Images/checkbox-unchecked.png'/></td>");

            sb.Append("<td style='display: none;'>" + dt.Rows[i]["SearchString"] + "</td>");
            for (int j = 0; j < dt.Columns.Count; j++)
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
                    sb.Append("<td class='clss-" + j + "'>" + dt.Rows[i][j] + "</td>");

            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
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
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
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
    public static string GetSelHierTbl(object obj, string BucketType)
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
            sb.Append("<th style='width:20%;'>Category</th>");
            sb.Append("<th style='width:25%;'>Brand</th>");
            sb.Append("<th style='width:25%;'>BrandForm</th>");
            sb.Append("<th style='width:30%;'>SubBrandForm</th>");
        }
        else if (BucketType == "2")
        {
            sb.Append("<th style='width:15%;'>Country</th>");
            sb.Append("<th style='width:20%;'>Region</th>");
            sb.Append("<th style='width:25%;'>Site</th>");
            sb.Append("<th style='width:40%;'>Distributor</th>");
        }
        else
        {
            sb.Append("<th style='width:40%;'>Class</th>");
            sb.Append("<th style='width:60%;'>Channel</th>");
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
            sb.Append("<tr onclick='fnSelectUnSelectBucket(this);' flg='0' flgVisible='1' BucketID='" + dt.Rows[i]["BucketID"] + "' StrValue='" + dt.Rows[i]["StrValue"] + "'>");
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
    public static string fnGetReport(string UserID, string LoginID, string RoleID, string MonthVal, string YearVal, string flgCall)
    {
        //flgCall - 1: Main Page, 2: Import Popup
        try
        {
            StringBuilder sbTimeChecker = new StringBuilder();
            sbTimeChecker.Append("SP Caliing Start : " + DateTime.Now.ToLongTimeString());

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPGetNorms";
            Scmd.Parameters.AddWithValue("@USerID", UserID);
            Scmd.Parameters.AddWithValue("@LOginID", LoginID);
            //Scmd.Parameters.AddWithValue("@ROleID", RoleID);
            Scmd.Parameters.AddWithValue("@MonthVal", MonthVal);
            Scmd.Parameters.AddWithValue("@YearVal", YearVal);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            sbTimeChecker.Append("<br/>SP Caliing End : " + DateTime.Now.ToLongTimeString());

            if(flgCall == "1")
                return "0|^|" + CreateSitePriorityTbl(Ds, "Report", flgCall) + "|^|" + CreateBtns(Ds.Tables[4]);
            else
                return "0|^|" + CreateSitePriorityTbl(Ds, "ImportSBF", flgCall);
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string CreateSitePriorityTbl(DataSet Ds, string RptName, string flgCall)
    {
        //flgCall - 1: Main Page, 2: Import Popup

        string[] SkipColumn = new string[0];
        //SkipColumn[0] = "INITID";

        StringBuilder sb = new StringBuilder();
        sb.Append("<table id='tbl" + RptName + "' class='table table-bordered table-sm cls-tbl-" + RptName + " w-100'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        if (flgCall == "1")
            sb.Append("<th></th>");
        else
            sb.Append("<th><input id='chkImportAll' type='checkbox' onclick='fnImportChkUnchkAll();'/></th>");
        sb.Append("<th>Location</th>");
        sb.Append("<th>Channel</th>");
        sb.Append("<th>SBF</th>");
        if(flgCall == "1")
            sb.Append("<th>Action</th>");
        sb.Append("<th style='display: none;'>SearchText</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");

        sb.Append("<tbody>");
        if (Ds.Tables[0].Rows.Count > 0)
        {
            StringBuilder sbLocation = new StringBuilder();
            StringBuilder sbChannel = new StringBuilder();
            StringBuilder sbSBF = new StringBuilder();

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                sbLocation.Clear();
                sbLocation.Append(GetSitePrioritywiseLocation(Ds.Tables[0].Rows[i]["SWPNormID"].ToString(), Ds.Tables[1]));
                sbChannel.Clear();
                sbChannel.Append(GetSitePrioritywiseChannel(Ds.Tables[0].Rows[i]["SWPNormID"].ToString(), Ds.Tables[2]));
                sbSBF.Clear();
                sbSBF.Append(GetSitePrioritywiseSBF(Ds.Tables[0].Rows[i]["SWPNormID"].ToString(), Ds.Tables[3]));

                sb.Append("<tr iden='sitepriority' strId='" + Ds.Tables[0].Rows[i]["SWPNormID"] + "' flgEdit='0'>");

                if (flgCall == "1")
                {
                    if (Ds.Tables[0].Rows[i]["flgEdit"].ToString() == "1")
                        sb.Append("<td iden='sitepriority'><input type='checkbox' onclick='fnChkIndividual(this);'/></td>");
                    else
                        sb.Append("<td iden='sitepriority'></td>");
                }
                else
                    sb.Append("<td iden='sitepriority'><input type='checkbox' onclick='fnImportChkIndividual(this);'/></td>");

                sb.Append("<td iden='sitepriority'>");
                sb.Append("<div class='td-container w-100'>");
                sb.Append("<div iden='content' class='td-container-content w-100'>" + sbLocation.ToString().Split('#')[0] + "</div>");
                sb.Append("<div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select Location' iden='btn' buckettype='2' lvl='" + sbLocation.ToString().Split('#')[2] + "' selectedstr='" + sbLocation.ToString().Split('#')[1] + "' onclick='fnShowHierPopup(this, 1);'/></div>");
                sb.Append("</div>");
                sb.Append("</td>");

                sb.Append("<td iden='sitepriority'>");
                sb.Append("<div class='td-container w-100'>");
                sb.Append("<div iden='content' class='td-container-content w-100'>" + sbChannel.ToString().Split('#')[0] + "</div>");
                sb.Append("<div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select Channel' iden='btn' buckettype='3' lvl='" + sbChannel.ToString().Split('#')[2] + "' selectedstr='" + sbChannel.ToString().Split('#')[1] + "' onclick='fnShowHierPopup(this, 1);'/></div>");
                sb.Append("</div>");
                sb.Append("</td>");

                sb.Append("<td iden='sitepriority'>");
                sb.Append("<div class='td-container w-100'>");
                sb.Append("<div iden='content' class='td-container-content w-100'>" + sbSBF.ToString().Split('#')[0] + "</div>");
                sb.Append("<div class='td-container-btn' style='display: none;'><img src='../../Images/edit.png' title='Select Location' iden='btn' buckettype='1' lvl='" + sbSBF.ToString().Split('#')[2] + "' selectedstr='" + sbSBF.ToString().Split('#')[1] + "' onclick='fnShowSBFHierPopup(this, 1);'/></div>");
                sb.Append("</div>");
                sb.Append("</td>");

                if (flgCall == "1")
                {
                    if (Ds.Tables[0].Rows[i]["flgEdit"].ToString() == "1")
                        sb.Append("<td iden='sitepriority' class='cls-td-Action'><img src='../../Images/edit.png' title='Edit' onclick='fnEditCopy(this, 1);'/><img src='../../Images/delete.png' title='Delete' onclick='fnDeleteIndividual(this);'/></td>");
                    else
                        sb.Append("<td iden='sitepriority' class='cls-td-Action'></td>");
                }

                sb.Append("<td iden='sitepriority' style='display: none;'>" + Ds.Tables[0].Rows[i]["strSearch"] + "</td>");
                sb.Append("</tr>");
            }
        }

        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    private static string GetSitePrioritywiseLocation(string strId, DataTable dt)
    {
        int ntype = 0;
        StringBuilder sb = new StringBuilder();
        StringBuilder sbstr = new StringBuilder();

        DataRow[] dr = dt.Select("SWPNormID=" + strId);
        foreach (DataRow row in dr)
        {
            sb.Append(", " + row["Descr"]);
            sbstr.Append("|" + row["LocationHierID"] + "^" + row["LocationNodeType"]);

            if (Convert.ToInt32(row["LocationNodeType"]) > ntype)
                ntype = Convert.ToInt32(row["LocationNodeType"]);
        }

        return sb.ToString().Substring(2) + "#" + sbstr.ToString().Substring(1) + "#" + ntype.ToString();
    }
    private static string GetSitePrioritywiseChannel(string strId, DataTable dt)
    {
        int ntype = 0;
        StringBuilder sb = new StringBuilder();
        StringBuilder sbstr = new StringBuilder();

        DataRow[] dr = dt.Select("SWPNormID=" + strId);
        foreach (DataRow row in dr)
        {
            sb.Append(", " + row["Descr"]);
            sbstr.Append("|" + row["NodeID"] + "^" + row["NodeType"]);

            if (Convert.ToInt32(row["NodeType"]) > ntype)
                ntype = Convert.ToInt32(row["NodeType"]);
        }

        return sb.ToString().Substring(2) + "#" + sbstr.ToString().Substring(1) + "#" + ntype.ToString();
    }
    private static string GetSitePrioritywiseSBF(string strId, DataTable dt)
    {
        int ntype = 0;
        StringBuilder sb = new StringBuilder();
        StringBuilder sbstr = new StringBuilder();

        DataRow[] dr = dt.Select("SWPNormID=" + strId, "SeqNo Asc");
        foreach (DataRow row in dr)
        {
            sb.Append("<div class='cls-div-drag-block-mini cls-div-drag-block-" + row["SeqNo"] + "' nid='" + row["NodeID"] + "' rank='" + row["SeqNo"] + "'><div class='cls-div-drag-count-mini'>" + row["SeqNo"] + "</div><div class='cls-div-drag-content-mini'>" + row["SBF"] + "</div></div>");
            sbstr.Append("|" + row["NodeID"] + "^" + row["NodeType"] + "^" + row["SeqNo"]);

            if (Convert.ToInt32(row["NodeType"]) > ntype)
                ntype = Convert.ToInt32(row["NodeType"]);
        }

        return sb.ToString() + "#" + sbstr.ToString().Substring(1) + "#" + ntype.ToString();
    }

    private static string CreateBtns(DataTable dt)
    {
        StringBuilder sb = new StringBuilder();

        
        sb.Append("<a id='btnSaveMultiple' class='btn btn-primary btn-sm btn-disabled mb-1 mr-2' href='#' title='Save'>Save All Opened</a>");
        sb.Append("<a id='btnDeleteMultiple' class='btn btn-danger btn-sm btn-disabled mb-1 mr-2' href='#' title='Delete'>Delete Selected</a>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<a iden='btn-Action' class='btn btn-danger btn-sm btn-disabled mb-1 mr-2' href='#' ActionType='" + dt.Rows[i]["ButtonID"].ToString() + "' title='" + dt.Rows[i]["ButtonText"].ToString() + "'>" + dt.Rows[i]["ButtonText"].ToString() + "</a>");
        }

        return sb.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnDelete(object objSWPNorm)
    {
        try
        {
            string strSWPNorm = JsonConvert.SerializeObject(objSWPNorm, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblSWPNorm = JsonConvert.DeserializeObject<DataTable>(strSWPNorm);
            if (tblSWPNorm.Rows[0][0].ToString() == "0")
                tblSWPNorm.Rows.RemoveAt(0);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPDeleteNorms";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@SWPIDs", tblSWPNorm);
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

    [System.Web.Services.WebMethod()]
    public static string fnImportSWB(object objSWPNorm, string UserID, string LoginID, string RoleID, string MonthVal, string YearVal)
    {
        try
        {
            string strSWPNorm = JsonConvert.SerializeObject(objSWPNorm, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblSWPNorm = JsonConvert.DeserializeObject<DataTable>(strSWPNorm);
            if (tblSWPNorm.Rows[0][0].ToString() == "0")
                tblSWPNorm.Rows.RemoveAt(0);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPImportNorms";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@SWPIDs", tblSWPNorm);
            Scmd.Parameters.AddWithValue("@MonthVal", MonthVal);
            Scmd.Parameters.AddWithValue("@YearVal", YearVal);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) > -1)
                return "0|^|";
            else
                return "1|^|" + CreateHTMLTbl(Ds.Tables[1], "Error");
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
    [System.Web.Services.WebMethod()]
    public static string fnSave(string LoginID, string UserID, string RoleID, string MonthVal, string YearVal, string SWPNormID, object objLocation, object objChannel, object objSBF, string flgSaveSubmit)
    {
        try
        {
            string strLocation = JsonConvert.SerializeObject(objLocation, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblLocation = JsonConvert.DeserializeObject<DataTable>(strLocation);
            if (tblLocation.Rows[0][0].ToString() == "0")
                tblLocation.Rows.RemoveAt(0);

            string strChannel = JsonConvert.SerializeObject(objChannel, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblChannel = JsonConvert.DeserializeObject<DataTable>(strChannel);
            if (tblChannel.Rows[0][0].ToString() == "0")
                tblChannel.Rows.RemoveAt(0);

            string strSBF = JsonConvert.SerializeObject(objSBF, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblSBF = JsonConvert.DeserializeObject<DataTable>(strSBF);
            if (tblSBF.Rows[0][0].ToString() == "0")
                tblSBF.Rows.RemoveAt(0);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPManageNorms";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@ROleID", RoleID);
            Scmd.Parameters.AddWithValue("@SWPNormID", SWPNormID);
            Scmd.Parameters.AddWithValue("@flgSaveSubmit", flgSaveSubmit);      // 1: Submit; 2: Save - As @Anuj instruction, only using flg = 2.
            Scmd.Parameters.AddWithValue("@MonthVal", MonthVal);
            Scmd.Parameters.AddWithValue("@YearVal", YearVal);
            Scmd.Parameters.AddWithValue("@Channels", tblChannel);
            Scmd.Parameters.AddWithValue("@SBF", tblSBF);
            Scmd.Parameters.AddWithValue("@Location", tblLocation);
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) > -1)
                return "0|^|";
            else
                return "1|^|" + CreateHTMLTbl(Ds.Tables[1], "Error");
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
    private static string CreateHTMLTbl(DataTable dt, string strName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table id='tbl" + strName + "' class='table table-bordered table-sm cls-tbl-" + strName + " w-100'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
        }
        sb.Append("</tr>");
        sb.Append("</thead>");

        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sb.Append("<tr>");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                sb.Append("<td>" + dt.Rows[i][j].ToString() + "</td>");
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnAction(object objSWPNorm, string NodeID, string ActionType, string LoginID, string UserID, string Comments)
    {
        try
        {
            string strSWPNorm = JsonConvert.SerializeObject(objSWPNorm, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tblSWPNorm = JsonConvert.DeserializeObject<DataTable>(strSWPNorm);
            if (tblSWPNorm.Rows[0][0].ToString() == "0")
                tblSWPNorm.Rows.RemoveAt(0);

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spSWPSaveSubmit";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@SWPIDs", tblSWPNorm);
            Scmd.Parameters.AddWithValue("@NodeID", NodeID);
            Scmd.Parameters.AddWithValue("@ButtonID", ActionType);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@Comments", Comments);
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




    // ------------ Not In Use -------------------------------
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