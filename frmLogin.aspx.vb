Imports System.Web.Security
Imports System.Data.SqlClient
Partial Class Login
    Inherits System.Web.UI.Page
    Dim arrPara(0, 1) As String
    Dim objdr As SqlDataReader
    Dim objADO As New clsConnection.clsConnection
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
    End Sub
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim strTicket As String
        Dim RoleID As String = "0"
        Dim PassChangeFirst As String = "0"
        ReDim arrPara(5, 1)
        Dim varAuthenticate As Boolean = False
        arrPara(0, 0) = ReplaceQuotes(Trim(txtUserName.Value))
        arrPara(0, 1) = "1"

        arrPara(1, 0) = ReplaceQuotes(Trim(txtPassword.Value))
        arrPara(1, 1) = "1"

        arrPara(2, 0) = Session.SessionID
        arrPara(2, 1) = "1"

        arrPara(3, 0) = Request.ServerVariables("REMOTE_ADDR")
        arrPara(3, 1) = "1"

        arrPara(4, 0) = Request.Browser.Type
        arrPara(4, 1) = "1"

        arrPara(5, 0) = hdnRes.Value
        arrPara(5, 1) = "1"

        Dim objCon As New SqlConnection
        Dim objCom As New SqlCommand

        objCom.CommandTimeout = 0
        objdr = objADO.RunSP("spSecUserLogin", arrPara, 0, objCon, objCom)

        If objdr.HasRows Then
            objdr.Read()
            If (objdr("LoginResult") = 1) Then
                dvMessage.InnerText = "Invalid Username or Password !!!"
                txtUserName.Value = ""
                txtPassword.Value = ""
            ElseIf (objdr("LoginResult") = 2 Or objdr("LoginResult") = 3) Then
                Session("LoginID") = objdr("LoginID")
                Session("UserID") = objdr("UserID")
                Session("RoleId") = objdr("RoleId")
                RoleID = objdr("RoleId")
                Session("NodeType") = objdr("NodeType")
                Session("NodeId") = objdr("NodeId")
                Session("UserFullName") = objdr("UserFullName")
                PassChangeFirst = objdr("flgPasswordChange")

                strTicket = objdr("LoginID")
                makeTicket(strTicket)
                varAuthenticate = True
            End If
        End If
        objADO.CloseConnection(objCon, objCom, objdr)
        'If varAuthenticate Then
        'Response.Write("<script language=javascript>window.location.href='Other/Option.aspx';</script>")
        'End If

        If varAuthenticate Then
            If Convert.ToInt16(RoleID) = 1014 Then
                Response.Redirect("Data/EntryForms/SWB.aspx")
            Else
                Response.Redirect("Data/Other/frmDashboard.aspx")
            End If
        End If

    End Sub


    Private Sub makeTicket(ByVal strTicket As String)
        Dim objTicket As FormsAuthenticationTicket
        Dim authCookie As HttpCookie
        Dim sessionLength As Integer = ConfigurationSettings.AppSettings("sessionDuration")

        objTicket = New FormsAuthenticationTicket(1, txtUserName.Value, Date.Now, Date.Now.AddMinutes(sessionLength), False, strTicket)

        authCookie = New HttpCookie(".aspxauth")
        authCookie.Value = FormsAuthentication.Encrypt(objTicket)

        Response.Cookies.Add(authCookie)


    End Sub
    Public Function ReplaceQuotes(ByVal str As String) As String
        Return Replace(str, "'", "''")
    End Function
End Class
