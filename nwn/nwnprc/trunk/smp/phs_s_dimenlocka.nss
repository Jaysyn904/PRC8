/*:://////////////////////////////////////////////
//:: Spell Name Dimensional Lock : On Enter
//:: Spell FileName PHS_S_Dimenlocka
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Visual effect only applied.

    It is for 1 day/level...but this might not be wise. It can stay that way
    for now - it is a level 8 spell!!!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check caster
    if(PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    object oSelf = OBJECT_SELF;
    string sId = "PHS_DIMEN_LOCK_SR" + ObjectToString(oTarget);
    int nSR;

    // Delcare effects
    effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DIMENSIONAL_LOCK);

    // Because this AOE allows SR checks, we must store the result somehow.
    // * Local integer, also used On Exit to not remove if there are 2 locks
    //   overlapping.
    int nPrevious = GetLocalInt(oSelf, sId);

    // If nPrevious is 1, it is resisted. If 0, not taken. If 2, it failed.
    if(nPrevious == 0)
    {
        // Check SR
        nSR = PHS_SpellResistanceCheck(oCaster, oTarget);

        if(nSR == FALSE)
        {
            nPrevious = 2;
        }
        else
        {
            nPrevious = 1;
        }
    }
    // Failed...
    if(nPrevious == 2)
    {
        // Apply On Enter effects
        PHS_AOE_OnEnterEffects(eDur, oTarget, PHS_SPELL_DIMENSIONAL_LOCK);
    }
    //else
    //{
        // Nothing. Passed.
    //}
    // Set it for later use
    SetLocalInt(oSelf, sId, nPrevious);
}
