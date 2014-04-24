
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<%@include file="../../adapter/jsp/yetki.jsp" %>

<div id="fiyat_detay"></div>

<script type="text/javascript">

//detay_yaz(gr, abone, alloffdatas, '0');				
			
function detay_yaz(gr, fiyat, alloff, yaz){	

    Ext.Ajax.request({
        url : 'adapter/jsp/hesap/fiyat_tanim.jsp',
        params : {
            action : 'edetay',
            p_fiyat : fiyat,
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
                Ext.get('fiyat_detay_info').addClass('error');
                Ext.fly('fiyat_detay_info').update(response.responseText);
            }
            if(!obj.success){
                Ext.get('fiyat_detay_info').addClass('error');
                Ext.fly('fiyat_detay_info').update(obj.errors.reason);
            }
            else{                               
                gr.getStore().load({params:{start:0, limit:30}});
                Ext.getCmp('fiyatdetayGrid').store.load({params:{action:'alanlar', tarife:fiyat,start:0, limit:30}});
                Ext.getCmp('xfiyat_detay').close();//hide();//close();
            }
            Ext.getCmp('fiyatdetayGrid').store.removeAll();
            Ext.getCmp('fiyatdetayGrid').store.load({params:{action:'detay', abone:Ext.get('xabone').getValue()}});
            Ext.getCmp('xfiyat_detay').close();
        },
        failure: function(f,a){
            
            Ext.get('fiyat_detay_info').addClass('error');
            Ext.fly('fiyat_detay_info').update(' (' + i + ') *' + a.response.statusText);
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
                        url: 'adapter/jsp/hesap/fiyat_tanim.jsp?action=tumalanlar'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: true
                });					

var combolge = new Ext.form.ComboBox({
                store: bolgeStore,
                id: 'cmbbolge',
                listWidth:300,
                width:300,
                fieldLabel: 'Bölge Taným',
                /*tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item">Bölge: <strong>{bolge}</strong></div>Alan: <h3>{alan}</h3>Peron: <h5>{peron}</h5></tpl>'
                ),*/
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'bolge_id',
                //itemSelector: 'div.search-item',
                displayField: 'bolge',
                autocomplete: true,
                emptyText: 'Bölge seçin',
                triggerAction: 'all',
                value: '',
                listeners:{
                    select:{fn:function(combo, value, index) {
                            //Ext.getCmp('gridAbonedetay').store.filter('bolge_id', Ext.getCmp('gridAbonedetay').store.getAt(index).data['bolge_id']);
							Ext.getCmp('cmbalan').store.filter('bolge_id', Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id']);
							Ext.getCmp('gridAbonedetay').store.filter('bolge_id', Ext.getCmp('cmbbolge').store.getAt(index).data['bolge_id']);
                        }}}
                });							

var comalan = new Ext.form.ComboBox({
                store: alStore,
                id: 'cmbalan',
                fieldLabel: 'Alan Taným',
                /*tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item">Bölge: <strong>{bolge}</strong></div>Alan: <h3>{alan}</h3>Peron: <h5>{peron}</h5></tpl>'
                ),*/
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'alan_id',
                //itemSelector: 'div.search-item',
                displayField: 'alan',
                autocomplete: true,
                emptyText: 'Alan seçin',
                triggerAction: 'all',
                value: '',
                listeners:{
                    select:{fn:function(combo, value, index) {
                            Ext.getCmp('gridAbonedetay').store.filter('alan_id', Ext.getCmp('cmbalan').store.getAt(index).data['alan_id']);
                        }}}
                });

var sm = new Ext.grid.CheckboxSelectionModel({});
				
				
    var grid2 = new Ext.grid.GridPanel({
        id: 'gridAbonedetay',
        store: alStore,
        cm: new Ext.grid.ColumnModel({
            defaults: {
                width: 120,
                sortable: true
            },
            columns: [
                sm,
                {id:'alan', header: "Alan", dataIndex: 'alan', hidden: false},
                {id:'alan_id', header: "Alan ID", dataIndex: 'alan_id', hidden: false},
                {id:'bolge', header: "bolge", width: 135, dataIndex: 'bolge', hidden: true},
                {id:'bolge_id', header: "Bölge ID", width: 135, dataIndex: 'bolge_id', hidden: true}
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
    width: 500,
    height:200,
    items: [{
        layout:'column',
        items:[{
            columnWidth:.9,
            layout: 'form',
            items: [combolge]
        }/*,{
            columnWidth:.5,
            layout: 'form',
            items: [comalan]
    }*/]
    }/*, grid2*/],

        buttons: [
            {
                tooltip:'Yapýlan deðiþiklikleri geri al',
                text : 'Ýptal',
                //iconCls: 'x-button-cancel'
                icon: 'resources/icons/bullet_cross.png',
                handler: function(){
                    Ext.getCmp('xfiyat_detay').close();//hide();//close();
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
                    var fiyat = Ext.get('xfiyat').getValue();
                    detay_yaz(Ext.getCmp('fiyatdetayGrid'), fiyat, '', '1');
                    Ext.getCmp('fiyatdetayGrid').store.removeAll();
                    Ext.getCmp('fiyatdetayGrid').store.load({params:{action:'1detaylar', tarife:fiyat,start:0, limit:30}});
                    Ext.getCmp('xfiyat_detay').close();
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

                    var gr = Ext.getCmp('gridAbonedetay');
                    //var rows = gr.getSelectionModel().getSelections();                   
                    var fiyat = Ext.get('xfiyat').getValue();									

                    //var alloffdatas = '';
                    var bolge = combolge.getValue();
                    /*for(var i = 0; i < rows.length; i++){
                        alloffdatas += rows[i].get('alan_id') + ';';
                    }*/
                   
                    detay_yaz(gr, fiyat, bolge, '0');
                    
                    Ext.getCmp('fiyatdetayGrid').store.removeAll();
                    Ext.getCmp('fiyatdetayGrid').store.load({params:{action:'1detaylar', tarife:fiyat,start:0, limit:30}});
                    
                    //Ext.get('abone_detay_info').addClass('warning');
                    //Ext.fly('abone_detay_info').update('Kaydediliyor ...');								
                    //detay_yaz(gr,abone,bolge,alan,peron,1,i++);									                    
                }
            }
        ]
});
adetay.render('fiyat_detay');

/*Ext.onReady(function(){
	detay_yaz(Ext.getCmp('gridAbonedetay'), Ext.get('xabone').getValue(), 0, 0, 0, 1, 0);
});*/

</script>

