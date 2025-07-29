# 作業說明

本次作業分為實作與簡答兩部分。繳交時，實作部分只需要截圖表示；回答問題時，需簡要說明答案思路。最後，將兩部分合併為一份 PDF，上傳至 eeclass。

檔名格式請按照: `HW2_<學號>`。e.g. `HW2_113062595`。

## 實作

aes 專案的結構如下：

- host/：CA 的目錄
    - ...
- ta/：TA 的目錄
    - include/
        - aes_ta.h：修改 TA_AES_UUID
    - Makefile：修改 BINARY
    - ...
- ...

使用下方的 UUID 修改 LAB 1 的 aes 專案

```
aed564f1-960e-4117-8bb4-417b4e79c130

#define TA_UUID
    { 0xaed564f1, 0x960e, 0x4117, \
        { 0x8b, 0xb4, 0x41, 0x7b, 0x4e, 0x79, 0xc1, 0x30} }

```

根據[簽署操作流程](ta-signing.md)生成 `.ta`。私鑰使用 default_ta.pem，因此「編譯 OP-TEE OS」的步驟可以跳過。

## 簡答
- 提供簽署過程的截圖，包含所有終端執行的命令，以及 sign_encrypt.py 兩個命令的輸出。

    ```shell
    $ sign_encrypt.py display --in <.ta>
    $ sign_encrypt.py verify --uuid <uuid> --in <.ta> --key <default_ta.pem>
    ```

- 參考文件 [1](https://optee.readthedocs.io/en/latest/architecture/trusted_applications.html#verifying-with-subkeys)、[2](https://optee.readthedocs.io/en/latest/architecture/subkeys.html#subkeys)，說明 subkeys 機制、流程。

參考[客戶 api](https://globalplatform.org/specs-library/tee-client-api-specification/)第三章底下的相關章節，回答以下問題：

- CA 與 TA 使用的共享記憶體屬於安全記憶體還是非安全記憶體？
- 共享記憶體區塊是否可以在多個會話（Sessions）中重複使用？
- TEEC_AllocateSharedMemory、TEEC_RegisterSharedMemory 和 TEEC_TempMemoryReference 三種記憶體，可以實現 zero-copy 的機會從高到低排序是？
