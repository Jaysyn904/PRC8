//::///////////////////////////////////////////////
//:: Expeditious retreat
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
 Also gives + 2 AC bonus
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"



#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget = PRCGetSpellTargetObject();

    if (GetHasSpellEffect(SPELL_HASTE, oTarget) == TRUE)
    {
        return ; // does nothing if caster already has haste
    }
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eFast = EffectMovementSpeedIncrease(150);
    effect eLink = EffectLinkEffects(eFast, eDur);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 455, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
