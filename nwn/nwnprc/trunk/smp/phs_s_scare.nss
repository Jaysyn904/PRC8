/*:://////////////////////////////////////////////
//:: Spell Name Scare
//:: Spell FileName PHS_S_Scare
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Fear, Mind-Affecting]
    Range: Medium (20M)
    Targets: One living enemy per three levels in a 5M-radius sphere
    Duration: 1 round/level or 1 round; see text
    Saving Throw: Will partial
    Spell Resistance: Yes

    The affected creatures becomes frightened. If each subject succeeds on a Will
    save, they are shaken for 1 round. Creatures with 6 or more Hit Dice are
    immune to this effect.

    Scare counters and dispels remove fear.

    Material Component: A bit of bone from an undead skeleton, zombie, ghoul,
    ghast, or mummy.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description. Stronger (and AOE) version of Cause Fear.

    Shaken effect for 1 round like many others.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SCARE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;

    // What are the maximum enemies we can affect?
    int nMaxEnemies = PHS_LimitInteger(nCasterLevel/3);
    int nEnemiesCounter = 0;

    // Get duration in rounds. Can extend the 1 round too.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);
    float f1Round = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Declare effects
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDispelVFX = EffectVisualEffect(VFX_IMP_DISPEL);

    // Link effects
    effect eLink = EffectLinkEffects(eFear, eDur);

    // Get all in a 5M sphere. 30ft diameter = 15ft radius
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    while(GetIsObjectValid(oTarget) && nEnemiesCounter < nMaxEnemies)
    {
        // Reaction type check
        if(GetIsReactionTypeHostile(oTarget))
        {
            // We chose this one to affect - add one to total we chose
            nEnemiesCounter++;

            // Signal Spell cast at event.
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SCARE);

            // Get delay
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Check hit dice
            if(GetHitDice(oTarget) <= 5)
            {
                // Check spell resistance
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Check against mind spells and Fear
                    if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
                       !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_FEAR))
                    {
                        // If we remove Remove Fear, via. dispelling, we do not
                        // do the save
                        if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_REMOVE_FEAR, oTarget, fDelay))
                        {
                            // Removed - apply vispel VFX
                            DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eDispelVFX));
                        }
                        else
                        {
                            // Will Saving throw versus fear negates
                            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR))
                            {
                                // Impact and duration effects applied
                                SetLocalInt(oTarget, "PHS_SPELL_SCARE_FEAR", TRUE);
                                DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
                            }
                            else
                            {
                                // Pass, do shaken
                                SetLocalInt(oTarget, "PHS_SPELL_SCARE_FEAR", TRUE);
                                DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, f1Round));
                            }
                        }
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_15, lTarget, TRUE);
    }
}
