<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frmLogout.aspx.vb" Inherits="frmLogout" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <script language="javascript" type="text/javascript">

        function FnLogOut() {
            alert("You Have Been Logged Out From The System! Please Login Again.");
            parent.parent.window.location.href = "frmLogin.aspx";
        }
  
    </script>
</head>
<body>
    <form id="form1" runat="server">
    
    </form>
</body>
</html>
