#include "shd_inc_metashd"

void main()
{
    object oShadow = OBJECT_SELF;

    SetLocalInt(oShadow, METASHADOW_EXTEND_VAR, !GetLocalInt(oShadow, METASHADOW_EXTEND_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16836353) + " " + (GetLocalInt(oShadow, METASHADOW_EXTEND_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oShadow, FALSE);
}