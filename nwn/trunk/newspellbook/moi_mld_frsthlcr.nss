/*
3/1/20 by Stratovarius

Frost Helm Crown Bind

Your frost helm fuses to the top of your head, actually opening a breathing channel in the strange nodule at the helm’s crown.

As a standard action, you can project a ray of cold energy from your forehead, reminiscent of a frost worm’s breath weapon. 
You must make a ranged touch attack to hit a creature with this ray. If you hit, the ray deals 1d6 points of cold damage 
plus an additional 1d6 points for every point of essentia you invest in your frost helm. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_FROST_HELM);   
	int nDice = 1 + nEssentia;
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_FROST_HELM);
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_FROST_HELM);
		
	//Exclude the caster from the damage effects
	if (oTarget != oMeldshaper)
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oMeldshaper))
	    {
	       	if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
	       	{
    			int nAttack = PRCDoRangedTouchAttack(oTarget);
    			if (nAttack > 0)
    			{
		            int nDamage = d6(nDice);
		            ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_COLD);
		            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_L), oTarget);
		        }
	        }
	    }
	}
    
}