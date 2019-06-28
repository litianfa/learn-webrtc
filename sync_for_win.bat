@echo off

:: ��ȡ�ű�����·��
set script_path=%~dp0
:: ����ű�����Ŀ¼,��Ϊ���Ӱ��ű���ִ�еĳ���Ĺ���Ŀ¼
set old_cd=%cd%
cd /d %~dp0

echo=
echo ---------------------------------------------------------------
echo ���depot_tools
echo ---------------------------------------------------------------
set depot_tools_path=%script_path%depot_tools
if exist %depot_tools_path% (
    echo %depot_tools_path% �Ѵ���
) else (
    echo %depot_tools_path% �����ڣ�����depot_tools
    call git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
)
:: if�Ӿ��ERRORLEVEL�ò�����ȷ��ֵ������git clone����õ������ж�
if not %ERRORLEVEL% == 0 (
    echo depot_tools����ʧ��
    exit 1
)

:: ������������
set PATH=%depot_tools_path%;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0

echo=
echo ---------------------------------------------------------------
echo ��ʼ��depot_tools
echo ---------------------------------------------------------------
call gclient

if not %ERRORLEVEL% == 0 (
    echo ��ʼ��depot_toolsʧ��
    exit 1
)

echo=
echo ---------------------------------------------------------------
echo ͬ��webrtc����
echo ---------------------------------------------------------------
set webrtc_path=%script_path%webrtc
set webrtc_src_path=%webrtc_path%/src
if not exist %webrtc_path% (
    md %webrtc_path%
)
cd %webrtc_path%
if not exist %webrtc_src_path% (
    call fetch --nohooks webrtc
)
call gclient sync
cd %webrtc_src_path%
call git checkout master
call git pull origin master
call gclient sync

if not %ERRORLEVEL% == 0 (
    echo webrtcͬ��ʧ��
    exit 1
)

:: �ָ�����Ŀ¼
cd %old_cd%

echo allͬ���ɹ�
exit 0