@echo off

"Build/vasmm68k_psi-x.exe" -regsymredef -altlocal -altnum -m68000 -maxerrors=0 -no-opt -Fbin -start=0 -o "SHC Splash.bin" -L _LISTING.lst -Lall "SHC Splash.asm" 2> _ERROR.log
type _ERROR.log

if not exist "SHC Splash.bin" pause & exit
echo.
del _ERROR.log

echo.