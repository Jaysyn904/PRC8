//::///////////////////////////////////////////////
//:: Name      Endure Exposure
//:: FileName  inv_dra_endrexp.nss
//::///////////////////////////////////////////////
/*

Least Invocation
3rd Level Spell

With a touch, you grant a creature (or yourself)
the ability to withstand hot or cold environments,
but doesn't protect against actual fire or cold
damage. In addition, the target is immune to your
breath weapon's effects. This invocation lasts for
24 hours.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void DispelMonitor(object oCaster, object oTarget, int nSpellID);

void main()
{
    if (!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());
    int bValid = FALSE;
    int nBPIndex = 0;
    int nBPTIndex = 0;
	
	int bValidTarget = FALSE;
	int bValidCaster = FALSE;	

    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

    //Add to array on target of breaths they're protected from

    if(!array_exists(oTarget, "BreathProtected"))
        array_create(oTarget, "BreathProtected");

	while(!bValidTarget)
	{
		if(array_get_object(oTarget, "BreathProtected", nBPIndex) == OBJECT_INVALID)
		{
			array_set_object(oTarget, "BreathProtected", nBPIndex, oCaster);
			bValidTarget = TRUE;
		}
		else
			nBPIndex++;
	}

    if(!array_exists(oCaster, "BreathProtectTargets"))
         array_create(oCaster, "BreathProtectTargets");
	 
	while(!bValidCaster)
	{
		if(array_get_object(oCaster, "BreathProtectTargets", nBPTIndex) == OBJECT_INVALID)
		{
			array_set_object(oCaster, "BreathProtectTargets", nBPTIndex, oTarget);
			if(DEBUG) DoDebug("Storing target: " + GetName(oTarget));
			bValidCaster = TRUE;
		}
		else
			nBPTIndex++;
	}

    //add to array on caster of targets protected by their spell for resting cleanup

    if(!array_exists(oCaster, "BreathProtectTargets"))
         array_create(oCaster, "BreathProtectTargets");

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DispelMonitor(oCaster, oTarget, INVOKE_ENDURE_EXPOSURE);
}


/* void main()
{
    if (!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = GetInvokerLevel(oCaster, GetInvokingClass());
    int bValid = FALSE;
    int nBPIndex = 0;
    int nBPTIndex = 0;

    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

    //Add to array on target of breaths they're protected from

    if(!array_exists(oTarget, "BreathProtected"))
        array_create(oTarget, "BreathProtected");

    while(!bValid)
    {
        //find the first empty spot and add it
        if(array_get_object(oTarget, "BreathProtected", nBPIndex) == OBJECT_INVALID)
        {
            array_set_object(oTarget, "BreathProtected", nBPIndex, oCaster);
            bValid = TRUE;
        }
        else
            nBPIndex++;
    }

    //add to array on caster of targets protected by their spell for resting cleanup

    if(!array_exists(oCaster, "BreathProtectTargets"))
         array_create(oCaster, "BreathProtectTargets");

    while(!bValid)
    {
        //find the first empty spot and add it
        if(array_get_object(oCaster, "BreathProtectTargets", nBPTIndex) == OBJECT_INVALID)
        {
            array_set_object(oCaster, "BreathProtectTargets", nBPTIndex, oTarget);
            if(DEBUG) DoDebug("Storing target: " + GetName(array_get_object(oCaster, "BreathProtectTargets", nBPTIndex)));
            bValid = TRUE;
        }
        else
            nBPTIndex++;
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DispelMonitor(oCaster, oTarget, INVOKE_ENDURE_EXPOSURE);
}
 */

void DispelMonitor(object oCaster, object oTarget, int nSpellID)
{
    // Has the power ended since the last beat, or does the duration run out now
    if(PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster))
    {
        if(DEBUG) DoDebug("inv_dra_endexp: The protection effect has been removed");
        array_delete(oCaster, "BreathProtected");
        DeleteLocalInt(oCaster, "DragonWard");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID));
}