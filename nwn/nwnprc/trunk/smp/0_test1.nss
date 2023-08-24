#include "phs_inc_visuals"

void main()
{
    // Fires set VFX
    int iVFX = GetLocalInt(OBJECT_SELF, "VFX");

    if(iVFX > 0)
    {
        object oTarget = GetNearestObjectByTag("CombatDummy");

        if(!GetIsObjectValid(oTarget)) return;

        effect eVis;

        if(iVFX == VFX_BEAM_DISINTEGRATE ||
           iVFX == VFX_BEAM_FLAME ||
           iVFX == VFX_BEAM_BLACK ||
           iVFX == VFX_BEAM_CHAIN ||
           iVFX == VFX_BEAM_COLD ||
           iVFX == VFX_BEAM_EVIL ||
           iVFX == VFX_BEAM_FIRE ||
           iVFX == VFX_BEAM_FIRE_LASH ||
           iVFX == VFX_BEAM_FIRE_W ||
           iVFX == VFX_BEAM_FIRE_W_SILENT ||
           iVFX == VFX_BEAM_HOLY ||
           iVFX == VFX_BEAM_LIGHTNING ||
           iVFX == VFX_BEAM_MIND ||
           iVFX == VFX_BEAM_ODD)
        {
            eVis = EffectBeam(iVFX, OBJECT_SELF, BODY_NODE_CHEST);
        }
        else
        {
            eVis = EffectVisualEffect(iVFX);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 12.0);
    }
}
