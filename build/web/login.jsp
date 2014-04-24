<%-- 
    Document   : login
    Created on : 18.Ağu.2010, 11:34:43
    Author     : huseyin
--%>

<%@page import="org.barset.data.Database"%>

<%@page contentType="text/html" pageEncoding="windows-1254"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%
if ( request.getParameter("go") != null ){
    request.getSession().setAttribute("user", null);
    request.getSession().setAttribute("userFirma", null);
    request.getSession().setAttribute("userName", null);
}
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1254">
        <title>Sisteme Giriş</title>
        <LINK rel=stylesheet type="text/css" href="../resources/css/ext-all.css">
        <LINK rel=stylesheet type="text/css" href="../resources/css/login.css">
        <LINK rel=stylesheet type="text/css" href="../resources/css/style.css">
        <LINK rel="shortcut icon" href="../resources/park.ico">
        <LINK rel="icon" href="../resources/park.ico">

        <SCRIPT type="text/javascript" src="../adapter/ext/ext-base.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="../ext-all.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="../adapter/login.js"></SCRIPT>
    </head>
    <BODY id=docs scroll=no>
         
        <DIV id=loading-mask></DIV>
        <DIV id=loading>
            <DIV class=loading-indicator><IMG style="MARGIN-RIGHT: 8px" align=absMiddle src="../resources/loading2.gif" width=32 height=32>Yükleniyor...</DIV>
        </DIV>
        <DIV id=header><A style="FLOAT: right; MARGIN-RIGHT: 10px" href="http://extjs.com/"><IMG style="MARGIN-TOP: 1px; WIDTH: 83px; HEIGHT: 24px" src="../resources/bgr.gif"></A>
            <DIV class=api-title>Barset Bilgi Sistemleri</DIV></DIV>
        <DIV id=classes></DIV>
        <DIV id="login-main"></DIV>

    
     <!-- <%=String.valueOf(session.getAttribute("userName"))%> --> 
     
     
    </BODY>
</html>