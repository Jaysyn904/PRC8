//::///////////////////////////////////////////////
//:: Remove Fear
//:: NW_S0_RmvFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within a 10ft radius have their fear
    effects removed and are granted a +4 Save versus
    future fear effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 13, 2001
//:://////////////////////////////////////////////

#include "prc_inc_spells"  


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


    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 100;
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
       nDuration = nDuration*2;
    }
    object oTarget;
    effect eFear;
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    effect eLink = EffectLinkEffects(eMind, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    float fDelay;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    //Get first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        //Only remove the fear effect from the people who are friends.
        if(GetIsFriend(oTarget))
        {
            fDelay = PRCGetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_FEAR, FALSE));
            eFear = GetFirstEffect(oTarget);
            //Get the first effect on the current target
            while(GetIsEffectValid(eFear))
            {
                if (GetEffectType(eFear) == EFFECT_TYPE_FRIGHTENED)
                {
                    //Remove any fear effects and apply the VFX impact
                    RemoveEffect(oTarget, eFear);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                //Get the next effect on the target
                eFear = GetNextEffect(oTarget);
            }
            //Apply the linked effects
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
        }
        //Get the next target in the spell area.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, PRCGetSpellTargetLocation());
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Gets rid of the local int used  to store spell school - for the sake of tidiness.

}

