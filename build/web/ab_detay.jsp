
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="abone_detay_info" class="info">
	Peron se�ilmeyen <strong>abone</strong> b�t�n peronlara <strong>Tan�ml�</strong> say�l�r.<br>
    Sadece <strong>B�lge</strong> se�erek <strong>Kaydet</strong> denilirse b�lgenin alt�ndaki t�m peronlara <strong>Abone</strong> olur.<br>
    Sadece belli <strong>peron</strong>lara a�mak i�in <strong>B�lge</strong> ve <strong>Alan</strong> se�ilerek alt�ndaki <strong>Peron</strong>lar se�ilmelidir.<br>
</div> 

<div id="adetay"></div>

<script type="text/javascript">

//detay_yaz(gr, abone, alloffdatas, '0');				
			
function detay_yaz(gr, abone, alloff, yaz){	

    Ext.Ajax.request({
        url : 'adapter/jsp/abone.jsp',
        params : {
            action : 'edetay',
            p_abone : abone,
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
                Ext.get('abone_detay_info').addClass('error');
                Ext.fly('abone_detay_info').update(response.responseText);
            }
            if(!obj.success){
                Ext.get('abone_detay_info').addClass('error');
                Ext.fly('abone_detay_info').update(obj.errors.reason);
            }
            else{
				alert('��lem sonucu:' + obj.errors.reason);
				Ext.getCmp('xekle').close();//hide();//close();
				gr.getStore().load({params:{start:0, limit:30}});
				Ext.getCmp('detayGrid').store.load({params:{action:'detay', abone:abone,start:0, limit:10}});
            }
        },
        failure: function(f,a){
		
            Ext.get('abone_detay_info').addClass('error');
            Ext.fly('abone_detay_info').update(' (' + i + ') *' + a.response.statusText);
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
                            'peron_id',
                            'peron',
                            'alan',
                            'alan_id',
                            'bolge',
                            'bolge_id'],
                        root: 'rows'
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/abone.jsp'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false
                });
				
 var bolgeStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'bolge_id',
                        fields: [
                            'bolge',
                            'bolge_id'],
                        root: 'rows'
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/abone.jsp?action=bolgeler'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: true
                });	

 var alStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'alan_id',
                        fields: [
                            'bolge',
                            'bolge_id',
							'alan',
                            'alan_id'],
                        root: 'rows'
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/abone.jsp'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false
                });					

var combolge = new Ext.form.ComboBox({
                store: bolgeStore,
                id: 'cmbbolge',
                fieldLabel: 'B�lge Tan�m',
                /*tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item">B�lge: <strong>{bolge}</strong></div>Alan: <h3>{alan}</h3>Peron: <h5>{peron}</h5></tpl>'
                ),*/
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'bolge_id',
                //itemSelector: 'div.search-item',
                displayField: 'bolge',
                autocomplete: true,
                emptyText: 'B�lge se�in',
				lastQuery:'',
                triggerAction: 'all',
                value: '',
                listeners:{
                    select:{fn:function(combo, value, index) {
							Ext.getCmp('cmbalan').store.removeAll();
							Ext.getCmp('gridAbonedetay').store.removeAll();	
							Ext.getCmp('cmbalan').store.load({params:{action:'tumalanlar', bolge:Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id']}});
							Ext.getCmp('gridAbonedetay').store.load({params:{action:'alanlar', bolge:Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id'], start:0, limit:10}});
                            //Ext.getCmp('gridAbonedetay').store.filter('bolge_id', Ext.getCmp('gridAbonedetay').store.getAt(index).data['bolge_id']);
							//Ext.getCmp('cmbalan').store.filter('bolge_id', Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id']);
							//Ext.getCmp('gridAbonedetay').store.filter('bolge_id', Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id']);
                        }}}
                });							

var comalan = new Ext.form.ComboBox({
                store: alStore,
                id: 'cmbalan',
                fieldLabel: 'Alan Tan�m',
                /*tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item">B�lge: <strong>{bolge}</strong></div>Alan: <h3>{alan}</h3>Peron: <h5>{peron}</h5></tpl>'
                ),*/
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'alan_id',
                //itemSelector: 'div.search-item',
                displayField: 'alan',
                autocomplete: true,
                emptyText: 'Alan se�in',
                triggerAction: 'all',
				lastQuery:'',
                value: '',
                listeners:{
                    select:{fn:function(combo, value, index) {
							Ext.getCmp('gridAbonedetay').store.removeAll();
							Ext.getCmp('gridAbonedetay').store.load({params:{action:'alanlar', alan:Ext.getCmp('cmbalan').store.getAt(index).data['alan_id'],start:0, limit:10}});
                            //Ext.getCmp('gridAbonedetay').store.filter('alan_id', Ext.getCmp('cmbalan').store.getAt(index).data['alan_id']);
                        }}}
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
        id: 'gridAbonedetay',
        store: alanStore,
        cm: new Ext.grid.ColumnModel({
            defaults: {
                width: 120,
                sortable: true
            },
            columns: [
                sm,
                {id:'peron_id', header: "Peron ID", width: 200, dataIndex: 'peron_id'},
                {id:'peron', header: "Peron", dataIndex: 'peron', width: 215},
                {id:'alan', header: "Alan", dataIndex: 'alan', hidden: true},
                {id:'alan_id', header: "Alan ID", dataIndex: 'alan_id', hidden: true},
                {id:'bolge', header: "bolge", width: 135, dataIndex: 'bolge', hidden: true},
                {id:'bolge_id', header: "B�lge ID", width: 135, dataIndex: 'bolge_id', hidden: true}
            ]
        }),
        sm: sm,
        columnLines: true,
        width:560,
        height:340,
        frame:true,
        title:'Peronlar',
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
        layout:'column',
        items:[{
            columnWidth:.5,
            layout: 'form',
            items: [combolge]
        },{
            columnWidth:.5,
            layout: 'form',
            items: [comalan]
    }]
    }, grid2],

        buttons: [
            {
                tooltip:'Yap�lan de�i�iklikleri geri al',
                text : '�ptal',
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
                    Ext.getCmp('xekle').close();//hide();//close();
                }
            },
			'-',
			{
                tooltip:'T�m�n� Sil',
                text : 'T�m�n� Sil',
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
					var gr = Ext.getCmp('gridAbonedetay');                  
                    var abone = Ext.get('xabone').getValue();
					detay_yaz(gr, abone, '', '1');	
					return;
                }
            },
            '-',
            {
                tooltip:'Yap�lan de�i�iklikleri kaydet.',
                text : 'Kaydet',
                //iconCls: 'x-button-cancel'
                icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                handler:function() {

                    var gr = Ext.getCmp('gridAbonedetay');
                    var rows = gr.getSelectionModel().getSelections();                    
                    var abone = Ext.get('xabone').getValue();									
					
                    var alan = 0;
                    var bolge = Ext.getCmp('cmbbolge').getValue();
					var peron = 0;
					var alloffdatas = '';
					
					if(bolge < 1){
						alert('B�lge se�in..!');
						return;
					}
					
					if(rows.length == 0){
						detay_yaz(gr, abone, bolge, '0');return;
					}

                    //Ext.get('abone_detay_info').addClass('warning');
                    //Ext.fly('abone_detay_info').update('Kaydediliyor ...');								
                    //detay_yaz(gr,abone,bolge,alan,peron,1,i++);

                    for(var i = 0; i < rows.length; i++){	
						
						peron = rows[i].get('peron_id');
						bolge = rows[i].get('bolge_id');
						alan = rows[i].get('alan_id');
						
						alloffdatas += bolge + ';' + alan + ';' + peron;
						
						if(i != rows.length -1)
							alloffdatas += '>';

                        //Ext.fly('abone_detay_info').update('Kaydediliyor ... ' + rows.length + '/' + (i++)); 
						//alert(rows[i].get('bolge_id') + ',' + rows[i].get('alan_id') + ',' + rows[i].get('peron_id'));
                        //detay_yaz(gr,abone,rows[i].get('bolge_id'),rows[i].get('alan_id'),rows[i].get('peron_id'),0,i++);						
						//ssleep(500);                                               
                    }					
					detay_yaz(gr, abone, alloffdatas, '0');									                    
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

