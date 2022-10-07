//:://////////////////////////////////////////////
//:: Telflammar Shadowlord: Shadow Jump
//:: tfshad_jump
//:://////////////////////////////////////////////
/** @file
    Shadow Jump (Su):
    A Telflammar Shadowlord can travel between
    shadows as if by means of a Dimension Door spell.
    The limitation is that the magical transport
    must begin and end in an area with at least some
    shadow or darkness. The shadowlord can jump up
    to a total of 20 feet per class level per day
    in this way. This amount can be split up among
    many jumps, but each jump, no matter how small,
    counts as a 10-foot increment.


    The shadow requirement is waived, since it's not
    possible to detect without builder intervention.
    This script also contains an implementation of
    Shadow Pounce.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_combat"
#include "prc_inc_sneak"
#include "prc_inc_teleport"

void main()
{
    // Declare major variables
    object oCaster   = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    effect eVis      = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    float fDistance  = GetDistanceBetweenLocations(lCaster,lTarget);
    int iLevel       = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);

    // Get the feat ID
    int iFeat = FEAT_SHADOWJUMP - 1 + GetLevelByClass(CLASS_TYPE_SHADOWLORD, oCaster);

    // Check if we're targeting some creature instead of just a spot on the floor
    object oTarget = PRCGetSpellTargetObject();
    if(GetIsObjectValid(oTarget))
        lTarget = GetLocation(oTarget);

    // Check if teleportation is possible
    if(!GetCanTeleport(oCaster, lTarget, TRUE, TRUE))
    {
        IncrementRemainingFeatUses(oCaster, iFeat);
        return;
    }

    vector vOrigin = GetPositionFromLocation(GetLocation(oCaster));
    vector vDest   = GetPositionFromLocation(lTarget);

    // Calculate the amount of jump range remaining
    int iLeftUse = 1; // Init to 1 to account for the use taken by the engine when activating the feat
    while(GetHasFeat(iFeat, oCaster))
    {
        DecrementRemainingFeatUses(oCaster, iFeat);
        iLeftUse++;
    }

    // Return the feat uses for now.
    /// @TODO This is inefficient, make it so that the uses are only returned after calculating how many will be left after the jump.
    int nCount = iLeftUse;
    while(nCount)
    {
        IncrementRemainingFeatUses(oCaster, iFeat);
        nCount--;
    }

    // Calculate the maximum distance jumpable
    float fMaxDis = FeetToMeters(iLeftUse * 20.0);

    // If the target is too far, abort
    if(fDistance > fMaxDis)
    {//                              "Your target is too far!"
        FloatingTextStrRefOnCreature(16825300, oCaster);
        return;
    }

    // Reduce feat uses based on the distance teleported
    nCount = FloatToInt(fDistance / FeetToMeters(10.0));
    // The minimum of 10 feet
    if(!nCount) nCount = 1;
    // Take away the required number of uses.
    while(nCount)
    {
        DecrementRemainingFeatUses(oCaster, iFeat);
        nCount--;
    }

    // Calculate the locations to apply the VFX at
    vOrigin = Vector(vOrigin.x + 2.0, vOrigin.y - 0.2, vOrigin.z);
    vDest   = Vector(vDest.x + 2.0, vDest.y - 0.2, vDest.z);

    // Do VFX
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
    DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));

    // Schedule the jump itself
    DelayCommand(0.8, AssignCommand(oCaster, JumpToLocation(lTarget)));

    // Class level 4 gives the Shadow Pounce ability, which gives one a full attack at the end of a jump
    if(iLevel >= 4)
    {
        DelayCommand(1.0f, PerformAttackRound(oTarget, oCaster, EffectVisualEffect(-1), 0.0, 0, 0, 0, FALSE, "", "", FALSE, FALSE, TRUE));
    }
}

