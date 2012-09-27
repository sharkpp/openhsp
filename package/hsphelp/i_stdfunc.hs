;
;	HSP help manager用 HELPソースファイル
;	(先頭が;の行はコメントとして処理されます)
;

%type
内蔵関数
%ver
3.3
%note
ver3.3標準関数
%date
2012/09/27
%author
onitama
%url
http://hsp.tv/
%port
Win
Cli
Let




%index
int
整数値に変換
%group
基本入出力関数
%prm
(p1)
p1 : 変換元の値または変数

%inst
p1で指定された値を整数にしたものを返します。
値が実数の場合は、小数点以下が切り捨てられます。
値が文字列の場合は、数値文字列の場合はその数値に、 それ以外は0になります。

%href
str
double



%index
rnd
乱数を発生
%group
基本入出力関数
%prm
(p1)
p1=1〜32768 : 乱数の範囲

%inst
0から(p1-1)の範囲で整数の乱数値を発生させます。
p1の値は範囲に含まれません。たとえば、
^p
例 ：
    a=rnd(10)
^p
は、変数aに、0〜9までの乱数を代入します。
rnd関数は、プログラム起動してからは一定のパターンで乱数を発生させます。
乱数のパターンを一定でないものにする場合は、 randomize命令を使用してください。

%href
randomize



%index
strlen
文字列の長さを調べる
%group
基本入出力関数
%prm
(p1)
p1 : 文字列の長さを調べたい文字列かまたは文字列型の変数名

%inst
p1で指定された文字列または、文字列型変数が持っている文字列の長さを返します。
文字列が日本語の全角だった場合は、１文字でも２文字分に計算されます。
%href




%index
length
配列の1次元要素数を返す
%group
基本入出力関数
%prm
(p1)
p1 : 配列を調べる変数

%inst
p1で指定された変数が持つ配列要素数(1次元)を返します。
配列要素数が５だった場合は、p1(0)〜p1(4)が存在することになります。

%href
length2
length3
length4



%index
length2
配列の2次元要素数を返す
%group
基本入出力関数
%prm
(p1)
p1 : 配列を調べる変数

%inst
p1で指定された変数が持つ配列要素数(2次元)を返します。
配列要素数が５だった場合は、p1(0,0)〜p1(?,4)が存在することになります。
配列の次元が存在しない場合は、0が返ります。

%href
length
length3
length4



%index
length3
配列の3次元要素数を返す
%group
基本入出力関数
%prm
(p1)
p1 : 配列を調べる変数

%inst
p1で指定された変数が持つ配列要素数(3次元)を返します。
配列要素数が５だった場合は、p1(0,0,0)〜p1(?,?,4)が存在することになります。配列の次元が存在しない場合は、0が返ります。

%href
length
length2
length4



%index
length4
配列の4次元要素数を返す
%group
基本入出力関数
%prm
(p1)
p1 : 配列を調べる変数

%inst
p1で指定された変数が持つ配列要素数(4次元)を返します。
配列要素数が５だった場合は、p1(0,0,0,0)〜p1(?,?,?,4)が存在することになります。配列の次元が存在しない場合は、0が返ります。

%href
length
length2
length3



%index
vartype
変数の型を返す
%group
基本入出力関数
%prm
(p1)
p1 : 型を調べる変数、または文字列

%inst
p1で指定された変数が格納している値の型を調べて返します。
返される値は、型を示す整数値となります。型の値は、以下の通りです。
^p
 1 : ラベル型
 2 : 文字列型
 3 : 実数型
 4 : 整数型
 5 : モジュール型
 6 : COMオブジェクト型
^p
プラグイン等で型が拡張されている場合は、これ以外の値が返されます。
また、p1に文字列を指定した場合には、型を示す型名として扱われます。
型名は、登録されているものと大文字小文字を含めて完全に一致させる必要があります。
^p
"int"    : 整数型
"str"    : 文字列型
"double" : 実数型
"struct" : モジュール型
^p
標準的な型名として、使用できるも文字列は上の通りです。ただし、これ以外にもプラグイン等で型が拡張されている場合は、指定できる型名も追加されます。


%href
varptr



%index
varptr
変数データのポインタを返す
%group
基本入出力関数
%prm
(p1)
p1 : ポインタを調べる変数、または命令

%inst
p1で指定された変数が格納しているデータがあるメモリアドレスを返します。
p1に外部拡張命令(#funcで定義されているDLL呼び出し用の命令)を指定した場合には、実際に実行される外部関数のアドレスを返します。
この関数は、 外部DLLにポインタを渡したい時など特殊な場合に使用するもので、通常は覚えておく必要のないものです。
varptrによって取得したポインタは、配列の拡張や内容の更新などにより変化する可能性があるため、値を参照する直前で使用するようにしてください。

%href
vartype
libptr
%port-
Let


%index
gettime
時間・日付を取得する
%group
基本入出力関数
%prm
(p1)
p1=0〜7(0) : 取得するタイプ

%inst
p1で指定したタイプの日付・時刻情報を返します。
取得するタイプは以下の通りです。

^p
    0 : 年(Year)
    1 : 月(Month)
    2 : 曜日(DayOfWeek)
    3 : 日(Day)
    4 : 時(Hour)
    5 : 分(Minute)
    6 : 秒(Second)
    7 : ミリ秒(Milliseconds)
^p
たとえば、

^p
例 ：
    a=gettime(4)   ; いま何時?
^p
は、変数aに現在時刻が何時かを代入します。

%href




%index
str
文字列に変換
%group
基本入出力関数
%prm
(p1)
p1 : 変換元の値または変数

%inst
p1で指定された値を文字列にしたものを返します。

%href
int
double



%index
dirinfo
ディレクトリ情報の取得
%group
基本入出力関数
%prm
(p1)
p1=0〜5 : 取得するタイプ

%inst
p1で指定したタイプのディレクトリ名を返します。
取得するタイプは以下の通りです。
^p
    0 : カレント(現在の)ディレクトリ(dir_cur)
    1 : HSPの実行ファイルがあるディレクトリ(dir_exe)
    2 : Windowsディレクトリ(dir_win)
    3 : Windowsのシステムディレクトリ(dir_sys)
    4 : コマンドライン文字列(dir_cmdline)
    5 : HSPTVディレクトリ(dir_tv)
^p
p1を省略することはできません。
また、p1に0x10000以上の値を指定した場合は、ビット0〜15までをCSIDL値として特殊フォルダの取得を行ないます。
これにより、デスクトップ(0x10000)やマイドキュメント(0x10005)等のシステムが管理しているほとんどのフォルダを取得することができます。
通常は、hspdef.as内で定義されてる「dir_*」マクロを通してご使用ください。

%href
dir_cur
dir_exe
dir_win
dir_sys
dir_cmdline
dir_tv



%index
double
実数値に変換
%group
基本入出力関数
%prm
(p1)
p1 : 変換元の値または変数

%inst
p1で指定された値を実数にしたものを返します。
値が文字列の場合は、数値文字列の場合はその数値に、 それ以外は0になります。

%href
int
str



%index
sin
サイン値を返す
%group
基本入出力関数
%prm
(p1)
p1=(0.0) : 角度値(ラジアン)

%inst
p1のサイン(正弦)値を実数で返します。
p1で指定する単位はラジアン(2πが360度)になります。
%href
cos
tan
atan


%index
cos
コサイン値を返す
%group
基本入出力関数
%prm
(p1)
p1=(0.0) : 角度値(ラジアン)

%inst
p1のコサイン(余弦)値を実数で返します。
p1で指定する単位はラジアン(2πが360度)になります。
%href
sin
tan
atan


%index
tan
タンジェント値を返す
%group
基本入出力関数
%prm
(p1)
p1=(0.0) : 角度値(ラジアン)

%inst
p1のタンジェント(正接)値を実数で返します。
p1で指定する単位はラジアン(2πが360度)になります。
%href
sin
cos
atan


%index
atan
アークタンジェント値を返す
%group
基本入出力関数
%prm
(p1,p2)
p1      : Y値
p2(1.0) : X値

%inst
p1をY、p2をXの値として、 Y/Xの角度(アークタンジェント値)を実数のラジアン単位(2πが360度)で返します。
p2を省略した場合は1.0が使用されます。また、p2が0の場合は0.5π(90度)が返されます。

%href
sin
cos
tan


%index
sqrt
ルート値を返す
%group
基本入出力関数
%prm
(p1)
p1=0.0〜(0.0) : ルートを求める値

%inst
p1のルート(平方根)値を、実数で返します。
p1にマイナス値を指定することはできません。
%href



%index
sysinfo
システム情報の取得
%group
基本入出力関数
%prm
(p1)
p1=0〜 : 取得するタイプ

%inst
p1で指定したタイプのシステム情報値を返します。
取得できるタイプは以下の通りです。
^p
  0 : 文字列 OS名とバージョン番号
  1 : 文字列 ログイン中のユーザー名
  2 : 文字列 ネットワーク上のコンピュータ名
 16 : 数値 使用しているCPUの種類(コード)
 33 : 数値 物理メモリサイズの使用量(単位%)
 34 : 数値 全体の物理メモリサイズ
 35 : 数値 空き物理メモリサイズ
 36 : 数値 スワップファイルのトータルサイズ
 37 : 数値 スワップファイルの空きサイズ
 38 : 数値 仮想メモリを含めた全メモリサイズ
 39 : 数値 仮想メモリを含めた空きメモリサイズ
^p

%href



%index
peek
バッファから1byte読み出し
%group
メモリ管理関数
%prm
(p1,p2)
p1=変数 : 内容を読み出す元の変数名
p2=0〜  : バッファのインデックス(Byte単位)

%inst
変数に保存されたデータメモリ上の任意の場所にある1バイト(8bit)の内容を数値として返します。
関数の戻り値は、0〜255までの整数値になります。

%href
wpeek
lpeek



%index
wpeek
バッファから2byte読み出し
%group
メモリ管理関数
%prm
(p1,p2)
p1=変数 : 内容を読み出す元の変数名
p2=0〜  : バッファのインデックス(Byte単位)

%inst
変数に保存されたデータメモリ上の任意の場所にある2バイト(16bit)の内容を数値として返します。
関数の戻り値は、0〜65535までの整数値になります。

%href
peek
lpeek



%index
lpeek
バッファから4byte読み出し
%group
メモリ管理関数
%prm
(p1,p2)
p1=変数 : 内容を読み出す元の変数名
p2=0〜  : バッファのインデックス(Byte単位)

%inst
変数に保存されたデータメモリ上の任意の場所にある4バイト(32bit)の内容を数値として返します。
関数の戻り値は、0〜$ffffffffまでの整数値になります。

%href
peek
wpeek



%index
callfunc
外部関数の呼び出し
%group
基本入出力関数
%prm
(p1,p2,p3)
p1 : パラメーターが格納されている配列変数
p2 : 関数アドレス
p3 : パラメーター数

%inst
p2で指定されているアドレスをネイティブな関数として呼び出します。
呼び出しの引数として、p1で指定された数値型配列変数に格納されている値を使用します。p3でパラメーター数を指定することができます。
^p
例 :
	a.0=1
	a.1=2
	a.2=3
	res = callfunc( a, proc, 3 )
^p
上の例では、procが示すアドレスの関数を(1,2,3)という引数で呼び出します。
呼び出した関数の戻り値が、そのままcallfuncの戻り値となります。
この関数は、自前で関数アドレスを用意して呼び出す特殊な状況に使用するものです。
通常は使用する必要がありません。また、外部関数呼び出しに失敗した場合には、フリーズや予期しない結果が起こる場合があるので、十分に注意して使用するようにしてください。

%href
#uselib
#func



%index
absf
実数の絶対値を返す
%group
基本入出力関数
%prm
(p1)
p1 : 絶対値に変換する実数値

%inst
p1の絶対値を実数で返します。
整数の絶対値が必要な場合は、abs関数を使用してください。
%href
abs

%index
abs
整数の絶対値を返す
%group
基本入出力関数
%prm
(p1)
p1 : 絶対値に変換する整数値

%inst
p1の絶対値を整数で返します。
実数の絶対値が必要な場合は、absf関数を使用してください。
%href
absf


%index
logf
対数を返す
%group
基本入出力関数
%prm
(p1)
p1=0.0〜(0.0) : 対数を求める値

%inst
p1の対数(log)値を、実数で返します。
p1に0を指定した場合は無限大(INF)を返します。
%href
expf



%index
expf
指数を返す
%group
基本入出力関数
%prm
(p1)
p1=0.0〜(0.0) : 指数を求める値

%inst
p1の指数(exp)値を、実数で返します。
オーバーフローした場合は無限(INF)を返し、アンダーフローした場合は0を返します。
%href
logf



%index
limit
一定範囲内の整数を返す
%group
基本入出力関数
%prm
(p1,p2,p3)
p1 : 対象となる値
p2 : 最小値
p3 : 最大値

%inst
p1に指定した値を、p2〜p3の範囲内に収まる整数に変換したものを返します。
p1の値がp2よりも小さい場合は、p2の値が返され、p1の値がp3よりも大きい場合にはp3の値が返されます。
これにより、limit関数が返す値は、必ずp2〜p3の範囲内となります。
実数の範囲を求める場合には、limitf関数を使用してください。

%href
limitf



%index
limitf
一定範囲内の実数を返す
%group
基本入出力関数
%prm
(p1,p2,p3)
p1= : 対象となる値
p2= : 最小値
p3= : 最大値

%inst
p1に指定した値を、p2〜p3の範囲内に収まる実数に変換したものを返します。
p1の値がp2よりも小さい場合は、p2の値が返され、p1の値がp3よりも大きい場合にはp3の値が返されます。
これにより、limitf関数が返す値は、必ずp2〜p3の範囲内となります。
整数の範囲を求める場合には、limit関数を使用してください。

%href
limit



%index
varuse
変数の使用状況を返す
%group
基本入出力関数
%prm
(p1)
p1 : 使用状況を調べる変数

%inst
p1に指定した変数の使用状況を返します。
varuseは、モジュール型やCOMオブジェクト型の変数など、 実態を持たない状況が発生する場合にのみ有効です。
指定された変数が有効であれば1を、そうでなければ0を返します。
モジュール型変数であれば、未使用(0)か、初期化済み(1)、または他の変数のクローン(2)かどうかを調べることができます。
COMオブジェクト型であれば、有効なCOMオブジェクトを保持しているかを調べられます。

%href
newmod
delmod
%port-
Let




%index
libptr
外部呼出しコマンドの情報アドレスを得る
%group
基本入出力関数
%prm
(p1)
p1 : アドレスを調べるコマンド

%inst
p1に指定したコマンドの情報アドレスを取得して整数値として返します。
外部DLL呼び出しコマンドや関数をパラメーターとして指定することで、コマンドに関する情報が格納されているSTRUCTDAT構造体のアドレスを取得することができます。
STRUCTDAT構造体は、HSPSDK内で以下のように定義されています。
^p
	typedef struct STRUCTDAT {
	short	index;           // base LIBDAT index
	short	subid;           // struct index
	int	prmindex;            // STRUCTPRM index(MINFO)
	int	prmmax;              // number of STRUCTPRM
	int	nameidx;             // name index (DS)
	int	size;                // struct size (stack)
	int	otindex;             // OT index(Module)  / cleanup flag(Dll)
	union {
		void	*proc;       // proc address
		int	funcflag;        // function flags(Module)
	};
	} STRUCTDAT;
^p
p1にCOM呼び出しコマンドやユーザー定義命令、 ユーザー定義関数を指定した場合も同様にSTRUCTDAT構造体のアドレスが取得されます。
libptr関数は、HSPが使用している内部データへのアクセスを補助するもので、ここで扱う情報の内容について十分な知識を持った上で使用するようにしてください。
通常の使用範囲では、この関数を利用したり覚えておく必要はありません。
^
STRUCTDAT構造体を参照することで、 外部呼出しDLLのアドレスや、DLLハンドルなどの情報を得ることが可能です。

%href
varptr
%sample
	#uselib "user32.dll"
	#func MessageBoxA "MessageBoxA" int,sptr,sptr,int

	ladr=libptr( MessageBoxA )
	dupptr lptr,ladr,28	; STRUCTDAT構造体を取得
	lib_id=wpeek(lptr,0)
	mes "LIB#"+lib_id
	mref hspctx,68
	linf_adr=lpeek( hspctx, 832 )
	dupptr linf,linf_adr + lib_id*16,16	; LIBDAT構造体を取得
	dll_flag = linf(0)
	dll_name = linf(1)
	dll_handle = linf(2)
	mes "FLAG("+dll_flag+") NAME_ID#"+dll_name
	mes "HANDLE="+strf("%x",dll_handle)
	stop
%port-
Let



%index
comevdisp
COMイベントの内容を確認
%group
COMオブジェクト操作関数
%prm
(p1)
p1      : 変数名

%inst
p1で指定された変数(COMオブジェクト型)のイベントサブルーチン内で、イベントのディスパッチID(DISPID)を取得します。
p1で指定された変数は、comevent命令により初期化されている必要があります。
また、取得は必ずイベントサブルーチン内で行なう必要があります。

%href
comevent
comevarg
%port-
Let


%index
powf
累乗（べき乗）を求める
%group
基本入出力関数
%prm
(p1, p2)
p1 : 底（0以上）
p2 : 指数

%inst
p1をp2乗した値を求めます。結果は実数で与えられます。
p1は必ず正でなければなりません。負の場合はエラーにはなりませんが、非数（-1.#IND00）が返ります。
p2は正負どちらでも構いません。また、実数を指定することも可能です。

%sample
	repeat 5, -2
		mes "10の" + cnt + "乗は" + powf(10, cnt) + "です。"
	loop
	stop

