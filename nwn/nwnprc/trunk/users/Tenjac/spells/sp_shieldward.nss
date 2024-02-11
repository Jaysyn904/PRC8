//:://////////////////////////////////////////////
//:: Name     Shield of Warding
//:: FileName   sp_shieldward.nss
//:://////////////////////////////////////////////
/** @file Abjuration [Good]
Level: Paladin 2, Cleric 3,
Components: V, S,
Casting Time: 1 standard action
Range: Touch
Target: One shield or buckler touched
Duration: 1 minute/level
Saving Throw: Will negates (object, harmless)
Spell Resistance: No

The touched shield or buckler grants its wielder a +1
sacred bonus to Armor Class and on Reflex saves, +1 per
five caster levels (maximum +5 at 20th level). The bonus
applies only when the shield is worn or carried normally
(but not, for instance, if it is slung over the shoulder).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/21/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl) * 60;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
      	object oTarget = PRCGetSpellTargetObject();
      	object oShield;
      	
      	if GetObjectType(oTarget == OBJECT_TYPE_CREATURE) oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      	if GetObjectType(oTarget == OBJECT_TYPE_ITEM) oShield = oTarget;
              
        //Check that this is a shield, if not abort
        if(GetIsShield(oShield) == FALSE)
        {
        	SendMessageToPC(OBJECT_SELF, "Target has no equipped shield.");
              	break;
        }
        
        int nBonus = 1;        
        if nCasterLvl > 4 nBonus +=1;
        if nCasterLvl > 9 nBonus +=1;
        if nCasterLvl > 14 nBonus +=1;
        if nCasterLvl > 19 nBonus +=1;
        
        IPSafeAddItemProperty(oShield, ItemPropertyACBonus(nBonus), fDur);
        IPSafeAddItemProperty(oShield, ItemProperBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, nBonus), fDur);
        PRCSetSchool();
}
        
        