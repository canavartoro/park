<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/peron.jsp

--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<%
response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1);
%>

<!-- <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE"> 
<META HTTP-EQUIV="Expires" CONTENT="-1"> -->

<div id="perond-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
	
    function ekler(){
        var x = Ext.get('xabone').getValue();

        if(x == ''){
            msg('Hata!','Abone seçin! (' + x + ')');
            return;
        }

        var ek = new Ext.Window({
            id: "xekle",
            layout: "fit",
            title: "Abone Detay.",
            iconCls: "icon-user",
            width: 600,
            height: 500,
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
                url: 'pages/abone_detay.jsp'
            }
        });

        ek.show();
    }

    Ext.onReady(function(){

        Ext.QuickTips.init();
		
	var tarifeStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: [
                    'id', 'tanim'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/fiyat.jsp?action=fiyat'
            }),
            autoLoad: true
        });
		
	var comboTarife = {
            xtype : 'combo',
            id : 'comboTarife',
            triggerAction : 'all',
            displayField : 'tanim',
            valueField : 'id',
            fieldLabel:'Tarife Tanýmlarý',
            listWidth:250,
            width:250,
            store : tarifeStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{select:{fn:function(combo, value, index) {}}}
        }
        
        var peronlarStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: [
                    'id', 'kod'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/alan.jsp?action=peronlar'
            }),
            autoLoad: true
        });
        
        var comboPeronlar = {
            xtype : 'combo',
            id : 'comboPeronlar',
            triggerAction : 'all',
            displayField : 'kod',
            valueField : 'id',
            fieldLabel:'Peron Tanýmlarý',
            listWidth:350,
            width:250,
            store : peronlarStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{select:{fn:function(combo, value, index) {}}}
        }
		
	var myData = {
            records : [
                { displays : "Tahsil Edilemedi", values : "Tahsil Edilemedi" },
                { displays : "Tahsil Edildi", values : "Tahsil Edildi" },
                { displays : "GIRIS", values : "GIRIS" },
                { displays : "NAKIT", values : "NAKIT" }
            ]
        }
        
        var gridStore = new Ext.data.JsonStore({
            fields :  [
                {name: 'displays', mapping : 'displays'},
                {name: 'values', mapping : 'values'}
            ],
            data   : myData,
            root   : 'records',
            autoLoad: true
        });
        
        var comboEditor = {
            xtype : 'combo',
            triggerAction : 'all',
            displayField : 'displays',
            valueField : 'values',
            store : gridStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....'
        }
        
        var ds_model = Ext.data.Record.create([
            'id','fisno','kullanici1','peron','peron_tanim','tarife','plaka', 'aciklama','tarih1','saat1','psure','pdurum','gecen_sure','sure_asimi','alan_tanim', 'bolge_tanim', 'fiyat'
        ]);
        
        var aboneDelete = function(forDelete) {
            
            var grid = Ext.getCmp('gridPeronlar');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/peron.jsp',
                params : {
                    action : 'asil',
                    toDelete : forDelete.data.id
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

         var aboneSave = function() {
         var modified = aboneStore.getModifiedRecords(); // 1
         if (modified.length > 0) {
             var recordsToSend = [];
             Ext.each(modified, function(record) { // 2
                 recordsToSend.push(record.data);
             });
             var grid = Ext.getCmp('gridPeronlar');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
             grid.stopEditing();
             recordsToSend = Ext.encode(recordsToSend);
             Ext.Ajax.request({
                 url : 'adapter/jsp/peron.jsp',
                 params : {
                     action : 'akayit',
                     recordsToInsertUpdate : recordsToSend
                 },
                 success : function(response) {
                     grid.el.unmask();
					 //grid.getStore().rejectChanges();
					 //grid.getStore().commitChanges();
                     //firmaStore.commitChanges();
                     try{
                         var obj = Ext.util.JSON.decode(response.responseText);
                         if(!obj.success)
                             msg('Kayýt güncellenemedi!', obj.errors.reason);
                     }
                     catch(e){
                         msg('Sonuç çözülemedi!', response.responseText);
                     }
					 grid.getStore().removeAll();
					 grid.getStore().commitChanges();
                     grid.getStore().load({params:{start:0, limit:30}});
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
             }

             var aboneStore = new Ext.data.Store({
             reader: new Ext.data.JsonReader({
             id: 'id',
             totalProperty: 'totalCount',
             idProperty: 'id',
                fields: [
                    'id','fisno','kullanici1','peron','peron_tanim','tarife','plaka', 'aciklama','tarih1','saat1','psure','pdurum','gecen_sure','sure_asimi','alan_tanim', 'bolge_tanim', 'fiyat'],
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/peron.jsp?action=parac'
                }),
				listeners: {
					load : function(store, records, options) {
						// only load with filled array!
						//console.log('done');
					},
					exception : function(proxy, type, action, options, res, arg) {
						//console.log(type,action,options, res, arg);
						//alert('bir hata olustu:' + res.statusText + proxy.url);
					}
				},
                autoLoad: false,
                autoDestroy: true
                });

                aboneStore.on('loadexception', function(event, options, response, error) {
					//var rs = Ext.util.JSON.decode(response.responseText);
                    //alert("sunucu hatasi:" + response.responseText);
                    //event.stopEvent();
                });

        var pagingAbone = {
            xtype : 'paging',
            store : aboneStore,
            pageSize : 30,
            displayInfo : true,
            items : [
                '-',
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {										
                        var grid = Ext.getCmp('gridPeronlar');                        
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            id:'',
                            fisno:'',
                            kullanici1:'',
                            peron:'',
                            peron_tanim:'',
                            tarife:'',
                            plaka:'', 
                            aciklama:'',
                            tarih1:'',
                            saat1:'',
                            psure:'',
                            pdurum:'',
                            gecen_sure:'',
                            sure_asimi:'',
                            alan_tanim:'', 
                            bolge_tanim:''
                        })
                    );
                        grid.startEditing(0, 3);
                    }
                },
                {
                    tooltip:'Seçilen kaydý sil',
                    text : 'Sil',
                    disabled:<%=sil%>,
                    icon: 'resources/icons/delete.png',
                    handler:function() {
                        var grid = Ext.getCmp('gridPeronlar');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.id + ' Kayýt silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                aboneDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    disabled:<%=duzelt%>,
                    handler : aboneSave,
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif'
                    //iconCls: 'x-button-ok'
                },
                '-',
                {
                    tooltip:'Yapýlan deðiþiklikleri geri al',
                    text : 'Ýptal',
                    icon: 'resources/icons/bullet_cross.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        Ext.getCmp('aboneGrid').getStore().rejectChanges();
                    }
                }
                ]
        }       

        var gridPeronlar = new Ext.grid.EditorGridPanel({
            id:'gridPeronlar',
            region:'center',
            ds: aboneStore,
            title:'Peron Detaylarý',
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
                        Ext.getCmp('xhareket').setValue(rec.get('id'));
                        Ext.getCmp('detayGrid').store.removeAll();
                        Ext.getCmp('detayGrid').store.load({params:{action:'detay', abone:rec.get('abone'),start:0, limit:10}});
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
                        aboneStore.load({
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
            autoExpandColumn : 'adi',
            loadMask         : true,
            maskMsg          : 'Yükleniyor..',
            stripeRows: true,
            cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
                {
                    header: 'Kayýt Id',
                    width: 80,
                    dataIndex: 'id',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'numeric'
                    }
                },
                {
                    header: 'Fiþ No',
                    width: 260,
                    dataIndex: 'fisno',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                },
                {
                    header: 'Kullanýcý',
                    width: 160,
                    dataIndex: 'kullanici1',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                },
                {
                    header: 'Peron Id',
                    width: 160,
                    dataIndex: 'peron',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    editor : comboPeronlar,
                    blankText: ''
                },
                {
                    header: 'Peron Taným',
                    width: 160,
                    dataIndex: 'peron_tanim',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                },
                {
                    header: 'Tarife',
                    width: 160,
                    dataIndex: 'tarife',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    editor : comboTarife,
                    blankText: ''
                },
                {
                    header: 'Plaka No',
                    width: 160,
                    dataIndex: 'plaka',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Açýklama',
                    width: 160,
                    dataIndex: 'aciklama',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Giriþ Tarihi',
                    dataIndex: 'tarih1',
                    filterable: true,
                    filter: {
                        type: 'date'     // specify type here or in store fields config
                    },
                    width: 120,
                    editor: new Ext.form.DateField({
                        //format: 'd/m/y',
                        //minValue: '01/01/06',
                        //disabledDays: [0, 6],
                        //disabledDaysText: 'Bitiþ tarihi seçin.'
                    })
                },
                {
                    header: 'Planlanan Süre',
                    width: 160,
                    dataIndex: 'psure',
                    blankText: ''
                },{
                    header: 'Park Durumu',
                    width: 160,
                    dataIndex: 'pdurum',
                    editor : comboEditor,
                    blankText: ''
                },
                {
                    header: 'Geçen Süre',
                    dataIndex: 'gecen_sure',
                    width: 70,
                    align: 'right'
                },
                {
                    header: 'Zaman Aþýmý',
                    dataIndex: 'sure_asimi',
                    width: 70,
                    align: 'right'
                },
                {
                    header: 'Alan',
                    dataIndex: 'alan_tanim',
                    width: 70,
                    align: 'right'
                },
                {
                    header: 'Bolge',
                    dataIndex: 'bolge_tanim',
                    width: 95
                },
                {
                    header: 'Fiyat',
                    dataIndex: 'fiyat',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                }]),
            bbar    : [
                pagingAbone,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xhareket', 
                    name: 'xhareket',
                    value: ''
                },
				{
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xabonedetay',
                    name: 'xabonedetay',
                    value: ''
                }
                ],
            tbar:[
                {
                    xtype:'label',
                    fieldLabel: 'Plaka:',
                    text: 'Plaka:'
                },
                {
                  xtype:'textfield',
                  id:'text_plaka',
                  fieldLabel: 'Plaka',
                  text: 'Plaka:',
                  hideLabel: false,
                  //anchor:'50%',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Kullanýcý',
                    text: 'Kullanýcý:'
                },
                {
                  xtype:'textfield',
                  id:'text_kullanici',
                  fieldLabel: 'Kullanýcý',
                  text: 'Kullanýcý:',
                  hideLabel: false
                  //anchor:'50%'
                },                
                '-',
                {
                    xtype:'label',
                    fieldLabel: 'Alan:',
                    text: 'Alan:'
                },
                {
                  xtype:'textfield',
                  id:'text_alan',
                  fieldLabel: 'Alan',
                  text: 'Alan:',
                  hideLabel: false
                  //anchor:'50%'
                },'-',
                {
                    tooltip:'Kayýtlarý Al',
                    text : 'Sorgula',
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                    
                    handler:function() {
						
                        var text_plaka = Ext.getCmp('text_plaka');
                        var text_kullanici = Ext.getCmp('text_kullanici');
                        var text_alan = Ext.getCmp('text_alan');
                        
                        var grid = Ext.getCmp('gridPeronlar');
                        grid.el.mask('Sorgulanýyor ....', 'x-mask-loading');
                        grid.stopEditing();
                        grid.store.removeAll();
                        
						grid.store.load({
							params:{
								action:   'parac',
								plaka: text_plaka.getValue(),
								kullanici: text_kullanici.getValue(),
								alan: text_alan.getValue(),
								start:0,
								limit:30
							}
						});
						
                        grid.el.unmask();

               }
            }
                ]
                });

                var displayPanel = new Ext.Panel({
                frame: true,
                border : true,
                split:true,
                bodyStyle:'padding:5px 5px 0',
                width:'100%',
                height:'100%',
                iconCls: 'icon-cls',
                autoHeight:true,               
                renderTo : 'perond-win',
                items    : [
                gridPeronlar
                ]
                });

                 aboneStore.load({params:{start:0, limit:30}});
    });    

</script>
