#include "prc_alterations"
void main()
{
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    object oTarget = GetObjectByTag("PRC_Temptation");
    object oWP = GetWaypointByTag("prc_temptation");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oWP));
    DestroyObject(oTarget);
}
