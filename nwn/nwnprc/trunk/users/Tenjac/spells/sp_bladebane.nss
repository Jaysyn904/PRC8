//:://////////////////////////////////////////////
//:: Name     Bladebane
//:: FileName   sp_bladebane.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Paladin 2, Cleric 3, Sorcerer 4, Wizard 4,
Components: V, S, M,
Casting Time: 1 standard action
Range: Touch
Target: Weapon touched
Duration: 1 round/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

You impart a deadly quality to a single bladed weapon 
(any slashing weapon) for a short time.
Bladebane confers the bane ability on the weapon touched, 
against a creature type (and subtype, if necessary) of 
your choice.
The weapon's enhancement bonus increases by +2 against
the appropriate creature type, and it deals +2d6 points 
of bonus damage to those creatures.

Material Component: A drop of blood and ruby dust worth 500 gp.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/27/2022
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
        object oWeapon = PRCGetSpellTargetObject();
        
        //only bladed
        if(GetDamageTypeOfWeapon(oWeapon) != DAMAGE_TYPE_SLASHING)
        {
        	SendMessageToPC(oPC, "Invalid target. This spell must target slashing weapons.");
        	return;
        }        
        
        //+2  increase
        int nBonus = IPGetWeaponEnhancementBonus(oWeapon) + 2;        
        
        //convo for race
        SetLocalInt(oPC, "BladebaneRace");
        StartDynamicConversation("prc_c_bladebane", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
        
        int nRace = GetLocalInt(oPC, "BladebaneRace");
        
        itemproperty iEnhance = ItemPropertyEnhancementBonusVsRace(nRace, nBonus)
        itemproperty iDam = ItemPropertyDamageBonusVsRace(nRace, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6);
        
        IPSafeAddItemProperty(oWeapon, iEnhance, fDur);
        IPSafeAddItemProperty(oWeapon, iDam, fDur);
        
        PRCSetSchool();
}