/*:://////////////////////////////////////////////
//:: Spell Name Telekinetic Sphere: Movement
//:: Spell FileName PHS_S_TelekinSpA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This moves the nearest person affected with Telekinetic Sphere from this
    caster, to move to the target location (20M range from the caster). The
    cutscene immobilis is removed and reset (to permanent) when they get to the
    target place.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Moves the person to lTarget.
void TeleMove(location lTarget, effect Stop);
// Wrappers Cutscene mode off, and commandable as approprate, into
// one function
void TeleSetOff(object oSelf, int bResetFalse, effect eStop);

void main()
{
    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();

    // Declare effects
    effect eStop = EffectCutsceneImmobilize(); // Applied seperatly.
    // Make the "effect eStop = EffectCutsceneImmobilize();" supernatural,
    // so it isn't dispelled (will be removed if the spell is though)
    eStop = SupernaturalEffect(eStop);

    // Get nearest person with the spells effects
    int nCnt = 1;
    object oCreature = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    while(GetIsObjectValid(oCreature) && !GetIsObjectValid(oTarget))
    {
        // Distance check
        if(GetDistanceToObject(oCreature) <= 20.0)
        {
            // Check if the effects are from us
            if(PHS_GetHasSpellEffectFromCaster(PHS_SPELL_TELEKINETIC_SPHERE, oCreature, oCaster))
            {
                // Make oTarget oCreature
                oTarget = oCreature;
            }
        }
        // Get next nearest creature
        nCnt++;
        oCreature = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }

    if(GetIsObjectValid(oTarget))
    {
        // Now, we assign the special movement to oTarget
        FloatingTextStringOnCreature("*You telekinetically move " + GetName(oTarget) + " to the specified location*", oCaster, FALSE);
        AssignCommand(oTarget, TeleMove(lTarget, eStop));
    }
    else
    {
        FloatingTextStringOnCreature("*You can force nothing to move*", oCaster, FALSE);
    }
}

// Moves the person to lTarget.
void TeleMove(location lTarget, effect eStop)
{
    // Target is self now, we are assigned this action
    object oSelf = OBJECT_SELF;

    // Remove the immobilis
    PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_CUTSCENEIMMOBILIZE, PHS_SPELL_TELEKINETIC_SPHERE, oSelf, SUBTYPE_SUPERNATURAL);
    PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_CUTSCENEIMMOBILIZE, PHS_SPELL_TELEKINETIC_SPHERE_MOVEMENT, oSelf, SUBTYPE_SUPERNATURAL);

    // Check plot flag + Some other things.
    // * As the cutscene function is used, this captures two attempts at it.
    // * Shouldn't break anything much. This move back should take no time at all.
    // * Note: Some effects seem to stop moving, dispite the SetCommandable() flag.
    if(PHS_GetIsImmuneToRepel(oSelf)) return;

    // We need the commandable flag to put it back correctly.
    int bCommandable = GetCommandable(oSelf);

    // Time taken will be 1/4 of fDisance
    float fTime = GetDistanceBetweenLocations(lTarget, GetLocation(oSelf)) / 4;

    // Clear all actions - must stop what we are doing to move.
    ClearAllActions();

    // Set local saying we are moving
    SetLocalInt(oSelf, "PHS_REPELLING", TRUE);

    // Set it ON
    SetCutsceneMode(oSelf, TRUE);

    // Set cutscene cameraman movement rate to high
    // * Reset after complete automatically
    SetCutsceneCameraMoveRate(oSelf, 2.0);

    // Move them
    int bResetFalse = FALSE;
    if(!bCommandable)
    {
        // Needs to be set commandable
        SetCommandable(TRUE, oSelf);
        bResetFalse = TRUE;
    }

    // Application of effects to make the slide look better.
    effect eMove = EffectMovementSpeedIncrease(99);

    // Apply the effects using Actions, as to not go on before falling dead
    ActionDoCommand(PHS_ApplyDuration(oSelf, eMove, fTime));

    // Move to point
    ActionMoveToLocation(lTarget, TRUE);

    ActionDoCommand(TeleSetOff(oSelf, bResetFalse, eStop));

    // Make sure to Set Commandable to FALSE, no AOO's, no actions changing
    SetCommandable(FALSE, oSelf);

    // Delay the cutscene mode OFF, and any commandable things, not an action.
    DelayCommand(fTime, TeleSetOff(oSelf, bResetFalse, eStop));
}

// Wrappers Cutscene mode off, and commandable as approprate, into
// one function
void TeleSetOff(object oSelf, int bResetFalse, effect eStop)
{
    // Do not remove twice
    if(!GetLocalInt(oSelf, "PHS_REPELLING")) return;
    // Delete local saying we are moving
    DeleteLocalInt(oSelf, "PHS_REPELLING");

    // Store current camerea position
    StoreCameraFacing();

    // Turn of cutscene mode.
    SetCutsceneMode(oSelf, FALSE);

    // Restore camera position after the reset of cutscene mode changed it
    RestoreCameraFacing();

    // Remove the effects (movement increase, ETC)
    effect eCheck = GetFirstEffect(oSelf);
    while(GetIsEffectValid(eCheck))
    {
        // Check effect type, creator, spell Id, subtype, and duration tpye,
        // to only remove the correct ones.
        if(GetEffectType(eCheck) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE &&
           GetEffectCreator(eCheck) == oSelf &&
           GetEffectSpellId(eCheck) == SPELL_INVALID &&
           GetEffectSubType(eCheck) == SUBTYPE_SUPERNATURAL &&
           GetEffectDurationType(eCheck) == DURATION_TYPE_TEMPORARY)
        {
            RemoveEffect(oSelf, eCheck);
        }
        // Get next effect
        eCheck = GetNextEffect(oSelf);
    }

    // Reset the state of commandable if need be.
    if(bResetFalse == FALSE)
    {
        // Reset commandable state after delay so we can move again
        SetCommandable(TRUE, oSelf);
    }
    // Stop what we are doing too
    ClearAllActions();
    // Reapply the immobilis
    PHS_ApplyPermanent(oSelf, eStop);
}
