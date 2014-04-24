
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<%@include file="../../adapter/jsp/yetki.jsp" %>

<div id="cezali_tahsilat"></div>

<script type="text/javascript">

//cezatahsilat(plaka,borc,tutar);				
			
function cezatahsilat(plaka,tutar){		

	Ext.Ajax.request({
		url : 'adapter/jsp/hesap/cezali.jsp',
        params : {
            action : 'tahsilat',
            p_plaka : plaka,
            p_tutar : tutar
        },
        success : function(response) {	            
            var obj;
            
            try{
                obj = Ext.util.JSON.decode(response.responseText);
            }
            catch(e){
                Ext.get('fiyat_detay_info').addClass('error');
                Ext.fly('fiyat_detay_info').update(response.responseText);
            }
            if(!obj.success){
                msg('Error!', obj.errors.reason);
            }
            else{                               
                Ext.getCmp('xcezali_detay').close();
            }
            Ext.getCmp('xcezali_detay').close();
        },
        failure: function(f,a){
            msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
            /*if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
            }
            else if (a.failureType === Ext.form.Action.SERVER_INVALID){
                msg('Warning', a.result.errormsg);
            }
            else{
                msg('Error!', a.response.statusText);
            }*/
        }
    });
}
									
 function Popup(data) 
    {
        var mywindow = window.open('', 'my div', 'height=400,width=600');
        mywindow.document.write('<html><head><title>Yazdýrýlýyor...</title>');
        /*optional stylesheet*/ //mywindow.document.write('<link rel="stylesheet" href="main.css" type="text/css" />');
        mywindow.document.write('</head><body >');
        mywindow.document.write(data);
        mywindow.document.write('</body></html>');
        mywindow.document.close();
        mywindow.print();
		mywindow.close();
        return true;
    }
 
var adetay = new Ext.FormPanel({
    //id: 'abone_detay',
    labelAlign: 'left',
    frame:true,
	border:true,
    bodyStyle:'padding:5px 5px 0',
    width: 500,
    height:200,
    items: [{
        layout:'column',
        items:[{
            columnWidth:.5,
            layout: 'form',
            items: [
			{
				xtype:'label',
                fieldLabel: 'Plaka',
                name: 'labelplaka',
				width: 100,
                align: 'right',
				fieldLabel: 'Plaka',
				labelWidth: 20,
				text:Ext.get('xplaka').getValue()
            }
			]
        },{
            columnWidth:.5,
            layout: 'form',
            items: [
			{
				xtype:'numberfield',
                fieldLabel: 'Tutar',
                name: 'textbakiye',
				id: 'textbakiye',
				width: 70,
                align: 'right',
				fieldLabel: 'Bakiye',
				decimalPrecision:2,
				labelWidth: 20,
				value:Ext.get('xfiyat').getValue()
            },
			{
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'qplaka',
                    name: 'qplaka',
                    value: Ext.get('xplaka').getValue()
            },
			{
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'qbakiye',
                    name: 'qbakiye',
                    value: Ext.get('xfiyat').getValue()
            }
			]
    }]
    },
	{
	layout:'column',
	items:[{
			columnWidth:.5,
			layout: 'form',
			items: [
				/*{
					xtype:'checkbox',
					fieldLabel: 'Yazdýr',
					name: 'printing',
					id: 'printing',
					width: 100,
					align: 'right',
					labelWidth: 20
				}*/
			]
		}
	]
}],

        buttons: [
            {
                tooltip:'Yapýlan deðiþiklikleri geri al',
                text : 'Ýptal',
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
                    Ext.getCmp('xcezali_detay').close();//hide();//close();
                }
            },
			'-',
            '-',
            {
                tooltip:'Yapýlan deðiþiklikleri kaydet.',
                text : 'Kaydet',
                disabled:<%=duzelt%>,
                //iconCls: 'x-button-cancel'
                icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                handler:function() {
               
                    var plaka = Ext.get('xplaka').getValue();	
					var borc = Ext.get('xfiyat').getValue();	
					var tutar = Ext.get('textbakiye').getValue();	
					if( tutar > borc ){
						msg('Warning', "Borc tutarýndan fazla tahsilat yapýlamaz!");
						return;
					}
					cezatahsilat(plaka,tutar);
                }
            }
        ]
});
adetay.render('cezali_tahsilat');

/*Ext.onReady(function(){
	detay_yaz(Ext.getCmp('gridAbonedetay'), Ext.get('xabone').getValue(), 0, 0, 0, 1, 0);
});*/

</script>

