### 1. 日常開發：管理你的硬體邏輯變更

* **`git add <file>`**：將修改後的 RTL、Cocotb 腳本或軟體程式碼加入暫存區。
* **時機**：完成一個子模組（如 ALU 中的加法器）或修復一個測試報錯（Bug fix）時。


* **`git commit -m "feat(rtl): <message>"`**：提交變更並撰寫具意義的訊息。
* **時機**：當該階段的小功能通過基礎模擬驗證時。
* **專業範例**：`git commit -m "feat(rtl): add 5-stage pipeline hazard detection logic"`。
訊息格式：
feat: (新功能), fix: (修復 Bug), docs: (文件更新) 等前綴

* **`git status`**：檢查哪些檔案被修改但尚未提交。
* **時機**：隨時使用，確保沒有誤加暫存檔（如 `.vcd` 波形檔）進入版本庫。



### 2. 分支管理：實驗不同的硬體架構

你的專案包含從 Gen 1 到 Gen 3 的 CPU 演進，利用分支可以讓你安全地進行架構實驗。

* **`git checkout -b <branch_name>`**：建立並切換到新分支。
* **時機**：準備開發新階段功能時。例如從 **Phase 2** 進入 **Phase 3** 手刻 CPU 時，建議開一個 `feat-riscv-cpu` 分支。


* **`git merge <branch_name>`**：將完成的功能合併回 `main` 分支。
* **時機**：當整個 Phase（如 Phase 4 的 DMA 控制器）開發完畢且 Cocotb 測試全數通過時。


* **`git branch -d <branch_name>`**：刪除已合併的分支。
* **時機**：功能穩定合併後，保持專案整潔。



### 3. 里程碑管理：標記專案階段 (Phase 0-7)

這是你 README 中規劃的學習路徑，使用 Tag 能幫助你未來進行效能對比（Benchmark）。

* **`git tag -a v<number> -m "<description>"`**：建立帶註釋的標籤。
* **時機**：完成 README 中定義的里程碑。例如完成 **Phase 6** 的 Vivado 實體合成並取得 PPA 數據後，打上 `v0.6-vivado-ppa`。


* **`git checkout v<number>`**：切換到特定的里程碑版本。
* **時機**：在 **Phase 7** 進行「總結算」時，你需要頻繁切換回舊版本來跑同一個 Benchmark 程式以產出對比圖表。



### 4. 協作與備份

* **`git push origin <branch_name>`**：將本地進度推送到 GitHub。
* **時機**：每日結束開發或完成重要里程碑時。


* **`git pull`**：更新遠端變更。
* **時機**：如果你在不同電腦（如學校工作站與個人筆電）間切換開發時。



---

### 工程師的進階提示：使用 `.gitignore`

在開始第一個 `git add` 之前，請務必在專案根目錄建立 `.gitignore` 檔案。你的計畫中涉及大量模擬與合成工具，這些工具產生的中間產物會污染你的 Git 歷史：

```bash
# 建議加入 .gitignore 的項目
obj_dir/          # Verilator 輸出
*.vcd             # 波形檔
*.log             # 模擬日誌
*.jou             # Vivado 紀錄
*.pb              # Vivado 檔案
sw/*.elf          # 編譯後的韌體執行檔

```

你想先從哪個階段開始實行這些 Git 流程？建議可以先為 **Phase 0** 的基礎建設打下第一個 Commit。