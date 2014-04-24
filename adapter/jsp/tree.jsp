
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.barset.data.Database"%>
<%@page import="org.barset.beans.userBean"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
Docs.classData =

<%
userBean xUser = (userBean)request.getSession().getAttribute("user");

JSONObject jsecenekler = new JSONObject();
jsecenekler.put("id", "apidocs");
jsecenekler.put("iconCls", "icon-pkg");
jsecenekler.put("text", "Seçenekler");
jsecenekler.put("ekle", false);
jsecenekler.put("sil", false);
jsecenekler.put("duzelt", false);
jsecenekler.put("singleClickExpand", true);

JSONArray asecenekler = new JSONArray();

boolean singleClickExpand = false;
boolean leaf = false;
String href = "";

Database dt = new Database();

dt.setSql("select menu, baslik, icon, url from menuler where ustmenu = 0");
String[][] xsecenek = dt.TSelectAll();

if( xsecenek != null && xsecenek.length > 0 ){

    for( int loop = 0;loop < xsecenek.length;loop++ ){

        href =  xsecenek[loop][3].trim();
        singleClickExpand = href.length() < 1;
        leaf = href.length() > 0;

        JSONObject jo = new JSONObject();
        jo.put("id", "id" + xsecenek[loop][0].trim());
        jo.put("text", xsecenek[loop][1].trim());
        jo.put("iconCls", xsecenek[loop][2].trim());
        jo.put("ekle", false);
        jo.put("sil", false);
        jo.put("duzelt", false);
        jo.put("singleClickExpand", singleClickExpand);
        jo.put("href", href);
        jo.put("leaf", leaf);

        if(xUser.getSuper())
            dt.setSql("select menu, baslik, icon, url, 1 as ekle, 1 as sil, 1 as duzelt  from menuler where durum = 1 and ustmenu = " + xsecenek[loop][0].trim());
        else
            dt.setSql("SELECT menuler.menu, menuler.baslik, menuler.icon, menuler.url, kullanici_yetki.ekle, kullanici_yetki.sil, kullanici_yetki.duzelt FROM menuler Inner Join kullanici_yetki ON menuler.menu = kullanici_yetki.menu where menuler.durum = 1 and ustmenu = " + xsecenek[loop][0].trim() + " and kullanici_yetki.durum = 1 and kullanici_yetki.kullanici  = " + xUser.getID());
        
        String[][] xalt = dt.TSelectAll();

        if( xalt != null && xalt.length > 0 ){

            JSONArray ja = new JSONArray();

            for( int l = 0;l < xalt.length; l++ ){

                JSONObject joo = new JSONObject();
                joo.put("id", "id" + xalt[l][0].trim());
                joo.put("text", xalt[l][1].trim());
                joo.put("iconCls", xalt[l][2].trim());
                joo.put("ekle", xalt[l][4].trim().equals("1") ? false : true);
                joo.put("sil", xalt[l][5].trim().equals("1") ? false : true);
                joo.put("duzelt", xalt[l][6].trim().equals("1") ? false : true);
                joo.put("cls", "package");
                joo.put("href", xalt[l][3].trim());
                joo.put("leaf", true);
                jo.put("singleClickExpand", false);
                ja.add(joo);
            }
            jo.put("children", ja);
        }
        asecenekler.add(jo);
    }
}
jsecenekler.put("children", asecenekler);
out.print(jsecenekler);

/*
JSONObject jtanimlar = new JSONObject();
jtanimlar.put("id", "tanimlar");
jtanimlar.put("iconCls", "icon-static");
jtanimlar.put("text", "Tanýmlar");
jtanimlar.put("singleClickExpand", true);

JSONArray atanimlar = new JSONArray();

JSONObject jfirma = new JSONObject();
jfirma.put("id", "x-firma");
jfirma.put("iconCls", "icon-static");
jfirma.put("text", "Firma Tanýmlarý");
jfirma.put("href", "pages/firma.jsp");
jfirma.put("cls", "package");
jfirma.put("leaf", true);

atanimlar.add(jfirma);
jtanimlar.put("children", atanimlar);

asecenekler.add(jtanimlar);

jsecenekler.put("children", asecenekler);
out.print(jsecenekler);
*/

/*
JSONArray atanimlar = new JSONArray();

JSONObject jtanim = new JSONObject();
jtanim.put("id", "x-firma");
jtanim.put("iconCls", "icon-static");
jtanim.put("text", "Firma Tanýmlarý");
jtanim.put("href", "pages/firma.jsp");
jtanimlar.put("cls", "package");
jtanimlar.put("leaf", true);
jtanim.put("singleClickExpand", true);

atanimlar.add(jtanim);
jtanimlar.put("children", atanimlar);
asecenekler.add(jtanim);
jsecenekler.put("children", asecenekler);
out.print(jsecenekler);*/

/*
userBean xUser = (userBean)request.getSession().getAttribute("user");

if ( 1==2){//xUser == null ){
    response.sendError(0, "Yetkisiz kullaným giriþimi!");
    return;
}
else{
    Database dt = new Database();
    JSONObject menu = new JSONObject();
    String[][] tmp = null;
    String[] temp = null;
    dt.setSql("SELECT id, text, icon, sing, parent, leaf from menu_tanim where parent is null");
    tmp = dt.TSelectAll();
    temp = ( tmp != null && tmp.length > 0 ) ? tmp[0] : null;

    if( temp != null && temp.length > 0 ){

        try{
            menu.put("id", temp[0].trim());
            menu.put("text", temp[1].trim());
            menu.put("iconCls", temp[2].trim());
            menu.put("singleClickExpand", temp[3].trim());

            dt.setSql("SELECT id, text, icon, sing from menu_tanim where parent = '" + temp[0].trim() + "'");
            String[][] tmp1 = null;
            tmp1 = dt.TSelectAll();

            if( tmp1 != null && tmp1.length > 0 ){

                JSONArray child1 = new JSONArray();

                for(int i1 = 0;i1 < tmp1.length;){

                    JSONObject j1 = new JSONObject();
                    j1.put("id", tmp1[i1][0].trim());
                    j1.put("text", tmp1[i1][1].trim());
                    j1.put("iconCls", tmp1[i1][2].trim());
                    j1.put("singleClickExpand", "true");
/*
                    dt.setSql("SELECT id, text, icon, href from menu_tanim where parent = '" + tmp1[i1][0].trim() + "'");
                    String[][] tmp2 = null;
                    tmp2 = dt.TSelectAll();

                    if( tmp2 != null && tmp2.length > 0 ){

                        JSONArray child2 = new JSONArray();

                        for(int i2 = 0;i2 < tmp2.length;){

                            JSONObject j2 = new JSONObject();
                            j2.put("id", tmp1[i2][0].trim());
                            j2.put("text", tmp1[i2][1].trim());
                            j2.put("iconCls", tmp1[i2][2].trim());
                            j2.put("href", tmp1[i2][3].trim());
                            j2.put("cls", "package");
                            j2.put("singleClickExpand", "true");
                            j2.put("leaf", "true");
                            child2.add(j2);
                        }
                        j1.put("children", child2);
                    }*//*
                    child1.add(j1);
                }
                menu.put("children", child1);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    out.print(menu);
}*/

/*
{"id":"apidocs","iconCls":"icon-pkg","text":"Seçenekler","singleClickExpand":true,"children":[
    {"id":"tanimlar","iconCls":"icon-static","text":"Tanýmlar","singleClickExpand":true,"children":[
        {"href":"pages/firma.jsp","id":"x-firma","text":"Firma Tanýmlarý","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/bolge.jsp","id":"x-bolge","text":"Bölge Tanýmlarý","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/alan.jsp","id":"x-alan","text":"Alan Tanýmlarý","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/users.jsp","id":"x-users","text":"Kullanýcý Tanýmlarý","iconCls":"icon-user","cls":"package","singleClickExpand":true,"leaf":true}]},
    {"id":"fiyat","iconCls":"icon-static","text":"Fiyat","singleClickExpand":true,"children":[
        {"href":"pages/fiyat.jsp","id":"x-fiyat","text":"Fiyat Tanýmlarý","iconCls":"icon-fiyat","cls":"package","singleClickExpand":true,"leaf":true}]},
    {"id":"abone","iconCls":"icon-static","text":"Abone Yönetimi","singleClickExpand":true,"children":[
        {"href":"pages/abone.jsp","id":"x-abone","text":"Abone Tanýmlarý","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true}]},
    {"id":"sistem","iconCls":"icon-static","text":"Sistem","singleClickExpand":true,"children":[
        {"href":"pages/hata.jsp","id":"x-err","text":"Hata Kayýtlarý","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/help.jsp","id":"x-help","text":"Yardým","iconCls":"icon-docs","cls":"package","singleClickExpand":true,"leaf":true}]},
     {"id":"rapor","iconCls":"icon-static","text":"Raporlar","singleClickExpand":true,"children":[
        {"href":"pages/hata.jsp","id":"pkg-rpr","text":"Günlük Hesap Raporu","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/hata.jsp","id":"pkg-plk","text":"Plaka Sorgulama","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true},
        {"href":"pages/hata.jsp","id":"pkg-brc","text":"Borç Sorgulama","iconCls":"icon-cls","cls":"package","singleClickExpand":true,"leaf":true}]}
]};
*/
%>


<%@include file="docs-icons.jsp" %>