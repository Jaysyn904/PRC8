//:://////////////////////////////////////////////
//:: Name     Undead Bane Weapon
//:: FileName   sp_undbanew.nss
//:://////////////////////////////////////////////
/** @file
Undead Bane Weapon
Transmutation
Level: Paladin 3, Cleric 4,
Components: V, S, DF,
Casting Time: 1 Standard Action
Range: Touch
Target: Weapon touched 
Duration: 1 hour/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

Your hand glows with a dull light, and when you touch the weapon,
the light shifts to it, so that it sheds a serene gray radiance as 
bright as a candle.

You give a weapon the undead bane special ability in addition to 
any other properties it has. Against undead, your weapon's enhancement
bonus is 2 higher than normal, and it deals an extra 2d6 points of damage
against undead. The spell has no effect if cast upon a weapon that already
has the undead bane special ability.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;        	
        object oItem = GetSpellTargetObject();
        
        //Check if it's a creature and if so get main weapon
        if(GetObjectType(oItem) == OBJECT_TYPE_CREATURE
        {
        	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oItem);
        }
        
        itemproperty iAttack = ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 2);
        itemproperty iDamage = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6);
        
        //Valid targets
        if(IPGetIsProjectile(oItem) || IPGetIsMeleeWeapon(oItem) || IPGetIsRangedWeapon(oItem))
        {
        	AddItemProperty(DURATION_TYPE_TEMPOARY, iAttack, oItem, fDur);
        	IPSafeAddItemProperty(oItem, iDamage, fDur);
        }
        else SendMessageToPC(oPC, "Invalid target.  Must target a weapon or projectile.");
        
        PRCSetSchool();
}