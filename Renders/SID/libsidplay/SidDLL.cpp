/* Proper C Function Exports */

#include "SidDLL.h"

SidInfoImpl		c_SidInfoImpl;
sidplayfp		c_sidplayfp;
SidTune		   *c_tune;
SidTuneInfo	   *c_tuneinfo;

/******************************************************************************
 * SidConfig.h
 ******************************************************************************/

/**
 * Intended c64 model when unknown or forced.
 */
extern "C" __declspec(dllexport) void SidConfig_SetDefaultC64Model(SidConfig::c64_model_t c_defaultC64Model) {
	SidConfig::c64_model_t defaultC64Model = c_defaultC64Model;
}

/**
 * Force the model to #defaultC64Model ignoring tune's clock setting.
 */
extern "C" __declspec(dllexport) void SidConfig_SetForceC64Model(bool forceC64Model) {
}

/**
 * Intended sid model when unknown or forced.
 */
extern "C" __declspec(dllexport) void SidConfig_SetDefaultSidModel(SidConfig::sid_model_t c_defaultSidModel) {
	SidConfig::sid_model_t defaultSidModel = c_defaultSidModel;
}

/**
 * Force the sid model to #defaultSidModel.
 */
extern "C" __declspec(dllexport) void SidConfig_SetForceSidModel(bool forceSidModel) {
}

/**
 * Enable digiboost when 8580 SID model is used.
 */
extern "C" __declspec(dllexport) void SidConfig_SetDigiBoost(bool digiBoost) {
}

/**
 * Intended cia model.
 */
extern "C" __declspec(dllexport) void SidConfig_SetCIAModel(SidConfig::cia_model_t c_ciaModel) {
	SidConfig::cia_model_t ciaModel = c_ciaModel;
}

/**
 * Playbak mode.
 */
extern "C" __declspec(dllexport) void SidConfig_SetPlayBack(SidConfig::playback_t c_playback) {
	SidConfig::playback_t playback = c_playback;
}

/**
 * Sampling frequency.
 */
extern "C" __declspec(dllexport) void SidConfig_SetFrequency(uint_least32_t frequency) {
}

/**
 * Extra SID chips addresses.
 */
extern "C" __declspec(dllexport) void SidConfig_SetSecondSidAddress(uint_least16_t secondSidAddress) {
}

/**
 * Extra SID chips addresses.
 */
extern "C" __declspec(dllexport) void SidConfig_SetThirdSidAddress(uint_least16_t thirdSidAddress) {
}

/**
 * Pointer to selected emulation,
 * reSIDfp, reSID, hardSID or exSID.
 */
extern "C" __declspec(dllexport) void SidConfig_SetSidEmulation(sidbuilder * sidEmulation) {
}

/**
 * Left channel volume.
 */
extern "C" __declspec(dllexport) void SidConfig_SetLeftVolume(uint_least32_t leftVolume) {
}

/**
 * Right channel volume.
 */
extern "C" __declspec(dllexport) void SidConfig_SetRightVolume(uint_least32_t rightVolume) {
}

/**
 * Power on delay cycles.
 */
extern "C" __declspec(dllexport) void SidConfig_SetPowerOnDelay(uint_least32_t delay) {
}

/**
 * Sampling method.
 */
extern "C" __declspec(dllexport) void SidConfig_SetSamplingMethod(SidConfig::sampling_method_t samplingMethod) {
	SidConfig::sampling_method_t sampling_method = samplingMethod;
}

/**
 * Faster low-quality emulation,
 * available only for reSID.
 */
extern "C" __declspec(dllexport) void SidConfig_SetFastSampling(bool fastSampling) {
}

/******************************************************************************
 * SidInfo.h
 ******************************************************************************/

/// Library name
//const char* name() const;
extern "C" __declspec(dllexport) const char * SidInfo_LibraryName() {
	return c_SidInfoImpl.name();
}

/// Library version
//const char* version() const;
extern "C" __declspec(dllexport) const char * SidInfo_Version() {
	return c_SidInfoImpl.getVersion();
}

/// Library credits
extern "C" __declspec(dllexport) unsigned int SidInfo_NumberOfCredits() {
	return c_SidInfoImpl.getNumberOfCredits();
}
extern "C" __declspec(dllexport) const char *SidInfo_Credits(unsigned int i) {
	return c_SidInfoImpl.getCredits(i);
}

/// Number of SIDs supported by this library
//unsigned int maxsids() const;
extern "C" __declspec(dllexport) unsigned int SidInfo_MaxSIDS() {
	return c_SidInfoImpl.maxsids();
}

/// Number of output channels (1-mono, 2-stereo)
extern "C" __declspec(dllexport) unsigned int SidInfo_Channels(void) {
	return c_SidInfoImpl.getChannels();
}

/// Address of the driver
extern "C" __declspec(dllexport) uint_least16_t SidInfo_DriverAddr(void) {
	return c_SidInfoImpl.getDriverAddr();
}

/// Size of the driver in bytes
extern "C" __declspec(dllexport) uint_least16_t SidInfo_DriverLength(void) {
	return c_SidInfoImpl.getDriverLength();
}

/// Power on delay
//uint_least16_t powerOnDelay() const;
extern "C" __declspec(dllexport) uint_least16_t SidInfo_PownOnDelay(void) {
	return c_SidInfoImpl.getPowerOnDelay();
}

/// Describes the speed current song is running at
extern "C" __declspec(dllexport) const char* SidInfo_SpeedString(void) {
	return c_SidInfoImpl.getSpeedString();
}

/// Description of the laoded ROM images
extern "C" __declspec(dllexport) const char* SidInfo_KernalDesc(void) {
	return c_SidInfoImpl.getKernalDesc();
}

extern "C" __declspec(dllexport) const char* SidInfo_BasicDesc() {
	return c_SidInfoImpl.getBasicDesc();
}

extern "C" __declspec(dllexport) const char* SidInfo_ChargenDesc() {
	return c_SidInfoImpl.getChargenDesc();
}

/******************************************************************************
 *  SidPlayFP.h
 ******************************************************************************/

 /**
  * Get the current engine configuration.
  *
  * @return a const reference to the current configuration.
  */
extern "C" __declspec(dllexport) const SidConfig & SidPlayFP_GetConfig(void) {
	return c_sidplayfp.config();
}

/**
 * Get the current player informations.
 *
 * @return a const reference to the current info.
 */
extern "C" __declspec(dllexport) const SidInfo & SidPlayFP_Information(void) {
	return c_sidplayfp.info();
}

/**
 * Configure the engine.
 * Check #error for detailed message if something goes wrong.
 *
 * @param cfg the new configuration
 * @return true on success, false otherwise.
 */
extern "C" __declspec(dllexport) bool SidPlayFP_SetConfig(const SidConfig & cfg) {
	return c_sidplayfp.config(cfg);
}

/**
 * Error message.
 *
 * @return string error message.
 */
extern "C" __declspec(dllexport) const char * SidPlayFP_Error(void) {
	return c_sidplayfp.error();
}

/**
 * Set the fast-forward factor.
 *
 * @param percent
 */
extern "C" __declspec(dllexport) bool SidPlayFP_FastForward(unsigned int percent) {
	return c_sidplayfp.fastForward(percent);
}

/**
 * Load a tune.
 * Check #error for detailed message if something goes wrong.
 *
 * @param tune the SidTune to load, 0 unloads current tune.
 * @return true on sucess, false otherwise.
 */
extern "C" __declspec(dllexport) bool SidPlayFP_Load(SidTune *tune) {
	return c_sidplayfp.load(tune);
}

/**
 * Run the emulation and produce samples to play if a buffer is given.
 *
 * @param buffer pointer to the buffer to fill with samples.
 * @param count the size of the buffer measured in 16 bit samples
 *              or 0 if no output is needed (e.g. Hardsid)
 * @return the number of produced samples. If less than requested
 *         and #isPlaying() is true an error occurred, use #error()
 *         to get a detailed message.
 */
extern "C" __declspec(dllexport) uint_least32_t SidPlayFP_Play(short* buffer, uint_least32_t count) {
	return c_sidplayfp.play(buffer,count);
}

/**
 * Check if the engine is playing or stopped.
 *
 * @return true if playing, false otherwise.
 */
extern "C" __declspec(dllexport) bool SidPlayFP_isPlayering(void) {
	return c_sidplayfp.isPlaying();
}

/**
 * Stop the engine.
 */
extern "C" __declspec(dllexport) void SidPlayFP_Stop(void) {
	return c_sidplayfp.stop();
}

/**
 * Control debugging.
 * Only has effect if library have been compiled
 * with the --enable-debug option.
 *
 * @param enable enable/disable debugging.
 * @param out the file where to redirect the debug info.
 */
extern "C" __declspec(dllexport) void SidPlayFP_Debug(bool enable, FILE * out) {
	return c_sidplayfp.debug(enable,out);
}

/**
 * Mute/unmute a SID channel.
 *
 * @param sidNum the SID chip, 0 for the first one, 1 for the second.
 * @param voice the channel to mute/unmute.
 * @param enable true unmutes the channel, false mutes it.
 */
extern "C" __declspec(dllexport) void SidPlayFP_Mute(unsigned int sidNum, unsigned int voice, bool enable) {
	return c_sidplayfp.mute(sidNum, voice, enable);
}

/**
 * Get the current playing time.
 *
 * @return the current playing time measured in seconds.
 */
extern "C" __declspec(dllexport) uint_least32_t SidPlayFP_Time() {
	return c_sidplayfp.time();
}

/**
 * Get the current playing time.
 *
 * @return the current playing time measured in milliseconds.
 * @since 2.0
 */
extern "C" __declspec(dllexport) uint_least32_t SidPlayFP_TimeMs() {
	return c_sidplayfp.timeMs();
}

/**
 * Set ROM images.
 *
 * @param kernal pointer to Kernal ROM.
 * @param basic pointer to Basic ROM, generally needed only for BASIC tunes.
 * @param character pointer to character generator ROM.
 */
extern "C" __declspec(dllexport) void SidPlayFP_SetRoms(const uint8_t * kernal, const uint8_t * basic = 0, const uint8_t * character = 0) {
	return c_sidplayfp.setRoms(kernal,basic,character);
}

/**
 * Set the ROM banks.
 *
 * @param rom pointer to the ROM data.
 * @since 2.2
 */
extern "C" __declspec(dllexport) void SidPlayFP_SetKernal(const uint8_t * rom) {
	return c_sidplayfp.setKernal(rom);
}
extern "C" __declspec(dllexport) void SidPlayFP_SetBasic(const uint8_t * rom) {
	return c_sidplayfp.setBasic(rom);
}
extern "C" __declspec(dllexport) void SidPlayFP_SetChargen(const uint8_t * rom) {
	return c_sidplayfp.setChargen(rom);
}

/**
 * Get the CIA 1 Timer A programmed value.
 */
extern "C" __declspec(dllexport) uint_least16_t SidPlayFP_GetCia1TimerA() {
	return c_sidplayfp.getCia1TimerA();
}

/**
 * Get the SID registers programmed value.
 *
 * @param sidNum the SID chip, 0 for the first one, 1 for the second and 2 for the third.
 * @param regs an array that will be filled with the last values written to the chip.
 * @return false if the requested chip doesn't exist.
 * @since 2.2
 */
//bool getSidStatus(unsigned int sidNum, uint8_t regs[32]);
extern "C" __declspec(dllexport) bool SidPlayFP_GetSidStatus(unsigned int sidNum, uint8_t regs[32]) {
	return c_sidplayfp.getSidStatus(sidNum, regs);
}

/******************************************************************************
 *  SidTune.h
 ******************************************************************************/
/**
* Load a sidtune from a file.
*
* To retrieve data from standard input pass in filename "-".
* If you want to override the default filename extensions use this
* contructor. Please note, that if the specified "fileName"
* does exist and the loader is able to determine its file format,
* this function does not try to append any file name extension.
* See "SidTune.cpp" for the default list of file name extensions.
* You can specify "fileName = 0", if you do not want to
* load a sidtune. You can later load one with open().
*
* @param fileName
* @param fileNameExt
* @param separatorIsSlash
*/
extern "C" __declspec(dllexport) void SidTune_LoadFromFile(const char* fileName, const char** fileNameExt = 0, bool separatorIsSlash = false) {
	SidTune(fileName,fileNameExt,separatorIsSlash);
}

/**
 * Load a sidtune from a file, using a file access callback.
 *
 * This function does the same as the above, except that it
 * accepts a callback function, which will be used to read
 * all files it accesses.
 *
 * @param loader
 * @param fileName
 * @param fileNameExt
 * @param separatorIsSlash
 */
extern "C" __declspec(dllexport) void SidTune_LoadFromCallBack(SidTune::LoaderFunc loader, const char* fileName, const char** fileNameExt = 0, bool separatorIsSlash = false) {
	SidTune(loader,fileName,fileNameExt,separatorIsSlash);
}

/**
	 * Load a single-file sidtune from a memory buffer.
	 * Currently supported: PSID and MUS formats.
	 *
	 * @param oneFileFormatSidtune the buffer that contains song data
	 * @param sidtuneLength length of the buffer
	 */
extern "C" __declspec(dllexport) void SidTune_LoadFromMemory(const uint_least8_t * oneFileFormatSidtune, uint_least32_t sidtuneLength) {
	SidTune(oneFileFormatSidtune,sidtuneLength);
}

/**
 * The SidTune class does not copy the list of file name extensions,
 * so make sure you keep it. If the provided pointer is 0, the
 * default list will be activated. This is a static list which
 * is used by all SidTune objects.
 *
 * @param fileNameExt
 */
extern "C" __declspec(dllexport) void SidTune_SetFileNameExtensions(const char** fileNameExt) {
}

/**
 * Load a sidtune into an existing object from a file.
 *
 * @param fileName
 * @param separatorIsSlash
 */
extern "C" __declspec(dllexport) void SidTune_LoadObject(const char* fileName, bool separatorIsSlash = false) {
}

/**
 * Load a sidtune into an existing object from a file,
 * using a file access callback.
 *
 * @param loader
 * @param fileName
 * @param separatorIsSlash
 */
extern "C" __declspec(dllexport) void SidTune_LoadObjectCallBack(SidTune::LoaderFunc loader, const char* fileName, bool separatorIsSlash = false) {
}

/**
 * Load a sidtune into an existing object from a buffer.
 *
 * @param sourceBuffer the buffer that contains song data
 * @param bufferLen length of the buffer
 */
extern "C" __declspec(dllexport) void SidTune_Read(const uint_least8_t * sourceBuffer, uint_least32_t bufferLen) {
}

/**
 * Select sub-song.
 *
 * @param songNum the selected song (0 = default starting song)
 * @return active song number, 0 if no tune is loaded.
 */
extern "C" __declspec(dllexport) void SidTune_SelectSong(unsigned int songNum) {
}

/**
 * Retrieve current active sub-song specific information.
 *
 * @return a pointer to #SidTuneInfo, 0 if no tune is loaded. The pointer must not be deleted.
 */
//extern "C" __declspec(dllexport) SidTuneInfo * SidTune_GetInfo() {
//	return;
//}

/**
 * Select sub-song and retrieve information.
 *
 * @param songNum the selected song (0 = default starting song)
 * @return a pointer to #SidTuneInfo, 0 if no tune is loaded. The pointer must not be deleted.
 */
//extern "C" __declspec(dllexport) SidTuneInfo * SidTune_GetInfo(unsigned int songNum) {
//}


/**
 * Determine current state of object.
 * Upon error condition use #statusString to get a descriptive
 * text string.
 *
 * @return current state (true = okay, false = error)
 */
 //extern "C" __declspec(dllexport) bool SidTune_GetStatus(unsigned int songNum) {
 //}

/**
 * Error/status message of last operation.
 */
 //extern "C" __declspec(dllexport) char * SidTune_StatusString() {
 //}

/**
 * Copy sidtune into C64 memory (64 KB).
 */
 //extern "C" __declspec(dllexport) bool SidTune_PlaceSidTuneInC64mem(libsidplayfp::sidmemory& mem) {
 //}

/**
 * Calculates the MD5 hash of the tune, old method.
 * Not providing an md5 buffer will cause the internal one to be used.
 * If provided, buffer must be MD5_LENGTH + 1
 *
 * @return a pointer to the buffer containing the md5 string, 0 if no tune is loaded.
 */
 //extern "C" __declspec(dllexport) const char * SidTune_CreateMD5(char* md5 = 0) {
 //}

/**
 * Calculates the MD5 hash of the tune, new method, introduced in HVSC#68.
 * Not providing an md5 buffer will cause the internal one to be used.
 * If provided, buffer must be MD5_LENGTH + 1
 *
 * @return a pointer to the buffer containing the md5 string, 0 if no tune is loaded.
 */
 //extern "C" __declspec(dllexport) const char * SidTune_CreateMD5New(char* md5 = 0) {
 //}

/******************************************************************************
 *  SidTuneInfo.h
 ******************************************************************************/
 /**
  * Load Address.
  */
//extern "C" __declspec(dllexport) uint_least16_t SidTuneInfo_LoadAddr(void) {
//}

/**
 * Init Address.
 */
//extern "C" __declspec(dllexport) uint_least16_t SidTuneInfo_InitAddr(void) {
// }

/**
 * Play Address.
 */
//extern "C" __declspec(dllexport) uint_least16_t SidTuneInfo_PlayAddr(void) {
// }

/**
 * The number of songs.
 */
//extern "C" __declspec(dllexport) unsigned int SidTuneInfo_Songs(void) {
// }

/**
 * The default starting song.
 */
//extern "C" __declspec(dllexport) unsigned int SidTuneInfo_StartSong(void) {
// }

/**
 * The tune that has been initialized.
 */
//extern "C" __declspec(dllexport) unsigned int SidTuneInfo_CurrentSong(void) {
// }

/**
 * @name Base addresses
 * The SID chip base address(es) used by the sidtune.
 * - 0xD400 for the 1st SID
 * - 0 if the nth SID is not required
 */
//extern "C" __declspec(dllexport) uint_least16_t SidTuneInfo_SidChipBase(unsigned int i) {
// }

/**
 * The number of SID chips required by the tune.
 */
//extern "C" __declspec(dllexport) int SidTuneInfo_SidChips(void) {
// }

/**
 * Intended speed.
 */
//extern "C" __declspec(dllexport) int SidTuneInfo_SongSpeed(void) {
// }

/**
 * First available page for relocation.
 */
//extern "C" __declspec(dllexport) uint_least8_t SidTuneInfo_RelocStartPage(void) {
// }

/**
 * Number of pages available for relocation.
 */
//extern "C" __declspec(dllexport) uint_least8_t SidTuneInfo_RelocPages(void) {
// }

/**
 * @name SID model
 * The SID chip model(s) requested by the sidtune.
 */
//extern "C" __declspec(dllexport) model_t SidTuneInfo_SidModel(unsigned int i) {
// }

/**
 * Compatibility requirements.
 */
//extern "C" __declspec(dllexport) compatibility_t SidTuneInfo_Compatibility(void) {
// }

/**
 * @name Tune infos
 * Song title, credits, ...
 * - 0 = Title
 * - 1 = Author
 * - 2 = Released
 */
//extern "C" __declspec(dllexport) unsigned int SidTuneInfo_NumberOfInfoStrings(void) { ///< The number of available text info lines
// }
//extern "C" __declspec(dllexport) const char * SidTuneInfo_InfoString(unsigned int i) { ///< Text info from the format headers etc.
// }

/**
 * @name Tune comments
 * MUS comments.
 */
//extern "C" __declspec(dllexport) unsigned int SidTuneInfo_NumberOfCommentStrings(void) {
// }
//extern "C" __declspec(dllexport) const char* SidTuneInfo_CommentString(unsigned int i) {
// }
//extern "C" __declspec(dllexport) const char* SidTuneInfo_MusString(void) {
// }

/**
 * Length of single-file sidtune file.
 */
//extern "C" __declspec(dllexport) uint_least32_t SidTuneInfo_DataFileLen(void) {
// }

/**
 * Length of raw C64 data without load address.
 */
//extern "C" __declspec(dllexport) uint_least32_t SidTuneInfo_C64dataLen(void) {
// }

/**
 * The tune clock speed.
 */
//extern "C" __declspec(dllexport) clock_t SidTuneInfo_ClockSpeed(void) {
// }

/**
 * The name of the identified file format.
 */
//extern "C" __declspec(dllexport) const char * SidTuneInfo_FormatString(void) {
// }

/**
 * Whether load address might be duplicate.
 */
//extern "C" __declspec(dllexport) bool SidTuneInfo_FixLoad(void) {
// }

/**
 * Path to sidtune files.
 */
//extern "C" __declspec(dllexport) const char * SidTuneInfo_Path(void) {
// }

/**
 * A first file: e.g. "foo.sid" or "foo.mus".
 */
//extern "C" __declspec(dllexport) const char * SidTuneInfo_DataFileName(void) {
// }

/**
 * A second file: e.g. "foo.str".
 * Returns 0 if none.
 */
//extern "C" __declspec(dllexport) const char * SidTuneInfo_InfoFileName(void) {
// }
