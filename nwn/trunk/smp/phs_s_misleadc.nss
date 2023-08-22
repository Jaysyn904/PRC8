/*:://////////////////////////////////////////////
//:: Spell Name Mislead - Concentration heartbeat
//:: Spell FileName PHS_S_MisleadC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is part of the concentratoin system. It will do the concentration
    heartbeat stuff.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONCENTR"

void main()
{
    // Get creator and us
    object oSelf = OBJECT_SELF;
    object oCaster = GetAreaOfEffectCreator(oSelf);
    int nSpell = PHS_SPELL_MISLEAD;

    // Do the function
    PHS_ConcentrationAOEHeartbeat(oSelf, oCaster, nSpell);
}
