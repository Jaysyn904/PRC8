//::///////////////////////////////////////////////
//:: [Squirt]
//:: [race_muck_squirt.nss]
//:: [Jaysyn / PRC 20220419]
//::///////////////////////////////////////////////
/**@file  Squirt (Ex): A muckdweller can
squirt a jet of water into the eyes of
a target up to 25 feet away. Anyone
hit by this attack must make a DC 13
Reflex save or be blinded for 1 round. The
save DC is Dexterity-based.

/////////////////////////////////////////////////////////////////////////////*/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
//:: Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
	
	int nDC = 10 + (GetAbilityModifier(1, oCaster));

    float fDuration = RoundsToSeconds(1);

    effect eVis   = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eBlind = EffectBlindness();
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = ExtraordinaryEffect(EffectLinkEffects(eBlind, eDur));

//:: Fire cast spell at event
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MUCK_SQUIRT));


//:: Make Reflex save to negate
	if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
	{	
	//:: Apply visual and effects
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
}