/*:://////////////////////////////////////////////
//:: Name Concentration Include
//:: FileName SMP_INC_CONCENTR
//:://////////////////////////////////////////////
    This holds the functions needed to recursivly call a spell script and not
    do the effects.

    Each spell like this needs:

    - A seperate AOE entry
    - A heartbeat for the AOE
    - These two checks in the spell script
    - All targets the effects are applied to, to be added to a special array
      (SMP_CONCENTRATE_123_654_ARRAY_123456)

    Use this instead of SMP_INC_SPELLS, it has it in it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: 23 may
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// SMP_INC_CONCENTR. Start concentrating
// Call this in a spell which concentrates. The AOE can be used to remove effects
// from targets in the Heartbeat event it uses. The AOE's location matters, and
// is created here. Only use if using SMP_ConcentatingContinueCheck() before it.
// ---
// Remember to set the objects affected to an array of SMP_CONCENTRATING + spell ID +
// times cast + array. RETURNS APPROPRATE ARRAY STRING (using TIMES CAST)
// ---
// * nSpellId - used for variables
// * nRoundLimit - We force a limit of rounds? If so, we use this local to enforce it
// * lTarget - Need to retarget at the same location for it to be a valid re-concentate
// * nAOEId - The AOE to create at lTarget FOR HEARTBEAT, IMPORTANT.
// * fExtraTime - How many rounds (minimum 1 second) after the effects stays
// * oCaster - Creator of the spell/effect
// It should create an AOE of the correct ID.
// RETURNS APPROPRATE ARRAY STRING (using TIMES CAST)
string SMP_ConcentatingStart(int nSpellId, int nRoundLimit, location lTarget, int nAOEId, float fExtraTime = 1.0, object oCaster = OBJECT_SELF);

// SMP_INC_CONCENTR. Continue concentrating - or not as the case may be.
// Call this in a spell which concentrates. It should be used to check if the
// spell just cast was just to concentrate some more, or not.
// This will delete the local used so the AOE will go and remove everything.
// ---
// We will get the times cast and limits from locals
// ---
// * nSpellId - used for variables
// * lTarget - Need to retarget at the same location for it to be a valid re-concentate
// * sAOETag - Tag of the AOE.
// * fExtraTime - How many rounds (minimum 1 second) after the effects stays
// * oCaster - Creator of the spell/effect
// TRUE if it IS a correct check and they are JUST concentrating. FALSE, and
// it is a new spell.
int SMP_ConcentatingContinueCheck(int nSpellId, location lTarget, string sAOETag, float fExtraTime = 1.0, object oCaster = OBJECT_SELF);

// SMP_INC_CONCENTR. Use in the AOE's heartbeat script.
// This will:
// 1 If the creator isn't valid, it will remove all effects from the spell
//   created by invalid creators and then delete itself.
// 2 If the variable doesn't exsist, then it will first delete all the people
//   in the array and then remove itself, as well as remove the spell effects from the people
void SMP_ConcentrationAOEHeartbeat(object oSelf, object oCaster, int nSpell);

// Start concentrating
string SMP_ConcentatingStart(int nSpellId, int nRoundLimit, location lTarget, int nAOEId, float fExtraTime = 1.0, object oCaster = OBJECT_SELF)
{
    // Starting at 1 concentating round.
    string sLocal = "SMP_CONCENTATING_" + IntToString(nSpellId);
    int nConcentratingRounds = 1;
    // Set round limit to override any previous
    SetLocalInt(oCaster, sLocal + "LIMIT", nRoundLimit);
    // Get times cast
    int nReturnTimesCast = SMP_IncreaseStoredInteger(oCaster, "SMP_TIMES_CAST" + IntToString(nSpellId));

    // Based on Times cast
    string sConcetrateLocal = sLocal + "_" + IntToString(nReturnTimesCast);

    // Set for this times cast it is valid to concentrate - starting rounds at 1
    // Start concentation at round 1.
    // - EG: SMP_CONCENTRATING_100_4, for spell 100, times cast, 4
    SetLocalInt(oCaster, sConcetrateLocal, 1);

    // Delete it after 6.0 + fExtraTime seconds so the AOE used stop
    DelayCommand(6.0 + fExtraTime, SMP_DeleteIntInTime(sLocal, oCaster, nConcentratingRounds));

    // Create the AOE
    effect eAOE = EffectAreaOfEffect(nAOEId);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, lTarget);

    // Do concentrating thing, another spell
    ClearAllActions();
    ActionCastSpellAtLocation(nSpellId, lTarget, METAMAGIC_NONE, TRUE);

    // End this script
    // Return the ARRAY STRING to use, IE:
    // sConcetrateLocal + "_ARRAY"
    // so:
    // "SMP_CONCENTATING_" + ID + "_" + TimesCast + "_ARRAY"
    // "SMP_CONCENTATING_100_5_ARRAY"
    return sConcetrateLocal + "_ARRAY";
}

// Continue concentrating - or not as the case may be.
// TRUE if it IS a correct check and they are JUST concentrating. FALSE, and
// it is a new spell.
int SMP_ConcentatingContinueCheck(int nSpellId, location lTarget, string sAOETag, float fExtraTime = 1.0, object oCaster = OBJECT_SELF)
{
    // Check they are even aiming it at the right place first
    object oAOE = SMP_GetNearestObjectByTagToLocation(OBJECT_TYPE_AREA_OF_EFFECT, sAOETag, lTarget);
    // Get times this spell has currently been cast
    int nTimesCast = GetLocalInt(oCaster, "SMP_TIMES_CAST" + IntToString(nSpellId));
    // Local used
    string sLocal = "SMP_CONCENTATING" + IntToString(nSpellId);
    string sConcetrateLocal = sLocal + "_" + IntToString(nTimesCast);

    // If the location matches the AOE there, and the AOE is by us, all is OK
    if(GetDistanceBetween(oAOE, oCaster) < 0.1 &&
       GetAreaOfEffectCreator(oAOE) == oCaster)
    {
        // ALL IS OK, we carry on as normal

        // We need to make sure that we have not reached the limits of the
        // rounds we can concentrate for.

        // Get limit of times to concentrating
        int nLimit = GetLocalInt(oCaster, sLocal + "LIMIT");

        // Increase times concentrating by 1 for this spell, for nTimesCast
        // * we rely upon the fact that nTimesCast is valid.
        int nConcentratingRounds = GetLocalInt(oCaster, sConcetrateLocal) + 1;

        // Reached the limit?
        if(nConcentratingRounds < nLimit)
        {
            // NO, we carry on casting

            // Set new concentrating local for the time
            SetLocalInt(oCaster, sConcetrateLocal, nConcentratingRounds);
            // Delete it after 6.0 + fExtraTime seconds so the AOE used stop
            DelayCommand(6.0 + fExtraTime, SMP_DeleteIntInTime(sConcetrateLocal, oCaster, nConcentratingRounds));

            // Do the spell cheat-casting again.
            ClearAllActions();
            ActionCastSpellAtLocation(nSpellId, lTarget, METAMAGIC_NONE, TRUE);
        }
        else
        {
            // YES, we stop
            SendMessageToPC(oCaster, "You cannot concetate anymore on this spell");
            // We make sure that nConcentratingRounds for nSpellId under nTimesCast
            // is invalid so the AOE works out the rest
            DeleteLocalInt(oCaster, sConcetrateLocal);
        }
        // Return TRUE, we have either ended the concentating, or carrying on,
        // but it was a valid call of it.
        return TRUE;
    }
    else
    {
        // We make sure that nConcentratingRounds for nSpellId under nTimesCast
        // is invalid so the AOE works out the rest
        DeleteLocalInt(oCaster, sConcetrateLocal);
    }
    // FALSE - we have a new spell on our hands. The local should mean the AOE
    // that used it will delete itself.
    return FALSE;
}

// Use in the AOE's heartbeat script.
// This will:
// 1 If the creator isn't valid, it will remove all effects from the spell
//   created by invalid creators and then delete itself.
// 2 If the variable doesn't exsist, then it will first delete all the people
//   in the array and then remove itself, as well as remove the spell effects from the people
void SMP_ConcentrationAOEHeartbeat(object oSelf, object oCaster, int nSpell)
{
    // The first time this fires, we need to set nTimesCast to ourselves
    int nTimesCast = GetLocalInt(oSelf, "TIMES_CAST");
    if(nTimesCast == 0)
    {
        // Also set us to plot until WE want to go
        SetPlotFlag(oSelf, TRUE);
        nTimesCast = GetLocalInt(oCaster, "SMP_TIMES_CAST" + IntToString(nSpell));
        SetLocalInt(oSelf, "TIMES_CAST", nTimesCast);
    }

    // We need to get the right local - in this case, calm emotions
    string sLocal = "SMP_CONCENTATING" + IntToString(nSpell);
    string sConcentrationLocal = sLocal + "_" + IntToString(nTimesCast);


    // If the creator isn't valid, it will remove all effects from the spell
    // created by invalid creators and then delete itself.
    if(!GetIsObjectValid(oCaster))
    {
        // Loop all creatures in the area and remove the spell from them
        // - OBJECT_INVALID for oCreator will be fine.
        SMP_RemoveAllSpellsFromCreator(nSpell, oCaster);

        // Destroy ourselves
        SetPlotFlag(oSelf, FALSE);
        DestroyObject(oSelf);
    }
    // If the variable doesn't exsist, then it will first delete all the people
    // in the array and then remove itself.
    else if(GetLocalInt(oCaster, sConcentrationLocal) == FALSE)
    {
        // Ok, its ended, or they cast it again, or an error - we thusly
        // remove the effects from everyone in the array.
        string sArray = sConcentrationLocal + "_ARRAY";
        // Get max (only integer of sArray value on oCaster) and remove.
        int nMax = GetLocalInt(oCaster, sArray);
        DeleteLocalInt(oCaster, sArray);
        int nCnt = 1;
        // Make sure nMax is valid!
        if(nMax > 0)
        {
            // Loop in the array until nMax
            object oRemoveFrom = GetLocalObject(oCaster, sArray + IntToString(nCnt));
            while(nCnt <= nMax)
            {
                // Remove it
                SMP_PRCRemoveSpellEffects(nSpell, oCaster, oRemoveFrom);
                // Delete from array
                DeleteLocalObject(oCaster, sArray + IntToString(nCnt));
                // Next one
                nCnt++;
                oRemoveFrom = GetLocalObject(oCaster, sArray + IntToString(nCnt));
            }
        }
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
