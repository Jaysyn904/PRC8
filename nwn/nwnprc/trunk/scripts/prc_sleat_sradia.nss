//::///////////////////////////////////////////////
//:: Soul Eater: Soul Radiance toggle
//:: prc_sleat_sradia
//:://////////////////////////////////////////////
/** @file
    Soul Radiance (Su): If a 6th-level soul eater completely drains a creature
     of energy, it may adopt the creature's soul radiance, taking the victim's
     form, appearance, and abilities for 24 hours.


    This script just toggles a switch local that determines
    whether to apply Soul Radiance effects upon killing something
    with Energy Drain

    @author Ornedan
    @date   Created - 04.12.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


const string sVarName = "PRC_SoulEater_SoulRadianceActive";

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, sVarName, !GetLocalInt(oPC, sVarName));
    FloatingTextStringOnCreature(GetStringByStrRef(16832123/*Soul Radiance*/) + " " + (GetLocalInt(oPC, sVarName) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}