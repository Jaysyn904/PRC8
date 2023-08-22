#include "prc_alterations"
#include "prc_inc_teleport"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lCaster = GetLocation(oCaster);

    // Check if we're targeting some creature instead of just a spot on the floor
    location lTarget = GetSpellTargetLocation();
    object oTarget = PRCGetSpellTargetObject();
    if(GetIsObjectValid(oTarget))
        lTarget = GetLocation(oTarget);

    // Check if teleportation is possible
    if(!GetCanTeleport(oCaster, lTarget, TRUE, TRUE))
    {
        IncrementRemainingFeatUses(oCaster, FEAT_FATEFUL_STRIDE);
        return;
    }

    float fDistance = GetDistanceBetweenLocations(lCaster, lTarget);
    float fMaxDis = FeetToMeters(400 + (GetLevelByClass(CLASS_TYPE_BFZ, oCaster) * 40.0));

    // If the target is too far, abort
    if(fDistance > fMaxDis)
    {//                              "Your target is too far!"
        IncrementRemainingFeatUses(oCaster, FEAT_FATEFUL_STRIDE);
        FloatingTextStrRefOnCreature(16825300, oCaster);
        return;
    }

    effect eVis=EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    vector vOrigin = GetPositionFromLocation(lCaster);
    vector vDest   = GetPositionFromLocation(lTarget);

    // Calculate the locations to apply the VFX at
    vOrigin = Vector(vOrigin.x+2.0, vOrigin.y-0.2, vOrigin.z);
    vDest   = Vector(vDest.x+2.0, vDest.y-0.2, vDest.z);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
    DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));
    DelayCommand(0.8, AssignCommand(oCaster, JumpToLocation(lTarget)));
}