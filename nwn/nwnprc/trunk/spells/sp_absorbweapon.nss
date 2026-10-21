//::////////////////////////////////////////////////////////
//::
/*
	Absorb Weapon	(sp_absorbweapon.nss)
	Transmutation
	Level: 				Assassin 2,
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: 				Touch
	Effect: 			One touched weapon not in another 
						creature's possession
	Duration: 			1 hour/level (D)
	Saving Throw: 		Will negates (object); see text
	Spell Resistance:	Yes (object)
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	The weapon you hold in your hand begins to fade from 
	existence as you complete the spell. With the last words 
	of the spell it disappears completely. At the same 
	moment, a weapon-shaped red blotch appears on your arm.

	You can harmlessly absorb a weapon you are touching 
	(even a poisoned one) into your arm, as long as it is 
	not in another creature?s possession. The weapon must be 
	a light weapon for you at the time you cast the spell. 
	The absorbed weapon cannot be felt under the skin and 
	doesn't restrict your range of motion in any way. An 
	absorbed weapon cannot be detected with even a careful 
	search, although detect magic reveals the presence of a 
	magical aura. The only evidence of its presence is a 
	faint blotch on your skin shaped vaguely like the weapon.

	When you touch the spot (an action equivalent to drawing 
	a weapon), or when the spell duration expires, the weapon 
	appears in your hand and the spell ends. If you attack 
	with the weapon in the same round that you retrieve it 
	from its hiding place, you can attempt a Bluff check to 
	feint in combat as a free action, and you gain a +4 bonus 
	on the Bluff check. An intelligent magic weapon gets a 
	saving throw against this spell, but other weapons do not.
	
	- This needs a feat created and added via EffectBonusFeat()
	  that will restore the weapon when used and then end the
	  EffectBonusFeat().

*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-10 11:19:39
//::
//:://////////////////////////////////////////////////////// 
#include "prc_inc_spells"  
#include "prc_add_spell_dc" 

void ExpireAbsorbWeapon(object oCaster)  
{  
    // If the weapon was already manually retrieved, the JSON local is gone - nothing to do  
    string sJson = GetLocalString(oCaster, "PRC_ABSORBED_WEAPON_JSON");  
    if (sJson == "") return;  
  
    json jWeapon = JsonParse(sJson);  
    object oWeapon = JsonToObject(jWeapon, GetLocation(oCaster));  
    AssignCommand(oCaster, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));  
  
    DeleteLocalString(oCaster, "PRC_ABSORBED_WEAPON_JSON");  
    DeleteLocalInt(oCaster, "PRC_ABSORBED_WEAPON_SPELLID");  
}  
  
void main()  
{  
    object oCaster  = OBJECT_SELF;  
    object oWeapon  = PRCGetSpellTargetObject(); // item, not creature, touched  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
  
    if (!GetIsObjectValid(oWeapon) || GetObjectType(oWeapon) != OBJECT_TYPE_ITEM)  
        return;  
  
    // must be unpossessed & a light weapon for the caster  
    if (GetIsObjectValid(GetItemPossessor(oWeapon))) return; // in another's possession  
    if (!IPGetIsMeleeWeapon(oWeapon)) return; // or your light-weapon check  
  
    // Intelligent magic weapons get a Will save; mundane weapons do not  
    if (IPGetIsIntelligentWeapon(oWeapon))  
    {  
        if (PRCMySavingThrow(SAVING_THROW_WILL, oWeapon, PRCGetSaveDC(oWeapon, oCaster)))  
            return; // weapon resists  
    }  
  
    // Serialize the weapon to JSON, store it on the caster, then remove the real item  
    json jWeapon = ObjectToJson(oWeapon, TRUE);  
    SetLocalString(oCaster, "PRC_ABSORBED_WEAPON_JSON", JsonDump(jWeapon));  
    SetLocalInt(oCaster, "PRC_ABSORBED_WEAPON_SPELLID", GetSpellId());  
    DestroyObject(oWeapon);  
  
    effect eBlotch = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL); // "weapon-shaped red blotch" placeholder  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlotch, oCaster, HoursToSeconds(nCasterLevel), TRUE, GetSpellId(), nCasterLevel);  
  
    DelayCommand(HoursToSeconds(nCasterLevel), ExpireAbsorbWeapon(oCaster));  
}