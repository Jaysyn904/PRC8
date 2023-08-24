/*:://////////////////////////////////////////////
//:: Spell Name Grease: On Heartbeat
//:: Spell FileName PHS_S_GreaseC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grease will knockdown creatures (falling them) each round.

    The dexterity check replaces this text:

    A creature can walk within or through the area of grease at half normal speed
    with a DC 10 Balance check. Failure means it can’t move that round (and must
    then make a Reflex save or fall), while failure by 5 or more means it falls
    (see the Balance skill for details).

    Which only applies if they are doing ACTION_MOVETOPOINT.

    On Heartbeat:
    1. Reflex save else have knockdown applied to them for 6 seconds. The duration
       of this effect is 5.9 - fDelay.
    2. If they are still moving using ACTION_MOVETOPOINT, it will attempt a
       special balance check, and failing it, it will stop them using ClearAllActions()
       and a fail of result 5 or less means instant knockdown.

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
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
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
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GREASE);

            // Random delay to make it not all fire at once
            fDelay = PHS_GetRandomDelay(0.1, 0.3);

            fDuration = 5.9 - fDelay;

            // Reflex saving throw
            if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
            {
                // Apply damage and visuals
                DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eDur, fDuration));
            }
            else if(GetCurrentAction(oTarget) == ACTION_MOVETOPOINT)
            {
                // Are they moving? If so, DC 10 dexterity check
                nRoll = d20() + GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
                // If they fail it is < 10.
                if(nRoll < 10)
                {
                    // We at least ClearAllActions(), however...if 5 or under
                    if(nRoll <= 5)
                    {
                        // Apply damage and visuals
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eDur, fDuration));
                    }
                    else
                    {
                        AssignCommand(oTarget, ClearAllActions());
                    }
                }
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
