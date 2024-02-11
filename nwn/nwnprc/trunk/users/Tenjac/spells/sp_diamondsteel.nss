//:://////////////////////////////////////////////
//:: Name     Diamondsteel
//:: FileName   sp_diamondsteel.nss
//:://////////////////////////////////////////////
/** @file
Diamondsteel
Transmutation
Level: Paladin 3, Sorcerer 3, Wizard 3,
Components: V, S, M,
Casting Time: 1 standard action
Range: Touch
Target: Suit of metal armor touched
Duration: 1 round/level
Saving Throw: Will negates (object)
Spell Resistance: Yes (object)

You pass your hand over the suit of armor several times before finally touching it. 
As you do so, you feel a warmth grow in the palm of your hand. The warmth passes into
the armor and manifests as a sparkling shine.

Diamondsteel enhances the strength of one suit of metal armor. The armor provides 
damage reduction equal to half the AC bonus of the armor. This damage reduction can 
be overcome only by adamantine weapons. For example, a suit of full plate would provide
damage reduction 4/adamantine, and a +1 breastplate (+6 AC) would provide damage reduction
3/adamantine.

Material Component: Diamond dust worth at least 50 gp.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/23/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int oTarget = SPGetSpellTargetObject();
        
        if(GetObjectType(oTarget)) == OBJECT_TYPE_ITEM
        {
        	oArmor = oTarget;
        }
        
        if(GetObjectType(oTarget)) == OBJECT_TYPE_CREATURE
        {
        	oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
        }        
        int nMetaMagic = PRCGetMetaMagicFeat();        
        int nAC = GetBaseAC(oArmor);
        
        //Must be metal
        if(nAC > 3)
        {
        	if(nMetaMagic & METAMAGIC_EXTEND)
        	{
        		fDur += fDur;
        	}        
        	
        	//Get amount for bonus - includes any +
        	int nBonus = GetItemACValue(oArmor)/2;
        	
        	//Adamantine is x/+5
        	effect eDR = EffectDamageReduction(nBonus, DAMAGE_POWER_PLUS_FIVE);        	
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oTarget, fDur);
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);        	
        }
        else SendMessageToPC(oPC, "Invalid target. Target armor must be metal."
	
	PRCSetSchool();
}