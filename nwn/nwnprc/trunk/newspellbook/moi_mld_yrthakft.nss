/*
13/1/20 by Stratovarius

Yrthak Mask

Chakra Bind (Totem)

Your yrthak mask becomes your actual face, and your jaws lengthen into the crocodilian maw of a yrthak. The mask is too awkward to allow you to make bite attacks, but you can focus sonic energy through the hornlike protrusion on the front of the mask, using it to stab your foes with rays of pure sound.

Once every 2 rounds, you can focus sonic energy into a ray up to 60 feet long. This is a ranged touch attack that deals 1d6 points of sonic damage to a single target for every point of invested essentia.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_YRTHAK_MASK);  

	if (!GetLocalInt(oMeldshaper, "YrthakMaskTimer"))
	{
    	int nAttack = PRCDoRangedTouchAttack(oTarget);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_ODD, oMeldshaper, BODY_NODE_CHEST, !nAttack), oTarget, 1.0f);
    	if (nAttack > 0)
    	{
    	    // Only creatures, and PvP check.
    	    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper))
    	    {
    	        int nDamage = d6(nEssentia);
    	        ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_SONIC);
    	        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget);
    	    }
    	}
    	DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "YrthakMaskTimer"));
    	DelayCommand(6.0, FloatingTextStringOnCreature("You may use your Yrthak Mask Totem Bind again.", oMeldshaper, FALSE));
    }	
}