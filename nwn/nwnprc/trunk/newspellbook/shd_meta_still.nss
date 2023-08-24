#include "shd_inc_metashd"

void main()
{
    object oShadow = OBJECT_SELF;

    SetLocalInt(oShadow, METASHADOW_STILL_VAR, !GetLocalInt(oShadow, METASHADOW_STILL_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16836359) + " " + (GetLocalInt(oShadow, METASHADOW_STILL_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oShadow, FALSE);
}