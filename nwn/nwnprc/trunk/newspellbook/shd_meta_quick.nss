#include "shd_inc_metashd"

void main()
{
    object oShadow = OBJECT_SELF;

    SetLocalInt(oShadow, METASHADOW_QUICKEN_VAR, !GetLocalInt(oShadow, METASHADOW_QUICKEN_VAR));
    FloatingTextStringOnCreature(GetStringByStrRef(16836357) + " " + (GetLocalInt(oShadow, METASHADOW_QUICKEN_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oShadow, FALSE);
}