<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/hesap/cezali.jsp

--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../../adapter/jsp/yetki.jsp" %>

<%
response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1);
%>

<!-- <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE"> 
<META HTTP-EQUIV="Expires" CONTENT="-1"> -->

<div id="ceza-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
	
    function cezatahsilat(){
        
        var x = Ext.get('xplaka').getValue();

        if(x == ''){
            msg('Hata!','Kayýt seçin! (' + x + ')');
            return;
        }                  

        var ek = new Ext.Window({
            id: "xcezali_detay",
            layout: "fit",
            title: "Otopark Ceza Tahsilat",
            iconCls: "icon-fiyat",
            width: 510,
            height: 230,
            maximizable: false,
            constrain: true,
            resizable: false,
            autoScroll: false,
            closeAction : 'close',
            autoLoad: {
                showMask: true,
                scripts: true,
                maskMsg: 'Yükleniyor..',
                mode: "iframe",
                url: 'pages/hesap/ceza_tahsilat.jsp?ekle=<%=ekle%>&sil=<%=sil%>&duzelt=<%=duzelt%>'
            }
        });

        ek.show();
       
    }

	
    Ext.onReady(function(){
	
        Ext.QuickTips.init();	  
        
        var ds_model = Ext.data.Record.create([
            'id', 'plaka', 'bakiye', 'tarih1', 'tarih2'
        ]);
        
        var cezaDelete = function(forDelete) {
            
            var grid = Ext.getCmp('cezaGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/hesap/cezali.jsp',
                params : {
                    action : 'asil',
                    toDelete : forDelete.data.plaka
                },
                success : function(response) {
                    grid.el.unmask();
                    var obj = Ext.util.JSON.decode(response.responseText);
                    if(!obj.success){
                        msg('Kayýt silinemedi!', obj.errors.reason);
                    }
                    else{
                        grid.getStore().load({params:{start:0, limit:30}});
                        //grid.getStore().remove(forDelete);
                    }
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
             
             var cezaStore = new Ext.data.Store({
             reader: new Ext.data.JsonReader({
             id: 'id',
             totalProperty: 'totalCount',
             idProperty: 'id',
                fields: [
						'id', 'plaka', 'bakiye', 'tarih1', 'tarih2'
					],				
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/hesap/cezali.jsp?action=allceza'
                }),
                listeners: {
                load : function(store, records, options) {
                    //// only load with filled array!
                    ////console.log('done');
                },
                exception : function(proxy, type, action, options, res, arg) {
                    ////console.log(type,action,options, res, arg);
                    ////alert('bir hata olustu:' + res.statusText + proxy.url);
                }
            },
            autoLoad: true,
            autoDestroy: true
            });
            cezaStore.on('loadexception', function(event, options, response, error) {
            ////var rs = Ext.util.JSON.decode(response.responseText);
            ////alert("sunucu hatasi:" + response.responseText);
            ////event.stopEvent();
            });

        var pagingCeza = {
            xtype : 'paging',
            store : cezaStore,
            pageSize : 30,
            displayInfo : true,
            items : [
                '-',
                {
                    tooltip:'Seçilen kaydý sil',
                    text : 'Sil',
                    disabled:<%=sil%>,
                    icon: 'resources/icons/delete.png',
                    handler:function() {
                        var grid = Ext.getCmp('cezaGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.plaka + ' Kayýt silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                cezaDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Tahsilat',
                    disabled:<%=duzelt%>,
                    handler : cezatahsilat,
                    icon: 'resources/images/money_dollar.png'
                    //iconCls: 'x-button-ok'
                },
                '-',
                {
                    tooltip:'Yapýlan deðiþiklikleri geri al',
                    text : 'Ýptal',
                    icon: 'resources/icons/bullet_cross.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        Ext.getCmp('cezaGrid').getStore().rejectChanges();
                    }
                },
                '-'
                ]
        }
		
		var xDate=new Date();
		xDate.setDate(new Date().getDate()+1);
		
        var gridCelilar = new Ext.grid.EditorGridPanel({
            id:'cezaGrid',
            region:'center',
            ds: cezaStore,
            title:'Cezalý Plakalar',
            iconCls: 'icon-cls',
            border: true,
            autoScroll: true,
            autoHeight: true,
            autoWidth: true,
            split:true,
            height:500,
            collapsible: true,
            animate: true,
            autoSizeColumns: true,
            sm:new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                selectionchange: function(sel){
                    var rec = sel.getSelected();
                    if(rec){
                        Ext.getCmp('xplaka').setValue(rec.get('plaka'));
						Ext.getCmp('xfiyat').setValue(rec.get('bakiye'));
                        Ext.getCmp('cezadetayGrid').store.removeAll();
                        Ext.getCmp('cezadetayGrid').store.load({params:{action:'1detaylar', plaka:rec.get('plaka'),start:0, limit:30}});
                    }
                },
                beforeedit : function(e) {
                    //alert(e.record.get('bitis_tarihi'));
					//this.currentlyEditedRecord = e.record;
					/*if(e.record.data.TaskType === '' && e.field !== 'TaskType') {
						//TODO (enhancement) This would be great if it didn't interrupt the tabbing between fields in the grid.
						return false;
					}*/
		}                
            },
            render: {
                fn: function(){
                    cezaStore.load({
                        params: {
                            start: 0,
                            limit: 30
                        }
                    });
                }
            }
            }),
            viewConfig: {
                forceFit: true
            },
            clicksToEdit: 0,
            mode: 'remote',
            autoExpandColumn : 'plaka',
            loadMask         : true,
            maskMsg          : 'Yükleniyor..',
            stripeRows: true,
            cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
                {
                    header: 'Fiþ ID',
                    width: 80,
                    dataIndex: 'id',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'numeric'
                    }
                },
                {
                    header: 'Plaka No',
                    width: 260,
                    dataIndex: 'plaka',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                },
				{
                    header: 'Bakiye',
                    dataIndex: 'bakiye',
                    width: 70,
                    align: 'right'
                },
                {
                    header: 'KayitTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'tarih1'
                },
				{
                    header: 'GüncellemeTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'tarih2'
                }]),
            bbar    : [
                pagingCeza,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xplaka',
                    name: 'xplaka',
                    value: ''
                },
				{
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xfiyat',
                    name: 'xfiyat',
                    value: ''
                }
                ],
            tbar:[
                {
                    xtype:'label',
                    fieldLabel: 'Tarih:',
                    text: 'Tarih:'
                },
                {
                  xtype:'datefield',
                  id:'date_field1',
				  format:'Y-m-d',
				  dateFormat:'Y-m-d',
				  altFormats:'Y-m-d',
				  //altFormats:'Y-m-d H:i:s.u',
                  hideLabel: false,
				  value:new Date(),
                  //anchor:'50%',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Tarih',
                    text: 'Tarih:'
                },
                {
                  xtype:'datefield',
                  id:'date_field2',
				  format:'Y-m-d',
				  dateFormat:'Y-m-d',
				  altFormats:'Y-m-d',
				  value:xDate,
				  //altFormats:'Y-m-d H:i:s.u',
                  hideLabel: false,
                  //anchor:'50%',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },'-',
                {
                    tooltip:'Kayýtlarý Al',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',                    
                    handler:function() {
						
                        var delete_ok = 0;
						var date_field1 = Ext.getCmp('date_field1');
                        var date_field2 = Ext.getCmp('date_field2');
					
						var winHandle = window.open("adapter/jsp/hesap/cezali.jsp?action=aexcel&after_delete=" + delete_ok + "&date1=" + formatDate(date_field1.getValue(),'yyyy-MM-dd')  + "&date2=" + formatDate(date_field2.getValue(),'yyyy-MM-dd') , "_top", 
								"width=600,height=800,location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

						if (winHandle == null){
							msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
						}
					
						/*Ext.MessageBox.confirm(
							'Dikkat!',
							'Kayýtlar aktarýldýktan sonra liste boþaltýlsýn mý?',
							function(btn) {
								
								if (btn == 'yes') {	
									delete_ok = 1;
								}
								var winHandle = window.open("adapter/jsp/hesap/cezali.jsp?action=aexcel&after_delete=" + delete_ok + "&date1=" + date_field1 + "&date2=" + date_field2, "_top", 
								"width=600,height=800,location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

								if (winHandle == null){
									msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
								}
							}
						);*/ 

               }
            }
                ]
                });

                /***************************************SOUTH PANEL********************************************/

                var ds_cezali_model = Ext.data.Record.create([
                    'id', 'fisno', 'kullanici2', 'peron', 'alan', 'bolge', 'tarife', 'tarih1', 'tarih2', 'psure', 'gsure', 'fiyat'
                ]);              

                var cezaDetayStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'id',
                        fields: ['id', 'fisno', 'kullanici2', 'peron', 'alan', 'bolge', 'tarife', 'tarih1', 'tarih2', 'psure', 'gsure', 'fiyat'],
                        root: 'rows'/*,
                        baseParams: {
                           action:   '1detaylar'
                       }*/
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/hesap/cezali.jsp'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false
                });

                var pagingDetay = {
                    xtype : 'paging',
                    store : cezaDetayStore,
                    pageSize : 30,
                    displayInfo : true,
                    items : []
                }


                var gridcezaliDetaylar = new Ext.grid.EditorGridPanel({
                id:'cezadetayGrid',
                region:'center',
                title:'Tarife Detay Bilgileri',
                iconCls: 'icon-cls',
                ds: cezaDetayStore,
                border: true,
                autoScroll: true,
                autoHeight: true,
                autoWidth: true,
                bodyStyle:'padding:8px 8px 0',
                split:true,
                collapsible: true,
                animate: true,
                autoSizeColumns: true,
                sm: new Ext.grid.RowSelectionModel({
                    singleSelect:true,
                    listeners: {
                    selectionchange: function(sel){
                        /*var rec = sel.getSelected();
                        if(rec){
                            Ext.getCmp('xabonedetay').setValue(rec.get('id'));							
                        }*/
                    }
                }
                }),
                viewConfig: {
                    forceFit:true,
                    enableRowBody:true,
                    showPreview:true
                },
                clicksToEdit: 0,
                mode: 'remote',
                autoExpandColumn : 'peron',
                loadMask         : true,
                maskMsg          : 'Yükleniyor..',
                stripeRows: true,
                cm: new Ext.grid.ColumnModel([
                    {
                        header: 'Kayit Id',
                        width: 80,
                        dataIndex: 'id',
                        sortable: true,
                        hidden: true
                    },
                    {
                        header: 'Fiþ No',
                        width: 260,
                        dataIndex: 'fisno',
                        sortable: true,                        
                        blankText: '',
                        hidden: true
                    },
                    {
                        header: 'Kullanýcý (2)',
                        width: 160,
                        dataIndex: 'kullanici2',
                        blankText: ''
                    },
                    {
                        header: 'Peron Tanimi',
                        width: 160,
                        dataIndex: 'peron',
                        blankText: ''
                    },
					{
                        header: 'Alan Tanimi',
                        width: 160,
                        dataIndex: 'alan',
                        blankText: ''
                    },
					{
                        header: 'Bölge Tanimi',
                        width: 160,
                        dataIndex: 'bolge',
                        blankText: ''
                    },
					{
                        header: 'Tarife Tanimi',
                        width: 160,
                        dataIndex: 'tarife',
                        blankText: ''
                    },
                    {
                        header: 'KayitTarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'tarih1'
                    },
					{
                        header: 'ÇýkýþTarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'tarih2'
                    },
                    {
                        header: 'P.Süre',
                        width: 60,
                        dataIndex: 'psure'
                    },
					{
                        header: 'G.Süre',
                        width: 60,
                        dataIndex: 'gsure'
                    },
					{
                        header: 'Fiyat',
                        width: 60,
                        dataIndex: 'fiyat'
                    }]),
                    bbar    : [
                    pagingDetay
                    ]					
                    });

/******************************************************************************/

                var displayPanel = new Ext.Panel({
                frame: true,
                border : true,
                split:true,
                bodyStyle:'padding:5px 5px 0',
                width:'100%',
                height:'100%',
                iconCls: 'icon-cls',
                autoHeight:true,               
                renderTo : 'ceza-win',
                items    : [
                gridCelilar,
                gridcezaliDetaylar
                ]
                });

                 cezaStore.load({params:{start:0, limit:30}});
    });    

</script>
