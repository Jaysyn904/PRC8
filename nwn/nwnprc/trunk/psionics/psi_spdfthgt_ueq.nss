//::///////////////////////////////////////////////
//:: Speed of Thought onunequip script
//:: psi_spdfthgt_ueq
//:://////////////////////////////////////////////
/** @file
	Adds the Speed of Thought back to unequipper,
	if they now have non-heavy armor and are
	still psionically focused.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.03.2005
//:: Modified On: 11.07.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void Aux(object oCreature)
{
    if(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature)) < 6 && GetIsPsionicallyFocused(oCreature))
        AssignCommand(oCreature, ActionCastSpellAtObject(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, oCreature, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

void main()
{
    object oCreature = GetItemLastUnequippedBy();
    // Delayed, because the unequipped item has not left the slot yet.
    // This is probably going to bug during lag, but no can do
    if(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature) == GetItemLastUnequipped() && GetIsPsionicallyFocused(oCreature))
        DelayCommand(0.75f, Aux(oCreature));
}