
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <mmsystem.h>
#include <mmeapi.h>

#include <windows.h>

#include "pch.h"
#include "YM2149Lib.h"

#pragma comment(lib,"../StSoundLibrary/Release/StSoundLibrary.lib")

/*
*	Create
*/
YMMUSIC* YM_Init() {
	return ymMusicCreate();
}

/*
*	Destroy
*/
void YM_Destroy(YMMUSIC* pMusic) {
	ymMusicDestroy(pMusic);	
}

/*
*	Load from file
*/
bool YM_LoadFile(YMMUSIC* pMusic, const char* fName) {
	return ymMusicLoad(pMusic,fName);
}

/*
*	Load from Memory
*/
bool YM_LoadFromMemory(YMMUSIC* pMusic, void* pBlock, ymu32 size) {
	return ymMusicLoadMemory(pMusic,pBlock,size);
}

/*
*	Play (W.I.P)
*/
void YM_Play(YMMUSIC* pMusic) {
	ymMusicPlay(pMusic);
}

/*
*	Compute to PCM
*/
bool YM_ComputePCM(YMMUSIC* pMusic, ymsample* pBuffer, ymint nbSample) {
	return ymMusicCompute(pMusic, pBuffer, nbSample);
}

/*
*	Information
*/
void YM_Information(YMMUSIC* pMusic, ymMusicInfo_t* pInfo) {
	ymMusicGetInfo(pMusic,pInfo);
}

/*
*	LowpassFilter -- Enable / Disable
*/
void YM_LowpassFilter(YMMUSIC* pMusic, bool bActive) {
	ymMusicSetLowpassFiler(pMusic,bActive);
}


/*
*	Set Loop Mode
*/
void YM_SetLoopMode(YMMUSIC* pMusic, ymbool bLoop) {
	ymMusicSetLoopMode(pMusic,bLoop);
}

/*
*	Get Last Error
*/
const char* YM_GetLastError(YMMUSIC* pMusic) {
	return ymMusicGetLastError(pMusic);
}

/*
*	Get Register
*/
int YM_GetRegister(YMMUSIC* pMusic, ymint reg) {
	return ymMusicGetRegister(pMusic,reg);
}

/*
*	Pause
*/
void YM_Pause(YMMUSIC* pMusic) {
	ymMusicPause(pMusic);
}

/*
*	Stop
*/
void YM_Stop(YMMUSIC* pMusic) {
	ymMusicStop(pMusic);
}

/*
*	IsMusicOver
*/
bool YM_IsOver(YMMUSIC* pMusic) {
	return ymMusicIsOver(pMusic);
}

/*
*	Restart
*/
void YM_Restart(YMMUSIC* pMusic) {
	ymMusicRestart(pMusic);
}

/*
*	Is Seekable?
*/
bool YM_IsSeekable(YMMUSIC* pMusic) {
	return ymMusicIsSeekable(pMusic);
}

/*
*	Get Position
*/
ymu32 YM_GetPosition(YMMUSIC* pMusic) {
	return ymMusicIsSeekable(pMusic);
}

/*
*	Seek
*/
void YM_MusicSeek(YMMUSIC* pMusic,ymu32 timeInMs) {
	ymMusicSeek(pMusic,timeInMs);
}