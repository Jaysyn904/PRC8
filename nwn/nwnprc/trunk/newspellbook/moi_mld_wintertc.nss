/*
13/1/20 by Stratovarius

Winter Mask

Descriptors: Cold
Classes: Totemist
Chakra: Throat (totem)
Saving Throw: See text

You shape incarnum into a snow-white mask resembling the head of a wolf. A snarling muzzle filled with sharp teeth protrudes from the front of the mask, and eyes like blue ice crystals stare out in defiance.

You must make a successful melee touch attack. The target is fatigued unless it succeeds on a Fortitude save. 

Essentia: Your touch attack also deals 1d4 points of cold damage for every point of essentia you invest in your winter mask. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WINTER_MASK); 
	int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_WINTER_MASK);
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_WINTER_MASK);
    
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
            {                
            	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_COLD))
            	{
            		if (PRCGetIsAliveCreature(oTarget))
            		{
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oTarget, 60.0);
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
                	}
                	
                	if (nEssentia)
						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4(nEssentia*nAttack), DAMAGE_TYPE_COLD), oTarget);
                }	
            }    
        }
    }    

}