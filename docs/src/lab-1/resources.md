# 其它資源

- CA 和 TA 範例程式：位於 OP-TEE 專案 optee/optee_examples/
- TEE Client API：[DOC](https://globalplatform.org/specs-library/tee-client-api-specification/)
- TEE internal API：[DOC](https://globalplatform.org/specs-library/tee-internal-core-api-specification/)

## Troubleshooting
- 如果遇到問題想要重抓OPTEE的source code，可以執行下列指令重新抓取OPTEE:
```bash
#在家目錄/home/ubuntu下
repo init
repo sync -j4
rm -rf optee_examples/aes
```
- 完成後繼續按[教學](run-optee.md)的指示執行編譯系統的步驟即可。
