/*:://////////////////////////////////////////////
//:: Spell Name Darkness: On Exit
//:: Spell FileName PHS_S_DarknessB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE mearly applies a 20% consealment bonus. Note that if they have Daylight
    applied to them, then it cannot be consealed as the effects negate each
    other.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Remove one lot of darkness.
    object oTarget = GetExitingObject();
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        if(GetEffectSpellId(eAOE) == PHS_SPELL_DARKNESS)
        {
            // Remove only 1
            RemoveEffect(oTarget, eAOE);
            return;
        }
        // Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}
