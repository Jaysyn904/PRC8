/*
09/03/21 by Stratovarius

Dantalion, the Star Emperor
  
Dantalion, called the Star Emperor for his legend and appearance, is a composite of many souls. He grants binders the ability to teleport short distances, read thoughts, and stop foes.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Dantalion’s influence causes you to be aloof and use stately gestures. Dantalion can’t help but be curious about the leaders of the day, 
so anytime you are within 100 feet of someone who clearly is (or professes to be) a leader of others, Dantalion requires that you try to read that 
person’s thoughts. Once you have made the attempt, regardless of success or failure, you need not try to read that person’s thoughts again.

Granted Abilities: 
Pact magic grimoires attest to Dantalion’s profound wisdom and his extensive knowledge about all subjects. Because he knows all thoughts, he can grant 
you a portion of that power, as well as the ability to travel just by thinking. You also gain a portion of his commanding presence, which many binders 
ascribe to his royal origins.

Thought Travel: As a standard action, you can instantly transport yourself to any location you can see that is within 5 feet per effective binder level 
you possess. Thought travel is a teleportation effect and is usable a number of times per day equal to your effective binder level. Once you have used 
this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "spinc_dimdoor"
#include "prc_inc_template"

void main()
{
    object oBinder = OBJECT_SELF;
    int nCasterLevel = GetBinderLevel(oBinder, VESTIGE_DANTALION);
    int nUses;
    int nSLA = GetSpellId();

	if(!BindAbilCooldown(oBinder, nSLA, VESTIGE_DANTALION)) return;	
	if (GetLevelByClass(CLASS_TYPE_SCION_DANTALION, oBinder) >= 4) 
		if(!TakeMoveAction(oBinder)) return;
    
    nUses = nCasterLevel; 
    // Check uses per day
    if (GetLegacyUses(oBinder, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oBinder, FALSE);
        return;
    }             
    else
    {
		SetLegacyUses(oBinder, nSLA);
    	FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oBinder, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oBinder, FALSE);    		    		
		DimensionDoor(oBinder, nCasterLevel);	
    }
}
        