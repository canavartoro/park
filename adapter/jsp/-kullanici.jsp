<%--{
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/users.jsp
 }--%>
<%@page import="net.sf.json.JSONSerializer"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.barset.util.utility"%>
<%@page import="org.barset.beans.userBean"%>
<%@page import="org.barset.data.Database"%>

<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%

Database dt = null;
StringBuilder output = null;
String strOut = "";
boolean success = false;

userBean xUser = (userBean)request.getSession().getAttribute("user");

String action = request.getParameter("action");
if( action.trim().startsWith("users") ){
    dt = new Database();
    output = new StringBuilder();
    dt.setSql("SELECT kod, tanim, firma from kullanici_tanim where durum = 1 order by  firma, kod, tanim ");
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
        
        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{\"kod\":\"" + data[loop][0].trim() + "\",\"tanim\":\"" + data[loop][1].trim() + "\",\"firma\":\"" + data[loop][2].trim() + "\"}");
        }
        output.append("]}");
        out.println(output.toString());
    }
}
else if( action.trim().startsWith("all") ){
    
    String x = "";
    String start = "";//request.getParameter("start");
    String limit = "";//request.getParameter("limit");
    String xfirma = request.getParameter("xfirma");
    int total = 0;
    
    if(xfirma == null || xfirma.length() < 1) xfirma = xUser.getCompany();
    if( start == null || xfirma.length() < 1 ) xfirma = "0";
    if( limit == null || limit.length() < 1 ) limit = "50";
    
    dt = new Database();
    output = new StringBuilder();
    
    x = "SELECT count(id) FROM kullanici_tanim where firma = '" + xfirma + "' " ;
    
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

    x = "SELECT id, kod, tanim, '***' as parola, tahsilat, super, firma, durum, kayit_tarihi, kayit_kullanici, update_tarih, update_kullanici from kullanici_tanim where firma = '" + xfirma + "' order by  firma, kod, tanim LIMIT " + start + "," + limit;;

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        String tahsilat = "", sup = "", durum = "";

        for ( int loop = 0; loop < data.length;loop++ ){

            tahsilat = (data[loop][4].trim().equals("1")) ? "true" : "false";
            sup = (data[loop][5].trim().equals("1")) ? "true" : "false";
            durum = (data[loop][7].trim().equals("1")) ? "true" : "false";

            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"id\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"kod\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"tanim\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"parola\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"tahsilat\":\"" + tahsilat + "\"");
            output.append(",\"sup\":\"" + sup + "\"");
            output.append(",\"firma\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"durum\":\"" + durum + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][8].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][9].trim() + "\"");
            output.append(",\"update_tarih\":\"" + data[loop][10].trim() + "\"");
            output.append(",\"update_kullanici\":\"" + data[loop][11].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
        return;
    }
}
else if( action.trim().startsWith("excel") ){

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    output = new StringBuilder();
    dt = new Database();
    String x = "SELECT kod, tanim, '***' as parola, tahsilat, super, durum, kayit_tarihi, kayit_kullanici, update_tarih, update_kullanici from kullanici_tanim where firma = '" + xUser.getCompany() + "' order by  firma, kod, tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Kullanýcý Tanýmlarý " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Taným</TH>");
        output.append("<TH>Parola</TH>");
        output.append("<TH>Tahsilat</TH>");
        output.append("<TH>Süper</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kayýt Tarihi</TH>");
        output.append("<TH>Kayýt Kullanýcý</TH>");
        output.append("<TH>Güncelleme Tarihi</TH>");
        output.append("<TH>Güncelleyen Kullanýcý</TH>");
        output.append("</TR>");

        String tahsilat = "", sup = "", durum = "";

        for( int row = 0;row < data.length;row++ ){

            tahsilat = (data[row][3].trim().equals("1")) ? "Tahsilat" : "Normal";
            sup = (data[row][4].trim().equals("1")) ? "Süper" : "Normal";
            durum = (data[row][6].trim().equals("1")) ? "Aktif" : "Pasif";

            output.append("<TR>");
            output.append("<TD>" + data[row][0].trim() + "</TD>");
            output.append("<TD>" + data[row][1].trim() + "</TD>");
            output.append("<TD>" + data[row][2].trim() + "</TD>");
            output.append("<TD>" + tahsilat + "</TD>");
            output.append("<TD>" + sup + "</TD>");
            output.append("<TD>" + durum + "</TD>");
            output.append("<TD>" + data[row][6].trim() + "</TD>");
            output.append("<TD>" + data[row][7].trim() + "</TD>");
            output.append("<TD>" + data[row][8].trim() + "</TD>");
            output.append("<TD>" + data[row][9].trim() + "</TD>");
            output.append("</TR>");
        }
        output.append("</TABLE>");
        output.append("</CENTER></BODY>");
    }
    else{
        output.append("<BODY><CENTER>");
        output.append("<H4>Kullanýcý Kaydý bulunamadý.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());


}
else if( action.trim().startsWith("delete") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from kullanici_tanim where id = '" + toDelete + "'";
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
else if( action.trim().startsWith("save") ){

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
                String xQuery = "";

                try{
                    xQuery = "Call yeniuser('";
                    xQuery += jsonObject.getString("kod");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("tanim");
                    xQuery += "', '";
                    xQuery += jsonObject.getString("parola");
                    xQuery += "', ";
                    xQuery += jsonObject.getString("tahsilat");
                    xQuery += ", ";
                    xQuery += jsonObject.getString("sup");
                    xQuery += ", '";
                    xQuery += xUser.getCompany();
                    xQuery += "', ";
                    xQuery += jsonObject.getString("durum");
                    xQuery += ", '";
                    xQuery += xUser.getName();
                    xQuery += "')";
                }
                catch(Exception e){
                    strOut = xQuery + "x" + e.getMessage();
                    break;
                }

                dt.setSql(xQuery);
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kayýt güncellendi.";                    
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
if( action.trim().startsWith("fav") ){
    dt = new Database();
    String title = request.getParameter("title");
    String url = request.getParameter("url");
    
    String xQuery = "Call favoriekle('";
    xQuery += xUser.getCompany();
    xQuery += "', '";
    xQuery += xUser.getName();
    xQuery += "', '";
    xQuery += title;
    xQuery += "', '";
    xQuery += url;
    xQuery += "')";

    /*dt.setSql("set character_set_client='latin5';");dt.TInsert();
    dt.setSql("SET character_set_client='latin5'");dt.TInsert();
    dt.setSql("SET character_set_results='latin5'");dt.TInsert();
    dt.setSql("SET character_set_connection='latin5'");dt.TInsert();
    dt.setSql("SET NAMES latin5");dt.TInsert();*/

    xQuery = "insert into parkomat.favori_listesi (firma, kullanici, title, url) values ( '";
    xQuery += xUser.getCompany();
    xQuery += "', '";
    xQuery += xUser.getName();
    xQuery += "', '";
    xQuery += title;
    xQuery += "', '";
    xQuery += url;
    xQuery += "')";

    dt.setSql(xQuery);
    if( dt.TInsert() ){
        out.println("{success: false, errors: { reason: 'Kayýt güncellendi." + title + ":" + url + "' }}");
        return;
    }
    else{
        out.println("{success: false, errors: { reason: '" + dt.getFault() + xQuery + "' }}");
        return;
    }
}
%>
