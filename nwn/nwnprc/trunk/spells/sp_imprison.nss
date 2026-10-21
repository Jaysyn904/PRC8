//::////////////////////////////////////////////////////////
//::
/*	
	Imprisonment (sp_imprison.nss)
	Abjuration
	Level: 				Sor/Wiz 9
	Components: 		V, S
	Casting time: 		1 action
	Range: 				Touch
	Target: 			Creature touched
	Duration: 			Instantaneous
	Saving Throw: 		None
	Spell Resistance: 	Yes	
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	When the character casts imprisonment and touches an 
	opponent, the target is entombed in a state of suspended
	animation in a small sphere far beneath the surface of 
	the earth. For the creature, time ceases to flow and its 
	condition becomes fixed. The creature does not grow older. 
	Its body functions virtually cease, and no force or effect 
	can harm it. The subject remains there unless a freedom 
	spell is cast at the locale where the imprisonment took 
	place. Magical search by most divinations do not reveal 
	the fact that a creature is imprisoned, but discern location 
	does. A wish or miracle spell will not free the recipient 
	but will reveal where it is entombed. The imprisonment 
	spell functions only if the target's name and some facts 
	about its life are known.

	Target is entombed in suspended animation far beneath  
	the earth; time ceases, no force or effect can harm  
	it. Modeled as: jump to prison waypoint + cutscene  
	paralyze + ghost + ethereal + total damage/spell  
	immunity. 
	- NO SAVING THROW per PnP. SR applies (Yes).  
	- Only a freedom spell cast at the locale releases the  
	victim — the prison marker placeable at the casting  
	site carries the data a freedom script needs.		
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: ???
//:: Date: 	???
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 16:47:08
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_sp_tch"  

const int VFX_IMPRISONMENT = 9999999;
  
void ClearImprisonEntry(object oCaster, location lPrison)  
{  
    object oArea   = GetAreaFromLocation(lPrison);  
    vector vPos    = GetPositionFromLocation(lPrison);  
    int nCount     = GetPersistantLocalInt(oCaster, "ImprisonCount");  
    int nFound     = 0;  
    int i;  
  
    //:: Find the matching entry  
    for (i = 1; i <= nCount; i++)  
    {  
        struct metalocation mStored = GetPersistantLocalMetalocation(  
            oCaster, "ImprisonLoc_" + IntToString(i));  
        if (mStored.sAreaTag == GetTag(oArea) &&  
            fabs(mStored.fX - vPos.x) < 0.01 &&  
            fabs(mStored.fY - vPos.y) < 0.01 &&  
            fabs(mStored.fZ - vPos.z) < 0.01)  
        {  
            nFound = i;  
            break;  
        }  
    }  
    if (!nFound) return;  
  
    //:: Shift remaining entries down (same pattern as DeleteMapPin)  
    for (i = nFound; i < nCount; i++)  
    {  
        SetPersistantLocalMetalocation(oCaster,  
            "ImprisonLoc_" + IntToString(i),  
            GetPersistantLocalMetalocation(oCaster, "ImprisonLoc_" + IntToString(i + 1)));  
        SetPersistantLocalString(oCaster,  
            "ImprisonName_" + IntToString(i),  
            GetPersistantLocalString(oCaster, "ImprisonName_" + IntToString(i + 1)));  
    }  
  
    //:: Clear the now-duplicate tail slot and fix the count  
    DeletePersistantLocalMetalocation(oCaster, "ImprisonLoc_" + IntToString(nCount));  
    DeletePersistantLocalString(oCaster, "ImprisonName_" + IntToString(nCount));  
    SetPersistantLocalInt(oCaster, "ImprisonCount", nCount - 1);  
}

  
//:: Call this from a Freedom spell script targeting the prison  
//:: marker to release the victim.  
void RunFreedom(object oTarget, object oPrison, object oCaster = OBJECT_INVALID)  
{  
    //:: Strip the immunity bundle regardless of who cast it —  
    //:: the original imprisoner may not be a valid object anymore.  
    PRCRemoveEffectsFromSpell(oTarget, 777777/* SPELL_IMPRISONMENT */);  
  
    AssignCommand(oTarget, ClearAllActions());  
    AssignCommand(oTarget, JumpToObject(oPrison));  
    ApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_KNOCK), oPrison);  
  
    //:: Clear both the session flag and the persistent flag  
    //:: so OnEnter doesn't re-entomb the victim  
    DeleteLocalInt(oTarget, "PRC_IMPRISONED");  
    if (GetIsPC(oTarget))  
        DeletePersistantLocalInt(oTarget, "PRC_IMPRISONED");  
  
    //:: Remove the prison from the caster's persistent list so  
    //:: the marker doesn't respawn on their next login  
    if (GetIsObjectValid(oCaster) && GetIsPC(oCaster))  
        ClearImprisonEntry(oCaster, GetLocation(oPrison));  
  
    DestroyObject(oPrison, 2.0);  
}
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);  
  
    //:: Spellcast hook  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    if (GetTag(GetArea(oCaster)) == "LOCATION_INVALID")  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Declare major variables
    object oTarget      = PRCGetSpellTargetObject();  
    int nCasterLevel    = PRCGetCasterLevel(oCaster);  
    int nPenetr         = nCasterLevel + SPGetPenetr();  
    location lTarget    = GetLocation(oTarget);  
    object oPrisonPoint = GetWaypointByTag("ImprisonmentWP");  
    effect eVis         = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);  
    effect eVis2        = EffectVisualEffect(VFX_IMPRISONMENT);  
  
    //:: PvP / hostility check  
    if (!spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Melee touch attack
    if (PRCDoMeleeTouchAttack(oTarget, TRUE, oCaster) <= 0)  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    //:: Plot-flagged targets can't be entombed  
    if (GetPlotFlag(oTarget))  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    PRCSignalSpellEvent(oTarget, TRUE, PRCGetSpellId(), oCaster);  
  
    //:: Spell Resistance 
    if (PRCDoResistSpell(oCaster, oTarget, nPenetr))  
    {  
        PRCSetSchool();  
        return;  
    }  
	
    //:: Single player: just death with a custom GUI  
    if (GetIsPC(oTarget) && GetPCPublicCDKey(oTarget) == "")  
    {  
        DeathlessFrenzyCheck(oTarget);  
        ApplyEffectToObject(DURATION_TYPE_INSTANT,  
            SupernaturalEffect(EffectDeath(TRUE)), oTarget);  
        DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, TRUE, TRUE, 0,  
            "You Have Been Imprisoned in Stasis, deep in the bowels "  
            + "of the earth."));  
        DelayCommand(2.75, ExecuteScript("prc_ondeath", oTarget));  
        PRCSetSchool();  
        return;  
    }
  
    //:: Apply effects  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);  
  
    //:: Suspended animation: total immunity
    effect eLink =                   EffectCutsceneParalyze();  
    eLink = EffectLinkEffects(eLink, EffectCutsceneGhost());  
    eLink = EffectLinkEffects(eLink, EffectEthereal());  
    eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_ALL_SPELLS));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));  
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));  
  
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT,  
        SupernaturalEffect(eLink), oTarget, 0.0, TRUE,  
        PRCGetSpellId(), nCasterLevel, oCaster);  
    SetLocalInt(oTarget, "PRC_IMPRISONED", TRUE);  
  
    //:: Prison marker at the locale where imprisonment  
    //:: took place (PnP: freedom must be cast there)
    object oPrison = CreateObject(OBJECT_TYPE_PLACEABLE, "gcs_SpellPrison", lTarget);  
    if (GetIsObjectValid(oPrison))  
    {  
        SetLocalString(oPrison, "Imprisoned_One", GetName(oTarget));  
        SetLocalObject(oPrison, "PRC_IMPRISONED_CREATURE", oTarget);  
        SetLocalObject(oPrison, "PRC_IMPRISON_CASTER", oCaster);  
    }  
  
    //:: Persist the prison on the CASTER so it can be rebuilt  
    //:: after a server reset when they log back in.  
    if (GetIsPC(oCaster))  
    {  
        int nCount = GetPersistantLocalInt(oCaster, "ImprisonCount");  
        SetPersistantLocalMetalocation(oCaster,  
            "ImprisonLoc_" + IntToString(nCount + 1), LocationToMetalocation(lTarget));  
        SetPersistantLocalString(oCaster,  
            "ImprisonName_" + IntToString(nCount + 1), GetName(oTarget));  
        SetPersistantLocalInt(oCaster, "ImprisonCount", nCount + 1);  
    }
  
    //:: Entomb beneath the earth  
    AssignCommand(oTarget, ClearAllActions());  
    if (GetIsObjectValid(oPrisonPoint))  
        AssignCommand(oTarget, JumpToObject(oPrisonPoint));	
  
    PRCSetSchool();  
}