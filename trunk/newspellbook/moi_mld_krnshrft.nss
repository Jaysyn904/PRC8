/*
5/1/20 by Stratovarius

Krenshar Mask Totem Bind

Your face becomes one with your krenshar mask, so all its muscles move to match your expressions. A ridge of skin around the edge of the mask quivers when 
you grow angry or enter combat, and a growling edge creeps into your voice.

You gain the ability to produce a loud screech (as a standard action) similar to that of a krenshar. In combination with the frightening aspect of the mask, 
this shriek causes one creature within 30 feet of you to become frightened for 1 round if it fails a Will save. This is a sonic, mind-affecting fear effect. 
*/

#include "moi_inc_moifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_KRENSHAR_MASK);   
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_KRENSHAR_MASK);
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_KRENSHAR_MASK);
		
	//Exclude the caster from the effects
	if (oTarget != oMeldshaper)
	{
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oMeldshaper))
	    {
	       	if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
	       	{
				if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oTarget, 6.0);
	        }
	    }
	}
    
}