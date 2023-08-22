/*:://////////////////////////////////////////////
//:: Spell Name Prayer
//:: Spell FileName PHS_S_Prayer
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Clr 3, Pal 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 13.33M. (40-ft)
    Area: All allies and foes within a 13.33M-radius (40-ft.) burst centered on you
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: Yes

    You bring special favor upon yourself and your allies while bringing disfavor
    to your enemies. You and your each of your allies gain a +1 bonus on attack
    rolls, weapon damage rolls, saves, and skill checks, while each of your foes
    takes a -1 penalty on such rolls.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Larger AOE then any of the current AOE's for bless ETC.

    Easy to do though.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(PHS_SpellHookCheck(PHS_SPELL_PRAYER)) return;

    // Define ourselves.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lSelf = GetLocation(oCaster);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;
    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Effect - attack +1, +1 saves, +1 damage, +1 skills
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eAttack = EffectAttackIncrease(1);
    effect eMorale = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 1);
    effect eDam = EffectDamageIncrease(1, DAMAGE_TYPE_DIVINE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eMorale);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDam);

    // Bad effects - minus the above.
    effect eBadVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eBadAttack = EffectAttackDecrease(1);
    effect eBadMorale = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eBadSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 1);
    effect eBadDam = EffectDamageDecrease(1, DAMAGE_TYPE_DIVINE);
    effect eBadDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Link effects
    effect eBadLink = EffectLinkEffects(eBadAttack, eBadMorale);
    eBadLink = EffectLinkEffects(eBadLink, eBadDur);
    eBadLink = EffectLinkEffects(eBadLink, eBadSkill);
    eBadLink = EffectLinkEffects(eBadLink, eBadDam);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_LOS_HOLY_50);
    PHS_ApplyLocationVFX(lSelf, eImpact);

    // Loop allies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_50, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // Make sure they are not immune to spells
        if(!PHS_TotalSpellImmunity(oTarget))
        {
            // Check if ally or enemy
            if(GetIsFriend(oTarget) || GetFactionEqual(oTarget) || oTarget == oCaster)
            {
                //Fire cast spell at event for the specified target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRAYER, FALSE);

                // Delay for visuals and effects.
                fDelay = GetDistanceBetween(oCaster, oTarget)/20;

                // Remove previous GOOD effects
                PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_INCREASE, PHS_SPELL_PRAYER, oTarget);

                // Apply the VFX impact and effects
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
            else
            {
                // Enemy/Non-friend

                //Fire cast spell at event for the specified target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRAYER, TRUE);

                // Delay for visuals and effects.
                fDelay = GetDistanceBetween(oCaster, oTarget)/20;

                // Remove previous BAD effects
                PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_ATTACK_DECREASE, PHS_SPELL_PRAYER, oTarget);

                // Apply the VFX impact and effects
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eBadVis));
                PHS_ApplyDuration(oTarget, eBadLink, fDuration);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_50, lSelf);
    }
}
