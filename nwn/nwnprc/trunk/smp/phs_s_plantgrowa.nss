/*:://////////////////////////////////////////////
//:: Spell Name Plant Growth: On Enter
//:: Spell FileName PHS_S_PlantGrowA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed from the original, it does take the overgrowth part seriously.

    It also can only be cast outdoors, overground.

    90% (or 60% for larger+ creatures) movement speed decrease. Anyone with
    the correct feats are not affected. (FEAT_WOODLAND_STRIDE)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    //Declare major effects
    effect eSlow;

    switch(GetCreatureSize(oTarget))
    {
        case CREATURE_SIZE_HUGE:
        case CREATURE_SIZE_LARGE:
        {
            eSlow = EffectMovementSpeedDecrease(80);
        }
        break;
        //case CREATURE_SIZE_MEDIUM:
        //case CREATURE_SIZE_SMALL:
        //case CREATURE_SIZE_TINY:
        default:
        {
            eSlow = EffectMovementSpeedDecrease(80);
        }
        break;
    }

    // Check for the feat
    if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget))
    {
        //Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PLANT_GROWTH);

        // Apply effects
        PHS_AOE_OnEnterEffects(eSlow, oTarget, PHS_SPELL_PLANT_GROWTH);
    }
}
