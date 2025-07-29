# 作業說明

本次作業分為實作與簡答兩部分。繳交時，實作部分只需要截圖表示；回答問題時，需簡要說明答案思路。最後，將兩部分合併為一份 PDF，上傳至 eeclass。

檔名格式請按照: `HW1_<學號>`。e.g. `HW1_113062595`。

## 實作

課程提供的 aes 專案位於目錄`~/aes`。aes 依賴於前面我們編譯完的 OP-TEE 專案，並且 aes/Makefile 需要設定 OP-TEE 的正確路徑，否則會無法編譯 aes 專案。
<img alt="image" src="https://github.com/user-attachments/assets/bb05310f-178e-4ff0-bbf5-d32b41fcebe4" />

aes 專案的結構如下：

- host/：CA 的目錄
    - Makefile：不能直接使用
    - main.c：CA 程式，需要同學修改
- ta/：TA 的目錄
    - Makefile：不能直接使用
    - aes_ta.c：TA 程式，需要同學修改
    - ...
- Makefile：生成或清除 aes 專案的目標檔案
- ...

### a. 實作目標
參考`ta/include/aes_ta.h`的檔案內容。e.g.  
<img alt="image" src="https://github.com/user-attachments/assets/b3070c56-31d8-4fea-bcce-e54cfdee0ba3" />

並完成`host/main.c`, `ta/aes_ta.c`中指定的TODO修改。

### b. 測試
程式修改完以後，可以在 qemu 內執行測試。首先使用生成目標檔案
```shell
# 在aes專案目錄下
$ make
```

然後將檔案放到 buildroot 對應的路徑

```shell
# 在aes專案目錄下
$ make install
```

重新執行 buildroot 的建置再啟動 qemu

```shell
# 在 optee/build/
$ make run
```

在Normal World中登入之後，應該就會出現下列指令可以使用來測試我們修改完的 aes 專案:
```shell
$ optee_example_aes
```

## 簡答
- 提供 `$ optee_example_aes` 的執行輸出的截圖。
- 說明 aes 實作部分，修改的程式目的是什麼？以及如何依據 `ta/include/aes_ta.h` 內容進行修改？
- 說明 aes CA 的程式流程，每個步驟是如何操作 TA？
- 參考 [api 文件](https://globalplatform.org/specs-library/tee-internal-core-api-specification/)，說明 aes TA 使用 key/operation handle 的時候，呼叫 api 的流程以及使用的參數。
- OP-TEE 支援 Value parameter, Memory reference 中哪些形式的參數？ TA_InvokeCommandEntryPoint 的 Value parameter 最多能傳入幾個 32-bit 的參數
