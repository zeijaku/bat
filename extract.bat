@echo off
COLOR 0B

chcp 932

rem ======================================
rem ディレクトリ個別解凍bat
rem  1.カレント内の解凍対象拡張子リスト化
rem  2.リスト内ファイル解凍
rem ======================================

echo ======================
echo =  フォルダ解凍開始  =
echo ======================
rem 解凍拡張子
set type="rar zip"

set __DIR__=%~dp0

rem 圧縮exe指定
set exe="C:\Program Files\7-Zip\7z.exe"

rem カレントディレクトリ一覧
dir /B /A-D | findstr %type% > ZipList.dat

for /f "delims=" %%i in (ZipList.dat) do (
    echo %__DIR__%%%i 解凍中...
	rem 解凍
	%exe% x -y "%__DIR__%%%i" * >> NUL
    echo ----------
    timeout 1 >> NUL

)
rem DEL ZipList.dat

echo 解凍が無事なく完了しました

PAUSE
EXIT
