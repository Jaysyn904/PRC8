//::///////////////////////////////////////////////
//:: Select Spell level to Burn
//:: prc_burnselect.nss
//::///////////////////////////////////////////////
/*
    Used by a number of classes to choose the spell level to burn
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_sp_gain_mem"

void main()
{
    object oPC = OBJECT_SELF;
    
    int nSpellLevel = GetLocalInt(oPC, "BurnSpellLevel");
    
    int nArc = GetLevelByTypeArcane(oPC);
    int nDiv = GetLevelByTypeDivine(oPC);
    int nBest = nArc;
    if(nDiv > nArc) nBest = nDiv;
    int nClass = GetPrimarySpellcastingClass(oPC);
    int nMax = GetMaxSpellLevelForCasterLevel(nClass, nBest);
    int nMin = GetMinSpellLevelForCasterLevel(nClass, nBest);
    
    if((nSpellLevel+1) > nMax) nSpellLevel = nMin;
    else nSpellLevel++;
    
    SetLocalInt(oPC, "BurnSpellLevel",nSpellLevel);
    FloatingTextStringOnCreature("You are burning level "+IntToString(nSpellLevel)+" spells", oPC, FALSE);
}