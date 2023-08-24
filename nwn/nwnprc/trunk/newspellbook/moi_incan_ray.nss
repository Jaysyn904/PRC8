/*
3/1/21 by Stratovarius

Incandescent Ray (Su): Beginning at 5th level, you can channel incarnum into a ray of pure, brilliant soul energy at will. Using this ability is a standard action; you
must make a successful ranged touch attack to hit your target. The incandescent ray has a range of 60 feet and deals 1d8 points of damage per point of essentia invested
in this ability
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_RAY);
    effect eLink;

    if (nEssentia) 
    {
    	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    	effect eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);
    
    	int iAttackRoll = 0;

    	if(!GetIsReactionTypeFriendly(oTarget))
    	{
    	    //Fire cast spell at event for the specified target
    	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        
    	    iAttackRoll = PRCDoRangedTouchAttack(oTarget);
    	    if(iAttackRoll > 0)
    	    {
                 // perform ranged touch attack and apply sneak attack if any exists
                 ApplyTouchAttackDamage(oMeldshaper, oTarget, iAttackRoll, d8(nEssentia), DAMAGE_TYPE_POSITIVE);
    
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
             SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);    
        }
    }
}