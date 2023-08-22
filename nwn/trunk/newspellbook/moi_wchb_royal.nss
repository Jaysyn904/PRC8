#include "prc_class_const"
#include "inc_persist_loca"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nWitch = GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper);
    int nGold = 500;

    if(GetPersistantLocalInt(oMeldshaper, "RoyalPurse") >= nWitch)
        return;

    if(nWitch == 10)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 10);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 10);
    }
	else if(nWitch == 9)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 9);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 9);
    }
	else if(nWitch == 8)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 8);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 8);
    }
	else if(nWitch == 7)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 7);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 7);
    }
	else if(nWitch == 6)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 6);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 6);
    }
	else if(nWitch == 5)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 5);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 5);
    }
	else if(nWitch == 4)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 4);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 4);
    }
	else if(nWitch == 3)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 3);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 3);
    }
	else if(nWitch == 2)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 2);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 2);
    }
	else if(nWitch == 1)
    {
        // *Shared Trove
        GiveGoldToCreature(oMeldshaper, nGold * 1);
        SetPersistantLocalInt(oMeldshaper, "RoyalPurse", 1);
    }    
}