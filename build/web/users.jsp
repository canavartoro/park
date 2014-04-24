<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/firma.jsp
[Þablon olarak kullanýlacak.]
--%>
<%@page import="org.barset.beans.userBean"%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<%@include file="../adapter/jsp/yetki.jsp" %>

<%
String xfirmaparam = request.getParameter("xfirmaparam");
if( xfirmaparam == null || xfirmaparam.length() < 1 ) xfirmaparam = ((userBean)request.getSession().getAttribute("user")).getCompany();
%>

<div id="usr-win" style="width: 100%;height: 100%;position: relative;left: 2px; top: 2px;"></div>

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
            'email',
			{name: 'offline', type: 'boolean'},
            'kayit_tarihi',
            'kayit_kullanici',
            'update_tarih',
            'update_kullanici'
        ]);

        var doDelete = function(forDelete) {

            var grid = Ext.getCmp('usrGrid');
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

            var usrStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id:'id',
                totalProperty: 'totalCount',
                idProperty: 'id',
                fields: [
                    'id',
                    'kod',
                    'tanim',
                    'parola',
                    {name: 'tahsilat', type: 'boolean'},
                    {name: 'sup', type: 'boolean'},
                    'firma',
                    'email',
					{name: 'offline', type: 'boolean'},
                    {name: 'durum', type: 'boolean'},
                    'kayit_tarihi', 'kayit_kullanici', 'update_tarih', 'update_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/kullanici.jsp?action=all&xfirmaparam=' + '<%=xfirmaparam%>'
            }),
            autoLoad: false,
            autoDestroy: true
        });

        var onSave = function() {
        var grid = Ext.getCmp('usrGrid');
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
                        xfirmaparam: '<%=xfirmaparam%>',
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
            store : usrStore,
            pageSize : 20,
            displayInfo : true,
            items : [
                '-',
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
                        var grid = Ext.getCmp('usrGrid');                        
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            kod:'',
                            tanim:'',
                            parola:'',
                            tahsilat:false,
                            sup:false,
                            firma:'',
                            email:'',
							offline:false,
                            durum:true,
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
                        var grid = Ext.getCmp('usrGrid');
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
                        Ext.getCmp('usrGrid').getStore().rejectChanges();
                    }
                },
                '-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/kullanici.jsp' +
                            "?action=excel&xfirmaparam=<%=xfirmaparam%>", "_top", "width=600" +
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
            id:'usrGrid',
            ds: usrStore,
            border: true,
            autoScroll: true,
            autoHeight: true,
            autoWidth: true,
            autoSizeColumns: true,
            sm:new Ext.grid.RowSelectionModel({
            singleSelect:true,
            listeners: {
                selectionchange: function(sel){
                    var rec = sel.getSelected();
                    if(rec){
                        Ext.getCmp('ouser').setValue(rec.get('id'));
                        Ext.getCmp('yetkiGrid1').store.removeAll();
                        Ext.getCmp('yetkiGrid1').store.load({params:{action:'allyet', ouser:rec.get('id')}});
                    }
                },
                beforeedit : function(e) {
                    
                }                
            },
            render: {
                fn: function(){
                    usrStore.load({
                        params: {
                            xfirmaparam:'<%=xfirmaparam%>',
                            start: 0,
                            limit: 20
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
                    header: 'Kullanýcý Kodu',
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
                    header: 'Kullanýcý Tanýmý',
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
                    header: 'Süper',
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
                    header: 'Baðlantý',
                    width: 60,
                    dataIndex: 'offline',
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
                    header: 'Kullanýcý Email',
                    width: 260,
                    dataIndex: 'email',
                    sortable: true,
                    editor :
                        new Ext.form.TextField({
                        allowBlank: false
                    }),
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
                },
                {
                    header: 'GüncelTarihi',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_tarih'
                },
                {
                    header: 'GüncelKullanici',
                    width: 60,
                    //renderer: Ext.util.Format.dateRenderer('d.m.Y'),
                    dataIndex: 'update_kullanici'
                }]),
            bbar    : [
                pagingToolbar,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'ouser',
                    name: 'ouser',
                    value: ''
                }
                ]
                });
                
                
/****************************************************KULLANICI DETAY GRÝD*****************************************************/
        
        var yetkiSave = function() {
        var grid = Ext.getCmp('yetkiGrid1');
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
                        action : 'yetkisave',
                        ouser:Ext.get('ouser').getValue(),
                        recordsToInsertUpdate : recordsToSend
                    },
                    success : function(response) {
                        grid.el.unmask();
                        Ext.getCmp('yetkiGrid1').store.removeAll();
                        Ext.getCmp('yetkiGrid1').store.load({params:{action:'allyet', ouser:Ext.get('ouser').getValue()}});
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
                
                var yetkiDelete = function(forDelete) {

            var grid = Ext.getCmp('yetkiGrid1');
            grid.el.mask('Siliniyor', 'x-mask-loading'); // 3
            grid.stopEditing();
            Ext.Ajax.request({
                url : 'adapter/jsp/kullanici.jsp',
                params : {
                    action : 'yetkidel',
                    toDelete : forDelete.data.ids
                },
                success : function(response) {
                        grid.el.unmask();
                        Ext.getCmp('yetkiGrid1').store.removeAll();
                        Ext.getCmp('yetkiGrid1').store.load({params:{action:'allyet', ouser:Ext.get('ouser').getValue()}});
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
        
        var pagingYetki = {
            xtype : 'paging',
            store : yetkiStore,
            pageSize : 50,
            displayInfo : true,
            items : [
                '-',
                {
                    tooltip:'Yeni kayýt',
                    text : 'Ekle',
                    disabled:<%=ekle%>,
                    icon: 'resources/images/yourtheme/dd/drop-add.gif',
                    handler: function() {
                        var grid = Ext.getCmp('yetkiGrid1');
                        //var kod = grid.getStore().getCount().toString();
                        //var bkod = 'A' + '0000'.substring(0, 4 - kod.length) + kod;
                        grid.getStore().insert(
                        0,
                        new ds_model({
                            menu:'',
                            ekle:true,
                            sil:false,
							duzelt:false,
                            durum:true,
                            kullanici:Ext.get('ouser').getValue()
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
                        var grid = Ext.getCmp('yetkiGrid1');
                        var sel = grid.getSelectionModel().getSelected();
                        //var selIndex = firmaStore.indexOf(sel);
                        Ext.MessageBox.confirm(
                        'Silmek için onaylayýn',
                        sel.data.ids + ' Kayýt silinecek kabul ediyor musunuz?',
                        function(btn) {
                            if (btn == 'yes') {
                                yetkiDelete(sel);
                            }
                        }
                    );
                    }
                },
                {
                    tooltip:'Yapýlan deðiþiklikleri kaydet',
                    text : 'Kaydet',
                    disabled:<%=duzelt%>,
                    handler : yetkiSave,
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif'
                    //iconCls: 'x-button-ok'
                }				
                ]
        }
        
        var menuStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id: 'kod',
                fields: [
                    'menu', 'baslik', 'aciklama'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/kullanici.jsp?action=menuall'
            }),
            autoLoad: true
        });
        
        var comboMenu = {
            xtype : 'combo',
            id : 'comboMenu',
            triggerAction : 'all',
            displayField : 'baslik',
            valueField : 'menu',
            fieldLabel:'Menu Tanimlari',
            listWidth:300,
            width:250,
            store : menuStore,
            editable: false,
            forceSelection : false,
            mode:'remote',
            lastQuery:'',
            loadingText : 'Bekleyin....',
            listeners:{select:{fn:function(combo, value, index) {}}}
        }
        
        var myData = {
            records : [
                { displays : "Evet", values : "1" },
                { displays : "Hayýr", values : "0" }
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
        
        var yetkiStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                id:'ids',
                idProperty: 'ids',
                fields: [
                    'ids',
                    'kullanici',
                    'menu',
                    'baslik',
                    'aciklama',
                    'url',
                    {name: 'ekle', type: 'boolean'},
                    {name: 'sil', type: 'boolean'},
                    {name: 'duzelt', type: 'boolean'},
                    {name: 'durum', type: 'boolean'}],
                root: 'rows',
                baseParams: {
                    action:   'allyet',
                    ouser:   'x'
                }
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/kullanici.jsp'
            }),
            autoLoad: false,
            autoDestroy: true
        });
        
        var gridYetki = new Ext.grid.EditorGridPanel({
            id:'yetkiGrid1',
            region:'center',
            ds: yetkiStore,
            title:'Kullanýcý Yetkileri',
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
            autoExpandColumn : 'tanim',
            loadMask         : true,
            maskMsg          : 'Yükleniyor..',
            stripeRows: true,
            cm: new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(),
                {
                    header: 'Menü Tanýmý',
                    width: 80,
                    dataIndex: 'menu',
                    sortable: true,
                    blankText: '',
                    editor : comboMenu
                },
                {
                    header: 'Menü Metni',
                    width: 80,
                    dataIndex: 'baslik',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Açýklama',
                    width: 260,
                    dataIndex: 'aciklama',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Ekle',
                    width: 60,
                    dataIndex: 'ekle',
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayýr';
                    }
                },
                {
                    header: 'Silme Yetkisi',
                    width: 60,
                    dataIndex: 'sil',
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayýr';
                    }
                },
                {
                    header: 'Düzeltme Yetkisi',
                    width: 60,
                    dataIndex: 'duzelt',
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayýr';
                    }
                },
                {
                    header: 'Durum',
                    width: 60,
                    dataIndex: 'durum',
                    editor :comboEditor,
                    renderer:function(value){
                        return (value == 1)?'Evet':'Hayýr';
                    }
                }]),
            bbar    : [
                pagingYetki
                ]
                });


/****************************************************KULLANICI DETAY GRÝD*****************************************************/

                
                var displayPanel = new Ext.Panel({
                height   : 300,
                frame: false,
                border : false,
                width:'100%',
                height:'100%',
                autoHeight:true,
                layout: 'fit',
                renderTo : 'usr-win',
                items    : [
                gridFirmalar, gridYetki
                ]
                });
                
                usrStore.load({params:{xfirmaparam:'<%=xfirmaparam%>',start:0, limit:20}});
    });
</script>

<div id="tree-ct" style="position: relative; left: 2px; top: 2px;"></div>
