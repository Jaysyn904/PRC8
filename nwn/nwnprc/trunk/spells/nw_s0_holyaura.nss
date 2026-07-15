//::////////////////////////////////////////////////////////
//:: Holy Aura
//:: NW_S0_HolyAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//::////////////////////////////////////////////////////////
/*
	Holy Aura 
	Abjuration [Good]
	Level: 			Clr 8, Good 8
	Components: 	V, S, F
	Casting time:	1 standard action
	Range: 			20 ft.
	Targets: 		One creature/level in a 20-ft.-radius 
					burst centered on you
	Duration: 		1 round/level (D)
	Saving Throw: 	See text
	Spell 
	Resistance: 	Yes (harmless)


	A brilliant divine radiance surrounds the subjects, 
	protecting them from attacks, granting them resistance 
	to spells cast by evil creatures, and causing evil 
	creatures to become blinded when they strike the 
	subjects. This abjuration has four effects.

	First, each warded creature gains a +4 deflection bonus 
	to AC and a +4 resistance bonus on saves. Unlike 
	protection from evil, this benefit applies against 
	all attacks, not just against attacks by evil creatures.

	Second, each warded creature gains spell resistance 25 
	against evil spells and spells cast by evil creatures.

	Third, the abjuration blocks possession and mental 
	influence, just as protection from evil does.

	Finally, if an evil creature succeeds on a melee attack 
	against a warded creature, the offending attacker is 
	blinded (Fortitude save negates, as blindness/deafness, 
	but against holy aura’s save DC).

	Focus: A tiny reliquary containing some sacred relic. 
			The reliquary costs at least 500 gp. 
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:: Modified By: mr_bumpkin Dec 4, 2003 for PRC
//:: Modified By: Jaysyn - PnP accuracy pass 
//:: 		Date: 2026-07-13 21:08:19		
//:://////////////////////////////////////////////
 
#include "prc_inc_spells"
 
void PRCDoHolyAura(object oTarget, int nDuration, int nSpellID, object oCaster)
{
    // Impact VFX
    effect eVis  = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
 
    // +4 deflection AC vs ALL attackers (PnP: unlike protection from evil)
    effect eAC   = EffectACIncrease(4, AC_DEFLECTION_BONUS);
 
    // +4 resistance bonus to all saves vs ALL (PnP: applies against all attacks)
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
 
    // SR 25 vs evil spells/casters only
    effect eSR   = EffectSpellResistanceIncrease(25);
    eSR          = VersusAlignmentEffect(eSR, ALIGNMENT_ALL, ALIGNMENT_EVIL);
 
    // Mind-affecting immunity vs evil creatures only
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    eImmune        = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, ALIGNMENT_EVIL);
 
    // Blind evil attacker on hit (Fort negates) — approximated via damage shield
    // triggering blindness via OnHit is not natively available, so we use
    // a divine damage shield as the closest NWN approximation
    effect eBlind  = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);
    eBlind         = VersusAlignmentEffect(eBlind, ALIGNMENT_ALL, ALIGNMENT_EVIL);
 
    // Persistent VFX
    effect eDur  = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
 
    // Link — AC and saves are NOT VersusAlignment per PnP
    effect eLink = EffectLinkEffects(eAC, eSave);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eImmune);
    eLink = EffectLinkEffects(eLink, eBlind);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
 
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
 
    ApplyEffectToObject(DURATION_TYPE_INSTANT,   eVis,  oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}
 
void main()
{
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
 
    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
 
    object oCaster  = OBJECT_SELF;
    int    nSpellID = PRCGetSpellId();
    int    nCasterLevel = PRCGetCasterLevel(oCaster);
    int    nDuration    = nCasterLevel;         // 1 round/level
    int    nMaxTargets  = nCasterLevel;         // 1 creature/level
    int    nCount       = 0;
 
    // Remove existing instance on caster to prevent stacking
    PRCRemoveSpellEffects(nSpellID, oCaster, oCaster);
 
    // AoE — 20ft burst centered on caster
    // Apply to caster first
    PRCDoHolyAura(oCaster, nDuration, nSpellID, oCaster);
    nCount++;
 
    // Apply to nearby allies within 20ft up to caster level targets
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), GetLocation(oCaster), TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCount < nMaxTargets)
    {
        if (oTarget != oCaster &&
            !GetIsEnemy(oTarget, oCaster) &&
            GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
        {
            // Remove existing instance on target
            PRCRemoveSpellEffects(nSpellID, oCaster, oTarget);
            PRCDoHolyAura(oTarget, nDuration, nSpellID, oCaster);
            nCount++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), GetLocation(oCaster), TRUE, OBJECT_TYPE_CREATURE);
    }
 
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

/* void PRCDoAura(int nAlign, int nVis1, int nVis2, int nDamageType)
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);

    effect eVis = EffectVisualEffect(nVis1);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    //Change the effects so that it only applies when the target is evil
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR = EffectSpellResistanceIncrease(25); //Check if this is a bonus or a setting.
    effect eDur = EffectVisualEffect(nVis2);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eEvil = EffectDamageShield(6, DAMAGE_BONUS_1d8, nDamageType);


    // * make them versus the alignment

    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, nAlign);
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, nAlign);
    eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    eEvil = VersusAlignmentEffect(eEvil,ALIGNMENT_ALL, nAlign);


    //Link effects
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eEvil);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}


void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //--------------------------------------------------------------------------
    // GZ: Make sure this aura is only active once
    //--------------------------------------------------------------------------
    PRCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,PRCGetSpellTargetObject());


    PRCDoAura(ALIGNMENT_EVIL, VFX_DUR_PROTECTION_GOOD_MAJOR, VFX_DUR_PROTECTION_GOOD_MAJOR, DAMAGE_TYPE_DIVINE);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

 */