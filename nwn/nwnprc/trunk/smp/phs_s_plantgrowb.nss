/*:://////////////////////////////////////////////
//:: Spell Name Plant Growth: On Exit
//:: Spell FileName PHS_S_PlantGrowB
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
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_PLANT_GROWTH);
}
