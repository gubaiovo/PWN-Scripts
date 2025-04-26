#!/bin/bash

# 用法：pwninit.sh --libc libcfile --ld ldfile --bin attachment
# 初始化变量
ld_flag=""
libc_flag=""
bin_flag=""

# 解析参数
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --ld) ld_flag="$2"; shift ;;
        --libc) libc_flag="$2"; shift ;;
        --bin) bin_flag="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 检查是否提供了所有必要的参数
if [ -z "$ld_flag" ] || [ -z "$libc_flag" ] || [ -z "$bin_flag" ]; then
    echo "错误: 请提供 --ld, --libc 和 --bin 参数。"
    exit 1
fi

# 打印参数
cp "$bin_flag" "$bin_flag.bak"
patchelf --replace-needed libc.so.6 "$libc_flag" "$bin_flag"
patchelf --set-interpreter "$ld_flag" "$bin_flag"