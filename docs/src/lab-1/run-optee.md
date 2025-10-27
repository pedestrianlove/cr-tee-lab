# 執行OP-TEE系統

課程提供的 OP-TEE 專案位於目錄 optee/，先建置需要的目標檔案

```bash
$ cd ~/optee/build
$ make toolchains -j$(nproc)
$ make -j$(nproc)
```

- 可能會跑一段時間，經過測試4核心的CPU大約需要1小時左右。

專案建置完成後，可以啟動 qemu 運行 OP-TEE

```shell
# 在 ~/optee/build/
$ make run-only
```

如果要新增檔案到虛擬機的檔案系統，需要重新執行 buildroot 的建置再啟動 qemu，命令則要改成：

```shell
# 在 ~/optee/build/
$ make run
```

接著，輸入 `make` 的終端會進入 qemu 的 CLI，並且會生成兩個新的終端機，分別是安全世界（Secure World）和正常世界（Normal World）。qemu CLI 會輸出提示等待用戶反應，用戶輸入 c 後，其他的終端會開始輸出 OP-TEE 開機過程的日誌

```shell
(qemu) c
```

接著在正常世界的終端，可以輸入登入的使用者。完成登入後，就可以執行 OP-TEE 專案包含的測試和範例

```shell
# 測試
$ xtest
```

```shell
# 範例
$ optee_example_hello_world
```

## Troubleshooting
- OP-TEE專案所引用的其中一個repo有dependency的[問題](https://github.com/apache/teaclave-trustzone-sdk/issues/240)，可能會導致在重新編譯時會出現錯誤訊息。
- 由於我們有更新了optee專案的抓取來源，因此可以透過以下方式解決這個問題:
    - 1. [下載](https://github.com/NTHU-SCOPELAB/cr-tee-lab/releases/latest)最新的VM映像檔並重新建立開發環境
    - 2. 或是透過以下指令重新抓取OPTEE的source code
        ```bash
        #在optee目錄~/optee下
        rm -rf ~/optee/.repo
        repo init -u https://github.com/NTHU-SCOPELAB/cr-tee-manifest.git -m qemu_v8.xml
        repo sync ~/optee/optee_rust
        ```
- 完成後繼續按[教學](run-optee.md)的指示執行編譯系統的步驟即可。
