//:: prc_vassal_treas.nss

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
    // *Epic levels - 30,000 gp every 3 levels (11, 14, 17, 20, 23, etc.)  
    else if(nVassal >= 11)  
    {  
        // Check if this is an epic level that grants trove (every 3 levels)  
        if((nVassal - 11) % 3 == 0)  
        {  
            // *Shared Trove - Epic  
            GiveGoldToCreature(oPC, 30000);  
            SetPersistantLocalInt(oPC, "VassalLvl", nVassal);  
        }  
    }  
}