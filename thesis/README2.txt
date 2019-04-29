sjis, euc, utf8 なパッケージを作る。

前提： make, nkf, bash, platex が使える。
やること：
  *.tex, *.sty, *.cls をアップデート（今のコードは SJIS）して、
  あとは make を打てば十分。nkf でコードを変更してアーカイブを作ってくれる。

$ make

