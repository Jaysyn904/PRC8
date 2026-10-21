//::////////////////////////////////////////////////////////
//::
/*
	Rejuvenation Cocoon	(sp_rejuvcocoon.nss)
	Conjuration (Healing)
	Level: 				Druid 5,
	Components: 		V, S, M,
	Casting Time: 		1 standard action
	Range: 				Touch
	Target: 			Willing creature touched
	Duration: 			2 rounds
	Saving Throw: 		Will negates (harmless)
	Spell Resistance:	Yes (harmless)
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	You pass your hand over the body of your friend, drawing 
	a cocoon of glowing yellow-green energy about him.

	When you cast the spell, the rejuvenation cocoon forms 
	around the subject. One round after the cocoon forms, 
	it heals the subject of 10 points of damage per caster 
	level (maximum 150 hit points) and purges the subject 
	of poison and disease. At the end of the second round, 
	the rejuvenation cocoon dissipates and the subject 
	emerges, able to move and act freely.

	The cocoon is made of force, but it is somewhat flexible 
	and responds to pressure from the inside of the cocoon. 
	The subject can't move from the space it is in while 
	cocooned, however.

	The cocoon has hardness 10 and 10 hit points per caster 
	level. If it is destroyed, the spell ends.

	Material Component: A cocoon of a butterfly.

	PnP notes:  
	- Round 1 after casting: heals 10/CL (max 150) and  
	  purges poison and disease.  
	- Subject can't move while cocooned (2 rounds).  
	- Cocoon: hardness 10, 10hp/CL; destroyed = spell ends.  
	  HP pool tracked via EVENT_VIRTUAL_ONDAMAGED; hardness  
	  approximated by DR 10/- on the subject.	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 20:59:42
//::
//:://////////////////////////////////////////////////////// 
#include "prc_inc_spells"  
#include "prc_sp_func"  
  
void CocoonPurge(object oTarget, int nHeal, int nSpellID)  
{  
    if (!GetIsObjectValid(oTarget) || !PRCGetIsAliveCreature(oTarget)) return;  
    if (!GetHasSpellEffect(nSpellID, oTarget)) return; // cocoon gone  
  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectHeal(nHeal), oTarget, 0.0f, TRUE, nSpellID);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_HEALING_G), oTarget);  
  
    // Purge poison & disease  
    effect eCheck = GetFirstEffect(oTarget);  
    while (GetIsEffectValid(eCheck))  
    {  
        int nType = GetEffectType(eCheck);  
        if (nType == EFFECT_TYPE_POISON || nType == EFFECT_TYPE_DISEASE)  
            RemoveEffect(oTarget, eCheck);  
        eCheck = GetNextEffect(oTarget);  
    }  
}  
  
void CocoonCleanup(object oTarget)  
{  
    RemoveEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED,  
                      "sp_rejuvcocoon", FALSE, FALSE);  
    DeleteLocalInt(oTarget, "PRC_COCOON_HP");  
    DeleteLocalInt(oTarget, "PRC_COCOON_SPELLID");  
    DeleteLocalObject(oTarget, "PRC_COCOON_CASTER");  
}  
  
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)  
{  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nSpellID   = PRCGetSpellId();  
  
    // 2 rounds; Extend -> 4 rounds  
    float fDur = PRCGetMetaMagicDuration(RoundsToSeconds(2), nMetaMagic);  
  
    effect eLink = EffectCutsceneImmobilize();  
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));  
    // Hardness 10 approximation  
    eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    10));  
    eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    10));  
    eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 10));  
  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,  
                          TRUE, nSpellID, nCasterLevel);  
  
    // Cocoon hp pool: 10/CL; self-registered damage accumulator  
    SetLocalInt(oTarget, "PRC_COCOON_HP", 10 * nCasterLevel);  
    SetLocalInt(oTarget, "PRC_COCOON_SPELLID", nSpellID);  
    SetLocalObject(oTarget, "PRC_COCOON_CASTER", oCaster);  
    AddEventScript(oTarget, EVENT_VIRTUAL_ONDAMAGED,  
                   "sp_rejuvcocoon", TRUE, FALSE);  
  
    // Round 1: heal 10/CL (max 150), purge poison & disease  
    DelayCommand(6.0f, CocoonPurge(oTarget,  
                                   PRCMin(150, 10 * nCasterLevel),  
                                   nSpellID));  
  
    // Duration expiry cleanup  
    DelayCommand(fDur, CocoonCleanup(oTarget));  
  
    return TRUE;  
}  
  
void main()  
{  
    // ---- Event branch: cocoon damage accumulator ----  
    int nRunEvent = GetRunningEvent();  
    if (nRunEvent == EVENT_VIRTUAL_ONDAMAGED)  
    {  
        object oTarget = OBJECT_SELF;  
        int nPool = GetLocalInt(oTarget, "PRC_COCOON_HP");  
        if (nPool > 0)  
        {  
            int nDam = GetTotalDamageDealt();  
            nPool -= nDam;  
            if (nPool <= 0)  
            {  
                // Cocoon destroyed -> spell ends  
                int nSpellID = GetLocalInt(oTarget, "PRC_COCOON_SPELLID");  
                object oCaster = GetLocalObject(oTarget, "PRC_COCOON_CASTER");  
                if (GetIsObjectValid(oCaster))  
                    PRCRemoveSpellEffects(nSpellID, oCaster, oTarget);  
                else  
                    PRCRemoveEffectsFromSpell(oTarget, nSpellID);  
                FloatingTextStringOnCreature("*Cocoon destroyed*", oTarget);  
                CocoonCleanup(oTarget);  
            }  
            else  
                SetLocalInt(oTarget, "PRC_COCOON_HP", nPool);  
        }  
        return;  
    }  
  
    // ---- Spell-cast branch ----  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
  
    object oCaster = OBJECT_SELF;  
    object oTarget = PRCGetSpellTargetObject();  
    int nCasterLevel = PRCGetCasterLevel(oCaster);  
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT);  
  
    PRCSignalSpellEvent(oTarget, FALSE, PRCGetSpellId(), oCaster);  
  
    if (!nEvent) // normal cast  
    {  
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)  
        {  
            SetLocalSpellVariables(oCaster, 1);  
            return;  
        }  
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