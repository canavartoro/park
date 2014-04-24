<%--
Solution Developer
29 A�ustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/kullanici.jsp
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="user-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){

        var ds_model = Ext.data.Record.create([
            'kod',
            'tanim',
            'parola',
            {name: 'tahsilat', type: 'boolean'},
            {name: 'sup', type: 'boolean'},
            'firma',
            {name: 'durum', type: 'boolean'},
            'kayit_tarihi',
            'kayit_kullanici',
            'update_tarih',
            'update_kullanici'
        ]);

        var doDelete = function(forDelete) {

            var grid = Ext.getCmp('userGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/kullanici.jsp',
                params : {
                    action : 'delete',
                    toDelete : forDelete.data.id
                },
                success : function(response) {
                        grid.el.unmask();
                        obj = Ext.util.JSON.decode(response.responseText);
                        if(!obj.success){
                            msg('Kay�t silinemedi!', obj.errors.reason);
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

        var userStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'id',
                fields: [
                    'id',
                    'kod',
                    'tanim',
                    'parola',
                    {name: 'tahsilat', type: 'boolean'},
                    {name: 'sup', type: 'boolean'},
                    'firma',
                    {name: 'durum', type: 'boolean'},
                    'kayit_tarihi', 'kayit_kullanici', 'update_tarih', 'update_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/kullanici.jsp?action=allusers'
            }),
            autoLoad: true
        });



        var onSave = function() {
        var grid = Ext.getCmp('userGrid');
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
                    url : 'adapter/jsp/kullanici.jsp',
                    params : {
                        action : 'save',
                        recordsToInsertUpdate : recordsToSend
                    },
                    success : function(response) {
                        grid.el.unmask();
                        //firmaStore.commitChanges();
                        try{
                            obj = Ext.util.JSON.decode(response.responseText);
                            if(!obj.success)
                                msg('Kay�t g�ncellenemedi!', obj.errors.reason);
                        }
                        catch(e){
                            msg('Sonu� ��z�lemedi!', response.responseText);
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
            store : userStore,
            pageSize : 10,
            displayInfo : true,
            items : [
                '-', // 1
                {
                    tooltip:'Yeni kay�t',
                    text : 'Ekle',
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
                        var grid = Ext.getCmp('userGrid');
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            kod:'',
                            tanim:'',
                            parola:'',
                            tahsilat:false,
                            sup:false,
                            firma:'',
                            durum:true,
                            kayit_tarihi:'',
                            kayit_kullanici:'',
                            update_tarih:'',
                            update_kullanici:''
                        })
                    );
                        grid.startEditing(0, 0);
                        //Ext.getCmp('xxx').enable();
                    }
                },
                {
                    tooltip:'Se�ilen kayd� sil',
                    text : 'Sil',
                    icon: 'resources/icons/delete.png',
                    handler:function() {
                        var grid = Ext.getCmp('userGrid');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);

                        Ext.MessageBox.confirm(
                        'Silmek i�in onaylay�n',
                        sel.data.kod + ' Kay�t silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                doDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yap�lan de�i�iklikleri kaydet',
                    text : 'Kaydet',
                    handler : onSave,
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif'
                    //iconCls: 'x-button-ok'
                },
                '-',
                {
                    tooltip:'Yap�lan de�i�iklikleri geri al',
                    text : '�ptal',
                    icon: 'resources/icons/bullet_cross.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        Ext.getCmp('userGrid').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kay�tlar� d��a aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/kullanici.jsp' +
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
            id:'userGrid',
            ds: userStore,
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
            maskMsg          : 'Y�kleniyor..',
            stripeRows: true/*,
            listeners: {
                'beforeedit': function(oe) {
                    //Ext.getCmp('xxx').disable();
                }
            }*/,
            cm: new Ext.grid.ColumnModel([
                {
                    header: 'Kullan�c� Kodu',
                    width: 80,
                    dataIndex: 'kod',
                    sortable: true,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false,
                        id:'xxx'
                    })
                },
                {
                    header: 'Kullan�c� Tan�m�',
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
                    header: 'Parola',
                    width: 160,
                    dataIndex: 'parola',
                    inputType: 'password',
                    editor :
                         {
                        inputType: 'password',
                        maxLength: 12
                    }
                },
                {
                    header: 'Tahsilat',
                    width: 60,
                    dataIndex: 'tahsilat',
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return value ? '&#10003;': '&#9747;';
                    }
                },
                {
                    header: 'S�per',
                    width: 60,
                    dataIndex: 'sup',
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return value ? '&#10003;': '&#9747;';
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
                        //return (value == 1)?'Aktif':'Pasif';
                        return value ? '&#10003;': '&#9747;';
                    }
                },
                {
                    header: 'KayitTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'kayit_tarihi'
                },
                {
                    header: 'KayitKullan�c�',
                    width: 60,
                    dataIndex: 'kayit_kullanici'
                },
                {
                    header: 'G�ncelTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_tarih'
                },
                {
                    header: 'G�ncelKullanici',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_kullanici'
                }
                ]),
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
                renderTo : 'user-win',
                items    : [
                gridFirmalar
                ]
                });
    });
</script>
