//:://////////////////////////////////////////////
//:: Name     Strategic Charge
//:: FileName   sp_stratchrg.nss
//:://////////////////////////////////////////////
/** @file Abjuration
Level: Blackguard 1, Paladin 1
Components: V, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round/level

A red nimbus surrounds you as you move smoothly 
across the crowded battlefield.

You gain the benefit of the Mobility feat (PH 98), 
even if you not meet the prerequisites. You do not
have to be charging to gain this benefit.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/26/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        itemproperty iProp = PRCItemPropertyBonusFeat(IP_FEAT_MOBILITY);
        IPSafeAddItemProperty(oSkin, iProp, fDur);
        
        PRCSetSchool();
}