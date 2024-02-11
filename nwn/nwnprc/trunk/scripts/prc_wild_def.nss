#include "prc_inc_actions"
#include "inc_vfx_const"

void main()
{
    object oPC = OBJECT_SELF;
    if(!TakeSwiftAction(oPC)) return;
    SetLocalInt(oPC, "RandomDeflector", TRUE);
    DelayCommand(6.0, DeleteLocalInt(oPC, "RandomDeflector"));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CHAOS_CLOAK), oPC, 6.0);
}