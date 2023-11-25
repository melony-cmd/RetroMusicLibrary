#pragma once
#include <stdio.h>
#include <mmeapi.h>

#include "../StSoundLibrary/StSoundLibrary.h"

#ifdef YM2149LIBRARY_EXPORTS
	#define YM2149LIBRARY_API __declspec(dllexport)
#else
	#define YM2149LIBRARY_API __declspec(dllimport)
#endif

extern "C" __declspec(dllexport) YMMUSIC * YM_Init();
extern "C" __declspec(dllexport) void YM_Destroy(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) bool YM_LoadFile(YMMUSIC* pMusic, const char* fName);
extern "C" __declspec(dllexport) bool YM_LoadFromMemory(YMMUSIC * pMusic, void* pBlock, ymu32 size);
extern "C" __declspec(dllexport) void YM_Play(YMMUSIC* pMusic);
extern "C" __declspec(dllexport) bool YM_ComputePCM(YMMUSIC * pMusic, ymsample * pBuffer, ymint nbSample);
extern "C" __declspec(dllexport) void YM_Information(YMMUSIC * pMusic, ymMusicInfo_t * pInfo);
extern "C" __declspec(dllexport) void YM_LowpassFilter(YMMUSIC * pMusic, bool bActive);
extern "C" __declspec(dllexport) void YM_SetLoopMode(YMMUSIC * pMusic, ymbool bLoop);
extern "C" __declspec(dllexport) const char* YM_GetLastError(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) int YM_GetRegister(YMMUSIC * pMusic, ymint reg);
extern "C" __declspec(dllexport) void YM_Pause(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) void YM_Stop(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) bool YM_IsOver(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) void YM_Restart(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) bool YM_IsSeekable(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) ymu32 YM_GetPosition(YMMUSIC * pMusic);
extern "C" __declspec(dllexport) void YM_MusicSeek(YMMUSIC * pMusic, ymu32 timeInMs);
