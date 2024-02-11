/*
Tenebrous Apostate - Blast of the Void

When you attain 5th level, you can use a turn or rebuke attempt to deal 1d8 points of damage per effective 
turning level to every living creature within a 30-foot cone. This ability is usable once per day.

Strat 05/03/21
*/
#include "bnd_inc_bndfunc"

void TenebrousUmbralLock(object oBinder, int nSpell);

void TenebrousUmbralLock(object oBinder, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oBinder))
	{
		DeleteLocalInt(oBinder, "Bind"+IntToString(nSpell));
		BindAbilCooldown(oBinder, nSpell, -1);
	}
	else
		DelayCommand(1.0, TenebrousUmbralLock(oBinder, nSpell));
}    

void main()
{
    object oBinder = OBJECT_SELF;
    float fDur = RoundsToSeconds(GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder)*2);
	int nSpell = GetSpellId();    
	SetLocalInt(oBinder, "Bind"+IntToString(nSpell), TRUE);    
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(PSI_DUR_SHADOW_BODY)), oBinder, fDur);
	SetIncorporeal(oBinder, fDur, 1);
	TenebrousUmbralLock(oBinder, nSpell);
}

