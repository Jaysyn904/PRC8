/*:://////////////////////////////////////////////
//:: Spell Name Sleet Storm: On Heartbeat
//:: Spell FileName PHS_S_SleetStorC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I'll use Darkness style Invisibility + Darkness effect.

    No EffectUltravision() will be used in spells.

    The save is static, it was a DC10 Balance check, a DC10 reflex save is
    plenty large - still has a 1 in 20 chance of falling.

    13.33M is large! huge even! and it needs to be a good effect, it must
    really snow hard!

    Heartbeat does the DC10 reflex save, else knockdown. Taken mainly from
    Grease.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    // Static DC of 10
    int nSpellSaveDC = 10;
    float fDelay, fDuration;
    int nRoll;

    // Declare effects
    effect eDur = EffectKnockdown();

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the affected target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SLEET_STORM);

            // Random delay to make it not all fire at once
            fDelay = PHS_GetRandomDelay(0.1, 0.3);

            fDuration = 5.9 - fDelay;

            // Reflex saving throw
            if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
            {
                // Apply damage and visuals
                DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eDur, fDuration));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
