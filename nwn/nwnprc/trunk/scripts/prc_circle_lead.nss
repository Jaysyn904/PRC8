//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////
//::  
/*
	Circle Leader
	Type of Feat: Class Specific
	Prerequisite: Red Wizard level 5 or Hathran 5.
	Specifics: Allows caster to initiate Circle 
	Magic. Two to four participants can sacrifice 
	spells to augment the Circle Leader's spell 
	casting abilities for one rest cycle.
	Use: Activate Feat.
	
*/
//::  
//:://////////////////////////////////////////////  
//::	Script:     prc_circle_lead.nss  
//::	Author:     Jaysyn  
//::	Created:    2026-02-10 12:19:50  
//:://////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_inc_burn"  
#include "x2_inc_spellhook"
  
// Helper to apply delayed visual transform  
void DelayedApplyTransform(object oTarget)  
{  
    if (DEBUG) DoDebug("Starting to float!");  
    SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 1.0f,  
        OBJECT_VISUAL_TRANSFORM_LERP_SMOOTHERSTEP, 3.0f);  
}  
  
// Helper to clean up all circle effects and events  
void CleanupCircle(object oLeader)  
{  
    if (DEBUG) DoDebug("Cleaning up circle for " + GetName(oLeader));  
    // Clear animation  
    if (GetLocalInt(oLeader, "CircleMagicAnimating"))  
    {  
        AssignCommand(oLeader, ClearAllActions());  
        DeleteLocalInt(oLeader, "CircleMagicAnimating");  
    }  
    // Clear VFX by tag  
    effect eVFX = GetFirstEffect(oLeader);  
    while (GetIsEffectValid(eVFX))  
    {  
        if (GetEffectTag(eVFX) == "CircleMagicVFX")  
            DelayCommand(2.5f, RemoveEffect(oLeader, eVFX));  
        eVFX = GetNextEffect(oLeader);  
    }  
    // Reset floating transform with lerp  
    if (GetLocalInt(oLeader, "CircleMagicFloating"))  
    {  
        SetObjectVisualTransform(oLeader, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 0.0f,  
            OBJECT_VISUAL_TRANSFORM_LERP_SMOOTHERSTEP, 3.0f);  
        DeleteLocalInt(oLeader, "CircleMagicFloating");  
    }  
    // Clear state variables  
    DeleteLocalInt(oLeader, "CircleMagicActive");  
    DeleteLocalInt(oLeader, "CircleMagicTotal");  
    DeleteLocalString(oLeader, "CircleMagicClass");  
    DeleteLocalInt(oLeader, "CircleMagicMaxParticipants");  
    DeleteLocalInt(oLeader, "CircleMagicParticipants");  
    DeleteLocalLocation(oLeader, "CircleMagicStartLoc");  
    // Remove events  
    if (DEBUG) DoDebug("Removing HB and OnDamaged events for " + GetName(oLeader));  
    RemoveEventScript(oLeader, EVENT_ONHEARTBEAT, "prc_circle_lead");  
    RemoveEventScript(oLeader, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");  
}  
  
void main()  
{  
    if (DEBUG) DoDebug("prc_circle_lead script executed for " + GetName(OBJECT_SELF));  
  
    int nEvent = GetRunningEvent();  
    object oLeader = OBJECT_SELF;  
  
    // Initial feat activation  
    if (nEvent == FALSE)  
    {  
        if (DEBUG) DoDebug("Circle Leader feat activation running");  
        // Toggle off if already active  
        if (GetLocalInt(oLeader, "CircleMagicActive"))  
        {  
            FloatingTextStringOnCreature("You stop leading the circle.", oLeader);  
            CleanupCircle(oLeader);  
            return;  
        }  
        // Determine max participants and class tag  
        int bIsGreat = GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_THAYAN, oLeader) ||  
                       GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_RASHEMAN, oLeader);  
        int nMaxParticipants = bIsGreat ? 9 : 4;  
        string sClassTag;  
        if (GetHasFeat(FEAT_CIRCLE_LEADER_THAYAN, oLeader) ||  
            GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_THAYAN, oLeader))  
            sClassTag = "RED_WIZARD";  
        else if (GetHasFeat(FEAT_CIRCLE_LEADER_RASHEMAN, oLeader) ||  
                 GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_RASHEMAN, oLeader))  
            sClassTag = "HATHRAN";  
        // Class gating for Great Circle Leader variants  
        if ((sClassTag == "RED_WIZARD" && GetLevelByClass(CLASS_TYPE_RED_WIZARD, oLeader) == 0) ||  
            (sClassTag == "HATHRAN" && GetLevelByClass(CLASS_TYPE_HATHRAN, oLeader) == 0))  
        {  
            FloatingTextStringOnCreature("You do not qualify to lead this circle.", oLeader);  
            return;  
        }  
        // Initialize circle state  
        SetLocalInt(oLeader, "CircleMagicActive", TRUE);  
        SetLocalInt(oLeader, "CircleMagicTotal", 0);  
        SetLocalInt(oLeader, "CircleMagicParticipants", 0);  
        SetLocalInt(oLeader, "CircleMagicMaxParticipants", nMaxParticipants);  
        SetLocalString(oLeader, "CircleMagicClass", sClassTag);  
        SetLocalLocation(oLeader, "CircleMagicStartLoc", GetLocation(oLeader));  
        // Start animation and mark  
        AssignCommand(oLeader, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, HoursToSeconds(24)));  
        SetLocalInt(oLeader, "CircleMagicAnimating", TRUE);  
		// Apply VFX (tagged for removal)  
		effect eVFX1 = EffectVisualEffect(VFX_DUR_GLOW_PURPLE);  
		effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);  
		effect eVFX3 = EffectVisualEffect(PSI_DUR_BURST);  
		// Dummy valid effect so the link isn’t VFX-only  
		effect eDummy = EffectCutsceneGhost();  
		effect eLink = EffectLinkEffects(eDummy, eVFX1);  
		eLink = EffectLinkEffects(eLink, eVFX2);  
		eLink = EffectLinkEffects(eLink, eVFX3);  
		eLink = TagEffect(eLink, "CircleMagicVFX");  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oLeader, HoursToSeconds(24));
        // Apply floating transform after a short delay  
        DelayCommand(0.1f, DelayedApplyTransform(oLeader));  
        SetLocalInt(oLeader, "CircleMagicFloating", TRUE);  
        // Register heartbeat and OnDamaged for concentration  
        AddEventScript(oLeader, EVENT_ONHEARTBEAT, "prc_circle_lead", TRUE, FALSE);  
        AddEventScript(oLeader, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc", TRUE, FALSE);  
        // Command eligible henchmen to use Circle Magic feat  
        int i = 1;  
        object oAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oLeader, i);  
        while (GetIsObjectValid(oAssoc))  
        {  
            if (GetHasFeat(FEAT_CIRCLE_MAGIC, oAssoc))  
            {  
                if ((sClassTag == "RED_WIZARD" && GetLevelByClass(CLASS_TYPE_RED_WIZARD, oAssoc) > 0) ||  
                    (sClassTag == "HATHRAN" && GetLevelByClass(CLASS_TYPE_HATHRAN, oAssoc) > 0))  
                {  
                    AssignCommand(oAssoc, ActionUseFeat(FEAT_CIRCLE_MAGIC, oLeader));  
                }  
            }  
            i++;  
            oAssoc = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oLeader, i);  
        }  
        FloatingTextStringOnCreature("Circle opened (" + IntToString(nMaxParticipants) + " participants max).", oLeader);  
    }  
    else if (nEvent == EVENT_ONHEARTBEAT)  
    {  
        if (DEBUG) DoDebug("Circle Leader HB running");  
        // Concentration break check  
        if (X2GetBreakConcentrationCondition(oLeader))  
        {  
            FloatingTextStringOnCreature("Your concentration is broken; the circle collapses.", oLeader);  
            CleanupCircle(oLeader);  
            return;  
        }  
        // Movement check  
        location lStart = GetLocalLocation(oLeader, "CircleMagicStartLoc");  
        float fDist = GetDistanceBetweenLocations(lStart, GetLocation(oLeader));  
        if (DEBUG) DoDebug("Distance from start: " + FloatToString(fDist));  
        if (fDist > 2.0f)  
        {  
            FloatingTextStringOnCreature("You moved too far; the circle collapses.", oLeader);  
            CleanupCircle(oLeader);  
            return;  
        }  
    }  
}