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

public partial class MasterForms_frmRoleAddEdit : System.Web.UI.Page
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
        Scmd.CommandText = "spGetScreens";
        Scmd.Parameters.AddWithValue("@LoginID", hdnLoginID.Value);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);
        Scmd.Dispose();
        Sdap.Dispose();

        StringBuilder sbMenu = new StringBuilder();
        // sbScreen.Append("<option value='0'>--select--</option>");
        for (int i = 0; Ds.Tables[0].Rows.Count > i; i++)
        {
            sbMenu.Append("<option value='" + Ds.Tables[0].Rows[i]["MnID"].ToString() + "'>" + Ds.Tables[0].Rows[i]["MenuDescription"].ToString() + "</option>");
            //   ddlFunction.Items.Add(new ListItem(Ds.Tables[0].Rows[i]["RoleId"].ToString(), Ds.Tables[0].Rows[i]["RoleName"].ToString()));
        }
        hdnMenuID.Value = sbMenu.ToString();
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
            Scmd.CommandText = "spRoleGetRoles";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[6];
            SkipColumn[0] = "RoleId";
            SkipColumn[1] = "LoginIDIns";
            SkipColumn[2] = "TimestampIns";
            SkipColumn[3] = "LoginIDUpd";
            SkipColumn[4] = "TimestampUpd";
            SkipColumn[5] = "users";
            return "0|^|" + CreateMstrTbl(Ds.Tables[0], Ds.Tables[1], SkipColumn, "tblReport", "clsReport");

        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    private static string CreateMstrTbl(DataTable dt, DataTable dtMenu, string[] SkipColumn, string tblname, string cls)
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
        sb.Append("<th>Menu Screen</th>");
        sb.Append("<th>Edit</th>");
        sb.Append("<th>User Details</th>");
        sb.Append("<th>Add New User</th>");
        sb.Append("</tr>");
        sb.Append("</thead>");
        sb.Append("<tbody>");
        for (int i = 0; i < dt.Rows.Count; i++)
        {

            DataTable dtNew = new DataTable();
            DataRow[] dr = dtMenu.Select("RoleID=" + dt.Rows[i]["RoleId"].ToString());

            if (dr.Length > 0)
            {
                dtNew = dr.CopyToDataTable();
            }


            StringBuilder sbMenu = new StringBuilder();
            List<string> strMenuIdList = new List<string>();
            List<string> strMenuDescrList = new List<string>();

            foreach (DataRow drow in dtNew.Rows)
            {
                strMenuIdList.Add(Convert.ToString(drow["MnID"]));
                strMenuDescrList.Add(Convert.ToString(drow["MenuDescription"]));
            }
            string MenuIDString = String.Join(",", strMenuIdList.ToArray());
            string MenuDescrString = String.Join(",", strMenuDescrList.ToArray());





            //for (int a = 0; dtNew.Rows.Count > a; a++)
            //{
            //    sbMenu.Append("<option value='" + dtNew.Rows[i]["MnID"].ToString() + "'>" + dtNew.Rows[i]["MenuDescription"].ToString() + "</option>");
            //}
            ////  hdnMenuID.Value = sbMenu.ToString();


            sbDescr.Clear();
            sb.Append("<tr RoleID='" + dt.Rows[i]["RoleId"] + "' RoleName='" + dt.Rows[i]["RoleName"] + "' MenuID='" + MenuIDString + "' MenuDescr='" + MenuDescrString + "'>");
            sb.Append("<td>" + (i + 1).ToString() + "</td>");

            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                {
                    sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                }
            }
            //sb.Append("<td><select id='ddlMenu' class='mySelectClass' multiple='multiple' style='width:20%; box-sizing: border-box; margin-right: 1%;'>" + sbMenu + "</select></td>");

            if (MenuDescrString.Length > 50)
            {
                sb.Append("<td>" + MenuDescrString.Substring(0, 50) + "...</td>");
            }
            else
            {
                sb.Append("<td>" + MenuDescrString + "</td>");
            }
            sb.Append("<td title='Edit Role'><img src='../../Images/edit.png' onclick='fnEdit(this);'/></td>");
            sb.Append("<td><img title='" + customTooltipforUserDetail(dt.Rows[i]["users"].ToString(), dt.Rows[i]["RoleName"].ToString()) + "' class='clsInform' src='../../Images/person.png' onclick='fnUserDeatils(this);'/></td>");
            sb.Append("<td title='Add New User'><a href='#' style='color:blue;text-decoration:underline;' onclick='fnAddNewUser(this)'>Add New User</a></td>");

            sb.Append("</tr>");
        }
        sb.Append("</tbody>");
        sb.Append("</table>");
        return sb.ToString();
    }

    private static string customTooltipforUserDetail(string Users, string Role)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<div>User Details For: " + Role);
        sb.Append("</div>");
        if (Users != "")
        {
            int cntr = 0;
            sb.Append("<table>");
            sb.Append("<tr><th>User Name</th></tr>");
            int rowsperator = 0;

            sb.Append("<tr>");
            for (int i = 0; i < Users.Split(',').Length; i++)
            {
                cntr++;
                sb.Append("<td>" + Users.Split(',')[i] + "</td>");
                if (cntr > rowsperator)
                {
                    cntr = 0;
                    sb.Append("</tr><tr>");
                }
            }
            sb.Append("</tr>");
        }
        else
        {
            sb.Append("<tr>");
            sb.Append("<td>No User Found For This Role....</td>");
            sb.Append("</tr>");
        }
        sb.Append("</table>");
        return sb.ToString();

    }

    [System.Web.Services.WebMethod()]
    public static string fnViewUserDetail(string RoleID, string LoginID)
    {
        string tblname = "";
        string cls = "";
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetUsersofRole";
        Scmd.Parameters.AddWithValue("@RoleID", RoleID);
        Scmd.Parameters.AddWithValue("@LoginId", LoginID);
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataSet Ds = new DataSet();
        Sdap.Fill(Ds);

        StringBuilder str = new StringBuilder();
        if (Ds.Tables[0].Rows.Count > 0)
        {
            // str.Append("<table cellpadding='0' cellspacing='0' style='width:100%; border-bottom:1px solid gray;border-collapse:collapse;' id='tblBasicDetailsInfoDetails' class='table-bordered' ><thead>");
            str.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "'><thead>");
            str.Append("<tr>");
            str.Append("<th style='width:2%;'>#</th>");
            str.Append("<th style='width:7%;'>User Name</th>");
            str.Append("<th style='width:7%;'>Email ID</th>");
            str.Append("<th style='width:7%;'>Phone No</th>");
            str.Append("<th style='width:7%;'>Active</th>");
            str.Append("</tr></thead><tbody>");

            for (int i = 0; i < Ds.Tables[0].Rows.Count; i++)
            {
                str.Append("<tr NodeID='" + Ds.Tables[0].Rows[i]["UserID"].ToString() + "' Descr='" + Ds.Tables[0].Rows[i]["User Name"].ToString() + "'  EmailID = '" + Ds.Tables[0].Rows[i]["Email ID"].ToString() + "' PhoneNo = '" + Ds.Tables[0].Rows[i]["Phone No"].ToString() + "' Active = '" + Ds.Tables[0].Rows[i]["Active"].ToString() + "' > ");
                str.Append("<td style='width:2%;text-align:center;'>" + (i + 1) + "</td>");
                str.Append("<td style='display:none'>" + Ds.Tables[0].Rows[i]["UserID"].ToString() + "</td>");
                str.Append("<td style='width:7%;text-align:left;'>" + Ds.Tables[0].Rows[i]["User Name"].ToString() + "</td>");
                str.Append("<td style='width:7%;text-align:left;'>" + Ds.Tables[0].Rows[i]["Email ID"].ToString() + "</td>");
                str.Append("<td style='width:7%;text-align:left;'>" + Ds.Tables[0].Rows[i]["Phone No"].ToString() + "</td>");
                // str.Append("<td style='width:7%;text-align:left;'>" + Ds.Tables[0].Rows[i]["Active"].ToString() + "</td>");


                if (Ds.Tables[0].Rows[i]["Active"].ToString() == "Yes")
                {
                    // str.Append("<td style='width:7%;text-align:left;'><span><input type='checkbox' checked='checked'/></td></span>");
                    // str.Append("<td><a href='#' style='color:blue;text-decoration:underline;' onclick='fnActive_DActiveUser(this)'>Active</a></td>");
                    str.Append("<td><span><a href='#' style='color:blue;text-decoration:underline;' onclick='fnActive_DActiveUser(this)'>Active</a></td></span>");
                }
                else
                {
                    //str.Append("<td><a href='#' style='color:blue;text-decoration:underline;' onclick='fnActive_DActiveUser(this)'>DActive</a></td>");
                    str.Append("<td><span><a href='#' style='color:blue;text-decoration:underline;' onclick='fnActive_DActiveUser(this)'>In-Active</a></td></span>");
                }

                str.Append("</tr>");


            }

            str.Append("</tbody></table>");
        }
        else
        {
            str.Append("<table class='table table-bordered table-sm text-center'><tbody>");
            str.Append("<tr>");
            str.Append("<td class='text-left'>No User Found For This Role....</td>");
            str.Append("</tr>");
            str.Append("</tbody></table>");
        }
        return str.ToString();
    }

    [System.Web.Services.WebMethod()]
    public static string fnActive_DActiveUser(string UserID, string LoginID, string flgActiveValue)
    {
        string result = "";
        if ((HttpContext.Current.Session["LoginID"] != null))
        {
            SqlConnection con = null;
            con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlTransaction transaction;
            SqlCommand cmd = null;

            con.Open();
            transaction = con.BeginTransaction();
            try
            {
                cmd = new SqlCommand("spUserMarkInactive", con, transaction);
                cmd.Parameters.AddWithValue("@UserID", UserID);
                cmd.Parameters.AddWithValue("@LoginID", LoginID);
                cmd.Parameters.AddWithValue("@flgActive", flgActiveValue);


                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 0;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);

                string flgDuplicate = ds.Tables[0].Rows[0][0].ToString();
                if (flgDuplicate == "1")
                {
                    result = "1^" + "User Status Change Successfully..";
                }

                else
                {
                    result = "2^" + "Please Contact Administrator...";
                }

                transaction.Commit();
            }
            catch (Exception ex)
            {
                result = "2^" + ex.Message;
                transaction.Rollback();

                string ProjectTitle = ConfigurationManager.AppSettings["Title"];
                //clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "Manage Vehicle", "fnManageVanMaster", "Error in saving vehicle in " + ProjectTitle);
            }
            finally
            {
                cmd.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            result = "Session Expired,Please relogin^4^";
        }
        return result;
    }


    [System.Web.Services.WebMethod()]
    public static string fnAddNewUser(string LoginID, string NodeID, string UserName, string Designation, string EmployeeCode, string EmailID, string PhoneNo, string UserStatus, string RoleID, object ArrTblData)
    {
        string strTblData = JsonConvert.SerializeObject(ArrTblData, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        DataTable tblApplicableLvls = JsonConvert.DeserializeObject<DataTable>(strTblData);

        if (tblApplicableLvls.Columns.Count == 0)
        {
            tblApplicableLvls.Columns.Add("NodeID");
            tblApplicableLvls.Columns.Add("NOdeType");
            tblApplicableLvls.Columns.Add("BucketTypeID");
        }


        string result = "";
        if ((HttpContext.Current.Session["LoginID"] != null))
        {
            SqlConnection con = null;
            con = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
            SqlTransaction transaction;
            SqlCommand cmd = null;

            con.Open();
            transaction = con.BeginTransaction();
            try
            {
                cmd = new SqlCommand("spUserSaveUsers", con, transaction);
                cmd.Parameters.AddWithValue("@LoginID", LoginID);
                cmd.Parameters.AddWithValue("@userID", NodeID);
                cmd.Parameters.AddWithValue("@EmpName", UserName);
                cmd.Parameters.AddWithValue("@Designation", Designation);
                cmd.Parameters.AddWithValue("@EmpCode", EmployeeCode);
                cmd.Parameters.AddWithValue("@PersonEmailID", EmailID);
                cmd.Parameters.AddWithValue("@PersonPhone", PhoneNo);
                cmd.Parameters.AddWithValue("@flgActive", UserStatus);
                cmd.Parameters.AddWithValue("@RoleID", RoleID);
                cmd.Parameters.AddWithValue("@ApplicableLvls", tblApplicableLvls);


                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 0;
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);

                string flgDuplicate = ds.Tables[0].Rows[0][0].ToString();
                if (flgDuplicate == "-1")
                {
                    result = "-1^" + "User already exists.";
                }
                else if (flgDuplicate == "-2")
                {
                    result = "-2^" + "Please Contact Administrator.";
                }
                else
                {
                    result = "-3^" + "User Saved successfully.";
                }

                transaction.Commit();
            }
            catch (Exception ex)
            {
                result = "2^" + ex.Message;
                transaction.Rollback();

                string ProjectTitle = ConfigurationManager.AppSettings["Title"];
                //clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "Manage Vehicle", "fnManageVanMaster", "Error in saving vehicle in " + ProjectTitle);
            }
            finally
            {
                cmd.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            result = "Session Expired,Please relogin^4^";
        }
        return result;
    }


    [System.Web.Services.WebMethod()]
    public static string fnSave(string RoleID, string RoleName, object CheckingMenuID, string strSelectedMenuID, string LoginID)
    {
        DataTable tblMenuID = new DataTable();
        string strMenuID = JsonConvert.SerializeObject(CheckingMenuID, Formatting.Indented, new JsonSerializerSettings { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
        tblMenuID = JsonConvert.DeserializeObject<DataTable>(strMenuID);

        try
        {

            StringBuilder sb = new StringBuilder();
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd.Connection = Scon;
            Scmd.CommandText = "spRoleSaveRoles";
            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);
            Scmd.Parameters.AddWithValue("@RoleName", RoleName);
            Scmd.Parameters.AddWithValue("@MenuID", tblMenuID);

            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) == -1)
            {
                return "-1|^|" + "Role already exists.";
            }
            else if (Convert.ToInt32(Ds.Tables[0].Rows[0][0]) == -2)
            {
                return "-2|^|" + "Please Contact Administrator.";
            }
            else
            {
                return "-3|^|" + "Role Saved successfully.";
            }


           // return "-3|^|" + "Role Saved successfully.";
        }
        catch (Exception e)
        {
            return "2|^|" + e.Message;
        }
    }
}