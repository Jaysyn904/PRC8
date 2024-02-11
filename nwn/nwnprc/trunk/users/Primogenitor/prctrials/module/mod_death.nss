
#include "nw_i0_plot"

void Respawn(object oPlayer)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);
    RemoveEffects(oPlayer);
    AssignCommand(oPlayer, ActionJumpToLocation(GetStartingLocation()));
}

void main()
{
    ExecuteScript("prc_ondeath", OBJECT_SELF);
    object oPlayer = GetLastPlayerDied();
    DelayCommand(15.0, Respawn(oPlayer));
}
