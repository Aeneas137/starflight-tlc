
#include "env.h"
#include "CollectItem.h"
#include "Game.h"
#include "DataMgr.h"
#include "Button.h"

using namespace std;

CollectItem::CollectItem(): Requirement(),
	itemid(0),
	amount(0)
{
	
}	

CollectItem::CollectItem(TiXmlElement *rootElement): Requirement(),
	itemid(0),
	amount(0)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("ItemID").FirstChild().Text();
	if (text != NULL)
	{
		this->itemid = atoi(text->Value());
	}

	text = reqHandle.FirstChild("Amount").FirstChild().Text();
	if (text != NULL)
	{
		this->amount = atoi(text->Value());
	}
}


CollectItem::~CollectItem()
{

}

void CollectItem::RegisterSelf()
{
	Game::questMgr->CollectedItemEventMgr.Register(this);
}

void CollectItem::UnregisterSelf()
{
	Game::questMgr->CollectedItemEventMgr.Unregister(this);

	if (completed)
		g_game->gameState->m_items.RemoveItems(itemid, amount);
}

bool CollectItem::Check()
{
	Item item; int amount = 0;
	g_game->gameState->m_items.Get_Item_By_ID(itemid, item, amount);

	if (&item != NULL && amount >= this->amount)
	{
		completed = true;
	}
	else
	{
		completed = false;
	}

	return completed;
}

void CollectItem::OnCollectedItem(int itemid)
{
	if (itemid == this->itemid)
	{
		completed = Check();
	}
}

std::string CollectItem::ToString()
{
	Item item; int amount = 0;
	g_game->gameState->m_items.Get_Item_By_ID(itemid, item, amount);

	char *amountStr = new char[10];
	itoa(this->amount, amountStr, 10);

	char *countStr = new char[10];
	itoa(amount, countStr, 10);

	std::string str = "Collect ";
	
	str += amountStr;
	str += " ";
	str += Game::dataMgr->GetItemByID(itemid)->name;
	str += " - ";
	str += countStr;
	str += "/";
	str += amountStr;

	delete [] amountStr;
	delete [] countStr;

	return str;
}
