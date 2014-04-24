<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/bufe.jsp

--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<div id="buf-win" style="margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){

    <%@include file="../adapter/jsp/outer.jsp" %>

        var ds_model = Ext.data.Record.create([
            'kod',
            'tanim',
            'aciklama',
            {name: 'bakiye', type: 'float'},
            'versiyon',
            {name: 'fisno', type: 'int'},
            'durum',
            'kayit_tarihi',
            'kayit_kullanici',
            'update_tarih',
            'update_kullanici'
        ]);        

          var firmaStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: [
                    'kod', 'tanim', 'aciklama', 'bakiye', 'versiyon', 'fisno', 'durum',
                    'kayit_tarihi',//{name: 'kayit_tarihi', type: 'date', dateFormat: 'n/j h:ia'},
                    'kayit_kullanici', 'update_tarih', 'update_kullanici'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/firma.jsp?action=firma'
            }),
            autoLoad: true
        }); 
        
        var pagingToolbar = { //1
            xtype : 'paging',
            store : firmaStore,
            pageSize : 10,
            displayInfo : true,
            items : [
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
            cm: new Ext.grid.ColumnModel([
                {
                    header: 'Firma Kodu',
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
                    header: 'Firma Tanýmý',
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
                    header: 'Bakiye',
                    width: 60,
                    dataIndex: 'bakiye',
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
                    editor :
                        new Ext.form.NumberField({
                        allowBlank: false
                        }),
                        blankText: '0'
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
                    dataIndex: 'update_tarih'
                },
                {
                    header: 'GüncelKullanici',
                    width: 60,
                    dataIndex: 'update_kullanici'
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
                renderTo : 'buf-win',
                items    : [
                gridFirmalar
                ]
                });
                //firmaStore.load({params:{start:0, limit:10, action:'firma'}});
    });
</script>
