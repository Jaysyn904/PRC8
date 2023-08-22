//::///////////////////////////////////////////////
//:: Serene Guardian - Release Trigger
//:://////////////////////////////////////////////
/*
    Does the appropriate resonance release
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sep 9, 2018
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void ResonanceTrigger(object oPC, object oTarget, int nResType, int nClass, int nRes)
{
//    int nRes = GetLocalInt(oTarget, "Resonance");
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eImp = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    
    if ((nResType == SPELL_SERENE_PAIN || nResType == 0) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)
    && !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK))) // Pain, default, doesn't work on critical or sneak immune
    {
        eDur = EffectLinkEffects(eDur, EffectAttackDecrease(nRes));
        eDur = EffectLinkEffects(eDur, EffectSavingThrowDecrease(SAVING_THROW_ALL, nRes));
    }
    else if (nResType == SPELL_SERENE_DAMAGE) // Damage
    {
        if (nClass >= 6) // Double damage for Traumatic
            eImp = EffectLinkEffects(eImp, EffectDamage(d6(nRes*2)));
        else
            eImp = EffectLinkEffects(eImp, EffectDamage(d6(nRes)));
    }
    else if (nResType == SPELL_SERENE_STAGGER) // Stagger
    {
        int nSlow = 33 * nRes;
         
        if (nSlow >= 99) // Target is immobile
        {
            eDur = EffectLinkEffects(eDur, EffectCutsceneImmobilize());
        }
        else
        {
            eDur = EffectLinkEffects(eDur, EffectMovementSpeedDecrease(nSlow));     
        }
    }   
    else if (nResType == SPELL_SERENE_CONFOUND) // Confound
    {
        eDur = EffectLinkEffects(eDur, PRCEffectConfused());
    }    
    else if (nResType == SPELL_SERENE_SOUL) // Soul
    {
        int nHD = GetHitDice(oTarget);
        DeathlessFrenzyCheck(oTarget);
        
        if ((nRes * 2) >= nHD) // Can kill creatures with 2 HD per point of Res
        {
            int nDC = 10 + nClass + GetAbilityModifier(ABILITY_WISDOM, oPC);
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH)) // Do the save
                eImp = EffectLinkEffects(eImp, EffectDeath());
        }
    }
   
    //Apply the impact
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);

    // Only some have duration effects
    if (nResType == SPELL_SERENE_PAIN || nResType == SPELL_SERENE_STAGGER || nResType == SPELL_SERENE_CONFOUND)
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nRes), FALSE);
    }
    DeleteLocalInt(oTarget, "Resonance"); // We've used them all up
}

void main()
{
    object oPC = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_SERENE_GUARDIAN, oPC);
    int nResType = PRCGetSpellId();
    string sMes = "Error, Debug";
    
    if (nResType == SPELL_SERENE_PAIN)
        sMes = "Painful Release Activated";
    else if (nResType == SPELL_SERENE_DAMAGE)
    {
        sMes = "Damaging Release Activated";
        if (nClass >= 6)
            sMes = "Tramautic Release Activated";
    }
    else if (nResType == SPELL_SERENE_STAGGER)
        sMes = "Staggering Release Activated";
    else if (nResType == SPELL_SERENE_CONFOUND)
        sMes = "Confounding Release Activated";
    else if (nResType == SPELL_SERENE_SOUL)
        sMes = "Soul Release Activated";

    FloatingTextStringOnCreature(sMes, oPC, FALSE);    
    
    location lLoc = GetLocation(oPC);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
    
    while(GetIsObjectValid(oTarget))
    {
        int nRes = GetLocalInt(oTarget, "Resonance");
        if (nRes > 0) // Make sure they have Resonance
        {
            ResonanceTrigger(oPC, oTarget, nResType, nClass, nRes);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
   }    
    
}