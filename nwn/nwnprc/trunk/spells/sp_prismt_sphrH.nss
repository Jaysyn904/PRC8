//::///////////////////////////////////////////////
//:: Name      Prismatic Sphere on heartbeat
//:: FileName  sp_prismt_sphrH.nss
//:://////////////////////////////////////////////
// a heartbeat script for Prismatic Sphere

#include "prc_inc_spells"

void main()
{
        //SendMessageToAllPCs("Prismatic Sphere heartbeat.");

        float fDurFX = 3.0;
        location lTarget = GetLocation(OBJECT_SELF);

        // Handles visual fx of the spell (and continued on the heartbeat script) since the fx seem to last max 3 secs.
        effect eVFX = EffectVisualEffect(VFX_DUR_PRISMATIC_SPHERE, FALSE, 1.0, [0.0,0.0,0.064], [0.0,0.0,0.36]);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lTarget, fDurFX);
        // Repeats the vFX after 3 seconds
        DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lTarget, fDurFX));
}
