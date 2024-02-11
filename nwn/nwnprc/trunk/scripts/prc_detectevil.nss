//::///////////////////////////////////////////////
//:: Detect Evil
//:: prc_detectevil.nss
//::///////////////////////////////////////////////
/*
    Detect Evil as the spell, at will
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    // That was easy
    int nSlayer = GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, OBJECT_SELF);
    int nStk = GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER);
    int nPal = GetLevelByClass(CLASS_TYPE_PALADIN);
    
    int nLevel = max(nPal, max(nStk, nSlayer));
    DoRacialSLA(SPELL_DETECT_EVIL, nLevel);
}