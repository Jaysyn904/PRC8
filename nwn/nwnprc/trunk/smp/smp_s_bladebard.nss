/*:://////////////////////////////////////////////
//:: Spell Name Blade Barrier : On Enter 2 (ROUND)
//:: Spell FileName SMP_S_BladeBarD
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Here, apply the right one.

    Can be a circle, or a wall.

    Either way, it provides cover to those who stay in it, and does damage
    every heartbeat, and on enter.

    HB:
    - Damage (Up to 15d6) piercing, reflex save
    Enter:
    - Apply (if not already got) Blade Barrier +4AC, +2 Reflex saves
    Exit:
    - Remove (if couter at 0) all blade barrier effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check AOE creator.
    if(!SMP_CheckAOECreator()) return;

    // Declare Major Variables
    object oCreator = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nCasterLevel = SMP_GetAOECasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nDamage;
    int nMetaMagic = SMP_GetAOEMetaMagic();
    int nSpellId = GetSpellId();

    // Dice is limited to 15
    int nDice = SMP_LimitInteger(nCasterLevel, 15);

    // Declare major effects
    effect eAC = EffectACIncrease(4, AC_DODGE_BONUS);
    effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);

    // Link
    effect eLink = EffectLinkEffects(eAC, eReflex);

    // PvP Check, Do damage
    if(!GetIsReactionTypeFriendly(oTarget, oCreator) &&
    // Make sure they are not immune to spells
       !SMP_TotalSpellImmunity(oTarget))
    {
        // Check if we can even hit them
        if(GetDistanceToObject(oTarget) > 2.0)
        {
            // Fire cast spell at event for the target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BLADE_BARRIER);

            // Spell Resistance check
            if(!SMP_SpellResistanceCheck(oCreator, oTarget))
            {
                // Declare damage
                nDamage = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Reflex save - +2 DC IF they have blade barriers +2 reflex save
                if(GetHasSpellEffect(nSpellId, oTarget))
                {
                    // Reflex save
                    nDamage = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC + 2, SAVING_THROW_TYPE_NONE, oCreator);
                }
                else
                {
                    // Reflex save
                    nDamage = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCreator);
                }

                if(nDamage > 0)
                {
                    // Apply damage
                    SMP_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_SLASHING);
                }
            }
        }
    }

    // Always apply effects of the spell (+4 AC, +2 reflex saves).
    SMP_AOE_OnEnterEffects(eLink, oTarget, SMP_SPELL_BLADE_BARRIER);
}
