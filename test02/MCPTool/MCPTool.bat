@echo off

echo ***********************************
echo �������������
echo !
echo ����
echo --------
echo 1. ����apk�ļ������ǩ�������������������ܣ�
echo 2. ��ȡapk�е������ţ�ִ��MCPTool-check.bat��Java������ʹ��MCPTool.jar�е�readContent(path, password)������ȡ��

echo ?
echo ʹ�÷���
echo --------
echo 1. ��apk�ļ��ŵ�MCPToolĿ¼��
echo 2. ��apk�ļ���ק��MCPTool.bat��
echo 3. ִ����ɺ���ڵ�ǰĿ¼�����ɸ���������apk�ļ�
echo ***********************************


rem ��ק���ļ����������еĵ�һ������
set apkFile=%1
rem cd���������ڵĸ�Ŀ¼
cd /d %apkFile%\..


echo .........MCPTool..........
java -jar MCPTool-1.1.jar -path "%apkFile%" -outdir ./ -contents googleplay;m360;wandoujia;tencent;baidu;taobao;xiaomi; -password 12345678
echo.
echo ��������˳�����
pause>nul
exit