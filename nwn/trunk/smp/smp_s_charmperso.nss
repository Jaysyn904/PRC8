/*:://////////////////////////////////////////////
//:: Spell Name Charm Person
//:: Spell FileName SMP_S_CharmPerso
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Charm) [Mind-Affecting]
    Level: Brd 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One humanoid creature
    Duration: 1 hour/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    This charm makes a humanoid creature regard you as its trusted friend and
    ally. If the creature is currently being threatened or attacked by you or
    your allies, however, it receives a +5 bonus on its saving throw.

    Any act by you or your apparent allies that threatens the charmed person
    breaks the spell. You cannot control a charmed creature directly, but it
    may help in battle and not attack you.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Charms using Biowares EffectCharmed(), which, as tests show, just increases
    personal reputation.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // Duration is 1 hour/level.
    float fDuration = SMP_GetDuration(SMP_HOURS, nCasterLevel, nMetaMagic);

    // Lower save DC by 5 if they are in combat
    if(GetIsInCombat(oTarget))
    {
        nSpellSaveDC -= 5;
    }

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eCharm = EffectCharmed();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Always fire spell cast at event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CHARM_PERSON, FALSE);

    // Make sure they are humanoid
    if(SMP_GetIsHumanoid(oTarget) &&
    // Make sure they are not immune to spells
       !SMP_TotalSpellImmunity(oTarget))
    {
        // Must check reaction type for PvP
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check spell resistance and immunities, and immunity to charm
            if(!SMP_SpellResistanceCheck(oCaster, oTarget) &&
               !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_CHARM) &&
               !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
            {
                //Make Will Save to negate effect
                if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Apply VFX Impact and daze effect
                    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
                }
            }
        }
    }
}
