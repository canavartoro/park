<%-- 
    Document   : istek
    Created on : May 14, 2011, 2:53:07 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="istek-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
    
    Ext.onReady(function() {
        
        Ext.QuickTips.init();
        
        var istekkaydet = function(){
            
            var grid = Ext.getCmp('frmIstek');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading');
             
            var tip = Ext.getCmp('tip').getValue();
            var baslik = Ext.getCmp('baslik').getValue();
            var isim = Ext.getCmp('isim').getValue();
            var email = Ext.getCmp('email').getValue();
            var msg = Ext.getCmp('msg').getValue();
            
            if( baslik == '' ){
                msg('Hata!', 'Bilgiler Eksik');
                return;
            }
             
             Ext.Ajax.request({
                 url : 'adapter/jsp/sistem/istek.jsp',
                 params : {
                     action : 'istek',
                     tipi : tip,
                     bas : baslik,
                     isimsoyisim : isim,
                     mail : email,
                     mesaj : msg
                 },
                 success : function(response) {
                     grid.el.unmask();
                     try{
                         var obj = Ext.util.JSON.decode(response.responseText);
                         if(!obj.success)
                             msg('Kayýt güncellenemedi!', obj.errors.reason);
                     }
                     catch(e){
                         msg('Sonuç çözülemedi!', response.responseText);
                     }
                     grid.reset();
                 },
                 failure: function(f,a){
                     if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                         msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
                     }
                     if (a.failureType === Ext.form.Action.SERVER_INVALID){
                         msg('Warning', a.result.errormsg);
                     }
                 }
             });
            
        }
    
      var top = new Ext.FormPanel({
        labelAlign: 'top',
        frame:true,
        id:'frmIstek',
        title: 'Istek ve Onerilerinizi Bizimle Paylasin',
        bodyStyle:'padding:5px 5px 0',
        width: 700,
        height:500,
        items: [{
            layout:'column',
            items:[{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype: 'combo',
                    store: ['Istek', 'Sikayet', 'Hata Bildirimi' ],
                    fieldLabel: 'Icerik',
                    name: 'tip',
                    id:'tip',
                    anchor:'95%'
                }, {
                    xtype:'textfield',
                    fieldLabel: 'Konu Basligi',
                    name: 'baslik',
                    id:'baslik',
                    anchor:'95%'
                }]
            },{
                columnWidth:.5,
                layout: 'form',
                items: [{
                    xtype:'textfield',
                    fieldLabel: 'Isim Soyisim',
                    name: 'isim',
                    id: 'isim',
                    anchor:'95%'
                },{
                    xtype:'textfield',
                    fieldLabel: 'Email',
                    name: 'email',
                    id: 'email',
                    vtype:'email',
                    anchor:'95%'
                }]
            }]
        },{
            xtype: 'textarea',
            fieldLabel: 'Message text',
            hideLabel: true,
            width:'96%',
            height:400,
            name: 'msg',
            id: 'msg',
            flex: 1  // Take up all *remaining* vertical space
        }],

        buttons: [{
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    handler : istekkaydet,
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif'
                    //iconCls: 'x-button-ok'
                }]
    });

    top.render('istek-win');
   
/*
    var w = new Ext.Window({
        title: 'Istek Ve Oneri',
        collapsible: true,
        maximizable: true,
        width: 750,
        height: 500,
        minWidth: 300,
        minHeight: 200,
        layout: 'fit',
        plain: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center'
        //renderTo : 'istek-win',
    });
    w.show();*/
});
    
</script>
