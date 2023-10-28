# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config  -ruleid {1}  -id {Common 17-69}  -string {{ERROR: [Common 17-69] Command failed: Placer could not place all instances}}  -suppress 
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.cache/wt [current_project]
set_property parent.project_path C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/imports/Desktop/00.coe
add_files C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/imports/Desktop/weights.coe
read_verilog -library xil_defaultlib {
  C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/new/BrickBreaker_display.v
  C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/new/BrickBreaker_gameOver.v
  C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/imports/Desktop/Oled_Display.v
  C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/new/clk6p25m.v
  C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/sources_1/new/BrickBreaker_game.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/constrs_1/new/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/bened/OneDrive/Documents/EE2026-Project/MODS/MODS.srcs/constrs_1/new/Basys3_Master.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top BrickBreaker_game -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef BrickBreaker_game.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file BrickBreaker_game_utilization_synth.rpt -pb BrickBreaker_game_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]