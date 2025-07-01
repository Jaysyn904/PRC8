//::///////////////////////////////////////////////
//:: Name      Baleful Utterance
//:: FileName  inv_balefulutter.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

You speak a single word of the Dark Speech. This
destroys any one nonmagical object, though the
holder of an object can make a will save to prevent
it. If an object being worn or carried is destroyed
in this manner, the holder must make a fortitude
save or be dazed for one round and deafened for one
hour.

*/
//::///////////////////////////////////////////////

//#include "prc_inc_spells"
//#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nDC = GetInvocationSaveDC(oTarget, OBJECT_SELF, INVOKE_BALEFUL_UTTERANCE);
	
	if (GetHasFeat(FEAT_ABFOC_BALEFUL_UTTERANCE, OBJECT_SELF)) nDC += 2;
		
    effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);

    if(GetIsObjectValid(oTarget))
    {		
/*		if((nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE ) && !GetPlotFlag(oTarget))
        {
            effect eDamage = EffectDamage(9999, DAMAGE_TYPE_MAGICAL);
            effect eLink = EffectLinkEffects(eDamage, eVis);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        } */
		int nType = GetObjectType(oTarget);

		// Exclude all plot objects
		if (GetPlotFlag(oTarget))
			return;

		// Fire on all doors and placeables
		if (nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)
		{
			effect eDamage = EffectDamage(9999, DAMAGE_TYPE_MAGICAL);
			effect eLink = EffectLinkEffects(eDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
		// Fire only on triggers that are trapped
		else if (nType == OBJECT_TYPE_TRIGGER && GetIsTrapped(oTarget))
		{
			effect eDamage = EffectDamage(9999, DAMAGE_TYPE_MAGICAL);
			effect eLink = EffectLinkEffects(eDamage, eVis);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}	
        else if(nType == OBJECT_TYPE_CREATURE)
        {
            PRCSignalSpellEvent(oTarget, TRUE, INVOKE_BALEFUL_UTTERANCE, OBJECT_SELF);

            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                int i;
                object oItem;
                for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
                {
                    if(i != INVENTORY_SLOT_CARMOUR && i != INVENTORY_SLOT_CWEAPON_B &&
                       i != INVENTORY_SLOT_CWEAPON_L && i != INVENTORY_SLOT_CWEAPON_R)
                    {
                        oItem = GetItemInSlot(i, oTarget);
                        if(DEBUG) DoDebug("Baleful Utterance: Checking Item Slot " + IntToString(i) + " which has item " + DebugObject2Str(oItem));
                        if(GetIsObjectValid(oItem) && !GetIsItemPropertyValid(GetFirstItemProperty(oItem)))
                        {
                            DestroyObject(oItem);
                            i = NUM_INVENTORY_SLOTS;
                            effect eDaze = EffectDazed();
                            effect eDeaf = EffectDeaf();
                            effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
                            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC) && PRCGetIsAliveCreature(oTarget))
                            {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(1), TRUE, -1, nCasterLvl);
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, TurnsToSeconds(1), TRUE, -1, nCasterLvl);
                            }
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }
                    }
                }
            }
        }
    }
}