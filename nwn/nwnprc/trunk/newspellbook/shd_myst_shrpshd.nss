/*
13/02/19 by Stratovarius

Sharp Shadows

Apprentice, Cloak of Shadows 
Level/School: 3rd/Abjuration 
Range: Personal 
Target: You 
Duration: 1 minute/level 

You cloak yourself in sharp spikes of darkness. Although they are weightless and do nothing to impede you, your foes soon discover that they’re not so lucky.

A creature striking you takes 1d6 points of piercing damage +1 point per caster level (maximum +15). Damage from sharp shadows is not considered magical for the purpose of overcoming damage reduction.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{    
    int nEvent = GetRunningEvent();

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    object oItem;
    
    // We aren't being called from any event, instead being cast
    if(nEvent == FALSE)
    {
        if(!ShadPreMystCastCode()) return;
        struct mystery myst = EvaluateMystery(oShadow, oTarget, (METASHADOW_EXTEND | METASHADOW_EMPOWER | METASHADOW_MAXIMIZE));
    
        if(myst.bCanMyst)
        {
            myst.fDur = 60.0 * myst.nShadowcasterLevel;       
            if(myst.bExtend) myst.fDur *= 2;
            // Duration Effects
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CHILL_SHIELD), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);    
            
            // Add eventhook to the armor
            oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oShadow);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "shd_myst_shrpshd", TRUE, FALSE);
            DelayCommand(myst.fDur, RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "shd_myst_shrpshd", TRUE, FALSE));
            if(myst.bEmpower) 
            {
                SetLocalInt(oShadow, "SharpShadEmp", TRUE);
                DelayCommand(myst.fDur, DeleteLocalInt(oShadow, "SharpShadEmp"));
            }
            if(myst.bMaximize) 
            {
                SetLocalInt(oShadow, "SharpShadMax", TRUE);
                DelayCommand(myst.fDur, DeleteLocalInt(oShadow, "SharpShadMax"));
            }            
        }         
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
    	if(GetIsInMeleeRange(oTarget, oShadow))
    	{
        	int nDam = d6();
        	if (GetLocalInt(oShadow, "SharpShadMax")) nDam = 6;
        	if (GetLocalInt(oShadow, "SharpShadEmp")) nDam += nDam/2;
        	nDam += PRCMin(15, GetShadowcasterLevel(oShadow, CLASS_TYPE_SHADOWCASTER));
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGMAG), oTarget);    
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_PIERCING), oTarget);    
        }	
    }
}