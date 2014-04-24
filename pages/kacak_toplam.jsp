<%--
Solution Developer
29 Aðustos 2010 Pazar 12:52
Canavar.Toro
---------------------------
Adapter : adapter/jsp/peron.jsp

--%>
<%@page contentType="text/html" pageEncoding="windows-1254"%>
<%@include file="../adapter/jsp/yetki.jsp" %>
<%
response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1);
%>

<!-- <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE"> 
<META HTTP-EQUIV="Expires" CONTENT="-1"> -->

<div id="topkacak-win" style="width: 100%;height: 100%;position: relative;margin: 0px 0px;"></div>

<script type="text/javascript">
	    
    Ext.onReady(function(){

        Ext.QuickTips.init();	                
       
        
        var ds_model = Ext.data.Record.create([
            'sayi','plaka','fiyat'
        ]);
               

             var aboneStore = new Ext.data.Store({
             reader: new Ext.data.JsonReader({
             id: 'id',
             totalProperty: 'totalCount',
             idProperty: 'plaka',
                fields: [
                    'sayi','plaka','fiyat'],
                root: 'rows'
                }),
                proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/peron.jsp?action=topkacak'
                }),
				listeners: {
					load : function(store, records, options) {
						// only load with filled array!
						//console.log('done');
					},
					exception : function(proxy, type, action, options, res, arg) {
						//console.log(type,action,options, res, arg);
						//alert('bir hata olustu:' + res.statusText + proxy.url);
					}
				},
                autoLoad: false,
                autoDestroy: true
                });

                aboneStore.on('loadexception', function(event, options, response, error) {
					//var rs = Ext.util.JSON.decode(response.responseText);
                    alert("sunucu hatasi:" + response.responseText);
                    //event.stopEvent();
                });

        var pagingAbone = {
            xtype : 'paging',
            store : aboneStore,
            pageSize : 30,
            displayInfo : true,
            items : [
                '-',
				{
                    tooltip:'Kayýtlarý dýþa aktar',
                    text : 'Excel',
                    icon: 'resources/icons/page_excel.png',
                    //iconCls: 'x-button-cancel'
                    handler:function() {
                        var winHandle = window.open("adapter/jsp/peron.jsp?action=exctop", "_top", "width=600" +
                            ",height=800" +
                            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                        if (winHandle == null){
                            msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                        }
                    }
                }
                ]
        }       

        var gridPeronlar = new Ext.grid.EditorGridPanel({
            id:'gridTopKacaklar',
            region:'center',
            ds: aboneStore,
            title:'Peron Detaylarý',
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
                        
                    }
                },
				beforeedit : function(e) {				
					//alert(e.record.get('bitis_tarihi'));
					//this.currentlyEditedRecord = e.record;
					/*if(e.record.data.TaskType === '' && e.field !== 'TaskType') {
						//TODO (enhancement) This would be great if it didn't interrupt the tabbing between fields in the grid.
						return false;
					}*/
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
				new Ext.grid.RowNumberer(),
                {
                    header: 'Kayýt Sayýsý',
                    width: 80,
                    dataIndex: 'sayi',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'numeric'
                    }
                },
                {
                    header: 'Plaka No',
                    width: 260,
                    dataIndex: 'plaka',
                    sortable: true,
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                },
                {
                    header: 'Fiyat',
                    width: 160,
                    dataIndex: 'fiyat',
                    filterable: true,
                    filter: {
                        type: 'string'
                    },
                    blankText: ''
                }]),
            bbar    : [
                pagingAbone,
                {
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xhareket', 
                    name: 'xhareket',
                    value: ''
                },
				{
                    xtype: 'textfield',
                    editable: false,
                    inputType: 'hidden',
                    id: 'xabonedetay',
                    name: 'xabonedetay',
                    value: ''
                }
                ],
            tbar:[
                {
                    xtype:'label',
                    fieldLabel: 'Plaka:',
                    text: 'Plaka:'
                },
                {
                  xtype:'textfield',
                  id:'text_koplaka',
                  fieldLabel: 'Plaka',
                  text: 'Plaka:',
                  hideLabel: false,
                  //anchor:'50%',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },'-',
				{
                    xtype:'label',
                    fieldLabel: 'Tutar:',
                    text: 'Tutar:'
                },
                {
                  xtype:'textfield',
                  id:'text_kotutar1',
                  fieldLabel: 'tutar',
                  text: 'tutar:',
				  width: 60,
                  hideLabel: false
                  //anchor:'50%'
                },
				'-',
				{
                  xtype:'textfield',
                  id:'text_kotutar2',
                  fieldLabel: 'tutar',
                  text: 'tutar:',
				  width: 60,
                  hideLabel: false
                  //anchor:'50%'
                },
                {
                    tooltip:'Kayýtlarý Al',
                    text : 'Sorgula',
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                    
                    handler:function() {
						
                        var text_plaka = Ext.getCmp('text_koplaka');
						var text_tutar1 = Ext.getCmp('text_kotutar1');
						var text_tutar2 = Ext.getCmp('text_kotutar2');
                        
                        var grid = Ext.getCmp('gridTopKacaklar');
                        grid.el.mask('Sorgulanýyor ....', 'x-mask-loading');
                        grid.stopEditing();
                        grid.store.removeAll();
                        
						grid.store.load({
							params:{
								action:   'topkacak',
								plaka: text_plaka.getValue(),
								tutar1: text_tutar1.getValue(),
								tutar2: text_tutar2.getValue(),
								start:0,
								limit:30
							}
						});
						
                        grid.el.unmask();

               }
            }
                ]
                });

                var displayPanel = new Ext.Panel({
                frame: true,
                border : true,
                split:true,
                bodyStyle:'padding:5px 5px 0',
                width:'100%',
                height:'100%',
                iconCls: 'icon-cls',
                autoHeight:true,               
                renderTo : 'topkacak-win',
                items    : [
                gridPeronlar
                ]
                });

                 aboneStore.load({params:{start:0, limit:30}});
    });    

</script>
