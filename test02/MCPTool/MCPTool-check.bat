@echo off

echo ***********************************
echo �������������
echo !
echo ����
echo --------
echo 1. ���apk���Ѿ�д��������ţ�

echo ?
echo ʹ�÷���
echo --------
echo 1. ��apk�ļ��ŵ�MCPToolĿ¼��
echo 2. ��apk�ļ���ק��MCPTool-check.bat��
echo 3. ���ڿ���̨��ʾ����������
echo ***********************************


rem ��ק���ļ����������еĵ�һ������
set apkFile=%1
rem cd���������ڵĸ�Ŀ¼
cd /d %apkFile%\..


echo .........MCPTool..........
java -jar MCPTool-1.1.jar -path "%apkFile%" -password 12345678
echo.
echo ��������˳�����
pause>nul
exit