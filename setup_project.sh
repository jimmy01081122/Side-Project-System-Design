#!/bin/bash

# 建立基礎目錄結構
mkdir -p docs
mkdir -p hw/rtl/core
mkdir -p hw/rtl/accel
mkdir -p hw/rtl/bus
mkdir -p hw/rtl/mem
mkdir -p hw/ip
mkdir -p sim/cocotb
mkdir -p sim/tb_verilog
mkdir -p sim/waveforms
mkdir -p sw/benchmark
mkdir -p sw/common
mkdir -p sw/tools
mkdir -p scripts
mkdir -p syn

# 建立根目錄 .gitignore
cat <<EOF > .gitignore
# Build and Simulation Artifacts
obj_dir/
*.vcd
*.ghw
*.fst
*.log
*.jou
*.pb
*.str

# Software Binaries
sw/**/*.elf
sw/**/*.bin
sw/**/*.obj

# OS generated files
.DS_Store
EOF

# 在關鍵目錄添加說明文件
echo "# Project Documentation" > docs/README.md
echo "存放架構設計圖、規格書與 Phase 1 的 Roofline Model 報告。" >> docs/README.md

cat <<EOF > hw/rtl/README.md
# RTL Design Root
- **core/**: RISC-V CPU 核心演進 (Gen 1~3)。
- **accel/**: 矩陣加速器與 TinyGPU 設計。
- **bus/**: AXI4-Lite / APB 匯流排實作。
- **mem/**: Cache 階層與 FIFO 模組。
EOF

cat <<EOF > sim/cocotb/README.md
# Cocotb Verification Environment
存放 Python 測試腳本。建議每個硬體模組建立一個子資料夾存放對應的 \`testbench.py\` 與 \`Makefile\`。
EOF

cat <<EOF > sw/README.md
# Software and Benchmarks
- **benchmark/**: 存放矩陣運算等 C 語言測試程式。
- **common/**: 存放 Linker Script 與啟動碼。
- **tools/**: 存放修改後的 Spike 模擬器原始碼。
EOF

echo "專案結構已創建完成！"