<%@page import="org.barset.data.Database"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%

try{
     String action = "", query = "", password = "";

     action = request.getParameter("action");
     query = request.getParameter("query");
     password = request.getParameter("password");

     if(!password.equals("toro")){
         if(!password.equals("sabayer")){
             out.println("Yetkisiz kullaným!");
             return;
         }
     }

     Database dt = null;
     StringBuilder st = new StringBuilder();
     char tirnak = 34;

     if(action.equals("1")){ // select sorgusu
         

         try{
             dt = new Database();
             
             dt.setSql(query);

             st.append(dt.TSelectHTML());
             st.append(dt.getFault());

             /*String[][] data = dt.TSelectAll();

             if ( data != null && data.length > 0 ){

                 int col = data[0].length;
                 st.append("<table  style=" + String.valueOf(tirnak) + "width:100%;border:1px solid #999999;" + String.valueOf(tirnak) + " cellspacing=" + String.valueOf(tirnak) + "0" + String.valueOf(tirnak) + ">");
                 
                 for ( int loop = 0; loop < data.length;loop++ ){

                     st.append("<tr>");
                     for (int column = 0; column < col;column++){
                         st.append("<td style=" + String.valueOf(tirnak) + "border:1px dotted #999999;" + String.valueOf(tirnak) + ">");
                         st.append(data[loop][column].trim());
                         st.append("</td>");
                     }
                     st.append("</tr>");
                }
               st.append("</table>");
            }
            else{
                st.append("Hiç kayýt bulunamadý:" + dt.getFault());
            }*/
         }
         catch(Exception ee){
              st.append("Genel hata:" + dt.getFault() + "</br>" + ee.getMessage());
         }
     }
     else { // update sorgusu

         try{
             dt = new Database();

             dt.setSql(query);

             if(dt.TInsert()){
                 st.append("Ýþlem baþarýlý oldu hata:" + dt.getFault());
             }
             else{
                 st.append("Ýþlem baþarýsýz oldu hata:" + dt.getFault() + "</br>" + dt.getSql());
             }
         }
         catch(Exception ee){
              st.append("Genel hata:" + dt.getFault() + "</br>" + ee.getMessage());
         }
     }

     out.println(st.toString());

     //out.println("action:" + action + ",query:" + query + ",password:" + password);
}
catch(Exception e){
    out.println( "Genel hata:" + e.getMessage());
}


/*
String queryData = request.getQueryString();
out.println("Attached GET data: " + queryData);
*/
%>

<%
        /*
        Database dt = null;

        out.println("Baðlantý deneniyor ...</br>");
        out.println("</br>");

        try{

            dt = new Database();

            dt.setSql("SELECT KullaniciID, KullaniciAdi, Durum FROM dbo.kullanici_tanim WITH (NOLOCK)");

            String[][] data = dt.TSelectAll();

            if ( data != null && data.length > 0 ){
                for ( int loop = 0; loop < data.length;loop++ ){
                    out.println(data[loop][0].trim() + "," + data[loop][1].trim() + "," + data[loop][1].trim() + "</br>");
                    out.println("</br>");
                }
                out.println("</br>");
                out.println("Baðlandý...</br>");
                out.println("</br>");
            }
            else{
                out.println( "Sunucu hatasi:" + dt.getFault());
            }
        }
                catch(Exception e){
                    out.println("Genel hata:" + e.getMessage());
        }
        */
%>