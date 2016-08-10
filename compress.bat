@echo off
COLOR 0A

rem ======================================
rem ディレクトリ個別圧縮bat
rem  1.圧縮対象ディレクトリ内対象ファイル削除
rem  2.ディレクトリ圧縮
rem ======================================

echo ======================
echo =  フォルダ圧縮開始  =
echo ======================

rem 圧縮exe指定
set exe="C:\Program Files\7-Zip\7za.exe"
rem 削除対象ファイル
set target="*.html *.htm *.dat *.url *.db Thumbs.* thumbs.* Thumbs*"
rem ファイル削除事前確認[ y or n ]
set confirmation="n"

set __DIR__=%~dp0
rem 圧縮対象Dir一覧作成
dir /B /AD > DirList.dat
for /f "delims=" %%i in (DirList.dat) do (
	rem %%i 内 不要ファイル削除
	echo %%i 内 不要ファイル検索...
	call :DirFileDel "%__DIR__%%%i" %target%
	echo %%i 圧縮中...
	echo %__DIR__%%%i
	rem ディレクトリボリューム
	call :DirVol "%__DIR__%%%i"
	rem 圧縮
	%exe% a "%__DIR__%%%i.zip" "%__DIR__%%%i" >> NUL
	echo ----------
)
DEL %__DIR__%DirList.dat

echo 圧縮が完了しました

PAUSE
EXIT

rem ディレクトリ内削除対象ファイル削除
:DirFileDel

	CD /D %1

	SET EXEC_FLG=
	SETLOCAL ENABLEDELAYEDEXPANSION

	FOR /f "delims=;" %%I IN ('dir /b /on /s %~2') DO (
		rem ファイル存在チェック
		if exist "%%I" (
		  rem 削除確認分岐
		  if %confirmation%=="y" (
		  	rem 事前確認有
			SET /P EXEC_FLG="削除しますか？( y or n ):"
			IF /I "!EXEC_FLG!"=="y" (
				DEL "%%I"
				ECHO ！ %%Iを削除しました。
		    ) else (
				ECHO ！ %%Iを保護しました。
		    )
		  ) else (
		    rem 事前確認無
			DEL "%%I"
			ECHO ！ %%Iを削除しました。
		  )
		  timeout 1 >> NUL
		)
	)
	ENDLOCAL
EXIT /b

rem ディレクトリボリューム
:DirVol
	:%1の容量取得
	dir %1 /s > tmp_dir.txt
	:全体の容量抽出
	find "個のファイル" < tmp_dir.txt > tmp_byte.txt
	:1行のみ抽出
	more +1 tmp_byte.txt | sort /+10000 | sort /+10000 /o tmp_byte.txt
	:容量表示
	for /f "delims=\n" %%i in (tmp_byte.txt) do (
		echo %%i
	)
	DEL tmp_dir.txt
	DEL tmp_byte.txt
EXIT /b
