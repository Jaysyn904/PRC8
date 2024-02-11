/*:://////////////////////////////////////////////
//:: Name Repulsion include
//:: FileName SMP_INC_REPULSE
//:://////////////////////////////////////////////
    Big respect to Eldernurin.

    I still cannot even get vectors, and cirtainly the way this is done is quite
    sound enough to use for most spells which push people back in some way.

    ok, using ActionMoveAwayFromLocation, and assigning the action to the
    target so cutscene mode among other things works, and easier to assign
    actions.

    This will not work, for some reason, in any case against paralsis (and I guess
    a few other effects) and thusly will not even attempt against them, as it
    will stop them doing anything (well, anything..more) as the cutscene mode
    is annoying.

    Reason, it seems, is SetCommandable() will not work - it mearly never becomes
    commandable, evne though GetCommandable() works as expected :-)

    Edited for Spellmans.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_CONSTANT"

// Created by: Eldernurin
// Date: March 2004
// Type: #include file
// I would prefer that credit be given for this work
// or at least, that no one else takes credit for "slight"
// modifications of it.

// NOT THIS ANYMORE:
// * They will call sections of "SMP_DoActionMoveBack()", to move them at intervals,
//   which will solve any "jumping" or trying to move to odd location.

// SMP_INC_REPULSE. This will repulse oTarget from oSource.
// MUST ASSIGN THIS TO A PERSON, that person is oTarget.
// * The distance is needed to be put in.
// * Uses ActionMoveAwayFromLocation() to move away, basically.
// * The time it takes is calculated simply.
// Thanks to Eldernurin for the main ideas and code.
void SMP_ActionRepel(float fDistance, object oSource);

// SMP_INC_REPULSE. Simply adds fDistanceBack + Distance between oSource and OBJECT_SELF,
// then calls SMP_ActionRepel().
void SMP_ActionRepelBackwards(float fDistanceBack, object oSource);

// SMP_INC_REPULSE. Gets a location in a straight line, between oSouce and oTarget, adding fDistance.
location SMP_GetLocationBehind(object oSource, object oTarget, float fDistance);
// SMP_INC_REPULSE. Gets a location in a straight line, between lSource and lTarget, adding fDistance.
location SMP_GetLocationBehindLocation(location lSource, location lTarget, float fDistance);
// SMP_INC_REPULSE. Things that basically will always stop repelling are here.
// * Petrify, Appear/Disappear, Plot Flag, Paralsis, Entanglement, Sleep.
int SMP_GetIsImmuneToRepel(object oCreature);
// SMP_INC_REPULSE. Wrappers Cutscene mode off, and commandable as approprate, into
// one function. Also removes the tempoary effects, if any left.
void SMP_RepelSetOff(object oSelf, int bResetFalse);

// SMP_INC_REPULSE. This will repulse oTarget from oSource.
// MUST ASSIGN THIS TO A PERSON, that person is oTarget.
// * The distance is needed to be put in.
// * Uses ActionMoveAwayFromLocation() to move away, basically.
// * The time it takes is calculated simply.
// Thanks to Eldernurin for the main ideas and code.
void SMP_ActionRepel(float fDistance, object oSource)
{
    // Target is self now, we are assigned this action
    object oSelf = OBJECT_SELF;
    // Get source's location
    location lSource = GetLocation(oSource);

    // Check plot flag + Some other things.
    // * As the cutscene function is used, this captures two attempts at it.
    // * Shouldn't break anything much. This move back should take no time at all.
    // * Note: Some effects seem to stop moving, dispite the SetCommandable() flag.
    if(SMP_GetIsImmuneToRepel(oSelf)) return;

    // We need the commandable flag to put it back correctly.
    int bCommandable = GetCommandable(oSelf);

    // Time taken will be 1/4 of fDisance
    float fTime = fDistance / 4;

    // Clear all actions - must stop what we are doing to move.
    ClearAllActions();

    // Set local saying we are moving
    SetLocalInt(oSelf, "SMP_REPELLING", TRUE);

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

    // Do the fall down
    // Fall down "dead", on the back, like knockdown.
    // * Note: It is an action.
    ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 90.0, 0.5);

    // Application of effects to make the slide look better.
    effect eFreeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eMove = EffectMovementSpeedIncrease(99);
    effect eLink = EffectLinkEffects(eFreeze, eMove);
    eLink = SupernaturalEffect(eLink);

    // Apply the effects using Actions, as to not go on before falling dead
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSelf, fTime));

    // Move away
    // * Use fPause to properly go down "dead"
    ActionMoveAwayFromLocation(lSource, TRUE, fDistance);

    ActionDoCommand(SMP_RepelSetOff(oSelf, bResetFalse));

    // Make sure to Set Commandable to FALSE, no AOO's, no actions changing
    SetCommandable(FALSE, oSelf);

    // Delay the cutscene mode OFF, and any commandable things, not an action.
    DelayCommand(fTime, SMP_RepelSetOff(oSelf, bResetFalse));
}
// SMP_INC_REPULSE. Simply adds fDistanceBack + Distance between oSource and OBJECT_SELF,
// then calls SMP_ActionRepel().
void SMP_ActionRepelBackwards(float fDistanceBack, object oSource)
{
    // Get full distance to go away
    float fDistance = GetDistanceBetween(oSource, OBJECT_SELF) + fDistanceBack;

    // Move
    SMP_ActionRepel(fDistance, oSource);
}

// SMP_INC_SPELLS. Gets a location in a straight line, between oSouce and oTarget, adding fDistance.
location SMP_GetLocationBehind(object oSource, object oTarget, float fDistance)
{
    // * Thanks to BrainByte!

    // Get target area and facing to be used for the new location.
    object oArea = GetArea(oTarget);
    float fFacing = GetFacing(oTarget);
    // Get target position and relative position.
    vector vTarget = GetPosition(oTarget);
    vector vDelta = GetPosition(oTarget) - GetPosition(oSource);
    // Normalize transfer vector.
    vector vModified = VectorNormalize(vDelta);
    // Apply constant distance.
    vModified = Vector(vModified.x * fDistance, vModified.y * fDistance, vModified.z);
    // Get the new location.
    location locModified = Location(oArea, vTarget + vModified, fFacing);
    // Return the location.
    return locModified;
}
// SMP_INC_SPELLS. Gets a location in a straight line, between lSource and lTarget, adding fDistance.
location SMP_GetLocationBehindLocation(location lSource, location lTarget, float fDistance)
{
    // Get target area and facing to be used for the new location.
    object oArea = GetArea(OBJECT_SELF);
    float fFacing = 0.0;// Doesn't matter
    // Get target position and relative position.
    vector vTarget = GetPositionFromLocation(lTarget);
    vector vDelta = GetPositionFromLocation(lTarget) - GetPositionFromLocation(lSource);
    // Normalize transfer vector.
    vector vModified = VectorNormalize(vDelta);
    // Apply constant distance.
    vModified = Vector(vModified.x * fDistance, vModified.y * fDistance, vModified.z);
    // Get the new location.
    location locModified = Location(oArea, vTarget + vModified, fFacing);
    // Return the location.
    return locModified;
}
/*
// SMP_INC_REPULSE. Checks for things like Paralysis, that stop any "Falling over".
// Basically, anything that will use VFX_DUR_FREEZE_ANIMATIONS will be got.
// * List:
//   - Cutscene Paralsis, Entangle, Paralysis, Sleep.
int SMP_GetIsDisabledFromMoving(object oCreature)
{
    // Run through effects
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        // Check effect type (any source)
        switch(GetEffectType(eCheck))
        {
            // Things that disable falling over (EG: Cannot move, or already on ground)
            case EFFECT_TYPE_CUTSCENE_PARALYZE:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_SLEEP:
            //case EFFECT_TYPE_STUNNED: * Not one actually. They still "Sway".
            {
                return TRUE;
            }
            break;
        }
        // Get next effect
        eCheck = GetNextEffect(oCreature);
    }
    // Return FALSE - nothing that directly stops them falling over.
    return FALSE;
}
*/
// SMP_INC_REPULSE. Things that basically will always stop repelling are here.
// * Petrify, Appear/Disappear, Plot Flag
int SMP_GetIsImmuneToRepel(object oCreature)
{
    // Run through effects
    effect eCheck = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eCheck))
    {
        // Check effect type (any source)
        switch(GetEffectType(eCheck))
        {
            // Things that disable moving at all, it seems.
            case EFFECT_TYPE_CUTSCENE_PARALYZE:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_PARALYZE:
            // case EFFECT_TYPE_SLEEP: // * Note: On sleep, it can still be pushed back (has a HB)
            // These always included here anyway
            case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
            case EFFECT_TYPE_DISAPPEARAPPEAR:
            case EFFECT_TYPE_PETRIFY:
            {
                return TRUE;
            }
            break;
        }
        // Get next effect
        eCheck = GetNextEffect(oCreature);
    }
    // Return plot flag status as a default return value.
    return GetPlotFlag(oCreature);
}

// SMP_INC_REPULSE. Wrappers Cutscene mode off, and commandable as approprate, into
// one function
void SMP_RepelSetOff(object oSelf, int bResetFalse)
{
    // Do not remove twice
    if(!GetLocalInt(oSelf, "SMP_REPELLING")) return;
    // Delete local saying we are moving
    DeleteLocalInt(oSelf, "SMP_REPELLING");

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
}
// * Currently unused
location NewLoc(object oTarget, float fDistance)
{
    vector v1 = GetPosition(oTarget);
    vector v2 = GetPosition(OBJECT_SELF);
    vector v3;
    vector v4 = v2*-1.0;
    vector vn = v1+v4;
    vn = VectorNormalize(vn);
    vn= vn*fDistance;
    vn= vn+v1;
    int nNth=1;

    object oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
    while(GetIsObjectValid(oWp))
    {
        nNth++;

        v3= GetPosition(oWp);

        if(((v3.x<vn.x)&&(v2.x<v3.x))||((v3.x>vn.x)&&(v2.x>v3.x)))
        vn.x=v3.x;

        if(((v3.y<vn.y)&&(v2.y<v3.y))||((v3.y>vn.y)&&(v2.y>v3.y)))
        vn.y=v3.y;

        oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
    }

    return Location(GetArea(OBJECT_SELF), vn, GetFacing(OBJECT_SELF));
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
