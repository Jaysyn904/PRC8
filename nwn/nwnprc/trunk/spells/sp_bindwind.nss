//::////////////////////////////////////////////////////////
//::
/*	
	Binding Winds
	Evocation [Air]
	Level: 				Druid 2, Windstorm 2,
	Components: 		V, S,
	Casting Time: 		1 Standard Action
	Range: 				Medium (100 ft. + 10 ft./level)
	Target: 			One Creature
	Duration: 			Concentration
	Saving Throw: 		Reflex negates
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	Calling upon the power of elemental air, you encircle 
	the target in whipping winds.

	The subject can act normally, but it cannot move from 
	its current location. The winds carry its voice away, 
	so it can speak but cannot be heard, and it cannot hear 
	anything but the roar of the winds. This spell distracts 
	spellcasters, and so a Concentration check is required 
	to successfully cast any spell (DC equal to this spell's 
	DC + the level of the spell being cast).

	Furthermore, no sonic or language dependent spells or 
	effects can be cast into or out of the winds though 
	spells cast by you upon yourself function normally). 
	Ranged attacks made into or out of the winds take a —2 
	penalty. Binding winds holds flying creatures in midair. 
	
	PnP mechanics:  
	- Subject acts normally but cannot move -> CutsceneImmobilize.  
	- Winds carry voice away / hear only roar -> EffectDeaf.  
	- Distracts casters: Concentration check (DC = spell save DC)  
	  each round; failure = cannot cast that round -> per-round  
	  skill check applies EffectSpellFailure(100) for 5.5s.  
	- -2 on ranged attacks through the winds -> EffectAttackDecrease(2)  
	  (broader than PnP; engine can't filter ranged-only).  
	- Concentration duration via CheckConcentrationOnEffect  
	  (prc_inc_core) — breaks on stun/paralyze/damage etc. 	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 18:19:11
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_core"  
#include "prc_add_spell_dc"
  
// Each round the victim must pass Concentration vs the spell's  
// save DC or lose the ability to cast for that round.  
void BindWindsCastCheck(object oTarget, int nSpellID, int nSaveDC)  
{  
    if (!GetIsObjectValid(oTarget)  
        || GetIsDead(oTarget)  
        || !GetHasSpellEffect(nSpellID, oTarget))  
    {  
        return;  
    }  
  
    int nRoll = d20() + GetSkillRank(SKILL_CONCENTRATION, oTarget);  
    if (nRoll < nSaveDC)  
    {  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
            EffectSpellFailure(100), oTarget, 5.5);  
        FloatingTextStringOnCreature("*Winds disrupt your casting!*",  
            oTarget, FALSE);  
    }  
  
    // reflash the tornado while the winds hold  
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_AIR1), oTarget);  
  
    DelayCommand(6.0, BindWindsCastCheck(oTarget, nSpellID, nSaveDC));  
}

void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);  
  
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLvl = PRCGetCasterLevel(oCaster);  
    int nSpellID   = PRCGetSpellId();  
    int nSaveDC    = PRCGetSaveDC(oTarget, oCaster);  
    int nDuration  = nCasterLvl;                      
  
    PRCSignalSpellEvent(oTarget, TRUE);  
  
    if (GetIsReactionTypeFriendly(oTarget))  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    if (!PRCDoResistSpell(oCaster, oTarget, nCasterLvl + SPGetPenetr()))  
    {  
        if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC,  
                              SAVING_THROW_TYPE_SPELL))  
        {  
            // cannot move, cannot hear/be heard, -2 attacks  
            effect eLink = EffectLinkEffects(  
                               EffectCutsceneImmobilize(),  
                               EffectDeaf());  
            eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));  
            eLink = EffectLinkEffects(eLink,  
                        EffectVisualEffect(VFX_DUR_BLUR));  
            eLink = SupernaturalEffect(eLink);  
  
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,  
                oTarget, RoundsToSeconds(nDuration), TRUE,  
                nSpellID, nCasterLvl);  
  
            // tornado burst on hit  
            ApplyEffectToObject(DURATION_TYPE_INSTANT,  
                EffectVisualEffect(VFX_DUR_AIR1), oTarget);  
  
            // caster concentration maintenance (3s ticks)  
            CheckConcentrationOnEffect(oCaster, nSpellID,  
                oTarget, nDuration * 6);  
  
            // victim's Concentration-to-cast checks (per round)  
            DelayCommand(6.0,  
                BindWindsCastCheck(oTarget, nSpellID, nSaveDC));  
        }  
    }  
  
    PRCSetSchool();  
}  
  















