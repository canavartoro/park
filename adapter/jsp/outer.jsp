<%@page contentType="text/html" pageEncoding="windows-1254"%>

Ext.QuickTips.init();
Ext.UpdateManager.defaults.indicatorText = 'Yükleniyor ...';

if(Ext.LoadMask){
Ext.LoadMask.prototype.msg = "Yükleniyor ...";
}


if(Ext.PagingToolbar){
    Ext.apply(Ext.PagingToolbar.prototype, {
        beforePageText : "Sayfa",
        afterPageText  : " / {0}",
        firstText      : "Ýlk Sayfa",
        prevText       : "Önceki Sayfa",
        nextText       : "Sonraki Sayfa",
        lastText       : "Son Sayfa",
        refreshText    : "Yenile",
        displayMsg     : "Gösterilen {0} - {1} / {2}",
        emptyMsg       : 'Gösterilebilecek veri yok'
    });
}

if(Ext.form.TextField){
    Ext.apply(Ext.form.TextField.prototype, {
        minLengthText : "Girilen verinin uzunluðu en az {0} olabilir",
        maxLengthText : "Girilen verinin uzunluðu en fazla {0} olabilir",
        blankText     : "Bu alan boþ¸ býrakýlamaz",
        regexText     : "",
        emptyText     : null
    });
}

if(Ext.MessageBox){
  Ext.MessageBox.buttonText = {
    ok     : "Tamam",
    cancel : "Ýptal",
    yes    : "Evet",
    no     : "Hayýr"
  };
}



Ext.UpdateManager.defaults.indicatorText = 'Yükleniyor ...';

function msg(caption,text){
    Ext.MessageBox.show({
        title: caption,
        msg: text,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.ERROR,
        animEl: 'header'
    });
}

Date.monthNames = [
   "Ocak",
   "Þubat",
   "Mart",
   "Nisan",
   "Mayýs",
   "Haziran",
   "Temmuz",
   "Aðustos",
   "Eylül",
   "Ekim",
   "Kasým",
   "Aralýk"
];

Date.dayNames = [
   "Pazartesi",
   "Salý",
   "Çarþamba",
   "Perþembe",
   "Cuma",
   "Cumartesi",
   "Pazar"
];