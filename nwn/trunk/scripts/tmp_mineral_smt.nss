//::///////////////////////////////////////////////
//:: Name           Mineral Warrior smite impact script
//:: FileName       tmp_mineral_smite
//:: 
//:://////////////////////////////////////////////
#include "prc_inc_smite"

void main()
{
	if (!GetLocalInt(OBJECT_SELF, "EarthSmite"))
	{
    	DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_TEMPLATE_MINERAL);
    	SetLocalInt(OBJECT_SELF, "EarthSmite", TRUE);
    }	
}