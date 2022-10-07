//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by ray loses 1 to attack rolls.

    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Modified By: Sir Attilla
//:: Modified On: January 3 2004
//:://///////////////////////////////////////////

#include "inc_newspellbook" 
#include "prc_inc_core"

void main()
{
    int nLevel = 15;
    int nDC    =  GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_MEPH) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_FLARE, nLevel, nDC);
}


