//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Whirling Blade
Transmutation
Level: Bard 2, sorcerer/wizard 2,warmage 2
Components: V, S, F
Casting Time: 1 standard action
Range: 60 ft.
Effect: 60-ft. line
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

As you cast this spell, you hurl a single
slashing weapon at your foes, magically
striking at all enemies along a
line to the extent of the spell’s range.
You make a normal melee attack, just
as if you attacked with the weapon in
melee, against each foe in the weapon’s
path, but you can choose to substitute
your Intelligence or Charisma
modifier (as appropriate for your
spellcasting class) for your Strength
modifier on the weapon’s attack rolls
and damage rolls. Even if your base
attack bonus would normally give
you multiple attack rolls, a whirling
blade gets only one attack (at your best
attack bonus) against each target. The
weapon deals damage just as if you
had swung it in melee, including any
bonuses you might have from ability
scores or feats.

No matter how many targets your weapon hits or 
misses, it instantly and unerringly returns to 
your hand after attempting the last of its attacks.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

/* void PerformAttack(object oDefender, object oAttacker,
    effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0,
    int iDamageModifier = 0, int iDamageType = 0,
    string sMessageSuccess = "", string sMessageFailure = "",
    int iTouchAttackType = FALSE,
    object oRightHandOverride = OBJECT_INVALID, object oLeftHandOverride = OBJECT_INVALID,
    int nHandednessOverride = 0, int bCombatModeFlags = 0); // motu99: changed default of nHandednessOverride to FALSE (was -1) */

#include "prc_inc_combat"

int GetIsSlashingWeapon(object oItem)
{
    int iWeapType = StringToInt(Get2DACache("baseitems", "WeaponType", GetBaseItemType(oItem)));

    if (iWeapType == 3 || iWeapType == 4) // slashing or slashing & piercing
        return TRUE;
    else
        return FALSE;
}

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC 			= OBJECT_SELF;
		
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		
		int bSlashing = GetIsSlashingWeapon(oWeapon);
		
		if(!bSlashing)
		{
			SendMessageToPC(oPC, "This spell requires a slashing weapon in the spellcaster's right hand.");
			return;
		}		
		
		int nClass 			= GetLastSpellCastClass();
		int nStatMod 		= GetDCAbilityModForClass(nClass, oPC);
		int nStatBonus 		= GetAbilityModifier(nStatMod);
		
        vector vOrigin 		= GetPosition(oPC);
		
        location lTarget 	= PRCGetSpellTargetLocation();
		
		float fLength 		= FeetToMeters(60.0);
		
        effect eNone;
		
		SetLocalInt(oPC, "WhirlingBlade", TRUE);
		
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
        
        while(GetIsObjectValid(oTarget))
        {
                if (oTarget != oPC && GetIsReactionTypeHostile(oTarget, oPC))
                {
                        DelayCommand(0.0, PerformAttack(oTarget, oPC, eNone, 0.0, nStatBonus, 0, 0, "Whirling Blade: Hit!", "Whirling Blade: Miss!"));
                }
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
        }
		DelayCommand(1.0f, DeleteLocalInt(oPC, "WhirlingBlade"));
        PRCSetSchool();
}