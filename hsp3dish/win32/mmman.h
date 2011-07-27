
//
//	mmman.cpp functions
//
#ifndef __mmman_h
#define __mmman_h

//	flags
//
enum
{
MMDATA_NONE = 0,
MMDATA_INTWAVE,
MMDATA_MCIVOICE,
MMDATA_CDAUDIO,
MMDATA_MCIVIDEO,
MMDATA_MPEGVIDEO,
MMDATA_MAX,
};

//	MMDATA structure
//
typedef struct MMM
{
	//	Multimedia Data structure
	//
	int		flag;			//	bank mode (0=none/1=wav/2=mid/3=cd/4=avi)
	int		opt;			//	option (0=none/1=loop/2=wait/16=fullscr)
	int		num;			//	request number
	short	track;			//	CD track No.
	short	lasttrk;		//	CD last track No.
	void	*mempt;			//	pointer to sound data
	char	*fname;			//	sound filename (sbstr)
} MMM;


//  class
class MMMan {
public:
	MMMan();
	~MMMan();

	void Reset( void *hwnd );
	void ClearAllBank( void );
	void DeleteBank( int bank );
	int AllocBank( void );
	int SearchBank( int num );
	MMM *SetBank( int num, int flag, int opt, void *mempt, char *fname );

	int SendMCI( char *mci_commands );
	char *GetMCIResult( void );

	int Load( char *fname, int bank, int opt );
	int Play( int bank );
	void Stop( void );
	void Notify( void );

	void GetInfo( int bank, char **fname, int *num, int *flag, int *opt );
	int GetBusy( void );
	void SetWindow( void *hwnd, int x, int y, int sx, int sy );
	int GetBankMax( void ) { return mm_cur;  };

private:
	int mm_cur;
	MMM *mem_snd;
	int curmus;			// current playing MIDI (-1=none)
	char res[256];
	void *hwm;
	void *avi_wnd;
	int	avi_x, avi_y,avi_sx,avi_sy;
	char avi_wh[64];
};


#endif
