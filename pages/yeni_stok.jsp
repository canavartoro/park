
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<div id="sdetay"></div>

<script type="text/javascript">

				
			 
function stok_yaz(){	

	var s_stokyeni = Ext.get('x_stok').getValue();
	
	if( s_stokyeni == '' ){
		alert('Açýklama girin.');
		return;
	}

    Ext.Ajax.request({
        url : 'adapter/jsp/alan.jsp',
        params : {
            action : 'sdetay',
            s_stok : s_stokyeni
        },
        success : function(response) {	
			
            var obj;
            try{
                obj = Ext.util.JSON.decode(response.responseText);
            }
            catch(e){
                alert(response.responseText);
            }
            if(!obj.success){
                alert(obj.errors.reason);
            }
            else{
				alert('Ýþlem sonucu:' + obj.errors.reason);
				Ext.getCmp('sEkle').close();//hide();//close();
            }
        },
        failure: function(f,a){
			alert(a.response.statusText);
        }
    });
}


var adetay = new Ext.FormPanel({
    //id: 'abone_detay',
    labelAlign: 'left',
    frame:true,
    bodyStyle:'padding:5px 5px 0',
    width: 385,
    height:170,
    items: [{
            xtype:'fieldset',
            title: 'Açýklama',
            collapsible: true,
            autoHeight:true,
            defaults: {width: 210},
            defaultType: 'textfield',
            items :[{
                    fieldLabel: 'Açýklama',
                    id: 'x_stok',
                    value: ''
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
                    Ext.getCmp('sEkle').close();//hide();//close();
                }
            },
            '-',
            {
                tooltip:'Yapýlan deðiþiklikleri kaydet.',
                text : 'Kaydet',
                //iconCls: 'x-button-cancel'
                icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                handler:function() {
					stok_yaz();
                }
            },
            '-'
        ]
});
adetay.render('sdetay');

/*Ext.onReady(function(){
	detay_yaz(Ext.getCmp('gridAbonedetay'), Ext.get('xabone').getValue(), 0, 0, 0, 1, 0);
});*/

</script>

