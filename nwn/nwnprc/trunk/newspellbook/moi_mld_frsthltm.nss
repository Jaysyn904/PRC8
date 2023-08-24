/*
3/1/20 by Stratovarius

Frost Helm Totem Bind

Your frost helm fuses to your head and seems to spread downward, changing the appearance of your upper face to resemble the head of a frost worm. 
Your eyes meld into the helm’s strange nodule, your cheeks twist into lumpy protrusions, and the skin of your face grows thick and blue-white.

As a standard action, you can produce a trilling sound that stuns opponents within 20 feet. You can target one creature plus one additional creature 
per point of essentia you invest in your frost helm. Targets must succeed on a Will save or be stunned for 1d4 rounds.  
*/

#include "moi_inc_moifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_FROST_HELM)+1; 
    int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_FROST_HELM);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_FROST_HELM);
    float fDist = FeetToMeters(20.0);
    location lTarget = GetLocation(oMeldshaper);
    int nCount;
    
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget) && nCount != nEssentia)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper))
        {
	       	if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
	       	{
				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4()));
	       	}
            nCount++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }    
}