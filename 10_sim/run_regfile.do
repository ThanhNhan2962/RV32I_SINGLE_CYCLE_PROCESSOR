# ==========================================
# ModelSim DO file - Run simulation for tb_regfile
# ==========================================

# Ghi log console
transcript file "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/sim_log.txt"

# Tạo thư viện work
if [file exists work] {
    vdel -all
}
vlib work
vmap work work

# Biên dịch mô-đun DUT và testbench
vlog D:/CTMT/Milestones/Milestone_2/milestone2/00_src/regfile.sv
vlog D:/CTMT/Milestones/Milestone_2/milestone2/01_bench/tb_regfile.sv

# Khởi chạy mô phỏng và ghi waveform
vsim -voptargs=+acc -wlf "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/tb_regfile.wlf" work.tb_regfile

# Mở cửa sổ waveform
view wave

# Thêm tín hiệu testbench vào waveform
add wave tb_regfile.clk
add wave tb_regfile.reset
add wave tb_regfile.rd_addr
add wave tb_regfile.rd_data
add wave tb_regfile.rd_wren
add wave tb_regfile.rs1_addr
add wave tb_regfile.rs2_addr
add wave tb_regfile.rs1_data
add wave tb_regfile.rs2_data

# Ghi lại các tín hiệu để xuất waveform
log tb_regfile.clk
log tb_regfile.reset
log tb_regfile.rd_addr
log tb_regfile.rd_data
log tb_regfile.rd_wren
log tb_regfile.rs1_addr
log tb_regfile.rs2_addr
log tb_regfile.rs1_data
log tb_regfile.rs2_data

# Chạy mô phỏng
run -all

# Ghi danh sách waveform
write list "D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/tb_regfile.wlt"
