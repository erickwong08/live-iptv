#!/bin/bash
set -euo pipefail

# 1. 创建输出目录
mkdir -p output

# 2. 下载稳定可用的直播源（换了一个更稳的地址）
echo "正在下载直播源列表..."
curl -sSL "https://ghproxy.com/https://raw.githubusercontent.com/Guovin/TV/master/iptv/sources.txt" -o sources.txt

# 3. 分类处理
echo "正在生成IPv4源..."
grep -E -v "\[|\.ipv6|ipv6\." sources.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv4.m3u
sed -i '1i #EXTM3U' output/ipv4.m3u

echo "正在生成IPv6源..."
grep -E "\[|\.ipv6|ipv6\." sources.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv6.m3u
sed -i '1i #EXTM3U' output/ipv6.m3u

echo "正在生成港澳台源..."
grep -E "香港|港|澳门|澳|台湾|台|TVB|凤凰|翡翠|HBO" sources.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/hk_tw.m3u
sed -i '1i #EXTM3U' output/hk_tw.m3u

echo "正在生成通用全量源..."
awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' sources.txt > output/live.m3u
sed -i '1i #EXTM3U' output/live.m3u

# 4. 复制到根目录，方便直接访问
cp output/*.m3u ./

echo "✅ 所有直播源生成完成！"
