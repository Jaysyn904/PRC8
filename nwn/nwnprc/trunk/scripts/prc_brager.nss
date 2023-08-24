//::///////////////////////////////////////////////
//:: Battlerager
//:: prc_brager.nss
//:://////////////////////////////////////////////
//:: Applies Ferocious Prowess Bonus
//:://////////////////////////////////////////////
//:: Created By: Lockindal
//:: Created On: July 23, 2004
//:://////////////////////////////////////////////

#include "inc_newspellbook" 
#include "prc_inc_core"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_FEROCIOUS_PROW, oPC))
    {
        ActionCastSpellOnSelf(SPELL_BATTLERAGER_DAMAGE);   // +1 to attack and damage rolls
    }
}