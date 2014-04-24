<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/cihaz_tanim.jsp
[Þablon olarak kullanýlacak.]
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>

<div id="duyuru-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){

        var ds_model = Ext.data.Record.create([
            'id',
            'baslik',
            'mesaj',
            'firma',
            'durum',
            'kayit_tarihi',
            'kayit_kullanici'
        ]);

        var cihazDelete = function(forDelete) {

            var grid = Ext.getCmp('duyuruGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/duyuru_tanim.jsp',
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
                            grid.getStore().load();
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

        var cihazSave = function() {
        var grid = Ext.getCmp('duyuruGrid');
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
                    url : 'adapter/jsp/duyuru_tanim.jsp',
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
                        grid.getStore().load();
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

                var bolgeStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: ['id', 'baslik', 'mesaj', 'firma', 'durum', 'kayit_tarihi', 'kayit_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/duyuru_tanim.jsp?action=duyuru'
            }),
            autoLoad: true
        });

        var pagingBolge = {
            xtype : 'paging',
            store : bolgeStore,
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
                        var grid = Ext.getCmp('duyuruGrid');
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            id:'', baslik:'', mesaj:'', firma:'', durum:true, kayit_tarihi:'', kayit_kullanici:''                       })
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
                        var grid = Ext.getCmp('duyuruGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.id + ' Kayýt silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                cihazDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    disabled:<%=duzelt%>,
                    handler : cihazSave,
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
                        Ext.getCmp('duyuruGrid').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/cihaz_tanim.jsp' +
                            "?action=excel1", "_top", "width=600" +
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

        var gridBolgeler = new Ext.grid.EditorGridPanel({
            id:'duyuruGrid',
            region:'center',
            ds: bolgeStore,
            title:'Duyuru Tanýmlarý',
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
                    }
                }
            }
            }),
            viewConfig: {
                forceFit: true
            },
            clicksToEdit: 0,
            mode: 'remote',
            autoExpandColumn : 'baslik',
            loadMask         : true,
            maskMsg          : 'Yükleniyor..',
            stripeRows: true,
            cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
                {
                    header: 'Duyuru Id',
                    width: 80,
                    dataIndex: 'id',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Baslik',
                    width: 260,
                    dataIndex: 'baslik',
                    sortable: true,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Duyuru',
                    width: 160,
                    dataIndex: 'mesaj',
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
                }]),
            bbar    : [
                pagingBolge,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xduyuru',
                    name: 'xduyuru',
                    value: ''
                }
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
                renderTo : 'duyuru-win',
                items    : [
                gridBolgeler
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


    });
</script>
