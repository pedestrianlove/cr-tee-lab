# 建置DarkneTZ

## DarkneTZ介紹
[DarkneTZ](https://github.com/mofanv/darknetz/blob/master/README.md)是一個在 TrustZone 中執行DNN模型的應用程式。

## 建置步驟
#### 1.複製程式碼與資料集

```bash
git clone https://github.com/NTHU-SCOPELAB/cr-tee-darknetz.git
git clone https://github.com/NTHU-SCOPELAB/cr-tee-darknetz-dataset.git
```

#### 2.將程式碼放到example資料夾下
`$PATH_darknetz$`為`cr-tee-darknetz`所在的路徑

```bash
mkdir ~/optee/optee_examples/darknetz
cp -a $PATH_darknetz$/. ~/optee/optee_examples/darknetz/
```

#### 3.將datasets放到root下

`$PATH_tz_datasets$`為`cr-tee-darknetz-dataset`所在的路徑
```bash
cp -a $PATH_tz_datasets$/. ~/optee/out-br/target/root/
```

#### 4.測試
```bash
cd ~/optee/build
make run
```
```bash
#In Normal World
buildroot login: root
darknetp
```
如果執行結果像下面這樣表示建置成功
```bash
# usage: ./darknetp <function>
```
