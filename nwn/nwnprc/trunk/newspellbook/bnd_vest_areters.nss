/*
13/03/21 by Stratovarius

Arete, the First Elan
  
Arete, a powerful psion who sought immortality, created a new race but doomed himself to never-ending rebirths. His granted abilities provide binders with access to several qualities that toughen the body and mind.

Vestige Level: 4th
Binding DC: 21
Special Requirement: Arete does not like to be reminded that the elan are considered abominations by some, and he does not answer your summons if you are already bound to Chupoclops or Eurynome.

Influence: You do not get hungry or tired while bound to Arete, but you do suffer negative effects if you do not eat or sleep for the duration that the vestige is bound. If faced with a need to do research, Arete insists that you seek out lore regarding him and his research into immortality as well, which can often double or even triple the time you spend seeking information.

Granted Abilities: 
While bound to Arete, you gain powers that Arete had at some point in his search for immortality.

Resistance: Your gain a +4 bonus on a saving throw of your choice. You may change this to another saving throw as a move action.
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
	if(!TakeMoveAction(oBinder)) return;
	int nSpell = GetSpellId();

	PRCRemoveSpellEffects(nSpell, oBinder, oBinder);
	GZPRCRemoveSpellEffects(nSpell, oBinder, FALSE);
	
	// Never blank because it's set when the vestige is created
	int nType = GetLocalInt(oBinder, "AreteResist");
	
	if (nType == SAVING_THROW_WILL)
	{
		nType = SAVING_THROW_REFLEX;
		FloatingTextStringOnCreature("Arete is now boosting Reflex saves", oBinder, FALSE);
	}	
	else if (nType == SAVING_THROW_REFLEX)
	{
		nType = SAVING_THROW_FORT;
		FloatingTextStringOnCreature("Arete is now boosting Fort saves", oBinder, FALSE);
	}	
	else if (nType == SAVING_THROW_FORT)
	{
		nType = SAVING_THROW_WILL;		
		FloatingTextStringOnCreature("Arete is now boosting Will saves", oBinder, FALSE);
	}	
	
	SetLocalInt(oBinder, "AreteResist", nType);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSavingThrowIncrease(nType, 4)), oBinder, HoursToSeconds(24));
}

