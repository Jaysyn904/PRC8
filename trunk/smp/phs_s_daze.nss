/*:://////////////////////////////////////////////
//:: Spell Name Daze
//:: Spell FileName PHS_S_Daze
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    8M range, Target: One humanoid creature of 4 HD or less
    Duration: 1 round, Will negates, SR applies.

    This enchantment clouds the mind of a humanoid creature with 4 or fewer Hit
    Dice, and who is medium or smaller size, so that it takes no actions.
    Humanoids of 5 or more HD are not affected. A dazed subject is not stunned,
    so attackers get no special advantage against it.

    Material Component: A pinch of wool or similar substance.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Dazes a creature of 4HD or less, humanoid only. 1 round only.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DAZE)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration is 1 round.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DAZE, TRUE);

    // Make sure they are humanoid AND <= 4 HD.
    if(PHS_GetIsHumanoid(oTarget) && GetHitDice(oTarget) <= 4)
    {
        // Must be a medium or smaller creature.
        if(GetCreatureSize(oTarget) <= CREATURE_SIZE_MEDIUM)
        {
            // Must check reaction type for PvP
            if(!GetIsReactionTypeFriendly(oTarget))
            {
               // Check spell resistance and immunities.
               if(!PHS_SpellResistanceCheck(oCaster, oTarget))
               {
                    //Make Will Save to negate effect
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        // Apply VFX Impact and daze effect
                        PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                    }
                }
            }
        }
    }
}
