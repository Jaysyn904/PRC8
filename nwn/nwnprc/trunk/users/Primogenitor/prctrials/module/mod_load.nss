#include "reg_inc"
#include "rig_inc"
#include "spawn_inc"
#include "rng_inc"

void main()
{
    ExecuteScript("prc_onmodload", OBJECT_SELF);
    if(GetLocalInt(OBJECT_SELF, "ModLoadDone"))
        return;
    SetLocalInt(OBJECT_SELF, "ModLoadDone", TRUE);

    DelayCommand(1.0, REG_DoSetup());
    DelayCommand(2.0, RIG_DoSetup());
    DelayCommand(3.0, RNG_SetupNameList(""));
    DelayCommand(4.0, ProcessSpawnQueue());

    ExecuteScript("x2_mod_def_load", OBJECT_SELF);
    SetModuleXPScale(0);
}
