<%--{
Solution Developer
29 Ağustos 2010 Pazar 12:52
Canavar.Toro
-----------------------------
Page : pages/bufe_hareket.jsp
[Şablon olarak kullanılacak.]
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
if( action.trim().startsWith("firma") ){

    dt = null;
    StringBuilder output = null;
    dt = new Database();
    output = new StringBuilder();

    String x = "SELECT firma_tanim.kod, firma_tanim.tanim, firma_tanim.aciklama, firma_tanim.bakiye, firma_tanim.versiyon, firma_tanim.fisno, firma_tanim.durum, firma_tanim.kayit_tarihi, firma_tanim.kayit_kullanici, firma_tanim.update_tarih, firma_tanim.update_kullanici FROM firma_tanim ORDER BY firma_tanim.tanim ";    

    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if ( data != null && data.length > 0 ){

        output.append("{rows:[");

        for ( int loop = 0; loop < data.length;loop++ ){
            if( loop > 0 )
                output.append(",");
            output.append("{");
            output.append("\"kod\":\"" + data[loop][0].trim() + "\"");
            output.append(",\"tanim\":\"" + data[loop][1].trim() + "\"");
            output.append(",\"aciklama\":\"" + data[loop][2].trim() + "\"");
            output.append(",\"bakiye\":\"" + data[loop][3].trim() + "\"");
            output.append(",\"versiyon\":\"" + data[loop][4].trim() + "\"");
            output.append(",\"fisno\":\"" + data[loop][5].trim() + "\"");
            output.append(",\"durum\":\"" + data[loop][6].trim() + "\"");
            output.append(",\"kayit_tarihi\":\"" + data[loop][7].trim() + "\"");
            output.append(",\"kayit_kullanici\":\"" + data[loop][8].trim() + "\"");
            output.append(",\"update_tarih\":\"" + data[loop][9].trim() + "\"");
            output.append(",\"update_kullanici\":\"" + data[loop][10].trim() + "\"");
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
    out.println("{success: false, errors: { reason: 'Kullanıcı adı ve şifre hatalı!' }}");
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
                xQuery += jsonObject.getString("durum").equals("1") ? "true" : "false";
                xQuery += ", '";
                xQuery += xUser.getName();
                xQuery += "')";

                //out.println("{success: false, errors: { reason: 'de:" + xQuery + "!' }}");
                //return;

                dt.setSql(xQuery);
                if( dt.TInsert() ){
                    success = true;
                    strOut = "Kayıt güncellendi.";
                    //out.println("{success: true, errors: { reason: 'Kayıt güncellendi.' }}");
                    //return;
                }
                else{
                    success = false;
                    strOut = "Database hatası:" + dt.getFault() + xQuery;
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
            out.println("{success: false, errors: { reason: 'Database hatası:" + strOut + "' }}");
            return;
        }
        else{
            out.println("{success: true, errors: { reason: 'Kayıt Silindi!' }}");
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
    String x = "SELECT firma_tanim.kod, firma_tanim.tanim, firma_tanim.aciklama, firma_tanim.bakiye, firma_tanim.versiyon, firma_tanim.fisno, firma_tanim.durum, firma_tanim.kayit_tarihi, firma_tanim.kayit_kullanici, firma_tanim.update_tarih, firma_tanim.update_kullanici FROM firma_tanim ORDER BY firma_tanim.tanim";
    dt.setSql(x);
    String[][] data = dt.TSelectAll();
    if( data != null && data.length > 0 ){
        output.append("<BODY><CENTER>");
        output.append("<H4>Firma Tanımları " + utility.getDate() + "</H4>");
        output.append("<TABLE BORDER=1>");
        output.append("<TR>");
        output.append("<TH>Kod</TH>");
        output.append("<TH>Tanım</TH>");
        output.append("<TH>Açıklama</TH>");
        output.append("<TH>Bakiye</TH>");
        output.append("<TH>Versiyon</TH>");
        output.append("<TH>Fiş No</TH>");
        output.append("<TH>Durum</TH>");
        output.append("<TH>Kayıt Tarihi</TH>");
        output.append("<TH>Kayıt Kullanıcı</TH>");
        output.append("<TH>Güncelleme Tarihi</TH>");
        output.append("<TH>Güncelleyen Kullanıcı</TH>");
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
        output.append("<H4>Firma Kaydı bulunamadı.</H4>");
        output.append("<H5>" + dt.getFault() + "</H5>");
        output.append("</CENTER></BODY>");
    }


    out.println(output.toString());

    
}
else{
    out.println("{success: false, errors: { reason: 'Bilgiler eksik!' }}");
}
%>
