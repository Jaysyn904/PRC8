/*:://////////////////////////////////////////////
//:: Spell Name Web: On Exit
//:: Spell FileName PHS_S_WebA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Exit:

    Remove all web spell effects. Web spells do not overlap.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();

    // Remove all web effects
    effect eAOE = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eAOE))
    {
        // If the effect was created by the Web then remove it
        if(GetEffectCreator(eAOE) == oCaster)
        {
            if(GetEffectSpellId(eAOE) == PHS_SPELL_WEB)
            {
                RemoveEffect(oTarget, eAOE);
            }
        }
        eAOE = GetNextEffect(oTarget);
    }
}
