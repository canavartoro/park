<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/hesap/fiyat_tanim.jsp

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

<div id="fiyat-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
	
    function fiyatekler(){
        
        var x = Ext.get('xfiyat').getValue();

        if(x == ''){
            msg('Hata!','Tarife seçin! (' + x + ')');
            return;
        }                  

        var ek = new Ext.Window({
            id: "xfiyat_detay",
            layout: "fit",
            title: "Tarife Detay.",
            iconCls: "icon-user",
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
                url: 'pages/hesap/fiyat_detay.jsp?ekle=<%=ekle%>&sil=<%=sil%>&duzelt=<%=duzelt%>'
            }
        });

        ek.show();
       
    }

    Ext.onReady(function(){

        Ext.QuickTips.init();	
        
        var bolgeStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: [
                    'id', 'tanim'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/alan.jsp?action=bolge'
            }),
            autoLoad: true
        });
        
        var comboBolge = {
            xtype : 'combo',
            id : 'comfiyatbobolge',
            triggerAction : 'all',
            displayField : 'tanim',
            valueField : 'id',
            fieldLabel:'Bölge Tanýmlarý',
            listWidth:250,
            width:250,
            store : bolgeStore,
            editable: true,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{
                select:{fn:function(combo, value, index) {
                        Ext.getCmp('xxbolge1').setValue(Ext.getCmp('comfiyatbobolge').store.getAt(index).data['id']);
                        Ext.getCmp('fiyatGrid').store.removeAll();
                        Ext.getCmp('fiyatGrid').store.load({params:{action:'allfiyat', bolge:Ext.getCmp('comfiyatbobolge').store.getAt(index).data['id'],start:0, limit:30}});
                }}}
        }
        
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
            'id', 'kod', 'tanim', 'aciklama', 'sure1', 'sure2', 'tolerans', 'fiyat', 'sira', 'ozel_tarife', {name: 'gunluk', type: 'boolean'}, 'firma', 'kayit_tarihi', 'kayit_kullanici', 'durum'
        ]);
        
        var aboneDelete = function(forDelete) {
            
            var grid = Ext.getCmp('fiyatGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/hesap/fiyat_tanim.jsp',
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
             var grid = Ext.getCmp('fiyatGrid');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
             grid.stopEditing();
             recordsToSend = Ext.encode(recordsToSend);
             Ext.Ajax.request({
                 url : 'adapter/jsp/hesap/fiyat_tanim.jsp',
                 params : {
                     action : 'save',
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
                    'id', 'kod', 'tanim', 'aciklama', 'sure1', 'sure2', 'tolerans', 'fiyat', 'sira', 'ozel_tarife', 'gunluk', 'firma', 'kayit_tarihi', 'kayit_kullanici', 'durum'],
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/hesap/fiyat_tanim.jsp?action=allfiyat'
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
            autoLoad: false,
            autoDestroy: true
            });
            aboneStore.on('loadexception', function(event, options, response, error) {
            ////var rs = Ext.util.JSON.decode(response.responseText);
            ////alert("sunucu hatasi:" + response.responseText);
            ////event.stopEvent();
            });

        var pagingAbone = {
            xtype : 'paging',
            store : aboneStore,
            pageSize : 30,
            displayInfo : true,
            items : [
                '-',
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xxbolge1',
                    name: 'xxbolge1',
                    value: ''
                },
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
					
                        var grid = Ext.getCmp('fiyatGrid');                        
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            id:'',
                            kod:'',
                            tanim:'',
                            aciklama:'',
                            sure1: 0,
                            sure2: 0,
                            tolerans: 0,
                            fiyat: 0,
                            sira: 0,
                            ozel_tarife: false,
                            gunluk: false,
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
                        var grid = Ext.getCmp('fiyatGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.kod + ' Kayýt silinecek kabul ediyor musunuz?',
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
                        var winHandle = window.open('adapter/jsp/hesap/fiyat_tanim.jsp' +
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
            id:'fiyatGrid',
            region:'center',
            ds: aboneStore,
            title:'Tarife Tanýmlarý',
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
                        Ext.getCmp('xfiyat').setValue(rec.get('id'));
                        Ext.getCmp('fiyatdetayGrid').store.removeAll();
                        Ext.getCmp('fiyatdetayGrid').store.load({params:{action:'1detaylar', tarife:rec.get('id'),start:0, limit:30}});
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
                {
                    header: 'Tarife',
                    width: 80,
                    dataIndex: 'id',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'numeric'
                    }
                },
                {
                    header: 'Tarife Kodu',
                    width: 260,
                    dataIndex: 'kod',
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
                    header: 'Tarife Tanimi',
                    width: 160,
                    dataIndex: 'tanim',
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
                    header: 'Aciklama',
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
                    header: 'Süre (1)',
                    dataIndex: 'sure1',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Süre (2)',
                    dataIndex: 'sure2',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Tolenrans',
                    dataIndex: 'tolerans',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
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
                },
                {
                    header: 'Sira',
                    dataIndex: 'sira',
                    width: 70,
                    align: 'right',
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })
                },
                {
                    header: 'Ozel Tarife',
                    width: 60,
                    dataIndex: 'ozel_tarife',
                    editor :comboEditor,
                    renderer:function(value){
                        var template = '<span style="color:{0};">{1}</span>';
                        return (value == 1) ? String.format(template, 'green', 'Aktif') : String.format(template, 'red', 'Pasif');
                    }
                },
                {
                    header: 'Günlük',
                    width: 60,
                    dataIndex: 'gunluk',
                    editor :comboEditor,
                    renderer:function(value){
                        var template = '<span style="color:{0};">{1}</span>';
                        return (value == 1) ? String.format(template, 'green', 'Günlük') : String.format(template, 'red', 'Normal');
                    }
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
                    id: 'xfiyat',
                    name: 'xfiyat',
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
            tbar:[]
                });

                /***************************************SOUTH PANEL********************************************/

                var ds_alan_model = Ext.data.Record.create([
                    'id', 'bolge', 'kod', 'tanim', 'tarife', 'firma', 'durum', 'k_user', 'k_tarih'
                ]);

                var detayDelete = function(forDelete) {

                    var grid = Ext.getCmp('fiyatdetayGrid');
                    grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
                    grid.stopEditing();
                    Ext.Ajax.request({
                        url : 'adapter/jsp/hesap/fiyat_tanim.jsp',
                        params : {
                            action : 'dsil',
                            toDelete : forDelete.id//Ext.get('xabonedetay').getValue()
                        },
                        success : function(response) {
                                grid.el.unmask();
                                grid.store.removeAll();
                                grid.store.load({params:{action:'1detaylar', tarife:Ext.getCmp('xfiyat').getValue(),start:0, limit:30}});
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

                var detayStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'id',
                        fields: ['id', 'bolge', 'kod', 'tanim', 'tarife', 'firma', 'durum', 'k_user', 'k_tarih'],
                        root: 'rows'/*,
                        baseParams: {
                           action:   '1detaylar'
                       }*/
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/hesap/fiyat_tanim.jsp?action=1detaylar'
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
                            handler: fiyatekler
                        },
                        {
                            tooltip:'Seçilen kaydý sil',
                            text : 'Sil',
                            disabled:<%=sil%>,
                            icon: 'resources/icons/delete.png',
                            handler:function() {
                                var grid = Ext.getCmp('fiyatdetayGrid');
                                var sel = grid.getSelectionModel().getSelected();
                                //var selIndex = firmaStore.indexOf(sel);

                                Ext.MessageBox.confirm(
                                'Silmek için onaylayýn',
                                sel.data.tanim + ' nolu kayýt silinecek kabul ediyor musunuz?',
                                function(btn) {
                                    if (btn == 'yes') {
                                        detayDelete(sel);
                                    }
                                }
                            );
                            }
                        },
                        '-'
                        ]
                }


                var gridDetaylar = new Ext.grid.EditorGridPanel({
                id:'fiyatdetayGrid',
                region:'center',
                title:'Tarife Detay Bilgileri',
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
                autoExpandColumn : 'tanim',
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
                        header: 'Bolge Tanýmý',
                        width: 260,
                        dataIndex: 'bolge',
                        sortable: true,                        
                        blankText: '',
                        hidden: true
                    },
                    {
                        header: 'Bolge Kodu',
                        width: 160,
                        dataIndex: 'kod',
                        blankText: ''
                    },
                    {
                        header: 'Bolge Tanimi',
                        width: 160,
                        dataIndex: 'tanim',
                        blankText: ''
                    },
                    {
                        header: 'KayitTarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'k_tarih'
                    },
                    {
                        header: 'KayitKullanýcý',
                        width: 60,
                        dataIndex: 'k_user'
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
                renderTo : 'fiyat-win',
                items    : [
                gridAboneler,
                gridDetaylar
                ],
                tbar : [
                '->',
                'Bölge Seçin ..',
                comboBolge
                ]
                });

                 aboneStore.load({params:{start:0, limit:30}});
    });    

</script>
