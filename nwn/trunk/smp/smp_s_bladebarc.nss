/*:://////////////////////////////////////////////
//:: Spell Name Blade Barrier : On Heartbeat 1 (SQUARE)
//:: Spell FileName SMP_S_BladeBarC
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
    object oTarget;
    int nCasterLevel = SMP_GetAOECasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nDamage;
    int nSpellId = GetSpellId();
    int nMetaMagic = SMP_GetAOEMetaMagic();

    // Dice is limited to 15
    int nDice = SMP_LimitInteger(nCasterLevel, 15);

    // Loop targets in our AOE.
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        // Do damage
        if(!GetIsReactionTypeFriendly(oTarget, oCreator) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the target
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
        oTarget = GetNextInPersistentObject();
    }
}
