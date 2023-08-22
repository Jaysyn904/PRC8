/*:://////////////////////////////////////////////
//:: Spell Name Power Word, Blind
//:: Spell FileName PHS_S_PWBlind
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 7, War 7
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature with 200 hp or less
    Duration: See text
    Saving Throw: None
    Spell Resistance: Yes

    You utter a single word of power that causes one creature of your choice
    to become blinded, whether the creature can hear the word or not. The
    duration of the spell depends on the target’s current hit point total. Any
    creature that currently has 201 or more hit points is unaffected by power
    word blind.

    Hit Points  Duration
    ----------  --------
    Up to 50    Permanent
    51 to 100   1d4+1 minutes
    101 to 200  1d4+1 rounds
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No save, 1 target!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_POWER_WORD_BLIND)) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDuration;
    int nHitPoints;

    // Declare Effects
    effect eBlind = EffectBlindness();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    // Link effects
    effect eLink = EffectLinkEffects(eVis, eBlind);

    // Apply AOE visual
    effect eImpact =  EffectVisualEffect(PHS_VFX_FNF_PWBLIND);
    PHS_ApplyLocationVFX(GetLocation(oTarget), eImpact);

    // One target
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Fire cast spell at event for the specified target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POWER_WORD_BLIND);

        // Spell Resistance and immunity check
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            nHitPoints = GetCurrentHitPoints(oTarget);
            // Durations:
            //    Hit Points  Duration
            //    ----------  --------
            //    Up to 50    Permanent
            //    51 to 100   1d4+1 minutes
            //    101 to 200  1d4+1 rounds
            if(nHitPoints <= 50)
            {
                //Apply the blindness effect - Permanent
                PHS_ApplyPermanent(oTarget, eBlind);
            }
            else if(nHitPoints <= 100)
            {
                //Apply the blindness effect - 1d4+1 minutes.
                fDuration = PHS_GetRandomDuration(PHS_MINUTES, 4, 1, nMetaMagic, 1);
                PHS_ApplyDuration(oTarget, eBlind, fDuration);
            }
            else if(nHitPoints <= 200)
            {
                //Apply the blindness effect - 1d4 + 1 rounds
                fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, 1);
                PHS_ApplyDuration(oTarget, eBlind, fDuration);
            }
        }
    }
}
