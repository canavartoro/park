<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/abone.jsp

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

<div id="abn-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

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
            height: 527,
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
                url: 'pages/ab_detay.jsp?ekle=<%=ekle%>&sil=<%=sil%>&duzelt=<%=duzelt%>'
            }
        });

        ek.show();
    }

    Ext.onReady(function(){

        Ext.QuickTips.init();
		
		var myData = {
            records : [
                { displays : "Aktif", values : "1" },
                { displays : "Pasif", values : "0" }
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
            'abone','adi','soyadi','plaka','bitis_tarihi','firma','diger1',
            'diger2','diger3','deger1','deger2','deger3','tarih1','tarih2','tarih3',
            'kayit_tarihi',//{name:'kayit_tarihi',type:'date',dateFormat: 'Y-m-d'},
            'kayit_kullanici','update_tarihi','update_kullanici','durum'
        ]);

        var dateBitis = new Ext.form.DateField({
            id:'bitis',
            fieldlabel:'Bitiþ Tarihi:',
            format: 'd-m-Y',
            name: 'bitis',
            width:100,
            value: ''
         });
        
        var aboneDelete = function(forDelete) {
            
            var grid = Ext.getCmp('aboneGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/abone.jsp',
                params : {
                    action : 'asil',
                    toDelete : forDelete.data.abone
                },
                success : function(response) {
                    grid.el.unmask();
                    obj = Ext.util.JSON.decode(response.responseText);
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
             var grid = Ext.getCmp('aboneGrid');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
             grid.stopEditing();
             recordsToSend = Ext.encode(recordsToSend);
             Ext.Ajax.request({
                 url : 'adapter/jsp/abone.jsp',
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
             id: 'abone',
             totalProperty: 'totalCount',
             idProperty: 'abone',
                fields: [
                    'abone','adi','soyadi','plaka','bitis_tarihi','firma','diger1',
                    'diger2','diger3','deger1','deger2','deger3','tarih1','tarih2','tarih3',
                    'kayit_tarihi','kayit_kullanici','update_tarihi','update_kullanici','durum'],
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/abone.jsp?action=abone'
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
                /*autoLoad: true,*/
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
					
						var dt = new Date();
						dt.setFullYear(2012,0,1);
						dt.setHours(1, 0, 0, 0);
					
                        var grid = Ext.getCmp('aboneGrid');                        
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            abone:'0',
                            adi:'',
                            soyadi:'',
                            plaka:'',
                            bitis_tarihi: dt,
                            firma:'',
                            diger1:'',
                            diger2:'',
                            diger3:'',
                            deger1:'0',
                            deger2:'0',
                            deger3:'0',
                            tarih1:'',
                            tarih2:'',
                            tarih3:'',
                            kayit_tarihi:'',
                            kayit_kullanici:'',
                            update_tarihi:'',
                            update_kullanici:'',
                            durum:true
                        })
                    );
                        grid.startEditing(0, 1);
                    }
                },
                {
                    tooltip:'Seçilen kaydý sil',
                    text : 'Sil',
                    disabled:<%=sil%>,
                    icon: 'resources/icons/delete.png',
                    handler:function() {
                        var grid = Ext.getCmp('aboneGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.abone + ' Kayýt silinecek kabul ediyor musunuz?',
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
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/abone.jsp' +
                            "?action=aexcel", "_top", "width=600" +
                            ",height=800" +
                            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                        if (winHandle == null){
                            msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                        }
                    }
                },
                '-'
                ]
        }       

        var gridAboneler = new Ext.grid.EditorGridPanel({
            id:'aboneGrid',
            region:'center',
            ds: aboneStore,
            title:'Abone Tanýmlarý',
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
                        Ext.getCmp('xabone').setValue(rec.get('abone'));
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
                    header: 'Abone Kodu',
                    width: 80,
                    dataIndex: 'abone',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'numeric'
                    }
                },
                {
                    header: 'Abone Adý',
                    width: 260,
                    dataIndex: 'adi',
                    sortable: true,
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
                    header: 'Abone Soyadi',
                    width: 160,
                    dataIndex: 'soyadi',
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
                    header: 'Özel Kod',
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
                    header: 'Bitiþ Tarihi',
                    dataIndex: 'bitis_tarihi',
					//format: 'd/m/y',
					/*renderer: function(val) {
						var template = '<span style="color:{0};">{1}</span>';
						try{							
							var curDate = new Date();
							
							var d = new Date(val.substring(0,4), val.substring(5,7), val.substring(8,10), val.substring(11,13), val.substring(14,16), 00);
							//return String.format(template, '#FFCC66', d.toString());
							if( curDate.getDate() < d.getDate()){
								return String.format(template, '#990000', val);
							}
							else if(curDate.getFullYear() == d.getFullYear() && curDate.getMonth() <= d.getMonth()){
								return String.format(template, '#FFCC00', val);
							}
							else {
								return String.format(template, 'green', val);
							}
						}
						catch(e){
							return String.format(template, '#FF0080', val);
							//alert(e);
						}
						
					},*/
                    //renderer: Ext.util.Format.dateRenderer('d/m/Y'),
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
                    header: 'Metin (1)',
                    width: 160,
                    dataIndex: 'diger1',
                    filterable: true,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Metin (2)',
                    width: 160,
                    dataIndex: 'diger2',
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },{
                    header: 'Metin (3)',
                    width: 160,
                    dataIndex: 'diger3',
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Sayý (1)',
                    dataIndex: 'deger1',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Sayý (2)',
                    dataIndex: 'deger2',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Sayý (3)',
                    dataIndex: 'deger3',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Tarih (1)',
                    dataIndex: 'tarihi1',
                    width: 95,
                    editor: new Ext.form.DateField({
                    })
                },
                {
                    header: 'Tarih (2)',
                    dataIndex: 'tarihi2',
                    width: 95,
                    editor: new Ext.form.DateField({
                    })
                },
                {
                    header: 'Tarih (3)',
                    dataIndex: 'tarihi3',
                    width: 95,
                    //renderer: formatDate,
                    editor: new Ext.form.DateField({
                        //format: 'd/m/y',
                        //minValue: '01/01/06',
                        //disabledDays: [0, 6],
                        //disabledDaysText: 'Tarih deðeri.'
                    })
                },
				{
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
                    editor :comboEditor,
                    renderer:function(value){
						var template = '<span style="color:{0};">{1}</span>';
                        return (value == 1) ? String.format(template, 'green', 'Aktif') : String.format(template, 'red', 'Pasif');
                    }
                }
                /*{
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
                    editor :comboEditor{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return value ? '&#10003;': '&#9747;';
						//return value ? 'AKTÝF': 'PASÝF';
                    }
                }*/,
                {
                    header: 'Güncelleme Tarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_tarihi'
                },
                {
                    header: 'Güncelleme Kullanýcý',
                    width: 60,
                    dataIndex: 'update_kullanici'
                },
                {
                    header: 'KayitTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'kayit_tarihi'
                },
                {
                    header: 'KayitKullanýcý',
                    width: 60,
                    dataIndex: 'kayit_kullanici'
                }]),
            bbar    : [
                pagingAbone,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xabone',
                    name: 'xabone',
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
                    fieldLabel: 'Adý:',
                    text: 'Adý:'
                },
                {
                  xtype:'textfield',
                  id:'text_adi',
                  fieldLabel: 'Adi',
                  text: 'Adý:',
                  hideLabel: false,
                  //anchor:'50%',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Soyadý:',
                    text: 'Soyadý:'
                },
                {
                  xtype:'textfield',
                  id:'text_soyadi',
                  fieldLabel: 'SoyAdi',
                  text: 'SoyAdý:',
                  hideLabel: false
                  //anchor:'50%'
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Özel Kod:',
                    text: 'Özel Kod:'
                },
                {
                  xtype:'textfield',
                  id:'text_ozel',
                  fieldLabel: 'Ozel',
                  text: 'Ozel:',
                  hideLabel: false
                  //anchor:'50%'
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Metin(1):',
                    text: 'Metin (1):'
                },
                {
                  xtype:'textfield',
                  id:'text_metin1',
                  fieldLabel: 'Metin1',
                  text: 'Metin1:',
                  hideLabel: false
                  //anchor:'50%'
                },'-',
                {
                    xtype:'label',
                    fieldLabel: 'Bitiþ Tarihi:',
                    text: 'Bitiþ Tarihi:'
                },
                dateBitis,'-',
                {
                    tooltip:'Kayýtlarý Al',
                    text : 'Sorgula',
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                    
                    handler:function() {
						var sDate = dateBitis.getValue();
                        if(sDate != null && sDate.length > 0){
                            sDate = formatDate(new Date(dateBitis.getValue()),'yyyy-MM-dd'); 
                        }
						
                        var text_adi = Ext.getCmp('text_adi');
                        var text_soyadi = Ext.getCmp('text_soyadi');
                        var text_ozel = Ext.getCmp('text_ozel');
                        var text_metin1 = Ext.getCmp('text_metin1');
                        
                        var grid = Ext.getCmp('aboneGrid');
                        grid.el.mask('Sorgulanýyor ....', 'x-mask-loading');
                        grid.stopEditing();
                        grid.store.removeAll();
                        
						grid.store.load({
							params:{
								action:   'abone',
								bitis:   sDate,
								adi: text_adi.getValue(),
								soyadi: text_soyadi.getValue(),
								ozel: text_ozel.getValue(),
								metin1: text_metin1.getValue(),
								start:0,
								limit:30
							}
						});
						
                        grid.el.unmask();

               }
            }
                ]
                });

                /***************************************SOUTH PANEL********************************************/

                var ds_alan_model = Ext.data.Record.create([
                    'id',
                    'bolge',
                    'alan',
                    'peron',
                    'kayit_tarihi',
                    'kayit_kullanici'
                ]);

                var detayDelete = function(forDelete) {

                    var grid = Ext.getCmp('detayGrid');
                    grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
                    grid.stopEditing();
                    Ext.Ajax.request({
                        url : 'adapter/jsp/abone.jsp',
                        params : {
                            action : 'dsil',
                            toDelete : forDelete//Ext.get('xabonedetay').getValue()
                        },
                        success : function(response) {
                                grid.el.unmask();
                                var obj = Ext.util.JSON.decode(response.responseText);
                                if(!obj.success){
                                    msg('Kayýt silinemedi!', obj.errors.reason);
                                }
                                else{
                                    grid.store.removeAll();
                                    grid.store.load({params:{action:'detay', abone:Ext.get('xabone').getValue()}});
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

                var detaySave = function() {
                var grid = Ext.getCmp('detayGrid');
                    var modified = grid.getStore().getModifiedRecords(); // 1
                    if (modified.length > 0) {
                        var recordsToSend = [];
                        Ext.each(modified, function(record) { // 2
                            recordsToSend.push(record.data);
                        });

                        grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
                        grid.stopEditing();
                        recordsToSend = Ext.encode(recordsToSend); // 4
                        Ext.Ajax.request({
                            url : 'adapter/jsp/abone.jsp',
                            params : {
                                action : 'dkaydet',
                                recordsToInsertUpdate : recordsToSend
                            },
                            success : function(response) {
                                grid.el.unmask();
                                //firmaStore.commitChanges();
                                try{
                                    obj = Ext.util.JSON.decode(response.responseText);
                                    if(!obj.success)
                                        msg('Kayýt güncellenemedi!', obj.errors.reason);
                                }
                                catch(e){
                                    msg('Sonuç çözülemedi!', response.responseText);
                                }
                                grid.store.removeAll();
                                grid.store.load({params:{action:'alan', bolge:Ext.get('xbolge').getValue()}});
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
                        url: 'adapter/jsp/abone.jsp?action=alanlar'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: true
                });
                
                var combolge = new Ext.form.ComboBox({
                store: alanStore,
                id: 'cmbbolge',
                width: 300,
                tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item"><strong>{bolge}</strong></div><h3>{alan}</h3><h5>{peron}</h5></tpl>'
                ),
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'bolge_id',
                //itemSelector: 'div.search-item',
                displayField: 'bolge',
                autocomplete: true,
                emptyText: 'Bölge seçin',
                triggerAction: 'all',
                value: ''
                });

                var comalan = new Ext.form.ComboBox({
                store: alanStore,
                id: 'cmbalan',
                width: 300,
                tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item"><strong>{bolge}</strong></div><h3>{alan}</h3><h5>{peron}</h5></tpl>'
                ),
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'alan_id',
                //itemSelector: 'div.search-item',
                displayField: 'alan',
                autocomplete: true,
                emptyText: 'Alan seçin',
                triggerAction: 'all',
                value: ''
                });

                var comperon = new Ext.form.ComboBox({
                store: alanStore,
                id: 'cmbperon',
                width: 300,
                tpl: new Ext.XTemplate(
                '<tpl for="."><div class="x-combo-list-item"><strong>{bolge}</strong></div><h3>{alan}</h3><h5>{peron}</h5></tpl>'
                ),
                selecOnFocus: true,
                forceSelection: true,
                valueField: 'peron_id',
                //itemSelector: 'div.search-item',
                displayField: 'peron',
                autocomplete: true,
                emptyText: 'Peron seçin',
                triggerAction: 'all',
                value: ''
                });

                var detayStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'id',
                        fields: [
                            'id',
                            'bolge',
                            'bolge_id',
                            'alan',
                            'alan_id',
                            'peron',
                            'peron_id',
                            'kayit_tarihi',
                            'kayit_kullanici'],
                        root: 'rows',
                        baseParams: {
                           action:   'detay',
                           bolge:   'abone'
                       }
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/abone.jsp'
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false
                });

                var pagingDetay = {
                    xtype : 'paging',
                    store : detayStore,
                    pageSize : 10,
                    displayInfo : true,
                    items : [
                        '-',
                        {
                            tooltip:'Yeni kayýt',
                            text : 'Ekle',
                            disabled:<%=ekle%>,
                            icon: 'resources/images/yourtheme/dd/drop-add.gif',
                            handler: ekler
                        },
                        {
                            tooltip:'Seçilen kaydý sil',
                            text : 'Sil',
                            disabled:<%=sil%>,
                            icon: 'resources/icons/delete.png',
                            handler:function() {
                                //var grid = Ext.getCmp('detayGrid');
                                //var sel = grid.getSelectionModel().getSelected();
                                //var selIndex = firmaStore.indexOf(sel);
								var ids = Ext.get('xabonedetay').getValue();

                                Ext.MessageBox.confirm(
                                'Silmek için onaylayýn',
                                ids + ' nolu kayýt silinecek kabul ediyor musunuz?',
                                function(btn) {
                                    if (btn == 'yes') {
                                        detayDelete(ids);
                                    }
                                }
                            );
                            }
                        }/*,
                        {
                            tooltip:'Yapýlan deðiþiklikleri kaydet',
                            text : 'Kaydet',
                            handler : detaySave,
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
                                Ext.getCmp('detayGrid').getStore().rejectChanges();
                            }
                        }*/,
                        '-',
                        {
                            tooltip:'Kayýtlarý dýþa aktar',
                            text : 'Excel',
                            icon: 'resources/icons/page_excel.png',
                            //iconCls: 'x-button-cancel'
                            handler:function() {
                                var winHandle = window.open('adapter/jsp/bolge.jsp' +
                                    "?action=excel2", "_top", "width=600" +
                                    ",height=800" +
                                    ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                                if (winHandle == null){
                                    msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                                }
                            }
                        },
                        '-'
                        ]
                }


                var gridDetaylar = new Ext.grid.EditorGridPanel({
                id:'detayGrid',
                region:'center',
                title:'Abone Detay Bilgileri',
                iconCls: 'icon-cls',
                ds: detayStore,
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
							var rec = sel.getSelected();
							if(rec){
								Ext.getCmp('xabonedetay').setValue(rec.get('id'));							
							}
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
                autoExpandColumn : 'tanim',
                loadMask         : true,
                maskMsg          : 'Yükleniyor..',
                stripeRows: true,
                cm: new Ext.grid.ColumnModel([
					new Ext.grid.RowNumberer(),
                    {
                        header: 'Bölge Tanýmý',
                        width: 80,
                        dataIndex: 'bolge',
                        editor :combolge,
                        sortable: true,
						hidden: true
                    },
                    {
                        header: 'Alan Tanýmý',
                        width: 260,
                        dataIndex: 'alan',
                        sortable: true,
                        editor :comalan,
                        blankText: '',
						hidden: true
                    },
                    {
                        header: 'Peron Tanýmlarý',
                        width: 160,
                        dataIndex: 'peron',
                        editor :comperon,
                        blankText: ''
                    },
                    {
                        header: 'KayitTarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'kayit_tarihi'
                    },
                    {
                        header: 'KayitKullanýcý',
                        width: 60,
                        dataIndex: 'kayit_kullanici'
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
                renderTo : 'abn-win',
                items    : [
                gridAboneler,
                gridDetaylar
                ]
                });

                 aboneStore.load({params:{start:0, limit:30}});
    });    

</script>
