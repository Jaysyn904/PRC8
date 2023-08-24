//::///////////////////////////////////////////////
//:: Poisoned Food eating hook script
//:: poison_eat_hook
//::///////////////////////////////////////////////
/** @file
    The item used to trigger this should contain two
    local ints:
    pois_food_idx  - The number of poison to use. Matched
                     against poison.2da
    pois_food      - An local marking the food as poisoned.
                     This is required because valid values
                     for pois_food_idx start at 0.
    
    If pois_food is not TRUE, nothing happens.
    
    The actual effect is an EffectPoison being applied
    to whomever this script is activated on.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_poison"
#include "prc_inc_spells"


void main()
{
    object oFood   = GetLocalObject(GetModule(), "poison_eat_hook_item");
    object oTarget = OBJECT_SELF;
    
    // Check for presence of poison on the food. Only TRUE aka 1 is valid here.
    if(GetLocalInt(oFood, "pois_food") != TRUE) return;
    
    int nPoisonIdx = GetLocalInt(oFood, "pois_food_idx");
    
    // Apply the poison to target
    effect ePoison = EffectPoison(nPoisonIdx);
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);
}
