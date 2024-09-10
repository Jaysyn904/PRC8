//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////


// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding
#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    // Exclude dead creatures
    if (GetIsDead(oTarget))
    {
        return;
    }

    // Exclude dragons
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DRAGON)
    {
        return;
    }

    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur3 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    effect eFear = EffectFrightened();
    effect eAttackD = EffectAttackDecrease(2);
    effect eDmgD = EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING);
    effect SaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect Skill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);

    effect eLink = EffectLinkEffects(eDmgD, eDur2);
           eLink = EffectLinkEffects(eLink, eAttackD);
           eLink = EffectLinkEffects(eLink, SaveD);
           eLink = EffectLinkEffects(eLink, eFear);
           eLink = EffectLinkEffects(eLink, Skill);
           
    effect eLink2 = EffectLinkEffects(eDur3, SaveD);
           eLink2 = EffectLinkEffects(eLink2, Skill);

    int nHD = GetHitDice(GetAreaOfEffectCreator());
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, GetAreaOfEffectCreator()) + GetAbilityModifier(ABILITY_CHARISMA, GetAreaOfEffectCreator());
    int nDuration = d6(2);

    if (GetIsEnemy(oTarget, GetAreaOfEffectCreator()) && GetHitDice(oTarget) <= GetHitDice(GetAreaOfEffectCreator()))
    {
        // Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));

        // Make a saving throw check
        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR) 
            && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) 
            && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            int HD = GetHitDice(oTarget);

            if (HD < 5)
            {
                // Apply the VFX impact and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            }
            else
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
            }

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
