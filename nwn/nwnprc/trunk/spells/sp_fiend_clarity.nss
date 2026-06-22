//::///////////////////////////////////////////////
//:: Name      Fiendish Clarity
//:: FileName  sp_fiend_clarity.nss
//:://////////////////////////////////////////////
/**@file Fiendish Clarity
Divination [Evil]
Level: Clr 7, Demonic 7, Sor/Wiz 7
Components: V, S
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/ level

The caster develops the senses of a powerful fiend.
He has darkvision to a range of 60 feet. The caster
can see in magical darkness as if it were normal
darkness. He can see invisible creatures and objects
as if he had a see invisibility spell cast on him.
The caster can detect good at will.

Author:    Tenjac
Created:   5/17/06

Fixed By: Jaysyn
Date: 2026-06-22 16:03:57
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = (600.0f * nCasterLvl);

    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    //itemproperty nDarkvis = PRCItemPropertyBonusFeat(FEAT_DARKVISION);
    //effect eTrueSee = EffectTrueSeeing();
    itemproperty nDetGood = PRCItemPropertyBonusFeat(FEAT_DETECT_GOOD_AT_WILL);
	
	effect eDarkVision	= EffectBonusFeat(FEAT_DARKVISION);
	effect eSeeInvis 	= EffectSeeInvisible();  
	effect eUltra 		= EffectUltravision();  
	effect eLink 		= EffectLinkEffects(eSeeInvis, eUltra);
	eLink				= EffectLinkEffects(eLink, eDarkVision);

    //IPSafeAddItemProperty(oPC, nDarkvis, fDur);
    IPSafeAddItemProperty(oPC, nDetGood, fDur);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);

    //SPEvilShift(oPC);
    PRCSetSchool();
}

