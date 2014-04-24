
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<div id="alan_detay_info" class="info"></div>

<div id="adetay"></div>

<script type="text/javascript">				
			
function detay_yaz(gr, abone, alloff, yaz){	

    Ext.Ajax.request({
        url : 'adapter/jsp/alan.jsp',
        params : {
            action : 'edetay',
            p_alan : abone,
            p_alloff : alloff,
            p_yaz : yaz
        },
        success : function(response) {	
		
            var obj;
            gr.el.unmask();
            try{
                obj = Ext.util.JSON.decode(response.responseText);
            }
            catch(e){
                Ext.get('alan_detay_info').addClass('error');
                Ext.fly('alan_detay_info').update(response.responseText);
            }
            if(!obj.success){
                Ext.get('alan_detay_info').addClass('error');
                Ext.fly('alan_detay_info').update(obj.errors.reason);
            }
            else{
				alert('Ýþlem sonucu:' + obj.errors.reason);
				Ext.getCmp('xekle').close();//hide();//close();
				gr.getStore().load({params:{start:0, limit:30}});
				Ext.getCmp('detayGrid').store.load({params:{action:'detay', abone:abone,start:0, limit:10}});
            }
        },
        failure: function(f,a){
		
            Ext.get('alan_detay_info').addClass('error');
            Ext.fly('alan_detay_info').update(' (' + i + ') *' + a.response.statusText);
            if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
            }
            else if (a.failureType === Ext.form.Action.SERVER_INVALID){
                msg('Warning', a.result.errormsg);
            }
			else{
				msg('Error!', a.response.statusText);
			}
        }
    });
}

 var alanStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'peron_id',
                        fields: [
                    'id', 'kod', 'tanim', 'aciklama', 'sure1', 'sure2', 'tolerans', 'fiyat',
                     {name: 'durum', type: 'boolean'}, {name: 'ozel_tarife', type: 'boolean'}, 'sira', 'firma', 'kayit_tarihi', 'kayit_kullanici'],
                        root: 'rows'
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/fiyat.jsp?action=fiyat'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: true
                });			

var sm = new Ext.grid.CheckboxSelectionModel({
/*listeners:{
    rowselect : function( selectionModel, rowIndex, record){ 
    //var kivalasztott="";
    var selectedRows = selectionModel.getSelections();
    if( selectedRows.length > 0){                         
        for( var i = 0; i < selectedRows.length; i++) {
			//kivalasztott=kivalasztott+' '+selectedRows[i].get('id')+'-'+selectedRows[i].get('description');
		  
			alert(selectedRows[i].get('bolge_id') + ',' + selectedRows[i].get('alan_id') + ',' + selectedRows[i].get('peron_id'));
			detay_yaz(Ext.getCmp('gridAbonedetay'),Ext.get('xabone').getValue(),selectedRows[i].get('bolge_id'),selectedRows[i].get('alan_id'),selectedRows[i].get('peron_id'),0,i++);	
		  
        }
    }
     Ext.Msg.alert('Kivalasztva',kivalasztott);
    }
}*/

});
				
				
//var sm = new Ext.grid.CheckboxSelectionModel();
    var grid2 = new Ext.grid.GridPanel({
        id: 'gridAlandetay',
        store: alanStore,
        cm: new Ext.grid.ColumnModel({
            defaults: {
                width: 120,
                sortable: true
            },
            columns: [
                sm,
				new Ext.grid.RowNumberer(),
                {id:'kod', header: "Fiyat Kod", width: 200, dataIndex: 'kod'},
                {id:'tanim', header: "Fiyat Taným", dataIndex: 'tanim', width: 215},
                {id:'aciklama', header: "Açýklama", dataIndex: 'aciklama', hidden: false},
                {id:'sure1', header: "Süre-1", dataIndex: 'sure1', hidden: false},
                {id:'sure2', header: "Süre-2", width: 135, dataIndex: 'sure2', hidden: false},
                {id:'fiyat ', header: "Fiyat", width: 135, dataIndex: 'fiyat', hidden: false}
            ]
        }),
        sm: sm,
        columnLines: true,
        width:560,
        height:340,
        frame:true,
        title:'Fiyat Tanýmlarý',
        iconCls:'icon-grid'/*,
        renderTo: document.body*/
    });
 
var adetay = new Ext.FormPanel({
    //id: 'abone_detay',
    labelAlign: 'left',
    frame:true,
    bodyStyle:'padding:5px 5px 0',
    width: 600,
    height:420,
    items: [{
        layout:'column'/*,
        items:[{
            columnWidth:.5,
            layout: 'form',
            items: [combolge]
        },{
            columnWidth:.5,
            layout: 'form',
            items: [comalan]
    }]*/
    }, grid2],

        buttons: [
            {
                tooltip:'Yapýlan deðiþiklikleri geri al',
                text : 'Ýptal',
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
                    Ext.getCmp('xekle').close();//hide();//close();
                }
            },
			'-',
			{
                tooltip:'Tümünü Sil',
                text : 'Tümünü Sil',
                disabled:<%=sil%>,
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
                    var gr = Ext.getCmp('gridAlandetay');                  
                    var alan = Ext.get('xalan').getValue();
                    detay_yaz(gr, alan, '', '1');	
                    return;
                }
            },
            '-',
            {
                tooltip:'Yapýlan deðiþiklikleri kaydet.',
                text : 'Kaydet',
                disabled:<%=duzelt%>,
                //iconCls: 'x-button-cancel'
                icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                handler:function() {

                    var gr = Ext.getCmp('gridAlandetay');
                    var rows = gr.getSelectionModel().getSelections();                    
                    var alan = Ext.get('xalan').getValue();									

                    var alloffdatas = '';

                    //Ext.get('abone_detay_info').addClass('warning');
                    //Ext.fly('abone_detay_info').update('Kaydediliyor ...');								
                    //detay_yaz(gr,abone,bolge,alan,peron,1,i++);

                    for(var i = 0; i < rows.length; i++){	
                                                
                                                alloffdatas += rows[i].get('id');
						
						if(i != rows.length -1)
							alloffdatas += '>';

                        //Ext.fly('abone_detay_info').update('Kaydediliyor ... ' + rows.length + '/' + (i++)); 
						//alert(rows[i].get('bolge_id') + ',' + rows[i].get('alan_id') + ',' + rows[i].get('peron_id'));
                        //detay_yaz(gr,abone,rows[i].get('bolge_id'),rows[i].get('alan_id'),rows[i].get('peron_id'),0,i++);						
						//ssleep(500);                                               
                    }					
					detay_yaz(gr, alan, alloffdatas, '0');									                    
                }
            },
            '-'
        ]
});
adetay.render('adetay');

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}

/*Ext.onReady(function(){
	detay_yaz(Ext.getCmp('gridAbonedetay'), Ext.get('xabone').getValue(), 0, 0, 0, 1, 0);
});*/

</script>

