/*:://////////////////////////////////////////////
//:: Spell Name Dirge of Discord
//:: Spell FileName XXX_S_DirgeofDis
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Chaos, Sonic]
    Level: Clr 5
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Area: 6.67M-radius spread (20-ft.)
    Duration: 2d4 rounds + 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes
    Source: Various (WotC)

    This spell creates an unholy, chaotic dirge that fills the subject's head
    with the screams of the dying, the wailing of the damned, and the howling
    of the mad. Affected creatures suffer a -4 profane penalty to attack rolls
    and Concentration checks, a -8 enhancement penalty to effective Dexterity
    (with Reflex saves reduced accordingly for the spell's duration), and halved
    movement due to the subject's equilibrium being thrown off by the dirge.

    Focus: A tiny urn containing some ashes of a destrachan.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    Note that the urn focus isn't in yet.

    Wizards spellbook spell.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_DIRGE_OF_DISCORD)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Duration: 2d4 + 1 round/level
    float fDuration;

    // Declare Effects
    effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 8);
    effect eConcentration = EffectSkillDecrease(SKILL_CONCENTRATION, 4);
    effect eAttack = EffectAttackDecrease(4);
    effect eSlow = EffectMovementSpeedDecrease(50);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDex, eConcentration);
    eLink = EffectLinkEffects(eLink, eAttack);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);


    // Apply AOE location explosion
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    SMP_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 6.67M radius, all creatures
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_DIRGE_OF_DISCORD);

            // Spell resistance And immunity checking.
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Other immunities: Must be able to hear!
                if(SMP_GetCanHear(oTarget))
                {
                    // Roll will save to negate
                    if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC))
                    {
                        // Roll/get duration
                        fDuration = SMP_GetRandomDuration(SMP_ROUNDS, 4, 2, nMetaMagic, nCasterLevel);

                        // Apply effects for fDuration
                        SMP_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
