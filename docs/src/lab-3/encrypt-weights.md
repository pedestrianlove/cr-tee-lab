# 加密權重

為了防止模型資訊遭竊，部署在 TA 中的模型權重應先加密，並在載入至 TEE 時才進行解密。cr-tee-darknetz-dataset 底下提供未加密的權重 models/mnist/mnist_lenet_ta.weights，如果想再 TEE 裏面執行模型，需要使用加密過的 .weight 檔。

權重處理的正常流程如下：TA 接收權重 → 解密權重 → 運行模型 → 加密權重 → 發送權重。底下是加密權重的間接方法，首先將未加密的權重直接傳送給 TA。同時，我們註解用於解密權重的 `load_weight_TA` 程式碼。然後省略「運行模型」的步驟，TA 直接對權重加密，將加密後的權重發送回 CA 保存在 models/mnist/mnist_lenet_ta.weights。

## 權重加密步驟

cr-tee-darknetz專案的結構如下：

- host/：CA 的目錄
    - examples
        - classifier.c
        - ...
    - ...
- ta/：TA 的目錄
    - parser_TA.c
    - ...
- ...

#### 1. cr-tee-darknetz 程式碼新增和修改

將`parser_TA.c`檔案中的`load_weights_TA`呼叫`aes_cbc_TA`的部分註解掉

```C
void load_weights_TA(float *vec, int length, int layer_i, char type, int transpose)
{
    /*
        ...
    */
    //aes_cbc_TA("decrypt", tempvec, length);
    /*
        ...
    */
}
```

在`classifier.c`檔案中新增 function `convert_weights_to_TA`，發送、接收權重並且保存加密後的 .weight 檔

```C
void convert_weights_to_TA(char* datacfg, char *cfgfile, char *weightfile, int *gpus, int ngpus, int clear)
{
        int i;
        char *base = basecfg(cfgfile);
        network **nets = calloc(ngpus, sizeof(network*));

        int seed = rand();
        // load network into GPU(s)
        for(i = 0; i < ngpus; ++i) {
                srand(seed);
#ifdef GPU
        cuda_set_device(gpus[i]);
#endif
        nets[i] = load_network(cfgfile, weightfile, clear);
        }

        network *net = nets[0];
        char buff[256];
        sprintf(buff, "models/mnist/%s_ta.weights", base);
        save_weights(net, buff);
        free_network(net);
        free(base);
}
```
在 function `run_classifier`中新增呼叫`convert_weights_to_TA`的程式
```C
void run_classifier(int argc, char **argv)
{
    /*
		...
    */
    // 新增
    else if(0==strcmp(argv[2], "move")) convert_weights_to_TA(data, cfg, weights, gpus, ngpus, clear);
}
```

#### 2. 啟用 QEMU 模擬 OP-TEE ，並開啟 Host-Guest folder sharing

因為 qemu 沒有啟用硬碟，Normal World 新增的 .weights 檔案重開機後就會喪失，所以要用 
[Host-Guest folder sharing](https://optee.readthedocs.io/en/latest/building/devices/qemu.html#host-guest-folder-sharing) 保存到宿主的目錄。

`make run` 加入底下參數，新增名為 host 的共享裝置到客戶機，對應宿主機的 ~/optee 目錄

```sh
cd ~/optee/build
make QEMU_VIRTFS_ENABLE=y QEMU_USERNET_ENABLE=y run
```

使用 `mount` 掛載裝置到客戶的 /mnt/host 目錄

```sh
# In normal world
buildroot login: root
mkdir -p /mnt/host
mount -t 9p -o trans=virtio host /mnt/host
```

#### 3. 執行 CA 進行權重加密

`pp_start`和`pp_end`分別表示開始及結束放入TA的層
```sh
darknetp classifier move -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet.weights
```

#### 4. 將加密的權重檔複製到宿主的目錄

保存在 /mnt/host/out-br/target/root/ 底下，就是對應宿主中用來存放 REE rootfs 的目錄 ~/optee/out-br/target/root/

```sh
cp models/mnist/mnist_lenet_ta.weights /mnt/host/out-br/target/root/models/mnist
```

#### 6. 還原 cr-tee-darknetz 程式碼修改
將`parser_TA.c`檔案的`load_weights_TA`中的`aes_cbc_TA`註解取消

```C
void load_weights_TA(float *vec, int length, int layer_i, char type, int transpose)
{
    /*
        ...
    */
    aes_cbc_TA("decrypt", tempvec, length);
    /*
        ...
    */
}
```
#### 7. 使用加密權重在 TEE 中執行推論

重新啟動 qemu 運行 OP-TEE

```
cd ~/optee/build
make run
```

執行 CA 進行推論

```
# In normal world
$ buildroot login: root
$ darknetp classifier predict -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet_ta.weights  data/mnist/images/t_00007_c3.png
```