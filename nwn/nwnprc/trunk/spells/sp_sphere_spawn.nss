//executes default on spawn script and applies vfx for sphere of ultimate destruction
#include "inc_vfx_const"

void main()
{
    ExecuteScript("nw_ch_summon_9",OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_SPHERE_OF_ANHILIATION), OBJECT_SELF);
}