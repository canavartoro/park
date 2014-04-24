<%@page contentType="text/html" pageEncoding="windows-1254"%>

function createChart(){

    var store = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: [
                    'kod', 'toplam'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/firma.jsp?action=pie'
            }),
            autoLoad: true
        });

    var firmaStore = new Ext.data.Store({
            reader: new Ext.data.JsonReader({
                fields: [
                    'kod', 'toplam'],
                root: 'rows'
            }),
            proxy: new Ext.data.HttpProxy({
                url: 'adapter/jsp/firma.jsp?action=bar'
            }),
            autoLoad: true
        });        

    var columnChart = new Ext.chart.ColumnChart({
        store: firmaStore,
        //url:'../ext-3.0-rc1/resources/charts.swf',
        xField: 'kod',
        yField: 'toplam'
    });

    new Ext.Panel({
        width: 520,
        height: 300,
        title: 'Bölge Bazýnda Hesap Durum Görünümü',
        renderTo: 'container-pie',
        items: [
        {
            store: store,
            xtype: 'piechart',
            dataField: 'toplam',
            categoryField: 'kod',
            //extra styles get applied to the chart defaults
            extraStyle:
            {
                legend:
                {
                    display: 'bottom',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 13
                    }
                }
            }
        }
        ]
    });

    new Ext.Panel({
        width: 520,
        height: 300,
        title: 'Anlýk Hesap Durum Görünümü',
        renderTo: 'container-bar',
        items: [
        columnChart
        ]
    });

}


