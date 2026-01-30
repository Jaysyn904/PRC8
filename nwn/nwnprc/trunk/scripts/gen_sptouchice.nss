//:://////////////////////////////////////////////
//:	gen_sptouchice.nss
/*
	Touch of Golden Ice
	(Book of Exalted Deeds, p. 47)

	[Exalted]

	Your touch is poisonous to evil creatures.
	Prerequisite: CON 13
	
	Benefit: Any evil creature you touch with your 
	bare hand, fist, or natural weapon is ravaged 
	by golden ice (see Ravages and Afflictions in 
	Chapter 3: Exalted Equipment for effects).
	
	This handles the activated feat.

*/
//:
//:://////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Created on: 2026-01-30 08:21:32
//::
//:://////////////////////////////////////////////
#include "prc_alterations"  
#include "prc_inc_spells"  
#include "inc_poison"  
#include "prc_inc_sp_tch"  
  
void main()  
{  
    object oTarget = PRCGetSpellTargetObject();  
      
    // Perform melee touch attack  
    int nTouchAttack = PRCDoMeleeTouchAttack(oTarget);  
      
    // Only apply ravage if the touch attack hits  
    if(nTouchAttack > 0)  
    {  
        effect ePoison = EffectPoison(POISON_RAVAGE_GOLDEN_ICE);  
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);  
    }  
}


/* void main()
{
  object oTarget = PRCGetSpellTargetObject();
  effect ePoison = EffectPoison(POISON_RAVAGE_GOLDEN_ICE);

  SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);
} */