:: for Win64
cd /d "C:\Program Files\Sublime Merge" || exit
certutil -hashfile sublime_merge.exe md5 | find /i "B5498E935CB0906DF9A2D0B6CB5B056B" || exit

echo "Correct Version"
timeout /t 10

echo 00025AEE: 48 31 C0 C3             | xxd -r - sublime_merge.exe
echo 00029059: 90 90 90 90 90          | xxd -r - sublime_merge.exe
echo 00029072: 90 90 90 90 90          | xxd -r - sublime_merge.exe
echo 000273E9: 48 31 C0 48 FF C0 C3    | xxd -r - sublime_merge.exe
echo 000256F1: C3                      | xxd -r - sublime_merge.exe
echo 00024798: C3                      | xxd -r - sublime_merge.exe

timeout /t 10