Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json

Partial Class Data_EntryForms_frmGetBrandCategory
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("LoginId") Is Nothing) Then
            Response.Redirect("../../frmLogin.aspx")
            Return
        End If
        If Not IsPostBack Then

            Dim strReturnBrandTable As String = fnGetBrandDetails()
            If strReturnBrandTable.Split("~")(0) = "1" Then
                '  dvBrandName.InnerHtml = strReturnTable.Split("|")(0).Split("~")(1)
                dvBrandName.InnerHtml = strReturnBrandTable.Split("~")(1)
            End If

            'Dim strReturnSubBrandTable As String = fnGetSubBrandDetails()
            'If strReturnSubBrandTable.Split("~")(0) = "1" Then
            '    '  dvBrandName.InnerHtml = strReturnTable.Split("|")(0).Split("~")(1)
            '    dvSubBrandName.InnerHtml = strReturnSubBrandTable.Split("~")(1)
            'End If
        End If
    End Sub
    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetBrandDetails() As String

        Dim Cntr As Integer = 0
        Dim objCon As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom As New SqlCommand("[spPordHierMapUserDefinedPrd]", objCon)
        objCom.Parameters.Add("@FileSetID", SqlDbType.Int).Value = 39 '   
        objCom.Parameters.Add("@LoginID", SqlDbType.Int).Value = 0
        objCom.Parameters.Add("@Lvl", SqlDbType.VarChar).Value = "BF"

        objCom.CommandTimeout = 0
        objCom.CommandType = CommandType.StoredProcedure

        Dim da As New SqlDataAdapter(objCom)
        Dim ds As New DataSet
        da.Fill(ds)
        Dim strReturn As String

        Dim strTable As New StringBuilder
        Dim strSecondTable As New StringBuilder



        '''''''''''''''''''''''''''''Second Cursor'''''''''''''''''''''
        If ds.Tables(1).Rows.Count > 0 Then
            strSecondTable.Append("<table class='table table-bordered table-sm table-striped' id='tblMain'>")
            strSecondTable.Append("<thead>")
            strSecondTable.Append("<tr>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Category")
            strSecondTable.Append("</th>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Brand")
            strSecondTable.Append("</th>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Brand Form")
            strSecondTable.Append("</th>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Brand Form name")
            strSecondTable.Append("</th>")

            'strSecondTable.Append("<th>")
            'strSecondTable.Append("BrandName")
            'strSecondTable.Append("</th>")

            'strSecondTable.Append("<th>")
            'strSecondTable.Append("Category Name")
            'strSecondTable.Append("</th>")

            strSecondTable.Append("</tr>")


            strSecondTable.Append("</thead>")



            For Each dataR As DataRow In ds.Tables(1).Rows
                strSecondTable.Append("<tr BFNodeId = '" & dataR.Item("BFNodeID") & "'  BFNodeType = '" & dataR.Item("BFNodeType") & "' >")
                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("Category"))
                strSecondTable.Append("</td>")

                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("Brand"))
                strSecondTable.Append("</td>")

                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("BrandForm"))
                strSecondTable.Append("</td>")

                Dim ddlBrandForm As String = ""
                ddlBrandForm &= "<option value = 0>- Select Brand Form -</option>"
                Dim flag As Integer = 0
                For Each dr As DataRow In ds.Tables(0).Rows
                    'If dataR.Item("Brand").ToString.ToUpper = dr.Item("Brand_Name").ToString.ToUpper Then
                    '    ddlBrandForm &= "<option selected value = " & dr.Item("ID") & ">" & dr.Item("BrandForm_Name").ToString() & "</Option>"
                    'End If
                    If dataR.Item("id") = dr.Item("id") Then
                        ddlBrandForm &= "<option selected value = " & dr.Item("Id") & ">" & dr.Item("BrandForm_Name").ToString() & "</Option>"

                    Else
                        ddlBrandForm &= "<option value = " & dr.Item("Id") & ">" & dr.Item("BrandForm_Name").ToString() & "</Option>"

                    End If
                Next
                strSecondTable.Append("<td>")
                strSecondTable.Append("<Select id='ddlBrandForm' class='form-control form-control-sm'> " & ddlBrandForm & "</select>")
                strSecondTable.Append("</td>")

                strSecondTable.Append("</tr>")
            Next

            strSecondTable.Append("</table>")

        Else
            strSecondTable.Append("<div class='text-danger text-center'>")
            strSecondTable.Append("No Record Found...")
            strSecondTable.Append("</div>")
        End If

        '    strReturnVal = "1@" & HttpContext.Current.Server.HtmlDecode(strTable.ToString)
        strReturn = "1~" & strSecondTable.ToString
        Return strReturn
    End Function

    <System.Web.Services.WebMethod(EnableSession:=True)>
    Public Shared Function fnSaveBrand(ByVal objDetails As Object) As String
        Dim strReturn As String = 1
        Dim strReturnFromDb As Integer = 0
        Dim tblBrandForm As New DataTable()
        tblBrandForm.TableName = "tblBrandForm"
        Dim settings As New JsonSerializerSettings()
        settings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        Dim strTable As String = JsonConvert.SerializeObject(objDetails, settings.ReferenceLoopHandling)
        tblBrandForm = JsonConvert.DeserializeObject(Of DataTable)(strTable)


        Dim Objcon2 As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom2 As New SqlCommand("[spPordHierConfirmPrd]", Objcon2)

        objCom2.Parameters.AddWithValue("@PrdMapping", tblBrandForm)
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = 1 'Session("LoginID") '1
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1^"
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnGetSubBrandDetails() As String

        Dim Cntr As Integer = 0
        Dim objCon As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom As New SqlCommand("[spPordHierMapUserDefinedPrd]", objCon)
        objCom.Parameters.Add("@FileSetID", SqlDbType.Int).Value = 39 '   
        objCom.Parameters.Add("@LoginID", SqlDbType.Int).Value = 0
        objCom.Parameters.Add("@Lvl", SqlDbType.VarChar).Value = "SBF"

        objCom.CommandTimeout = 0
        objCom.CommandType = CommandType.StoredProcedure

        Dim da As New SqlDataAdapter(objCom)
        Dim ds As New DataSet
        da.Fill(ds)
        Dim strReturn As String

        Dim strTable As New StringBuilder
        Dim strSecondTable As New StringBuilder



        '''''''''''''''''''''''''''''Second Cursor'''''''''''''''''''''
        If ds.Tables(1).Rows.Count > 0 Then
            strSecondTable.Append("<table class='table table-bordered table-sm table-striped' id='tblMain'>")
            strSecondTable.Append("<thead>")
            strSecondTable.Append("<tr>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Category")
            strSecondTable.Append("</th>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Brand")
            strSecondTable.Append("</th>")
            strSecondTable.Append("<th>")
            strSecondTable.Append("Brand Form")
            strSecondTable.Append("</th>")

            strSecondTable.Append("<th>")
            strSecondTable.Append("Sub Brand Form")
            strSecondTable.Append("</th>")

            strSecondTable.Append("<th>")
            strSecondTable.Append("Sub Brand Form")
            strSecondTable.Append("</th>")

            'strSecondTable.Append("<th>")
            'strSecondTable.Append("BrandName")
            'strSecondTable.Append("</th>")

            'strSecondTable.Append("<th>")
            'strSecondTable.Append("Category Name")
            'strSecondTable.Append("</th>")

            strSecondTable.Append("</tr>")


            strSecondTable.Append("</thead>")



            For Each dataR As DataRow In ds.Tables(1).Rows
                strSecondTable.Append("<tr SBFNodeId = '" & dataR.Item("SBFNodeID") & "'  SBFNodeType = '" & dataR.Item("SBFNodeType") & "' >")
                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("Category"))
                strSecondTable.Append("</td>")

                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("Brand"))
                strSecondTable.Append("</td>")

                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("BrandForm"))
                strSecondTable.Append("</td>")

                strSecondTable.Append("<td>")
                strSecondTable.Append(dataR.Item("SubBrandForm"))
                strSecondTable.Append("</td>")

                Dim ddlBrandForm As String = ""
                ddlBrandForm &= "<option value = 0>- Select SBF -</option>"
                Dim flag As Integer = 0
                For Each dr As DataRow In ds.Tables(0).Rows
                    'If dataR.Item("Brand").ToString.ToUpper = dr.Item("Brand_Name").ToString.ToUpper Then
                    '    ddlBrandForm &= "<option selected value = " & dr.Item("ID") & ">" & dr.Item("BrandForm_Name").ToString() & "</Option>"
                    'End If
                    If dataR.Item("id") = dr.Item("id") Then
                        ddlBrandForm &= "<option selected value = " & dr.Item("Id") & ">" & dr.Item("Sub_brandform_Name").ToString() & "</Option>"

                    Else
                        ddlBrandForm &= "<option value = " & dr.Item("Id") & ">" & dr.Item("Sub_brandform_Name").ToString() & "</Option>"

                    End If
                Next
                strSecondTable.Append("<td>")
                strSecondTable.Append("<Select id='ddlSubBrandForm' class='form-control form-control-sm'> " & ddlBrandForm & "</select>")
                strSecondTable.Append("</td>")

                strSecondTable.Append("</tr>")
            Next

            strSecondTable.Append("</table>")
            strReturn = "1~" & strSecondTable.ToString
        Else
            strSecondTable.Append("<div class='text-danger text-center'>")
            strSecondTable.Append("No Record Found...")
            strSecondTable.Append("</div>")
            strReturn = "2~" & strSecondTable.ToString
        End If

        '    strReturnVal = "1@" & HttpContext.Current.Server.HtmlDecode(strTable.ToString)

        Return strReturn
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function fnSaveSubBrand(ByVal objDetails As Object) As String
        Dim strReturn As String = 1
        Dim strReturnFromDb As Integer = 0
        Dim tblBrandForm As New DataTable()
        tblBrandForm.TableName = "tblBrandForm"
        Dim settings As New JsonSerializerSettings()
        settings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore
        Dim strTable As String = JsonConvert.SerializeObject(objDetails, settings.ReferenceLoopHandling)
        tblBrandForm = JsonConvert.DeserializeObject(Of DataTable)(strTable)


        Dim Objcon2 As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom2 As New SqlCommand("[spPordHierConfirmPrd]", Objcon2)

        objCom2.Parameters.AddWithValue("@PrdMapping", tblBrandForm)
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = 1
        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Try
            Objcon2.Open()
            objCom2.ExecuteNonQuery()
            strReturn = "1^"
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn
    End Function
End Class
