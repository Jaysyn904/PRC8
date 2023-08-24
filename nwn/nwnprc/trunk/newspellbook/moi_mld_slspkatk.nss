/*
23/1/21 by Stratovarius

A soulspark attacks by focusing soul energy on its target as a ranged attack. This doesn’t provoke attacks of opportunity.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oSoulspark  = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
   	//SendMessageToPC(GetFirstPC(),"moi_mld_slspkatk: we have target "+GetName(oTarget));    

   	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
   	effect eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);
    
   	int iAttackRoll, nDam, nAtk;
   	
   	string sType = GetResRef(oSoulspark);
   	if (sType == "moi_slspk_least") nDam = d4()+1;
   	else if (sType == "moi_slspk_lesser") nDam = d6()+2;
   	else if (sType == "moi_slspk_medium") 
   	{
   		nDam = d8()+3;
   		nAtk = 1;
   	}	
   	else if (sType == "moi_slspk_greatr") 
   	{
   		nDam = d12()+5;  
   		nAtk = 1;
   	}   	
   	
   	object oMeldshaper = GetMaster(OBJECT_SELF);
   	if (!GetLocalInt(oMeldshaper, "SoulsparkEssentiaChoice")) 
   	{
   		nDam += GetEssentiaInvested(oMeldshaper, MELD_SOULSPARK_FAMILIAR);
   		nAtk += GetEssentiaInvested(oMeldshaper, MELD_SOULSPARK_FAMILIAR);
   	}

   	if(!GetIsReactionTypeFriendly(oTarget))
   	{
   	    //Fire cast spell at event for the specified target
   	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        
   	    iAttackRoll = PRCDoRangedTouchAttack(oTarget, FALSE, oSoulspark, nAtk);
   	    if(iAttackRoll > 0)
   	    {
            // perform ranged touch attack and apply sneak attack if any exists
	        ApplyTouchAttackDamage(oSoulspark, oTarget, iAttackRoll, nDam, DAMAGE_TYPE_POSITIVE);
    
            //Apply the VFX impact and damage effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);    
    }
}