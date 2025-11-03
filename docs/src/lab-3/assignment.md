# 作業說明

本次作業分為實作與簡答兩部分。繳交時，實作部分只需要截圖表示；回答問題時，需簡要說明答案思路。最後，將兩部分合併為一份 PDF，上傳至 eeclass。

檔名格式請按照: `HW3_<學號>`。e.g. `HW3_113062595`。

## 題目
### DarkneTZ 實作
- 按照[建置 DarkneTZ](build-darknetz.md) 與[加密權重](encrypt-weights.md)的說明，分別在 REE 和 TEE 執行模型的推論，提供下面兩個命令的輸出截圖。

```
darknetp classifier predict cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet.weights  data/mnist/images/t_00007_c3.png
```
```
darknetp classifier predict -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet_ta.weights  data/mnist/images/t_00007_c3.png
```

> 提示：參考截圖的輸出結果，檢查實作是否正確  
> REE
> [![jie-tu-2025-11-02-xia-wu6-28-33.png](https://i.postimg.cc/63m7t3tx/jie-tu-2025-11-02-xia-wu6-28-33.png)](https://postimg.cc/Q9cNqjFf)
> TEE
> [![jie-tu-2025-11-02-xia-wu6-28-46.png](https://i.postimg.cc/4yHYdgx3/jie-tu-2025-11-02-xia-wu6-28-46.png)](https://postimg.cc/V01fG2My)

### 單選題

根據 DarkneTZ [論文](https://dl.acm.org/doi/abs/10.1145/3386901.3388946)，回答以下問題。

1. DarkneTZ 框架旨在邊緣設備上主要防禦哪一種利用模型洩露訓練數據資訊的攻擊？

    1. GAN 攻擊 (GAN Attacks) 
    1. 模型逆向工程攻擊 (Model Inversion Attacks) 
    1. 白盒模型成員推論攻擊 (Membership Inference Attacks, MIAs) 
    1. 黑盒模型成員推論攻擊 (Membership Inference Attacks, MIAs)

1. 考慮到邊緣 TEE (如 Arm TrustZone) 有限的記憶體，DarkneTZ 如何設計其模型執行策略以容納大型 DNN 模型？

    1. 將模型分為敏感層與非敏感層，僅將敏感層執行於 TEE 中，非敏感層執行於 REE。 
    1. 採用剪枝和量化這些模型壓縮的技術來減少運行時的內存佔用。 
    1. 使用硬體加速器（如 GPU）來分擔 TEE 的計算負載與記憶體壓力。 
    1. 在 TEE 內實現分頁機制（Paging）以動態載入模型層次。

1. 根據論文，為了有效抵抗 MIA，DarkneTZ 優先保護 DNN 的哪一類層次？請指出其原因。

    1. 所有非線性激活函數層，因為這些函數容易被逆向工程攻擊。 
    1. 網路的『第一層』，因為它們學習了關於輸入數據的通用但敏感的特徵。 
    1. 所有非線性層，因為線性層必須使用 REE 的加速器進行計算。 
    1. 網路的『最後一層』（輸出層），因為它們包含關於訓練數據的最高成員推論資訊。

1. 根據 DarkneTZ 的性能評估結果，僅保護『單一最關鍵層次』時，CPU 執行時間的額外性能開銷約為多少？

    1. 超過 50% 
    1. 幾乎沒有開銷（小於 1%） 
    1. 約 3% 
    1. 約 10%

### 簡答題

1. 根據論文，雲端 TEE 解決方案（如 Intel SGX）與邊緣 TEE（如 Arm TrustZone）相比，存在哪三個主要的『環境差異』，使得雲端方案難以直接應用於邊緣設備？

1. DarkneTZ 透過控制輸出資訊來防禦 MIA，除此之外，這項 TEE 隔離機制還能夠針對哪幾類型的攻擊提供額外的防護？

### 加分題

為鼓勵同學深入探討相關領域，並累積實作經驗，以「DarkneTZ 實作」題目為範例，提供下列幾個研究方向。建議同學參考相關論文或教學資源，重現前人提出的解決方案。在加分題的報告中，你只要簡單地介紹你採取的方案，然後著重在說明重現或部署的流程。

- 重現 DarkneTZ 論文中的實驗，測量在 TEE 環境下運行模型時的 CPU 執行時間、記憶體使用量，以及處理器功耗。
- 在利用 TEE 保護模型機密性的前提下，如何引入加速器（如 GPU 或專用硬體）來降低訓練與推論過程的時間成本？
- 將模型移植至 TEE 系統的常見方法包括：切割並僅保護模型的部分層級、壓縮模型以減少資源需求、擴充 TEE 功能以支援原生模型運行。除了 DarkneTZ 的方案，還有什麼移植模型的方法？
- 目前還有許多成熟 TEE 方案，如 Android pKVM、Linux CVM（包含 Intel TDX 與 AMD SEV），廠商也有公開釋出相關的 emulator 軟體，供開發者測試、使用。如何將模型部署至 OP-TEE 以外的這些系統中？
