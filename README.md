# H-modpack

H-modpack 为自用的整合包,H-modpack只是个临时的名字,以后随时会修改为其他名字.  
由于最近没有时间完mc所以只是一个草稿,不具备可玩性.  
整合包使用[packwiz](https://packwiz.infra.link/)管理以避免直接管理大量二进制文件  
可以使用`go install github.com/packwiz/packwiz@latest`.来安装packwiz.

推送到仓库后在 action 的打包.zip中有
- 以 -**client**.zip为后缀的文件为curse格式的mc整合包,理论上可以被多数主流mc启动器安装.后缀还有zh_cn的为专属简中的整合包.
- 以 -**server**.zip为后缀的文件不清楚有什么用,顺手生成的.

zh-cn/目录下是转为简中的文件,有i18n,jech,imb等优化操作体验的mod.  
安装packwiz后,在仓库运行 `./build.sh` 后会在build/dist/文件产出三个压缩包.两个客户端的,一个没什么用处的.