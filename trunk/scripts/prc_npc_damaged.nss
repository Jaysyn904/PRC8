//::///////////////////////////////////////////////
//:: OnDamaged NPC eventscript
//:: prc_npc_damaged
//:://////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()
{
    object oPC = GetLastDamager();
    if(GetHasFeat(FEAT_SADISTIC_REWARD, oPC) && PRCGetIsAliveCreature(OBJECT_SELF))
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL)), oPC, 6.0);
    
    object oMeldshaper = GetLocalObject(OBJECT_SELF, "NecrocarnumShroud");
    if (GetIsObjectValid(oMeldshaper) && PRCGetIsAliveCreature(OBJECT_SELF))
    {
    	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_SHROUD);
    	float fDist = MetersToFeet(GetDistanceBetween(oMeldshaper, OBJECT_SELF));
    	float nCheck = 5.0 + nEssentia * 5.0;
    	if (nCheck >= fDist && GetHasSpellEffect(MELD_NECROCARNUM_SHROUD, oMeldshaper))
    	{
    		if(PRCGetIsAliveCreature(OBJECT_SELF))
    		    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_1), EffectAttackIncrease(1))), oMeldshaper, 6.0);    
    		else // Assuming the enemy is dead here
    			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_1), EffectAttackIncrease(1))), oMeldshaper, RoundsToSeconds(GetHitDice(OBJECT_SELF)));    
    	}		
    }		
        
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONDAMAGED);
}