#include "shd_inc_metashd"

void main()
{
    object oShadow = OBJECT_SELF;

    SetLocalInt(oShadow, METASHADOW_MAXIMIZE_VAR, !GetLocalInt(oShadow, METASHADOW_MAXIMIZE_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16836355) + " " + (GetLocalInt(oShadow, METASHADOW_MAXIMIZE_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oShadow, FALSE);
}