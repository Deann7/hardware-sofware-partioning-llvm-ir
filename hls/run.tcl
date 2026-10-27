# Usage: vitis_hls -f run.tcl -tclargs <kernel> <variant> <steps>
#   kernel : sobel | gauss | median | conv5
#   variant: mono | mono_pipe | orig | manual | gen | stream | gen_stream
#   steps  : plus-separated list of csim,csynth,cosim,impl
set root    "D:/Ayah/Percobaan2"
set kernel  [lindex $argv end-2]
set variant [lindex $argv end-1]
set steps   [split [lindex $argv end] "+"]
set kdir    "$root/kernels/$kernel"

set reftop [dict create sobel sobel_codesign_filter gauss gauss_filter median median_filter conv5 conv5_filter]
set top [dict get $reftop $kernel]
set src "$kdir/ref.cpp"
set def V_MONO
switch $variant {
    mono      { }
    mono_pipe { }
    orig      { set top sobel_hw_datapath; set src "$kdir/orig_hw.cpp"; set def V_ORIG }
    manual    { set top ${kernel}_win;    set src "$kdir/manual.cpp";  set def V_MANUAL }
    gen       { set top ${kernel}_hw_gen; set src "$kdir/gen/hw.cpp";  set def V_GEN }
    stream    { set top ${kernel}_stream; set src "$kdir/stream.cpp";  set def V_STREAM }
    gen_stream { set top ${kernel}_stream; set src "$kdir/gen/stream.cpp"; set def V_STREAM }
    default   { error "unknown variant $variant" }
}

set inc "-I$kdir -I$root/common"
open_project -reset "$root/hls/prj/${kernel}_${variant}"
set_top $top
add_files $src -cflags $inc
add_files -tb "$root/common/tb.cpp" -cflags "$inc -D$def"
open_solution -reset "solution1" -flow_target vivado
set_part {xc7z020clg484-1}
create_clock -period 10 -name default

if {$variant eq "orig"} {
    config_interface -default_slave_interface s_axilite
}
if {[string match mono* $variant]} {
    # Conventional full-image HLS accelerator: image buffers in DDR via AXI master,
    # control and buffer addresses via AXI4-Lite. Source code is left untouched.
    set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 4096 $top input
    set_directive_interface -mode m_axi -bundle gmem -offset slave -depth 4096 $top output
    set_directive_interface -mode s_axilite $top
    if {$variant eq "mono_pipe"} {
        set_directive_pipeline -II 1 "$top/X_LOOP"
    }
}

foreach s $steps {
    switch $s {
        csim   { csim_design }
        csynth { csynth_design }
        cosim  { cosim_design -rtl verilog }
        impl   { export_design -flow impl -rtl verilog -format ip_catalog }
    }
}
exit
