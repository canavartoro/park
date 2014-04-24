<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/peron_detay.jsp
 }--%>

<%@page import="org.barset.data.ExecProc"%>
<%@page import="org.barset.beans.peronBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
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

String action = request.getParameter("action");

if( action == null ) return;

if( action.trim().startsWith("parac") ){
    
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
    
    if(start == null || start.length() < 1)
        start = "0";
    if(limit == null || limit.length() < 1)
        limit = "30";

    String filters = "";
    String plaka = request.getParameter("plaka");
    String kullanici = request.getParameter("kullanici");
    String alan = request.getParameter("alan");	
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' ";
    if(kullanici != null && kullanici.length() > 0)
        filters += " and peron_detay.kullanici1 like '" + kullanici + "%' ";
    if(alan != null && alan.length() > 0)
        filters += " and alan_tanim.tanim like '" + alan + "%' ";

    x = "SELECT count(id) FROM peron_arac where firma = '" + xUser.getCompany() + "' " + filters;
    
    dt.setSql(x);

    String[] xCount = dt.TSelect();

    if( xCount != null && xCount.length > 0 ){
        try{
            total = Integer.parseInt(xCount[0].replaceAll(";", "").trim());
        }
        catch(Exception ee){
			out.println("{success: false, errors: { reason: 'JSON error: " + ee.getMessage() + "!' }}");
			return;
        }
    }
	//DATE_FORMAT(bitis_tarihi,'%M %d, %Y %H:%i:%s')
    //x = "SELECT id, fisno, kullanici1, peron, peron_tanim, tarife, plaka, aciklama, tarih1, saat1, psure, pdurum, gecen_sure, sure_asimi, alan_tanim, bolge_tanim FROM peron_arac where firma = '" + xUser.getCompany() + "' " + filters + " LIMIT " + start + "," + limit;		

    x = "SELECT peron_detay.id, peron_detay.fisno, peron_detay.kullanici1, peron_detay.peron, peron_tanim.tanim AS peron_tanim, "
            + " peron_detay.tarife, peron_detay.plaka, peron_detay.aciklama, peron_detay.tarih1, peron_detay.saat1, peron_detay.psure, "
            + " peron_detay.pdurum, timestampdiff(MINUTE,peron_detay.tarih1,now()) AS gecen_sure, (timestampdiff(MINUTE,peron_detay.tarih1,now()) - ifnull(peron_detay.psure,0)) AS sure_asimi, "
            + " alan_tanim.tanim AS alan_tanim, bolge_tanim.tanim as bolge_tanim, peron_detay.fiyat FROM "
            + " peron_detay inner join peron_tanim on peron_detay.peron = peron_tanim.id inner join alan_tanim on peron_tanim.alan = alan_tanim.id inner join bolge_tanim on alan_tanim.bolge = bolge_tanim.id "
            + " where peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.tarih2 is null " + filters + " order by bolge_tanim.tanim, alan_tanim.tanim "
            + " LIMIT " + start + "," + limit;
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        try{
			for ( int loop = 0; loop < data.length;loop++ ){
				if( loop > 0 )
					output.append(",");
				output.append("{");          
				output.append("\"id\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"fisno\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"kullanici1\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"peron\":\"" + data[loop][3].trim() + "\"");
				output.append(",\"peron_tanim\":\"" + data[loop][4].trim() + "\"");
				output.append(",\"tarife\":\"" + data[loop][5].trim() + "\"");
				output.append(",\"plaka\":\"" + data[loop][6].trim() + "\"");
				output.append(",\"aciklama\":\"" + data[loop][7].trim() + "\"");
				output.append(",\"tarih1\":\"" + data[loop][8].trim() + "\"");
				output.append(",\"saat1\":\"" + data[loop][9].trim() + "\"");
				output.append(",\"psure\":\"" + data[loop][10].trim() + "\"");
				output.append(",\"pdurum\":\"" + data[loop][11].trim() + "\"");
				output.append(",\"gecen_sure\":\"" + data[loop][12].trim() + "\"");
				output.append(",\"sure_asimi\":\"" + data[loop][13].trim() + "\"");
				output.append(",\"alan_tanim\":\"" + data[loop][14].trim() + "\"");
				output.append(",\"bolge_tanim\":\"" + data[loop][15].trim() + "\"");
                                output.append(",\"fiyat\":\"" + data[loop][16].trim() + "\"");
				output.append("}");
				//output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
			}
		}catch(Exception e){
			out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
			return;
		}

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("exkacak") ){
    
	response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";

    String filters = "";
    String plaka = request.getParameter("plaka");
    String kullanici = request.getParameter("kullanici");
    String alan = request.getParameter("alan");	
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' ";
    if(kullanici != null && kullanici.length() > 0)
        filters += " and peron_detay.kullanici1 like '" + kullanici + "%' ";
    if(alan != null && alan.length() > 0)
        filters += " and alan_tanim.tanim like '" + alan + "%' ";
    
    
    x = "SELECT peron_detay.id, peron_detay.fisno, peron_detay.kullanici1, peron_detay.peron, peron_tanim.tanim AS peron_tanim, "
            + " peron_detay.tarife, peron_detay.plaka, peron_detay.aciklama, peron_detay.tarih1, peron_detay.saat1, peron_detay.psure, "
            + " peron_detay.pdurum, timestampdiff(MINUTE,peron_detay.tarih1,now()) AS gecen_sure, (timestampdiff(MINUTE,peron_detay.tarih1,now()) - ifnull(peron_detay.psure,0)) AS sure_asimi, "
            + " alan_tanim.tanim AS alan_tanim, bolge_tanim.tanim as bolge_tanim, peron_detay.fiyat FROM "
            + " peron_detay inner join peron_tanim on peron_detay.peron = peron_tanim.id inner join alan_tanim on peron_tanim.alan = alan_tanim.id inner join bolge_tanim on alan_tanim.bolge = bolge_tanim.id "
            + " where peron_detay.fiyat > 0 AND peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " order by bolge_tanim.tanim, alan_tanim.tanim ";
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
	if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Kara Liste " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ID</TH>");
        output.append("<TH>FISNO</TH>");
        output.append("<TH>KULLANICI1</TH>");
        output.append("<TH>PERON</TH>");
        output.append("<TH>PERON TANIM</TH>");
        output.append("<TH>TARIFE</TH>");
        output.append("<TH>PLAKA</TH>");
        output.append("<TH>ACIKLAMA Tarihi</TH>");
        output.append("<TH>TARIH1</TH>");
		output.append("<TH>SAAT1</TH>");
		output.append("<TH>PSURE</TH>");
		output.append("<TH>PDURUM</TH>");
		output.append("<TH>GSURE</TH>");
		output.append("<TH>SURE</TH>");
		output.append("<TH>ALAN</TH>");
		output.append("<TH>BOLGE</TH>");
		output.append("<TH>FIYAT</TH>");
        output.append("</TR>");

        for( int row = 0;row < data.length;row++ ){
            x = data[row][4].trim().equals("1") ? "Aktif" : "Pasif";
            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + data[row][3].trim() + "</TD>");
			output.append("<TD>" + data[row][4].trim() + "</TD>");
            output.append("<TD>" + data[row][5].trim() + "</TD>");
            output.append("<TD>" + data[row][6].trim() + "</TD>");
            output.append("<TD>" + data[row][7].trim() + "</TD>");
            output.append("<TD>" + data[row][8].trim() + "</TD>");
			output.append("<TD>" + data[row][9].trim() + "</TD>");
			output.append("<TD>" + data[row][10].trim() + "</TD>");
			output.append("<TD>" + data[row][11].trim() + "</TD>");
			output.append("<TD>" + data[row][12].trim() + "</TD>");
			output.append("<TD>" + data[row][13].trim() + "</TD>");
			output.append("<TD>" + data[row][14].trim() + "</TD>");
			output.append("<TD>" + data[row][15].trim() + "</TD>");
			output.append("<TD>" + data[row][16].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Kara Liste Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }
	out.println(output.toString());
    return;
}
else if( action.trim().startsWith("kacak") ){
    
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
    
    if(start == null || start.length() < 1)
        start = "0";
    if(limit == null || limit.length() < 1)
        limit = "30";

    String filters = "";
    String plaka = request.getParameter("plaka");
    String kullanici = request.getParameter("kullanici");
    String alan = request.getParameter("alan");	
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' ";
    if(kullanici != null && kullanici.length() > 0)
        filters += " and peron_detay.kullanici1 like '" + kullanici + "%' ";
    if(alan != null && alan.length() > 0)
        filters += " and alan_tanim.tanim like '" + alan + "%' ";

    x = "SELECT count(id) FROM peron_detay where firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters;
    
    dt.setSql(x);

    String[] xCount = dt.TSelect();

    if( xCount != null && xCount.length > 0 ){
        try{
            total = Integer.parseInt(xCount[0].replaceAll(";", "").trim());
        }
        catch(Exception ee){
            out.println("{success: false, errors: { reason: 'JSON error: " + ee.getMessage() + "!' }}");
            return;
        }
    }
    
    x = "SELECT peron_detay.id, peron_detay.fisno, peron_detay.kullanici1, peron_detay.peron, peron_tanim.tanim AS peron_tanim, "
            + " peron_detay.tarife, peron_detay.plaka, peron_detay.aciklama, peron_detay.tarih1, peron_detay.saat1, peron_detay.psure, "
            + " peron_detay.pdurum, timestampdiff(MINUTE,peron_detay.tarih1,now()) AS gecen_sure, (timestampdiff(MINUTE,peron_detay.tarih1,now()) - ifnull(peron_detay.psure,0)) AS sure_asimi, "
            + " alan_tanim.tanim AS alan_tanim, bolge_tanim.tanim as bolge_tanim, peron_detay.fiyat FROM "
            + " peron_detay inner join peron_tanim on peron_detay.peron = peron_tanim.id inner join alan_tanim on peron_tanim.alan = alan_tanim.id inner join bolge_tanim on alan_tanim.bolge = bolge_tanim.id "
            + " where peron_detay.fiyat > 0 AND peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " order by bolge_tanim.tanim, alan_tanim.tanim "
            + " LIMIT " + start + "," + limit;
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        try{
			for ( int loop = 0; loop < data.length;loop++ ){
				if( loop > 0 )
					output.append(",");
				output.append("{");          
				output.append("\"id\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"fisno\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"kullanici1\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"peron\":\"" + data[loop][3].trim() + "\"");
				output.append(",\"peron_tanim\":\"" + data[loop][4].trim() + "\"");
				output.append(",\"tarife\":\"" + data[loop][5].trim() + "\"");
				output.append(",\"plaka\":\"" + data[loop][6].trim() + "\"");
				output.append(",\"aciklama\":\"" + data[loop][7].trim() + "\"");
				output.append(",\"tarih1\":\"" + data[loop][8].trim() + "\"");
				output.append(",\"saat1\":\"" + data[loop][9].trim() + "\"");
				output.append(",\"psure\":\"" + data[loop][10].trim() + "\"");
				output.append(",\"pdurum\":\"" + data[loop][11].trim() + "\"");
				output.append(",\"gecen_sure\":\"" + data[loop][12].trim() + "\"");
				output.append(",\"sure_asimi\":\"" + data[loop][13].trim() + "\"");
				output.append(",\"alan_tanim\":\"" + data[loop][14].trim() + "\"");
				output.append(",\"bolge_tanim\":\"" + data[loop][15].trim() + "\"");
                                output.append(",\"fiyat\":\"" + data[loop][16].trim() + "\"");
				output.append("}");
				//output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
			}
		}catch(Exception e){
			out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
			return;
		}

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("exctop") ){
    
	response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
	int row = 0;
	double d = 0;

	String tutar1 = request.getParameter("tutar1");
	String tutar2 = request.getParameter("tutar2");

    String filters = "", having = "";
    String plaka = request.getParameter("plaka");
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' "; 
	if(tutar1 != null && tutar1.length() > 0 && tutar2 != null && tutar2.length() > 0)
        having = " having fiyat between " + tutar1 + " and " + tutar2 + " ";
		
	x = "SELECT count(peron_detay.id) as sayi, peron_detay.plaka, sum(peron_detay.fiyat) as fiyat FROM  " +
		" peron_detay  " +
        " where peron_detay.fiyat > 0 and peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " group by peron_detay.plaka " + having + " order by peron_detay.plaka ";
	
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
	

	output.append("<BODY><CENTER>");
    output.append("<H4>Bölge Tanýmlarý " + utility.getDate() + "</H4>");
    output.append("<TABLE BORDER=1>");
    output.append("<TR>");
    output.append("<TH>ADET</TH>");
    output.append("<TH>PLAKA</TH>");
    output.append("<TH>FIYAT</TH>");
    output.append("</TR>");
	
	for( row = 0;row < data.length;row++ ){
        output.append("<TR>");
        output.append("<TD>" + data[row][0].trim() + "</TD>");
        output.append("<TD>" + data[row][1].trim() + "</TD>");
        output.append("<TD>" + data[row][2].trim() + "</TD>");
        output.append("</TR>");
		d += Double.parseDouble(data[row][2].trim());
    }
    output.append("</TABLE>");
	output.append("<H4>Kayit sayisi.");
	output.append(row);
	output.append("</H4>");
	output.append("<H2>Toplam tutar.");
	output.append(d);
	output.append("</H2>");
    output.append("</CENTER></BODY>");
	
	
    }
	else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Kara Liste Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }

    out.println(output.toString());
    return;
}
else if( action.trim().startsWith("kacaktop") ){
    
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
	String tutar1 = request.getParameter("tutar1");
	String tutar2 = request.getParameter("tutar2");
	String plaka = request.getParameter("plaka");
    
    if(start == null || start.length() < 1)
        start = "0";
    if(limit == null || limit.length() < 1)
        limit = "30";

    String filters = "", having = "";    
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' "; 
	if(tutar1 != null && tutar1.length() > 0 && tutar2 != null && tutar2.length() > 0)
        having = " having fiyat between " + tutar1 + " and " + tutar2 + " ";

	/*System.out.println();
    System.out.println(String.valueOf(id) + ":" + pdurum + ":" + plaka + ":" + String.valueOf(fiyat));*/		
    
    x = "SELECT count(peron_detay.id) as sayi, peron_detay.plaka, sum(peron_detay.fiyat) as fiyat FROM  " +
            " peron_detay  " +
            " where peron_detay.fiyat > 0 and peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " group by peron_detay.plaka " + having + " order by peron_detay.plaka ";            
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
	
		try{
            total = data.length;
        }
        catch(Exception ee){
            out.println("{success: false, errors: { reason: 'JSON error: " + ee.getMessage() + "!' }}");
            return;
        }

	x = "SELECT count(peron_detay.id) as sayi, peron_detay.plaka, sum(peron_detay.fiyat) as fiyat FROM  " +
		" peron_detay  " +
        " where peron_detay.fiyat > 0 and peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " group by peron_detay.plaka " + having + " order by peron_detay.plaka " +            
		" LIMIT " + start + "," + limit;
		
	System.out.println();
    System.out.println(x + ":==:" + having);
		
	dt.setSql(x);
    data = dt.TSelectAll();
	if ( data != null && data.length > 0 ){			

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        try{
			for ( int loop = 0; loop < data.length;loop++ ){
				if( loop > 0 )
					output.append(",");
				output.append("{");          
				output.append("\"sayi\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"plaka\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"fiyat\":\"" + data[loop][2].trim() + "\"");
				output.append("}");
				//output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
			}
		}catch(Exception e){
			out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
			return;
		}
	}
        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("topkacak") ){
    
    
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
	String tutar1 = request.getParameter("tutar1");
	String tutar2 = request.getParameter("tutar2");
	String plaka = request.getParameter("plaka");
    
    if(start == null || start.length() < 1)
        start = "0";
    if(limit == null || limit.length() < 1)
        limit = "30";

    String filters = "", having = "";    
	
    if(plaka != null && plaka.length() > 0)
        filters += " and peron_detay.plaka like '" + plaka + "%' "; 
	if(tutar1 != null && tutar1.length() > 0 && tutar2 != null && tutar2.length() > 0)
        having = " having fiyat between " + tutar1 + " and " + tutar2 + " ";

	/*System.out.println();
    System.out.println(String.valueOf(id) + ":" + pdurum + ":" + plaka + ":" + String.valueOf(fiyat));*/		
    
    x = "SELECT count(peron_detay.id) as sayi, peron_detay.plaka, sum(peron_detay.fiyat) as fiyat FROM  " +
            " peron_detay  " +
            " where peron_detay.fiyat > 0 and peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " group by peron_detay.plaka " + having + " order by peron_detay.plaka ";            
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
	
		try{
            total = data.length;
        }
        catch(Exception ee){
            out.println("{success: false, errors: { reason: 'JSON error: " + ee.getMessage() + "!' }}");
            return;
        }

	x = "SELECT count(peron_detay.id) as sayi, peron_detay.plaka, sum(peron_detay.fiyat) as fiyat FROM  " +
		" peron_detay  " +
        " where peron_detay.fiyat > 0 and peron_detay.firma = '" + xUser.getCompany() + "' and peron_detay.pdurum = 'Tahsil Edilemedi' " + filters + " group by peron_detay.plaka " + having + " order by peron_detay.plaka " +            
		" LIMIT " + start + "," + limit;
		
	System.out.println();
    System.out.println(x + ":==:" + having);
		
	dt.setSql(x);
    data = dt.TSelectAll();
	if ( data != null && data.length > 0 ){			

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        try{
			for ( int loop = 0; loop < data.length;loop++ ){
				if( loop > 0 )
					output.append(",");
				output.append("{");          
				output.append("\"sayi\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"plaka\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"fiyat\":\"" + data[loop][2].trim() + "\"");
				output.append("}");
				//output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
			}
		}catch(Exception e){
			out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
			return;
		}
	}
        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("alanlar") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select bolge_tanim.id as bolge_id, bolge_tanim.tanim as bolge, alan_tanim.id as alan_id, alan_tanim.tanim as alan, peron_tanim.id as peron_id, peron_tanim.tanim as peron FROM bolge_tanim inner join  alan_tanim on bolge_tanim.id = alan_tanim.bolge inner join peron_tanim on alan_tanim.id = peron_tanim.alan " +
            "where bolge_tanim.firma = '" + xUser.getCompany() + "' and bolge_tanim.durum = 1 and alan_tanim.durum = 1 and peron_tanim.durum = 1 " +
            "order by bolge_tanim.tanim, alan_tanim.tanim, peron_tanim.tanim";


    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"bolge_id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"alan_id\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"alan\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"peron_id\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"peron\":\"" + data[loop][5].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("bolgeler") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select bolge_tanim.id as bolge_id, bolge_tanim.tanim as bolge FROM bolge_tanim  " +
            "where bolge_tanim.firma = '" + xUser.getCompany() + "' and bolge_tanim.durum = 1 " +
            "order by bolge_tanim.tanim";


    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"bolge_id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][1].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("tumalanlar") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select bolge_tanim.id as bolge_id, bolge_tanim.tanim as bolge, alan_tanim.id as alan_id, alan_tanim.tanim as alan FROM bolge_tanim inner join  alan_tanim on bolge_tanim.id = alan_tanim.bolge " +
            " where bolge_tanim.firma = '" + xUser.getCompany() + "' and bolge_tanim.durum = 1 and alan_tanim.durum = 1 " +
            " group by bolge_tanim.id, bolge_tanim.tanim, alan_tanim.id, alan_tanim.tanim " + 
			" order by bolge_tanim.tanim, alan_tanim.tanim";


    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"bolge_id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"alan_id\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"alan\":\"" + data[loop][3].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("detay") ){

    String xabone = request.getParameter("abone");

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT  abone_detay.id, bolge_tanim.tanim AS bolge, bolge_tanim.id as bolge_id, alan_tanim.tanim AS alan, alan_tanim.id as alan_id, peron_tanim.tanim as peron, peron_tanim.id as peron_id, abone_detay.kayit_tarihi, abone_detay.kayit_kullanici FROM " +
            "abone_detay inner join  bolge_tanim on abone_detay.bolge = bolge_tanim.id  " +
            "inner join alan_tanim on abone_detay.alan = alan_tanim.id " +
            "inner join peron_tanim on abone_detay.peron = peron_tanim.id " +
            "where abone_detay.abone = '" + xabone + "'";


    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"bolge_id\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"alan\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"alan_id\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"peron\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"peron_id\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][8].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("akayit") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");

    success = false;
    strOut = "";
    JSONObject jsonObject = null;
    JSONArray json = null;

    try{
        json = JSONArray.fromObject( recordsToInsertUpdate );
    }
    catch(Exception e){
        out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
        return;
    }

    if( json != null ){

        String peron, tarife, plaka, aciklama, tarih1, pdurum, fiyat, ids;
        long id = 0;
        java.lang.String[] arac;

        for(int loop = 0;loop < json.size();loop++){

            jsonObject = (JSONObject) JSONSerializer.toJSON(json.getString(loop));

            if( jsonObject != null ){

                dt = new Database();

                try{
                    ids = jsonObject.getString("id");
                    peron = jsonObject.getString("peron");
                    tarife = jsonObject.getString("tarife");
                    plaka = jsonObject.getString("plaka");
                    aciklama = jsonObject.getString("aciklama");
                    tarih1 = jsonObject.getString("tarih1");
                    pdurum = jsonObject.getString("pdurum");
                    fiyat = jsonObject.getString("fiyat");
                    
                    try{
                        id = Long.parseLong(ids.trim());
                    }
                    catch(Exception e){
                    }
                    
                    System.out.println();
                    System.out.println(String.valueOf(id) + ":" + pdurum + ":" + plaka + ":" + String.valueOf(fiyat));
                    
                    if( id < 1 ){
                        
                        peronBean per = new peronBean();
                        per.setFirma(xUser.getCompany());
                        per.setKullaniciID(xUser.getName());
                        per.setPlaka(plaka.trim());
                        per.setTarife("");
                        per.setTolerans(0);
                        per.setTarifeID(Long.parseLong(tarife.trim()));
                        per.setPeronID(Long.parseLong(peron.trim()));
                        per.setDurum(pdurum);
                        per.setFiyat(Double.parseDouble(fiyat.trim()));
                        per.setSure(0);
                        per.setVersiyon(1);

                        arac = per.giris();
                    }
                    else{
                        
                        peronBean per = new peronBean();
                        per.setFirma(xUser.getCompany());
                        per.setHareketID(id);
                        per.setKullaniciID(xUser.getName());
                        per.setDurum(pdurum);
                        per.setFiyat(Double.parseDouble(fiyat.trim()));
                        arac = per.cikis();                         
                    }
                    
                    if( arac != null && arac.length > 0 ){
                        
                        /*if( id > 0 ){                            
                        }
                        else{
                        }*/
                        success = true;
                        strOut = "Kayýt güncellendi.";
                        
                    }
                    else{
                        success = false;
                        strOut = "Database hatasý:" + dt.getFault();
                        break;
                    }
                }
                catch(Exception ee){
                    System.err.println(new Date() + " hata:" + ee.getMessage());
                    out.println("{success: false, errors: { reason: 'Kayýt güncellenemedi.' " + ee.getMessage() + " }}");
                    return;
                }
            }
            else{
                strOut = "JSON dizisi çözülemedi:" + json.getString(0);
            }
        }
    }
    else{
        strOut = "JSON Objesi çözülemedi:" + recordsToInsertUpdate;
    }

    out.println("{success: " + String.valueOf(success) + ", errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("dkayit") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");

    success = false;
    strOut = "";
    JSONObject jsonObject = null;
    JSONArray json = null;

    try{
        json = JSONArray.fromObject( recordsToInsertUpdate );
    }
    catch(Exception e){
        out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
        return;
    }

    if( json != null ){

        String ids;
        long id = 0;
        java.lang.String[] arac;
        ExecProc proc = new ExecProc();

        for(int loop = 0;loop < json.size();loop++){

            jsonObject = (JSONObject) JSONSerializer.toJSON(json.getString(loop));

            if( jsonObject != null ){

                dt = new Database();

                try{
                    ids = jsonObject.getString("id");
                    
                    try{
                        id = Long.parseLong(ids.trim());
                    }
                    catch(Exception e){
                    }
                    
                    if( id > 1 ){
                        arac = proc.tahsilat(xUser.getCompany(), xUser.getName(), String.valueOf(id));                                                
                    }
                    else{
                        arac = null;
                    }
                    
                    if( arac != null && arac.length > 0 ){
                        
                        /*if( id > 0 ){                            
                        }
                        else{
                        }*/
                        success = true;
                        strOut = "Kayýt güncellendi.";
                        
                    }
                    else{
                        success = false;
                        strOut = "Database hatasý:" + dt.getFault();
                        break;
                    }
                }
                catch(Exception ee){
                    System.err.println(new Date() + " hata:" + ee.getMessage());
                    out.println("{success: false, errors: { reason: 'Kayýt güncellenemedi.' " + ee.getMessage() + " }}");
                    return;
                }
            }
            else{
                strOut = "JSON dizisi çözülemedi:" + json.getString(0);
            }
        }
    }
    else{
        strOut = "JSON Objesi çözülemedi:" + recordsToInsertUpdate;
    }

    out.println("{success: " + String.valueOf(success) + ", errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("save2") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");

    success = false;
    strOut = "";
    JSONObject jsonObject = null;
    JSONArray json = null;

    try{
        json = JSONArray.fromObject( recordsToInsertUpdate );
    }
    catch(Exception e){
        out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
        return;
    }

    if( json != null ){

        for(int loop = 0;loop < json.size();loop++){

            jsonObject = (JSONObject) JSONSerializer.toJSON(json.getString(loop));

            if( jsonObject != null ){

                dt = new Database();

                String xQuery = "Call yenialan('";
                xQuery += jsonObject.getString("kod");
                xQuery += "', '";
                xQuery += jsonObject.getString("tanim");
                xQuery += "', '";
                xQuery += jsonObject.getString("aciklama");
                xQuery += "', ";
                xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                xQuery += ", '";
                xQuery += jsonObject.getString("bolge");
                xQuery += "', '";
                xQuery += xUser.getName();
                xQuery += "')";

                dt.setSql(xQuery);
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kayýt güncellendi.";
                    //out.println("{success: true, errors: { reason: 'Kayýt güncellendi.' }}");
                    //return;
                }
                else{
                    success = false;
                    strOut = "Database hatasý:" + dt.getFault() + xQuery;
                    break;
                }
            }
            else{
                strOut = "JSON dizisi çözülemedi:" + json.getString(0);
            }
        }
    }
    else{
        strOut = "JSON Objesi çözülemedi:" + recordsToInsertUpdate;
    }

    out.println("{success: " + String.valueOf(success) + ", errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("asil") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from peron_detay where id = " + toDelete;
        dt = new Database();
        dt.setSql(strOut);
        if(!dt.TInsert()){
            out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "' }}");
            return;
        }
        else{
            out.println("{success: true, errors: { reason: 'Kayýt Silindi!' }}");
            return;
        }
    }

    out.println("{success: false, errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("dsil") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from abone_detay where id = " + toDelete;
        dt = new Database();
        dt.setSql(strOut);
        if(!dt.TInsert()){
            out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "' }}");
            return;
        }
        else{
            out.println("{success: true, errors: { reason: 'Kayýt Silindi!' }}");
            return;
        }
    }

    out.println("{success: false, errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("edetay") ){

    String alloffdata = request.getParameter("p_alloff");
	String xabone = request.getParameter("p_abone");
    String xsil = request.getParameter("p_yaz");

    if( xabone != null && xabone.length() > 0 ){
        dt = new Database();
		
		try{
			if(xsil.equalsIgnoreCase("1")){
				strOut = "delete from abone_detay where abone = " + xabone;
				dt.setSql(strOut);
				dt.TInsert();
			}
			else{						
			
				strOut = "delete from abone_detay where abone = " + xabone;
				dt.setSql(strOut);
				dt.TInsert();	
				
				String[] linePar = null;

				if( alloffdata != null && alloffdata.indexOf(">") != -1  ){
					linePar = alloffdata.split(">");
					
					/*if ( 1 == 1 ) {
						out.println("{success: false, errors: { reason: 'sql error: " + String.valueOf(linePar[1]) + "/," + alloffdata + "!' }}");
						return;
					}*/
					
				}
				else {
					linePar = new String[]{ alloffdata };
				}					
				
				String[] dataPar = null;
				
				if( linePar != null && linePar.length > 0 ){								
					
					for( int i = 0 ; i < linePar.length ; i++){										
					
						if( linePar[i] != null && linePar[i].length() > 0 && linePar[i].indexOf(";") != -1 ){
						
							dataPar = linePar[i].split(";");
							
							if( dataPar != null && dataPar.length > 0 ){														
							
								strOut = "insert into abone_detay (abone,bolge,alan,peron,kayit_kullanici) values (" + xabone + "," + dataPar[0] + "," + dataPar[1] + "," + dataPar[2] + ", N'" + xUser.getID() + "') ";															
								
								dt.setSql(strOut);
								if(!dt.TInsert()){
									out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "," + dt.getFault() + "' }}");
									return;
								}
							
							}
						
						}
					  
					}
					
				}	
			}
        }
        catch(Exception ee){
			out.println("{success: false, errors: { reason: 'sql error: " + ee.getMessage() + "," + dt.getFault() + "!' }}");
			return;
        }		       
        		        			
        out.println("{success: true, errors: { reason: 'Kayýt tamamlandý!' }}");
        return;

    }

    out.println("{success: false, errors: { reason: '" + strOut + "!' }}");
    return;

}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
