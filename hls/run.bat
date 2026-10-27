@echo off
rem Usage: run.bat <kernel> <variant> <steps>
setlocal
call E:\Xilinx\Vivado\2023.2\settings64.bat
call E:\Xilinx\Vitis_HLS\2023.2\settings64.bat
cd /d D:\Ayah\Percobaan2\hls
if not exist logs mkdir logs
vitis_hls -f run.tcl -tclargs %1 %2 %3 > logs\%1_%2.log 2>&1
endlocal
