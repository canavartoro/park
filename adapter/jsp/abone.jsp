<%--{
Solution Developer
29 A�ustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/abone.jsp
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

if( action.trim().startsWith("abone") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();
    String x = "";
    int total = 0;

    String start = request.getParameter("start");
    String limit = request.getParameter("limit");

    String filters = "";
    String bitis = request.getParameter("bitis");
    String adi = request.getParameter("adi");
    String soyadi = request.getParameter("soyadi");
    String ozel = request.getParameter("ozel");
    String metin1 = request.getParameter("metin1");	
	
    if(bitis != null && bitis.length() > 0)
        filters += " and bitis_tarihi = '" + bitis + "' ";
    if(adi != null && adi.length() > 0)
        filters += " and adi like '" + adi + "%' ";
    if(soyadi != null && soyadi.length() > 0)
        filters += " and soyadi like '" + soyadi + "%' ";
    if(ozel != null && ozel.length() > 0)
        filters += " and plaka like '" + ozel + "%' ";
    if(metin1 != null && metin1.length() > 0)
        filters += " and diger1 like '" + metin1 + "%' ";

    x = "SELECT count(abone) FROM abone_tanim where firma = '" + xUser.getCompany() + "' " + filters;

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
    x = "SELECT abone,  sqlTemizle(adi) as adi, sqlTemizle(soyadi) as soyadi, plaka, bitis_tarihi as bitis_tarihi, firma, sqlTemizle(diger1) as diger1, sqlTemizle(diger2) as diger2, diger3, deger1, deger2, deger3, tarih1, tarih2, tarih3, kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici, durum FROM abone_tanim where firma = '" + xUser.getCompany() + "' " + filters + " LIMIT " + start + "," + limit;		
	
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
				output.append("\"abone\":\"" + data[loop][0].trim() + "\"");
				output.append(",\"adi\":\"" + data[loop][1].trim() + "\"");
				output.append(",\"soyadi\":\"" + data[loop][2].trim() + "\"");
				output.append(",\"plaka\":\"" + data[loop][3].trim() + "\"");
				output.append(",\"bitis_tarihi\":\"" + data[loop][4].trim() + "\"");
				output.append(",\"firma\":\"" + data[loop][5].trim() + "\"");
				output.append(",\"diger1\":\"" + data[loop][6].trim() + "\"");
				output.append(",\"diger2\":\"" + data[loop][7].trim() + "\"");
				output.append(",\"diger3\":\"" + data[loop][8].trim() + "\"");
				output.append(",\"deger1\":\"" + data[loop][9].trim() + "\"");
				output.append(",\"deger2\":\"" + data[loop][10].trim() + "\"");
				output.append(",\"deger3\":\"" + data[loop][11].trim() + "\"");
				output.append(",\"tarih1\":\"" + data[loop][12].trim() + "\"");
				output.append(",\"tarih2\":\"" + data[loop][13].trim() + "\"");
				output.append(",\"tarih3\":\"" + data[loop][14].trim() + "\"");
				output.append(",\"kayit_tarihi\":\"" + data[loop][15].trim() + "\"");
				output.append(",\"kayit_kullanici\":\"" + data[loop][16].trim() + "\"");
				output.append(",\"update_tarihi\":\"" + data[loop][17].trim() + "\"");
				output.append(",\"update_kullanici\":\"" + data[loop][18].trim() + "\"");
				output.append(",\"durum\":\"" + data[loop][19].trim() + "\"");
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
if( action.trim().startsWith("alanlar") ){

	String bolge = request.getParameter("bolge");
	String alan = request.getParameter("alan");

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select bolge_tanim.id as bolge_id, bolge_tanim.tanim as bolge, alan_tanim.id as alan_id, alan_tanim.tanim as alan, peron_tanim.id as peron_id, peron_tanim.tanim as peron FROM bolge_tanim inner join  alan_tanim on bolge_tanim.id = alan_tanim.bolge inner join peron_tanim on alan_tanim.id = peron_tanim.alan " +
            "where bolge_tanim.firma = '" + xUser.getCompany() + "' and bolge_tanim.durum = 1 and alan_tanim.durum = 1 and peron_tanim.durum = 1 ";
	if(bolge != null && bolge.length() > 0)
		x += " and  bolge_tanim.id = " + bolge;
	if(alan != null && alan.length() > 0)
		x += " and  alan_tanim.id = " + alan;
    x += " order by bolge_tanim.id, alan_tanim.id, peron_tanim.id";


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

	String bolge = request.getParameter("bolge");

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select bolge_tanim.id as bolge_id, bolge_tanim.tanim as bolge, alan_tanim.id as alan_id, alan_tanim.tanim as alan FROM bolge_tanim inner join  alan_tanim on bolge_tanim.id = alan_tanim.bolge " +
            " where bolge_tanim.firma = '" + xUser.getCompany() + "' and bolge_tanim.durum = 1 and alan_tanim.durum = 1 ";
	if(bolge != null && bolge.length() > 0)
		x += " and  bolge_tanim.id = " + bolge;
    x += " group by bolge_tanim.id, bolge_tanim.tanim, alan_tanim.id, alan_tanim.tanim " + 
			" order by bolge_tanim.id, alan_tanim.id";


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

        String t1, t2, t3, s1, s2, s3;

        for(int loop = 0;loop < json.size();loop++){

            jsonObject = (JSONObject) JSONSerializer.toJSON(json.getString(loop));

            if( jsonObject != null ){

                dt = new Database();

                try{
                    t1 = jsonObject.getString("tarih1");
                    t2 = jsonObject.getString("tarih2");
                    t3 = jsonObject.getString("tarih3");
                    s1 = jsonObject.getString("deger1");
                    s2 = jsonObject.getString("deger2");
                    s3 = jsonObject.getString("deger3");									

                    String xQuery = "Call yeniabone('";
                    xQuery += jsonObject.getString("abone");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("adi");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("soyadi");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("plaka");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("bitis_tarihi");
                    xQuery += "', '";
                    xQuery += xUser.getCompany();
                    xQuery += "', '";
                    xQuery += jsonObject.getString("diger1");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("diger2");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("diger3");
                    xQuery += "', ";
                    xQuery += s1.length() > 0 ? s1 : "0";
                    xQuery += ", ";
                    xQuery += s2.length() > 0 ? s2 : "0";
                    xQuery += ", ";
                    xQuery += s3.length() > 0 ? s3 : "0";
                    xQuery += ", ";					
					xQuery += (t1.length() > 0 && !t1.equalsIgnoreCase("null")) ? "'" + t1 + "'" : "null";					                   
                    xQuery += ", ";
                    xQuery += (t2.length() > 0 && !t2.equalsIgnoreCase("null")) ? "'" + t2 + "'" : "null";
                    xQuery += ", ";
                    xQuery += (t3.length() > 0 && !t3.equalsIgnoreCase("null")) ? "'" + t3 + "'" : "null";
                    xQuery += ", '";
                    xQuery += xUser.getName();
                    xQuery += "', ";
                    xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                    xQuery += ")";

                    dt.setSql(xQuery);
                    if( dt.TInsert() ){
                        success = true;
                        strOut = "Kay�t g�ncellendi.";
                        //out.println("{success: true, errors: { reason: 'Kay�t g�ncellendi.' }}");
                        //return;
                    }
                    else{
                        success = false;
                        strOut = "Database hatas�:" + dt.getFault() + xQuery;
                        break;
                    }
                }
                catch(Exception ee){
                    System.err.println(new Date() + " hata:" + ee.getMessage());
					out.println("{success: false, errors: { reason: 'Kay�t g�ncellenemedi.' " + ee.getMessage() + " }}");
                    return;
                }
            }
            else{
                strOut = "JSON dizisi ��z�lemedi:" + json.getString(0);
            }
        }
    }
    else{
        strOut = "JSON Objesi ��z�lemedi:" + recordsToInsertUpdate;
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
                    strOut = "Kay�t g�ncellendi.";
                    //out.println("{success: true, errors: { reason: 'Kay�t g�ncellendi.' }}");
                    //return;
                }
                else{
                    success = false;
                    strOut = "Database hatas�:" + dt.getFault() + xQuery;
                    break;
                }
            }
            else{
                strOut = "JSON dizisi ��z�lemedi:" + json.getString(0);
            }
        }
    }
    else{
        strOut = "JSON Objesi ��z�lemedi:" + recordsToInsertUpdate;
    }

    out.println("{success: " + String.valueOf(success) + ", errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("asil") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from abone_tanim where abone = " + toDelete;
        dt = new Database();
        dt.setSql(strOut);
        if(!dt.TInsert()){
            out.println("{success: false, errors: { reason: 'Database hatas�:" + strOut + "' }}");
            return;
        }
        else{
            out.println("{success: true, errors: { reason: 'Kay�t Silindi!' }}");
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
            out.println("{success: false, errors: { reason: 'Database hatas�:" + strOut + "' }}");
            return;
        }
        else{
            out.println("{success: true, errors: { reason: 'Kay�t Silindi!' }}");
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
	int Id = 0;

    if( xabone != null && xabone.length() > 0 ){
        dt = new Database();
		
		try{
			if(xsil.equalsIgnoreCase("1")){
				strOut = "delete from abone_detay where abone = " + xabone;
				dt.setSql(strOut);
				dt.TInsert();
			}
			else{						
			
				/*strOut = "delete from abone_detay where abone = " + xabone;
				dt.setSql(strOut);
				dt.TInsert();*/	
				
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
							
								strOut = "insert into abone_detay (abone,bolge,alan,peron,kayit_kullanici) values (" + xabone + "," + dataPar[0] + "," + dataPar[1] + "," + dataPar[2] + ", N'" + xUser.getName() + "') ";															
								
								dt.setSql(strOut);
								if(!dt.TInsert()){
									out.println("{success: false, errors: { reason: 'Database hatas�:" + strOut + "," + dt.getFault() + "' }}");
									return;
								}
							
							}
						
						}
						else{
							try{
								Id = Integer.parseInt(linePar[i].replaceAll(";", "").trim());
								if(Id > 0){
								
									strOut = "insert into  abone_detay (abone,bolge,alan,peron,kayit_kullanici) select " + xabone + " as abone,a.bolge as bogle,a.id as alan,p.id as peron, '" + xUser.getName() + "' as kayit_kullanici from alan_tanim a inner join peron_tanim p on a.id = p.alan where a.bolge = " + String.valueOf(Id);															
								
									dt.setSql(strOut);
									if(!dt.TInsert()){
										out.println("{success: false, errors: { reason: 'Database hatas�:" + strOut + "," + dt.getFault() + "' }}");
										return;
									}
								}
							}
							catch(Exception ee){
								out.println("{success: false, errors: { reason: 'JSON error: " + ee.getMessage() + "!' }}");
								return;
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
        		        			
        out.println("{success: true, errors: { reason: 'Kay�t tamamland�!' }}");
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
    String x = "SELECT abone, adi, soyadi, plaka, bitis_tarihi, diger1, diger2, diger3, deger1, deger2, deger3, tarih1, tarih2, tarih3, kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici, durum FROM abone_tanim where firma = '" + xUser.getCompany() + "'";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        
        output.append("<BODY><CENTER>");
        output.append("<H4>Abone Tan�mlar� " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ABONE</TH>");
        output.append("<TH>ADI</TH>");
        output.append("<TH>SOYADI</TH>");
        output.append("<TH>�ZELKOD</TH>");
        output.append("<TH>B�T�� TAR�H�</TH>");
        output.append("<TH>MET�N(1)</TH>");
        output.append("<TH>MET�N(2)</TH>");
        output.append("<TH>MET�N(3)</TH>");
        output.append("<TH>SAYI(1)</TH>");
        output.append("<TH>SAYI(2)</TH>");
        output.append("<TH>SAYI(3)</TH>");
        output.append("<TH>TAR�H(1)</TH>");
        output.append("<TH>TAR�H(2)</TH>");
        output.append("<TH>TAR�H(3)</TH>");
        output.append("<TH>KAYIT TAR�H�</TH>");
        output.append("<TH>KAYIT KULLANICI</TH>");
        output.append("<TH>G�NCELLEME TAR�H�</TH>");
        output.append("<TH>G�NCELEME KULLANICI</TH>");
        output.append("<TH>DURUM</TH>");
        output.append("</TR>");
//kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici, durum
        for( int row = 0;row < data.length;row++ ){
            x = data[row][18].trim().equals("1") ? "Aktif" : "Pasif";
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
            output.append("<TD>" + data[row][17].trim() + "</TD>");
            output.append("<TD>" + x + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Abone Kayd� bulunamad�.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else if( action.trim().startsWith("excel2") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    String x = "select  a.id, a.kod, a.tanim, a.aciklama, b.kod, b.tanim, a.durum, a.bolge, a.kayit_tarihi, a.kayit_kullanici, a.update_tarihi, a.update_kullanici from bolge_tanim b inner join alan_tanim a on b.id = a.bolge where firma = '" + xUser.getCompany() + "'  order by a.bolge, a.kod, a.tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Alan Tan�mlar� " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ID</TH>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Tan�m</TH>");
        output.append("<TH>A��klama</TH>");
        output.append("<TH>B�lge Kod</TH>");
        output.append("<TH>B�lge Tan�m</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kay�t Tarihi</TH>");
        output.append("<TH>Kay�t Kullan�c�</TH>");
        output.append("<TH>G�ncelleme Tarihi</TH>");
        output.append("<TH>G�ncelleyen Kullan�c�</TH>");
        output.append("</TR>");

        for( int row = 0;row < data.length;row++ ){
            x = data[row][6].trim().equals("1") ? "Aktif" : "Pasif";
            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + data[row][3].trim() + "</TD>");
            output.append("<TD>" + data[row][4].trim() + "</TD>");
            output.append("<TD>" + data[row][5].trim() + "</TD>");
            output.append("<TD>" + x + "</TD>");
            output.append("<TD>" + data[row][7].trim() + "</TD>");
            output.append("<TD>" + data[row][8].trim() + "</TD>");
            output.append("<TD>" + data[row][9].trim() + "</TD>");
            output.append("<TD>" + data[row][10].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Alan Kayd� bulunamad�.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
