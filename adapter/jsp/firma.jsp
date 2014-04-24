<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/firma.jsp
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
int index = 0;

String action = request.getParameter("action");
if( action.trim().startsWith("firma") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT firma_tanim.kod, firma_tanim.tanim, firma_tanim.aciklama, firma_tanim.bakiye, firma_tanim.versiyon, firma_tanim.fisno, firma_tanim.ot_giris, firma_tanim.ot_transfer, firma_tanim.cezali, firma_tanim.vergi_no, firma_tanim.vergi_daire, firma_tanim.durum, firma_tanim.kayit_tarihi, firma_tanim.kayit_kullanici, firma_tanim.update_tarih, firma_tanim.update_kullanici FROM firma_tanim ORDER BY firma_tanim.tanim ";    

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");
		
        for ( int loop = 0; loop < data.length;loop++ ){
			index = 0;
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"kod\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"tanim\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"aciklama\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"bakiye\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"versiyon\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"fisno\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"ot_giris\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"ot_transfer\":\"" + data[loop][index].trim() + "\""); index++;
			output.append(",\"cezali\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"vergi_no\":\"" + data[loop][index].trim() + "\""); index++;
			output.append(",\"vergi_daire\":\"" + data[loop][index].trim() + "\""); index++;
			output.append(",\"durum\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"kayit_tarihi\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"kayit_kullanici\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"update_tarih\":\"" + data[loop][index].trim() + "\""); index++;
            output.append(",\"update_kullanici\":\"" + data[loop][index].trim() + "\""); index++;
            output.append("}");
            //output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    else{
        %>
        {
        rows:[
            {
                "kod":"1",
                "tanim":"<%=dt.getFault()%>",
                "sort_order":"0"
            },{
                "kod":"2",
                "tanim":"Drama",
                "sort_order":"1"
            }]
       }
        <%
}
}
else if( action.trim().startsWith("login") ){    

    String frm = request.getParameter("xfirma");
    String usr = request.getParameter("fldusername");
    String psw = request.getParameter("fldpassword");
    if( frm != "" && usr != "" ){

        userBean user = new userBean();
        user.setID(usr);
        user.setPassword(psw);
        user.setCompany(frm);
        if( user.userLogin() ){
            request.getSession().setAttribute("user", user);
            request.getSession().setAttribute("userFirma", frm);
            request.getSession().setAttribute("userName", usr);
            out.println("{success: true}");
            return;
        }
    }
    out.println("{success: false, errors: { reason: 'Kullanýcý adý ve þifre hatalý!' }}");
    return;
}
else if( action.trim().startsWith("out") ){
    request.getSession().removeAttribute("xfirma");
    request.getSession().removeAttribute("fldusername");
    response.sendRedirect("../do.jsp");
}
else if( action.trim().startsWith("save") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");

    /*
    json-lib-2.3-jdk15
    Json-lib requires (at least) the following dependencies in your classpath:

    •jakarta commons-lang 2.4
    •jakarta commons-beanutils 1.7.0
    •jakarta commons-collections 3.2
    •jakarta commons-logging 1.1.1
    •ezmorph 1.0.6
    */        

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

                String xQuery = "Call yenifirma('";
                xQuery += jsonObject.getString("kod");
                xQuery += "', '";
                xQuery += jsonObject.getString("tanim");
                xQuery += "', '";
                xQuery += jsonObject.getString("aciklama");
                xQuery += "', '";
                xQuery += jsonObject.getString("bakiye");
                xQuery += "', '";
                xQuery += jsonObject.getString("versiyon");
                xQuery += "', '";
                xQuery += jsonObject.getString("fisno");
                xQuery += "', ";
                xQuery += jsonObject.getString("ot_giris");             
                xQuery += ", ";
                xQuery += jsonObject.getString("ot_transfer");
				xQuery += ", ";
                xQuery += jsonObject.getString("cezali");
				xQuery += ", '";
                xQuery += jsonObject.getString("vergi_no");
				xQuery += "', '";
                xQuery += jsonObject.getString("vergi_daire");				
                xQuery += "', ";
                xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                xQuery += ", '";
                xQuery += xUser.getName();
                xQuery += "')";
                
                System.out.println(xQuery);
				
				/*if(1==1){
					out.println("{success: false, errors: { reason: 'de:" + xQuery + "!' }}");
					return;
				}*/

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
else if( action.trim().startsWith("delete") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from firma_tanim where kod = '" + toDelete + "'";
        dt = new Database();
        dt.setSql(strOut);
        if(!dt.TInsert()){
            out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "' }}");
            return;
        }
        else{
            strOut = "delete from kullanici_tanim where firma = '" + toDelete + "'";
            dt = new Database();
            dt.setSql(strOut);
            dt.TInsert();
            strOut = "delete from abone_detay where abone in (select abone from abone_tanim where firma = '" + toDelete + "')";
            dt = new Database();
            dt.setSql(strOut);
            dt.TInsert();
            strOut = "delete from abone_tanim where firma = '" + toDelete + "'";
            dt = new Database();
            dt.setSql(strOut);
            dt.TInsert();
            out.println("{success: true, errors: { reason: 'Kayýt Silindi!' }}");
            return;
        }
    }

    out.println("{success: false, errors: { reason: '" + strOut + "!' }}");
    return;

}
else if( action.trim().startsWith("excel") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    String ot_transfer = "", ot_giris = "";
    String x = "SELECT firma_tanim.kod, firma_tanim.tanim, firma_tanim.aciklama, firma_tanim.bakiye, firma_tanim.versiyon, firma_tanim.fisno, firma_tanim.ot_transfer, firma_tanim.ot_giris, firma_tanim.durum, firma_tanim.kayit_tarihi, firma_tanim.kayit_kullanici, firma_tanim.update_tarih, firma_tanim.update_kullanici FROM firma_tanim ORDER BY firma_tanim.tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Firma Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Taným</TH>");
        output.append("<TH>Açýklama</TH>");
        output.append("<TH>Bakiye</TH>");
        output.append("<TH>Versiyon</TH>");
        output.append("<TH>Fiþ No</TH>");
        output.append("<TH>Otomatik Transfer</TH>");
        output.append("<TH>Otomatik Giriþ</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kayýt Tarihi</TH>");
        output.append("<TH>Kayýt Kullanýcý</TH>");
        output.append("<TH>Güncelleme Tarihi</TH>");
        output.append("<TH>Güncelleyen Kullanýcý</TH>");
        output.append("</TR>");

        for( int row = 0;row < data.length;row++ ){
            ot_transfer = data[row][6].trim().equals("1") ? "Evet" : "Hayir";
            ot_giris = data[row][7].trim().equals("1") ? "Evet" : "Hayir";
            x = data[row][8].trim().equals("1") ? "Aktif" : "Pasif";
            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + data[row][3].trim() + "</TD>");
            output.append("<TD>" + data[row][4].trim() + "</TD>");
            output.append("<TD>" + data[row][5].trim() + "</TD>");
            output.append("<TD>" + ot_transfer + "</TD>");
            output.append("<TD>" + ot_giris + "</TD>");
            output.append("<TD>" + x + "</TD>");
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
        output.append("<H4>Firma Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());

    
}
else if( action.trim().startsWith("bar") ){ // ana ekran grafik raporun sorgusu

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    /*String x = "SELECT "
            + "peron_tanim.tanim,"
            + "sum(peron_detay.fiyat) AS miktar, "
            + "count(peron_detay.aciklama) as adet  "
            + "FROM peron_detay left outer join peron_tanim on peron_detay.peron = peron_tanim.id  "
            + "where peron_detay.firma = '" + xUser.getCompany() + "' and "
            + "( "
            //+ "(hour(now()) <= 13) and ( peron_detay.tarih1 BETWEEN CAST(CONCAT(curdate() - INTERVAL 1 DAY, ' ', '13:00')  AS DATETIME) AND CAST(CONCAT(curdate(), ' ', '13:00')  AS DATETIME) ) or "
            //+ "((hour(now()) > 13) and (peron_detay.tarih1 BETWEEN CAST(CONCAT(curdate() - INTERVAL 1 DAY, ' ', '13:00')  AS DATETIME) AND CAST(CONCAT(curdate(), ' ', '13:00')  AS DATETIME) )  ) "
			
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) >= CAST(CONCAT(curdate() - INTERVAL 1 DAY, ' ', '13:00:00')  AS DATETIME) AND  " 
			+ " CAST(CONCAT(CAST(peron_detay.tarih1 AS DATE), ' ', peron_detay.saat1)  AS DATETIME) < CAST(CONCAT(curdate(), ' ', '13:00:00')  AS DATETIME)        " 
            + ") "
            + " group by peron_tanim.tanim order by peron_tanim.tanim ";*/
			
	String x = "SELECT kullanici, bakiye FROM hesap_tanim where firma = '" + xUser.getCompany() + "' and (kullanici <> '" + xUser.getCompany() + "') and (kullanici <> 'FIRMA') order by id ";			

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"kod\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"toplam\":\"" + data[loop][1].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
}
else if( action.trim().startsWith("pie") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT Count(peron_detay.id) AS toplam, alan_tanim.tanim AS kod FROM peron_detay "
            + "Inner Join peron_tanim ON peron_detay.peron = peron_tanim.id "
            + " inner join alan_tanim on peron_tanim.alan = alan_tanim.id "
            + " where peron_detay.firma = '" + xUser.getCompany() + "' group by alan_tanim.tanim " ;

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"toplam\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"kod\":\"" + data[loop][1].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
    }
}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
