# 加密權重

為了防止模型資訊遭竊，部署在 TA 中的模型權重應先加密，並在載入至 TEE 時才進行解密。

## 權重加密步驟

darknetz專案的結構如下：

- host/：CA 的目錄
    - examples
        - classifier.c
        - ...
    - ...
- ta/：TA 的目錄
    - parser_TA.c
    - ...
- ...

#### 1. 將`parser_TA.c`檔案中的`load_weights_TA`呼叫`aes_cbc_TA`的部分註解掉

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

#### 2. 在`classifier.c`檔案中新增 function `convert_weights_to_TA`
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
#### 3. 使用 qemu 模擬 OP-TEE ，並開啟 Host-Guest folder sharing
[Host-Guest folder sharing](https://optee.readthedocs.io/en/latest/building/devices/qemu.html#host-guest-folder-sharing)
```sh
cd ~/optee/build
make QEMU_VIRTFS_ENABLE=y QEMU_USERNET_ENABLE=y run
```
```sh
# In normal world
buildroot login: root
mkdir -p /mnt/host
mount -t 9p -o trans=virtio host /mnt/host
```

#### 4. 執行權重加密

`pp_start`和`pp_end`分別表示開始及結束放入TA的層
```sh
darknetp classifier move -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet.weights
```

#### 5. 將轉換好的權重保存到適當的位子

```sh
cp models/mnist/mnist_lenet_ta.weights mnt/host/out-br/target/root/models/mnist
```

#### 6. 將`parser_TA.c`檔案的`load_weights_TA`中的`aes_cbc_TA`註解取消

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
#### 7. 重新啟動 qemu 運行 OP-TEE

```
cd ~/optee/build
make run
```
```sh
# In normal world
buildroot login: root
```

#### 8. 執行推論
```
darknetp classifier predict -pp_start 0 -pp_end 10 cfg/mnist.dataset cfg/mnist_lenet.cfg models/mnist/mnist_lenet_ta.weights  data/mnist/images/t_00007_c3.png
```