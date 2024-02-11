#include "x2_inc_switches"
void main()
{
    ExecuteScript("nw_ch_acani9", OBJECT_SELF);
    //lootable, but not ressurectable
    SetLootable(OBJECT_SELF, TRUE);
    SetIsDestroyable(FALSE, FALSE, TRUE);
    //fix attack count
    int nNumber = GetLocalInt(OBJECT_SELF,CREATURE_VAR_NUMBER_OF_ATTACKS);
    if (nNumber >0 )
    {
        SetBaseAttackBonus(nNumber);
    } 
}