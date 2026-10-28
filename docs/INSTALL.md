# 环境部署

## 本地部署

> 将本项目复制到本地任意目录,需要用vscode打开

> `core` 是独立的 submodule,克隆时使用 `git clone --recurse-submodules`,或在克隆后运行 `git submodule update --init`。
> 首次使用请在项目根目录运行 `./init.sh`(Windows 可用 PowerShell 运行 `./init.ps1`),它会从 `core/scaffold` 生成 `lib.typ`、`config.typ`、`typst.toml`、`.vscode`、`tests`、`projects/example` 等文件;已存在的文件会**跳过**,不会覆盖你的修改。

1. `vscode`打开本项目目录,下载`Tinymist插件`

    [TinyMist地址](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist)

    `Tinymist`会自动下载`typst`

<a id="fonts"></a>

2. 准备必要字体 


    至少要安装下面这些字体,常规字体必须安装,粗体字体尽量安装,其它样式字体按需要安装
    ```
    "Source Han Serif SC",
    "Source Han Sans SC"
    "KaiTi"
    "FangSong"
    "Microsoft YaHei"
    "Libertinus Serif"
    "Fira Code"
    "DejaVu Sans Mono"
    ```
    字体来源
    - [思源宋体](https://source.typekit.com/source-han-serif/cn/)
    - [思源黑体](https://github.com/adobe-fonts/source-han-sans/)
    - [Fira Code](https://github.com/tonsky/FiraCode)
    - 楷体,仿宋,微软雅黑,Libertinus Serif,DejaVu Sans Mono windows系统字体 -> C:/windows/fonts

3. 安装字体

    > 字体安装windows系统可以直接双击打开安装,也可以放在一个目录下通过`Tinymist`插件配置自动识别

    - 系统全局安装,按照对应系统安装即可
    - `Tinymist`配置安装

        将字体文件位置添加到`vscode`的配置中,可以按照项目设置不同配置
        ```json
        "tinymist.fontPaths": [
            "./fonts"
        ],
        ```

   
4. 打开 `./tests/base.typ` 文件预览验证是否成功

    `Tinymist`插件安装后`.typ`文件打开后右上角会有`导出pdf`与`侧边栏预览`等按钮,
    首次渲染打开`typst`会下载一些必要第三方依赖包,可能会比较慢

    如果报错,请检查字体是否安装成功,
    使用`Tinymis`的`tool`工具中的`Fonts`验证识别到的字体


## 服务器部署

> 服务器操作手册是以`RedHat`系统写的,Linux系统应该都一致,
> windows系统环境变量和字体安装不同,需要调整

1. `typst`安装

    - 下载二进制文件

        [`typst`](https://github.com/typst/typst/releases)是一个开源的软件,由`rust`开发,提供了不同系统的二进制文件,
        你也可以通过`rustup`从源码重新编译

        选择合适你系统的版本,我这里使用的是`typst-x86_64-unknown-linux-musl.tar.xz`版本文件,
        写这篇文章时候typst版本是 `0.15.1` 

        下载后的文件是一个压缩包,其内有一个`typst`二进制文件,和其它的三个说明手册,授权文件,我们使用时只需要二进制文件

    - 将`typst`(windows文件是`typst.exe`)文件复制到服务器中,并加入到环境变量中

        服务器中的目录可以任意目录,在shell配置文件(`.bashrc`,`.zshrc`..)中将该目录加入到`$PATH`中
        (`TIPTOP`环境中shell配置文件为`$TOP/bin/tiptop_env`)

        在最后一行加入 `export PATH=$PATH:<二进制文件所在目录>`

    - 验证安装是否完成

        安装后,重新登录,运行`typst --version`应该输出类似`typst 0.15.1 (9dfd3a08)`的版本信息

2. 字体安装
    > 字体安装可以全局安装,也可以用户级别安装,我这里只用单一用户,所以用户级别安装即可,也不需要root权限.

    > 如果多用户需要用root权限全局安装

    - 准备字体

        [参考本地部署中的字体准备](#fonts)

    - 安装字体

        将字体文件放到用户目录下的`fonts`目录,如果没有需要创建

        运行命令`fc-cache -fv`筛选字体缓存

    - 验证是否安装完成

        运行命令`fc-list|grep 'Source Han Sans'`验证是否安装成功

3. 项目上传

    在本地项目根目录要直接运行scp命令上传到远程服务器,此命令会上传`.git`,`.vscode`等生产环境不需要的文件,
    首次上传只要上传一次,上传后再删除即可,或者你可以使用其它方式按需上传

    `scp -r ./ <用户名>@<服务器IP>:<项目根目录>`

    例如:`scp -r ./ user@host:~/typst`

4. 第三包安装

    > 如果你的服务器允许连接外网,可以跳过此步.
    
    > 第三方包由`typst`自动下载,如果网络不通,会下载失败,需要你从本地将第三方包复制到生产环境

    - 找到本地目录

        - windows -> `C:\Users\<你的用户名>\AppData\Local\typst`
        - linux -> `~/.cache/typst`

    - 上传到服务器目录

        切换到本地第三方包目录后,运行此命令上传到远程服务器中

        `scp -r ./ <用户名>@<服务器IP>:~/.cache/typst/`

        用其它方式上传也是可以的,注意目录结构一致

5. 验证

    在服务器根目录下运行以下命令

    `typst compile --root ./ --font-path ./core/fonts ./tests/base.typ`

    没有报错的话,会在同目录生成 `base.pdf`,查看这个pdf内容是否正确

6. 后续同步
   
    > 如果你有自己的同步方式,跳过此步,可以开始开发了,这里介绍一个windows同步到linux的工具rsync

    当本地同步到远程的时候,有时候只希望同步有修改过的文件,但是修改又不止一个文件,可以使用`rsync`来自定义同步

    `rsync`是一个linux工具,windows是不支持的,但是通过`git bash`和转义版本的`rsync.exe`文件,可以实现windows使用`rsync`.

    - 将二进制文件复制到`git bash`用户目录

        下载 [attachment/msys-xxhash-0.dll,attachment/rsync.exe](https://repo.msys2.org/msys/x86_64/?spm=5176.28103460.0.0.39f22988wxR4nV)
        放到`git bash`的用户目录下
        `<Git安装目录>\usr\bin`

    - `git bash` 中验证`rsycn`

        运行`rsync --version`验证是否正常使用
        会出现这样的信息
        ```bash
        rsync  version 3.3.0  protocol version 31
        Copyright (C) 1996-2024 by Andrew Tridgell, Wayne Davison, and others.
        Web site: https://rsync.samba.org/
        Capabilities:
            64-bit files, 64-bit inums, 64-bit timestamps, 64-bit long ints,
            socketpairs, symlinks, symtimes, hardlinks, no hardlink-specials,
            no hardlink-symlinks, IPv6, atimes, batchfiles, inplace, append, ACLs,
            xattrs, optional secluded-args, iconv, prealloc, stop-at, crtimes
        Optimizations:
            no SIMD-roll, no asm-roll, openssl-crypto, no asm-MD5
        Checksum list:
            xxh128 xxh3 xxh64 (xxhash) md5 md4 sha1 none
        Compress list:
            zstd lz4 zlibx zlib none
        Daemon auth list:
            sha512 sha256 sha1 md5 md4

        rsync comes with ABSOLUTELY NO WARRANTY.  This is free software, and you
        are welcome to redistribute it under certain conditions.  See the GNU
        General Public Licence for details.
        ```
    
    - 同步
    
        `rsync -avP --delete --exclude={'.git','.vscode','attachment','*.md','.gitignore'} --filter=':- .gitignore' /path/to/isee/ user@host:~/typst/`

        上面是我的同步命令,其中 
        `--delete` 参数控制本地删除,远程也会删除,
        `--exclude` 参数放入不想要同步的目录,文件,
        `--filter` 参数根据`.gitignore`规则忽略文件.

        `/path/to/isee/` 是项目根目录,注意默认要有`/`,windows 路径在`git bash`中会变为`/d/code/isee/`这种格式.

        `user@host:~/typst/` 是要同步的远程主机的目录

