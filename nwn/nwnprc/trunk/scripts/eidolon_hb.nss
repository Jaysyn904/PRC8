//::///////////////////////////////////////////////  
//:: eidolon_hb.nss [Heartbeat]  
//:://///////////////////////////////////////////// 
//::
/*
	Dimensional lock does not interfere with an 
	eidolon's operation, but an eidolon that enters 
	the area of a dimensional lock spell or similar 
	effect loses the benefits of its otherworldly 
	geometry and its insanity aura.
	
*/
//::
//::///////////////////////////////////////////////	
#include "inc_debug"  
  
void main()  
{  
    ExecuteScript("nw_c2_default1", OBJECT_SELF);
	
	object oNPC = OBJECT_SELF;  
    int bLocked = GetLocalInt(oNPC, "PRC_Spell_DimLock_Affected");  
  
    int bHasAC = FALSE;  
    int bHasInsanity = FALSE;  
  
    effect eTest = GetFirstEffect(oNPC);  
    while (GetIsEffectValid(eTest))  
    {  
        string sTag = GetEffectTag(eTest);  
  
        if (sTag == "Eidolon_AC")  
        {  
            bHasAC = TRUE;  
            if (bLocked) RemoveEffect(oNPC, eTest);  
        }  
        else if (sTag == "Eidolon_Insanity")  
        {  
            bHasInsanity = TRUE;  
            if (bLocked) RemoveEffect(oNPC, eTest);  
        }  
  
        eTest = GetNextEffect(oNPC);  
    }  
  
    if (bLocked)  
    {  
        if(DEBUG) DoDebug("eidolon_hb >> In Dimensional Lock field, suppressing AC/Insanity");  
        return;  
    }  
  
    //:: Not locked - reapply if missing  
    if (!bHasAC)  
    {  
        effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);  
        eAC = TagEffect(eAC, "Eidolon_AC");  
        eAC = UnyieldingEffect(eAC);  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oNPC);  
        if(DEBUG) DoDebug("eidolon_hb >> Reapplied Eidolon_AC");  
    }  
  
    if (!bHasInsanity)  
    {  
        effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "eidolon_insan_a", "eidolon_insan_b", "");  
        effect eVis = EffectVisualEffect(VFX_DUR_AURA_BLUE_DARK);  
        effect eLink = EffectLinkEffects(eAOE, eVis);  
        eLink = TagEffect(eLink, "Eidolon_Insanity");  
        eLink = UnyieldingEffect(eLink);  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oNPC, HoursToSeconds(900));  
        if(DEBUG) DoDebug("eidolon_hb >> Reapplied Eidolon_Insanity");  
    }  
}