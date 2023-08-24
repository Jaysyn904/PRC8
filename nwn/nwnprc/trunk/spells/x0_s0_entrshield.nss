//::///////////////////////////////////////////////
//:: Entropic Shield
//:: x0_s0_entrshield.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    20% concealment to ranged attacks including
    ranged spell attacks

    Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"



#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


     //Declare major variables
    object oTarget = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Set the four unique armor bonuses
    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eShield, eDur);
//    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

