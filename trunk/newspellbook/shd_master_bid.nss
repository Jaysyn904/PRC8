/*
   ----------------
   Master of Shadow Master's Bidding

   shd_master_bid.nss
   ----------------

   Applies a number of bonuses based on player choice
   
   27.02.19 by Stratovarius
*/

#include "shd_inc_shdfunc"
#include "prc_inc_assoc"

void main()
{
        // Set up some data
        object oShadow = OBJECT_SELF;
        
        if (GetLocalInt(oShadow, "MastersBidding"))
        {
            FloatingTextStringOnCreature("You may not bid your elemental yet", oShadow, FALSE);
            return;
        }    
        
        object oFam = GetAssociateNPC(ASSOCIATE_TYPE_FAMILIAR, oShadow, NPC_MS_ELEMENTAL);
        int nMaster = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHADOW);
        float fDur = 6.5; // Just to make sure everything takes effect 
        int nBid = PRCGetSpellId();
        effect eDur;
        
        if (nBid == MYST_BID_HEAL)
            eDur = EffectRegenerate(1, 6.0);
        else if (nBid == MYST_BID_ATTACK && nMaster >= 2)
        {
            eDur = EffectModifyAttacks(1);
        }  
        else if (nBid == MYST_BID_COLD && nMaster >= 4)
            eDur = EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_COLD);
        else if (nBid == MYST_BID_DR && nMaster >= 8)
        {
            eDur = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5);
            eDur = EffectLinkEffects(eDur, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5));
            eDur = EffectLinkEffects(eDur, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5));
        }  
        else if (nBid == MYST_BID_SPEED && nMaster >= 9)
        {
            eDur = EffectMovementSpeedIncrease(66);
        } 
        else
            FloatingTextStringOnCreature("You are too low level to use this Master's Bidding", oShadow, FALSE);
        
        eDur = EffectLinkEffects(eDur, EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDur), oFam, fDur, FALSE);
        
        if (nMaster >= 10)
        {
            SetLocalInt(oShadow, "MastersBidding", TRUE);
            FloatingTextStringOnCreature("You have bidden your elemental familiar", oShadow, FALSE);
            DelayCommand(6.0, DeleteLocalInt(oShadow, "MastersBidding"));
            DelayCommand(6.0, FloatingTextStringOnCreature("You may bid your elemental familiar", oShadow, FALSE));
        }    
}