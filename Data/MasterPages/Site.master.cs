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

public partial class Data_MasterPages_SiteMenu : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnLoginID.Value = Session["LoginID"].ToString();
            lblUserName.Text= "Welcome " + Session["UserFullName"].ToString() + " !";
            //GetHierarchyMenuOLD();
            PopulateTopMenuHierarch(hdnLoginID.Value);
        }
    }
    private void PopulateTopMenuHierarch(string loginValue)
    {
        string[,] arrPara = new string[2, 2];
        arrPara[0, 0] = "0";
        arrPara[0, 1] = "0";
        arrPara[1, 0] = loginValue;
        arrPara[1, 1] = "0";

        SqlConnection objCon = new SqlConnection();
        SqlCommand objCom = new SqlCommand();
        objCom.CommandTimeout = 0;

        DataSet ds = new DataSet();
        clsConnection.clsConnection objAdo = new clsConnection.clsConnection();
        ds = objAdo.RunSPDS("spMakeTreeMenu", arrPara);

        ds.Relations.Add("rsParentChild", ds.Tables[0].Columns["HierID"], ds.Tables[0].Columns["PHierID"], false);
        int i = 0;

        string strproduct = "";
        if (ds.Tables.Count > 0)
        {
            int marginleft = 10;
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (dr["PHierID"].ToString() == "0" && dr["IndexNumP"].ToString() == "0")
                {
                    if (dr["IsLastLevel"].ToString() == "10")
                    {
                        strproduct += "<li><a class='active' href='javascript:void(0)'><span id='" + dr["HierID"].ToString() + "^" + dr["IsLastLevel"].ToString() + "'>" + dr["Descr"].ToString() + "</span></a>";
                    }
                    else
                    {
                        //strproduct += "<li HierID='" + dr["HierID"].ToString() + "' onclick=\"fnAction('" + dr["HierID"].ToString() + "')\"><a href='javascript:void(0)' style='padding-left:" + (marginleft + 5) + "px'><span id='" + dr["HierID"].ToString() + "^" + dr["IsLastLevel"].ToString() + "'>" + dr["Descr"].ToString() + "</span></a>";
                        strproduct += "<li HierID='" + dr["HierID"].ToString() + "' onclick='fnSelect(this);'><a href='javascript:void(0)'><span id='" + dr["HierID"].ToString() + "^" + dr["IsLastLevel"].ToString() + "'>" + dr["Descr"].ToString() + "</span></a>";
                    }
                    if (dr.GetChildRows("rsParentChild").Length > 0)
                    {
                        strproduct += PopulateProductChildTree(dr, marginleft);
                    }
                    strproduct += "</li>";
                }
                i = i + 1;
            }

        }
        objAdo.CloseConnection(ref objCon, ref objCom);

        TabHead.InnerHtml = strproduct.ToString();

    }
    private static string PopulateProductChildTree(DataRow dr, int marginleft)
    {
        string strproduct = "<ul class='accordion-body-parent'>";
        foreach (DataRow cRow in dr.GetChildRows("rsParentChild"))
        {
            if (cRow["IsLastLevel"].ToString() == "10")
            {
                strproduct += "<li><a class='active' href='javascript:void(0)' style='padding-left:" + (marginleft + 5) + "px'><span id='" + cRow["HierID"].ToString() + "^" + cRow["IsLastLevel"].ToString() + "'>" + cRow["Descr"].ToString() + "</span></a>";
            }
            else
            {
                // strproduct += "<li   HierID='" + cRow["HierID"].ToString() + "' onclick=\"fnAction('" + cRow["HierID"].ToString() + "')\"><a href='javascript:void(0)' style='padding-left:" + (marginleft + 5) + "px'><span id='" + cRow["HierID"].ToString() + "^" + cRow["IsLastLevel"].ToString() + "'>" + cRow["Descr"].ToString() + "</span></a>";
                strproduct += "<li HierID='" + cRow["HierID"].ToString() + "' onclick='fnSelect(this);'><a href='javascript:void(0)'><span id='" + cRow["HierID"].ToString() + "^" + cRow["IsLastLevel"].ToString() + "'>" + cRow["Descr"].ToString() + "</span></a>";
            }
            if (cRow.GetChildRows("rsParentChild").Length > 0)
            {
                int marginleftt = marginleft + 8;
                strproduct += PopulateProductChildTree(cRow, marginleftt);
            }
            strproduct += "</li>";
        }
        strproduct += "</ul>";
        return strproduct;
    }

    private void GetHierarchyMenuOLD()
    {
        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();

        Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetMenuName";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Sdap = new SqlDataAdapter(Scmd);
        Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbMenuLst = new StringBuilder();
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            if (i == 0)
            {
                sbMenuLst.Append("<li MenuID='" + Ds.Tables[0].Rows[i]["MnID"].ToString() + "' onclick='fnSelect(this);'><a class='nav-link active' href='#'>" + Ds.Tables[0].Rows[i]["MenuDescription"].ToString() + "</a>");
                // hdnMenuType.Value = Ds.Tables[0].Rows[i]["MnID"].ToString();
                if (Ds.Tables[0].Rows[i]["MnID"].ToString() == "1")
                {
                    sbMenuLst.Append("<ul>");
                    sbMenuLst.Append("<li MenuID='" + Ds.Tables[0].Rows[i]["MnID"].ToString() + "' onclick='fnSelect(this);'><a class='nav-link active' href='#'>Abhi/a></li>");
                    sbMenuLst.Append("</ul>");
                }
                sbMenuLst.Append("</li>");
            }
            else
                sbMenuLst.Append("<li MenuID='" + Ds.Tables[0].Rows[i]["MnID"].ToString() + "' onclick='fnSelect(this);'><a class='nav-link' href='#'>" + Ds.Tables[0].Rows[i]["MenuDescription"].ToString() + "</a></li>");
        }
        TabHead.InnerHtml = sbMenuLst.ToString();

    }
}
