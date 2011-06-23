
//
//	HSP3dish window manager
//	onion software/onitama 2011/4
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../hsp3/hsp3config.h"
#include "../hsp3/hsp3debug.h"
#include "../hsp3/dpmread.h"
#include "../hsp3/strbuf.h"
#include "../hsp3/strnote.h"

#include "hgio.h"
#include "supio.h"
#include "hspwnd.h"

HspWnd *curwnd;

/*------------------------------------------------------------*/
/*
		constructor
*/
/*------------------------------------------------------------*/

HspWnd::HspWnd()
{
	//		������
	//
	Reset();
}

HspWnd::~HspWnd()
{
	//		���ׂĔj��
	//
	Dispose();
}

/*------------------------------------------------------------*/
/*
		interface
*/
/*------------------------------------------------------------*/

void HspWnd::Dispose( void )
{
	//		�j��
	//
	int i;
	Bmscr *bm;
	for(i=0;i<bmscr_max;i++) {
		bm = mem_bm[i];
		if ( bm != NULL ) {
			delete bm;
		}
	}
	free( mem_bm );
}


int HspWnd::GetActive( void )
{
	//
	//		detect active window
	return 0;
}


void HspWnd::ExpandScreen( int id )
{
	int i;
	int idmax;
	Bmscr **new_bm;

	//Alertf("Expand:%d:%d",idmax,bmscr_max);
	idmax = id + 1;
	if ( idmax <= bmscr_max ) return;
	new_bm = (Bmscr **)malloc( sizeof( Bmscr * ) * idmax );

	for(i=0;i<idmax;i++) {
		if (( i >= bmscr_max )||( bmscr_max == 0 )) {
			new_bm[i] = NULL;
		} else {
			//if ( mem_bm[i] != NULL ) 
			new_bm[i] = mem_bm[i];
		}
	}
	if ( mem_bm != NULL ) free( mem_bm );

	bmscr_max = idmax;
	mem_bm = new_bm;
}


void HspWnd::Reset( void )
{
	//		all window initalize
	//
	int sx,sy;

	//		alloc Bmscr
	//
	bmscr_max = 0;
	mem_bm = NULL;
	ExpandScreen( 16 );									// �Ƃ肠����

	sx = hgio_getWidth();
	sy = hgio_getHeight();

	MakeBmscr( 0, HSPWND_TYPE_MAIN, 0, 0, sx, sy );
	
	//		global vals
	//
#if 0
	wfy=GetSystemMetrics( SM_CYCAPTION )+GetSystemMetrics( SM_CYFRAME )*2;
	wfx=GetSystemMetrics( SM_CXFRAME )*2;
	wbx=GetSystemMetrics( SM_CXHTHUMB );
	wby=GetSystemMetrics( SM_CYVTHUMB );
	mwfy=GetSystemMetrics( SM_CYCAPTION )+GetSystemMetrics( SM_CYFIXEDFRAME )*2;
	mwfx=GetSystemMetrics( SM_CXFIXEDFRAME )*2;
#endif

	curwnd = this;
}


void HspWnd::MakeBmscr( int id, int type, int x, int y, int sx, int sy )
{
	//		Bmscr(�I�t�X�N���[��)����
	//
	ExpandScreen( id );

	if ( mem_bm[ id ] != NULL ) {
		delete mem_bm[ id ];
	}
	Bmscr * bm = new Bmscr;
	mem_bm[ id ] = bm;

	bm->wid = id;
	bm->type = type;
	bm->texid = -1;
	bm->Init( sx, sy );
}


void HspWnd::MakeBmscrFromResource( int id, char *fname )
{
	//		Bmscr(���\�[�X)����
	//
	ExpandScreen( id );

	if ( mem_bm[ id ] != NULL ) {
		delete mem_bm[ id ];
	}
	Bmscr * bm = new Bmscr;
	mem_bm[ id ] = bm;

	bm->wid = id;
	bm->type = HSPWND_TYPE_BUFFER;
	bm->texid = -1;
	bm->Init( fname );
//	bm->Init( hInst, hwnd, sx, sy,
//	 ( mode & 0x01 ? BMSCR_PALMODE_PALETTECOLOR : BMSCR_PALMODE_FULLCOLOR ) );
}


int HspWnd::Picload( int id, char *fname, int mode )
{
	//		picload
	//		( mode:0=resize/1=overwrite )
	//
	Bmscr *bm;

	bm = GetBmscr( id );
	if ( bm == NULL ) return 1;
	if ( bm->flag == BMSCR_FLAG_NOUSE ) return 1;
	switch( bm->type ) {
	case HSPWND_TYPE_MAIN:
		break;
	case HSPWND_TYPE_BUFFER:
		MakeBmscrFromResource( id, fname );
		break;
	default:
		throw HSPERR_UNSUPPORTED_FUNCTION;
	}
	return 0;
}


Bmscr *HspWnd::GetBmscrSafe( int id )
{
	//		���S��bmscr�擾
	//
	Bmscr *bm;
	if (( id < 0 )||( id >= bmscr_max )) throw HSPERR_ILLEGAL_FUNCTION;
	bm = GetBmscr( id );
	if ( bm == NULL ) throw HSPERR_ILLEGAL_FUNCTION;
	if ( bm->flag == BMSCR_FLAG_NOUSE ) throw HSPERR_ILLEGAL_FUNCTION;
	return bm;
}


int HspWnd::GetEmptyBufferId( void )
{
	//		��ID���擾
	//
	int i;
	Bmscr *bm;
	for(i=0;i<bmscr_max;i++) {
		bm = GetBmscr(i);
		if ( bm == NULL ) return i;
		if ( bm->flag == BMSCR_FLAG_NOUSE ) return i;
	}
	return bmscr_max;
}


/*------------------------------------------------------------*/
/*
		Bmscr interface
*/
/*------------------------------------------------------------*/

Bmscr::Bmscr()
{
	//		bmscr������
	//
	flag = BMSCR_FLAG_NOUSE;
}

Bmscr::~Bmscr()
{
	//		Bmscr�j��
	//
	if ( flag == BMSCR_FLAG_INUSE ) {
		hgio_delscreen( (BMSCR *)this );
	}
}

/*----------------------------------------------------------------*/
//		font&text related routines
/*----------------------------------------------------------------*/

void Bmscr::Init( int p_sx, int p_sy )
{
	//		bitmap buffer make
	//
	flag = BMSCR_FLAG_INUSE;

	objmax = 0;
//	mem_obj = NULL;
	sx = p_sx; sy = p_sy;
	sx2 = sx;

	Cls(0);

	objmode = 1;
	fl_dispw = 0;

	fl_dispw = 1;
	fl_udraw = 1;
}


void Bmscr::Init( char *fname )
{
	int i;
	strcpy( resname, fname );
	i = hgio_texload( (BMSCR *)this, fname );
	if ( i < 0 ) {
		throw HSPERR_PICTURE_MISSING;
	}
	Init( sx, sy );
	//Alertf( "(%d,%d)",sx,sy );
}


void Bmscr::Cls( int mode )
{
	//		screen setting reset
	//
	int i;

	//		Font initalize
	//
	//Sysfont(0);

	//		object initalize
	//
	//ResetHSPObject();

	//		text setting initalize
	//
	cx=0;cy=0;
	Setcolor(0,0,0);

	//		vals initalize
	//
	textspeed=0;
	ox=64;oy=24;py=0;
	gx=32;gy=32;gmode=0;
	objstyle = 00;
	for(i=0;i<BMSCR_SAVEPOS_MAX;i++) { savepos[i] = 0; }

	//		CEL initalize
	//
	SetCelDivideSize( 0, 0, 0, 0 );

	//		all update
	//
	fl_udraw = fl_dispw;

	//		Update HGI/O
	//
	if ( wid == 0 ) {
		hgio_screen( (BMSCR *)this );
	}
}


void Bmscr::Title( char *str )
{
	hgio_title( str );
}


void Bmscr::Width( int x, int y, int wposx, int wposy, int mode )
{
}


void Bmscr::Posinc( int pp )
{
	if ( pp<py ) { cy+=py; } else { cy+=pp; }
}


void Bmscr::Setcolor( int a1, int a2, int a3 )
{
	color = 0xff000000|((a1&0xff)<<16)|((a2&0xff)<<8)|(a3&0xff);
}


void Bmscr::SetFont( char *fontname, int size, int style )
{
	hgio_font( fontname, size, style );
}


void Bmscr::Print( char *mes )
{
	hgio_mes( (BMSCR *)this, mes );
	Posinc( printsizey );
}


void Bmscr::Boxfill( int x1,int y1,int x2,int y2 )
{
	//		boxf
	hgio_boxf( (BMSCR *)this, (float)x1, (float)y1, (float)x2, (float)y2 );
}


int Bmscr::Pget( int xx, int yy )
{
	//		pget
	//
	return 0;
}


void Bmscr::Pset( int xx,int yy )
{
	//		pset
	//
	hgio_line( (BMSCR *)this, (float)xx, (float)yy );
	hgio_line2( (float)xx, (float)yy );
	hgio_line( NULL, 0.0f, 0.0f );
}


void Bmscr::Line( int xx,int yy )
{
	//		line
	//
	hgio_line( (BMSCR *)this, (float)cx, (float)cy );
	hgio_line2( (float)xx, (float)yy );
	hgio_line( NULL, 0.0f, 0.0f );
	cx=xx;cy=yy;
#if 0
	HPEN oldpen;
	int x,y,x1,y1,x2,y2;
	x=cx;y=cy;
	MoveToEx( hdc,x,y,NULL );
	if (cx<xx)   { x1=x;x2=xx-x; }
				else { x1=xx;x2=x-xx; }
	if (cy<yy)   { y1=y;y2=yy-y; }
				else { y1=yy;y2=y-yy; }
	oldpen=(HPEN)SelectObject(hdc,hpn);
	LineTo( hdc,xx,yy );
	SelectObject(hdc,oldpen);
	Send( x1,y1,x2+1,y2+1 );
	cx=xx;cy=yy;
#endif
}


void Bmscr::Circle( int x1,int y1,int x2,int y2, int mode )
{
	//		circle
	//		mode: 0=outline/1=fill
	//
	hgio_circle( (BMSCR *)this, (float)x1, (float)y1, (float)x2, (float)y2, mode );
}


/*----------------------------------------------------------------*/

int Bmscr::Copy( Bmscr *src, int xx, int yy, int s_psx, int s_psy )
{
	//		copy
	//
	int texpx,texpy,psx,psy;
	psx = s_psx;
	psy = s_psy;
	texpx = xx + s_psx;
	texpy = yy + s_psy;
	if ( texpx < 0 ) return -1;
	if ( texpx >= src->sx ) {
		if ( xx >= src->sx ) return -1;
		psx = src->sx - xx;
	}
	if ( texpy < 0 ) return -1;
	if ( texpy >= src->sy ) {
		if ( yy >= src->sy ) return -1;
		psy = src->sy - yy;
	}
	hgio_copy( (BMSCR *)this, xx, yy, psx, psy, (BMSCR *)src, (float)psx, (float)psy );
	return 0;
}


int Bmscr::Zoom( int dx, int dy, Bmscr *src, int xx, int yy, int s_psx, int s_psy, int mode )
{
	//		zoom
	//		(mode:0=normal/1=halftone)
	//
	int texpx,texpy,psx,psy;
	psx = s_psx;
	psy = s_psy;
	texpx = xx + s_psx;
	texpy = yy + s_psy;
	if ( texpx < 0 ) return -1;
	if ( texpx >= src->sx ) {
		if ( xx >= src->sx ) return -1;
		psx = src->sx - xx;
	}
	if ( texpy < 0 ) return -1;
	if ( texpy >= src->sy ) {
		if ( yy >= src->sy ) return -1;
		psy = src->sy - yy;
	}
	hgio_copy( (BMSCR *)this, xx, yy, psx, psy, (BMSCR *)src, (float)dx, (float)dy );
	return 0;
}


int Bmscr::BmpSave( char *fname )
{
	//		save BMP,DIB file
	//
	return 0;
}


void Bmscr::SetHSVColor( int hval, int sval, int vval )
{
	//		hsv�ɂ��F�w��
	//			h(0-191)/s(0-255)/v(0-255)
	//
	int h,s,v;
	int save_r, save_g, save_b;
	int t,i,v1,v2,v3;
	int mv=8160;		// 255*32
	int mp=4080;		// 255*16
	//		overflow check
	//
	v = vval & 255;
	s = sval & 255;		// /8
	//		hsv -> rgb �ϊ�
	//
	h = hval % 192;
	i = h/32;
	t = h % 32;
	v1 = (v*(mv-s*32) 	+mp)/mv;
	v2 = (v*(mv-s*t) 	+mp)/mv;
	v3 = (v*(mv-s*(32-t))+mp)/mv;
	switch(i){
		case 0:
		case 6:
				save_r=v;	save_g=v3;	save_b=v1;	break;
		case 1:
				save_r=v2;	save_g=v;	save_b=v1;	break;
		case 2:
				save_r=v1;	save_g=v;	save_b=v3;	break;
		case 3:
				save_r=v1;	save_g=v2;	save_b=v;	break;
		case 4:
				save_r=v3;	save_g=v1;	save_b=v;	break;
		case 5:
				save_r=v;	save_g=v1;	save_b=v2;	break;
	}
	Setcolor( save_r, save_g, save_b );
}


void Bmscr::GetClientSize( int *xsize, int *ysize )
{
	//		�E�B���h�E�̃N���C�A���g�̈�̃T�C�Y�����߂�
	//
#if 0
	RECT rw;
	GetClientRect( hwnd, &rw );
	*xsize = rw.right;
	*ysize = rw.bottom;
#endif
}


void Bmscr::GradFill( int x, int y, int sx, int sy, int mode, int col1, int col2 )
{
	//		�O���f�[�V�����h��Ԃ�
	//
#if 0
	TRIVERTEX axis[2];
	PTRIVERTEX vtx;
	static int grad_rect[2] = { 0, 1 };

	vtx = &axis[1];
	vtx->x = x + sx; vtx->y = y + sy;
	CnvRGB16( vtx, col2 );

	vtx = &axis[0];
	vtx->x = x; vtx->y = y;
	CnvRGB16( vtx, col1 );

	GradientFill( hdc, axis, 2, &grad_rect, 1, mode );
	Send( x,y,sx,sy );
#endif
}


void Bmscr::GradFillEx( int *vx, int *vy, int *vcol )
{
	//		�O���f�[�V�����h��Ԃ�(gsquare�p)
	//
#if 0
	TRIVERTEX axis[4];
	PTRIVERTEX vtx;
	int i;
	int minx,miny,maxx,maxy, ax,ay;
	static int grad_square[6] = { 0, 1, 2, 0, 2, 3 };
	minx = sx;
	miny = sy;
	maxx = maxy = 0;
	for(i=0;i<4;i++) {
		vtx = &axis[i];
		vtx->x = vx[i];
		if ( vtx->x < minx ) { minx = vtx->x; }
		if ( vtx->x > maxx ) { maxx = vtx->x; }
		vtx->y = vy[i];
		if ( vtx->y < miny ) { miny = vtx->y; }
		if ( vtx->y > maxy ) { maxy = vtx->y; }
		CnvRGB16( vtx, (DWORD)vcol[i] );
	}
	GradientFill( hdc, axis, 4, &grad_square, 2, GRADIENT_FILL_TRIANGLE );
	ax = maxx - minx + 1; ay = maxy - miny + 1;
	if (( ax > 0 )&&( ay > 0 )) { Send( minx,miny,ax,ay ); }
#endif
}


void Bmscr::FillRot( int x, int y, int dst_sx, int dst_sy, float ang )
{
	//		��]��`�h��Ԃ�(grect�p)
	//
	hgio_fillrot( (BMSCR *)this, (float)x, (float)y, (float)dst_sx, (float)dst_sy, ang );
}


void Bmscr::SetCelDivideSize( int new_divsx, int new_divsy, int new_ofsx, int new_ofsy )
{
	//		�Z�������T�C�Y��ݒ�
	//
	if ( new_divsx > 0 ) divsx = new_divsx; else divsx = sx;
	if ( new_divsy > 0 ) divsy = new_divsy; else divsy = sy;
	divx = sx / divsx;
	divy = sy / divsy;
	celofsx = new_ofsx;
	celofsy = new_ofsy;
}


int Bmscr::CelPut( Bmscr *src, int id, float destx, float desty, float ang )
{
	//		�Z�����R�s�[(�ϔ{�E��])
	//
	int xx,yy,texpx,texpy,psx,psy;
	int bak_cx, bak_cy;
	float dsx,dsy;

	psx = src->divsx;
	psy = src->divsy;
	xx = ( id % src->divx ) * psx;
	yy = ( id / src->divx ) * psy;
	texpx = xx + psx;
	texpy = yy + psy;
	if ( texpx < 0 ) return -1;
	if ( texpx >= src->sx ) {
		if ( xx >= src->sx ) return -1;
		psx = src->sx - xx;
	}
	if ( texpy < 0 ) return -1;
	if ( texpy >= src->sy ) {
		if ( yy >= src->sy ) return -1;
		psy = src->sy - yy;
	}

	dsx = (float)psx * destx;
	dsy = (float)psy * desty;

	bak_cx = cx + (int)dsx;
	bak_cy = cy;
	hgio_copyrot( (BMSCR *)this, xx, yy, psx, psy, src->celofsx, src->celofsy, (BMSCR *)src, dsx, dsy, ang );
	cx = bak_cx;
	cy = bak_cy;
	return 0;
}


int Bmscr::CelPut( Bmscr *src, int id )
{
	//		�Z�����R�s�[(�Œ�T�C�Y)
	//
	int xx,yy,texpx,texpy,psx,psy;
	int bak_cx, bak_cy;

	psx = src->divsx;
	psy = src->divsy;
	xx = ( id % src->divx ) * psx;
	yy = ( id / src->divx ) * psy;
	texpx = xx + psx;
	texpy = yy + psy;
	if ( texpx < 0 ) return -1;
	if ( texpx >= src->sx ) {
		if ( xx >= src->sx ) return -1;
		psx = src->sx - xx;
	}
	if ( texpy < 0 ) return -1;
	if ( texpy >= src->sy ) {
		if ( yy >= src->sy ) return -1;
		psy = src->sy - yy;
	}

	bak_cx = cx + psx;
	bak_cy = cy;
	cx -= src->celofsx;
	cy -= src->celofsy;
	hgio_copy( (BMSCR *)this, xx, yy, psx, psy, (BMSCR *)src, (float)psx, (float)psy );
	cx = bak_cx;
	cy = bak_cy;
	return 0;
}

