/*
    Warlock epic feat
    Master of the Elements summoning
*/
#include "prc_inc_racial"

#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    if(DEBUG) DoDebug("Master of Elements Spell ID: " + IntToString(GetSpellId()));

    if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_AIR)
        DoRacialSLA(3197, CasterLvl); //Summon Creature 9 - Air
    else if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_EARTH)
        DoRacialSLA(3198, CasterLvl); //Summon Creature 9 - Earth
    else if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_FIRE)
        DoRacialSLA(3199, CasterLvl); //Summon Creature 9 - Fire
    else if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_WATER)
        DoRacialSLA(3200, CasterLvl); //Summon Creature 9 - Water
}
