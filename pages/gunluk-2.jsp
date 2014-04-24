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

        /*var date1, date2;
        var currentTime = new Date();
        date1 = new Date();
        date2 = new Date();
		
        if( currentTime.getHours() < 14 ){
            date1.setDate(currentTime.getDate() - 1);
            date1.setHours(14, 30, 0, 0);
            date2.setHours(14, 30, 0, 0);
        }
        else{
            date1.setHours(14, 30, 0, 0);
            date2.setDate(currentTime.getDate() + 1);
            date2.setHours(14, 30, 0, 0);
        }*/

        var dateBaslangic = new Ext.form.DateField({
            id:'baslangic',
            name: 'baslangic',
            fieldlabel:'Baþlangýç Tarihi:',
            format: 'd-m-Y',
            allowBlank:false,
            value: new Date()
         });
		 
		var startTimePicker = new Ext.form.TimeField({
			triggerClass: 'x-form-time-trigger',
			fieldLabel: 'Baþlangýç',
			name: 'bassaat',
			id:'bassaat',
			editable:false,
			width:80,
			increment: 30,
			value:'',
			format:"H:i",
			value: '13:00'
		});	
      

         var dateBitis = new Ext.form.DateField({
            id:'bitis',
            fieldlabel:'Bitiþ Tarihi:',
            format: 'd-m-Y',
            name: 'bitis',
            width:140,
            allowBlank:false,
            value: new Date()
         });
		 
		var endTimePicker = new Ext.form.TimeField({
			triggerClass: 'x-form-time-trigger',
			fieldLabel: 'Bitiþ',
			name: 'bitsaat',
			id:'bitsaat',
			width:80,
			increment: 30,
			editable:false,
			format:"H:i",
			value: '13:00'
		});
            
          var firmaStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: ['tanim', 'stok', 'miktar', 'adet'],
                root: 'rows',
                baseParams: {
                    action:   'gunluk',
                    baslangic:   formatDate(new Date(dateBaslangic.getValue()),'yyyy-MM-dd'),
                    bitis:   formatDate(new Date(dateBitis.getValue()),'yyyy-MM-dd'),
					bass : startTimePicker.getValue(),
					bits : endTimePicker.getValue()
                }
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/gunluk.jsp'
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
					var bass = startTimePicker.getValue();
					var bits = endTimePicker.getValue();
					
                        var winHandle = window.open('adapter/jsp/gunluk.jsp' +
                            "?action=_excel&baslangic=" + formatDate(new Date(dateBaslangic.getValue()),'yyyy-MM-dd') +
                            "&bitis=" + formatDate(new Date(dateBitis.getValue()),'yyyy-MM-dd') +
							"&bassaat=" + bass + "&bitsaat=" + bits, "_top", "width=600" +
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
					
					var bass = startTimePicker.getValue();
					var bits = endTimePicker.getValue();
                        
                        var winHandle = window.open('adapter/jsp/gunluk.jsp' +
                            "?action=excel&baslangic=" + formatDate(new Date(dateBaslangic.getValue()),'yyyy-MM-dd') +
                            "&bitis=" + formatDate(new Date(dateBitis.getValue()),'yyyy-MM-dd') +
							"&bassaat=" + bass + "&bitsaat=" + bits, "_top", "width=600" +
                            ",height=800" +
                            ",location=0,menubar=0,resizable=no,scrollbars=no,status=yes,titlebar=no,dependent=yes");

                        if (winHandle == null){
                            msg("Hata!","Error: While Launching New Window...nYour browser maybe blocking up Popup windows. nn  Please check your Popup Blocker Settings");
                        }
                    }
                }                
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
                },
                {
                    header: 'Kart Sayýsý',
                    width: 60,
                    dataIndex: 'adet'
                }]),
            bbar    : [
                pagingToolbar,
                '-',
                {
                  xtype:'label',
                  fieldLabel: 'Kart Sayýsý',
                  text: 'Kart Sayýsý:',
                  bodyStyle: {
                    background: '#ffffff',
                    padding: '7px'
                  }
                },
                {
                    xtype:'label',
                    fieldLabel: 'Kart Sayýsý',
                    text: '0',
                    id: 'kartsay'
                },
                '-',
                {
                  xtype:'label',
                  fieldLabel: 'Kart Sayýsý',
                  text: 'Toplam Adet:'
                },
                {
                    xtype:'label',
                    fieldLabel: 'Kart Sayýsý',
                    text: '0',
                    id: 'topsay'
                }
                ],
                tbar:[
                {
                  xtype:'label',
                  fieldLabel: 'Baþlangýç Tarihi',
                  text: 'Baþlangýç Tarihi:'
                },
                dateBaslangic,	
				startTimePicker,
                '-',
                {
                  xtype:'label',
                  fieldLabel: 'Bitiþ Tarihi',
                  text: 'Bitiþ Tarihi:'
                },
                dateBitis,
				endTimePicker,
                {
                    tooltip:'Kayýtlarý Al',
                    text : 'Sorgula',
                    icon: 'resources/images/yourtheme/dd/drop-yes.gif',
                    //iconCls: 'x-button-cancel'
                    handler:function() {

                        var bas = formatDate(new Date(dateBaslangic.getValue()),'yyyy-MM-dd');
                        var bit = formatDate(new Date(dateBitis.getValue()),'yyyy-MM-dd'); 

						var bass = startTimePicker.getValue();
						var bits = endTimePicker.getValue();

                        var grid = Ext.getCmp('firmaGrid');
                        //grid.el.mask('Hesaplanýyor ....', 'x-mask-loading');
                        //grid.stopEditing();

                        Ext.Ajax.request({
                            url : 'adapter/jsp/gunluk.jsp',
                            params : {
                                action : 'toplam',
                                baslangic:   bas,
                                bitis:   bit,
								bassaat: bass,
								bitsaat: bits
                            },
                            success : function(response) {
                                grid.el.unmask();
                                var obj = Ext.util.JSON.decode(response.responseText);
                                if(!obj.success){
                                    msg('Kayýt silinemedi!', obj.errors.reason);
                                }


                                Ext.get('kartsay').update(obj.bilgiler.kart);
                                Ext.get('topsay').update(obj.bilgiler.toplam);

                                //Ext.getCmp('kartsay').setValue(obj.bilgiler.kart);
                                //Ext.getCmp('topsay').setValue(obj.bilgiler.toplam);
                            },
                            failure: function(f,a){
                                grid.el.unmask();
                                if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                                msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
                            }
                            if (a.failureType === Ext.form.Action.SERVER_INVALID){
                                msg('Warning', a.result.errormsg);
                            }
                        }
                    });

                    /*Ext.getCmp('firmaGrid')*/grid.store.load({
                            params:{
                                action:   'gunluk',
                                baslangic:   bas,
                                bitis:   bit
                            }
                        });

               }
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
                renderTo : 'frm-gun',
                items    : [
                gridFirmalar
                ]
                });
                //firmaStore.load({params:{start:0, limit:10, action:'firma'}});
    });
</script>
