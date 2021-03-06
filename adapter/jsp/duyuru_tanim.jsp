<%--{
Solution Developer
29 A�ustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/bolge.jsp
[�ablon olarak kullan�lacak.]
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
if( action.trim().startsWith("duyuru") ){
    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT duyuru_tanim.id, duyuru_tanim.baslik, duyuru_tanim.mesaj, duyuru_tanim.firma, duyuru_tanim.durum, duyuru_tanim.kayit_tarihi, duyuru_tanim.kayit_kullanici FROM duyuru_tanim where firma = '" + xUser.getCompany() + "' order by duyuru_tanim.id";

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"baslik\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"mesaj\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"firma\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"durum\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][6].trim() + "\"");
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
    long id = 0;
    StringBuffer sb;

    try{
        json = JSONArray.fromObject( recordsToInsertUpdate );
    }
    catch(Exception e){
        out.println("{success: false, errors: { reason: 'JSON error: " + e.getMessage() + "!' }}");
        return;
    }

    if( json != null ){
        dt = new Database();

        for(int loop = 0;loop < json.size();loop++){

            jsonObject = (JSONObject) JSONSerializer.toJSON(json.getString(loop));

            if( jsonObject != null ){						                
                
                try{
                    id = Long.parseLong(jsonObject.getString("id").trim());
                }
                catch(Exception e){
                }                
                
                String drm = "0";
                if(jsonObject.getString("durum").trim().equals("1") || jsonObject.getString("durum").trim().equals("true") ) drm = "1";
                
                if( id > 0 ){
                    sb = new StringBuffer();
                    sb.append("update duyuru_tanim set baslik = '");
                    sb.append(jsonObject.getString("baslik").trim());
                    sb.append("', mesaj = '"); 
                    sb.append(jsonObject.getString("mesaj").trim());
                    sb.append("', durum = "); 
                    sb.append(drm);
                    sb.append(" where id = ");
                    sb.append(id);
                    id = 0;
                }
                else{
                    sb = new StringBuffer();
                    sb.append("insert into duyuru_tanim (baslik, mesaj, firma, durum,kayit_kullanici) values ('");
                    sb.append(jsonObject.getString("baslik").trim());
                    sb.append("', '");
                    sb.append(jsonObject.getString("mesaj").trim());
                    sb.append("', '");
                    sb.append(xUser.getCompany());
                    sb.append("', ");
                    sb.append(jsonObject.getString("durum").trim().equals("true") ? "1" : "0");
                    sb.append(", '");
                    sb.append(xUser.getName());
                    sb.append("');");
                }

                dt.setSql(sb.toString());
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kay�t g�ncellendi.";
                    //out.println("{success: true, errors: { reason: 'Kay�t g�ncellendi.' }}");
                    //return;
                }
                else{
                    success = false;
                    strOut = "Database hatas�:" + dt.getFault() + sb.toString();
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
else if( action.trim().startsWith("delete1") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from duyuru_tanim where id = '" + toDelete + "'";
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
else if( action.trim().startsWith("excel1") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    StringBuilder output = new StringBuilder();
    dt = new Database();
    String x = "SELECT duyuru_tanim.id, duyuru_tanim.baslik, duyuru_tanim.mesaj, duyuru_tanim.durum, duyuru_tanim.kayit_tarihi, duyuru_tanim.kayit_kullanici FROM duyuru_tanim where firma = '" + xUser.getCompany() + "' order by duyuru_tanim.id";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Duyuru Tan�mlar� " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>ID</TH>");
        output.append("<TH>Baslik</TH>");
        output.append("<TH>Duyuru</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kay�t Tarihi</TH>");
        output.append("<TH>Kay�t Kullan�c�</TH>");
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
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Duyuru Kayd� bulunamad�.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
