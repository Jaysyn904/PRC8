/*
1/03/21 by Stratovarius

Malphas, the Turnfeather
  
Malphas allows his summoners to see without being seen, to pass through surroundings without leaving any sign, to vanish from sight, and to poison their enemies.

Invisibility: As a standard action, you can make yourself invisible. Making an attack ends the invisibility (as normal), but otherwise, the effect lasts a number of rounds equal to your effective
binder level. You can invoke this ability as a swift action at 15th level. Once you return to visibility, you cannot use this ability again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void MalphasInvisLock(object oBinder, int nSpell);

void MalphasInvisLock(object oBinder, int nSpell)
{
	if (!GetHasSpellEffect(nSpell, oBinder))
	{
		DeleteLocalInt(oBinder, "Bind"+IntToString(nSpell));
		BindAbilCooldown(oBinder, nSpell, VESTIGE_MALPHAS);
	}
	else
		DelayCommand(1.0, MalphasInvisLock(oBinder, nSpell));
}

void main()
{
    object oBinder    = OBJECT_SELF;
    int nSpell = GetSpellId(); 
    if (GetLocalInt(oBinder, "Bind"+IntToString(nSpell))) return;
    int nBinderLevel  = GetBinderLevel(oBinder, VESTIGE_MALPHAS);
	SetLocalInt(oBinder, "Bind"+IntToString(nSpell), TRUE);
	
	effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eCover = EffectConcealment(50);
	effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eInvis);
	
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(eImpact), oBinder);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oBinder, RoundsToSeconds(nBinderLevel));
    MalphasInvisLock(oBinder, nSpell);
}