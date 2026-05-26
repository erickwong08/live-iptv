#!/bin/bash
mkdir -p output

# 源地址（稳定开源接口）
URL="https://raw.githubusercontent.com/iptv-sources/iptv-json/main/source.json"

# 下载源
curl -sSL $URL -o source.json

# 转换为 m3u 格式
jq -r '.channels[] | .name + "," + .url' source.json > all.txt

# 分类：IPv6
grep -E "://\[|\.ipv6|ipv6\." all.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv6.m3u

# 分类：IPv4
grep -v -E "://\[|\.ipv6|ipv6\." all.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/ipv4.m3u

# 分类：港澳台
grep -E "香港|港|澳门|澳|台湾|台|TVB|凤凰|星空|翡翠|now|hktv|tw|hk" all.txt | awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' > output/hktw.m3u

# 完整源
awk -F ',' '{print "#EXTINF:-1,"$1"\n"$2}' all.txt > output/all.m3u

# 头部格式
sed -i '1i #EXTM3U' output/*.m3u
