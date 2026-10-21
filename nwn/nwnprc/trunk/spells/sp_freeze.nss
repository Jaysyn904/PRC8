//::////////////////////////////////////////////////////////
//::
/*
	Freeze	(sp_freeze.nss)
	Conjuration (Creation) [Cold]
	Level: 				Druid 6,
	Components: 		V, S, DF,
	Casting Time: 		1 standard action
	Range: 				Medium (100 ft. + 10 ft./level)
	Effect: 			Ray
	Duration: 			1 round/2 levels
	Saving Throw: 		Reflex partial; see text
	Spell Resistance: 	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	Calling upon divine power, your hand turns cold and numbs 
	as you complete the spell. A moment later, a thin blue 
	ray swirled with white streaks from your outstretched 
	hand, leave a light fog in the air where it passes.

	You must succeed on a ranged touch attack with the ray 
	to strike a target. A target struck takes 2d6 points of 
	cold damage. A creature struck must succeed on a Reflex 
	save or be encased in a 5-inch-thick sheath of ice and 
	be immobilized (and is helpless). A creature encased in 
	ice takes 2d6 points of cold damage each round until 
	freed. A target encased in ice is aware and breathes 
	normally but cannot speak or move other tan to attempt 
	to escape by making a Strength check (see below). It 
	can still execute purely mental actions, such as using 
	a spell-like ability. A spellcaster can cast a spell 
	with no verbal or somatic component as long as the spell 
	lacks a focus or material component, or the material 
	component, focus, or divine focus is already in the 
	spellcaster's hand.

	The ice blocks line of effect. A winged creature cannot 
	flap its wings and falls. A swimmer can't swim but because 
	ice floats, the encase swimmer will rise to the surface 
	and bob about.

	A DC 22 Strength check breaks the ice, freeing the encased 
	creature. Creatures other than the target can also attack 
	the ice. The ice has hardness 0 and 15 hit points. When the 
	duration of the spell expires, the ice melts and the encased 
	creature is freed. Damage that would harm the creature must 
	first deal enough damage to destroy the ice before the 
	creature takes damage, and damage dealt to the ice is 
	subtracted from damage that would be dealt to the creature.

	PnP notes:  
	- Ranged touch; 2d6 cold on hit (no save vs damage).  
	- Failed Reflex: encased in ice — helpless, cannot  
	  speak/move; purely mental actions still allowed.  
	  Modeled: CutsceneParalyze + SpellFailure(100) for  
	  verbal/somatic spells (SLAs can't be filtered).  
	- Encased: 2d6 cold each round until freed.  
	- DC 22 Strength check each round breaks the ice.  
	- Ice: hardness 0, 15 hp; absorbs damage meant for  
	  the target until destroyed. Modeled by an  
	  OnDamaged accumulator + DamageImmunity pool.  
	- Others can attack the ice — approximated by the  
	  same damage pool. 	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 21:28:29
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_sp_func"  
#include "prc_inc_sp_tch"  
#include "prc_add_spell_dc" 
  
//:: Per-round: cold tick + Strength escape check  
void FreezeLoop(object oTarget, object oCaster, int nSpellID, int nEleDmg, int nBeatsLeft)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget)  
        || !GetHasSpellEffect(nSpellID, oTarget))  
    {  
        return; //:: Ice broken/dispelled/expired  
    }  
  
    //:: 2d6 cold per round encased  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(2), nEleDmg), oTarget, 0.0f, TRUE, nSpellID);  
  
    //:: DC 22 Strength check to break free  
    if (d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget) >= 22)  
    {  
        FloatingTextStringOnCreature("*Breaks free of the ice!*", oTarget, FALSE);  
        PRCRemoveSpellEffects(nSpellID, oCaster, oTarget);  
        DeleteLocalInt(oTarget, "PRC_FREEZE_ICE_HP");  
        RemoveEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED, "sp_freeze", TRUE, FALSE);  
        return;  
    }  
  
    if (--nBeatsLeft > 0)  
        DelayCommand(6.0f, FreezeLoop(oTarget, oCaster, nSpellID, nEleDmg, nBeatsLeft));  
}  
  
void FreezeCleanup(object oTarget)  
{  
    DeleteLocalInt(oTarget, "PRC_FREEZE_ICE_HP");  
    RemoveEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED, "sp_freeze", TRUE, FALSE);  
}  
  
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nSpellID   = PRCGetSpellId();  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSaveDC    = PRCGetSaveDC(oTarget, oCaster);  
    int nPenetr    = nCasterLevel + SPGetPenetr();  
    int nEleDmg    = ChangedElementalDamage(oCaster, DAMAGE_TYPE_COLD);  
    int nRounds    = PRCMax(1, nCasterLevel / 2);  
    float fDur     = RoundsToSeconds(nRounds);  
    int iAttackRoll = 0;  
  
    if (nMetaMagic & METAMAGIC_EXTEND)  
        fDur *= 2.0f;  
  
    if (!GetIsReactionTypeFriendly(oTarget))  
    {  
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));  
  
        iAttackRoll = PRCDoRangedTouchAttack(oTarget);  
        if (iAttackRoll > 0)  
        {  
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))  
            {  
                // 2d6 cold on hit, no save  
                int nDam = PRCMaximizeOrEmpower(6, 2, nMetaMagic) + SpellDamagePerDice(oCaster, 2);  
                ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDam, nEleDmg);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);  
  
                //:: Reflex or encased  
                if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_COLD))  
                {  
                    effect eLink = EffectCutsceneParalyze();  
                    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ICESKIN));  
                    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BLUR));  
  
                    //:: Ice sheath: 15 hp soak, hardness 0  
                    eLink = EffectLinkEffects(eLink, EffectDamageReduction(15, DAMAGE_POWER_ENERGY));  
  
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, nSpellID);  
  
                    //:: Ice hp pool + self-registered damage handler  
                    SetLocalInt(oTarget, "PRC_FREEZE_ICE_HP", 15);  
                    SetLocalInt(oTarget, "PRC_FREEZE_SPELL", nSpellID);  
                    SetLocalObject(oTarget, "PRC_FREEZE_CASTER", oCaster);  
                    AddEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED,  
                                   "sp_freeze", TRUE, FALSE);  
  
                    //:: Start per-round tick + escape loop  
                    DelayCommand(6.0f, FreezeLoop(oTarget, oCaster, nSpellID, nEleDmg, FloatToInt(fDur / 6.0f)));  
  
                    DelayCommand(fDur, FreezeCleanup(oTarget));  
                }  
            }  
        }  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_HAND,  !iAttackRoll), oTarget, 1.7, FALSE);  
    }  
    return iAttackRoll;  
}  
  
void main()  
{  
    //:: Ice sheath damage accumulator  
    int nRunEvent = GetRunningEvent();  
    if (nRunEvent == EVENT_VIRTUAL_ONDAMAGED)  
    {  
        object oTarget = OBJECT_SELF;  
        int nPool   = GetLocalInt(oTarget, "PRC_FREEZE_ICE_HP");  
        int nDamage = GetTotalDamageDealt();  
  
        if (nPool > 0 && nDamage > 0)  
        {  
            nPool -= nDamage;  
            SetLocalInt(oTarget, "PRC_FREEZE_ICE_HP", nPool);  
            if (nPool <= 0)  
            {  
                //:: Ice destroyed — spell ends  
                int nSpellID = GetLocalInt(oTarget, "PRC_FREEZE_SPELL");  
                object oCaster =  
                    GetLocalObject(oTarget, "PRC_FREEZE_CASTER");  
                PRCRemoveSpellEffects(nSpellID, oCaster, oTarget);  
                FreezeCleanup(oTarget);  
            }  
        }  
        return;  
    }  
  
    object oCaster = OBJECT_SELF;  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
    if (!X2PreSpellCastCode()) return;  
    object oTarget = PRCGetSpellTargetObject();  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);  
    if (!nEvent)  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD)  
            && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster)  
            && oCaster == oTarget)  
        {  
            SetLocalSpellVariables(oCaster, 1);  
            return;  
        }  
        if (oCaster != oTarget)  
            DoSpell(oCaster, oTarget, nCasterLevel, nEvent);  
    }  
    else  
    {  
        if (nEvent & PRC_SPELL_EVENT_ATTACK)  
        {  
            if (DoSpell(oCaster, oTarget, nCasterLevel, nEvent))  
                DecrementSpellCharges(oCaster);  
        }  
    }  
    PRCSetSchool();  
}