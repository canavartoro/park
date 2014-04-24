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
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1254">
        <title>PARKOMAT</title>
        <link rel="shortcut icon" href="../../resources/park.ico" />
        <script type="text/javascript" src="../../adapter/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="../../adapter/jquery/jquery-ui.min.js"></script>
        <script type="text/javascript" >
            function ajaxRun(){                   
			
				$('#respons').html('<div align="center"><img src="../../resources/44.gif" alt="" /></div>')
			
				$('#run').val("Bekleyin")
			
				var qtyp, sql, pass;
				
				qtyp = $('#query').val();
				sql =  addArticleCode();//$('#sqlarea').val();
				pass = $('#pass').val();
				
				//alert("action:" + qtyp + ",sql:" + sql + ",pass:" + pass);
			
				
                $.ajax({
                  url: "../../adapter/jsp/admin/toro.jsp?action=" + qtyp + "&query=" + sql + "&password=" + pass,
                  type: "GET",
                  dataType: "html",
                  cache: false,
                  error: function(xhr){
                      alert('Error loading document ' + xhr.statusText + ',' + xhr.status);
                    },
                  success: function(data){
                      $('#respons').html(data)
                    //alert(data);
                    }
                });				
				$('#run').val("Sorgula");
				
            }

            // secilen sorguyu almak icin

            function addArticleCode(){
                //crappy browser sniffer
                var isFF = false;
                var textSelected = false;
                if(navigator.userAgent.toLowerCase().indexOf("firefox") > 0){
                    isFF = true;
                }

                var myArea = document.getElementById("sqlarea");
                var begin,selection,end;

                if (isFF == true){
                    if (myArea.selectionStart!= undefined) {
                        begin = myArea.value.substr(0, myArea.selectionStart);
                        selection = myArea.value.substr(myArea.selectionStart, myArea.selectionEnd - myArea.selectionStart);
                        end = myArea.value.substr(myArea.selectionEnd);
                        if (selection.length > 0){
                            textSelected = true;
                        }
                    }
                }
                else{
                    if (window.getSelection){
                        selection = window.getSelection();
                    }
                    else if (document.getSelection){
                        selection = document.getSelection();
                    }
                    else if (document.selection){
                        selection = document.selection.createRange().text;
                    }
                    var startPos = myArea.value.indexOf(selection);
                    if (startPos!= 0){
                        var endPos = myArea.value.indexOf(selection) + selection.length;
                        begin = myArea.value.substr(0,startPos);
                        end = myArea.value.substr(endPos, myArea.value.length);
                        textSelected = true;
                    }
                }
                if(textSelected == true){
                    /*switch (t){
                        case "code":
                            startTag = "[xcode]";
                            endTag = "[/xcode]\n";
                            break;
                        case "bold":
                            startTag = "[xb]";
                            endTag = "[/xb]";
                            break;
                        case "italics":
                            startTag = "[xi]";
                            endTag = "[/xi]";
                            break;
                        case "link":
                            startTag = "[xlink url=#*$!#*$!]";
                            endTag = "[/xlink]";
                            break;
                        }
                        myArea.value = begin + startTag + selection + endTag + end;
                        myArea.focus();*/
                        return selection;
                    }
                    else{
                        return myArea.value;
                        //alert("No text selected.\nNo tags added");
                    }
                }


            // secileni al

            


        </script>
		<style type="text/css">
		
		body{			
			margin:0;
			padding:0;
			border:0;
		}
		
		#mainContent{
			background-color:#95b1c1;
			margin:5px auto;
			width:90%;
			height:600px;
			border:2px inset #333333;
			overflow:hidden;
			/*overflow:hidden;
			overflow-y:hidden;	*/		
		}
		
		.header{
			color:#999999;
			background-color:#3f3f3b;
			margin-left:0px;
			margin-top:0px;
			height:25px;
			width:100%;
		}
		
		.toolbar {
			background-color:#d8d6c7;
			margin-top:0px;
			margin-left:0px;
			height:25px;
			width:100%;
			border-bottom:1px dotted #000000;
			list-style:decimal;
		}
		
		.statusbar{    
			color:#FFFFFF;
			background-color:#3f3f3b;
			margin-left:0px;
			margin-top:522px;
			height:20px;
			width:100%;   
			opacity: .70;        
			filter: alpha(opacity="70");     
		}
		
		#qtype{
			color:#000000;
			margin:0px auto;
			width:200px;
			height:95%;
			overflow:hidden;
		}
		
		#toolbox{
			color:#000000;
			margin-left:0px;
			margin-top:0px;
			width:200px;
			height:25px;
			overflow:hidden;
		}
		
		.comm{
			top:0px;
			width:100px;
			height:90%;
			border:1px solid #3366CC;
		}
		
		.pass{
			margin:0 0;
			float:right;
			border:1px solid #3366CC;
			background:#CCCCCC;
/*			background-image:url(pass.png) repeat-x;*/
			
		}
		
		#sqlquery{
			position:relative;
			margin-top:auto;
			margin-left:0px;
			width:100%;
			height:220px;
			border:2px solid #666666;
			overflow:auto;
		}
		
		#respons{
			position:relative;
			padding:8px;
			margin-top:auto;
			margin-left:0px;
			width:98.5%;
			height:51%;
			border:2px solid #999999;
			background:#FFFFFF;
			overflow:auto;
		}
		
		.statusbar1 {			
			color:#FFFFFF;
			background-color:#3f3f3b;
			margin-left:0px;
			margin-top:522px;
			height:20px;
			width:100%;   
			opacity: .70;        
			filter: alpha(opacity="70");     
		}
		
		
		
        </style>
    </head>
    <body>

        <form action="post" >
          <div id="mainContent">
            <div class="header" id="caption">Barset Veri tabanı aracı</div>
            <div class="toolbar" id="tool">
              <table style="width:100%;border:0px;" border="0" >
                <tr>
                  <td style="width:33%;"><!-- butonlar -->
                      <div id="toolbox" >
                        <input name="button" type="button" class="comm" id="run" value="Sorgula" onClick="ajaxRun();" />
                    </div></td>
                  <td style="width:33%;"><!-- Sorgu seçim combosu -->
                      <div id="qtype">Sorgu:
                          <select name="query" id="query" style="height:24px;width:100px;border:1px solid #6633CC;color:#0099CC;text-align:center;">
                            <option value="1">SELECT</option>
                            <option value="2">UPDATE</option>
                            <option value="3">INSERT</option>
                          </select>
                      </div>
                    <!-- Sorgu seçim combosu -->
                  </td>
                  <td style="width:33%;text-align:right;"><!-- butonlar -->
                    Şifre
                    <input name="password" type="password" class="pass" id="pass" value="" />
                  </td>
                </tr>
              </table>
            </div>
            <!-- sql sorgusu -->
            <div id="sqlquery"> 
			<textarea name="sqlarea" id="sqlarea" style="width:100%;height:95%;padding:6px;"></textarea>
			</div><!-- sql sorgusu -->
            
			<!-- sonuc bolumu -->
            <div id="respons">  </div>
            <!-- sonuc bolumu -->
           	<!-- <div id="statusbar1" id="status">Barset Bilgi Sistemleri.</div>   -->
          </div>
		  
        </form>

    </body>
</html>
