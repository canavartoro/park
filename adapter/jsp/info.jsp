
<%@page contentType="text/html" pageEncoding="windows-1254"%>

<div id="info" class="info">
    <%= x %><br>
    Yeni kay�t <strong>Ekle</strong>mek i�in <strong>Ekle</strong> butonunu kullan�n, gerekli alanlar� doldurduktan sonra <strong>Kaydet</strong> butonunu kullan�n.<br>
    Kay�t d�zetlmek i�in d�zeltilecek alana �ift t�klat�n d�zeltin <strong>Kaydet</strong> butonunu kullan�n. ��lemi iptal etmek i�in <strong>Kaydet</strong> demeden <strong>�ptal</strong> butonunu kullan�n.<br>
    Kay�t silmek i�in, sat�r� se�in ve <strong>Sil</strong> butonunu kullan�n a��lan kutuya evet se�ene�ine t�klat�n.<br>
    Kay�tlar� d��a aktarmak i�in <strong>Excel</strong> butonunu kullan�n.
</div>

<script type="text/javascript">
window.setTimeout(function() {
    Ext.get('info').fadeOut({remove:true});
}, 8000);
</script>
