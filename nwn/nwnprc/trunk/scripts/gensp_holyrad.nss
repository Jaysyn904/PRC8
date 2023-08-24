//::///////////////////////////////////////////////
//:: Magic Circle Against Evil
//:: NW_S0_CircEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001


//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_class_const"
#include "x2_inc_spellhook"
#include "prc_alterations"
#include "prc_spell_const"

void main()
{
   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
   SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);


/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if (GetHasSpellEffect(SPELL_HOLYRADIANCE)
        || GetAlignmentGoodEvil(OBJECT_SELF)!= ALIGNMENT_GOOD )
    {
       PRCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,PRCGetSpellTargetObject());
       return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL,"gensp_holyrada","gensp_holyradc");
    effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_GOOD_HELP);

    effect eLink = EffectLinkEffects(eAOE, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = SupernaturalEffect(eLink);

    object oTarget = PRCGetSpellTargetObject();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
}

