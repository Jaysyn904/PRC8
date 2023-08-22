#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    if (oTarget == oPC) return; // No hitting yourself
    if (GetLocalInt(oPC, "CombatLoopProtection")) return; // Stop the damn loop
    
    int nBonus = 0;
    // This counteracts the bonus from Improved Disarm if the PC has it
    if (GetHasFeat(FEAT_PRC_IMP_DISARM, oPC)) nBonus -= 4;

    DoDisarm(oPC, oTarget, nBonus, FALSE, FALSE);        
    
    SetLocalInt(oPC, "CombatLoopProtection", TRUE);
    DelayCommand(4.0, DeleteLocalInt(oPC, "CombatLoopProtection"));
}