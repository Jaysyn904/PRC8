//::///////////////////////////////////////////////
//:: Destruction Retribution
//:: prc_cc_desretrib.nss
//:://////////////////////////////////////////////
/*
    Causes all creatures whose masters have the feat to go boom.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 30 , 2005
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{

    if(DEBUG) DoDebug("prc_cc_desretrib.nss: Creature has been killed");

    object oCreature = OBJECT_SELF;

    if(GetLocalInt(oCreature, "DestructionRetribution"))
    {
        if(DEBUG) DoDebug("prc_cc_desretrib.nss: Master has Destruction Retribution");
    
        int nDamage;
        int nHD = GetHitDice(oCreature) / 2 + 1;
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_10); //Replace with Negative Pulse
        effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eDam, eHeal;

        location lTarget = GetLocation(oCreature);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        while(GetIsObjectValid(oTarget))
        {
            nDamage = d6(nHD);
            if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NEGATIVE))
                nDamage /= 2;

            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
            || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
            || GetLocalInt(oTarget, "AcererakHealing"))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
            }
            else
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
        }
    }
}
