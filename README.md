# H-modpack

H-modpack 为某服务器自用的整合包,H-modpack只是个临时的名字,以后随时有可能修改为其他名字.

在action 的打包.zip中有
- 以 -**client**.zip为后缀的文件为curse格式的mc整合包,理论上可以被多数主流mc启动器安装.
- 以 -**server**.zip为后缀的文件不清楚有什么用,顺手生成的.

安装了packwiz后可用使用下方的命令导出一个modrinth格式的整合包.  
目前是项目下目录运行的,打包了全部mod的文件,可能会出现未知问题.  
运行./build.sh后会删除build/dist中的文件,所有如果需要.mrpack请在运行./build.sh之前将modpack.mrpack移动到别处.

```shell
packwiz refresh --build
packwiz mr export -o build/dist/modpack.mrpack
packwiz refresh
```