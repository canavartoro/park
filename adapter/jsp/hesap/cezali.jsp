<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/hesap/cezali.jsp
 }--%>

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

if ( xUser == null ){
    out.println("{success: false, errors: { reason: 'Login olunmadý!' }}");
    return;
}

boolean success = false;
String strOut = "";
Database dt = null;

String action = request.getParameter("action");

if( action == null ) return;

if( action.trim().startsWith("allceza") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
	
	if(start == null) start = "0";
	if(limit == null) limit = "30";

     x = "select count(id) from cezali  where firma = '" + xUser.getCompany() + "' and bakiye > 0 order by tarih2";       

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
    
	x = "SELECT id, plaka, bakiye, tarih1, tarih2 from cezali where firma = '" + xUser.getCompany() + "' and bakiye > 0 order by tarih2 LIMIT " + start + "," + limit;    
    
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
				output.append(",\"plaka\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"bakiye\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"tarih1\":\"" + data[loop][3].trim() + "\"");
				output.append(",\"tarih2\":\"" + data[loop][4].trim() + "\"");
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
if( action.trim().startsWith("1detaylar") ){
    
	String plaka = request.getParameter("plaka");
    String date1 = request.getParameter("date1");
	String date2 = request.getParameter("date2");
    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
	String where = " where 1 = 1 ";
    if( start == null || start.length() < 1 ) start = "0";
    if( limit == null || limit.length() < 1 ) limit = "30";

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
	
	if( date1 != null && date1.length() > 0 ){
		if( date2 != null || date2.length() > 0 ){
			where += " and date(d.tarih2) BETWEEN date('" + date1 + "') and date('" + date2 + "') ";
		}
		else{
			where += " and date(d.tarih2) = date('" + date1 + "') ";
		}
	}
	else{
		where += " ";
	}	
	
	if( plaka != null || plaka.length() > 0 ){
		where += " and d.plaka = '" + plaka + "' ";
	}
		

    String x = "select d.id, d.fisno, d.kullanici2, concat(p.tanim,' (' ,p.id,')') as peron, concat(a.tanim,' (',a.id,')') as alan, concat(b.tanim,' (',b.id,')') as bolge, concat(t.tanim,' (',t.id,')') as tarife, d.tarih1, d.tarih2, d.psure, d.gsure, d.fiyat  from cezali_detay c inner join peron_detay d on c.refno = d.id inner join peron_tanim p on d.peron = p.id inner join alan_tanim a on p.alan = a.id inner join bolge_tanim b on a.bolge = b.id inner join fiyat_tanim t on d.tarife = t.id " + where + " LIMIT " + start + "," + limit;


    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");
      
        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{"); 
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"fisno\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"kullanici2\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"peron\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"alan\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"tarife\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"tarih1\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"tarih2\":\"" + data[loop][8].trim() + "\"");
			output.append(",\"psure\":\"" + data[loop][9].trim() + "\"");
			output.append(",\"gsure\":\"" + data[loop][10].trim() + "\"");
			output.append(",\"fiyat\":\"" + data[loop][11].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("tahsilat") ){

    String plaka = request.getParameter("p_plaka");
	String tutar = request.getParameter("p_tutar");
	
	if(plaka == null || tutar == null){
		out.println("{success: false, errors: { reason: 'Gerekli bilgiler eksik!' }}");
        return;
	}

    dt = null;
    dt = new Database();

    String x = "Call cezatahsilat('" + xUser.getCompany() + "', '" + xUser.getName() + "','" + plaka + "'," + tutar + ");";
	
	dt.setSql(x);
    if( dt.TInsert() ){
        out.println("{success: true, errors: { reason: 'Kayýt güncellendi.' }}");
        return;
    }
    else{
		out.println("{success: true, errors: { reason: 'Database hatasý:" + dt.getFault()  + ".' }}");
        return;
    }
}
else if( action.trim().startsWith("asil") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "Call cezali_sil('" + xUser.getCompany() + "','" + toDelete + "');";
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
else if( action.trim().startsWith("aexcel") ){

	String after_delete = request.getParameter("after_delete");
	String date1 = request.getParameter("date1");
	String date2 = request.getParameter("date2");
	String where = "";
	
	if( date1 != null || date1.length() > 0 ){
		if( date2 != null || date2.length() > 0 ){
			where = " and date(d.tarih2) BETWEEN date('" + date1 + "') and date('" + date2 + "') ";
		}
		else{
			where = " and date(d.tarih2) = date('" + date1 + "') ";
		}
	}	

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
	String x = "", resp = "";	
	
    x = "select d.fisno, d.plaka, d.kullanici2, concat(p.tanim,' (' ,p.id,')') as peron, concat(a.tanim,' (',a.id,')') as alan, concat(b.tanim,' (',b.id,')') as bolge, d.tarih1, d.tarih2, d.gsure, d.fiyat  from cezali_detay c inner join peron_detay d on c.refno = d.id inner join peron_tanim p on d.peron = p.id inner join alan_tanim a on p.alan = a.id inner join bolge_tanim b on a.bolge = b.id inner join fiyat_tanim t on d.tarife = t.id where d.firma = '" + xUser.getCompany() + "' " + where + " order by d.plaka, d.tarih2, d.peron ";		
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        
        output.append("<BODY><CENTER>");
        output.append("<H4>Cezalý Plakalar " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>FÝÞ NO</TH>");
		output.append("<TH>PLAKA NO</TH>");
        output.append("<TH>KULLANICI</TH>");
        output.append("<TH>PERON</TH>");
        output.append("<TH>ALAN</TH>");
        output.append("<TH>BÖLGE</TH>");
        output.append("<TH>GÝRÝÞ TARÝHÝ</TH>");
        output.append("<TH>ÇIKIÞ TARÝHÝ</TH>");
        output.append("<TH>GEÇEN SÜRE</TH>");
        output.append("<TH>FÝYAT</TH>");
        output.append("</TR>");

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
            output.append("<TD>" + data[row][9].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER><H5>" + resp + "</H5>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Cezalý palaka bulunamadý.</H4>");
        output.append("<H5>" + resp + "/" + dt.getFault() + "</H5>");
        output.append("</CENTER>");
    }
	
	output.append("<H5>" + date1 + "<-->" + date2 + "</H5>");
	//output.append("<H5>" + x + "</H5>");
	output.append("</BODY>");
	
	/*if(after_delete != null && after_delete.startsWith("1") ){
		x = "DELETE FROM cezali_detay WHERE refno IN ( SELECT id FROM cezali WHERE firma = '" + xUser.getCompany() + "' ); DELETE FROM cezali WHERE firma = '" + xUser.getCompany() + "'; ";	
		dt.setSql(x);
		if(!dt.TInsert()){
			resp = "Database hatasý:" + x + "," + dt.getFault();
		}
		else{
			resp = "Liste Silindi.";
		}
	}*/


    out.println(output.toString());


}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
