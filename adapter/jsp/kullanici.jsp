<%--{
Solution Developer
29 A�ustos 2010 Pazar 12:52
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
int index = 0;

userBean xUser = (userBean)request.getSession().getAttribute("user");

String action = request.getParameter("action");
if( action.trim().startsWith("users") ){
    
    String firma_par = request.getParameter("xfirma");
    
    dt = new Database();
    output = new StringBuilder();
    if( firma_par != null && firma_par.length() > 0 ){
        dt.setSql("SELECT 'FIRMA' AS kod, 'FIRMA' AS tanim, '" + xUser.getCompany() + "' AS firma UNION ALL SELECT kod, tanim, firma from kullanici_tanim where durum = 1 and firma = '" + xUser.getCompany() + "' order by  firma, kod, tanim ");
    }
    else{
        dt.setSql("SELECT kod, tanim, firma from kullanici_tanim where durum = 1 order by  firma, kod, tanim ");
    }    
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
else if( action.trim().startsWith("allyet") ){
    
    String ouser = request.getParameter("ouser");
    
    dt = new Database();
    output = new StringBuilder();
    dt.setSql("SELECT kullanici_yetki.ids, kullanici_yetki.kullanici, menuler.menu, menuler.baslik, menuler.aciklama, menuler.url, kullanici_yetki.ekle, kullanici_yetki.sil, kullanici_yetki.duzelt, kullanici_yetki.durum FROM kullanici_yetki inner join menuler on kullanici_yetki.menu = menuler.menu WHERE kullanici_yetki.kullanici =  '" + ouser + "' order by menuler.seviye, menuler.ustmenu, menuler.baslik");
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){
        
        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            //ids, kullanici, menu, baslik, aciklama, url, yazma, silme, durum
            output.append(
                    "{\"ids\":\"" + data[loop][0].trim() + 
                    "\",\"kullanici\":\"" + data[loop][1].trim() + 
                    "\",\"menu\":\"" + data[loop][2].trim() + 
                    "\",\"baslik\":\"" + data[loop][3].trim() + 
                    "\",\"aciklama\":\"" + data[loop][4].trim() + 
                    "\",\"url\":\"" + data[loop][5].trim() + 
                    "\",\"ekle\":\"" + data[loop][6].trim().equals("1") +
                    "\",\"sil\":\"" + data[loop][7].trim().equals("1") +
                    "\",\"duzelt\":\"" + data[loop][8].trim().equals("1") +
                    "\",\"durum\":\"" + data[loop][9].trim().equals("1") +
                    "\"}");
        }
        output.append("]}");
        out.println(output.toString());
    }
}
else if( action.trim().startsWith("all") ){
    
    String xfirmaparam = request.getParameter("xfirmaparam");
    if( xfirmaparam == null || xfirmaparam.length() < 1 ) xfirmaparam = xUser.getCompany();       
    String start = request.getParameter("start");
    if( start == null || start.length() < 1 ) start = "0";
    String limit = request.getParameter("limit");
    if( limit == null || limit.length() < 1 ) limit = "20";
    
    dt = new Database();
    output = new StringBuilder();
    
    int total = 0;
    String x = "";
    
    x = "SELECT count(id) FROM kullanici_tanim where firma = '" + xfirmaparam + "' " ;

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

    x = "SELECT id, kod, tanim, '***' as parola, tahsilat, super, firma, durum, email, offline, kayit_tarihi, kayit_kullanici, update_tarih, update_kullanici from kullanici_tanim where firma =  '" + xfirmaparam + "' order by  firma, kod, tanim LIMIT " + start + "," + limit;

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{totalCount:");
        output.append(total);
        output.append(",rows:[");

        String tahsilat = "", sup = "", durum = "", offline = "";

        for ( int loop = 0; loop < data.length;loop++ ){
			
            tahsilat = (data[loop][4].trim().equals("1")) ? "true" : "false";
            sup = (data[loop][5].trim().equals("1")) ? "true" : "false";
            durum = (data[loop][7].trim().equals("1")) ? "true" : "false";
			offline = (data[loop][9].trim().equals("1")) ? "true" : "false";

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
			output.append(",\"offline\":\"" + offline + "\""); 
            output.append(",\"email\":\"" + data[loop][8].trim() + "\""); 
            output.append(",\"kayit_tarihi\":\"" + data[loop][10].trim() + "\""); 
            output.append(",\"kayit_kullanici\":\"" + data[loop][11].trim() + "\""); 
            output.append(",\"update_tarih\":\"" + data[loop][12].trim() + "\""); 
            output.append(",\"update_kullanici\":\"" + data[loop][13].trim() + "\""); 
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
        return;
    }
}
else if( action.trim().startsWith("menuall") ){
    
    dt = new Database();
    output = new StringBuilder();
    
    String x = "";

    x = "SELECT menuler.menu, menuler.baslik, menuler.aciklama FROM menuler where menuler.durum = 1;";
    
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){

            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"menu\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"baslik\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"aciklama\":\"" + data[loop][2].trim() + "\"");
            output.append("}");
        }

        output.append("]}");
        out.println(output.toString());
        return;
    }
}
else if( action.trim().startsWith("excel") ){
    
    String xfirmaparam = request.getParameter("xfirmaparam");
    if( xfirmaparam == null || xfirmaparam.length() < 1 ) xfirmaparam = xUser.getCompany();

    response.setContentType("application/vnd.ms-excel");
    response.setCharacterEncoding("windows-1254");

    output = new StringBuilder();
    dt = new Database();
    String x = "SELECT kod, tanim, '***' as parola, tahsilat, super, durum, kayit_tarihi, kayit_kullanici, update_tarih, update_kullanici from kullanici_tanim where firma = '" + xfirmaparam + "' order by  firma, kod, tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Kullan�c� Tan�mlar� " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Tan�m</TH>");
        output.append("<TH>Parola</TH>");
        output.append("<TH>Tahsilat</TH>");
        output.append("<TH>S�per</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kay�t Tarihi</TH>");
        output.append("<TH>Kay�t Kullan�c�</TH>");
        output.append("<TH>G�ncelleme Tarihi</TH>");
        output.append("<TH>G�ncelleyen Kullan�c�</TH>");
        output.append("</TR>");

        String tahsilat = "", sup = "", durum = "";

        for( int row = 0;row < data.length;row++ ){

            tahsilat = (data[row][3].trim().equals("1")) ? "Tahsilat" : "Normal";
            sup = (data[row][4].trim().equals("1")) ? "S�per" : "Normal";
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
        output.append("<H4>Kullan�c� Kayd� bulunamad�.</H4>");
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
else if( action.trim().startsWith("yetkidel") ){
    String toDelete = request.getParameter("toDelete");

    if( toDelete != null && toDelete.length() > 0 ){
        strOut = "delete from kullanici_yetki where ids = " + toDelete;
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
else if( action.trim().startsWith("save") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");
    String xfirmaparam = request.getParameter("xfirmaparam");
    if( xfirmaparam == null || xfirmaparam.length() < 1 ) xfirmaparam = xUser.getCompany();

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
                    xQuery += xfirmaparam;
					xQuery += "', ";
                    xQuery += jsonObject.getString("offline");
                    xQuery += ", ";
                    xQuery += jsonObject.getString("durum");
                    xQuery += ", '";
                    xQuery += jsonObject.getString("email");
                    xQuery += "', '";
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
                    strOut = "Kay�t g�ncellendi.";                    
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
else if( action.trim().startsWith("yetkisave") ){

    String recordsToInsertUpdate = request.getParameter("recordsToInsertUpdate");
    String ouser = request.getParameter("ouser");
    if( ouser == null || ouser.length() < 1 ) {
        out.println("{success: false, errors: { reason: 'JSON error: kullan�c� bilgisi eksik!' }}");
        return;
    }

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
                String xQuery = "", ekle = "", sil = "", duzelt = "", durum = "";

                try{
                    
                    if(jsonObject.getString("ekle").trim().equals("true") || jsonObject.getString("ekle").trim().equals("1")) 
                        ekle = "1"; 
                    else 
                        ekle = "0";
                    if(jsonObject.getString("sil").trim().equals("true") || jsonObject.getString("sil").trim().equals("1"))
                        sil = "1";
                    else
                        sil = "0";
                    if(jsonObject.getString("duzelt").trim().equals("true") || jsonObject.getString("duzelt").trim().equals("1"))
                        duzelt = "1";
                    else
                        duzelt = "0";
                    if(jsonObject.getString("durum").trim().equals("true") || jsonObject.getString("durum").trim().equals("1"))
                        durum = "1";
                    else
                        durum = "0";
                    
                    xQuery = "delete from kullanici_yetki where menu = ";
                    xQuery += jsonObject.getString("menu");
                    xQuery += " and kullanici = ";
                    xQuery += ouser;
                    
                    dt.setSql(xQuery);
                    dt.TInsert();                    
                    
                    xQuery = " insert into kullanici_yetki (kullanici,menu,ekle,sil,duzelt,durum) values (";
                    xQuery += ouser;
                    xQuery += ",";
                    xQuery += jsonObject.getString("menu");
                    xQuery += ",";
                    xQuery += ekle;
                    xQuery += ",";
                    xQuery += sil;
                    xQuery += ",";
                    xQuery += duzelt;
                    xQuery += ",";
                    xQuery += durum;
                    xQuery += ");";
                }
                catch(Exception e){
                    strOut = xQuery + "x" + e.getMessage();
                    break;
                }

                dt.setSql(xQuery);
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kay�t g�ncellendi.";                    
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
else if( action.trim().startsWith("fav") ){
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
        out.println("{success: false, errors: { reason: 'Kay�t g�ncellendi." + title + ":" + url + "' }}");
        return;
    }
    else{
        out.println("{success: false, errors: { reason: '" + dt.getFault() + xQuery + "' }}");
        return;
    }
}

%>
