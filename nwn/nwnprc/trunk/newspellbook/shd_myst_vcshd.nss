/*
12/02/19 by Stratovarius

Voice of Shadow

Apprentice, Ebon Whispers 
Level/School: 1st/Enchantment (Compulsion) [Mind-Affecting]
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature 
Duration: 1 round 
Saving Throw: Will negates 
Spell Resistance: Yes

By speaking via a conduit through the Plane of Shadow, you deliver a commanding message.

This mystery functions like the spell command, except if cast on undead or constructs. They are dazed for the duration.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = RoundsToSeconds(1);
        if(myst.bExtend) myst.fDur *= 2;   
        myst.nPen = ShadowSRPen(oShadow, myst.nShadowcasterLevel);
        
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oShadow, oTarget, myst.nPen) || myst.bIgnoreSR)
            {                
                if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
                {
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_NONE))
                    {
                        effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
                        myst.eLink = EffectLinkEffects(EffectDazed(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
                        if (myst.bIgnoreSR) myst.eLink = SupernaturalEffect(myst.eLink);
                        
						
						object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
						int nRemove = FALSE;
    					itemproperty ip = GetFirstItemProperty(oItem);
    					while(GetIsItemPropertyValid(ip))
    					{
    						if (GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS && GetItemPropertySubType(ip) == IP_CONST_IMMUNITYMISC_MINDSPELLS)
    						{
    							RemoveItemProperty(oItem, ip);
    							nRemove = TRUE;
    						}	
    						if (GetItemPropertyType(ip) == ITEM_PROPERTY_MIND_BLANK)
    						{
    							RemoveItemProperty(oItem, ip);
    							nRemove = TRUE;
    						}
    					    	
    					    ip = GetNextItemProperty(oItem);
    					}	
						
    					AssignCommand(oTarget, ClearAllActions(TRUE));
    					effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectCharmed());
    					DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel));
    					if (nRemove) DelayCommand(1.0, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oItem));                        
                        
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }                
                }
                else
                {
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
                        myst.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, myst.eLink, oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        DoCommandSpell(oShadow, oTarget, myst.nMystId, FloatToInt(myst.fDur/6.0), myst.nShadowcasterLevel);                    
                    }    
                }
            }    
        }
    }
}