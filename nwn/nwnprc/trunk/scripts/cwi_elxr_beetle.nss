//////////////////////////////////////////////////  
// Beetle Elixir  
// cwi_elxr_beetle.nss  
//////////////////////////////////////////////////  
//::
/*  
BEETLE ELIXIR
Price (Item Level): 1,350 gp (5th)
Body Slot: —
Caster Level: 6th
Aura: Moderate; (DC 18) transmutation
Activation: Full-round (manipulation)
Weight: —

The viscous liquid in this vial has an oily brown
color and smells a little like wet leaves.

Drinking beetle elixir causes your skin to harden, 
darken, and gloss over, and short antennae to 
sprout from your forehead.

You gain darkvision out to 60 feet and a +2 
enhancement bonus to your existing natural armor. 
(A creature without natural armor has an effective 
natural armor bonus of +0.) These effects last for
12 hours.

Prerequisites: Craft Wondrous Item, alter self, 
darkvision, Craft (alchemy) 5 ranks.

Cost to Create: 675 gp, 54 XP, 2 days 
*/  
//::
//;;//////////////////////////////////////////////  
#include "prc_inc_spells"  
  
void main()  
{  
    object oTarget = GetItemActivator();  
	string sTargetName = GetName(oTarget);
    object oItem = GetItemActivated();  
	string sItemName = GetName(oItem);
	
	if (GetHasSpellEffect(SPELL_ELIXIR_OF_THE_BEETLE, OBJECT_SELF))
	PRCRemoveSpellEffects(SPELL_ELIXIR_OF_THE_BEETLE, OBJECT_SELF, OBJECT_SELF);

	if(DEBUG) DoDebug("Using "+sItemName+" on "+sTargetName+".");
      
    // Apply darkvision effect  
    effect eDarkvision = EffectBonusFeat(FEAT_DARKVISION);  
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_BLACK);  
      
    // Apply natural armor bonus  
    effect eArmor = EffectACIncrease(2, AC_NATURAL_BONUS);  
      
    // Link all effects  
    effect eLink = EffectLinkEffects(eDarkvision, eArmor);  
    eLink = EffectLinkEffects(eLink, eVis); 
      
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(12));  

}