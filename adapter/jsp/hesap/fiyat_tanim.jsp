<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/hesap/fiyat_tanim.jsp
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

boolean success = false;
String strOut = "";
Database dt = null;

String action = request.getParameter("action");

if( action == null ) return;

if( action.trim().startsWith("allfiyat") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;
    
    String bolge = request.getParameter("bolge");
    String wherebolge = "";
    
    if( bolge != null && bolge.length() > 0 ){
        wherebolge = " and fiyat_detay.bolge = " + bolge;
    }

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");

    if( wherebolge.length() > 0 )
        x = "select count(fiyat_tanim.id) fiyat_tanim inner join fiyat_detay on fiyat_tanim.id = fiyat_detay.tarife where fiyat_tanim.firma = '" + xUser.getCompany() + "' " + wherebolge;
    else
        x = "select count(id) from fiyat_tanim where firma = '" + xUser.getCompany() + "' ";    

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
    if( wherebolge.length() > 0 ){
        x = "SELECT fiyat_tanim.id, fiyat_tanim.kod, fiyat_tanim.tanim, fiyat_tanim.aciklama, fiyat_tanim.sure1, fiyat_tanim.sure2, fiyat_tanim.tolerans, fiyat_tanim.fiyat, fiyat_tanim.sira, fiyat_tanim.ozel_tarife, fiyat_tanim.gunluk, fiyat_tanim.firma, fiyat_tanim.kayit_tarihi, fiyat_tanim.kayit_kullanici, fiyat_tanim.durum FROM fiyat_tanim inner join fiyat_detay on fiyat_tanim.id = fiyat_detay.tarife where fiyat_tanim.firma = '" + xUser.getCompany() + "' " + wherebolge + " order by fiyat_tanim.sure1, fiyat_tanim.sure2, fiyat_tanim.tolerans LIMIT " + start + "," + limit;
        //System.out.println();
    }else{
        x = "SELECT id, kod, tanim, aciklama, sure1, sure2, tolerans, fiyat, sira, ozel_tarife, gunluk, firma, kayit_tarihi, kayit_kullanici, durum FROM fiyat_tanim where firma = '" + xUser.getCompany() + "' order by sure1, sure2, tolerans LIMIT " + start + "," + limit;
    }        
    
	//DATE_FORMAT(bitis_tarihi,'%M %d, %Y %H:%i:%s')    
    
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
				output.append(",\"kod\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"tanim\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"aciklama\":\"" + data[loop][3].trim() + "\"");
				output.append(",\"sure1\":\"" + data[loop][4].trim() + "\"");
				output.append(",\"sure2\":\"" + data[loop][5].trim() + "\"");
				output.append(",\"tolerans\":\"" + data[loop][6].trim() + "\"");
                                output.append(",\"fiyat\":\"" + data[loop][7].trim() + "\"");
				output.append(",\"sira\":\"" + data[loop][8].trim() + "\"");
				output.append(",\"ozel_tarife\":\"" + data[loop][9].trim() + "\"");
                                output.append(",\"gunluk\":\"" + data[loop][10].trim() + "\"");
				output.append(",\"firma\":\"" + data[loop][11].trim() + "\"");
				output.append(",\"kayit_tarihi\":\"" + data[loop][12].trim() + "\"");
				output.append(",\"kayit_kullanici\":\"" + data[loop][13].trim() + "\"");
				output.append(",\"durum\":\"" + data[loop][14].trim() + "\"");
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
    
    String tarife = request.getParameter("tarife");
    String start = request.getParameter("start");
    String limit = request.getParameter("limit");
    if( start == null || start.length() < 1 ) start = "0";
    if( limit == null || limit.length() < 1 ) limit = "30";

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT fiyat_detay.id, fiyat_detay.bolge, bolge_tanim.kod, bolge_tanim.tanim, fiyat_detay.tarife, fiyat_detay.firma, fiyat_detay.durum, fiyat_detay.k_user, fiyat_detay.k_tarih FROM fiyat_detay inner join bolge_tanim on fiyat_detay.bolge = bolge_tanim.id  where fiyat_detay.tarife =  " + tarife + " LIMIT " + start + "," + limit;


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
            output.append(",\"kod\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"tanim\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"tarife\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"firma\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"durum\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"k_user\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"k_tarih\":\"" + data[loop][8].trim() + "\"");
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
else if( action.trim().startsWith("save") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");

    success = false;
    strOut = "";
    long id = 0;
    JSONObject jsonObject = null;
    JSONArray json = null;
    dt = new Database();
    StringBuffer sb;

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
                
                try{
                    id = Long.parseLong(jsonObject.getString("id"));
                }
                catch(Exception e){
                }

                if( id > 0 ){
                    sb = new StringBuffer();
                    sb.append("update fiyat_tanim set kod = '");
                    sb.append(jsonObject.getString("kod"));
                    sb.append("', tanim = '");
                    sb.append(jsonObject.getString("tanim"));
                    sb.append("', aciklama = '");
                    sb.append(jsonObject.getString("aciklama"));
                    sb.append("', sure1 = '");
                    sb.append(jsonObject.getString("sure1"));
                    sb.append("', sure2 = '");
                    sb.append(jsonObject.getString("sure2"));
                    sb.append("', tolerans = '");
                    sb.append(jsonObject.getString("tolerans"));
                    sb.append("', fiyat = '");
                    sb.append(jsonObject.getString("fiyat"));
                    sb.append("', ozel_tarife = ");
                    sb.append(jsonObject.getString("ozel_tarife"));
                    sb.append(", gunluk = ");
                    sb.append(jsonObject.getString("gunluk"));
                    sb.append(", durum = ");
                    sb.append(jsonObject.getString("durum"));
                    sb.append(", sira = '");
                    sb.append(jsonObject.getString("sira"));
                    sb.append("', kod = '");
                    sb.append(jsonObject.getString("kod"));
                    sb.append("' where id = ");
                    sb.append(id);                                        
                    id = 0;
                }
                else{
                    sb = new StringBuffer();
                    sb.append("insert into fiyat_tanim (kod, tanim, aciklama, sure1, sure2, tolerans, fiyat, firma, kayit_tarihi, kayit_kullanici, sira, ozel_tarife, gunluk, durum) values ('");
                    sb.append(jsonObject.getString("kod"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("tanim"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("aciklama"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("sure1"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("sure2"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("tolerans"));
                    sb.append("', '");
                    sb.append(jsonObject.getString("fiyat"));
                    sb.append("', '");
                    sb.append(xUser.getCompany());
                    sb.append("', NOW(), '");
                    sb.append(xUser.getName());
                    sb.append("', '");
                    sb.append(jsonObject.getString("sira"));
                    sb.append("', ");
                    sb.append(jsonObject.getString("ozel_tarife"));
                    sb.append(", ");
                    sb.append(jsonObject.getString("gunluk"));
                    sb.append(", ");
                    sb.append(jsonObject.getString("durum"));
                    sb.append(");");
                }
                
                dt.setSql(sb.toString());
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kayýt güncellendi.";
                    //out.println("{success: true, errors: { reason: 'Kayýt güncellendi.' }}");
                    //return;
                }
                else{
                    success = false;
                    strOut = "Database hatasý:" + dt.getFault() + sb.toString();
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
        strOut = "delete from fiyat_detay where tarife = " + toDelete;
        dt = new Database();
        dt.setSql(strOut);
        dt.TInsert();
        strOut = "delete from fiyat_tanim where id = " + toDelete;
        
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
        strOut = "delete from fiyat_detay where id = " + toDelete;
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
    String xabone = request.getParameter("p_fiyat");
    String xsil = request.getParameter("p_yaz");             

    if( xabone != null && xabone.length() > 0 ){
        dt = new Database();
        
        try{
            if(xsil.equalsIgnoreCase("1")){
                strOut = "delete from fiyat_detay where tarife = " + xabone;
                dt.setSql(strOut);
                dt.TInsert();
            }
            else{		
                /*strOut = "delete from fiyat_detay where tarife = " + xabone;
                dt.setSql(strOut);
                dt.TInsert();*/
                
                strOut = "insert into fiyat_detay (tarife,bolge,firma,k_user) values (" + xabone + "," + alloffdata + ",'" + xUser.getCompany() + "','" + xUser.getName() + "') ";															
                
                dt.setSql(strOut);

                if(!dt.TInsert()){
                    out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "," + dt.getFault() + "' }}");
                    return;
                }
                
                /*String[] alans = alloffdata.split(";");
                long alan = 0;
                
                if( alans != null && alans.length > 0 ){
                    for(int l = 0;l < alans.length;l++){
                        try{
                            alan = Long.parseLong(alans[l].trim());
                        }
                        catch(Exception e){
                            alan = 0;
                        }
                        if( alan > 0 ){
                            strOut = "insert into fiyat_detay (tarife,alan,firma,k_user) values (" + xabone + "," + String.valueOf(alan) + ",'" + xUser.getCompany() + "','" + xUser.getName() + "') ";															
                
                            dt.setSql(strOut);

                            if(!dt.TInsert()){
                                out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "," + dt.getFault() + "' }}");
                                return;
                            }
                            alan = 0;
                        }
                    }
                }       */                         				
                
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
else if( action.trim().startsWith("aexcel") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    String x = "SELECT id, kod, tanim, aciklama, sure1, sure2, tolerans, fiyat, sira, ozel_tarife, kayit_tarihi, kayit_kullanici, durum FROM fiyat_tanim where firma = '" + xUser.getCompany() + "' order by sure1, sure2, tolerans ";		
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        
        output.append("<BODY><CENTER>");
        output.append("<H4>Abone Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>TRIFE</TH>");
        output.append("<TH>KOD</TH>");
        output.append("<TH>TANIM</TH>");
        output.append("<TH>ACIKLAMA</TH>");
        output.append("<TH>SURE (1)</TH>");
        output.append("<TH>SURE (2)</TH>");
        output.append("<TH>TOLERANS</TH>");
        output.append("<TH>FIYAT</TH>");
        output.append("<TH>SIRA</TH>");
        output.append("<TH>OZEL TARIFE</TH>");
        output.append("<TH>KAYIT TARÝHÝ</TH>");
        output.append("<TH>KAYIT KULLANICI</TH>");
        output.append("<TH>DURUM</TH>");
        output.append("</TR>");
//kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici, durum
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
            output.append("<TD>" + data[row][10].trim() + "</TD>");
            output.append("<TD>" + data[row][11].trim() + "</TD>");
            output.append("<TD>" + data[row][12].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Tarife Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
