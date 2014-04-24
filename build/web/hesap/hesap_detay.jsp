<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/bolge.jsp
[Þablon olarak kullanýlacak.]
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../../adapter/jsp/yetki.jsp" %>

<div id="hdetay-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){ 
        
        var ds_model = Ext.data.Record.create(['id', 'kullanici1', 'hesap1', 'kullanici2', 'hesap2', 'kayit_tarihi', 'kayit_saati', 'tur', 'aciklama', 'tutar', 'bakiye', 'durum']);

        var users = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: ['kod', 'tanim', 'firma'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/kullanici.jsp?action=users&xfirma=current'
            }),
            autoLoad: true
        });
        
        var comboUsers = {
            xtype : 'combo',
            triggerAction : 'all',
            displayField : 'tanim',
            valueField : 'kod',
            store : users,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....'
        }
        
        var detaySave = function() {
            
         var modified = Ext.getCmp('hesapdetayGrid').getStore().getModifiedRecords(); // 1
         if (modified.length > 0) {
             var recordsToSend = [];
             Ext.each(modified, function(record) { // 2
                 recordsToSend.push(record.data);
             });
             var grid = Ext.getCmp('hesapdetayGrid');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
             grid.stopEditing();
             recordsToSend = Ext.encode(recordsToSend);
             Ext.Ajax.request({
                 url : 'adapter/jsp/hesap/hesap_tanim.jsp',
                 params : {
                     action : '2save',
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

         var detayDelete = function(forDelete) {

                    var grid = Ext.getCmp('hesapdetayGrid');
                    grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
                    grid.stopEditing();
                    Ext.Ajax.request({
                        url : 'adapter/jsp/hesap/hesap_tanim.jsp',
                        params : {
                            action : 'dsil',
                            toDelete : forDelete.id//Ext.get('xabonedetay').getValue()
                        },
                        success : function(response) {
                                grid.el.unmask();
                                grid.store.removeAll();
                                grid.store.load({params:{start:0, limit:30}});
                                var obj = Ext.util.JSON.decode(response.responseText);
                                if(!obj.success){
                                    msg('Kayýt silinemedi!', obj.errors.reason);
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
                        totalProperty: 'totalCount',
                        idProperty: 'id',
                        fields: [ 'id', 'kullanici1', 'hesap1', 'kullanici2', 'hesap2', 'kayit_tarihi', 'kayit_saati', 'tur', 'aciklama', 'tutar', 'bakiye', 'durum'],
                        root: 'rows'/*,
                        baseParams: {
                           action:   '1detaylar'
                       }*/
                    }),
                    proxy: new Ext.data.HttpProxy({
                        url: 'adapter/jsp/hesap/hesap_tanim.jsp?action=1detaylar&hesap=' + Ext.getCmp('xhesap').getValue()
                    }),
                    //totalProperty: 'totalCount',
                    remoteSort: true,
                    autoLoad: false,
                    autoDestroy: true
                });
                
                var myData = {
            records : [
                { displays : "TRANSFER", values : "TRANSFER" },
                { displays : "TAHSILAT", values : "TAHSILAT" },
                { displays : "K.TAHSILAT", values : "K.TAHSILAT" },
                { displays : "DEVIR", values : "DEVIR" }
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

        

                var pagingDetay = {
                    xtype : 'paging',
                    store : detayStore,
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
					
                                var grid = Ext.getCmp('hesapdetayGrid');                        
                                grid.getStore().insert(
                                0,
                                new ds_model({
                                    id:'',
                                    kullanici1:'',
                                    hesap1:'',
                                    kullanici2: '',
                                    hesap2: '',
                                    kayit_tarihi: '',
                                    kayit_saati: '',
                                    tur:'',
                                    aciklama:'',
                                    tutar:'',
                                    bakiye:'',
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
                                var grid = Ext.getCmp('hesapdetayGrid');
                                var sel = grid.getSelectionModel().getSelected();
                                //var selIndex = firmaStore.indexOf(sel);

                                Ext.MessageBox.confirm(
                                'Silmek için onaylayýn',
                                sel.data.id + ' nolu kayýt silinecek kabul ediyor musunuz?',
                                function(btn) {
                                    if (btn == 'yes') {
                                        detayDelete(sel);
                                    }
                                }
                            );
                            }
                        },
                        {
                            tooltip:'Yapýlan deðiþiklikleri kaydet',
                            text : 'Kaydet',
                            disabled:<%=duzelt%>,
                            handler : detaySave,
                            icon: 'resources/images/yourtheme/dd/drop-yes.gif'
                            //iconCls: 'x-button-ok'
                        },
                        {
                            tooltip:'Kayýtlarý dýþa aktar',
                            text : 'Excel',
                            icon: 'resources/icons/page_excel.png',
                            //iconCls: 'x-button-cancel'
                            handler:function() {
                                var winHandle = window.open('adapter/jsp/hesap/hesap_tanim.jsp' +
                                    "?action=bexcel&hesap=" + Ext.getCmp('xhesap').getValue(), "_top", "width=600" +
                                    ",height=800" +
                                    ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                                if (winHandle == null){
                                    msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                                }
                            }
                        }
                        ]
                }


                var gridDetaylar = new Ext.grid.EditorGridPanel({
                id:'hesapdetayGrid',
                region:'center',
                title:'Hesap Transfer Bilgileri',
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
                },
                render: {
                fn: function(){
                    detayStore.load({
                        params: {
                            start: 0,
                            limit: 30
                        }
                    });
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
                        hidden: false
                    },
                    {
                        header: 'Kullanici (1)',
                        width: 260,
                        dataIndex: 'kullanici1',
                        sortable: true,                        
                        blankText: '',
                        editor : comboUsers,
                        hidden: false
                    },
                    {
                        header: 'Hesap (1)',
                        width: 260,
                        dataIndex: 'hesap1',
                        sortable: true,                        
                        blankText: '',
                        hidden: false
                    }
                    ,
                    {
                        header: 'Kullanici (2)',
                        width: 160,
                        dataIndex: 'kullanici2',
                        blankText: '',
                        editor : comboUsers
                    },
                    {
                        header: 'Hesap (2)',
                        width: 160,
                        dataIndex: 'hesap2',
                        blankText: ''
                    },
                    {
                        header: 'Kayit Tarihi',
                        width: 60,
                        //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                        dataIndex: 'kayit_tarihi'
                    },
                    {
                        header: 'Kayit Saati',
                        width: 60,
                        dataIndex: 'kayit_saati'
                    },
                    {
                        header: 'Hareket Tur',
                        width: 60,
                        dataIndex: 'tur'/*,
                        editor : comboEditor*/
                    },
                    {
                        header: 'Aciklama',
                        width: 60,
                        dataIndex: 'aciklama'/*,
                         editor :
                        new Ext.form.TextField({
                            allowBlank: false
                        })*/
                    },
                    {
                        header: 'Tutar',
                        width: 60,
                        dataIndex: 'tutar',                        
                        align: 'right',
                        editor: new Ext.form.NumberField({
                            allowBlank: false,
                            allowNegative: false,
                            maxValue: 1000000000
                        })
                    },
                    {
                        header: 'Bakiye',
                        width: 60,
                        dataIndex: 'bakiye'
                    },
                    {
                        header: 'Durum',
                        width: 60,
                        dataIndex: 'durum',
                        //editor :comboEditor,
                        renderer:function(value){
                            var template = '<span style="color:{0};">{1}</span>';
                            return (value == 1) ? String.format(template, 'green', 'Aktif') : String.format(template, 'red', 'Pasif');
                        }
                    }]),
                    bbar    : [
                    pagingDetay
                    ]                
                    });      
//north,center,south
                var displayPanel = new Ext.Panel({
                frame: false,
                border : true,
                split:true,
                width:'100%',
                height:'100%',
                iconCls: 'icon-cls',
                autoHeight:true,
                renderTo : 'hdetay-win',
                items    : [
                gridDetaylar
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
                ]
                });
                detayStore.load({
                        params: {
                            start: 0,
                            limit: 30
                        }
                    });

    });
</script>
