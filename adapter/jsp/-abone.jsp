<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/abone.jsp
 }--%>

<%@page import="java.util.Date"%>
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
if( action.trim().startsWith("abone") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT abone, adi, soyadi, plaka, bitis_tarihi, firma, diger1, diger2, diger3, deger1, deger2, deger3, tarih1, tarih2, tarih3, kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici, durum FROM abone_tanim where firma = '" + xUser.getCompany() + "'";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

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

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("alanlar") ){

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
                    xQuery += (t1.length() > 0) ? "'" + t1 + "'" : "null";
                    xQuery += ", ";
                    xQuery += (t2.length() > 0) ? "'" + t2 + "'" : "null";
                    xQuery += ", ";
                    xQuery += (t3.length() > 0) ? "'" + t3 + "'" : "null";
                    xQuery += ", '";
                    xQuery += xUser.getID();
                    xQuery += "', ";
                    xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                    xQuery += ")";

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
                catch(Exception ee){
                    System.err.println(new Date() + " hata:" + ee.getMessage());
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
                xQuery += xUser.getID();
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
        strOut = "delete from abone_tanim where abone = " + toDelete;
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

    String xabone = request.getParameter("abone");
    String xperon = request.getParameter("peron");
    String xalan = request.getParameter("alan");
    String xbolge = request.getParameter("bolge");
    String xsil = request.getParameter("sil");

    if( xabone != null && xabone.length() > 0 ){
        dt = new Database();
        if(xsil.equalsIgnoreCase("1")){
            strOut = "delete from abone_detay where abone = " + xabone;
            dt.setSql(strOut);
            dt.TInsert();
        }
        
        strOut = "insert into abone_detay (abone,bolge,alan,peron,kayit_kullanici) values (" + xabone + "," + xbolge + "," + xalan + "," + xperon + ", N'" + xUser.getID() + "')";
        dt.setSql(strOut);
        if(!dt.TInsert()){
            out.println("{success: false, errors: { reason: 'Database hatasý:" + strOut + "," + dt.getFault() + "' }}");
            return;
        }
        out.println("{success: true, errors: { reason: 'Kayýt Silindi!' }}");
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
        output.append("<H4>Abone Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ABONE</TH>");
        output.append("<TH>ADI</TH>");
        output.append("<TH>SOYADI</TH>");
        output.append("<TH>ÖZELKOD</TH>");
        output.append("<TH>BÝTÝÞ TARÝHÝ</TH>");
        output.append("<TH>METÝN(1)</TH>");
        output.append("<TH>METÝN(2)</TH>");
        output.append("<TH>METÝN(3)</TH>");
        output.append("<TH>SAYI(1)</TH>");
        output.append("<TH>SAYI(2)</TH>");
        output.append("<TH>SAYI(3)</TH>");
        output.append("<TH>TARÝH(1)</TH>");
        output.append("<TH>TARÝH(2)</TH>");
        output.append("<TH>TARÝH(3)</TH>");
        output.append("<TH>KAYIT TARÝHÝ</TH>");
        output.append("<TH>KAYIT KULLANICI</TH>");
        output.append("<TH>GÜNCELLEME TARÝHÝ</TH>");
        output.append("<TH>GÜNCELEME KULLANICI</TH>");
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
        output.append("<H4>Abone Kaydý bulunamadý.</H4>");
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
        output.append("<H4>Alan Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ID</TH>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Taným</TH>");
        output.append("<TH>Açýklama</TH>");
        output.append("<TH>Bölge Kod</TH>");
        output.append("<TH>Bölge Taným</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kayýt Tarihi</TH>");
        output.append("<TH>Kayýt Kullanýcý</TH>");
        output.append("<TH>Güncelleme Tarihi</TH>");
        output.append("<TH>Güncelleyen Kullanýcý</TH>");
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
        output.append("<H4>Alan Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
