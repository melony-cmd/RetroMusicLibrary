// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"

#include "AtariAudio/AtariMachine.h"
#include "AtariAudio/SndhFile.h"

SndhFile c_sndh;
AtariMachine c_atarimachine;

/*
 *  AtariMachine C __declspec(dllexport)
 */
extern "C" __declspec(dllexport) void AtariM_Startup(uint32_t hostReplayRate);

void AtariM_Startup(uint32_t hostReplayRate) {
    c_atarimachine.Startup(hostReplayRate);   
    return;
}

/*
 *  SndhFile C __declspec(dllexport)
 */
extern "C" __declspec(dllexport) bool SNDH_Load(const void* rawSndhFile, int sndhFileSize, uint32_t hostReplayRate);
extern "C" __declspec(dllexport) void SNDH_Unload();
extern "C" __declspec(dllexport) bool SNDH_InitSubSong(int subSongId);
extern "C" __declspec(dllexport) int SNDH_AudioRender(int16_t * buffer, int count, uint32_t * pSampleViewInfo);

extern "C" __declspec(dllexport) int SNDH_GetSubsongCount();
extern "C" __declspec(dllexport) int SNDH_GetDefaultSubsong();
extern "C" __declspec(dllexport) bool SNDH_GetSubsongInfo(int subSongId, SndhFile::SubSongInfo &info);

extern "C" __declspec(dllexport) const void *SNDH_GetRawData();
extern "C" __declspec(dllexport) int SNDH_GetRawDataSize();

int SNDH_GetSubsongCount() {
    return c_sndh.GetSubsongCount();
}

int SNDH_GetDefaultSubsong() {
    return c_sndh.GetDefaultSubsong();
}

//bool SNDH_GetSubsongInfo(int subSongId, SubSongInfo & out) {
bool SNDH_GetSubsongInfo(int subSongId, SndhFile::SubSongInfo &info) {
    return c_sndh.GetSubsongInfo(subSongId,info);
}

const void *SNDH_GetRawData() {
    return c_sndh.GetRawData();
}

int SNDH_GetRawDataSize() {
    return c_sndh.GetRawDataSize();
}

void SNDH_Unload() {
    c_sndh.Unload();
    return;
}

bool SNDH_Load(const void* rawSndhFile, int sndhFileSize, uint32_t hostReplayRate) {
    return c_sndh.Load(rawSndhFile, sndhFileSize, hostReplayRate);
}

bool SNDH_InitSubSong(int subSongId) {
    return c_sndh.InitSubSong(subSongId);
}

int SNDH_AudioRender(int16_t* buffer, int count, uint32_t* pSampleViewInfo = NULL) {
    return c_sndh.AudioRender(buffer, count, pSampleViewInfo);
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

