@echo off
echo Compiling %1...
copy /y %1 %1.bak >> null
luac %1
if exist luac.out copy /y luac.out %1 >> nil
if exist luac.out del luac.out
