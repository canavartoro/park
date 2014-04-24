<%@page contentType="text/html" pageEncoding="windows-1254"%>

Ext.QuickTips.init();
Ext.UpdateManager.defaults.indicatorText = 'Y�kleniyor ...';

if(Ext.LoadMask){
Ext.LoadMask.prototype.msg = "Y�kleniyor ...";
}


if(Ext.PagingToolbar){
    Ext.apply(Ext.PagingToolbar.prototype, {
        beforePageText : "Sayfa",
        afterPageText  : " / {0}",
        firstText      : "�lk Sayfa",
        prevText       : "�nceki Sayfa",
        nextText       : "Sonraki Sayfa",
        lastText       : "Son Sayfa",
        refreshText    : "Yenile",
        displayMsg     : "G�sterilen {0} - {1} / {2}",
        emptyMsg       : 'G�sterilebilecek veri yok'
    });
}

if(Ext.form.TextField){
    Ext.apply(Ext.form.TextField.prototype, {
        minLengthText : "Girilen verinin uzunlu�u en az {0} olabilir",
        maxLengthText : "Girilen verinin uzunlu�u en fazla {0} olabilir",
        blankText     : "Bu alan bo�� b�rak�lamaz",
        regexText     : "",
        emptyText     : null
    });
}

if(Ext.MessageBox){
  Ext.MessageBox.buttonText = {
    ok     : "Tamam",
    cancel : "�ptal",
    yes    : "Evet",
    no     : "Hay�r"
  };
}



Ext.UpdateManager.defaults.indicatorText = 'Y�kleniyor ...';

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
   "�ubat",
   "Mart",
   "Nisan",
   "May�s",
   "Haziran",
   "Temmuz",
   "A�ustos",
   "Eyl�l",
   "Ekim",
   "Kas�m",
   "Aral�k"
];

Date.dayNames = [
   "Pazartesi",
   "Sal�",
   "�ar�amba",
   "Per�embe",
   "Cuma",
   "Cumartesi",
   "Pazar"
];