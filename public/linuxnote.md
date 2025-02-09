---
title: 【随時更新】Linux 勉強ノート
tags:
  - ShellScript
  - Linux
  - 勉強メモ
private: false
updated_at: '2025-02-09T21:12:04+09:00'
id: eeca565e601ccc6ffd99
organization_url_name: null
slide: false
ignorePublish: false
---

# 前文

これは個人的にLinuxの勉強をしたときのメモ。
後半はほぼ「[【永久保存版】シェルスクリプト完全攻略ガイド](https://qiita.com/osw_nuco/items/a5d7173c1e443030875f)」のノート。

## Linuxの概要

コンピューターを構成する要素として、ハードウェア（hardware）とソフトウェア（software）に大別する方法がある。

ハードが私たちの手に触れる物理的な要素を指すのに対し、ソフトは処理を行うプログラムを指すと言えば伝わるだろうか。

ここでソフトの方に注目して、さらに分類を見ていくと、次のように分類できる。
* 大まかにコンピューターを動かす基礎となる仕事をする`system software`
* ゲーム、通信、ワープロ、ブラウジングなど多様な仕事をする`application software`、いわゆるアプリ

さて、本稿の本題であるLinuxはそんなsystem softwareの中枢、`Operating System`の一種である。macOSやAndroidあたりとは実は親戚だったりする。

### 簡単な歴史

最初期のOS、UNIXの歴史は'60年代、マサチューセッツ工科大学、AT&T Bell研究所、General Electricが開発していたシステムにさかのぼる。60年代末、この経験をもとにベル研究所の*Ken Thompson*がUNIXを開発し始めた。はじめアセンブリ言語で書かれていたが、*Dennis Ritchie*がC言語を開発し、コードをすべてCで書き直した。

'70年代にはUNIXは研究所内外で爆発的に広まり、数多くの研究所や大学で利用されるようになった。また、さまざまな派生OSが生み出されていったが、ここでとくに重要なのはカルフォルニア大学の学生であった*Bill Joy*が作り上げた`BSD UNIX`である。
加えて、'80年代にカーネギーメロン大学で改良されたUNIXはのちの*Steve Jobs*による`macOS`の源流となった。

'90年代、ヘルシンキ大学の学生であった*Linus Torvalds*はUNIX互換のOS"Linux"を作り始めた。'00年代に入ると活動は世界的な注目を集め、これを中核（カーネル）とした`Red Hat`や`Debian Gnu`などが登場した。

また、`Andy Rubin`らはLinuxカーネルを用いてモバイル用OS`Android`を開発、*google*による支援もあって今日では世界でもっとも使われるOSとなっている。

## ディレクトリ構造

## 余談：host, terminal

大規模なcomputer networkなどでは、一括で処理を行ったり記録したりする高性能な大型のコンピューターと、それを操作したり情報の入出力を行ったりする端末という形態をとることがある。

この時、大型コンピューターを**host**、端末を**terminal**という。

このようにすることで、1つ1つコンピューターを用意する費用を軽減することができる。

この形態はinternetにおけるClient-Server Systemに似ている。Clientは用役を提供される側、Serverは用役を給仕する側を指していて、Clientからの要求にServerが応答する形で処理を進めるものをいう。

また、"Terminal"といえば、アプリとしてその機能を再現した`Terminal emulator`というものが存在する。実態として、現在の`Terminal emulator`は`Shell`を操作するための「ガワ」と言える。

## 概要：`Shell`とは？
`Shell`はユーザーとカーネルの間を取り持つアプリの総称である。`Shell`はユーザーからの命令をカーネルに翻訳して通達し、実行結果を再度翻訳してユーザーのもとへ返す役割を持つ。また、ただ翻訳するだけでなく種々の入力補助やワイルドカード展開などプログラマの仕事を補助するこまごまとした機能が多数備わっている。

Linux distroでは`bash`と呼ばれる`Shell`が標準となっているため、本稿でもこれを踏襲する。

なお、語源は読んで字のごとく貝で、二枚貝の殻が身を覆う姿に由来する。

## Command-Lineの見どころ

下のようなプログラマ御用達の"黒い画面"を見たことがあるだろう。これを`CLI (Command-Line Interface)`、または単に`Command-Line`という。

```bash
$ uname -a
```

左側にある`$`は`prompt`といって、`Shell`が入力を受け付けているのを表している。

一方右側にあるのが`command`、つまりユーザーの命令である。`Shell`はこの命令をカーネルに掛け合い、返答を次の行に表示してくれる。

ちなみに`uname`コマンドはコンピューターのシステム情報を表示する命令である。

<details>
<summary>
consoleとは？
</summary>

かつてコンピューターが巨大で扱いずらかった時代、キーボードやモニターといった装置は本体に直接備え付けられていた。これらを`console`、日本語では制御盤などと呼んだ。

現在、こういった機器はめったにお目に掛かれなくなったが、`console`という言葉自体は「意思疎通を取るもの」を指すものとして使われている。
たとえば、JavaScriptの`console objectは`ブラウザのデバッグ・コンソールを仲介する。

</details>

## Wildcard
`Wildcard`は特定の文字列の代わりに使える特殊な文字。

たとえば、あるディレクトリにtxtファイルが複数入っていて、これらすべてを指定したいとする。

```terminal
# ディレクトリ内のすべてのtxtファイルを参照してその内容を出力
$ cat *.txt
```

ここで使ったのは`*`、0文字以上の任意の文字列を指している。つまり、このディレクトリに入っている"hello.txt"や"world.txt"をすべて参照して`cat`に渡している。

| wildcard       | description                    |
| -------------- | ------------------------------ |
| ?              | Any one character              |
| *              | String of 0 or more characters |
| [15]           | ex. 1 or 5                     |
| {hoge, fuga}   | ex. hoge or fuga               |
| [!19] or [^19] | ex. Not one, not nine          |

`Wildcard`は`Shell`に限らず、プログラミングやデータベース操作、`explorer`のファイル検索やブラウジングにも使えるので覚えておくとよい。

語源はカードゲームで他のカードを代用できる特殊なカードである"Wild card"から。

## 入力補完

`bash`など`shell`では入力を補完する機能が既定で備わっている。利用するしないで効率がだいぶ変わるのでぜひ活用したい。

以下の例では、current directory内にletter.txtというファイルがあったとして、このファイルの名前を補完してみる。

```bash
$ cat l # ←ここでtabキー
$ cat letter.txt # このように補完される
```

もしlから始まるファイルが複数ある場合ではこの時点では決定できず、そのいずれかを選択するようになる。
また、別に"le"と打ってからtabでもいいし、"let"からでもよい。とにかく使ってみて慣れることである。

ちなみにコマンドでも補完が効く。

## 履歴

また、`Shell`には履歴（`history`）機能が備わっている。

```terminal
$         # ここで上下キー
```

promptで↑キーを押下するとひとつ前に実行したコマンドが表示される。連打するとさらにさかのぼれる。
↓キーでまた下れる。

ほか、!!を実行することでも直前のコマンドを再度展開できる。

### `history`コマンド

```bash
$ history
$ history | less
```

履歴が表示される。長すぎる場合にはless（pagerの一種）を併用してやるとよい。

12番のコマンドを実行したい場合、`$ !12`を叩くと実行される。

## `set` - bash option

*本節は内容的にこの位置に置くが、ShellScirptの内容を含むのでいったん最後まで読んでから戻ってくることを勧める。*

`set`はbashのoptionを設定するコマンド。

```bash
$ set -o noclobber # noclobberを有効にせよの意。無効にしたいなら+oとすること。
```

`set`はbashの組み込みであるため、詳細は`help`コマンドを用いて閲覧できる。

### ShellScriptでやるべき設定

* `errexit`, `-e`: コマンドが異常終了し次第スクリプトを停止（むしろなんでこれが規定ではないのか）
* `nounset`, `-u`: 未定義の変数を参照し次第例外を投げる（むしろなんで規定ではないのか、大事故の温床）
* `xtrace`, `-x`: コマンドの実行時にそのコマンドと引数をstderrに投げる。shファイルを実行するときにstderrにredirectしておけば自動的にログを書ける。
* `noclobber`, `-C`: 出力リダイレクトを禁じる

`errexit`の項目でコマンドが異常終了し次第強制終了すると述べたが、これはpipeでつながったコマンドを実行しているときにはエラーを補足できない。
Pipeを使ったコマンドは最後に実行されたコマンドのステータスが全体のステータスとして解釈されるためである。このエラーを補足するためには、次のoptionを付ける。

* `pipefail`: pipeを使っていてもエラーを補足する。

結論として、ShellScriptを書き始めるときは次のように設定しているとよい。

```bash
#! /bin/bash

set -euxo pipefail
```

<details>

<summary>
nounsetを設定しなかった場合の大事故の例
</summary>

```bash
#! bin/bash

# WORKDIRを定義したと思い込む

rm -fr $WORKDIR/
```

上を実行すると`WORKDIR`が未定義なので何もないものと解釈され、結果として実行されるのは`rm -fr /`という恐ろしいコマンドになる。

一応説明すると、`rm`はファイルやディレクトリを削除するコマンド、`/`はroot即ちLinuxの最上段にあるディレクトリであり、`-f` はforceのことで確認・警告をすべて無視するオプション、`-r`はrecursiveのことでディレクトリ配下のすべての項目を削除するオプションである。

まとめると、Linuxを構成するすべての情報をことごとく削除しつくす地雷のようなコマンドとなっている。何が怖いってLinuxでは削除したファイルの復元がかなり難しいこと。

つまり地獄への紐なしバンジーというわけである。口に出すのもおぞましい。やめやめ…

</details>

## 実行
拡張子は`sh`、先頭にはShebang（`#! /bin/bash`）を書くこと、実行権限を与えるのを忘れずに

## 変数
```bash
var="Hello, World!" # 変数定義、=の前後に空白は入れられない。単一のコマンドとして認識されるため。
echo $var # 変数を参照するときは、変数名の前に$を置く。
var="Evening, World!" # 再代入
unset $var # 変数を削除
echo $var # 例外は投げられず、何も出力されない。これ結構まずい。エラーにする方法があるので後述
readonly CONSTANT="invariant" # 定数定義。
```

## 特殊文字
```
* ? [ ' " ` \ $ ; & ( ) | ~ < > # % = space tab CR
```
入力にはエスケープが必要。

## 引用符
singleとdoubleで違いがある。

singleなら与えられた文字列がすべてEscapeされる。したがって、変数は展開されない。

doubleなら`$`、`` ` ``、`/`以外がEscapeされる。したがって、変数が展開される。

```bash
var1=value
var2='${var1}'
echo $var2 # ${var1}

var1=value
var2="${var1}"
echo $var2 # value
```

## Command-Line args
```Terminal
$ test.sh 1 2 3 4,
```

コマンドライン引数は`position parameter`に保存される。
実際に参照するには、`$1`または`${2}`と書く。10番目以降は、`${10}`と波括弧で囲まねばならない。

## Special Parameter
* `$0`: ファイル名
* `$?`: 直前に終了したプロセスの終了ステータス（後述）。
* `$#`: 与えられた`command-line args`の数。ちなみに、`shift`命令で`$2`を`$1`、`$3`を`$2`といった具合に左にずらせるが、同時に`$#`の値も1つ減少し、0の状態でさらに叩くと例外が発される。
* `$*`: position parameterをまとめて参照。
* `$@`: position parameterを個別に参照。関数にまとめて引き渡すときなどに実引数に与えるときに使うなど。
* `$$`: 実行されたShellScriptのprocess ID
* `$!`: 最後に実行されたBackground processのprocess ID

```bash
(sleep 10; echo 'end') & # &は非同期処理を行う命令
echo $!
wait $! # IDを指定してプロセスの終了を待つ。
```

<details>
<summary>
変数の参照に関して補足
</summary>

普通の変数、定数を参照するときもそうだが、原則として参照を行うときは引用符で囲った方がよい。

ShellScriptでは囲まなくとも文字列と認識されることと、半角スペースが空いていると別々の引数とみなされるという関係上、内部の文字列に空白が含まれていた場合参照時に別々の文字列として展開される可能性がある。

</details>

<details>
<summary>
終了ステータスについて
</summary>

* Linux Distroの終了ステータスは符号なし8bit（`0~255`）で表せられ、うち0のみが正常終了、それ以外はすべて異常終了を表す。
* ShellScriptでは`exit 0`の形でステータスを指定できる。さもなくば、最後に実行されたコマンドの終了ステータスが流用される。

</details>



## 配列
```bash
ary=(1 2 3 4 5 6 7) # 定義。変数の時と同様等号の前後に空白を入れてはならない。要素の間には空白を入れる。
echo ${#ary{@}} # 要素数。7が出力される。
ary=(item0 [2]=item2 [4]=item4) # 位置指定。要素数は3になる。
echo "${ary[@]}" # 1 2 3 4 5 6 7 JavaScriptなどでいうところのspread syntax。
array=(114 515 $"${array[@]}") # 疑似的に要素を追加。冒頭、末尾、中間など好きにできる。
array+=(hello, world!) # 末尾に追加、stack風に。

echo ${!array[@]} # 値を持つidx一覧
```

## 制禦構文

### 条件分岐
基本的には以下。
```bash
if condition; then
  process
fi
```

いつものやつを書くなら以下。
```bash
if condition1; then
  process1
elif condition2; then
  process2
else
  process3
fi
```

使用感
```bash
# 郵便番号を探す例
if grep '[0-9]\{3\}-[0-9]\{4\}' register.txt; then
  echo $?
  echo success
else
  echo $?
  echo fail
fi
```
与えられた命令の終了ステータスによって分岐する。Cと同様、0が返れば真、1が返れば偽。

#### test命令による式の評価

ShellScriptの場合、単に比較演算子を与えるだけでは評価してくれない。命令として定義されていないためである。そこで、`test`命令はCなりPythonなりと同様に評価する機能を提供している。
```bash
if test "$1" == "Hello"; then
  echo "Hello, World!"
else
  echo "Sorry, I don't know you."
fi
```

糖衣構文もある。ふつうはこっちを使う。

```bash
if [[ $1 == "Hello" ]]; then
  echo "Hello, World!"
else
  echo "Sorry, I don't know you."
fi
```

内部的には、`[[`がコマンドと認識されている。
`"$1"`、`=`、`Hello`は引数と認識されるため空白をあけること。加えて、最後の引数として`]]`を渡すこと。
等号は`=`、`==`どちらでも動くらしい。

以下に主要な演算子を記載しておくが、詳細は`test`のmanual pageを参照されたい。

#### 文字列の比較

| operator                        | True condition                |
| ------------------------------- | ----------------------------- |
| _str_                           | non-empty and non-undefined   |
| -n _str_                        | non-empty                     |
| -z _str_                        | empty                         |
| _str_ = _str_<br>_str_ == _str_ | equity                        |
| _str_ != _str_                  | non-equity                    |
| _str_ "<" _str_                 | Before in lexicographic order |
| _str_ ">" _str_                 | After in lexicographic order  |

<details>
<summary>
不等号に関して補足
</summary>

ShellScriptにおいて`>`ないし`<`は`redirect`（転送）の役割が与えられており、そのまま記述すると動作しない。引用符で囲ったり、`\`でエスケープしてやる必要がある。

</details>

#### 整数の比較
| operator        | True condition        |
| --------------- | --------------------- |
| _int_ -eq _int_ | equal                 |
| _int_ -ne _int_ | not-equal             |
| _int_ -lh _int_ | less than             |
| _int_ -le _int_ | less than or equal    |
| _int_ -gh _int_ | greater than          |
| _int_ -ge _int_ | greater than or equal |

#### ファイル操作

ほかにもいろいろあるが主要なものだけ。

| operator  | True condition                                            |
| --------- | --------------------------------------------------------- |
| -d _file_ | _file_ exists and is a directory                          |
| -e _file_ | _file_ exists                                             |
| -f _file_ | _file_ exists and is a regular file                       |
| -r _file_ | _file_ exists and the user has read access                |
| -w _file_ | _file_ exists and the user has write access               |
| -x _file_ | _file_ exists and the user has execute (or search) access |

#### 論理演算
| operator                   | True condition |
| -------------------------- | -------------- |
| expression && expression   | and            |
| expression \|\| expression | or             |

#### pattern match
```bash
var="document"
if [[ $var == doc*]]; then
  echo "success"
else
  echo "fail"
fi
```

### 多岐分岐（case文）

```bash
case expression in
  pattern)
    process
    ;;
  pattern)
    process
    ;;
  *)
    process
    ;;
esac
```

実際に書くと次のようになる。

```bash
case "$1" in
  *Script)
    echo ShellScriptかJavaScriptか…
    ;;
  *)
    echo "僕はRubyが好きですね"
    ;;
esac
```

### 反復処理

#### for文

```bash
for item in items; do
  echo $item
done
```

たとえば次のようになる。

```bash
for item in "$@"; do
  echo $item
done
```

```bash
for item in "${ary[@]}"; do
  echo $item
done
```

#### while文, until文
```bash
while condition; do
  process
done

until condition; do
  process
done
```

たとえば次のようになる。

```bash
while [[ $# -gt 0]]; do
  echo $1
  shift
done

# $#の値が正の間だけ$1を出力、Command-Line argsを左にシフト。
```

```bash
until [[ $# -eq 0 ]]
  echo $1
  shift
done

# 上をuntilをつかって書き直した形。
```

## 関数定義

```bash
function name()
{
    process
}
```

ShellScriptでは、何も考えずに変数を定義するとglobalになって怖い。
関数内では`local`が使えるのでこいつを使ってlocal scopeを利用する。

```bash
greet="Good morning, World!"
function name()
{
    local greet="Hello, World!"
    echo $greet
}
echo $greet
```

### 引数の話
当然引数を取りたくなると思いますが、ここが少しややこしい。
local scopeでは、先述した`$1`や`$@`がその役割を果たす。

```bash
function name()
{
    echo "$1"
    local sum=0
    for i in "$@"; do
      sum=$(("${sum}"+"${i}")) # 計算するときはこのように書く。代入先の方に$を付けないように。
    done
    echo "${sum}"
}
```

ほとんどの`Special Parameter`は直感的に関数内の引数と対応付けられると思うが、`$0`の値はscopeにかかわらずファイル名である。では、どうやって関数名を取得するのかという話になるが、これには`FUNCNAME`を用いる。

`FUNCNAME`は組み込みの配列であり、関数が呼び出されるたびに先頭に関数名が追加される。

```bash
function name()
{
  for item in ${FUNCNAME[@]}; do
    echo "${item}"
  done
}

name #=> name main
```

要するに、local scopeで`FUNCNAME[0]`を参照してやると関数名を取得できる。
なんか内部的にはmain関数が呼ばれてるみたい。おもしろい。

### 終了ステータス
global scopeでは`exit`で指定できたが、local scopeでは`return`で指定できる。

```bash
function get_triangle_surface()
{
  if [[ "$#" == 2 ]]; then
    echo "引数に過不足がある"
    return 1
  else
    echo $(($1*$2/2))
    return 0
  fi
}
```

`return`の引数を略した場合は直前のコマンドの終了ステータスが、そもそも`return`自体を省いた場合は最後に実行されたコマンドの終了ステータスが流用される。

## Redirect, Hear Document, Pipe

### 予備知識：`standard input/output`

普段、こうしてCLIを使うときキーボードから入力を行い、画面に出力が表示される。
ここでいう入出力とは何か具体的にいうと、ファイルからデータを与え、ファイルにデータが返される一連の操作を指している。

さて、こうしたファイルの入出力を管理しているのが標準入出力（standard input/output）である。標準入出力には次の三本のStream（流れ）がある。

| name                           | assignment        | file descriptor |
| ------------------------------ | ----------------- | --------------- |
| standard input (stdin)         | keyboard          | 0               |
| standard output (stdout)       | terminal emulator | 1               |
| standard error output (stderr) | ibid              | 2               |

「割り当て」の項目にあるように、これらはハードとの対応があらかじめ割り当てられており、プログラマはとくに意識せずともこれらへ/に暗黙裡に入出力される。

<details>

<summary>
UNIXにとっての「ファイル」とは？～Device File～
</summary>

UNIXにとって、ファイルとはデータを読み込んだり書き込んだりできるものの総称である。
この流儀に従えば、たとえば五大装置やUSBメモリ、またSocketなども「ファイル」に含まれることになる。こうした考え方を**Device File**という。

なぜこのようなことをするかといえば、それは単にハードウェアを仮想化してまとめて扱えれば管理が大変楽になるからである。
入力や出力が別々にあればその差異を吸収するのはプログラマの役割となり開発は一段と難しくなっていただろう。

ちなみに、これらハードを仮想化したファイルは`/dev`配下にある。

こと`/dev/null`は大変有用であり、書き込んでもすべて消え、読み込んでも何も返さない。不要なログなどはここに`redirect`してしまえば楽に消去でき、また簡単にファイルを初期化できる。

`/dev`配下を見てみよう。
```
$ ls -lF /dev | head -n 10
total 0
crw-r--r-- 1 root root     10, 235 Jan 16 16:50 autofs
drwxr-xr-x 2 root root         620 Jan 16 16:50 block/
drwxr-xr-x 2 root root         140 Jan 16 16:49 bsg/
crw-rw---- 1 root disk     10, 234 Jan 16 16:50 btrfs-control
drwxr-xr-x 3 root root          60 Jan 16 16:49 bus/
drwxr-xr-x 2 root root        2840 Jan 16 16:50 char/
crw------- 1 root root      5,   1 Jan 16 16:50 console
lrwxrwxrwx 1 root root          11 Jan 16 16:50 core -> /proc/kcore
crw------- 1 root root     10, 125 Jan 16 16:50 cpu_dma_latency
```

</details>


<details>

<summary>
「標準」入出力って？
</summary>



</details>


### Redirect
リダイレクト（転送）を使うと、本来のストリームの割り当てを別のファイルに変更できる。
文法は次の通り。

```bash
echo "Hello" > greeting.txt

cat greeting.txt # Hello
```

本来は既定されたターミナルに出力されるはずだったstdoutであるが、実際にはgreeting.txtに変更されていることがわかる。

上の書き方の場合、上書き保存、すなわち一度初期化されたから文字列が書き込まれる形になる。
追記するなら次の通り。

```bash
echo "Good evening" >> greeting.txt

cat greeting.txt # Hello Good evening
```

なお、双方ファイルが存在しなかった場合には自動的に作成される。

<details>
<summary>
stderrへの出力
</summary>

```bash
echo "ERROR!" 2> error.log
cat error.log
```

* `2>`は上の表にある`file descriptor`のstderrの項目の2である。
* `2>>`も利用できる。
* ちなみに`>`、`>>`は`1>`、`1>>`の略記となっている。無論この1はstdoutの1である。
* さらにちなむと、`3>`など2以上の整数も指定できるが、これらは普通descriptorの複製など特別な用途で用いる。

stdoutとstderr双方に同時に出力先を指定することもできる。

```bash
ls /bin /error > bin.txt 2> error.txt
```

双方を同じファイルにredirectするなら`&>`を用いる。

```bash
ls /bin /error &> result.txt
```

</details>

<details>
<summary>
file descriptorとは？
</summary>

`file descriptor`とは、プログラムがファイルを扱うときにOSがプログラムに対して割り当てるプロセスに固有な自然数である。

たとえば、以下はCで`myfile.txt`を開き、OSがdescriptorに3を与えた場合である。

```c
int fd = open("myfile.txt", O_RDONLY); // fdには3が格納される
char buffer[100];
read(fd, buffer, 100); // ファイルディスクリプタ3（myfile.txt）からデータを読み込む
close(fd); // ファイルディスクリプタ3を閉じる
```

OSは内部にファイルとdescriptorの対応表を持っており、これによりプログラマは楽にファイル操作ができ、OSはファイルを効率的に管理できる。

</details>

入力でもredirectが使える。

```bash
$ cat hoge.txt
# hoge hoge
$ tr hoge fuga < hoge.txt > fuga.txt
$ cat fuga.txt
fuga fuga
```

`<`は`0<`の省略である。以外にも任意のdescriptorを指定できる。

<details>
<summary>
trコマンドについて
</summary>

基本はman pageを確認してもらいたいが、勉強がてら。

```terminal
$ man -f tr
tr (1) - translate or delete characters
```

`tr`はUNIX黎明期のエディター`ed`から変更や削除の機能だけを抽出する形で生まれたコマンドである。

書式は次の通り。

```
tr option STR1 [STR2]
```

基本的なoptionは次の通り。

| option                | description                                       |
| --------------------- | ------------------------------------------------- |
| -c, --complement      | STR1 replaced by STR2                             |
| -d, --delete          | delete STR1                                       |
| -s, --squeeze-repeats | replace consecutive STR1s with a single character |
| -t, --truncate-set1   | truncate STR1 to length of STR2                   |

使用例

```terminal
$ cat greeting.txt
hellooooooooooooooooooo, world!
$ cat greeting.txt | tr -s o
$ cat greeting.txt
hello, world!
```

```terminal
$ cat greeting.txt
hello, world!
$ cat greeting.txt | tr -d " "
$ cat greeting.txt
hello,world!
```

</details>

### Hear Document

`Hear Document`はShellScript内に長い文字列を入力する方法である。

```bash
command << EOF
  contents
EOF
```

基本的には次のように使う。Hear Documentに与えたテキストは言葉通り**すべて**標準入力となる。よって、字下げ用のスペースや、コメントも書けない。

```bash
cat << EOF
hello
world
EOF
```

以下はHear Documentを標準入力に投げる例である。

```bash
cat - << EOF > content.txt
hello
world
EOF
```

`cat`の引数として置かれた`-`についてであるが、これは`cat`の仕様としてファイル名を指定して実行すると標準入力を受け取らなくなるため、標準入力を受け取りつつ標準出力先を指定する細工である。

また、置換（後述）との併用により、`Python`のf-stringのような使い方もできる。

```bash
text=$(cat << EOF
  arg1: $1
  arg2: $2
EOF
)

echo "${text}"
```

ただし、Hear Documentは**文字列ではなく標準入力**であることに留意されたし。上記で`cat`にDocumentを渡していたのはそのためである。
<details>
<summary>
詳細
</summary>

たとえば、Hear documentを`echo`に与えてみる。

```bash
echo << EOF
  hello
  world
EOF
```

これを実行しても、何も表示されない。`echo`は標準入力からは入力を受け付けないためである。

</details>

<details>
<summary>
EOF - 終了文字列について
</summary>

EOFはEnd of Fileの略で、通常終了文字列と呼ばれるが、実はHear Documentに用いる終了文字列はなんでもよい。ただ、Documentに書く内容と被ってはならない。

* `<< 'EOF'`でHear Documentを書くと、内部で展開が行われない。
* `<<-EOF`でHear Documentを書くと、行頭のtabが無視される。スペースは変わらず。どこで使うんだこれ。
* `<<< EOF`はHear Stringと呼ばれる、Hear Documentのone-linearである。たとえば次のように使う。

```bash
args="books"
text=$(cat <<< "args: $args")
echo $text
```

</details>

### Pipeline

`pipeline`は前のコマンドの標準出力を次のコマンドの標準入力に直接渡す機能である。

```bash
$ cat /etc/os-release | grep -i ubuntu | wc -l
9
```

標準入力に返されるはずのデータが次々とコマンドを介し、結果として「os-releaseに文字列ubuntuを含む行が何行あるか数える」命令になっている。

<details>
<summary>
上記コマンドの詳細
</summary>

`cat`はファイルを連結し、標準出力に吐き出す命令、`grep -i`はパターン（大文字小文字無視）に適合した行を抜粋する命令、`wc -l`は行数を数える命令である。`/etc/os-release`はdistroの版情報を保存したファイル。

まとめると、`os-release`の内容のうち、ubuntuという文字列（大文字小文字無視）が含まれている行を抜き出し、行数を数えている。

これをredirectを用いて書くと次のようになる。

```terminal
$ cat /etc/os-release > os-release.txt
$ grep -i ubuntu > > os-release.txt
$ wc -l os-release.txt
9
```

`pipeline`を使うことで非常に簡潔に命令を書くことができる。

</details>

この場合stderrは通常通りターミナルに吐き出されるが、stderrすらも次のコマンドに渡してやる場合は`|&`もしくは`2>&1`を用いる。

```bash
$ ls /bin |& grep -i "hello" | head -n 10
```

### Process Replacement

これは`Pipeline`の亜種のようなもので、1つしか結果を渡せない`pipeline`に対して複数渡すことができる機能である。

```
$ diff <(ls a) <(ls b)
（省略）
```

### Command Grouping

波括弧でコマンドを囲んでやることで複数の命令のstdoutをまとめてredirectできる。

```bash
{
  echo first message
  echo next message
  echo third message
} > dist.txt

# 次のようにも書ける。
{ echo first message; echo next...; } > dist.txt
```

丸括弧で囲んだ場合は`sub shell`が起動し、そこで実行される。`sub shell`は外部から隔絶された環境で、この中でディレクトリ構造を変更したり変数をいじったりしても親機の処理に影響しない。事実上の`block scope`として使える。

```bash
current_directory=`pwd`
(
  cd /etc
  current_directory=`pwd`
  echo "${current_directory}"
)

echo "${current_directory}"
```
