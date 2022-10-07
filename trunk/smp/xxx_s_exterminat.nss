/*:://////////////////////////////////////////////
//:: Spell Name Exterminate
//:: Spell FileName XXX_S_Exterminat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Death]
    Level: Sor/wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One tiny animal or vermin with no more then 1 HD
    Duration: Instantaneous
    Saving Throw: Fortitude Negates
    Spell Resistance: Yes
    Source: Various (Tevish Szat)

    Exterminate instantly kills an animal or vermin of tiny size with no more
    than 1 Hit Dice, unless they pass a sucessful fortitude save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Simple, effective, easy to check for size and race and HD.

    Rats, and so on, would be mainly affected.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_EXTERMINATE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nRace = GetRacialType(oTarget);
    int nSize = GetCreatureSize(oTarget);
    int nHD = GetHitDice(oTarget);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDeath = EffectDeath();

    // Signal Spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_EXTERMINATE);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check race, and size
        if(nSize == CREATURE_SIZE_TINY && nHD <= 1 &&
          (nRace == RACIAL_TYPE_ANIMAL || nRace == RACIAL_TYPE_VERMIN))
        {
            // Spell Resistance + Immunity check
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Saving throw + Immunity check
                if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
                {
                    // Fail and we apply death
                    SMP_ApplyInstantAndVFX(oTarget, eVis, eDeath);
                }
            }
        }
    }
}
