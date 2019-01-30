#ifndef TEXTBLOB_H
#define TEXTBLOB_H
#pragma once

#include <string>
#include "tinyxml/tinyxml.h"

class TextBlob
{
public:
	TextBlob();
	TextBlob(TiXmlElement *rootElement);
	virtual ~TextBlob();

	

protected:


private:
	
};

#endif
