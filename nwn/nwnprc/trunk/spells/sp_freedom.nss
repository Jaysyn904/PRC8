//::////////////////////////////////////////////////////////
//::
/*	
	Freedom (sp_freedom.nss)
	Abjuration
	Level: 				Sor/Wiz 9
	Components: 		V, S
	Casting time: 		1 action
	Range: 				See text
	Target: 			One creature
	Duration: 			Instantaneous
	Saving Throw:		None
	Spell Resistance:	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	The subject is freed from spells and effects that restrict
	his movement. To free someone from the imprisonment spell,
	the character must know that person's name and background, 
	and the character must cast this spell at the spot where 
	that person was entombed. 
	
	- Frees the subject from spells/effects restricting  
	 movement: remove paralyze/entangle/slow/petrify/  
	 movement-decrease — instantaneous, NOT an ongoing  
	 immunity buff (that's freedom of movement).  
	- Frees an imprisonment victim ONLY when cast at the  
	 entombment site — the gcs_SpellPrison marker is the  
	 locale anchor.	 
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: ???
//:: Date: 	???
//::	
//:: Fixed by: Jaysyn
//:: Date: 2026-10-07 21:44:39
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"

void ClearImprisonEntry(object oCaster, location lPrison)  
{  
    object oArea = GetAreaFromLocation(lPrison);  
    vector vPos  = GetPositionFromLocation(lPrison);  
    int nCount   = GetPersistantLocalInt(oCaster, "ImprisonCount");  
    int nFound   = 0;  
    int i;  
  
    for (i = 1; i <= nCount; i++)  
    {  
        struct metalocation mStored = GetPersistantLocalMetalocation(  
            oCaster, "ImprisonLoc_" + IntToString(i));  
        if (mStored.sAreaTag == GetTag(oArea) &&  
            fabs(mStored.fX - vPos.x) < 0.01 &&  
            fabs(mStored.fY - vPos.y) < 0.01 &&  
            fabs(mStored.fZ - vPos.z) < 0.01)  
        { nFound = i; break; }  
    }  
    if (!nFound) return;  
  
    for (i = nFound; i < nCount; i++)  
    {  
        SetPersistantLocalMetalocation(oCaster, "ImprisonLoc_" + IntToString(i),  
            GetPersistantLocalMetalocation(oCaster, "ImprisonLoc_" + IntToString(i + 1)));  
        SetPersistantLocalString(oCaster, "ImprisonName_" + IntToString(i),  
            GetPersistantLocalString(oCaster, "ImprisonName_" + IntToString(i + 1)));  
    }  
    DeletePersistantLocalMetalocation(oCaster, "ImprisonLoc_" + IntToString(nCount));  
    DeletePersistantLocalString(oCaster, "ImprisonName_" + IntToString(nCount));  
    SetPersistantLocalInt(oCaster, "ImprisonCount", nCount - 1);  
}  
  
void FreeCaptive(object oVictim, object oPrison)  
{  
	//:: Strip the immunity/paralysis bundle by spell ID — no  
	//:: creator check, so post-reset victims are covered.  
    PRCRemoveEffectsFromSpell(oVictim, 777777 /* SPELL_IMPRISONMENT */);  
  
    DeleteLocalInt(oVictim, "PRC_IMPRISONED");  
    if (GetIsPC(oVictim))  
        DeletePersistantLocalInt(oVictim, "PRC_IMPRISONED");  
  
    SetCommandable(TRUE, oVictim);  
    AssignCommand(oVictim, ClearAllActions());  
    AssignCommand(oVictim, JumpToObject(oPrison));  
    ApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectVisualEffect(VFX_IMP_KNOCK), oPrison);  
  
	//:: Remove from the imprisoner's persistent list  
    object oImprisoner = GetLocalObject(oPrison, "PRC_IMPRISON_CASTER");  
    if (GetIsObjectValid(oImprisoner) && GetIsPC(oImprisoner))  
        ClearImprisonEntry(oImprisoner, GetLocation(oPrison));  
  
    DestroyObject(oPrison, 2.0);  
    FloatingTextStringOnCreature("*Captive freed*", OBJECT_SELF, FALSE);  
}  
  
void RunFreedom(object oPrison)  
{  
	//:: Fast path: live object ref stored by sp_imprison.nss  
    object oVictim = GetLocalObject(oPrison, "PRC_IMPRISONED_CREATURE");  
    if (GetIsObjectValid(oVictim))  
    {  
        FreeCaptive(oVictim, oPrison);  
        return;  
    }  
  
	//:: Post-reset fallback: find by name at the prison waypoint  
    string sName = GetLocalString(oPrison, "Imprisoned_One");  
    if (sName == "") return;  
    object oCell = GetWaypointByTag("ImprisonmentWP");  
    int nNth = 1;  
    object oScan = GetNearestObject(OBJECT_TYPE_CREATURE, oCell, nNth);  
    while (GetIsObjectValid(oScan))  
    {  
        if (GetName(oScan) == sName)  
        {  
            FreeCaptive(oScan, oPrison);  
            return;  
        }  
        oScan = GetNearestObject(OBJECT_TYPE_CREATURE, oCell, ++nNth);  
    }  
    FloatingTextStringOnCreature("*Spell Failed*", OBJECT_SELF, FALSE);  
    SendMessageToPC(OBJECT_SELF, "The target seems to be unreachable at this time.");  
}  
  
void main()  
{  
    object oCaster = OBJECT_SELF;  
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);  
  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  
  
    object oTarget = PRCGetSpellTargetObject();  
    PRCSignalSpellEvent(oTarget, FALSE, PRCGetSpellId(), oCaster);  
  
	//:: Prison marker targeted: free the entombed ----  
    if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE &&  
        GetResRef(oTarget) == "gcs_spellprison")  
    {  
        RunFreedom(oTarget);  
        PRCSetSchool();  
        return;  
    }  
  
	//:: Normal path: strip movement-restricting effects 
	//:: PnP: instantaneous removal only — no ongoing immunity.  
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)  
    {  
        effect eLook = GetFirstEffect(oTarget);  
        while (GetIsEffectValid(eLook))  
        {  
            int nType = GetEffectType(eLook);  
            if (nType == EFFECT_TYPE_PARALYZE     ||  
                nType == EFFECT_TYPE_ENTANGLE     ||  
                nType == EFFECT_TYPE_SLOW         ||  
                nType == EFFECT_TYPE_PETRIFY      ||  
                nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)  
            {  
                RemoveEffect(oTarget, eLook);  
            }  
            eLook = GetNextEffect(oTarget);  
        }  
        
		ApplyEffectToObject(DURATION_TYPE_INSTANT,  
		EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT), oTarget);  
    }  
  
    PRCSetSchool();  
}