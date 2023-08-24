/*:://////////////////////////////////////////////
//:: Spell Name Daze Monster
//:: Spell FileName PHS_S_DazeMonster
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Medium (20M) Target: One living creature of 6 HD or less
    Duration: 1 round. Will negates, SR applies.

    This spell functions like daze, but daze monster can affect any one living
    creature of any type. Creatures of 7 or more HD are not affected.

    This enchantment clouds the mind of a creature, so that it takes no actions.
    A dazed subject is not stunned, so attackers get no special advantage
    against it.

    Material Component: A pinch of wool or similar substance.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Dazes any creature for 1 round, 6HD or less.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DAZE_MONSTER)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds.
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

    // Make sure they are <= 6 HD.
    if(GetHitDice(oTarget) <= 6)
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
