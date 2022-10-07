//::///////////////////////////////////////////////
//:: Order of the Bow Initiate Ranged Precision
//:: prc_ootbi_rngprc.nss
//::///////////////////////////////////////////////
/*
    Performs a single attack with a damage bonus of 1d8
    per two Order of the Bow Initiate levels + 1.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 21.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;
    int nCrittable = TRUE;
    int nClass = GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE, oPC);
    
    // Ranged Precision works at 30 feet, or at 60 feat if the OOTBI is level 10 or greater
    float fCheck = 30.0;
    if (nClass >= 10) fCheck *= 2;
    float fDistance = FeetToMeters(fCheck);
    
    // This weapon can only be used with a Longbow or Shortbow
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(!GetBaseItemType(oItem) == BASE_ITEM_LONGBOW && !GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
    {
        FloatingTextStringOnCreature("You must have a bow equipped to use Ranged Precision", oPC, FALSE);
        return;
    }  
    // Does not work on creatures immune to crits
    if (GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
    {
        FloatingTextStringOnCreature("The target is immune to critical hits", oPC, FALSE);
        nCrittable = FALSE;
    } 
    
    // Distance check
    if (fDistance >= GetDistanceToObject(oTarget) && nCrittable)
    {	
    	// Only use the visual if you're going to use ranged precision
    	eDummy = EffectVisualEffect(VFX_IMP_SONIC);
    	// 1d8 at level 1 of the class, 2d8 at level 3, and so on
    	int nPrecision = d8((nClass/2) + 1);
    	PerformAttack(oTarget, oPC, eDummy, 0.0, 0, nPrecision, DAMAGE_TYPE_PIERCING, "Ranged Precision Hit", "Ranged Precision Miss");
    }
    else
    {
    	// So as not to penalize the player, this script performs a full attack round if the target is outside of the distance
    	// Stops him from being told the wrong error message.
    	if (nCrittable) FloatingTextStringOnCreature("You are too far away to use Ranged Precision", oPC, FALSE);
    	FloatingTextStringOnCreature("Performing a full attack action", oPC, FALSE);
	PerformAttackRound(oTarget, oPC, eDummy);
    }
}