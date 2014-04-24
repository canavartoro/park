Ext.BLANK_IMAGE_URL = '../resources/s.gif';
Ext.chart.Chart.CHART_URL = '../resources/charts.swf';
Ext.QuickTips.init();
//Ext.QuickTips.enable();/// buraya dikkar ...!!!

function msg(caption,text){
    Ext.MessageBox.show({
        title: caption,
        msg: text,
        buttons: Ext.MessageBox.OK,
        icon: Ext.MessageBox.ERROR,
        animEl: 'header'
    });
}

Ext.onReady(function(){

    Ext.UpdateManager.defaults.indicatorText = 'Yükleniyor ...';

    if(Ext.PagingToolbar){
        Ext.apply(Ext.PagingToolbar.prototype, {
            beforePageText : "Sayfa",
            afterPageText  : " / {0}",
            firstText      : "Ýlk Sayfa",
            prevText       : "Önceki Sayfa",
            nextText       : "Sonraki Sayfa",
            lastText       : "Son Sayfa",
            refreshText    : "Yenile",
            displayMsg     : "Gösterilen {0} - {1} / {2}",
            emptyMsg       : 'Gösterilebilecek veri yok'
        });
    }

    if(Ext.form.TextField){
      Ext.apply(Ext.form.TextField.prototype, {
        minLengthText : "Girilen verinin uzunluðu en az {0} olabilir",
        maxLengthText : "Girilen verinin uzunluðu en fazla {0} olabilir",
        blankText     : "Bu alan boþ¸ býrakýlamaz",
        regexText     : "",
        emptyText     : null
      });
    }


    var firmalar = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            fields: ['kod', 'tanim'],
            root: 'rows'
        }),
        proxy: new Ext.data.HttpProxy({
            url: '../adapter/jsp/firma.jsp?action=firma'
         }),
        autoLoad: true
    });


    
    var users = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            fields: ['kod', 'tanim', 'firma'],
            root: 'rows'
        }),
        proxy: new Ext.data.HttpProxy({
            url: '../adapter/jsp/kullanici.jsp?action=users'
        }),
        autoLoad: true
    });

    var formLogin = new Ext.FormPanel({
        frame: true,
        border: false,
        buttonAlign: 'center',
        bodyStyle:'padding:5px 5px 0',
        //url: 'user/extjs_login',
        //method: 'POST',
        id: 'frmLogin',
        items: [
            {
                xtype:'combo'
                ,fieldLabel:'Firma'
                ,displayField:'tanim'
                ,valueField:'kod'
                ,disabled:false
                ,editable: false
                ,forceSelection : false
                ,id:'firma'
                ,listWidth:200
                ,width:170
                ,store: firmalar
                ,triggerAction:'all'
                ,loadingText : 'Bekleyin....'
                ,mode:'remote'
                ,lastQuery:''
                ,listeners:{select:{fn:function(combo, value, index) {
                            
                            Ext.getCmp('xfirma').setValue(firmalar.getAt(index).data['kod']);
                            Ext.getCmp('users').store.filter('firma', firmalar.getAt(index).data['kod']);
                            Ext.get('fldusername').dom.value = '';
                        }}}
            },
            {
                xtype: 'trigger',
                fieldLabel: 'Kullanýcý',
                id:'fldusername',
                name: 'username',
                width:170,
                hideTrigger: false,
                allowBlank: false,
                triggerClass: 'x-select-trigger',
                onTriggerClick: function() {
                  winUsers.show();
               }
            }, {
                xtype: 'textfield',
                fieldLabel: 'Parola',
                id:'fldpassword',
                name: 'password',
                allowBlank: false,
                width:170,
                inputType: 'password'
            },
            {
                xtype: 'textfield',
                editable: false,
                inputType: 'hidden',
                id: 'xfirma',
                name: 'xfirma',
                value: ''
            }
        ],
        buttons: [
            {
                text: 'Giriþ',
                iconCls: 'x-button-ok',
                handler: giris/*function(){
                    if(formLogin.getForm().isValid()){
                        formLogin.getForm().submit({
                            url: 'xjsp/firma.jsp?action=login',
                            waitMsg: 'Doðrulanýyor bekleyin',
                            waitTitle:'Ýþlem yapýlýyor',
                             success: function(f,a){
                               window.location = 'do.jsp';
                            },
                            failure: function(f,a){
                                if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                                    Ext.Msg.alert('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
                                }
                                if (a.failureType === Ext.form.Action.SERVER_INVALID){
                                    Ext.Msg.alert('Warning', a.result.errormsg);
                                }
                            }
                        });
                    }
                }*/},
            {text: 'Kapat', handler: function() {
                    formLogin.getForm().reset();
                    javascript:window.close();
                }, iconCls: 'x-button-cancel'
            }
        ],
        keys: [
            {key: [Ext.EventObject.ENTER], handler: function() {
                    giris();
                }
            }
        ]
    });

    var winLogin = new Ext.Window({
        title: 'Giriþ',
        id: 'xgiris',
        iconCls:'brick-icon',
        layout: 'fit',
        width: 330,
        height: 170,
        frame:true,
        resizable: false,
        closable: false,
        draggable: false,
        items: [formLogin]
    });

    winLogin.show();

    var pagingToolbar = { //1
        xtype : 'paging',
        store : users,
        pageSize : 10,
        displayInfo : true
    }

    var grid = new Ext.grid.GridPanel({
    //renderTo: document.body,
    frame:true,
    //title: 'Movie Database',
    height:200,
    id:'users',
    width:500,
    store: users,
    autoExpandColumn: 'tanim',
    loadMask : true,
    maskMsg: 'Yükleniyor..',
    viewConfig : {
    forceFit : true
    },
    listeners: {
        'afteredit': function(oe) {
                    //var kod = oe.record.get('kod');
                    //var tanim = oe.record.get('tanim');
                    //var aciklama = oe.record.get('aciklama');
                    //alert(kod + tanim + aciklama);
        },
        'rowdblclick': function(gridObj, rowIndex, e){
            var record = gridObj.getStore().getAt(rowIndex);
            Ext.get('fldusername').dom.value = record.get('kod');
            Ext.getCmp('winUsers').hide();
        }
    },
    bbar : pagingToolbar,
    columns: [
    new Ext.grid.RowNumberer({width: 30}),
    {header: "Kod", dataIndex: 'kod', sortable: true, width: 40},
    {header: "Taným", dataIndex: 'tanim', sortable: true},
    {header: "Firma", dataIndex: 'firma', sortable: true, width: 40}
    ]
    });

    /*
     'kod', 'tanim', 'tahsilat', 'super', 'firma',
                {name: 'kayit_tarihi', mapping: 'kayit_tarihi', type: 'date', dateFormat: 'timestamp'},
                'kayit_kullanici'
     **/

    var winUsers = new Ext.Window({
        title: 'Kullanýcýlar',
        iconCls:'x-users-form',
        id: 'winUsers',
        layout: 'fit',
        width: 350,
        height: 300,
        frame:true,
        closeAction   : 'hide',
        resizable: false,
        closable: true,
        draggable: false,
        items: [grid],
        bbar: [
            {text: 'Seç', handler: function(){
                    var sm = grid.getSelectionModel();
                    var sel = sm.getSelections();
                    Ext.get('fldusername').dom.value = sel[0].get('kod');
                    winUsers.hide();
            }, iconCls: 'x-button-ok'},
            {text: 'Kapat', handler: function() {
                    winUsers.hide();
                }, iconCls: 'x-button-cancel'
            }
        ]

    });
    
    setTimeout(function(){
        //Ext.get('loading').puff();
        //Ext.get('loading-mask').puff();
        Ext.get('loading').remove();
        Ext.get('loading-mask').fadeOut({remove:true});
    }, 500);

    

});

function giris(){
    
    var frm = Ext.get('xfirma').getValue();
    var usr = Ext.get('fldusername').getValue();
    var psw = Ext.get('fldpassword').getValue();

    if((!frm || frm == undefined ) || (!usr || usr == undefined)){
        msg('Hatalý giriþ!','Bilgiler eksik tekrar deneyin!');
        return;
    }
    var formPanel = Ext.getCmp('xgiris');
    formPanel.el.mask('Doðrulanýyor Bekleyin', 'x-mask-loading');

    Ext.Ajax.request({
        url : '../adapter/jsp/firma.jsp',
        params : {
            action : 'login', xfirma : frm, fldusername: usr, fldpassword: psw
        },
        success : function(response) {            
            obj = Ext.util.JSON.decode(response.responseText);
            if( obj.success ){
                formPanel.el.unmask();                
                window.location = '../index.jsp';
            }
            else{
                msg('Giris Yapilamadi!', obj.errors.reason);
            }
        },
        failure: function(f,a){
            obj = Ext.util.JSON.decode(a.response.responseText);
            formPanel.el.unmask();
            msg('Giris Yapilamadi!', obj.errors.reason);
            if (a.failureType === Ext.form.Action.CONNECT_FAILURE){
                msg('Failure', 'Server reported:'+a.response.status+' '+a.response.statusText);
            }
            if (a.failureType === Ext.form.Action.SERVER_INVALID){
                msg('Warning', a.result.errormsg);
            }
        }
    });

    formPanel.el.unmask();
    

}