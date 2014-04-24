<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/gunluk.jsp

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

String action = request.getParameter("action");
if( action.trim().startsWith("gunluk") ){

	StringBuilder output = new StringBuilder(); 
	String dateBaslangic = "x", dateBitis = "x", timeBaslangic = "x", timeBitis = "x", stok_tip = "N. EKMEK";
	
    try{
		if ( request.getParameter("baslangic") != null )
			dateBaslangic = request.getParameter("baslangic");
		if ( request.getParameter("bitis") != null )
			dateBitis = request.getParameter("bitis");
		if ( request.getParameter("bass") != null )
			timeBaslangic = request.getParameter("bass");
		if ( request.getParameter("bits") != null )
			timeBitis = request.getParameter("bits");
		if ( request.getParameter("stok_tip") != null )
			stok_tip = request.getParameter("stok_tip");			
		
		dt = new Database();
				
		String x = "SELECT peron_tanim.tanim, peron_detay.aciklama, sum(peron_detay.fiyat) AS miktar, count(peron_detay.aciklama) as adet  "
				+ "FROM peron_detay left outer join peron_tanim on peron_detay.peron = peron_tanim.id  where peron_detay.firma = '" + xUser.getCompany() 				
				+ "'	and ( " 
				+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT('" + dateBaslangic + "', ' ', '" + timeBaslangic + "')  AS DATETIME) AND  " 
				+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT('" + dateBitis + "', ' ', '" + timeBitis + "')  AS DATETIME)        " 
				+ " ) "
				+ " and peron_detay.aciklama = N'"
				+ stok_tip + "' "
				+ "group by peron_detay.peron, peron_detay.aciklama  "
				+ "order by peron_tanim.tanim";

		dt.setSql(x);

		/*if(1==1){
			output.append("{rows:[");
			output.append("{");
			output.append("\"tanim\":\"hata\"");
			output.append(",\"stok\":\"" + x + "\"");
			output.append(",\"miktar\":\" String.valueOf(len) \"");
			output.append(",\"adet\":\"hata\"");
			output.append("}");
			output.append("]}");
			out.println(output.toString());
			return;
		}*/
		
		String[][] data = dt.TSelectAll();
		if ( data != null && data.length > 0 ){
			
			output.append("{rows:[");
			
			for ( int loop = 0; loop < data.length;loop++ ){
				if( loop > 0 )
					output.append(",");
				output.append("{");
				output.append("\"tanim\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"stok\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"miktar\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"adet\":\"" + data[loop][3].trim() + "\"");
				output.append("}");
			}

			output.append("]}");
		}
		
		out.println(output.toString());
		return;
	}
	catch(Exception exc){
        //System.err.println("Sistem hatasi - > " + exc.toString());
		
		output.append("{rows:[");
		output.append("{");
		output.append("\"tanim\":\"hata\"");
		output.append(",\"stok\":\"" + exc.toString() + "\"");
		output.append(",\"miktar\":\" String.valueOf(len) \"");
		output.append(",\"adet\":\"hata\"");
		output.append("}");
		output.append("]}");
		out.println(output.toString());
        return;
    }
}
if( action.trim().startsWith("toplam") ){

    String dateBaslangic = request.getParameter("baslangic");
    String dateBitis = request.getParameter("bitis");
	String timeBaslangic = request.getParameter("bassaat");
	String timeBitis = request.getParameter("bitsaat");
	String stok_tip = "N. EKMEK";
	if ( request.getParameter("stok_tip") != null )
			stok_tip = request.getParameter("stok_tip");

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
			
	String x = "SELECT ifnull(sum(peron_detay.fiyat),0) AS miktar, count(peron_detay.aciklama) as adet  "
            + "FROM peron_detay left outer join peron_tanim on peron_detay.peron = peron_tanim.id  where peron_detay.firma = '" + xUser.getCompany()
            + "' and ( "
            //+ " ( CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) BETWEEN CAST(CONCAT('" + dateBaslangic + "', ' ', '" + timeBaslangic + "')  AS DATETIME) AND CAST(CONCAT('" + dateBitis + "', ' ', '" + timeBitis + "')  AS DATETIME) )     "
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT('" + dateBaslangic + "', ' ', '" + timeBaslangic + "')  AS DATETIME) AND  " 
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT('" + dateBitis + "', ' ', '" + timeBitis + "')  AS DATETIME)        " 
            + ") "
			+ " and peron_detay.aciklama = '"
			+ stok_tip + "' ";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
	
	int i_sum = 0, i_count = 0;        

	try{
		i_sum = Integer.parseInt(data[0][0].trim());
        i_count = Integer.parseInt(data[0][1].trim());
	}
	catch(Exception exc){
		//System.err.println("Sistem hatasi - > " + exc.toString());
		return;
	}
	
    if ( data != null && data.length > 0 ){
        out.println("{success: true, bilgiler: { kart: '" + data[0][1].trim() + "', toplam:'" + data[0][0].trim() + "' }}");
        return;
    } else {
        out.println("{success: false, bilgiler: { kart: '0', toplam:'0' }}");
        return;
    }
}
else if( action.trim().startsWith("_excel") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    String dateBaslangic = request.getParameter("baslangic");
    String dateBitis = request.getParameter("bitis"); 
	String bassaat = request.getParameter("bassaat");
    String bitsaat = request.getParameter("bitsaat"); 
	String stok_tip = "N. EKMEK";
	if ( request.getParameter("stok_tip") != null )
			stok_tip = request.getParameter("stok_tip");

    StringBuilder output = new StringBuilder();
    dt = new Database();
			
	String x = "SELECT peron_tanim.tanim, peron_detay.aciklama, sum(peron_detay.fiyat) AS miktar, count(peron_detay.aciklama) as adet  "
            + "FROM peron_detay left outer join peron_tanim on peron_detay.peron = peron_tanim.id  where peron_detay.firma = '" + xUser.getCompany()
            + "' and ( "            
            //+ " ( CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) BETWEEN CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME) )     "
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND  " 
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME)        " 
            + ") "
			+ " and peron_detay.aciklama = '" + stok_tip + "' "
            + "group by peron_detay.peron, peron_detay.aciklama  "
            + "order by peron_detay.peron";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Günlük Özet Rapor " + dateBaslangic + " ile " + dateBitis + " Arasýndadýr.</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Bufe Adý</TH>");
        output.append("<TH>Verilen</TH>");
        output.append("<TH>Miktar</TH>");
        output.append("<TH>Kart Sayýsý</TH>");
        output.append("</TR><TBODY>");
        int kart_say = 0, top_say = 0, say = 0;

        for( int row = 0;row < data.length;row++ ){
            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + data[row][3].trim() + "</TD>");
            output.append("</TR>");

            try{
                say++;
                kart_say += Integer.parseInt(data[row][3].trim());
                top_say += Integer.parseInt(data[row][2].trim());
            }catch(Exception e){
                System.err.println( "Toplamlar alýnýrken hata:" + e.getMessage());
            }

        }

        output.append("</TBODY><TFOOT><tr>");
        output.append("<td id=\"txt1\" colspan=\"4\" style=\"text-align:right;\"><em>Kart Sayýsý :");
        output.append(kart_say);
        output.append(", Toplam Adet:");
        output.append(top_say);
        output.append(", Toplam Kayýt:");
        output.append(say);
        output.append("</em></td></tr></TFOOT></TABLE></CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Kayýt bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());

    
}
else if( action.trim().startsWith("excel") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    String dateBaslangic = request.getParameter("baslangic");
    String dateBitis = request.getParameter("bitis");
	String bassaat = request.getParameter("bassaat");
    String bitsaat = request.getParameter("bitsaat");
	String stok_tip = "N. EKMEK";
	if ( request.getParameter("stok_tip") != null )
			stok_tip = request.getParameter("stok_tip");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    
    /*String x = "SELECT " + 
		"peron_tanim.tanim AS bufe, " + 
		"CONCAT(abone_tanim.adi,' ',abone_tanim.soyadi) AS isim, " + 
		"abone_tanim.diger1 AS tcno, " + 
		"peron_detay.aciklama AS verilen, " + 
		"peron_detay.fiyat AS miktar, " + 
		"peron_detay.tarih1 as tarih, " + 
		"abone_tanim.plaka AS kart, " + 
		"abone_tanim.bitis_tarihi AS bitis, " + 
		"abone_tanim.deger1 AS abonelik " + 
		"FROM " + 
		"peron_detay " + 
		"Left Outer Join peron_tanim ON peron_detay.peron = peron_tanim.id left outer join abone_tanim on peron_detay.plaka = abone_tanim.plaka " + 
		"where peron_detay.firma = '" + xUser.getCompany() + "' " + 
		"and " + 
		"( " + 
		//"(hour(now()) <= 13) and ( CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) BETWEEN CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME) ) or " +
        //        "((hour(now()) > 13) and ( CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) BETWEEN CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME) )  ) " +		
		" CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND  " +
		" CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME)        "  +
		") " + 
		"order by peron_detay.peron";*/
		
	String x = "SELECT " + 
		"peron_tanim.tanim AS bufe, " + 
		"CONCAT(abone_tanim.adi,' ',abone_tanim.soyadi) AS isim, " + 
		"abone_tanim.diger1 AS tcno, " + 
		"peron_detay.aciklama AS verilen, " + 
		"peron_detay.fiyat AS miktar, " + 
		"peron_detay.tarih1 as tarih, " + 
		"abone_tanim.plaka AS kart, " + 
		"abone_tanim.bitis_tarihi AS bitis, " + 
		"abone_tanim.deger1 AS abonelik " + 
		"FROM " + 
		"peron_detay " + 
		"Left Outer Join peron_tanim ON peron_detay.peron = peron_tanim.id left outer join abone_tanim on peron_detay.plaka = abone_tanim.plaka " + 
		"where peron_detay.firma = '" + xUser.getCompany() + "' " + 
		"and " + 
		"( " + 
		//" ( CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) BETWEEN CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME) )     " +
		" CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT('" + dateBaslangic + "', ' ', '" + bassaat + "')  AS DATETIME) AND  " +
		" CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT('" + dateBitis + "', ' ', '" + bitsaat + "')  AS DATETIME)        "  +
		") " + 
		" and peron_detay.aciklama = '" + stok_tip + "' " +
		"order by peron_detay.peron";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Günlük Detaylý Rapor " + dateBaslangic + " ile " + dateBitis + " Arasýndadýr.</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Bufe</TH>");
        output.append("<TH>Ýsim</TH>");
        output.append("<TH>TC No</TH>");
        output.append("<TH>Verilen</TH>");
        output.append("<TH>Miktar</TH>");
        output.append("<TH>Tarih</TH>");
        output.append("<TH>Kart No</TH>");
        output.append("<TH>Bitis Tarihi</TH>");
        output.append("<TH>Abonelik</TH>");
        output.append("</TR><TBODY>");
        int kart_say = 0, top_say = 0, say = 0;

        for( int row = 0;row < data.length;row++ ){
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
            output.append("</TR>");

            try{
                say++;
                kart_say += Integer.parseInt(data[row][8].trim());
                top_say += Integer.parseInt(data[row][4].trim());
            }catch(Exception e){
                System.err.println( "Toplamlar alýnýrken hata:" + e.getMessage());
            }

        }
        output.append("</TBODY><TFOOT><tr>");
        output.append("<td id=\"txt1\" colspan=\"9\" style=\"text-align:right;\"><em>Toplam Abonelik :");
        output.append(kart_say);
        output.append(", Toplam Adet:");
        output.append(top_say);
        output.append(", Toplam Kayýt:");
        output.append(say);
        output.append("</em></td></tr></TFOOT></TABLE></CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Kayýt bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());

    
}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
