
#ifndef _TIMER_H
#define _TIMER_H 1

#include "env.h"

#if defined(_POSIX_SOURCE)
#include <sys/time.h>
#endif

class Timer
{
private:
	long timer_start;
	long stopwatch_start;
	#if defined(_POSIX_SOURCE)
	timeval initial;
	#endif

public:
	Timer(void);
	~Timer(void);
	long getTimer();
	void setTimer(long value);

	long getStartTimeMillis();

	void sleep(long ms);
	void reset();
	bool stopwatch(long ms);
};

#endif
