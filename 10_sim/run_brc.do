transcript file "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/sim_log.txt"

vlib work
vlog D:/CTMT/Milestones/Milestone_2/milestone2/00_src/brc.sv
vlog D:/CTMT/Milestones/Milestone_2/milestone2/01_bench/tb_brc.sv

vsim -wlf "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/tb_brc.wlf" tb_brc

view wave
add wave -r tb_brc/*
log -r tb_brc/*

run -all

write list "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/tb_brc.wlt"
