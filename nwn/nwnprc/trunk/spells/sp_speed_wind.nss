//::///////////////////////////////////////////////
//:: [Speed of the Wind]
//:: [sp_speed_wind.nss]
//:: [Yaballa: 7/9/2003]
//:: Modified by: Jaysyn 2024-08-20 20:06:06
//:: 
//::///////////////////////////////////////////////
/**@file Speed of the Wind
(Masters of the Wild: A Guidebook to Barbarians, Druids, and Rangers)

Transmutation
Level: Druid 2,
Components: V, S,
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: 10 minutes/level
Saving Throw: Will negates
Spell Resistance: Yes

With this spell, you can grant the ephemeral quickness
of a sudden breeze.  The subject gains a +4 enhancement 
bonus to Dexterity and a -2 enhancement penalty to 
Constitution.
 */////////////////////////////////////////////////
 #include "x2_inc_spellhook"
 
void ApplySpeedOfTheWindEffect(object oTarget, int nCasterLevel, int nMetamagic)
{
//:: Declare variables
	int nDuration = nCasterLevel;
	
//:: Handle metamagic
	if(nMetamagic & METAMAGIC_EXTEND) 
	{
        nDuration = nDuration * 2; 
	}		
//:: Set up effects
    effect eDex 	= EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eCon 	= EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
    effect eVis1 	= EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eVis2 	= EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
    effect eLink 	= EffectLinkEffects(eDex, eCon);
			eLink 	= EffectLinkEffects(eLink, eDur);

// Add visual effects to indicate the spell's impact
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
}

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

//:: Declare major variables
	object oCaster 		= OBJECT_SELF;
    object oTarget 		= GetSpellTargetObject();
    int nCasterLevel 	= PRCGetCasterLevel(oCaster);
	int nMetamagic		= PRCGetMetaMagicFeat();

//:: Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));
	
//:: If the target is Undead or a Construct, exit the script
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
    {
		SendMessageToPC(oCaster, "Only creatures with Constitution scores can be affected by Speed of the Wind");
	//:: Unset the Spell school
		PRCSetSchool();
        return;
    }

//:: Prevent spell stacking
     PRCRemoveEffectsFromSpell(oTarget, PRCGetSpellId());		
	 
//:: Apply the Speed of the Wind effects to the target
    ApplySpeedOfTheWindEffect(oTarget, nCasterLevel, nMetamagic);
	
//:: Unset the Spell school
    PRCSetSchool();	
}