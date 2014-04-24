<%-- 
    Document   : istek
    Created on : May 14, 2011, 3:32:11 PM
    Author     : Administrator
--%>

<%@page import="org.barset.data.Database"%>
<%@page import="org.barset.beans.userBean"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<%

userBean xUser = (userBean)request.getSession().getAttribute("user");

boolean success = false;
String strOut = "";
Database dt = null;

String action = request.getParameter("action");

if( action == null ) return;

if( action.trim().startsWith("istek") ){
    
    String tipi = request.getParameter("tipi");
    String bas = request.getParameter("bas");
    String isimsoyisim = request.getParameter("isimsoyisim");
    String mail = request.getParameter("mail");
    String mesaj = request.getParameter("mesaj");

    dt = new Database();
    StringBuffer sb = new StringBuffer();
    sb.append("insert into oneri (firma, tip, konu, isim, email, mesaj, kullanici) values ('");
    sb.append(xUser.getCompany());
    sb.append("','");
    sb.append(tipi);
    sb.append("','");
    sb.append(bas);
    sb.append("','");
    sb.append(isimsoyisim);
    sb.append("','");
    sb.append(mail);
    sb.append("','");
    sb.append(mesaj);
    sb.append("','");
    sb.append(xUser.getName());
    sb.append("')");
    
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
                        return;
                    }
         
                  

}

%>