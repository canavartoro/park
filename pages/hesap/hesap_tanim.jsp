<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/hesap/hesap_tanim.jsp

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

<div id="hesap-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
	
    function hesaptransfer(){
        
        var x = Ext.get('xhesap').getValue();

        if(x == ''){
            msg('Hata!','Hesap seçin! (' + x + ')');
            return;
        }                  

        var ek = new Ext.Window({
            id: "xhesap_detay",
            layout: "fit",
            title: "Hesap Transferleri",
            iconCls: "icon-user",
            width: 800,
            height: 550,
            maximizable: true,
            constrain: true,
            resizable: true,
            autoScroll: true,
            closeAction : 'close',
            autoLoad: {
                showMask: true,
                scripts: true,
                maskMsg: 'Yükleniyor..',
                mode: "iframe",
                url: 'pages/hesap/hesap_detay.jsp?ekle=<%=ekle%>&sil=<%=sil%>&duzelt=<%=duzelt%>'
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
        
        var ds_model = Ext.data.Record.create([
             'id', 'firma', 'kullanici', 'bakiye', 'giris_tarihi', 'giris_saati', 'kayit_tarihi', 'durum'
        ]);
        
        var aboneDelete = function(forDelete) {
            
            var grid = Ext.getCmp('hesapGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/hesap/hesap_tanim.jsp',
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
             var grid = Ext.getCmp('hesapGrid');
             grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
             grid.stopEditing();
             recordsToSend = Ext.encode(recordsToSend);
             Ext.Ajax.request({
                 url : 'adapter/jsp/hesap/hesap_tanim.jsp',
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
                     'id', 'firma', 'kullanici', 'bakiye', 'giris_tarihi', 'giris_saati', 'kayit_tarihi', 'durum'],
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/hesap/hesap_tanim.jsp?action=allfiyat'
                }),
                listeners: {
                load : function(store, records, options) {
                },
                exception : function(proxy, type, action, options, res, arg) {
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
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
					
                        var grid = Ext.getCmp('hesapGrid');                        
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            id:'',
                            firma:'',
                            kullanici:'',
                            bakiye: 0,
                            giris_tarihi: '',
                            giris_saati: '',
                            kayit_tarihi: '',
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
                        var grid = Ext.getCmp('hesapGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.kullanici + ' Kayýt silinecek kabul ediyor musunuz?',
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
                        Ext.getCmp('hesapGrid').getStore().rejectChanges();
                    }
                },
                {
                    tooltip:'Hesap hareketleri',
                    text : 'Hesap Transferi',
                    icon: 'resources/icons/submit.gif',
                    //iconCls: 'x-button-cancel'
                    handler:hesaptransfer
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/hesap/hesap_tanim.jsp' +
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
            id:'hesapGrid',
            region:'center',
            ds: aboneStore,
            title:'Hesap Tanýmlarý',
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
                        Ext.getCmp('xhesap').setValue(rec.get('id'));                        
                    }
                },
                beforeedit : function(e) {
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
                    header: 'Hesap Id',
                    width: 80,
                    dataIndex: 'id',
                    sortable: true
                },
                {
                    header: 'Kullanici',
                    width: 260,
                    dataIndex: 'kullanici',
                    sortable: true,
                    editor : comboUsers,
                    blankText: ''
                },
                {
                    header: 'Bakiye',
                    dataIndex: 'bakiye',
                    width: 70,
                    align: 'right'/*,
                    editor: new Ext.form.NumberField({
                        allowBlank: false,
                        allowNegative: false,
                        maxValue: 1000000000
                    })*/
                },
                {
                    header: 'Giris Tarihi',
                    width: 260,
                    dataIndex: 'giris_tarihi',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Giris Saati',
                    width: 260,
                    dataIndex: 'giris_saati',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Kayit Tarihi',
                    width: 260,
                    dataIndex: 'kayit_tarihi',
                    sortable: true,
                    blankText: ''
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
                pagingAbone,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xhesap',
                    name: 'xhesap',
                    value: ''
                }
                ],
            tbar:[]
                });

                /***************************************SOUTH PANEL********************************************/

                               

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
                renderTo : 'hesap-win',
                items    : [
                gridAboneler
                ]
                });

                 aboneStore.load({params:{start:0, limit:30}});
    });    

</script>
