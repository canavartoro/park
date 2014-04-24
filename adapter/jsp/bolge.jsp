<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/bolge.jsp
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

String action = request.getParameter("action");
if( action.trim().startsWith("bolge") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select id, kod, tanim, aciklama, durum, firma, kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici from bolge_tanim where firma = '" + xUser.getCompany() + "' order by kod, tanim";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"kod\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"tanim\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"aciklama\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"durum\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"firma\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"update_tarihi\":\"" + data[loop][8].trim() + "\"");
            output.append(",\"update_kullanici\":\"" + data[loop][9].trim() + "\"");
            output.append("}");
            //output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
if( action.trim().startsWith("alan") ){

    String xbolge = request.getParameter("bolge");

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "select  a.id, a.kod, a.tanim, a.aciklama, a.durum, a.bolge, a.kayit_tarihi, a.kayit_kullanici, a.update_tarihi, a.update_kullanici from bolge_tanim b inner join alan_tanim a on b.id = a.bolge where firma = '" + xUser.getCompany() + "' and a.bolge = '" + xbolge + "'  order by a.kod, a.tanim";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"kod\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"tanim\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"aciklama\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"durum\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"bolge\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"update_tarihi\":\"" + data[loop][8].trim() + "\"");
            output.append(",\"update_kullanici\":\"" + data[loop][9].trim() + "\"");
            output.append("}");
            //output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\"}");
        }

        output.append("]}");
        out.println(output.toString());
    }
    return;
}
else if( action.trim().startsWith("save1") ){

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
                String xQuery = "Call yenibolge('";
                xQuery += jsonObject.getString("kod");
                xQuery += "', '";
                xQuery += jsonObject.getString("tanim");
                xQuery += "', '";
                xQuery += jsonObject.getString("aciklama");
                xQuery += "', ";
                xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                xQuery += ", '";
                xQuery += xUser.getName();
                xQuery += "', '";
                xQuery += xUser.getCompany();
                xQuery += "')";
				
				/*if(1 == 1){
					out.println("{success: false, errors: { reason: 'JSON error: " + xQuery + "|" + jsonObject.getString("tanim") + "!' }}");
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
				
				/*if(1 == 1){
					out.println("{success: false, errors: { reason: 'JSON error: " + xQuery + "' }}");
					return;
				}*/
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
else if( action.trim().startsWith("delete1") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from bolge_tanim where id = '" + toDelete + "'";
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
else if( action.trim().startsWith("delete2") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from peron_tanim where id = '" + toDelete + "'";
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
else if( action.trim().startsWith("excel1") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    String x = "select id, kod, tanim, aciklama, durum, kayit_tarihi, kayit_kullanici, update_tarihi, update_kullanici from bolge_tanim where firma = '" + xUser.getCompany() + "' order by kod, tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Bölge Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ID</TH>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Taným</TH>");
        output.append("<TH>Açýklama</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kayýt Tarihi</TH>");
        output.append("<TH>Kayýt Kullanýcý</TH>");
        output.append("<TH>Güncelleme Tarihi</TH>");
        output.append("<TH>Güncelleyen Kullanýcý</TH>");
        output.append("</TR>");

        for( int row = 0;row < data.length;row++ ){
            x = data[row][4].trim().equals("1") ? "Aktif" : "Pasif";
            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + data[row][3].trim() + "</TD>");
            output.append("<TD>" + x + "</TD>");
            output.append("<TD>" + data[row][5].trim() + "</TD>");
            output.append("<TD>" + data[row][6].trim() + "</TD>");
            output.append("<TD>" + data[row][7].trim() + "</TD>");
            output.append("<TD>" + data[row][8].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Bölge Kaydý bulunamadý.</H4>");
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
