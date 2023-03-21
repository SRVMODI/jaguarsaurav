Imports System.IO
Imports System.Data

Imports System.Data.SqlClient
Partial Class Data_Upload_frmUploadPRDMFile
    Inherits System.Web.UI.Page


    Private Sub btnRead_Click(sender As Object, e As EventArgs) Handles btnRead.Click
        Dim csvPath As String = Server.MapPath("~/Files/") + Path.GetFileName(FileUpload1.PostedFile.FileName)
        If File.Exists(csvPath) Then
            File.Delete(csvPath)
        End If
        FileUpload1.SaveAs(csvPath)

        Dim Filename As String = Path.GetFileName(FileUpload1.PostedFile.FileName)

        Dim FileSetID As String = fnGetFileSetID(Filename)

        If FileSetID.Split("^")(0) = 1 Then
            FileSetID = FileSetID.Split("^")(1)
        Else
            FileSetID = 0
        End If
        Dim ErrorMsg As String = ""
        Dim dataTable As New DataTable()
        'Create a DataTable.
        If FileSetID <> 0 Then
            Using SR As StreamReader = New StreamReader(csvPath)
                Dim Headers() As String = SR.ReadLine().Split("|")

                Dim lineno = 0
                Dim maxcol = 0
                maxcol = Headers.Count()

                For i As Integer = 0 To Headers.Count() - 1
                    dataTable.Columns.Add(Headers(i).Trim().Replace(Chr(34), "").Replace("r\", ""))
                Next
                dataTable.Columns.Add("FileSetID")
                While Not SR.EndOfStream
                    lineno = lineno + 1

                    Dim test As String = SR.ReadLine()
                    '  test = test.Replace(Chr(34), "")
                    'Dim rows As String() = System.Text.RegularExpressions.Regex.Split(test, "|(?=(?:[^""]*""[^""]*"")*[^""]*$)").[Select](Function(x) x.Replace("""", "")).ToArray()
                    'Dim rows As String() = System.Text.RegularExpressions.Regex.Split(test, "(?:^|\|)").[Select](Function(x) x.Replace(Chr(34), "")).ToArray() '(""[^""]*""|[^|]*)
                    Dim rows() As String = System.Text.RegularExpressions.Regex.Split(test, "(?<!\\)\|").[Select](Function(x) x.Replace(Chr(34), "")).ToArray() '(""[^""]*""|[^|]*)

                    If (maxcol = rows.Count) Then
                        Dim DRow = dataTable.NewRow()
                        For i As Integer = 0 To rows.Count - 1
                            DRow(i) = rows(i)
                        Next
                        DRow(rows.Count) = FileSetID
                        dataTable.Rows.Add(DRow)

                    End If
                End While
            End Using
            Try

                '''''''''''''''''' Truncate Table ''''''''''''''''''''''''
                Dim consString As String = ConfigurationManager.ConnectionStrings("strConn").ConnectionString
                Dim strSQL As String
                strSQL = "TRUNCATE TABLE tmpProductMaster"
                Using connection As New SqlConnection(consString)
                    Dim cmd As New SqlCommand(strSQL, connection)
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using

                ''''''''''''''''''' Insert Data ''''''''''''''''''''''''
                Using con As New SqlConnection(consString)
                    Using sqlBulkCopy As New SqlBulkCopy(con)
                        'Set the database table name.
                        sqlBulkCopy.DestinationTableName = "dbo.tmpProductMaster"
                        con.Open()
                        sqlBulkCopy.WriteToServer(dataTable)
                        con.Close()
                    End Using
                End Using
                Dim strReturn = fnExecutePrdUploadFromTmpTable()

                If strReturn.Split("^")(0) = 1 Then
                    lblMsg.Text = "File Upload Successfully..."
                Else
                    lblMsg.Text = "Error--" & strReturn.Split("^")(1)
                End If


            Catch ex As Exception
                lblMsg.Text = "Error..." & ex.Message
            End Try
        End If
    End Sub

    Function fnGetFileSetID(ByVal FileName As String) As String
        Dim Objcon2 As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom2 As New SqlCommand("[spFileGetFileSetID]", Objcon2)
        objCom2.Parameters.Add("@FileName", SqlDbType.VarChar).Value = FileName
        objCom2.Parameters.Add("@LoginID", SqlDbType.Int).Value = 1 ' Session("LoginID")

        Dim retValParam As New SqlParameter("@FileSetID", Data.SqlDbType.Int)
        retValParam.Direction = Data.ParameterDirection.Output
        objCom2.Parameters.Add(retValParam)

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0
        Dim FileSetID As Integer = 0
        Dim dr As SqlDataReader
        Dim strReturn As String
        Try
            Objcon2.Open()
            dr = objCom2.ExecuteReader()
            'dr.Read()
            FileSetID = retValParam.Value  'dr.Item("FileSetID")
            strReturn = "1^" & FileSetID
        Catch ex As Exception
            strReturn = "2^" & ex.Message
        Finally
            objCom2.Dispose()
            Objcon2.Close()
            Objcon2.Dispose()
        End Try
        Return strReturn
    End Function


    Function fnExecutePrdUploadFromTmpTable() As String
        Dim Objcon2 As New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("strConn"))
        Dim objCom2 As New SqlCommand("[spPrdUploadFromTmpTable]", Objcon2)

        objCom2.CommandType = CommandType.StoredProcedure
        objCom2.CommandTimeout = 0

        Dim dr As SqlDataReader
        Dim strReturn As String
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
