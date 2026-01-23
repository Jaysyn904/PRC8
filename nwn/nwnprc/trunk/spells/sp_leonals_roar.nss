//::///////////////////////////////////////////////
//:: Leonal's Roar
//:: [sp_leonalsroar.nss]
//:: Created by: Jaysyn
//:: Created on: 2025-08-01 19:06:26
//:://////////////////////////////////////////////
//::
/*
	Leonal's Roar
	(Book of Exalted Deeds)

	Evocation [Good, Sonic]
	Level: Druid 8,
	Components: V
	Casting Time: 1 standard action
	Range: 40 ft.
	Target: Nongood creatures in a 40-ft.-radius spread centered on you
	Duration: Instantaneous
	Saving Throw: Fortitude partial
	Spell Resistance: Yes

	This spell has the effect of a holy word, and it additionally
	deals 2d6 points of sonic damage to nongood creatures in the area.
	A successful Fortitude saving throw negates the sonic damage, but
	not the other effects of the spell.

*/
//:
//::///////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode()) return;

    object oTarget;
	object oCaster = OBJECT_SELF;
	
	int nSpellId = PRCGetSpellId();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nSaveDC;// = PRCGetSpellSaveDC(9999 /*SPELL_LEONALS_ROAR*/, SPELL_SCHOOL_EVOCATION, oCaster);
    int n35ed = GetPRCSwitch(PRC_35ED_WORD_OF_FAITH);

    // Spell visuals
    effect eDeaf = EffectDeaf();
    effect eStun = EffectStunned();
    effect eConfuse = PRCEffectConfused();
    effect eDeath = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eSmite = EffectVisualEffect(VFX_FNF_WORD);
    effect eSonicVFX = EffectVisualEffect(VFX_IMP_SONIC);
    effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;
	
	if(nSpellId == SPELL_FOT_LEONALS_ROAR)
	{
		int nCHA = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
		nSaveDC = 20 + nCHA;
	}
	else
	{
		int nSaveDC = PRCGetSpellSaveDC(SPELL_LEONALS_ROAR, SPELL_SCHOOL_EVOCATION, oCaster);
	}

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSmite, PRCGetSpellTargetLocation());

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
            && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
        {
            float fDelay = PRCGetRandomDelay(0.5, 2.0);
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LEONALS_ROAR));

            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                // Added: Leonal's Roar Sonic Damage (Fort negates)
                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SONIC, oCaster, fDelay))
                {
                    int nDmg = d6(2);
                    effect eSonicDmg = PRCEffectDamage(oTarget, nDmg, DAMAGE_TYPE_SONIC);
                    effect eSonicLink = EffectLinkEffects(eSonicVFX, eSonicDmg);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSonicLink, oTarget));
                }

                // Retain Holy Word's VFX sonic flash for hit feedback
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSonicVFX, oTarget);

                if (GetIsObjectValid(GetMaster(oTarget)))
                {
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
                    {
                        DeathlessFrenzyCheck(oTarget);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eUnsummon, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eDeath), oTarget));
                    }
                }
                else if (!PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
                {
                    int nHD = GetHitDice(oTarget);

                    // Deaf 1d4 rounds
                    eLink = EffectLinkEffects(eDur, eDeaf);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d4()), TRUE, -1, CasterLvl));

                    if ((nHD < 12 && !n35ed) || (n35ed && nHD < CasterLvl))
                    {
                        eLink = EffectLinkEffects(eMind, eStun);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), TRUE, -1, CasterLvl));
                    }

                    if ((nHD < 8 && n35ed) || (n35ed && nHD < CasterLvl - 5))
                    {
                        eLink = EffectLinkEffects(eSonicVFX, eConfuse);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(d10()), TRUE, -1, CasterLvl));
                    }

                    if ((nHD < 4 && n35ed) || (n35ed && nHD < CasterLvl - 10))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                        {
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
