@echo off
rem Runs every design end to end (csim, csynth, cosim, Vivado P&R), skipping those whose P&R report already exists.
rem Run one design at a time: each Vivado P&R run needs several GB of RAM.
cd /d D:\Ayah\Percobaan2\hls
if not exist prj\sobel_orig\solution1\impl\report\verilog\export_impl.rpt call run.bat sobel orig csim+csynth+cosim+impl
for %%k in (sobel gauss median conv5) do (
  for %%v in (gen gen_stream manual stream mono mono_pipe) do (
    if exist prj\%%k_%%v\solution1\impl\report\verilog\export_impl.rpt (
      echo skip %%k %%v
    ) else (
      echo run %%k %%v
      call run.bat %%k %%v csim+csynth+cosim+impl
    )
  )
)
echo ALL DONE
