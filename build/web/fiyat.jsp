<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/firma.jsp
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<div id="fiyat-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){

        var ds_model = Ext.data.Record.create([
            'id', 'kod', 'tanim', 'aciklama', 'sure1', 'sure2', 'tolerans', 'fiyat',
             {name: 'durum', type: 'boolean'}, {name: 'ozel_tarife', type: 'boolean'}, 'sira', 'firma', 'kayit_tarihi', 'kayit_kullanici'
        ]);

        var doDelete = function(forDelete) {

            var grid = Ext.getCmp('fiyatGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/fiyat.jsp',
                params : {
                    action : 'delete',
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

            var firmaStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id:'id',
                fields: [
                    'id', 'kod', 'tanim', 'aciklama', 'sure1', 'sure2', 'tolerans', 'fiyat',
                     {name: 'durum', type: 'boolean'}, {name: 'ozel_tarife', type: 'boolean'}, 'sira', 'firma', 'kayit_tarihi', 'kayit_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/fiyat.jsp?action=fiyat'
            }),
            autoLoad: true
        });

        var onSave = function() {
        var grid = Ext.getCmp('fiyatGrid');
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
                    url : 'adapter/jsp/fiyat.jsp',
                    params : {
                        action : 'save',
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

        var pagingToolbar = { //1
            xtype : 'paging',
            store : firmaStore,
            pageSize : 10,
            displayInfo : true,
            items : [
                '-', // 1
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
                        var grid = Ext.getCmp('fiyatGrid');
                        var kod = grid.getStore().getCount().toString();
                        var fkod = 'F' + '0000'.substring(0, 4 - kod.length) + kod;
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            kod:fkod,
                            tanim:'',
                            aciklama:'',
                            sure1:'',
                            sure2:'',
                            tolerans:'',
                            fiyat:'',
                            durum:true,
                            ozel_tarife:false, 
                            sira:'1',
                            firma:'',
                            kayit_tarihi:'',
                            kayit_kullanici:''
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
                                doDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    disabled:<%=duzelt%>,
                    handler : onSave,
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
                        Ext.getCmp('fiyatGrid').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/fiyat.jsp' +
                            "?action=excel", "_top", "width=600" +
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

        var gridFirmalar = new Ext.grid.EditorGridPanel({
            id:'fiyatGrid',
            ds: firmaStore,
            border: true,
            autoScroll: true,
            autoHeight: true,
            autoWidth: true,
            autoSizeColumns: true,
            sm: new Ext.grid.RowSelectionModel({ singleSelect: !true }),
            viewConfig: {
                forceFit: true
            },
            clicksToEdit: 0,
            mode: 'remote',
            autoExpandColumn : 'tanim',
            loadMask         : true,
            maskMsg          : 'Yükleniyor..',
            stripeRows: true,
            listeners: {
                'afteredit': function(oe) {
                }
            },
            cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
                {
                    header: 'Fiyat Kodu',
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
                    header: 'Fiyat Tanýmý',
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
                    header: 'Süre1',
                    width: 60,
                    dataIndex: 'sure1',
                    editor :
                        new Ext.form.NumberField({
                        allowBlank:false
                        })
                },
                {
                    header: 'Süre2',
                    width: 60,
                    dataIndex: 'sure2',
                    editor :
                        new Ext.form.NumberField({
                        allowBlank:false
                        })
                },
                {
                    header: 'Tolerans',
                    width: 60,
                    dataIndex: 'tolerans',
                    editor :
                        new Ext.form.NumberField({
                        allowBlank:false
                        })
                },
                {
                    header: 'Fiyat',
                    width: 60,
                    dataIndex: 'fiyat',
                    editor :
                        new Ext.form.NumberField({
                        allowBlank:false,
                        decimalPrecision:2
                        }),
                    renderer:function(value){
                        return value + ' TL';
                    }
                },
                {
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return value ? '&#10003;': '&#9747;';
                    }
                },
                {
                    header: 'Özel Tarife',
                    width: 60,
                    dataIndex: 'ozel_tarife',
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return value ? '&#10003;': '&#9747;';
                    }
                },
                {
                    header: 'Sýra',
                    width: 60,
                    dataIndex: 'sira',
                    editor :
                    new Ext.form.NumberField({
                        allowBlank:false,
                        decimalPrecision:2
                    })
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
                pagingToolbar
                ]
                });

                var displayPanel = new Ext.Panel({
                height   : 300,
                frame: false,
                border : false,
                width:'100%',
                height:'100%',
                autoHeight:true,
                layout: 'fit',
                renderTo : 'fiyat-win',
                items    : [
                gridFirmalar
                ]
                });
    });
</script>
