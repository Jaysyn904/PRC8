/*:://////////////////////////////////////////////
//:: Spell Name Hypnotic Pattern: On Heartbeat
//:: Spell FileName PHS_S_HypnoticPC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses new functions in PHS_INC_CONCENTR file, like Calm Emotions.

    Should be easier to debug.

    The AOE doesn't do anything except for check the validity of its creator,
    and the correct variables.

  1 If the variable doesn't exsist, then it will first delete all the people
    in the array and then remove itself.

  2 If the creator isn't valid, it will remove all effects from the spell
    created by invalid creators and then delete itself.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONCENTR"

void main()
{
    // Get creator and us
    object oSelf = OBJECT_SELF;
    object oCaster = GetAreaOfEffectCreator(oSelf);
    int nSpell = PHS_SPELL_HYPNOTIC_PATTERN;

    // Do the function
    PHS_ConcentrationAOEHeartbeat(oSelf, oCaster, nSpell);
}
