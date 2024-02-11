#include "prc_alterations"
void main()
{
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    object oTarget = GetObjectByTag("PRC_Compassion");
    object oWP = GetWaypointByTag("prc_compassion");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oWP));
    DestroyObject(oTarget);
}
