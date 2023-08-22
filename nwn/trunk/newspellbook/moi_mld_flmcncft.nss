/*
3/1/20 by Stratovarius

Flame Cincture Waist Bind

Energy attacks are not simply absorbed and dispersed, but instead the energy is bound within the belt, eagerly awaiting release.

You can release a blast of fire from your flame cincture equal 1d6 plus 1d6 per point of essentia invested in the meld. A successful Reflex save reduces the damage by half.
*/

#include "moi_inc_moifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_FLAME_CINCTURE);   
	int nDice = 1 + nEssentia;
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_FLAME_CINCTURE);	
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_FLAME_CINCTURE);
	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_FLAME_CINCTURE);
		
	//Exclude the caster from the damage effects
	if (oTarget != oMeldshaper)
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oMeldshaper))
	    {
	       	if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
	       	{
	            int nDamage = d6(nDice);

	            //Adjust damage based on Reflex Save, Evasion and Improved Evasion
	            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
	            if(nDamage > 0)
	            {
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE), oTarget);
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);
	            }
	        }
	    }
	}
    
}