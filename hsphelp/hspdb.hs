;
;	HSP help manager用 HELPソースファイル
;	(先頭が「;」の行はコメントとして処理されます)
;

%type
拡張命令
%ver
3.1
%note
hspdb.asをインクルードすること。

%date
2004/04/01
%author
onitama
%dll
hspdb
%url
http://www.onionsoft.net/
%port
Win
%portinfo
Windows+ODBC環境が必要です。


%index
dbini
ODBCの初期化を行なう
%group
拡張入出力制御命令


%inst
ODBC の初期化を行ないます。 最初に１回だけ必ず実行する必要があります。
実行後に結果がシステム変数 statに格納されます。
0ならば正常終了、それ以外はエラーが発生したことを示しています。



%index
dbbye
HSPDBの終了処理を行なう
%group
拡張入出力制御命令
%inst
HSPDB全体の終了処理を行ないます。
通常、この命令はプログラム終了時に自動的に呼び出されるため、特にスクリ
プトに記述する必要はありません。


%index
dbopen
DBに接続を行なう
%group
拡張入出力制御命令
%prm
p1,p2
p1         : 接続指定文字列
p2=0〜1(0) : 接続モード

%inst
接続指定文字列で指定されたDBに接続を開始します。
接続指定文字列は、「DSN=TEST」 のようなDSN名を指定することができる他、
ドライバやファイルなど、各種パラメーターを文字列で記述することが可能で
す。接続指定文字列についての詳細はODBC関連の資料を参考にしてください。
接続モードが 1の場合は接続確認のためのダイアログがポップアップします。
接続モードが 0の場合は、指定した文字列のまま接続を行ないます。
実行後に結果がシステム変数 statに格納されます。0ならば正常終了、それ以
外はエラーが発生したことを示しています。

%href
dbclose



%index
dbclose
DBの接続を切断する
%group
拡張入出力制御命令
%inst
dbopen命令によって接続されたDBを切断します。
%href
dbopen



%index
dbstat
現在の状態を得る
%group
拡張入出力制御命令
%inst
現在の接続状態などをシステム変数 statに代入します。
^p
 stat : 状態
 -------------------------
   1  : エラーが発生
   2  : 切断中
   3  : 接続中
   4  : SQL応答待ち
^p
%href
dbsend



%index
dbspchr
区切り文字を指定する
%group
拡張入出力制御命令
%prm
p1
p1 : 0〜255 : 文字コード

%inst
dbgets命令で取得される結果の項目を区切るための文字を設定します。
通常は「,」で項目が区切られますが、 別な文字にしたい場合に設定を行なっ
て下さい。たとえば、「dbspchr 9」を指定した場合はTABコードが区切り文字
になります。

%href
dbgets




%index
dbsend
SQL文字列を送信する
%group
拡張入出力制御命令
%prm
"..."
"..." : SQL文字列

%inst
接続したDBにSQLの文法によるコントロール文字列を送信します。
実行後に結果が、システム変数 statに格納されます。0ならば正常終了、それ
以外はエラーが発生したことを示しています。
正常終了した場合は、dbgets命令で結果を取得することができます。

%href
dbgets
dbopen




%index
dbgets
結果文字列を取得する
%group
拡張入出力制御命令
%prm
p1
p1 : 結果の文字列が代入される変数名

%inst
dbsend命令により送信されたSQL文字列に対する結果を取得します。
p1に、結果文字列が代入される変数名を指定する必要があります。

p1で指定された変数は強制的に文字列型になり、変数バッファのサイズが許す
限りデータを受け取ります(バッファがオーバーフローすることはありません)
実行後に結果がシステム変数statに格納されます。 0ならば正常にデータを受
け取ったことを示しています。 1の場合は、結果の取得中にエラーが発生した
ことを示しています。2の場合は、 これ以上受け取るべきデータがないことを
示しています。

データを取得する場合は、大きなデータを何度にも分けて取得する可能性もあ
るため、システム変数statの内容が0だった場合は、 再度dbgetsを実行して最
後までデータを受け取るまでループさせるようにしてください。

%href
dbsend
dbspchr


