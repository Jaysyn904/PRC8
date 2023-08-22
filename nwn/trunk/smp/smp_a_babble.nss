/*:://////////////////////////////////////////////
//:: Monster Ability Name Allip Babble
//:: Monster Ability FileName SMP_A_Babble
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Babble (Su): An allip constantly mutters and whines to itself, creating a
    hypnotic effect. All sane creatures within 20 meters of the allip must succeed
    on a DC 16 Will save or be affected as though by a hypnotism spell for 2d4
    rounds. This is a sonic mind-affecting compulsion effect.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Hypnotism for those in the area (heartbeat script).

    Note: Anyone who saves against its effects are rendered immune to them
    for the duration.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_ABILITY"

void main()
{
    // Create the AOE effect
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_BABBLE);

    // Supernatural effect
    eAOE = SupernaturalEffect(eAOE);

    // Place the effect on us forever.
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
