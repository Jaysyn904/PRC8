//:://////////////////////////////////////////////
//:: Name     Lesser Energy Shield
//:: FileName   sp_lenshield.nss
//:://////////////////////////////////////////////
/** @file Abjuration 
Level: Paladin 1, Cleric 2
Components: V, S, DF,
Casting Time: 1 Standard Action
Range: Touch
Target: Shield touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: No

A silver aura surrounds the touched shield for a 
moment before it appears to transform into the chosen 
type of energy. The shield hums with power.

When this spell is cast, the shield touched appears 
to be made entirely out of one type of energy (fire,
cold, electricity, acid, or sonic). Whoever bears the
shield gains resistance 5 against the chosen energy 
type. Additionally, if the wielder successfully hits 
someone with the shield with a shield bash attack, th
e victim takes 1d6 points of the appropriate energy 
damage in addition to the normal shield bash damage.
The energy type must be chosen when the spell is cast 
and cannot be changed during the duration of the spell.
The energy resistance overlaps (and does not stack) 
with resist elements. A given shield cannot be the 
subject of more than one lesser energized shield 
or energized shield spell at the same time.

The descriptor of this spell is the same as the 
energy type you choose when you cast it.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_inc_fork"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oTarget = PRCGetSpellTargetObject();
        object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        
        //Check that this is a shield, if not abort
        if(GetIsShield(oShield) == FALSE)
        {
        	SendMessageToPC(OBJECT_SELF, "Target has no equipped shield.");
        	break;
        }
        
        //The type of damage resistance we're choosing
        int nDR;
        
        //Get the type by which subradial spell is used to cast
        int nSpell = GetSpellId();        
        if(nSpell == SPELL_LESSER_ENERGIZED_SHIELD_FIRE)
        {
        	nDR = IP_CONST_DAMAGETYPE_FIRE;
        	SetLocalInt(oTarget, "EnShieldType", DAMAGE_TYPE_FIRE);
        }        
        if(nSpell == SPELL_LESSER_ENERGIZED_SHIELD_COLD)
        {
        	nDR = IP_CONST_DAMAGETYPE_COLD;
        	SetLocalInt(oTarget, "EnShieldType", DAMAGE_TYPE_COLD);
        }        	
        if(nSpell == SPELL_LESSER_ENERGIZED_SHIELD_ELEC)
        {
        	nDR = IP_CONST_DAMAGETYPE_ELECTRICAL;
        	SetLocalInt(oTarget, "EnShieldType", DAMAGE_TYPE_ELECTRICAL);
        }        
        if(nSpell == SPELL_LESSER_ENERGIZED_SHIELD_ACID)
        {
        	nDR = IP_CONST_DAMAGETYPE_ACID;
        	SetLocalInt(oTarget, "EnShieldType", DAMAGE_TYPE_ACID);
        }
        if(nSpell == SPELL_LESSER_ENERGIZED_SHIELD_SONIC)
        {
        	nDR = IP_CONST_DAMAGETYPE_SONIC;
        	SetLocalInt(oTarget, "EnShieldType", DAMAGE_TYPE_SONIC);
        }
        
        //Set local int for amount of shield damage on the wielder of the shield
        SetLocalInt(oTarget, "EnShieldD6", 1); 
        
        //Schedule ints for deletion
        DelayCommand(fDur, DeleteLocalInt(oTarget, "EnShieldType"));
        DelayCommand(fDur, DeleteLocalInt(oTarget, "EnShieldD6"));
        
        //Add resistance property
        IPSafeAddItemProperty(oShield, ItemPropertyDamageResistance(nDR, 5), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        
        PRCSetSchool();
}