//::///////////////////////////////////////////////
//:: Mind Blank
//:: NW_S0_MindBlk.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies are granted immunity to mental effects
    in the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"

void PRCApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0)  
{  
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);  
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);  
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  
  
    effect eLink = EffectLinkEffects(eImm1, eVis);  
    eLink = EffectLinkEffects(eLink, eDur);  
    effect eSearch = GetFirstEffect(oTarget);  
    int bValid;  
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    //Enter Metamagic conditions  
    if (nMetaMagic & METAMAGIC_EXTEND)  
    {  
        nDuration = nDuration *2; //Duration is +100%  
    }  
  
    int nPnP = GetPRCSwitch(PRC_PNP_MINDBLANK);  
    float fDuration;  
    if (nPnP)  
    {  
        //PnP duration is a flat 1 day, or 2 days if Extended - does not scale with caster level  
        fDuration = HoursToSeconds(24);  
        if (nMetaMagic & METAMAGIC_EXTEND)  
        {  
            fDuration = HoursToSeconds(48);  
        }  
    }  
    else  
    {  
        fDuration = TurnsToSeconds(nDuration);  
    }  
  
    //Fire cast spell at event for the specified target  
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));  
    //Search through effects  
    while(GetIsEffectValid(eSearch))  
    {  
        bValid = FALSE;  
        //Check to see if the effect matches a particular type defined below  
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)  
        {  
            bValid = TRUE;  
        }  
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)  
        {  
            bValid = TRUE;  
        }  
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)  
        {  
            bValid = TRUE;  
        }  
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)  
        {  
            bValid = TRUE;  
        }  
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)  
        {  
            bValid = TRUE;  
        }  
        else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED)  
        {  
            bValid = TRUE;  
        }  
    // * Additional March 2003  
    // * Remove any feeblemind originating effects  
        else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)  
        {  
            bValid = TRUE;  
        }  
        else if (GetEffectSpellId(eSearch) == SPELL_BANE)  
        {  
            bValid = TRUE;  
        }  
  
        //Apply damage and remove effect if the effect is a match  
        if (bValid == TRUE)  
        {  
            RemoveEffect(oTarget, eSearch);  
        }  
        eSearch = GetNextEffect(oTarget);  
    }  
  
    //After effects are removed we apply the immunity to mind spells to the target  
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));  
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
  
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);  
    int nPnP = GetPRCSwitch(PRC_PNP_MINDBLANK);  
  
    if (!nPnP)  
    {  
        //Bioware: AOE, all allies in a Huge sphere  
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());  
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());  
        while(GetIsObjectValid(oTarget))  
        {  
            if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))  
            {  
                PRCApplyMindBlank(oTarget, GetSpellId(), PRCGetRandomDelay());  
            }  
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());  
        }  
    }  
    else  
    {  
        //PnP: single target only, no AOE  
        object oTarget = PRCGetSpellTargetObject();  
        if (GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))  
        {  
            PRCApplyMindBlank(oTarget, GetSpellId(), 0.0);  
        }  
    }  
  
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
}

/* void PRCApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0)
{
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eSearch = GetFirstEffect(oTarget);
    int bValid;
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

	int nPnP = GetPRCSwitch(PRC_PNP_MINDBLANK);  
	float fDuration = nPnP ? HoursToSeconds(nDuration * 24) : TurnsToSeconds(nDuration)

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
    //Search through effects
    while(GetIsEffectValid(eSearch))
    {
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED)
        {
            bValid = TRUE;
        }
    // * Additional March 2003
    // * Remove any feeblemind originating effects
        else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)
        {
            bValid = TRUE;
        }
        else if (GetEffectSpellId(eSearch) == SPELL_BANE)
        {
            bValid = TRUE;
        }

        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE)
        {
            RemoveEffect(oTarget, eSearch);
        }
        eSearch = GetNextEffect(oTarget);
    }

    //After effects are removed we apply the immunity to mind spells to the target
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
}
 */
/* void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            PRCApplyMindBlank(oTarget, GetSpellId(), PRCGetRandomDelay());
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation());
    }

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
} */
