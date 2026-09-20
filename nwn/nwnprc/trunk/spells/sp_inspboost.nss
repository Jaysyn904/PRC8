//::////////////////////////////////////////////////////////  
//:: Inspirational Boost  
//:: sp_inspboost.nss  
//:://////////////////////////////////////////////////////// 
/*  
    Inspirational Boost
	(Spell Compendium, p. 124)

	Enchantment (Compulsion) [Mind-Affecting, Sonic]
	Level: Bard 1,
	Components: V, S,
	Casting Time: 1 swift action
	Range: Personal
	Target: You
	Duration: 1 round or special; see text

	You concentrate on assisting your friends as you begin 
	the short chant and simple hand-chopping motion 
	necessary to cast the spell. As you finish, the 
	spell's chant allows you to segue easily into 
	bolstering your allies.

	While this spell is in effect, the morale bonus granted 
	by your inspire courage bardic music increases by 1. The 
	effect lasts until your inspire courage effect ends. 
	If you don't begin to use your inspire courage ability 
	before the beginning of your next turn, the spell's 
	effect ends.
  
*/
//:://////////////////////////////////////////////////////// 
  
#include "prc_inc_spells"  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT); 
  
    object oCaster = OBJECT_SELF;  
  
    // Set the flag that nw_s2_bardsong.nss 
	// will check when applying the morale bonus  
    SetLocalInt(oCaster, "InspirationalBoostOn", TRUE);  
  
    // Visual/audible feedback for the swift action cast  
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);  
  
    // Clear the flag if bard song isn't triggered before the  
    // caster's next turn (1 round)  
    DelayCommand(6.0, DeleteLocalInt(oCaster, "InspirationalBoostOn"));  
	
	PRCSetSchool(); 
}