
<%-- 
    Document   : statu
    Created on : 30.Tem.2010, 11:52:42
    Author     : huseyin
--%>

<%@page import="org.barset.data.Database"%>

<%@page contentType="text/html" pageEncoding="windows-1254"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Palaka Sorgulama</title>


<style type="text/css">

<!--

body{
	background-color: #F8F8F8;/*#c3daf9;*/
	color:#284051;
	font-size: 16px;
	font-family: "Trebuchet MS",sans-serif;
	line-height: 1.6em;
}

#res {
	width:99%;
	height:auto;
	overflow:auto;
	padding:5px 5px;	
}

#box-table-a 
{ 
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif; 
	font-size: 12px; 
	margin: 5px; 
	width: auto; 
	text-align: left; 
	border-collapse: collapse; 
} 
#box-table-a th 
{ 
	font-size: 13px; 
	font-weight: normal; 
	padding: 8px; 
	background: #b9c9fe; 
	border-top: 4px solid #aabcfe; 
	border-bottom: 1px solid #fff; 
	color: #039; 
} 
#box-table-a td 
{ 
	padding: 8px; 
	background: #e8edff;  
	border-bottom: 1px solid #fff; 
	color: #669; 
	border-right: 1px dashed #6cf;
	border-top: 1px solid transparent; 
} 
#box-table-a tr:hover td 
{ 
	background: #d0dafd;
	color: #339; 
} 
#box-table-a .text 
{
height:80%;
width:100%; 
margin-top: 0px; 
margin-left: 0px; 
vertical-align: middle; 
color: #039; 
background-color: #e8edff; 
text-align:right; 
border:0px;
}

#box-table-a .btn 
{
height:80%;
width:100%; 
margin-top: 0px; 
margin-left: 0px; 
vertical-align: middle; 
color: red; 
background-color: #e8edff; 
text-align:right; 
border:0px;
}

#cmd {
	font-family: Georgia, "Times New Roman", Times, serif;
	font-size: 9px;
	color: #FFFFFF;
	background-color: #669;
	border:1px solid #FFFFFF;
	position: relative;
	padding:0px;
	left: 10px;
	top: 10px;
	width: 75px;
	height: 25px;
	list-style-position: inside;
}

.btx{
	border:0px;
	background-color: #669;
	color: #FFFFFF;
}

-->
</style>

<script type="text/javascript">

	function getir(t){	
		
		$('#run').val("Bekleyin")
		var qtyp, sql, pass;
		qtyp = $('#plaka').val();
		if( t == '1' && qtyp == '' ){
			alert('Plaka girilmedi!');
			return;
		}
		
		$('#res').html('<div align="center"><img src="../../resources/44.gif" alt="" /></div>');		
		
		var param = '';
		if( t == '1' ){
			param = 'adapter/jsp/rapor/rapor.jsp?action=psor&plaka=' + qtyp;
		}
		else if ( t == '4' ){
			param = 'adapter/jsp/rapor/rapor.jsp?action=hsor&plaka=' + qtyp;
		}
		else{
			param = 'ajax.asp?hes=1';
		}
	
	$.ajax({
		url: param, //+ "&query=" + sql + "&password=" + pass,
		type: "GET",
		dataType: "html",
		cache: false,
		error: function(xhr){
//			alert('Sunucu hatasi ' + xhr.statusText + ',' + xhr.status);
			$('#res').html('<div align="center">Sunucu hatasi ' + xhr.statusText + ',' + xhr.status + '</div>');	
			},
		success: function(data){
			$('#res').html(data);
		}
	});			
	$('#run').val("Sorgula");

}

</script>
</head>

<body>
<table height="106" border="0" cellpadding="1" cellspacing="1" style="left:10px; top:10px; width:100%;border: 1px dashed #284051;padding:5px 5px;">
  <caption style="margin:5px 5px;background-color: #284051;color:#FFFFFF;height:35px;">
    Plaka Sorgulama
  </caption>
  <tr height="30">
    <td width="20px" height="27">Tarih </td>
    <td width="20px"><input type="text" name="hesap_tarih" id="hesap_tarih" /></td>
    <td width="20px"><input name="button" type="button" id="run" style="background-color:#DFE8F6;border-bottom: 1px solid #8DB2E3;" onclick="javascript:getir('1');" value="Sorgula" /></td>
	<td width="60%"><input name="button22" type="button" id="button2" style="background-color:#DFE8F6;border-bottom: 1px solid #8DB2E3;" onclick="javascript:getir('4');" value="Plaka Hareketleri" /></td>
  </tr>
  <tr>
    <td colspan="5" style="overflow:hidden;"><div id="res" >Gösterilecek Bilgi Yok</div></td>
  </tr>
  <tr><td></td></tr>
  <tr>
    <td colspan="5"></td>
  </tr>
</table> 
<div id="hesap_rapor" style="width:100%;height:100%;">
		<script type="text/javascript"> 
		
		Ext.onReady(function(){
		
		Ext.QuickTips.init();

		var dr = new Ext.FormPanel({
		  labelWidth: 125,
		  frame: true,
		  autoHeight: true,
		  autoScroll:true,
		  autoWidth: true,
		  title: 'Date Range',
		  bodyStyle:'padding:5px 5px 0',
		  width: 350,
		  defaults: {width: 175},
		  defaultType: 'datefield',
		  tbar: [{
			fieldLabel: 'Start Date',
			name: 'startdt',
			id: 'startdt',
			vtype: 'daterange',
			endDateField: 'enddt' // id of the end date field
		  },{
			fieldLabel: 'End Date',
			name: 'enddt',
			id: 'enddt',
			vtype: 'daterange',
			startDateField: 'startdt' // id of the start date field
		  }],
		  items:[]
		});

		dr.render('hesap_rapor');
		
		});		
</script>
</body>
</html>
