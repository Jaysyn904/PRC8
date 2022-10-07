//:://////////////////////////////////////////////
//:: Name     Smite of Sacred Fire
//:: FileName   sp_smitesacfire.nss
//:://////////////////////////////////////////////
/** @file Evocation [Good]
Level: Paladin 2,
Components: V, DF,
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round/level; see text

You must cast this spell in the same round when you 
attempt a smite attack. If the attack hits, you deal 
an extra 2d6 points of damage to the target of the 
smite. Whether or not you succeed on the smite attempt,
during each subsequent round of the spell?s duration,
you deal an extra 2d6 points of damage on any successful 
melee attack against the target you attempted to smite. 
The spell ends prematurely after any round when you do not
attempt a melee attack against the target you previously 
attempted to smite, or if you fail to hit with any of 
your attacks in a round.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/25/2022
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void SmiteCheck(object oWeapon)
{
	//No smite attempt last round
	if(!GetLocalInt(oWeapon, "PRCSmiteLastRound"))
	{
		RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT, "prc_evnt_ssf", TRUE, FALSE);
	}
}	

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        
        itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
        IPSafeAddItemProperty(oWeapon, ipHook, fDur);
        
        //Add onhit
        AddEventScript(oWeapon, EVENT_ITEM_ONHIT, "prc_evnt_ssf", TRUE, FALSE);
        
        DelayCommand(6.0f, SmiteCheck(oWeapon));
                       
        PRCSetSchool();
}