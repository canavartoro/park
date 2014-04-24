
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="info" class="info">
    <%= x %><br>
    Yeni kayýt <strong>Ekle</strong>mek için <strong>Ekle</strong> butonunu kullanýn, gerekli alanlarý doldurduktan sonra <strong>Kaydet</strong> butonunu kullanýn.<br>
    Kayýt düzetlmek için düzeltilecek alana çift týklatýn düzeltin <strong>Kaydet</strong> butonunu kullanýn. Ýþlemi iptal etmek için <strong>Kaydet</strong> demeden <strong>Ýptal</strong> butonunu kullanýn.<br>
    Kayýt silmek için, satýrý seçin ve <strong>Sil</strong> butonunu kullanýn açýlan kutuya evet seçeneðine týklatýn.<br>
    Kayýtlarý dýþa aktarmak için <strong>Excel</strong> butonunu kullanýn.
</div>

<script type="text/javascript">
window.setTimeout(function() {
    Ext.get('info').fadeOut({remove:true});
}, 8000);
</script>
