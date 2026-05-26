#!/bin/bash
set -euo pipefail

# 创建输出目录
mkdir -p output

# 下载源（用更稳定的公共源）
echo "正在下载直播源..."
curl -sSL "https://raw.githubusercontent.com/imyuji/iptv/main/tv.txt" -o tv.txt

# 1. 处理IPv4源
echo "正在分类IPv4源..."
grep -E -v "\[|\.ipv6|ipv6\." tv.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv4.m3u
sed -i '1i #EXTM3U' output/ipv4.m3u

# 2. 处理IPv6源
echo "正在分类IPv6源..."
grep -E "\[|\.ipv6|ipv6\." tv.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv6.m3u
sed -i '1i #EXTM3U' output/ipv6.m3u

# 3. 处理港澳台源
echo "正在分类港澳台源..."
grep -E "香港|港|澳门|澳|台湾|台|TVB|凤凰|翡翠" tv.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/hk_tw.m3u
sed -i '1i #EXTM3U' output/hk_tw.m3u

# 4. 生成通用源
echo "生成通用源..."
awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' tv.txt > output/live.m3u
sed -i '1i #EXTM3U' output/live.m3u

# 复制到根目录，方便直接访问
cp output/*.m3u ./

echo "✅ 直播源生成完成！"
