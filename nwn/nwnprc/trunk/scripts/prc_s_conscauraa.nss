//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: All allies in the area are immune to fear
//:: and other mind effects created by outsiders
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oTarget = GetEnteringObject();
    //AssignCommand(GetAreaOfEffectCreator(), ActionSpeakString("Something Entered"));
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()) && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD))
    {
        //AssignCommand(oTarget, ActionSpeakString("Entered"));
        //effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        effect eAC = EffectACDecrease(1);
        effect eAttack = EffectAttackDecrease(1);
        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1);
        effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eLink = EffectLinkEffects(eAC, eAttack);
               eLink = EffectLinkEffects(eLink, eSave);
               eLink = EffectLinkEffects(eLink, eVis);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
     }
}
