<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/rapor/rapor.jsp
[Þablon olarak kullanýlacak.]
 }--%>

<%@page import="org.barset.util.utility"%>
<%@page import="net.sf.json.util.PropertyFilter"%>
<%@page import="net.sf.json.JSON"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JsonConfig"%>
<%@page import="net.sf.json.JSONSerializer"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.barset.beans.userBean"%>
<%@page language="java" session="true" %>
<%@page import="javax.servlet.http.HttpSession" %>
<%@page import="org.barset.data.Database"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%
//response.setContentType("application/json");
userBean xUser = (userBean)request.getSession().getAttribute("user");

boolean success = false;
String strOut = "";
Database dt = null;
StringBuilder output = null;

String action = request.getParameter("action");
if( action.trim().startsWith("psor") ){

    String xplaka = request.getParameter("plaka");	


    String x = "SELECT d.tarih1, d.tarih2, d.fiyat, CONCAT(p.tanim, ' ', p.id) as peron, d.fisno from peron_detay as d INNER JOIN peron_tanim as p ON d.peron = p.id  " +
				" WHERE d.plaka = '" + xplaka + "' AND d.pdurum = 'Tahsil Edilemedi' AND d.fiyat > 0 AND d.firma = '" + xUser.getCompany() + "'";
				
	dt = new Database();
	output = new StringBuilder();
             
	dt.setSql(x);

    output.append(dt.TSelectHTML());
    output.append(dt.getFault());

    out.println(output.toString());
    return;
}
if( action.trim().startsWith("hsor") ){

    String xplaka = request.getParameter("plaka");	


    String x = "SELECT d.fisno, CONCAT(b.tanim, ' ', b.id) AS bolge, CONCAT(a.tanim, ' ', a.id) AS alan, CONCAT(p.tanim, ' ', p.id) AS peron, " +
				" d.kullanici1 AS girisyapan, d.kullanici2 AS tahsileden, d.fiyat, d.gsure as gecensure, d.tarih1 as giristarihi, d.tarih2 as cikistarihi, " +
				" d.pdurum as durum FROM peron_detay AS d INNER JOIN peron_tanim AS p ON d.peron = p.id  " +
				" INNER JOIN alan_tanim AS a ON p.alan = a.id INNER JOIN bolge_tanim AS b ON a.bolge = b.id  " +
				" INNER JOIN fiyat_tanim AS f ON d.tarife = f.id " +
				" WHERE d.plaka = '" + xplaka + "' and d.firma = '" + xUser.getCompany() + "' ORDER BY d.id ";
				
	dt = new Database();
	output = new StringBuilder();
             
	dt.setSql(x);

    output.append(dt.TSelectHTML());
    output.append(dt.getFault());

    out.println(output.toString());
    return;
}
else{
    out.println("Bilgiler eksik!'");
}
%>
