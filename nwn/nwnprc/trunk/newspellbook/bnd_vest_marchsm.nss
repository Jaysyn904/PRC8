/*
18/03/21 by Stratovarius

Marchosias, King of Killers
    
A legendary assassin in life, Marchosias now grants his summoners his supernatural charm, plus the ability to kill or paralyze with one startling attack and to disappear in a puff of smoke.
  
Vestige Level: 7th
Binding DC: 30
Special Requirement: No
  
Influence: Marchosias’s influence makes you debonair and sly, as though you have some trick up your sleeve and the knowledge of it makes you confident. In addition, 
Marchosias requires that you use the death attack he grants you against any foe you catch unawares.
  
Granted Abilities: 
Marchosias gives you an assassin’s skill at killing, plus the ability to assume gaseous form and the power to charm foes.

Smoke Form: You can assume the form of a smoke cloud at will, like the gaseous form spell. You can suppress or activate this ability as a standard action. 
Once you have returned to your normal form from smoke form, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void MarchosiasLock(object oBinder, int nSpell);

void MarchosiasLock(object oBinder, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oBinder))
	{
		DeleteLocalInt(oBinder, "Bind"+IntToString(nSpell));
		BindAbilCooldown(oBinder, nSpell, VESTIGE_MARCHOSIAS);
	}
	else
		DelayCommand(1.0, MarchosiasLock(oBinder, nSpell));
}

void main()
{
	object oBinder = OBJECT_SELF;

    if (GetHasSpellEffect(SPELL_GASEOUS_FORM, oBinder))
    {
    	PRCRemoveSpellEffects(SPELL_GASEOUS_FORM, oBinder, oBinder);
	}	
	else
	{
    	if (GetLocalInt(oBinder, "Bind"+IntToString(SPELL_GASEOUS_FORM))) return;
		SetLocalInt(oBinder, "Bind"+IntToString(SPELL_GASEOUS_FORM), TRUE);	
		DoRacialSLA(SPELL_GASEOUS_FORM, GetBinderLevel(oBinder, VESTIGE_MARCHOSIAS), 0, TRUE);
		DelayCommand(2.0, MarchosiasLock(oBinder, SPELL_GASEOUS_FORM));
	}	
}
