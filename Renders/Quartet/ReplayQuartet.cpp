#include "ReplayQuartet.h"
#include "zingzong/src/zingzong.h"
#include "zingzong/src/zz_def.h"
#include "zingzong/src/zz_private.h"

extern "C" __declspec(dllexport) const char* quartet_core_version(void);
extern "C" __declspec(dllexport) uint8_t quartet_core_mute(zz_core_t K, uint8_t clr, uint8_t set);
extern "C" __declspec(dllexport) zz_err_t quartet_core_init(zz_core_t core, zz_mixer_t mixer, zz_u32_t spr);
extern "C" __declspec(dllexport) void quartet_core_kill(zz_core_t core);
extern "C" __declspec(dllexport) zz_err_t quartet_core_tick(zz_core_t const core);
extern "C" __declspec(dllexport) zz_i16_t quartet_core_play(zz_core_t core, void* pcm, zz_i16_t n);
extern "C" __declspec(dllexport) zz_u32_t quartet_core_blend(zz_core_t core, zz_u8_t map, zz_u16_t lr8);
extern "C" __declspec(dllexport) zz_u8_t quartet_log_bit(const zz_u8_t clr, const zz_u8_t set);
extern "C" __declspec(dllexport) void quartet_log_fun(zz_log_t func, void* user);
extern "C" __declspec(dllexport) void quartet_mem(zz_new_t newf, zz_del_t delf);
extern "C" __declspec(dllexport) zz_err_t quartet_new(zz_play_t* pplay);
extern "C" __declspec(dllexport) void quartet_del(zz_play_t* pplay);
extern "C" __declspec(dllexport) zz_err_t quartet_load(zz_play_t const play, const char* song, const char* vset, zz_u8_t* pfmt);
extern "C" __declspec(dllexport) zz_err_t quartet_close(zz_play_t const play);
extern "C" __declspec(dllexport) zz_err_t quartet_info(zz_play_t play, zz_info_t* pinfo);
extern "C" __declspec(dllexport) zz_err_t quartet_init(zz_play_t play, zz_u16_t rate, zz_u32_t ms);
extern "C" __declspec(dllexport) zz_err_t quartet_setup(zz_play_t play, zz_u8_t mixer, zz_u32_t spr);
extern "C" __declspec(dllexport) zz_err_t quartet_tick(zz_play_t play);
extern "C" __declspec(dllexport) zz_i16_t quartet_play(zz_play_t play, void* pcm, zz_i16_t n);
extern "C" __declspec(dllexport) zz_u32_t quartet_position(zz_play_t play);
extern "C" __declspec(dllexport) zz_u8_t quartet_mixer_info(zz_u8_t id, const char** pname, const char** pdesc);

/*
*/
extern "C" __declspec(dllexport) int q_song_load(song_t * song, const char* uri) {
	return song_load(song,uri);
}

const char* quartet_core_version(void) {
	return zz_core_version();
}

uint8_t quartet_core_mute(zz_core_t K, uint8_t clr, uint8_t set){
	return zz_core_mute(K, clr, set);
}

zz_err_t quartet_core_init(zz_core_t core, zz_mixer_t mixer, zz_u32_t spr){
	return zz_core_init(core, mixer, spr);
}

void quartet_core_kill(zz_core_t core){
	zz_core_kill(core);
}

zz_err_t quartet_core_tick(zz_core_t const core){
	return zz_core_tick(core);
}

zz_i16_t quartet_core_play(zz_core_t core, void* pcm, zz_i16_t n){
	return zz_core_play(core, pcm, n);
}

zz_u32_t quartet_core_blend(zz_core_t core, zz_u8_t map, zz_u16_t lr8){
	return zz_core_blend(core,map,lr8);
}

zz_u8_t quartet_log_bit(const zz_u8_t clr, const zz_u8_t set){
	return zz_log_bit(clr,set);
}

void quartet_log_fun(zz_log_t func, void* user){
	zz_log_fun(func, user);
}

void quartet_mem(zz_new_t newf, zz_del_t delf){
	zz_mem(newf, delf);
}

zz_err_t quartet_new(zz_play_t * pplay){
	return zz_new(pplay);
}

void quartet_del(zz_play_t * pplay){
	zz_del(pplay);
}

zz_err_t quartet_load(zz_play_t const play, const char* song, const char* vset, zz_u8_t * pfmt){
	return zz_load(play,song,vset,pfmt);
}

zz_err_t quartet_close(zz_play_t const play){
	return zz_close(play);
}

zz_err_t quartet_info(zz_play_t play, zz_info_t * pinfo){
	return zz_info(play, pinfo);
}

zz_err_t quartet_init(zz_play_t play, zz_u16_t rate, zz_u32_t ms){
	return zz_init(play,rate,ms);
}

zz_err_t quartet_setup(zz_play_t play, zz_u8_t mixer, zz_u32_t spr){
	return zz_setup(play,mixer,spr);
}

zz_err_t quartet_tick(zz_play_t play){
	return zz_tick(play);
}

zz_i16_t quartet_play(zz_play_t play, void* pcm, zz_i16_t n){
	return zz_play(play,pcm,n);
}

zz_u32_t quartet_position(zz_play_t play){
	return zz_position(play);
}

zz_u8_t quartet_mixer_info(zz_u8_t id, const char** pname, const char** pdesc){
	return zz_mixer_info(id,pname,pdesc);
}
