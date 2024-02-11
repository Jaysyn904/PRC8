/*:://////////////////////////////////////////////
//:: Spell Name Ghoul Touch - On Enter
//:: Spell FileName PHS_S_GhoulToucA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cannot decrease ability checks without decreasing the ability!

    But the rest is fine, as is the paralysis :-)

    This script is the on enter of the "carrion fog" around the target. Never
    affects caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare Major Variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration of the sickening is forever, until wiped.

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_POISON_L);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Make sure it isn't just removed like that
    // - Removed by neutralise poison.
    eLink = SupernaturalEffect(eLink);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GHOUL_TOUCH);

    // PvP check - it doesn't affect the caster
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) && oTarget != oCaster)
    {
        // Poison immunity
        if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_POISON))
        {
            // Spell resistance + immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Fortitude save
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POISON, oCaster))
                {
                    // Apply visual effect and negative effects
                    PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);
                }
            }
        }
    }
}
