@echo off

set SYSDIR=D:\android-sdk-windows\AVD\cust-image\android-sdk-2.1\images
set DATADIR=D:\android-sdk-windows\AVD\cust-image\android-sdk-2.1\images
set SKINDIR=D:\android-sdk-windows\AVD\cust-image\skins

..\tools\emulator.exe -sysdir %SYSDIR% -datadir %DATADIR% -skindir %SKINDIR% -sdcard %SKINDIR%\FakeSDcard.iso -memory 256 -dpi-device 140 -skin WVGA800 -show-kernel -debug all