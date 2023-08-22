/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Wall: (Blindness) On Heartbeat
//:: Spell FileName PHS_S_PrisWallC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it stated above.

    Simplified a lot. It now doesn't stop spells or missiles (ugly!) but will
    do th effects of each thing On Enter - ugly!

    This is still powerful (very much so) for the level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    object oTarget;
    int nMetaMagic = PHS_GetAOEMetaMagic();
    float fDelay, fDuration;

    // Declare blindness
    effect eBlind = EffectBlindness();

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Check HD
            if(GetHitDice(oTarget) <= 8)
            {
                // Fire cast spell at event for the affected target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PRISMATIC_SPHERE);

                // Check if they can see
                if(PHS_GetCanSee(oTarget))
                {
                    // Check spell resistance
                    if(PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Get duration
                        fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 2, nMetaMagic);

                        // Get a small delay
                        fDelay = GetDistanceToObject(oTarget)/20;

                        // Apply blindness
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eBlind, fDuration));
                    }
                }
            }
        }
        //Get next target.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
