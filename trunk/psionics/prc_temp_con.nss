#include "prc_alterations"
void main()
{
    object oTarget = GetLastSpeaker();
    AssignCommand(OBJECT_SELF, SpeakString("Get thee gone, before I tempt thee again, fool."));

    object oWP = GetWaypointByTag("prc_runrunrun");
    AssignCommand(oTarget, ActionForceMoveToLocation(GetLocation(oWP), TRUE, 10.0));

    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 7.0);
}
