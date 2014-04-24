<%-- 
    Document   : welcome
    Created on : 19.Aðu.2010, 09:56:31
    Author     : huseyin
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page import="org.barset.beans.userBean"%>
<%@page import="org.barset.data.Database"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<DIV id=welcome>
<DIV class=col>
<DIV id=search></DIV></DIV>
<DIV class=col-last>
    
<DIV class=res-block>
<DIV class=res-block-inner>
    <H3 align="center">Sistem Saati</H3>
<!-- EXTRA BLOK BAÞLAR !!! -->
<table width="100%" height="58" border="0" cellpadding="0" cellspacing="0" id="zat" style="border-collapse: collapse;">
    <tr></tr>
    <tr></tr>
    <tr></tr>
    <tr>
        <td width="100%">
    <div align="center">
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="130" height="130">
            <param name="movie" value="resources/clock.swf">
            <param name="quality" value="high"><param name="BGCOLOR" value="#FFFFFF">
            <param name="wmode" value="transparent">
            <embed src="resources/clock.swf" width="130" height="130" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" bgcolor="#FFFFFF" wmode="transparent"></embed></object>
    </div>
</td>
</tr>
</table>
<!-- EXTRA BLOK BÝTER !!! -->

</DIV></DIV>

<DIV class=res-block>
<DIV class=res-block-inner>
    <H3 align="center">Favorilerim</H3>
<UL>
    <%

    response.setCharacterEncoding("windows-1254");
/*
    userBean xUser = (userBean)request.getSession().getAttribute("user");

    if( xUser == null ){
        out.println("null");
    }

    Database dt = new Database();
    String x = "select title, url from favori_listesi where firma = '";
    x += xUser.getCompany();
    x += "' and kullanici = '";
    x += xUser.getID();
    x += "' order by title LIMIT 0, 5 ";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
        for ( int loop = 0; loop < data.length;loop++ ){
            out.println("<LI><A href=\"" + data[loop][1].trim() + "\" target=_blank>" + data[loop][0].trim() + "</A></LI>");
        }
    }
*/
    %>
    <!--
  <LI><A href="#" target=_blank>Günlük Hesap Raporu</A></LI>
  <LI><A href="#" target=_blank>Günlük Hareket Raporu</A></LI>
  <LI><A href="#" target=_blank>Bölge Bazýnda Hesap Raporu</A></LI>
  <LI><A href="#" target=_blank>Borç Sorgulama</A></LI>
  <LI><A href="#" target=_blank>Plaka Sorgulama</A></LI>-->
  <LI><A href="pages/admin/statu.jsp" target=_blank>Admin Panel</A></LI>

  
</UL>
</DIV>
</DIV>

<DIV class=res-block>
<DIV class=res-block-inner>
<H3>Hoþgeldin <%=session.getAttribute("userName")%></H3>
<UL>
  <LI><A href="#" target=_blank>Firma Bilgisi</A>
  
  <LI><A href="parkomat.jar" target=_blank>Parkomat Programý</A>
</LI></UL></DIV></DIV>
<DIV class=res-block>
<DIV class=res-block-inner>
<H3>Ýstatistikler</H3>
<UL style="LIST-STYLE-TYPE: none; MARGIN-LEFT: 0px" id=legend>
  <!--<LI><IMG class="item-icon icon-pkg" src="resources/s.gif">***

  <LI><IMG class="item-icon icon-cls" src="resources/s.gif">***

  <LI><IMG class="item-icon icon-static" src="resources/s.gif">***

  <LI><IMG class="item-icon icon-cmp" src="resources/s.gif">***

  <LI><IMG class="item-icon icon-method" src="resources/s.gif">***

  <LI><IMG class="item-icon icon-prop" src="resources/s.gif">***  

  <LI><IMG class="item-icon icon-event" src="resources/s.gif">***
      -->
  <LI><IMG class="item-icon icon-config" src="resources/s.gif">Bilgi Yok
</LI>
</UL></DIV></DIV></DIV></DIV>


<div id="container-bar" style="left: 10px;top: 10px;position: absolute;"></div>


<div id="container-pie" style="left: 10px;top: 320px;position: absolute;"></div>


<script type="text/javascript">
    Ext.onReady(function(){
        Ext.chart.Chart.CHART_URL = 'resources/charts.swf';
        createChart();
    });
</script>