/*:://////////////////////////////////////////////
//:: Spell Name Repulsion Shell : On Enter (5M) (Important one)
//:: Spell FileName PHS_S_RepulsionE
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    How does this work, we wonder, eh?

    Well, since creatures come in all shapes and sizes, it is pretty hard. The
    game might not make it work right.

    At the moment it is 5M sphere, this means:

    - One sphere at 1M
    - One sphere at 2M
    ...
    - One sphere at 5M

    The 5M sphere has a special On Enter script. The rest all have a script which
    checks locals on the target, and caster, to see if they should push back.

    Note; To make sure that the caster can't push people back, a check for
    GetCurrentAction() is done and ActionMoveToPoint(). Also, instead of it
    collapsing when it is used hostility, it only prevents it working, so if
    they do move, we set it to not work for a few seconds too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Local ID for some of the things set by the biggest one
    // * Ok, so its long, oh well.
    string sID = "PHS_REPULSIONAOE" + IntToString(GetLocalInt(oCaster, "PHS_REPULSION_TIMES_CAST")) + ObjectToString(oCaster);

    // Stop if they are not an alive thing, or is plot, or is a DM
    if(GetIsDM(oTarget) || GetPlotFlag(oTarget) || oTarget == oCaster) return;

    // We do not do moving back just yet. Every target who is new and who enters
    // must make a will and SR check.


    // If we are starting still, do not hedge back
    if(GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_REPULSION))) return;

    // Check if we are moving, and therefore cannot force it agsint something
    // that would be affected!
    // * Uses special Repulsion version that only disables it.
    vector vVector = GetPosition(oCaster);
    object oArea = GetArea(oCaster);
    DelayCommand(0.1, PHS_MobileRepulsionAOECheck(oCaster, PHS_SPELL_REPULSION, vVector, oArea));

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // The target is allowed a Spell resistance and immunity check to force
    // thier way through the barrier
    if(GetLocalInt(oTarget, sID + "SR")) return;

    // Target allowed a will save to negate
    if(GetLocalInt(oTarget, sID + "WILL")) return;


    // Distance we need to move them back is going to be 4M away, so out of the
    // AOE.

    // Therefore, this is 4 - Current Distance.
    float fDistance =  4.0 - GetDistanceBetween(oCaster, oTarget);

    // Debug stuff, obviously we'll need to move them at least 1 meter away.
    if(fDistance < 1.0)
    {
        fDistance = 1.0;
    }

    // Move the enterer back from the caster.
    PHS_PerformMoveBack(oCaster, oTarget, fDistance, GetCommandable(oTarget));
}
