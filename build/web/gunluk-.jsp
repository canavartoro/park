<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/gunluk.jsp

--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="frm-gun" style="margin: 0px 0px;"></div>

<script type="text/javascript">

    Ext.onReady(function(){

    <%@include file="../adapter/jsp/outer.jsp" %>
            
          var firmaStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: ['tanim', 'stok', 'miktar'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/gunluk.jsp?action=gunluk'
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
                        var winHandle = window.open('adapter/jsp/gunluk.jsp' +
                            "?action=_excel", "_top", "width=600" +
                            ",height=800" +
                            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                        if (winHandle == null){
                            msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                        }
                    }
                },
				'-',
                {
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel (Detaylý)',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open('adapter/jsp/gunluk.jsp' +
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
                    header: 'Bufe Adý',
                    width: 260,
                    dataIndex: 'tanim',
                    sortable: true,
                    blankText: ''
                },
                {
                    header: 'Malzeme',
                    width: 160,
                    dataIndex: 'stok',
                    blankText: ''
                },
                {
                    header: 'Miktar',
                    width: 60,
                    dataIndex: 'miktar'
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
                renderTo : 'frm-gun',
                items    : [
                gridFirmalar
                ]
                });
                //firmaStore.load({params:{start:0, limit:10, action:'firma'}});
    });
</script>
