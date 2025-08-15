//::////////////////////////////////////////////////////////
//::
//::	Creeping Cold & Greater Creeping Cold
//:: 	sp_creepingcold.nss
//:
//::////////////////////////////////////////////////////////
//::
/*
	Creeping Cold
	Transmutation [Cold]
	Level: Drd 2
	Components: V, S, F
	Casting Time: 1 action
	Range: Close (25 ft. + 5 ft./2 levels)
	Target: One creature
	Duration: 3 rounds
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	You turn the subject’s sweat to ice, creating blisters as 
	ice forms on and inside the skin. The spell deals 1d6 cumulative 
	points of cold damage per round it is in effect (that is, 1d6 
	on the 1st round, 2d6 on the second, and 3d6 on the third). 
	Only one save is allowed against the spell; if successful, 
	it halves the damage each round. 

	Focus: A small glass or pottery vessel worth at least 25
	gp filled with ice, snow, or water.

	Greater Creeping Cold
	Transmutation [Cold]
	Level: Drd 7
	Duration: See text
	This spell is the same as creeping cold, but it adds a fourth
	round to the duration, during which it deals 4d6 points
	of damage, if the caster is at least 15th level, it adds a fifth
	round at 5d6 points of damage. If the caster is at least
	20th level, it adds a sixth round at 6d6 points of damage
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created By: Jaysyn
//:: Created on: 2025-08-07 00:18:04
//::
//::////////////////////////////////////////////////////////
#include "x2_inc_spellhook"

void ApplyCreepingColdDamage(object oTarget, object oCaster, int nSpellID, int nMetaMagic, int nRound, int nMaxRounds, int nMaxDice, int nSave, int nEleDmg);

void main()
{
    if (!X2PreSpellCastCode()) return;

    int nSpellID = PRCGetSpellId();
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCL = PRCGetCasterLevel(oCaster);
    nCL += SPGetPenetr();

    int nMaxRounds = 3;
    int nMaxDice   = 3;

    if (nSpellID == SPELL_GREATER_CREEPING_COLD)
    {
        nMaxRounds = 4;
        if (nCL >= 15) nMaxRounds = 5;
        if (nCL >= 20) nMaxRounds = 6;

        nMaxDice = nMaxRounds; // capped at 6
    }

    // Extend doubles duration but not damage cap
    if (nMetaMagic & METAMAGIC_EXTEND)
        nMaxRounds *= 2;

    int nEleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);

    if (!GetIsReactionTypeFriendly(oTarget, oCaster))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));

        if (PRCDoResistSpell(oCaster, oTarget, nCL))
        {
            effect eFail = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oTarget);
            return;
        }

        int nDC = PRCGetSpellSaveDC(nSpellID, SPELL_SCHOOL_TRANSMUTATION, oCaster);
        int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD, oCaster);

        effect eVis = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_ICESKIN));
		effect eCold = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_FROST_L));
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget);		
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(nMaxRounds));

        DelayCommand(0.0f, ApplyCreepingColdDamage(oTarget, oCaster, nSpellID, nMetaMagic, 1, nMaxRounds, nMaxDice, nSave, nEleDmg));
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
}

void ApplyCreepingColdDamage(object oTarget, object oCaster, int nSpellID, int nMetaMagic, int nRound, int nMaxRounds, int nMaxDice, int nSave, int nEleDmg)
{
    if (GetIsDead(oTarget)) return;

    int nDice = nRound;
    if (nDice > nMaxDice)
        nDice = nMaxDice;

    int nDamage = d6(nDice);
    if (nMetaMagic & METAMAGIC_MAXIMIZE)
        nDamage = nDice * 6;
    else if (nMetaMagic & METAMAGIC_EMPOWER)
        nDamage += nDamage / 2;

    nDamage += SpellDamagePerDice(oCaster, nDice);

    if (nSave == FALSE)
        nDamage /= 2;

    effect eVFX = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDmg = PRCEffectDamage(oTarget, nDamage, nEleDmg);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(eVFX, eDmg), oTarget);

    if (nRound < nMaxRounds)
    {
        DelayCommand(6.0f, ApplyCreepingColdDamage(oTarget, oCaster, nSpellID, nMetaMagic, nRound + 1, nMaxRounds, nMaxDice, nSave, nEleDmg));
    }
}