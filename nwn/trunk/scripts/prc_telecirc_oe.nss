//:://////////////////////////////////////////////
//:: Teleportation Circle Area of Effect OnEnter
//:: prc_telecirc_oe
//:://////////////////////////////////////////////
/** @file
    @author Ornedan
    @data   Created - 2005.10.25
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_teleport"
#include "inc_vfx_const"
#include "x0_i0_position"


void main()
{
    object oAoE = OBJECT_SELF;

    if(DEBUG && !GetLocalInt(oAoE, "PRC_TeleCircle_AoE_Inited"))
        DoDebug("prc_telecirc_oe: ERROR: Teleportation Circle data not initialised!");

    // Get the creature to teleport and the location to move it to
    object oTarget   = GetEnteringObject();
    location lTarget = GetTeleportError(GetLocalLocation(oAoE, "TargetLocation"), oTarget, TRUE);

    if(DEBUG) DoDebug("prc_telecirc_oe: Attempting to teleport " + DebugObject2Str(oTarget) + " to " + DebugLocation2Str(lTarget));

    // Assign the jump if the target can be teleported
    if(GetCanTeleport(oTarget, lTarget, TRUE))
    {
        DelayCommand(1.0f, AssignCommand(oTarget, JumpToLocation(lTarget)));
        DelayCommand(1.5, ShadowPounce(oTarget));    
    }    

    /// @todo: Some neat VFX here. Maybe the conjuration pillar effect?
    // Some VFX at the location the creature suddenly disappears from
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_CONJ_MIND), GetLocation(oTarget), 2.0f);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_CONJ_MIND), GetLocation(oTarget));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_CONJ_MIND), oTarget);
}