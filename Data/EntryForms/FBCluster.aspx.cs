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

public partial class _FBCluster : System.Web.UI.Page
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
        DataSet Ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);

        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetLocHierLvl";
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

        Ds.Clear();
        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spFBGetFBMatser";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbMonth = new StringBuilder();
        StringBuilder sbPrevMonth = new StringBuilder();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (Ds.Tables[0].Rows[i]["flgSelect"].ToString() == "1")
            {
                sbMonth.Append("<li StartDate='" + Ds.Tables[0].Rows[i]["Start Date"].ToString().Trim() + "' EndDate='" + Ds.Tables[0].Rows[i]["End Date"].ToString().Trim() + "' flgEdit='1' onclick='fnMonth(this);'><a class='nav-link active' href='#'>" + Ds.Tables[0].Rows[i]["Month"].ToString().Trim() + "</a></li>");
                hdnMonth.Value = Ds.Tables[0].Rows[i]["Start Date"].ToString().Trim() + "|" + Ds.Tables[0].Rows[i]["End Date"].ToString().Trim() + "|1";
            }
            else
                sbMonth.Append("<li StartDate='" + Ds.Tables[0].Rows[i]["Start Date"].ToString().Trim() + "' EndDate='" + Ds.Tables[0].Rows[i]["End Date"].ToString().Trim() + "' flgEdit='1' onclick='fnMonth(this);'><a class='nav-link' href='#'>" + Ds.Tables[0].Rows[i]["Month"].ToString().Trim() + "</a></li>");

                sbPrevMonth.Append("<li StartDate='" + Ds.Tables[0].Rows[i]["Start Date"].ToString().Trim() + "' EndDate='" + Ds.Tables[0].Rows[i]["End Date"].ToString().Trim() + "' flgEdit='1' onclick='fnPrevMonth(this);'><a class='nav-link' href='#'>" + Ds.Tables[0].Rows[i]["Month"].ToString().Trim() + "</a></li>");
        }
        TabHead.InnerHtml = sbMonth.ToString();
        PopupTab.InnerHtml = sbPrevMonth.ToString();

        Ds.Tables.RemoveAt(0);
    }


    [System.Web.Services.WebMethod()]
    public static string fnLocationHier(string LoginID, string UserID, string RoleID, string UserNodeID, string UserNodeType, string ProdLvl, string flg, object obj)
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

                return "0|^|" + GetLocationTbl(Ds.Tables[0], ProdLvl) + "|^|" + GetSelHierTbl(DsSelHier.Tables[0], "2");
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
    private static string GetSelHierTbl(DataTable dt, string BucketType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table class='table table-bordered table-sm table-hover'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th style='width:15%;'>Country</th>");
        sb.Append("<th style='width:20%;'>Region</th>");
        sb.Append("<th style='width:20%;'>Site</th>");
        sb.Append("<th style='width:25%;'>Distributor</th>");
        sb.Append("<th style='width:20%;'>Branch</th>");
        sb.Append("</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            switch (dt.Rows[i]["NodeType"].ToString())
            {
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
            }
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }


    [System.Web.Services.WebMethod()]
    public static string fnGetReport(string LoginID, string UserID, string RoleID, string FromDate, string EndDate, string flgEdit)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spFBGetClusterByMonth";
            Scmd.Parameters.AddWithValue("@FromDate", FromDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
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

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "ClusterID";

            return "0|^|" + CreateClusterMstrTbl(Ds.Tables[0].Rows.Count, Ds.Tables[0], Ds.Tables[1], SkipColumn, "tblReport", "clsReport", flgEdit);
        }
        catch (Exception ex)
        {
            return "2|^|" + ex.Message;
        }
    }
    private static string CreateClusterMstrTbl(int RecordCtr, DataTable dt, DataTable dtLoc, string[] SkipColumn, string tblname, string cls, string flgEdit)
    {
        StringBuilder sb = new StringBuilder(); 
        StringBuilder sbLoc = new StringBuilder();
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
        if(flgEdit == "1")
            sb.Append("<th>Action</th>");

        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        if (RecordCtr > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sbLoc.Clear();
                sbLoc.Append(CreateStrLoc(dtLoc, dt.Rows[i]["ClusterID"].ToString()));

                sb.Append("<tr strId='" + dt.Rows[i]["ClusterID"] + "' str='" + dt.Rows[i]["ClusterName"] + "' strLoc='" + sbLoc.ToString() + "' style='display: table-row;'>");
                sb.Append("<td>" + (i + 1).ToString() + "</td>");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        if (dt.Columns[j].ColumnName.ToString() == "strLoc")
                            sb.Append("<td>" + (sbLoc.ToString().Split('~')[0].Length > 70 ? "<span title='" + sbLoc.ToString().Split('~')[0] + "' class='clsInform'>" + sbLoc.ToString().Split('~')[0].Substring(0, 68) + ".." : sbLoc.ToString().Split('~')[0]) + "</span></td>");
                        else
                            sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                    }
                }
                if (flgEdit == "1")
                    sb.Append("<td class='clstdAction'><img src='../../Images/edit.png' title='edit' onclick='fnEdit(this);' style='margin-right: 12px;'/></td>");

                sb.Append("</tr>");
            }
        }
        else if(flgEdit == "1")
        {
            sb.Append("<tr strId='0' style='display: table-row;'>");
            sb.Append("<td></td>");
            sb.Append("<td><textarea style='width:98%; box-sizing: border-box; overflow-y: hidden;' rows='1'></textarea></td>");
            sb.Append("<td><span></span><img src='../../Images/edit.png' title='Select the Branch' lvl='' selhier='' onclick='fnShowLocHierPopup(this, 1);'  style='float:right;'/></td>");
            sb.Append("<td class='clstdAction'><img src='../../Images/save.png' title='save' onclick='fnSave(this, 0);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>");
            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }
    public static string CreateStrLoc(DataTable dt, string ClusterID)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sbLoc = new StringBuilder();
        DataRow[] dr = dt.Select("ClusterID=" + ClusterID);
        foreach(DataRow row in dr)
        {
            sb.Append(", " + row["Descr"].ToString());
            sbLoc.Append("^" + row["NodeID"].ToString() + "|" + row["NodeType"].ToString());
        }
        return sb.ToString().Substring(2) + "~" + sbLoc.ToString().Substring(1);
    }

    // ------ Not In Use -----------
    [System.Web.Services.WebMethod()]
    public static string fnRemoveCluster(string ClusterID)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRemoveCluster";
            Scmd.Parameters.AddWithValue("@ClusterID", ClusterID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            //Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            return "0|^|";
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    [System.Web.Services.WebMethod()]
    public static string fnSave(string ClusterID, string ClusterName, object obj, string StartDate, string EndDate, string LoginID, string UserID, string RoleID, string flgOverwrite)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spFBClusterMappingSaveCluster";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@ClusterID", ClusterID);
            Scmd.Parameters.AddWithValue("@ClusterName", ClusterName);
            Scmd.Parameters.AddWithValue("@ClusterMapping", tbl);
            Scmd.Parameters.AddWithValue("@StartDate", StartDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            //Scmd.Parameters.AddWithValue("@flgOverwrite", flgOverwrite);
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
                StringBuilder sb = new StringBuilder();
                if (Ds.Tables[1].Rows.Count > 0)
                {
                    sb.Append("Many of the Branch(s) are mapped with following Cluster(s) : ");
                    sb.Append("<table class='table table-striped table-bordered table-sm' style='margin-top: 6px;'>");
                    sb.Append("<thead>");
                    sb.Append("<tr>");
                    sb.Append("<th>#</th>");
                    for (int j = 0; j < Ds.Tables[1].Columns.Count; j++)
                    {
                        sb.Append("<th>" + Ds.Tables[1].Columns[j].ColumnName.ToString() + "</th>");
                    }
                    sb.Append("</tr>");
                    sb.Append("</thead>");
                    sb.Append("<tbody>");
                    for (int i = 0; i < Ds.Tables[1].Rows.Count; i++)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td>" + (i + 1).ToString() + "</td>");
                        for (int j = 0; j < Ds.Tables[1].Columns.Count; j++)
                        {
                            sb.Append("<td>" + Ds.Tables[1].Rows[i][j] + "</td>");
                        }
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody>");
                    sb.Append("</table>");

                    sb.Append("Please exclude these Branch(s) from all the above Cluster(s) and create a new one ?");
                    //sb.Append("Do you want to exclude these Distributors from all the above Cluster(s) and create a new one ?");
                }

                return "1|^|" + sb.ToString();
            }
            else
            {
                return "2|^|";
            }
        }
        catch (Exception e)
        {
            return "3|^|" + e.Message;
        }
    }

    // -------- Import Prev Cluster -----------
    [System.Web.Services.WebMethod()]
    public static string fnGetPrevMonthClusters(string LoginID, string UserID, string RoleID, string FromDate, string EndDate)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spFBGetClusterByMonth";
            Scmd.Parameters.AddWithValue("@FromDate", FromDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
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

            string[] SkipColumn = new string[1];
            SkipColumn[0] = "ClusterID";

            return "0|^|" + CreatePrevMonthClusterTbl(Ds.Tables[0], SkipColumn, "tblPrevQtrCluster", "clsPrevQtrCluster");
        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }
    private static string CreatePrevMonthClusterTbl(DataTable dt, string[] SkipColumn, string tblname, string cls)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "'>");
        sb.Append("<thead>");
        sb.Append("<tr>");
        sb.Append("<th></th>");
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
            sb.Append("<tr strId='" + dt.Rows[i]["ClusterID"] + "'>");
            sb.Append("<td><input type='checkbox'/></td>");
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
        return sb.ToString();
    }
    [System.Web.Services.WebMethod()]
    public static string fnImportPrevMonthCluster(string CopyFromStartDate, string CopyFromEndDate, object obj, string StartDate, string EndDate, string LoginID, string UserID, string RoleID)
    {
        try
        {
            string str = JsonConvert.SerializeObject(obj, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            DataTable tbl = JsonConvert.DeserializeObject<DataTable>(str);

            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spFBClusterCopyCluster";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@CopyFromStartDate", CopyFromStartDate);
            Scmd.Parameters.AddWithValue("@ClusterList", tbl);
            Scmd.Parameters.AddWithValue("@StartDate", StartDate);
            Scmd.Parameters.AddWithValue("@EndDate", EndDate);
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
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
            return "1|^|" + e.Message;
        }
    }
}