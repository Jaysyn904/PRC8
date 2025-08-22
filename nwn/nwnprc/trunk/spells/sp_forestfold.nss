//::///////////////////////////////////////////////
//::
//::	Forestfold
//::	sp_forestfold.nss
//::
//:://////////////////////////////////////////////
/*
	Caster Level(s): Druid 4, Ranger 3
	School: Transmutation	
	Component(s): Verbal, Somatic
	Range: Personal
	Area of Effect / Target: Caster
	Duration: 10 turns / level
	Additional Counter Spells:
	Save: None
	Spell Resistance: No

	The caster's movement is muffled & their coloring
	changes to match their surroundings, gaining a +20 
	competence bonus to any Hide and Move Silently 
	checks.
	
*/
//:://////////////////////////////////////////////
//::
//:: Created By: Jaysyn
//:: Created On: 2025-08-06 12:24:24
//::
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"


void PRCDoForestfold(object oPC)
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eHide 	= EffectSkillIncrease(SKILL_HIDE, 20);
	effect eMS 		= EffectSkillIncrease(SKILL_MOVE_SILENTLY, 20);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHide, eDur);
	
			eLink = EffectLinkEffects(eLink, eMS);

    int nDuration = 10*PRCGetCasterLevel(oPC); // * Duration 10 turn/level
     if (nMetaMagic & METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_FORESTFOLD, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds(nDuration));
}

void main()
{
	object oPC = OBJECT_SELF;
	
	DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) { return; }

// No stacking
	PRCRemoveEffectsFromSpell(oPC, SPELL_FORESTFOLD);

// End of Spell Cast Hook
    PRCDoForestfold(oPC);
	
// Erasing the variable used to store the spell's spell school
	DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
}