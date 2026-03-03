# Side-Project-System-Design


## Phase 0: 現代驗證基礎設施建置 (Verification & Infrastructure)

在寫任何一行硬體之前，我們先把測試環境架好。

* **環境配置**：WSL Ubuntu + VS Code + Verilator + GTKWave。
* **現代驗證導入 (Verification)**：除了 Verilog Testbench，導入 **Cocotb (Coroutine based co-simulation testbench)**。這是一個用 Python 寫硬體驗證的框架。
* **Python 數據擷取**：我們將在 Cocotb 中寫 Python 腳本，即時抓取模擬過程中的 Cycle 數、匯流排佔用率，並用 Matplotlib 直接畫出 Dataflow 與 Latency 圖表，不需要等到 Vivado 合成就能看到硬體效能！

## Phase 1: 架構探索與指令集模擬 (Architecture Exploration)


* **Spike / QEMU 模擬實驗**：
1. 寫一支 C 語言矩陣加法/乘法程式。
2. 用 RISC-V GCC 編譯，跑在 Spike 模擬器上，測量 Baseline 的 **Instruction Count (指令總數)**。


* **自定義指令效益評估**：
1. 修改 Spike 模擬器的 C++ 原始碼，加入你的「自定義矩陣指令 (Custom ISA)」。
2. 修改 C 語言程式，嵌入 Inline Assembly 呼叫新指令。
3. **量化對比**：比較純 C 語言 vs. 自定義指令的指令數差異、動態執行軌跡 (Dynamic Execution Trace)，評估加速潛力。


* **Python 系統效能建模 (Performance Modeling)**：在寫 RTL 之前，用 Python 寫一個簡單的腳本，輸入記憶體頻寬 (Bandwidth) 與運算單元數量，畫出 **Roofline Model (屋頂線模型)**，找出系統的理論極限是 Compute-bound 還是 Memory-bound。

## Phase 2: IC Design 基礎與通訊協定 (RTL Basics)

開始手刻底層積木，並用 Python 測量通訊開銷。

* **模組實作**：Valid/Ready 握手協定、Synchronous FIFO。
* **匯流排實作**：AMBA APB、AMBA AXI4-Lite。
* **Python Dataflow 模擬**：用 Cocotb 灌入隨機的讀寫請求 (Random Traffic Generation)，利用 Python 測量並繪製 AXI 匯流排在不同 FIFO 深度下的 **吞吐量 (Throughput)** 與 **擁塞延遲 (Congestion Latency)**。

## Phase 3: RISC-V 處理器核心手刻 (CPU Evolution)

將 Phase 1 在 Spike 模擬出的架構，化為真實的硬體電路。

* **Gen 1 (多週期)**：實作 RV32I，包含 Memory-Mapped I/O (MMIO)。
* **Gen 2 (管線化)**：5-Stage Pipeline (IF, ID, EX, MEM, WB)、Data Forwarding、Hazard Unit。
* **Gen 3 (硬體自訂指令)**：將 Phase 1 驗證過有效的擴充指令，真正在 ALU 與 Decode 階段實作出來。
* **記憶體階層**：實作 Direct-Mapped Cache 與 Set-Associative Cache。

## Phase 4: 異質加速器與資料搬移 (Accelerator & DMA)



* **手刻矩陣加速器 (Accelerator)**：實作 Systolic Array 或簡化版 Vector Unit (SIMD)。
* **手刻 DMA 控制器 (Direct Memory Access)**：**【核心關鍵】** 實作一個能擔任 AXI Master 的 DMA 引擎。讓它可以在 CPU 休眠或做其他事的時候，自動把 SRAM 的矩陣資料狂塞給加速器。
* **模擬量化**：用 Cocotb (Python) 測量「CPU Polling (輪詢) 搬資料」與「DMA 搬資料」時，AXI 匯流排的佔用率對比，量化 DMA 帶來的頻寬解放。
* **TinyGPU design**
## Phase 5: 系統整合與軟硬體協同優化 (System Co-Design Optimization)

把所有東西串進同一個 AXI Interconnect，並開始「榨乾」系統效能。

* **System Integration**：RISC-V CPU + Cache + DMA + Accelerator + SRAM + UART。
* **System Co-Design Optimization (軟硬體協同優化)**：
    * **軟體端**：優化 C 語言的 Memory Alignment (記憶體對齊)、Loop Unrolling (迴圈展開)。
    * **硬體端**：調整 DMA 的 Burst Size (突發傳輸大小)、加速器的 Double Buffering (雙緩衝區，掩蓋通訊延遲)。


* **Python 系統級 Profiling**：透過 Cocotb 監控整個 SoC，繪製 CPU、DMA、Accelerator 在時間軸上的甘特圖 (Gantt Chart)，找出誰在等誰，並進行優化。

## Phase 6: 實體合成與精確 PPA 量化 (Vivado Implementation)

將優化後的 RTL 程式碼送入 Vivado，獲取業界標準的硬體報告。

* **Performance**：解析 Timing Report，測量最高運作頻率 (Fmax) 與 Critical Path。
* **Area**：解析 Utilization Report，量化 CPU、DMA、Cache、Accelerator 各自佔用的 LUTs / Flip-Flops / DSP 比例。
* **Power**：將 Verilator/Vivado 模擬產生的真實訊號翻轉率 (SAIF 檔) 餵給 Power Analyzer，取得極度精確的動態與靜態功耗數據 (mW)。

## Phase 7: Benchmark 總結算 (The Grand Finale)

在你的開發環境中，跑同一支 C 語言應用程式 (例如矩陣運算或簡單神經網路)，產出最終的對比圖表：

1. **純軟體 (Baseline)**：跑在基礎 RV32I 上的執行時間與能耗。
2. **管線化與快取 (Microarchitecture)**：加入 Pipeline 與 Cache 後的加速比。
3. **擴充指令 (Custom ISA)**：使用自定義指令的指令數減少與效能提升。
4. **異質卸載 (Co-Design)**：CPU + DMA + Accelerator 全力運轉的終極吞吐量與 Energy per MAC (每次乘加運算消耗的能量)。


