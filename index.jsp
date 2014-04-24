<%-- 
    Document   : do
    Created on : 17.Ağu.2010, 14:39:23
    Author     : huseyin
--%>

<%@page import="org.barset.data.ExecProc"%>
<%@page import="java.util.Date"%>
<%@page import="org.barset.beans.userBean"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%

HttpSession ses = request.getSession();

/*
userBean user = new userBean();
user.setID("sa");
user.setPassword("98");
user.setCompany("101");
request.getSession().setAttribute("user", user);
request.getSession().setAttribute("userFirma", "101");
request.getSession().setAttribute("userName", "sa");
*/

if( ses == null ){
    out.println("Session ayarlanamadı:");    
}

Object userObject = request.getSession().getAttribute("userName");

if ( userObject == null ){
    response.sendRedirect("pages/login.jsp");
}

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1254">
        <title>Ana Sayfa</title>
		
        <LINK rel=stylesheet type="text/css" href="resources/css/ext-all.css">
        <LINK rel=stylesheet type="text/css" href="resources/css/docs.css">
        <LINK rel=stylesheet type="text/css" href="resources/css/style.css">
		<LINK rel=stylesheet type="text/css" href="resources/css/theme-gray/date-picker.css">
		
        <LINK rel="shortcut icon" href="resources/park.ico">
        <LINK rel="icon" href="resources/park.ico">
               
        <SCRIPT type="text/javascript" src="adapter/ext/ext-base.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="ext-all.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="adapter/TabCloseMenu.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="adapter/docs.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="adapter/firma.js"></SCRIPT>
        <script type="text/javascript" src="adapter/jsp/tree.jsp?qtype=<%=request.getSession().getId()%>"></script>
        <SCRIPT type="text/javascript" src="adapter/ColumnNodeUI.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="adapter/treeSerializer.js"></SCRIPT>
        <SCRIPT type="text/javascript" src="adapter/date.js"></SCRIPT>
		<script type="text/javascript" src="adapter/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="adapter/jquery/jquery-ui.min.js"></script>		



        <script type="text/javascript" src="adapter/ext/ext-all-debug.js"></script>

        <script type="text/javascript" src="charts/pie-chart.jsp"></script>
        <link rel="stylesheet" type="text/css" href="examples/shared/examples.css" />
        <link rel="stylesheet" type="text/css" href="resources/css/ColumnNodeUI.css" />
    </head>
    <BODY id=docs scroll=no>
        <DIV id=loading-mask></DIV>
        <DIV id=loading>
            <div class="loading-indicator"><img src="resources/loading2.gif" width="32" height="32" style="margin-right:8px;float:left;vertical-align:top;"/>Barset - <a href="http://www.barset.com.tr">www.barset.com.tr</a><br /><span id="loading-msg"></span>Sistem yükleniyor...</div>
        </DIV>
        <DIV id=header><A style="FLOAT: right; MARGIN-RIGHT: 10px" href="http://barset.com.tr/"><IMG style="MARGIN-TOP: 1px; WIDTH: 83px; HEIGHT: 24px" src="resources/bgr.gif"></A>
            <DIV class=api-title>
                <%
    /*
    StringBuilder bl = new StringBuilder();
    try{

            System.out.println("Dikkat: " + new Date() );

            ExecProc proc = new ExecProc();

            String[] dat = proc.kartOku("101", "10", "111111111111");

            if( dat == null ){
                out.println("Hata: null" );
            }
            else{
                //{ aboneid, tcno, isim, stok, miktar, kart, mesaj, toplam };
                
                bl.append("aboneid: " + dat[0].trim());
                
                try{
                    bl.append("tcno: " + dat[1].trim());
                }
                catch(Exception e){
                    bl.append("tcno:" + e.getMessage());
                }

                bl.append("isim: " + dat[2].trim());
                bl.append("stok: " + dat[3].trim());
                bl.append("miktar: " + dat[4].trim());
                bl.append("kart: " + dat[5].trim());
                bl.append("mesaj: " + dat[6].trim());
                bl.append("toplam: " + dat[7].trim());
                out.println(bl.toString());
            }
        }
        catch(NullPointerException n){
            System.err.println("Hata: " + new Date() + n.getMessage() + bl.toString() );
            out.println("Hata: " + new Date() + n.getMessage() + bl.toString() );
        }
        catch(Exception ex){
            System.err.println("Hata: " + new Date() + ex.getMessage() );
            out.println("Hata: " + new Date() + ex.getMessage() );
        }
*/

userBean xUser = (userBean)request.getSession().getAttribute("user");
if(xUser != null){
    out.print( "<strong>" + xUser.getFirmaTanim() + "</strong>&nbsp;<span style=\"color:#ff4545;font-size:12px;font-family:\"monotype\",\"courier new\",sans-serif;\">" + xUser.getFirmaAciklama() + "</span>&nbsp;&nbsp;&nbsp;");
}
else{
    out.print("Barset Parkomat Sistemi");
}
%>

                </DIV></DIV>
        <DIV id=classes></DIV>
        <DIV id=main></DIV><SELECT style="DISPLAY: none" id=search-options> <OPTION selected>Starts with</OPTION> <OPTION>Ends with</OPTION> <OPTION>Any Match</OPTION></SELECT>
    </BODY>
</HTML>