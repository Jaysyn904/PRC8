//::///////////////////////////////////////////////
//:: Remove Paralysis
//:: NW_S0_RmvParal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the paralysis and hold effects from the
    targeted creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 20, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells" 

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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
    object oTarget;
    int nType;
    effect eParal;
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
    int nCnt = 0;
    int nRemove = PRCGetCasterLevel(OBJECT_SELF) / 4;
    nRemove += 1;
    float fDelay;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    //Get the first effect on the target
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, PRCGetSpellTargetLocation());
    while(GetIsObjectValid(oTarget) && nCnt <= nRemove)
    {
        if(GetIsFriend(oTarget))
        {
            fDelay = PRCGetRandomDelay();
            eParal = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eParal))
            {
                //Check if the current effect is of correct type
                if (GetEffectType(eParal) == EFFECT_TYPE_PARALYZE)
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_PARALYSIS, FALSE));

                    //Remove the effect and apply VFX impact
                    RemoveEffect(oTarget, eParal);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    nCnt++;
                }
                //Get the next effect on the target
                eParal = GetNextEffect(oTarget);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, PRCGetSpellTargetLocation());
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
