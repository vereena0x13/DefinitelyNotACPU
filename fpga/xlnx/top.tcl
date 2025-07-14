set hwDir [file normalize ..]
set verilogDir [file normalize $hwDir/verilog]
set genDir [file normalize $hwDir/gen]
set xlnxDir [file normalize $hwDir/xlnx]
set rptDir [file normalize $xlnxDir/rpt]


set_part xc7a100tcsg324-1


read_verilog $genDir/CPU.v
read_verilog $verilogDir/top.v
read_verilog $verilogDir/synchronizer.v


read_xdc $xlnxDir/top.xdc


synth_design -top top


opt_design
place_design
route_design


report_methodology                                          \
    -file $rptDir/methodology.rpt

report_timing_summary                                       \
    -file $rptDir/timing_summary.rpt

report_timing                                               \
    -file $rptDir/timing.rpt

report_clock_utilization                                    \
    -file $rptDir/clock_utilization.rpt

report_utilization                                          \
    -hierarchical                                           \
    -hierarchical_percentages                               \
    -file $rptDir/utilization.rpt

report_route_status                                         \
    -file $rptDir/route_status.rpt

report_io                                                   \
    -file $rptDir/io.rpt

report_power                                                \
    -file $rptDir/power.rpt

report_drc                                                  \
    -file $rptDir/drc.rpt



write_bitstream -bin_file -force top.bit