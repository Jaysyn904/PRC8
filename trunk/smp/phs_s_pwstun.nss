/*:://////////////////////////////////////////////
//:: Spell Name Power Word Stun
//:: Spell FileName PHS_S_PWStun
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 8, War 8
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature with 150 hp or less
    Duration: See text
    Saving Throw: None
    Spell Resistance: Yes

    You utter a single word of power that instantly causes one creature of your
    choice to become stunned, whether the creature can hear the word or not. The
    duration of the spell depends on the target’s current hit point total. Any
    creature that currently has 151 or more hit points is unaffected by power
    word stun.

    Hit Points  Duration
    ----------  ---------
    50 or less  4d4 rounds
    51-100      2d4 rounds
    101-150     1d4 rounds
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell, including Bioware visual effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_POWER_WORD_STUN)) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nHitpoints = GetCurrentHitPoints(oTarget);
    float fDuration;

    // Get duration
    // Hit Points  Duration
    // ----------  --------
    // 50 or less  4d4 rounds
    // 51-100      2d4 rounds
    // 101-150     1d4 rounds
    int nDice = 1;
    if(nHitpoints <= 50)
    {
        // Duration is 4d4 rounds
        nDice = 4;
    }
    else if(nHitpoints < 100)
    {
        // Duration is 2d4 rounds
        nDice = 2;
    }
    else if(nHitpoints < 150)
    {
        // Duration is 1d4 rounds
        nDice = 1;
    }
    // Get final duration
    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, nDice, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    // Link effects
    effect eLink = EffectLinkEffects(eDur, eStun);

    // Apply the VFX impact
    effect eWord =  EffectVisualEffect(VFX_FNF_PWSTUN);
    PHS_ApplyLocationVFX(GetLocation(oTarget), eWord);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Make sure thier HP is <= 150
        if(nHitpoints <= 150)
        {
            // Signal Spell Cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POWER_WORD_STUN);

            // Check spell resistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects for duration
                PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
            }
        }
    }
}
