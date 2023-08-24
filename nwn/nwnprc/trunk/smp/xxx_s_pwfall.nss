/*:://////////////////////////////////////////////
//:: Spell Name Power Word, Fall
//:: Spell FileName XXX_S_PWFall
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Sor/Wiz 3
    Components: V
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One Living creature with 50hp or less
    Duration: Instant
    Saving Throw: None
    Spell Resistance: Yes
    Source: Various (dantedarkstar)

    You utter a single word of power that makes one creature of your choice
    falls prone, whether the creature can hear the word or not. It takes 6
    seconds for the prone creature to fall, then get up again. Creatures with
    51 hp or more are unaffected  by power word fall.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Note: Made extraordinary, its not something that should be able to be dispelled,
    or probably more importantly, be in the way when a dispel is cast (good or
    bad intentions aside).

    Note: HP changed from 60 to 50, and now made it level 3.

    Need to test to work it right.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!SMP_SpellHookCheck(SMP_SPELL_POWER_WORD_FALL)) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nHitpoints = GetCurrentHitPoints(oTarget);

    // Takes 1 round to get up
    float fDuration = RoundsToSeconds(1);

    // Declare Effects
    effect eKnockdown = EffectKnockdown();
    eKnockdown = ExtraordinaryEffect(eKnockdown);

    // Apply the VFX impact
    effect eWord =  EffectVisualEffect(VFX_FNF_PWSTUN);
    SMP_ApplyLocationVFX(GetLocation(oTarget), eWord);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Make sure thier HP is <= 50 and mind immunity.
        if(nHitpoints <= 50 &&
          !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            // Signal Spell Cast at
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_POWER_WORD_FALL);

            // Check spell resistance and immunity
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects for duration
                SMP_ApplyDuration(oTarget, eKnockdown, fDuration);
            }
        }
    }
}
