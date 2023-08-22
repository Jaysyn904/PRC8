/*:://////////////////////////////////////////////
//:: Spell Name Imprisonment
//:: Spell FileName PHS_S_Imprison
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 9
    Components: V, S
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: Instantaneous
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    When you cast imprisonment and touch a creature, it is entombed in a state
    of suspended animation (see the temporal stasis spell) in a small sphere far
    beneath the surface of the earth. All inhibiting movement spells are removed
    when they are transported. The subject remains there unless a freedom spell
    is cast at the locale where the imprisonment took place. Magical search by
    a crystal ball, a locate object spell, or some other similar divination
    does not reveal the fact that a creature is imprisoned, but discern
    location does. A wish or miracle spell will not free the recipient, but
    will reveal where it is entombed. If you know the target’s name and some
    facts about its life, the target takes a -4 penalty on its save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Save VS will, or get sent to a place like maze! :-)

    Easy to do, and uses some of mazes things.

    No getting out, however. This can be like death to a PC, so we pop up a
    dialog box for death like Petrify.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Gets one location from the 4 prison location points - denoted by
// PHS_S_IMPRISONMENT_TARGET + IntToString(1, 2, 3, 4).
// * Tries to get an empty one.
location GetImprisonLocation();

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oTargetArea = GetArea(oTarget);
    // - Use oTarget location in case GetSpellTargetLocatoin() isn't equal to it.
    location lTarget = GetLocation(oTarget);
    object oNewPrisonObject;
    object oPrisonPoint = GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET);
    // We use JumpToLocation. We will move them to one of 4 "Prisons" in the
    // area. If more then 4 people are there, of course, it'll just add it to
    // the first one (hey, its found the same space :-P ).
    location lPrisonPoint = GetImprisonLocation();

    // DC
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // +4 DC if equal faction
    if(GetFactionEqual(oTarget))
    {
        nSpellSaveDC += 4;
    }

    // Delcare impact effect
    effect eImpact1 = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eImpact2 = EffectVisualEffect(PHS_VFX_FNF_IMPRISONMENT);
    // A duration effect, just so it is something to check.
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_IMPRISONMENT, TRUE);

    // No beam hit/miss visual - basically, the new VFX looks better.

    // Melee Touch Attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // - It is a minotaur?
        // - Can it be destroyed?
        if(PHS_CanCreatureBeDestroyed(oTarget) &&
           GetIsObjectValid(oPrisonPoint) &&
          !PHS_IsInMazeArea(oTarget) &&
          !PHS_IsInPrisonArea(oTarget))
        {
            // Spell Resistance and immunity Check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Apply AOE visuals at the targets location
                    // (not on the target, who will move)
                    PHS_ApplyLocationVFX(lTarget, eImpact1);
                    PHS_ApplyLocationVFX(lTarget, eImpact2);

                    // Apply a duration effect
                    PHS_ApplyPermanent(oTarget, eDur);

                    // Set variables to jump back to.
                    SetLocalLocation(oTarget, PHS_S_MAZEPRISON_LOCATION, lTarget);
                    SetLocalObject(oTarget, PHS_S_MAZEPRISON_OLD_AREA, oTargetArea); // A check for LOCATION is valid.

                    // Create Imprisonment object, and set local object to the target
                    oNewPrisonObject = CreateObject(OBJECT_TYPE_PLACEABLE, PHS_IMPRISONMENT_OBJECT, lTarget);
                    // Set local object so freedom works.
                    SetLocalObject(oNewPrisonObject, PHS_MAZEPRISON_OBJECT, oTarget);
                    // Set local object on the PC so they know which is thiers
                    // - Same variable name.
                    SetLocalObject(oTarget, PHS_MAZEPRISON_OBJECT, oNewPrisonObject);

                    // Move the target using special function
                    AssignCommand(oTarget, PHS_ForceMovementToLocation(lTarget));

                    // Set plot flag on enter, and are set to uncommandable.
                }
            }
        }
    }
}

// Gets one location from the 4 prison location points - denoted by
// PHS_S_IMPRISONMENT_TARGET + IntToString(1, 2, 3, 4).
// * Tries to get an empty one.
location GetImprisonLocation()
{
    // Go from 4 to 1. We put anyone in 1 if no where else.
    int nTest = 4;
    object oPC, oTestTarget = GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET + IntToString(nTest));
    while(GetIsObjectValid(oTestTarget))
    {
        // Last one? Return it now!
        if(nTest == 1)
        {
            return GetLocation(oTestTarget);
        }
        else
        {
            // Test if this one is empty. anyone within 5M of it?
            oPC = GetNearestObject(OBJECT_TYPE_CREATURE, oTestTarget);
            if(GetDistanceBetween(oPC, oTestTarget) > 5.0)
            {
                // Valid, nothing within 5M (we set the location they go to
                // to be directly over the target).
                return GetLocation(oTestTarget);
            }
        }
    }
    // If invalid return the location of PHS_S_IMPRISONMENT_TARGET (at the
    // centre of the area, will push the PC to nearby!)
    return GetLocation(GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET));
}
