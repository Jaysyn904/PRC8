//::////////////////////////////////////////////////////////
//:: tmp_hvamp_charm.nss
//::
//::////////////////////////////////////////////////////////
/*
	Charm Gaze (Su): Some half-vampires can charm humanoid 
	or monstrous humanoid opponents just by looking into 
	their eyes. This is similar to a gaze attack, except 
	that the half-vampire must use a standard action, and 
	those merely looking at the half-vampire are not 
	affected. Anyone the half-vampire targets must make a 
	successful Will save or fall under the half-vampire's 
	influence as though affected by a charm monster spell 
	(caster level equal to HD). Any creature that 
	successfully saves against a half-vampire's charm gaze 
	cannot be affected by that half-vampire's charm gaze 
	for 24 hours. The ability has a range of 30 feet.

*/
//::////////////////////////////////////////////////////////
#include "inc_newspellbook"
#include "prc_inc_core"
#include "prc_inc_spells"
 
void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nHD = GetHitDice(oCaster);
    int nDC = 10 + nHD + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
 
    // Humanoid-only restriction — per PnP: "charm humanoid or monstrous humanoid opponents"
    if(!PRCAmIAHumanoid(oTarget))
    {
        FloatingTextStringOnCreature("*Target is not a humanoid — Charm Gaze has no effect*", oCaster, FALSE);
        return;
    }
 
    // 24-hour immunity check
    if(GetLocalInt(oTarget, "PRC_HVamp_CharmGaze_Immune_" + ObjectToString(oCaster)))
    {
        FloatingTextStringOnCreature("*Target is immune to your Charm Gaze*", oCaster, FALSE);
        return;
    }
 
    // Will save
    int nSave = WillSave(oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster);
 
	if(nSave == 0) // Failed save  
	{  
		effect eVis   = EffectVisualEffect(VFX_IMP_CHARM);  
		effect eCharm = EffectCharmed();  
			   eCharm = PRCGetScaledEffect(eCharm, oTarget);  
		effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);  
		effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);  
		effect eLink  = EffectLinkEffects(eMind, eCharm);  
			   eLink  = EffectLinkEffects(eLink, eDur);  
	  
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3 + nHD/2), TRUE, SPELL_CHARM_MONSTER, nHD);  
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
	}
    else // Successful save — 24 hour immunity
    {
        SetLocalInt(oTarget, "PRC_HVamp_CharmGaze_Immune_" + ObjectToString(oCaster), TRUE);
        DelayCommand(HoursToSeconds(24),
            DeleteLocalInt(oTarget, "PRC_HVamp_CharmGaze_Immune_" + ObjectToString(oCaster)));
        FloatingTextStringOnCreature("*Target resists your Charm Gaze*", oCaster, FALSE);
    }
}