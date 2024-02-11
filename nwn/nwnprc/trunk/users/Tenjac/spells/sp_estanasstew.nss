//:://////////////////////////////////////////////
//:: Name     Estana's Stew
//:: FileName   sp_estanasstew.nss
//:://////////////////////////////////////////////
/** @file Conjuration (Healing)
Level: Cleric 2, Druid 2, Paladin 2,
Components: V, S, AF,
Casting Time: 1 round
Range: 0 ft.
Effect: Fills pot with healing stew (1 serving/2 levels)
Duration: Instantaneous (see text)
Saving Throw: Will half (harmless); see text
Spell Resistance: Yes (harmless)

This spell calls upon Estanna, goddess of hearth and home 
, to fill a specially crafted stewpot with a potent healing stew.
The caster must be hold the pot in hand when Estanna's stew
is cast; otherwise, the spell fails and is wasted.
The spell creates one serving per two caster levels (maximum 5).
A single serving heals 1d6+1 points of damage and requires
a standard action to consume. Any portion of the stew that
is not consumed disappears after 1 hour.The stew can be 
splashed onto a single undead creature within 10 feet.
If a ranged touch attack succeeds, the undead creature 
takes 1d6+1 points of damage per serving splashed on it.
The undead creature can apply spell resistance and can 
attempt a Will save to take half damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/20/22
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
	int nSpell = GetSpellId();
	
	if (nSpell == SPELL_ESTANAS_STEW)
	{
		object oItem = CreateItemOnObject("prc_estanasstew", oPC, 1);
		int nServings = min(5, (nCasterLvl/2));
		SetItemCharges(oItem, nServings);		
	}
        
        if (nSpell == SPELL_ESTANAS_STEW_EAT)
        {
        	int nHeal = d6(1) + 1;
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(nHeal), oPC);
        }
        
        if (nSpell == SPELL_ESTANAS_STEW_SPLASH)
        {
        	object oItem = PRCGetSpellCastItem(OBJECT_SELF);        	
        	object oTarget = GetSpellTargetObject();
        	
        	
        	if(GetIsObjectValid(oTarget))
        	{
        		nTouch = TouchAttackRanged(oTarget);
        	}
        	// Check if we hit, or even have anything to hit!
        	if(nTouch >= 1)
        	{
        		int nServings = GetItemCharges(oItem);
        		
        		//Chuck all of it
        		int nDam = (d6(1) + 1) * nServings;
        		
        		// Critical hit?
        		if(nTouch == 2)
        	 	{	
        	 		nDam *= 2;
        	 	}
        	 	int nPenetr = SPGetPenetr();
        	 	
        	 	//Resist
        	 	if(!PRCDoResistSpell(OBJECT_SELF, oTarget nPenetr);
        	 	{
        	 		if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
        	 		{
        	 			nDam = nDam/2'
        	 		}
        	 		
        	 		if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        	 		{
        	 			SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);
        	 		}
        	 	}
        	 	
        	 	SPApplyEffectToObject(DURATION_TYPER_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL), oTarget);
        	 }
        	 //Remove the object
        	 DestroyObject(oItem);
        }
        PRCSetSchool();
}