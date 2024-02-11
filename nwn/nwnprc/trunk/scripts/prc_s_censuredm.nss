//::///////////////////////////////////////////////
//:: [Censure Daemons]
//:: [prc_s_censuredm.nss]
//:://////////////////////////////////////////////
//:: Evil Outsiders must make a will save versus
//:: Knight level + 10 + Cha Bonus or be stunned
//:: for 1 round.  If HD is less than 2 x Knight Level
//:: must save again or be immediately banished
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

int PRCCanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}


#include "prc_alterations"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, OBJECT_SELF);
    int nCnt = 1;
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nDC = 10 + nLevel + nChrMod;
    effect eImpVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eStunVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eStun = EffectStunned();
    effect eCensure = EffectLinkEffects(eStun, eStunVis);
    effect eBanish = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eLOS = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    //Show the holy burst effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLOS, GetLocation(OBJECT_SELF));

    //Cycle through all enemy outsiders within 30 feet
    object oTarget = GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_OUTSIDER, OBJECT_SELF, 1, PLAYER_CHAR_IS_PC, PLAYER_CHAR_NOT_PC, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    while(GetIsObjectValid(oTarget) && GetDistanceBetween(oTarget, OBJECT_SELF) <= FeetToMeters(30.0f)){
        //Only works on evil outsiders
        if(GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL) return;

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);

        //First censure check to stun
        if(!WillSave(oTarget, nDC, SAVING_THROW_TYPE_GOOD)){
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCensure, oTarget, RoundsToSeconds(1));

            //Second check to banish weaker fiends
            if(GetHitDice(oTarget) < nLevel*2 && !WillSave(oTarget, nDC, SAVING_THROW_TYPE_GOOD)){
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBanish, GetLocation(oTarget));
                if (PRCCanCreatureBeDestroyed(oTarget) == TRUE)
                    DestroyObject(oTarget, 0.3);
            }
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_OUTSIDER, OBJECT_SELF, nCnt, PLAYER_CHAR_IS_PC, PLAYER_CHAR_NOT_PC, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    }
}
