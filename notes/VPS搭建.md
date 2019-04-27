### MacOS下操作

**ssh终端连接服务器**

ssh 用户名@ip

不用此方法，可以使用ssh连接软件

**安装ss**

```shell
wget --no -check -certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
chmod + xshadowsocks.sh
./shadowsocks.sh 2>&1 | tee shadowsocks.log
```

**配置多用户**

```shell
# 查看是否存在文件
cat /etc/shadowsocks.json

vi /etc/shadowsocks.json
# 点击i键进行编辑
{
"server":"0.0.0.0",
"local_address":"127.0.0.1",
"local_port":1080,
"port_password":{
"443":"pwd000",
"9001":"pwd123",
"9002":"pwd234",
"9003":"pwd345",
"9004":"pwd456"                    
},
"timeout":300,
"method":"aes-256-cfb",
"fast_open": false
}
// 编辑完毕后，点击esc键，再输入:wq保存
```

**开放端口**

```shell
# 查看已开放端口
firewall -cmd --list-ports
# 开启端口 以开启8388端口为例
firewall -cmd --zone=public --add -port=8388/tcp --permanent
# 重启防火墙
firewall -cmd --reload
```

**重启ss**

```shell
ssserver -/c etc/shadowsocks.json -d restart
```

**使用BBR加速**

```shell
wget –no -check -certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod +x bbr.sh
./bbr.sh
```





