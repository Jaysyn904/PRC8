#include "prc_class_const"
#include "inc_persist_loca"

void main()
{
    object oPC = OBJECT_SELF;
    int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, oPC);

    if(GetPersistantLocalInt(oPC, "VassalLvl") >= nVassal)
        return;

    // *Level 8
    if(nVassal == 8)
    {
        // *Shared Trove
        GiveGoldToCreature(oPC, 80000);
        SetPersistantLocalInt(oPC, "VassalLvl", 8);
    }
    // *Level 5
    else if(nVassal == 5)
    {
        // *Shared Trove
        GiveGoldToCreature(oPC, 50000);
        SetPersistantLocalInt(oPC, "VassalLvl", 5);
    }
    // *Level 2
    else if(nVassal == 2)
    {
        // *Shared Trove
        GiveGoldToCreature(oPC, 20000);
        SetPersistantLocalInt(oPC, "VassalLvl", 2);
    }
    // *Level 1
    else if(nVassal == 1)
    {
		CreateItemOnObject("Platinumarmor8", oPC, 1);
        SetPersistantLocalInt(oPC, "VassalLvl", 1);
    }
}