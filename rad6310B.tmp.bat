
del /s /q *.vspscc

del /s /q /f /ah *.suo

del /s /q *.sup

del /s /q *.aps

del /s /q *.obj

del /s /q *.idb

del /s /q *.pdb

del /s /q *.exp

del /s /q *.pch

del /s /q *.pdb

del /s /q /f *.suo

del /s /q *.ncb

del /s /q *.sbr

del /s /q *.ilk

del /s /q *.bsc

del /s /q *.map

del /s /q *.pft

del /s /q *.xml

COLOR 1f

TITLE YEDEK


cd yedek

"C:\Program Files\WinRAR\rar" a -r -x*.rar -x*.exe -x*.pdb -x*.bat -x*.svn -x*.svn* -x*.trace -x*.dll -x*.db -x*.sdf -x*.nt -ed -ep1 images1.rar "D:\park\park"

cls

SET FAIL="Dosyalar Yedeklendi " images1.rar 

FOR /F "tokens=1,2,3 delims=/ " %%I IN ('DATE /T') DO SET date1=%%I%%J%%K
FOR /F "tokens=1,2 delims=: " %%I IN ('TIME /T') DO SET time1=%%I:%%J
ECHO %date1% %time1%  %FAIL% >>backup.log& GOTO :EOF

exit

