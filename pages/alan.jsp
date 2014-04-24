<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/alan.jsp
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
 
<!--
<%! private String x = "Sistemde tanýmlý olan alan ve peron tanýmlarý."; %>
<%@include file="../adapter/jsp/info.jsp" %> -->
<%@include file="../adapter/jsp/yetki.jsp" %>
<div id="alan-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">        

    Ext.onReady(function(){

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
		
		/*var stokStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: [
                    'id', 'kod'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/alan.jsp?action=s_stok'
            }),
            autoLoad: true
        });*/

        var comboBolge = {
            xtype : 'combo',
            id : 'combobolge',
            triggerAction : 'all',
            displayField : 'tanim',
            valueField : 'id',
            fieldLabel:'Bölge Tanýmlarý',
            listWidth:250,
            width:250,
            store : bolgeStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{select:{fn:function(combo, value, index) {
                        Ext.getCmp('xbolge1').setValue(Ext.getCmp('combobolge').store.getAt(index).data['id']);
                        Ext.getCmp('alanGrid1').store.removeAll();
                        Ext.getCmp('peronGrid').store.removeAll();
                        Ext.getCmp('alanGrid1').store.load({params:{action:'alan', bolge:Ext.getCmp('combobolge').store.getAt(index).data['id'],start:0, limit:10}});
                        }}}
        }
		
		/*var comboStok = {
            xtype : 'combo',
            id : 'comboStok',
            triggerAction : 'all',
            displayField : 'kod',
            valueField : 'kod',
            fieldLabel:'Açýklama',
            listWidth:250,
            width:250,
            store : stokStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{select:{fn:function(combo, value, index) {}}}
        }*/

        var ds_model = Ext.data.Record.create([
            'kod',
            'tanim',
            'aciklama',
            'durum',
            'bolge',
            'kayit_tarihi',
            'kayit_kullanici',
            'update_tarihi',
            'update_kullanici'
        ]);

        var alanDelete = function(forDelete) {

            var grid = Ext.getCmp('alanGrid1');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/alan.jsp',
                params : {
                    action : 'delete1',
                    toDelete : forDelete.data.id
                },
                success : function(response) {
                        grid.el.unmask();
                        var obj = Ext.util.JSON.decode(response.responseText);
                        if(!obj.success){
                            msg('Kayýt silinemedi!', obj.errors.reason);
                        }
                        else{
                            Ext.getCmp('alanGrid1').store.removeAll();
                            Ext.getCmp('peronGrid').store.removeAll();
                            Ext.getCmp('alanGrid1').store.load({params:{action:'alan', bolge:Ext.get('xbolge1').getValue()}});
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
		
		var yeniStok = function(){
		
			var newStok = new Ext.Window({
				id: "sEkle",
				layout: "fit",
				title: "Açýklama Ekle.",
				iconCls: "icon-user",
				width: 400,
				height: 200,
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
					url: 'pages/yeni_stok.jsp'
				}
			});

			newStok.show();
		
		}

        var alanSave = function() {
        var grid = Ext.getCmp('alanGrid1');
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
                    url : 'adapter/jsp/alan.jsp',
                    params : {
                        action : 'save1',
                        recordsToInsertUpdate : recordsToSend
                    },
                    success : function(response) {
                        grid.el.unmask();
                        //firmaStore.commitChanges();
                        try{
                            var obj = Ext.util.JSON.decode(response.responseText);
                            if(!obj.success)
                                msg('Kayýt güncellenemedi!', obj.errors.reason);
                        }
                        catch(e){
                            msg('Sonuç çözülemedi!', response.responseText);
                        }
                        Ext.getCmp('alanGrid1').store.removeAll();
                        Ext.getCmp('peronGrid').store.removeAll();
                        Ext.getCmp('alanGrid1').store.load({params:{action:'alan', bolge:Ext.get('xbolge1').getValue()}});
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
                id: 'id',
                fields: [
                    'id', 'kod', 'tanim', 'aciklama', 'durum', 'bolge', 'kayit_tarihi',
                    'kayit_kullanici', 'update_tarihi', 'update_kullanici'],
                root: 'rows',
                baseParams: {
                    action:   'alan',
                    bolge:   'bolge'
                }
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/alan.jsp?action=alan'
            }),
            autoLoad: false
        });

        var pagingAlan = {
            xtype : 'paging',
            store : alanStore,
            pageSize : 25,
            displayInfo : true,
            items : [
                '-',
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
                        var grid = Ext.getCmp('alanGrid1');
                        //var kod = grid.getStore().getCount().toString();
                        //var bkod = 'A' + '0000'.substring(0, 4 - kod.length) + kod;
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            kod:'',
                            tanim:'',
                            aciklama:'',
                            durum:'',
                            bolge:Ext.get('xbolge1').getValue(),
                            kayit_tarihi:'',
                            kayit_kullanici:'',
                            update_tarihi:'',
                            update_kullanici:''
                        })
                    );
                        grid.startEditing(0, 0);
                    }
                },
                {
                    tooltip:'Seçilen kaydý sil',
                    text : 'Sil',
                    disabled:<%=sil%>,
                    icon: 'resources/icons/delete.png',
                    handler:function() {
                        var grid = Ext.getCmp('alanGrid1');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.kod + ' Kayýt silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                alanDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    disabled:<%=duzelt%>,
                    handler : alanSave,
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
                        Ext.getCmp('bolgeGrid1').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/alan.jsp' +
                            "?action=excel1", "_top", "width=600" +
                            ",height=800" +
                            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                        if (winHandle == null){
                            msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                        }
                    }
                }				
                ]
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

        var gridAlanlar = new Ext.grid.EditorGridPanel({
            id:'alanGrid1',
            region:'center',
            ds: alanStore,
            title:'Alan Tanýmlarý',
            iconCls: 'icon-cls',
            border: true,
            autoScroll: true,
            autoHeight: true,
            autoWidth: true,
            split:true,
            collapsible: true,
            animate: true,
            autoSizeColumns: true,
            sm:new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                selectionchange: function(sel){
                    var rec = sel.getSelected();
                    if(rec){
						var Id = rec.get('id');
                        Ext.getCmp('xalan').setValue(Id);
                        Ext.getCmp('peronGrid').store.removeAll();
                        Ext.getCmp('peronGrid').store.load({params:{action:'peron', alan:Id,start:0, limit:30}});
                    }
                }
            }
            }),
            viewConfig: {
                forceFit: true
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
                    header: 'Alan Kodu',
                    width: 80,
                    dataIndex: 'kod',
                    sortable: true,
					editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Alan Tanýmý',
                    width: 260,
                    dataIndex: 'tanim',
                    sortable: true,
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
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Aktif':'Pasif';
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
                },
                {
                    header: 'GüncelTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_tarihi'
                },
                {
                    header: 'GüncelKullanici',
                    width: 60,
                    dataIndex: 'update_kullanici'
                }]),
            bbar    : [
                pagingAlan,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xalan',
                    name: 'xalan',
                    value: ''
                },
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xbolge1',
                    name: 'xbolge1',
                    value: ''
                }
                ]
                });

                /***************************************SOUTH PANEL********************************************/

                var ds_peron_model = Ext.data.Record.create([
                    'kod',
                    'tanim',
                    'aciklama',
                    'durum',
                    'alan',
                    'kayit_tarihi',
                    'kayit_kullanici',
                    'update_tarihi',
                    'update_kullanici'
                ]);

                var peronDelete = function(forDelete) {

                    var grid = Ext.getCmp('peronGrid');
                    grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
                    grid.stopEditing();
                    Ext.Ajax.request({
                        url : 'adapter/jsp/bolge.jsp',
                        params : {
                            action : 'delete2',
                            toDelete : forDelete.data.id
                        },
                        success : function(response) {
                                grid.el.unmask();
                                obj = Ext.util.JSON.decode(response.responseText);
                                if(!obj.success){
                                    msg('Kayýt silinemedi!', obj.errors.reason);
                                }
                                else{
                                    grid.store.removeAll()
									grid.store.load({params:{action:'peron', alan:Ext.get('xalan').getValue()}});
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

                var peronSave = function() {
                var grid = Ext.getCmp('peronGrid');
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
                            url : 'adapter/jsp/alan.jsp',
                            params : {
                                action : 'save2',
                                recordsToInsertUpdate : recordsToSend
                            },
                            success : function(response) {
                                grid.el.unmask();
                                //firmaStore.commitChanges();
                                try{
                                    var obj = Ext.util.JSON.decode(response.responseText);
                                    if(!obj.success)
                                        msg('Kayýt güncellenemedi!', obj.errors.reason);
                                }
                                catch(e){
                                    msg('Sonuç çözülemedi!', response.responseText);
                                }
                                grid.store.removeAll()
                                grid.store.load({params:{action:'peron', alan:Ext.get('xalan').getValue()}});
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

                var peronStore = new Ext.data.Store({
                        reader: new Ext.data.JsonReader({
                        id: 'id',
                        fields: [
                            'id', 'kod', 'tanim', 'aciklama', 'durum', 'alan', 'kayit_tarihi',
                            'kayit_kullanici', 'update_tarihi', 'update_kullanici'],
                        root: 'rows',
                        baseParams: {
                           action:   'peron',
                           alan:   'alan'
                       }
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/alan.jsp'
                    }),
					listeners: {
						loadexception: function (proxy, options, response, e) {
							var result = response.responseText;
							Ext.MessageBox.alert('Load failure', e + " ..... ");
						}
					},
                    totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false
                });
				/*peronStore.on('exception',function( store, records, options ){
					// do something about the record exception
					alert('hata!');
				},this);*/

                var pagingAlan = {
                    xtype : 'paging',
                    store : alanStore,
                    pageSize : 10,
                    displayInfo : true,
                    items : [
                        '-',
                        {
                            tooltip:'Yeni kayýt',
                            text : 'Ekle',
                            disabled:<%=ekle%>,
                            icon: 'resources/images/yourtheme/dd/drop-add.gif',
                            handler: function() {
                                var grid = Ext.getCmp('peronGrid');
                                //var c = grid.getStore().getCount() + 1;
                                //var kod = c.toString();
                                //var akod = 'P' + '0000'.substring(0, 4 - kod.length) + kod;
                                grid.getStore().insert(
                                0,
                                new ds_peron_model({
                                    kod:'',
                                    tanim:'',
                                    aciklama:'',
                                    durum:'',
                                    alan:Ext.get('xalan').getValue(),
                                    kayit_tarihi:'',
                                    kayit_kullanici:'',
                                    update_tarihi:'',
                                    update_kullanici:''
                                })
                            );
                                grid.startEditing(0, 0);
                            }
                        },
                        {
                            tooltip:'Seçilen kaydý sil',
                            text : 'Sil',
                            disabled:<%=sil%>,
                            icon: 'resources/icons/delete.png',
                            handler:function() {
                                var grid = Ext.getCmp('peronGrid');
                                var sel = grid.getSelectionModel().getSelected();
                                //var selIndex = firmaStore.indexOf(sel);

                                Ext.MessageBox.confirm(
                                'Silmek için onaylayýn',
                                sel.data.kod + ' Kayýt silinecek kabul ediyor musunuz?',
                                function(btn) {
                                    if (btn == 'yes') {
                                        peronDelete(sel);
                                    }
                                }
                            );
                            }
                        },
                        {
                            tooltip:'Yapýlan deðiþiklikleri kaydet',
                            text : 'Kaydet',
                            disabled:<%=duzelt%>,
                            handler : peronSave,
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
                                Ext.getCmp('peronGrid').getStore().rejectChanges();
                            }
                        },
                        '-',
                        {
                            tooltip:'Kayýtlarý dýþa aktar',
                            text : 'Excel',
                            icon: 'resources/icons/page_excel.png',
                            //iconCls: 'x-button-cancel'
                            handler:function() {
                                var winHandle = window.open('adapter/jsp/alan.jsp' +
                                    "?action=excel2&bolge=" + Ext.getCmp('xbolge1').getValue(), "_top", "width=600" +
                                    ",height=800" +
                                    ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                                if (winHandle == null){
                                    msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                                }
                            }
                        },
						/*{
							tooltip:'Yeni stok tipi ekle',
							text : 'Açýklama Ekle',
							handler : yeniStok,
							icon: 'resources/images/yourtheme/dd/drop-yes.gif'
							//iconCls: 'x-button-ok'
						},*/
                        '-'
                        ]
                }

                var gridPronlar = new Ext.grid.EditorGridPanel({
                id:'peronGrid',
                region:'center',
                title:'Peron Tanýmlarý',
                iconCls: 'icon-cls',
                ds: peronStore,
                border: true,
                autoScroll: true,
                autoHeight: true,
                autoWidth: true,
                split:true,
                collapsible: true,
                animate: true,
                autoSizeColumns: true,
                sm: new Ext.grid.RowSelectionModel({
                    singleSelect:true
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
                        header: 'Peron Kodu',
                        width: 80,
                        dataIndex: 'kod',
                        sortable: true,
                        editor :
                            new Ext.form.TextField({
                            allowBlank: false
                        }),
                        blankText: ''
                    },
                    {
                        header: 'Peron Tanýmý',
                        width: 260,
                        dataIndex: 'tanim',
                        sortable: true,
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
                        editor :
                            new Ext.form.TextField({
                            allowBlank: false
                        }),
                        blankText: ''
                    },
                    {
                        header: 'Durum',
                        width: 60,
                        dataIndex: 'durum',
                        editor :comboEditor,
                        renderer:function(value){
                            return (value == 1)?'Aktif':'Pasif';
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
                    },
                    {
                        header: 'GüncelTarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'update_tarihi'
                    },
                    {
                        header: 'GüncelKullanici',
                        width: 60,
                        dataIndex: 'update_kullanici'
                    }]),
                bbar    : [
                    pagingAlan
                    ]
                    });

/******************************************************************************/

//north,center,south
                var displayPanel = new Ext.Panel({
                frame: false,
                border : true,
                split:true,
                width:'100%',
                height:'100%',
                autoHeight:true,
                renderTo : 'alan-win',
                items    : [
                gridAlanlar, gridPronlar
                /*{
                            id:'preview',
                            region:'south',
                            height:220,
                            title:'Alan Tanýmlarý',
                            split:true,
                            border: true,
                            collapsible: true
                            //bodyStyle: 'padding: 10px; font-family: Arial; font-size: 12px;'
                        }*/
                ],
                tbar : [
                '->',
                'Bölge Seçin ..',
                comboBolge
                ]
                });


    });
</script>
