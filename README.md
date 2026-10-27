# H-modpack

H-modpack 为我的服务器自用的整合包,H-modpack只是个临时的名字,以后随时可能会修改为其他名字.

在action 的打包.zip中有
-client.zip 为curse整合包,理论上可以被多数主流mc启动器安装.
-server.zip 不清楚有什么用,顺手生成的.

安装了packwiz后可用使用下方的命令导出一个更大的包

```shell
packwiz refresh --build
packwiz mr export -o ./dist/modpack.mrpack
packwiz refresh
```