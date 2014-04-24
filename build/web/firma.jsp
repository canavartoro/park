<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/firma.jsp
[Þablon olarak kullanýlacak.]
--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<!--
<%! private String x = "Sistemde tanýmlý olan firma bilgileri."; %>
<%@include file="../adapter/jsp/info.jsp" %>
-->

<%@include file="../adapter/jsp/yetki.jsp" %>

<div id="frm-win" style="margin: 0px 0px;"></div>

<script type="text/javascript">
    
        function kullanicilar(){
        var x = Ext.get('xfirmaparam').getValue();

        if(x == ''){
            msg('Hata!','Firma seçin! (' + x + ')');
            return;
        }

        var ek = new Ext.Window({
            id: "xuserform",
            layout: "fit",
            title: "Kullanýcý Tanýmlarý.",
            //iconCls: "icon-user",
            icon: 'resources/icons/group_go.png',
            width: 800,
            height: 600,
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
                url: 'pages/users.jsp?xfirmaparam=' + x + '&ekle=<%=ekle%>&sil=<%=sil%>&duzelt=<%=duzelt%>'
            }
        });

        ek.show();
    }

    Ext.onReady(function(){

    <%@include file="../adapter/jsp/outer.jsp" %>     

        var ds_model = Ext.data.Record.create([
            'kod',
            'tanim',
            'aciklama',
            {name: 'bakiye', type: 'float'},
            'versiyon',
            {name: 'fisno', type: 'int'},
            {name: 'ot_giris', type: 'boolean'},
            {name: 'ot_transfer', type: 'boolean'},
			{name: 'cezali', type: 'int'},
            'vergi_no',
			'vergi_daire',
			'durum',
            'kayit_tarihi',
            'kayit_kullanici',
            'update_tarih',
            'update_kullanici'
        ]);

        var doDelete = function(forDelete) {

            var grid = Ext.getCmp('firmaGrid');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/firma.jsp',
                params : {
                    action : 'delete',
                    toDelete : forDelete.data.kod
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
                fields: [
                    'kod', 'tanim', 'aciklama', 'bakiye', 'versiyon', 'fisno', 'cezali',
                    {name: 'ot_giris', type: 'boolean'},{name: 'ot_transfer', type: 'boolean'}, 'durum', 'vergi_no', 'vergi_daire',
                    'kayit_tarihi',//{name: 'kayit_tarihi', type: 'date', dateFormat: 'n/j h:ia'},
                    'kayit_kullanici', 'update_tarih', 'update_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/firma.jsp?action=firma'
            }),
            autoLoad: true
        }); 
        
        var onSave = function() {
            var modified = firmaStore.getModifiedRecords(); // 1
            if (modified.length > 0) {
                var recordsToSend = [];
		Ext.each(modified, function(record) { // 2
                    recordsToSend.push(record.data);
                });
                var grid = Ext.getCmp('firmaGrid');
		grid.el.mask('Kaydediliyor..', 'x-mask-loading'); // 3
		grid.stopEditing();
		recordsToSend = Ext.encode(recordsToSend); // 4
		Ext.Ajax.request({
                    url : 'adapter/jsp/firma.jsp',
                    params : {
                        action : 'save',
                        recordsToInsertUpdate : recordsToSend
                    },
                    success : function(response) {
                        grid.el.unmask();
                        //firmaStore.commitChanges();
                        try{
						//alert(response.responseText);
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
                        var grid = Ext.getCmp('firmaGrid');
                        var kod = grid.getStore().getCount().toString();
                        var fkod = 'F' + '0000'.substring(0, 4 - kod.length) + kod;
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            kod:fkod,
                            tanim:'',
                            aciklama:'',
                            bakiye:'0',
                            versiyon:'1',
                            fisno:'0',
                            ot_giris:false,
                            ot_transfer:false,
							cezali:0,
                            durum:'',
                            kayit_tarihi:'',
                            kayit_kullanici:'',
                            update_tarih:'',
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
                        var grid = Ext.getCmp('firmaGrid');
                        var sel = grid.getSelectionModel().getSelected();

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
                        Ext.getCmp('firmaGrid').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/firma.jsp' +
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
        
        var gridFirmalar = new Ext.grid.EditorGridPanel({ 
            id:'firmaGrid',
            ds: firmaStore,
            border: true,
            autoScroll: true,
            autoHeight: true,
            autoWidth: true,
			enableColumnHide: false,
			enableColumnMove: false,
            autoSizeColumns: true,
            sm:new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                selectionchange: function(sel){
                    var rec = sel.getSelected();
                    if(rec){
                        Ext.getCmp('xfirmaparam').setValue(rec.get('kod'));                        
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
                    header: 'Firma Kodu',
                    width: 80,
                    dataIndex: 'kod',
                    sortable: true,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Firma Tanýmý',
                    width: 260,
                    dataIndex: 'tanim',
                    sortable: true,
					draggable:false,
					renderer:addTooltip,
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
					sortable: true,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: true
                    }),
                    blankText: ''
                },
                {
                    header: 'Bakiye',
                    width: 60,
                    dataIndex: 'bakiye',
					sortable: true,
					draggable:false,
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
                    header: 'Versiyon',
                    width: 60,
                    dataIndex: 'versiyon',
					sortable: true,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
                    blankText: ''
                },
                {
                    header: 'Fiþno',
                    width: 60,
                    dataIndex: 'fisno',
					sortable: true,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.NumberField({
                        allowBlank: false
                        }),
                        blankText: '0'
                },
				{
                    header: 'Cezali',
                    width: 60,
                    dataIndex: 'cezali',
					sortable: true,
					draggable:false,
                    editor :
                        new Ext.form.NumberField({
                        allowBlank: false
                        }),
                        blankText: '0',
					renderer:function(value){
                        return (value > 0) ? value + ' Gün':'Yok';
                    }
                },
				{
                    header: 'Vergi No',
                    width: 30,
                    dataIndex: 'vergi_no',
					sortable: false,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: true
                    }),
                    blankText: ''
                },
				{
                    header: 'Vergi Daire',
                    width: 60,
                    dataIndex: 'vergi_daire',
					sortable: true,
					draggable:false,
					renderer:addTooltip,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: true
                    }),
                    blankText: ''
                },
                {
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
					sortable: true,
					draggable:false,
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Aktif':'Pasif';
                    }
                },
                {
                    header: 'Otomatik Giriþ',
                    width: 60,
                    dataIndex: 'ot_giris',
					sortable: true,
					draggable:false,
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayir';
                    }
                },
                {
                    header: 'Otomatik Transfer',
                    width: 60,
					sortable: true,
					draggable:false,
                    dataIndex: 'ot_transfer',
                    editor :{
                        xtype: 'checkbox'
                    },
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayir';
                    }
                },
                {
                    header: 'KayitTarihi',
					sortable: true,
					draggable:false,
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'kayit_tarihi'
                },
                {
                    header: 'KayitKullanýcý',
					sortable: true,
					draggable:false,
                    width: 60,
                    dataIndex: 'kayit_kullanici'
                },
                {
                    header: 'GüncelTarihi',
					sortable: true,
					draggable:false,
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_tarih'
                },
                {
                    header: 'GüncelKullanici',
					sortable: true,
					draggable:false,
                    width: 60,
                    dataIndex: 'update_kullanici'
                }]),
                bbar : [
                pagingToolbar
                ],
                tbar : [
                    {
                        tooltip:'Firma kullanýcý tanýmlarý',
                        text : 'Kullanýcý Tanýmlarý',
                        disabled:<%=ekle%>,                        
                        icon: 'resources/icons/group_go.png',
                        //iconCls: 'x-button-ok'
                        handler : kullanicilar
                    },
                    {
                        xtype: 'textfield',
                        editable: false,
                        inputType: 'hidden',
                        id: 'xfirmaparam',
                        name: 'xfirmaparam',
                        value: ''
                    }
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
                renderTo : 'frm-win',
                items    : [
                gridFirmalar
                ]
                });
                //firmaStore.load({params:{start:0, limit:10, action:'firma'}});
    });
	
	function addTooltip(value, metadata, record, rowIndex, colIndex, store){
		metadata.attr = 'ext:qtip="' + value + '"';
		return value;
	}
	
</script>
