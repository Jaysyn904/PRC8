//::///////////////////////////////////////////////
//:: Ghost Step (Invisibility)
//:: prc_ninjca_gstep.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature becomes invisibility
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Smith
//:: Created On: July 18, 2005
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    int iContinue = 0;
    object oCaster = OBJECT_SELF;
    if ( PRCGetHasEffect( EFFECT_TYPE_CHARMED, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_CONFUSED, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_CUTSCENE_PARALYZE, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_CUTSCENEIMMOBILIZE, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_DAZED, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_DOMINATED, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_FRIGHTENED, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_PARALYZE, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_PETRIFY, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_SLEEP, oCaster ) )
    {
        iContinue++;
    }
    if ( PRCGetHasEffect( EFFECT_TYPE_STUNNED, oCaster ) )
    {
        iContinue++;
    }
    if ( iContinue > 0 )
    {
        IncrementRemainingFeatUses(oCaster, FEAT_GFKILL_GHOST_STEP);
        return;
    }
    if (!Ninja_AbilitiesEnabled(OBJECT_SELF))
    {
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_GHOST_STEP);
        SendMessageToPC(OBJECT_SELF, "Your ki powers will not function while encumbered or wearing armor");
        return;
    }
    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    Ninja_DecrementKi(OBJECT_SELF, FEAT_GHOST_STEP);

    // End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();

    //effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // a major hack here, if we're a level 10 or higher ninja, Ghost Step also makes you ethereal
    // probably should be a replacing feat so other classes can use it

    effect eLink;

    effect eSanc = EffectEthereal();
    eLink = EffectLinkEffects(eDur, eSanc);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOST_STEP, FALSE));

    float nDuration = RoundsToSeconds(1);

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration,TRUE,-1, 1);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}

