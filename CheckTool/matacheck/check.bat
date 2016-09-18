@echo off
::java -jar lib/check.jar %var%
cd lib
java -jar check.jar ../../apk
echo.&echo 请按任意键退出...&pause>nul
exit 