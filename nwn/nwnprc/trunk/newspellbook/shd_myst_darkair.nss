/*
15/02/19 by Stratovarius

Dark Air

Initiate, Elemental Shadows 
Level/School: 5th/Transmutation [Air]

Reaching out with your mind to the darkness attached to your soul, you infuse nature with shadow and compel it to do your will.

This mystery acts like the spell control wind, tossing creatures about and knocking them to the ground if they fail a reflex save.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void DoRandomMove(object oTarget)
{
    // Calculate the new location
    object oArea    = GetArea(oTarget);
    float fDistance = FeetToMeters(10.0f * d4());
    float fAngle    = IntToFloat(Random(3600)) / 10.0;
    float fFacing   = IntToFloat(Random(3600)) / 10.0;
    vector vOrigin  = GetPosition(oTarget);
    vector vAngle   = AngleToVector(fAngle);
    vector vTarget  = vOrigin + (vAngle * fDistance);

    // If there is blocking geometry on the way, determine where
    if(!LineOfSightVector(vOrigin, vTarget))
    {
        float fEpsilon    = 1.0f;          // Search precision
        float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
        float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
        fDistance         = fDistance / 2; // The search position, set to middle of the range

        do{
            // Create test vector for this iteration
            vTarget = vOrigin + (vAngle * fDistance);

            // Determine which bound to move.
            if(LineOfSightVector(vOrigin, vTarget))
                fLowerBound = fDistance;
            else
                fUpperBound = fDistance;

            // Get the new middle point
            fDistance = (fUpperBound + fLowerBound) / 2;
        }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
    }// end if - The location was blocked by geometry

    // Create the final target vector
    vTarget = vOrigin + (vAngle * fDistance);

    // Move the target
    int bCommandable            = GetCommandable(oTarget);
    location lTargetDestination = Location(oArea, vTarget, fFacing);
    float fDelay                = PRCGetRandomDelay();

    // Set commandable if it isn't already
/*    if(!bCommandable)
        SetCommandable(TRUE, oTarget);*/

    // Assign jump commands
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, JumpToLocation(lTargetDestination));

    // Set commandability off it it was off in the beginning
/*    if(!bCommandable)
        AssignCommand(oTarget, ActionDoCommand(SetCommandable(FALSE, oTarget)));*/
/*DoDebug("DoRandomMove(): Jumping creature " + DebugObject2Str(oTarget) + "\n"
      + "Old location = " + DebugLocation2Str(GetLocation(oTarget)) + "\n"
      + "New location = " + DebugLocation2Str(lTargetDestination) + "\n"
      + "Commandability = " + DebugBool2String(bCommandable) + "\n"
        );*/
    // Do some VFX during the jump delay
    DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, oArea, vOrigin, vTarget, 0.0f,
                               FloatToInt(GetDistanceBetweenLocations(GetLocation(oTarget), lTargetDestination)), // One VFX every meter
                               fDelay
                               );
}

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    location lTarget    = PRCGetSpellTargetLocation();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STORM), lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TORNADO), lTarget);
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0f), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, myst.nMystId, oShadow);

                if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_WIND), oTarget);
                }// end if - Reflex save
                DoRandomMove(oTarget);
            }// end if - Difficulty check

            // Get next target
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0f), lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Explosion target loop      
    }
}