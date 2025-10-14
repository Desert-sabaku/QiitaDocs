---
title: IPv6のせいで名前解決がうまくいかなかった話
tags:
  - Network
  - IPv6
  - dns
  - トラブルシューティング
  - 技術メモ
private: false
updated_at: '2025-10-14T21:27:08+09:00'
id: 824fd94150aa577a2e0e
organization_url_name: null
slide: false
ignorePublish: false
---

# これは何

IPv6 のせいで名前解決がうまくいかなかった話です。あるあるらしいのでネット上に腐るほど同じ話はあるでしょうが、まあ~~実績作り~~書くことで理解するということですね。

# 事象

コンピューターネットワークの勉強をしていて、名前解決の仕組みを理解するために、`nslookup`コマンドを使って DNS サーバーに問い合わせをしていました。

```powershell
nslookup www.google.com
```

すると、以下のような応答が返ってきました。

```plaintext
サーバー:  UnKnown
Address:  2001:4860:4860::8888

*** UnKnown が 8.8.8.8 を見つけられません: No response from server
```

# 問題の切り分け

この応答から、DNS サーバーのアドレスが IPv6 形式で表示されていることがわかります。`2001:4860:4860::8888`は Google のパブリック DNS サーバーの IPv6 アドレスです。

しかし、`No response from server`というエラーメッセージが表示されており、DNS サーバーからの応答がないことを示しています。

まず、IPv4 アドレスで問い合わせを試みることにしました。

```powershell
nslookup www.google.com 8.8.8.8
```

このコマンドでは、明示的に IPv4 アドレスの DNS サーバーを指定しています。すると、以下のような応答が返ってきました。

```plaintext
サーバー:  dns.google
Address:  8.8.8.8

権限のない回答:
名前:    www.google.com
Addresses:  2404:6800:4004:80f::2004
          172.217.174.100
```

この応答から、DNS サーバーからの応答が正常に返ってきていることがわかります。

では、なぜ IPv6 アドレスでの問い合わせが失敗したのかを調査しました。

# 原因の特定

1. **ネットワーク設定の確認**: コンピューターのネットワーク
2. **ファイアウォールの設定**: IPv6 トラフィックがブロックされていないか確認
3. **DNS サーバーの応答確認**: DNS サーバーが IPv6 トラフィックに応答しているか確認
4. **ルーターの設定確認**: ルーターが IPv6 トラフィックを適切に処理しているか確認

## ネットワーク設定の確認

とりあえず設定を確認しましょう。

```powershell
ipconfig \all
```

```plaintext
Wireless LAN adapter Wi-Fi:

   接続固有の DNS サフィックス . . . . .:
   説明. . . . . . . . . . . . . . . . .: Intel(R) Wi-Fi 6E AX210 160MHz
   物理アドレス. . . . . . . . . . . . .: C4-FF-99-D7-84-08
   DHCP 有効 . . . . . . . . . . . . . .: はい
   自動構成有効. . . . . . . . . . . . .: はい
   リンクローカル IPv6 アドレス. . . . .: fe80::7ae:dace:92d0:c768%18(優先)
   IPv4 アドレス . . . . . . . . . . . .: 192.168.3.30(優先)
   サブネット マスク . . . . . . . . . .: 255.255.255.0
   リース取得. . . . . . . . . . . . . .: 2025年10月13日 15:47:43
   リースの有効期限. . . . . . . . . . .: 2025年10月14日 21:59:21
   デフォルト ゲートウェイ . . . . . . .: 192.168.3.1
   DHCP サーバー . . . . . . . . . . . .: 192.168.3.1
   DHCPv6 IAID . . . . . . . . . . . . .: 163905433
   DHCPv6 クライアント DUID. . . . . . .: 00-01-00-01-30-72-2F-40-D4-93-90-5C-42-24
   DNS サーバー. . . . . . . . . . . . .: 2001:4860:4860::8888
                                         DoH: https://dns.google/dns-query
                                          2606:4700:4700::1111
                                         DoH: https://cloudflare-dns.com/dns-query
                                          8.8.8.8
                                         DoH: https://dns.google/dns-query
                                          1.1.1.1
                                         DoH: https://cloudflare-dns.com/dns-query
   NetBIOS over TCP/IP . . . . . . . . .: 有効

```

抜粋です。

見るのは Wifi の項目、その DNS ですね。ちゃんと調べると別に間違ってません。すべて Google と Cloudflare の public DNS Server です。
丁寧に DoH を設定してますのでまあ割と安全だと思います。

## ファイアウォールの確認

設定から Windows Defender ファイアウォールへアクセス、詳細設定へ。送受信の設定の各項目について IPv6 が有効か調べます…

正味見方がよくわからん…（ちなみに IPv6 のプロトコル番号は 41 らしいです。）

じゃあ PowerShell で IPv6 をブロックしているルールを探します。

```powershell
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*IPv6*" }
```

```
Name                          : CoreNet-IPv6-In
DisplayName                   : コア ネットワーク - IPv6 (IPv6 受信)
Description                   : ISATAP (Intra-Site Automatic Tunnel Addressing Protocol) および 6to4 トンネリング サー
                                ビスに対して IPv6 トラフィックを許可するために必要な受信規則です。
DisplayGroup                  : コア ネットワーク
Group                         : @FirewallAPI.dll,-25000
Enabled                       : True
Profile                       : Any
Platform                      : {}
Direction                     : Inbound
Action                        : Allow
EdgeTraversalPolicy           : Block
LooseSourceMapping            : False
LocalOnlyMapping              : False
Owner                         :
PrimaryStatus                 : OK
Status                        : 規則は、ストアから正常に解析されました。 (65536)
EnforcementStatus             : NotApplicable
PolicyStoreSource             : PersistentStore
PolicyStoreSourceType         : Local
RemoteDynamicKeywordAddresses : {}
PolicyAppId                   :
PackageFamilyName             :
```

ほかにもいくらかありますが、全部大丈夫ですね…
ファイアウォールの問題ではなさそうです。

## DNS サーバーの応答確認

IPv6 トラフィックに対して DNS サーバーが応答しているか確認するために、`ping`コマンドを使用して Google の IPv6 アドレスに対して疎通確認を行いました。

```powershell
ping -6 2001:4860:4860::8888
```

```plaintext
2001:4860:4860::8888 に ping を送信しています 32 バイトのデータ:
ping: 転送に失敗しました。一般エラーです。
ping: 転送に失敗しました。一般エラーです。
ping: 転送に失敗しました。一般エラーです。
ping: 転送に失敗しました。一般エラーです。

2001:4860:4860::8888 の ping 統計:
    パケット数: 送信 = 4、受信 = 0、損失 = 4 (100% の損失)
```

お、損失 100%ですね。応答がないのはこれが原因でしょう。

## ルーターの設定確認

一応ルーターの設定も見てみましょう。当方は Softbank Air を使っていますので、管理画面にアクセスします。

が、ルーターの管理画面には IPv6 に関する設定項目が見当たりません。Softbank Air は IPv6 をサポートしていない…？

これがビンゴ。案の定でした。

参考：[ソフトバンクエアーは IPv6 通信の利用不可](https://microminister.co.jp/tokuhayanet/softbankair_ipv6/)

# 解決

Softbank Air は IPv6 をサポートしていないため、IPv6 アドレスを使用した DNS サーバーへの問い合わせが失敗していました。

したがって、 IPv6 自体を無効にするか、IPv4 アドレスの DNS サーバーを使用するようにネットワーク設定を変更することで問題を解決できます。

今回は IPv6 を無効にしてみます。

コントロール パネル\ネットワークとインターネット\ネットワーク接続にアクセスし、使用している Wifi アダプタのプロパティへ。
IPv6 のチェックを外すと無効化できます。

この状態で`nslookup www.google.com`を実行すると、以下のような応答が返ってきました。

```plaintext
サーバー:  dns.google
Address:  8.8.8.8

名前:    one.one.one.one
Address:  1.1.1.1
```

問題なく名前解決ができました。乙。

# 追記

この記事公開しようとしたらいきなりネットワークの応用問題出されて詰みかけました。草も生えない。

https://x.com/OrzDesert/status/1978018400640082084

```plaintext
TypeError: fetch failed
    at node:internal/deps/undici/undici:15845:13
    at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
    at async QiitaApi.request (/home/sabaku_laptop/procon/QiitaDocs/node_modules/@qiita/qiita-cli/dist/qiita-api/index.js:47:24)
    at async QiitaApi.get (/home/sabaku_laptop/procon/QiitaDocs/node_modules/@qiita/qiita-cli/dist/qiita-api/index.js:100:16)
    at async QiitaApi.authenticatedUserItems

    以下略…
```

よくわかりません。アップデートしてみますか。

```bash
npm install @qiita/qiita-cli@latest
```

```plaintext
npm error code ETIMEDOUT
npm error errno ETIMEDOUT
npm error network request to https://registry.npmjs.org/@qiita%2fqiita-cli failed, reason:
npm error network This is a problem related to network connectivity.

後略…
```

なんかめっちゃ Timeout しててワロエナイ。

これ qiita cli というより npm 側の問題っぽいですね。

[npm install がタイムアウトしてなんもできなくなった時にしたこと](https://zenn.dev/kumasun/scraps/c6a99c6bb75234)がいう通り、IPv4 を優先してみます。

それでこうなりました。

```bash
npm search react
```

```plaintext
react
React is a JavaScript library for building user interfaces.
Version 19.2.0 published 2025-10-01 by react-bot
Maintainers: fb react-bot
Keywords: react
https://npm.im/react

後略...
```

どうやら npm 内部の http client はホスト名の解決で帰ってきたアドレスを順に試していく方式らしいです。IPv6 アドレスが最初に返ってきて、そこにアクセスできないのでタイムアウトしてしまうと。

だから順序としては

1. `registry.npmjs.org`の名前解決で IPv6 アドレスが返ってくる
2. そのアドレスにアクセスしようとするが、ルーターが IPv6 をサポートしていないのでタイムアウト

って感じでいいのかな。

Windows 側で IPv6 を無効にしたのはくみ取ってくれないらしい。
