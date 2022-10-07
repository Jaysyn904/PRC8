//::///////////////////////////////////////////////
//:: Visage of Terror
//:: prc_rava_visage
//:://////////////////////////////////////////////
/*
Once per day on a successful touch attack you can trigger a spell like ability 
similar to the spell phantasmal killer with a DC equal to 14 + Ravager levels.
*/

#include "prc_inc_sp_tch"

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_RAVAGER, oPC);
    int nDC = nLevel + 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    DoSpellMeleeTouch(SPELL_PHANTASMAL_KILLER, nLevel, nDC);
}