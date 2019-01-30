#include "env.h"			//for TRACE
#include "AudioSystem.h"
#include <fmod_errors.h>    //for FMOD_ErrorString()

Sample::Sample():
	name(""),
	sample(NULL),
	channel(NULL),
	loop(false), paused(false)
{
}

Sample::~Sample()
{
	if (sample != NULL) {
		FMOD_Sound_Release(sample);
		sample = NULL;
	}
}

/**
    volume is based on 1.0 = 100%
**/
void Sample::SetVolume(float volume)
{
	ASSERT(sample);

    //perform a reasonable bounds check
    if (volume < 0.0f || volume > 10.0f) return;

    float freq, vol, pan;
    int prior;
    FMOD_Sound_GetDefaults(sample, &freq, &vol, &pan, &prior);

    //send values with new volume
    FMOD_Sound_SetDefaults(sample, freq, volume, pan, prior);
}

/* 
 * put a channel into looping/non-looping state
 * 
 * doLoop == false --> oneshot playback
 * doLoop == true  --> playback will loop forever
 *
 * you only call this *after* you've called AudioSystem::Play/PlayMusic
 */
void Sample::SetLoop(bool doLoop)
{
	loop = doLoop;
	FMOD_RESULT res;

	ASSERT(sample);
	ASSERT(channel);
	
	if (loop) {
		res = FMOD_Channel_SetMode(channel, FMOD_DEFAULT|FMOD_LOOP_NORMAL);
		ASSERT(res==FMOD_OK);

		//fmod use -1 for infinite looping
		res = FMOD_Channel_SetLoopCount(channel, -1);
		ASSERT(res==FMOD_OK);
	}
	else {
		res = FMOD_Channel_SetMode(channel, FMOD_DEFAULT|FMOD_LOOP_OFF);
		ASSERT(res==FMOD_OK);

		res = FMOD_Channel_SetLoopCount(channel, 0);
		ASSERT(res==FMOD_OK);
	}
}

/*
 * pause/unpause a channel
 *
 * you only call this *after* you've called AudioSystem::Play/PlayMusic
 */
void Sample::SetPaused(bool doPause)
{
	ASSERT(sample);
	ASSERT(channel);
	paused = doPause;

	FMOD_RESULT res = FMOD_Channel_SetPaused(channel, paused);
	if(res != FMOD_OK)
		TRACE("Audiosystem: FMOD_Channel_SetPaused return value was not FMOD_OK but %d\n", res);
}

AudioSystem::AudioSystem(void)
{
	system = NULL;
}

AudioSystem::~AudioSystem(void)
{
	//release all samples
	for (SampleIterator i = samples.begin(); i != samples.end(); ++i)
	{
		(*i) = NULL;
	}

	FMOD_System_Release(system);
}

bool AudioSystem::Init()
{
	//retrieve global music playback setting
	bPlay = g_game->getGlobalBoolean("AUDIO_GLOBAL");

	FMOD_RESULT result;

	result = FMOD_System_Create(&system);
	if (result != FMOD_OK) {
		TRACE("AudioSystem::Init\tFMOD_System_Create issue. (%d) %s\n", result, FMOD_ErrorString(result));
		return false;
	}

	//if we don't wan't audio, set output mode to FMOD_OUTPUTTYPE_NOSOUND
	if (!bPlay) {
		result = FMOD_System_SetOutput(system, FMOD_OUTPUTTYPE_NOSOUND);
		if (result != FMOD_OK) { 
			TRACE("AudioSystem::Init\tUnable to set output mode to FMOD_OUTPUTTYPE_NOSOUND (%d) %s\n", result, FMOD_ErrorString(result));
			return false;
		}
	}


	result = FMOD_System_Init(system,100,FMOD_INIT_NORMAL,NULL);
	if (result != FMOD_OK) {
		TRACE("AudioSystem::Init\tFMOD_System_Init issue. (%d) %s\n", result, FMOD_ErrorString(result));

		//Trying again with sound disabled, unless we already tried that as a result of global settings
		if(!bPlay) return false;
		
		TRACE("AudioSystem::Init\tTrying again with sound disabled\n");

		result = FMOD_System_SetOutput(system, FMOD_OUTPUTTYPE_NOSOUND);
		if (result != FMOD_OK) { 
			TRACE("AudioSystem::Init\tUnable to set output mode to FMOD_OUTPUTTYPE_NOSOUND (%d) %s\n", result, FMOD_ErrorString(result));
			return false;
		}

		result = FMOD_System_Init(system,100,FMOD_INIT_NORMAL,NULL);
		if (result != FMOD_OK) {
			TRACE("AudioSystem::Init\tUnable to initialize FMOD, even in FMOD_OUTPUTTYPE_NOSOUND mode. (%d) %s\n", result, FMOD_ErrorString(result));
			return false;
		}
	}

	return true;
}

void AudioSystem::Update()
{
	FMOD_System_Update(system);
}


Sample* AudioSystem::Load(std::string filename, float volume)
{
	if (filename.length() == 0) return false;

	Sample *sample = NULL;
    sample = new Sample();

	try {
		FMOD_RESULT res = FMOD_System_CreateSound(system, filename.c_str(), FMOD_DEFAULT, NULL, &sample->sample);
		if (res != FMOD_OK) {
			sample = NULL;
		}
	} catch (...) {
		sample = NULL;
	}
	ASSERT(sample);
	ASSERT(sample->sample);

	sample->SetVolume(volume);
	return sample;
}

bool AudioSystem::Load(std::string filename, std::string name, float volume)
{
	if (filename.length() == 0 || name.length() == 0) return false;

	Sample *sample = NULL;
    sample = new Sample();
	sample->setName(name);

	try {
		FMOD_RESULT res = FMOD_System_CreateSound(system, filename.c_str(), FMOD_DEFAULT, NULL, &sample->sample);
		if (res != FMOD_OK) {
			TRACE("AudioSystem::Load\tCould not load %s, string %s\n", filename.c_str(), name.c_str());
			return false;
		}
	} catch (...) {
		TRACE("AudioSystem::Load\tCould not load %s, string %s\n", filename.c_str(), name.c_str());
		return false;
	}
	ASSERT(sample);
	ASSERT(sample->sample);
	
	sample->SetVolume(volume);
	samples.push_back(sample);

	return true;
}

Sample* AudioSystem::LoadMusic(std::string filename, float volume)
{
	return Load(filename, volume);
}

bool AudioSystem::LoadMusic(std::string filename, std::string name, float volume)
{
	return Load(filename, name, volume);
}

bool AudioSystem::SampleExists(std::string name)
{
	for (SampleIterator i = samples.begin(); i != samples.end(); ++i)
	{
		if ((*i)->getName() == name)
		{
			return true;
		}
	}

	return false;
}

//FMOD_Channel_IsPlaying is broken (causes stack corruption on windows).
//We don't know as of yet if we are the one to blame for that breakage or if this
//is caused by either fmod or one of the things that fmod use.
//We make this function inconditionally returns false for the time being since this
//is known to work for everything but looping music, which we now handle with fmod
//builtin looping so that it does not rely on a working IsPlaying.
bool AudioSystem::IsPlaying(std::string name)
{
	return false;
/*
	Sample *samp = FindSample(name);
	if (samp == NULL){
		TRACE("IsPlaying: samp was NULL for sample %s\n", name.c_str());
		return false;
	}
    if (samp->sample == NULL){
		TRACE("IsPlaying: samp->sample was NULL for sample %s\n", name.c_str());
		return false;
	}
    if (samp->channel == NULL){
		TRACE("IsPlaying: samp->channel was NULL for sample %s\n", name.c_str());
		return false;
	}

	bool playing = false;
	FMOD_RESULT res= FMOD_Channel_IsPlaying(samp->channel, (FMOD_BOOL *) &playing);
	if (res != FMOD_OK)
		TRACE("IsPlaying: FMOD_Channel_IsPlaying return value was not FMOD_OK but %d\n", res);
	
	return playing;
*/
}

bool AudioSystem::IsPlaying(Sample *sample)
{
	//FMOD_Channel_IsPlaying is broken (causes stack corruption on windows).
	//bool playing;
	//FMOD_RESULT res= FMOD_Channel_IsPlaying(sample->channel, (FMOD_BOOL *) &playing);
	//return playing;
	return false;
}


Sample *AudioSystem::FindSample(std::string name)
{
	Sample *sample = NULL;
	for (SampleIterator i = samples.begin(); i != samples.end(); ++i)
	{
		if ((*i)->getName() == name)
		{
			sample = (*i);
			break;
		}
	}
	return sample;
}


bool AudioSystem::Play(std::string name, bool doLoop)
{
	//prevent playback based on global setting
	if (!bPlay) return true;

	Sample *sample = FindSample(name);
	if (sample == NULL || sample->sample == NULL){
		TRACE("AudioSystem::Play\tCould not play %s: no such sample\n", name.c_str());
		return false;
	}

	try {
		//sample found, play it
		FMOD_RESULT res = FMOD_System_PlaySound(system,FMOD_CHANNEL_FREE, sample->sample, true, &sample->channel);
		if (res!= FMOD_OK) return false;

		ASSERT(sample->channel);

		sample->SetLoop(doLoop);
		sample->SetPaused(false);

	} catch (...) {
		TRACE("AudioSystem::Play\tCould not play %s\n", name.c_str());
		return false;
	}

	return true;
}

bool AudioSystem::Play(Sample *sample, bool doLoop)
{
	//prevent playback based on global setting
	if (!bPlay) return true;

	if (sample == NULL || sample->sample == NULL){
		TRACE("AudioSystem::Play\tCannot play NULL sample\n");
		return false;
	}

	try {
		FMOD_RESULT res = FMOD_System_PlaySound(system,FMOD_CHANNEL_FREE,sample->sample,true,&sample->channel);
		if (res!= FMOD_OK) return false;

		ASSERT(sample->channel);

		sample->SetLoop(doLoop);
		sample->SetPaused(false);

	} catch (...) {
		TRACE("AudioSystem::Play\tCould not play 0x%p\n", (void *) sample);
		return false;
	}

	return true;
}

bool AudioSystem::PlayMusic(std::string name, bool doLoop)
{
	return Play(name, doLoop);
}

bool AudioSystem::PlayMusic(Sample *sample, bool doLoop)
{
	return Play(sample, doLoop);
}

void AudioSystem::PauseMusic(std::string name)
{
	Sample *sample = FindSample(name);
	if (sample == NULL || sample->sample == NULL || sample->channel == NULL){
		TRACE("AudioSystem::PauseMusic\tCould not pause %s", name.c_str());
		return;
	}

	sample->SetPaused(true);
}

void AudioSystem::UnpauseMusic(std::string name)
{
	Sample *sample = FindSample(name);
	if (sample == NULL || sample->sample == NULL || sample->channel == NULL){
		TRACE("AudioSystem::UnpauseMusic\tCould not unpause %s", name.c_str());
		return;
	}

	sample->SetPaused(false);
}
void AudioSystem::Stop(std::string name)
{
//Why do IsPlaying() here? We apparently don't need it in the other Stop()
//	if (!IsPlaying(name)) return;

	Sample *sample = FindSample(name);
	if (sample == NULL) return;

	FMOD_Channel_Stop(sample->channel);
}

void AudioSystem::Stop(Sample *sample)
{
	if (sample == NULL) return;
	FMOD_Channel_Stop(sample->channel);
}

void AudioSystem::StopAll()
{
	for (SampleIterator i = samples.begin(); i != samples.end(); ++i)
	{
		FMOD_Channel_Stop( (*i)->channel );
	}
}

void AudioSystem::StopAllExcept(std::string name)
{
	for (SampleIterator i = samples.begin(); i != samples.end(); ++i)
	{
		if ((*i)->getName() != name)
		{
			FMOD_Channel_Stop( (*i)->channel );
		}
	}
}

void AudioSystem::Delete(std::string name)
{
	SampleIterator i = samples.begin();
	while (i != samples.end())
	{
		if ((*i)->getName() == name)
		{
			Stop( (*i) );
			i = samples.erase(i);
		}
		else i++;
	}
}
