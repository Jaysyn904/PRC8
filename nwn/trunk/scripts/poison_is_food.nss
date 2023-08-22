//::///////////////////////////////////////////////
//:: Poison Food target validity checking script
//:: poison_is_food
//::///////////////////////////////////////////////
/** @file
    This script is run through ExecuteScriptAndReturnInt
    from poison_appl_food.
    It's purpose is to determine whether the targeted
    item is a consumable (food or drink).

    This is an example script that merely returns FALSE for
    any and all calls. Set the PRC switch
    PRC_POISON_IS_FOOD_SCRIPT_NAME to the be the name of
    your own script in order to make the system work.

    That is, a builder must add their own checks here if they
    have an edible food system present in their module and
    wish to allow such to be poisoned.

    OBJECT_SELF is the targeted item in this script.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{
	int nRet = FALSE;
	
	/** Your checks go here **/
	
	
	
	
	/** /Your checks go here **/
    SetExecutedScriptReturnValue (nRet);
}