<%-- 
    Document   : yetki
    Created on : May 10, 2011, 9:53:07 AM
    Author     : Administrator
--%>

<%
String ekle = request.getParameter("ekle");
String sil = request.getParameter("sil");
String duzelt = request.getParameter("duzelt");
if( ekle == null || ekle == "" ) ekle = "true";
if( sil == null || sil == "" ) sil = "true";
if( duzelt == null || duzelt == "" ) duzelt = "true";
if( ekle.equals("false") && duzelt.equals("true") ) duzelt = "false";
%>
