/*
05/03/21 by Stratovarius

Tenebrous, the Shadow That Was
  
Tenebrous, once a powerful demon prince, offers dominion over darkness and death.

Vestige Level: 4th
Binding DC: 21
Special Requirement: You must draw Tenebrous’s seal at night.

Influence: While influenced by Tenebrous, you are filled with a sense of detachment and an aching feeling of loss and abandonment. 
Tenebrous requires that you never be the first to act in combat. If your initiative check result is the highest, you must delay until someone else takes a turn.

Granted Abilities: 
Tenebrous grants you power over undead and shadows. He gives you the ability to chill your foes.

Vessel of Emptiness: You can use the flicker shadow magic mystery once per day. At 13th level, you can use this ability two times per day, and at 19th level, you can use it three times per day.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_template"

void main()
{
    object oBinder      = OBJECT_SELF;
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TENEBROUS);
    int nUses = 1;
    int nSLA = GetSpellId();
    if (nBinderLevel >= 19) nUses = 3;
    else if (nBinderLevel >= 13) nUses = 2;
    
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

    	float fDur = 6.0 * nBinderLevel;
    	object oSkin = GetPCSkin(oBinder);
    	ActionDoCommand(AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusFeat(IP_CONST_FEAT_MYST_FLICKER), oSkin, fDur));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION), oBinder, fDur);
    	SetLocalInt(oBinder, "TenebrousFlicker", nBinderLevel);
    	DelayCommand(fDur, DeleteLocalInt(oBinder, "TenebrousFlicker"));
    }    
}