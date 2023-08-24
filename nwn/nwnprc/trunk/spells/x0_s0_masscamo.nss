//::///////////////////////////////////////////////
//:: Mass Camoflage
//:: x0_s0_masscamo.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    +10 hide bonus to all allies in area
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void PRCDoCamoflage(object oTarget)
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHide, eDur);

    int nDuration = 10*PRCGetCasterLevel(OBJECT_SELF); // * Duration 10 turn/level
     if (nMetaMagic & METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

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



    // * now setup benefits for allies
        //Apply Impact
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    float fDelay = 0.0;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());

    //Get the first target in the radius around the caster
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            //fDelay = PRCGetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 454, FALSE));
            PRCDoCamoflage(oTarget);
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}









