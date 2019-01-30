#pragma once

#include <iostream>
#include <string>
#include <vector>
#include <fmod.h>
#include "Game.h"

class Sample
{
private:
	std::string name;
	bool loop;
	bool paused;

public:
	FMOD_SOUND	*sample;
	FMOD_CHANNEL *channel;

public:
	Sample(void);
	~Sample(void);
	std::string getName() { return name; }
	void setName(std::string value) { name = value; }

	void SetVolume(float volume);
	void SetLoop(bool doLoop);
	bool GetLoop(void){ return loop; }
	void SetPaused(bool doPause);
	bool GetPaused(void){ return paused; }
};

class AudioSystem
{
private:
	FMOD_SYSTEM *system;
	typedef std::vector<Sample*> Samples;
	typedef std::vector<Sample*>::iterator SampleIterator;
	Samples samples;
	bool bPlay;

public:
	AudioSystem(void);
	~AudioSystem(void);
	FMOD_SYSTEM* getSystem() { return system; }

	bool Init();
	void Update(); //must be called once per frame

	bool Load(std::string filename, std::string name, float volume = 1.0f);
	Sample* Load(std::string filename, float volume = 1.0f);
	bool LoadMusic(std::string filename, std::string name, float volume = 0.4f);
	Sample* LoadMusic(std::string filename, float volume = 0.4f);
	bool Play(std::string name, bool doLoop=false);
	bool Play(Sample *sample, bool doLoop=false);
	bool PlayMusic(std::string name, bool doLoop=true);
	bool PlayMusic(Sample *sample, bool doLoop=true);

	void PauseMusic(std::string name);
	void UnpauseMusic(std::string name);
	void Stop(std::string name);
	void Stop(Sample *sample);
	void StopAll();
	void StopAllExcept(std::string name);
	void Delete(std::string name);
	bool IsPlaying(std::string name);
	bool IsPlaying(Sample *sample);
	bool SampleExists(std::string name);
	Sample *FindSample(std::string name);

};
