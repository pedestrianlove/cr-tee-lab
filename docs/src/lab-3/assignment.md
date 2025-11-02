# 作業說明

本次作業分為實作與簡答兩部分。繳交時，實作部分只需要截圖表示；回答問題時，需簡要說明答案思路。最後，將兩部分合併為一份 PDF，上傳至 eeclass。

檔名格式請按照: `HW3_<學號>`。e.g. `HW3_113062595`。

## 實作
按照[建置DarkbeTZ](build-darknetz.md)與[加密權重](encrypt-weights.md)的說明，產生在TA跑的模型所用的權重。

## 簡答
- 提供下面兩個命令的輸出截圖
```
darknetp classifier predict cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet.weights  data/mnist/images/t_00007_c3.png
```
```
darknetp classifier predict -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet_ta.weights  data/mnist/images/t_00007_c3.png
```