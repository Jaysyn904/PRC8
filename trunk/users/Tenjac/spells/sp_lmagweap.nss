//:://////////////////////////////////////////////
//:: Name     Legion's Magic Weapon
//:: FileName   sp_lmagweap.nss
//:://////////////////////////////////////////////
/** @file 
Transmutation
Level: Cleric 2, Paladin 2, Sorcerer 2, Wizard 2,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: Melee or ranged weapons held by allied creatures in a 20-ft.-radius burst
Duration: 1 round/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

This spell functions like magic weapon (see page 251 of the 
Player's Handbook), except as noted above and as follows. It 
affects only weapons held by allies when the spell is cast.
It has no effect on ammunition.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/13/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        location lLoc = GetLocation(oPC);
        
        object oTarget = MyGetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
        	if(GetIsReactionTypeFriendly(oTarget))
        	{
        		object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        		if(GetIsObjectValid(oItem))
        		{
        			IPSafeAddItemProperty(oItem,ItemPropertyEnhancementBonus(1), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
        		}
        	}
        	oTarget = MyGetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
        PRCSetSchool();
}