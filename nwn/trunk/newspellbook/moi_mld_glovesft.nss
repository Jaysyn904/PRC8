/*
4/1/20 by Stratovarius

Gloves of the Poisoned Hand

Descriptors: Evil
Classes: Soulborn
Chakra: Hands
Saving Throw: See text

Slick green gloves slide over your hands. They appear moist but are dry to the touch.

Once per round, you can attempt to inflict a terrible, mind-wracking poison on a foe with a melee touch attack. The poison deals 1 point of Wisdom damage immediately
and another 1 point of Wisdom damage 1 minute later. Each instance of damage can be negated by a Fortitude save. 
No creature can be affected by the gloves more than once in a 24-hour period. 

Essentia: Every point of essentia you invest in your gloves increases the Wisdom damage dealt (both primary and secondary damage) by 1 point. 

Chakra Bind (Hands) 

The gloves merge with your hands, giving your hands a green cast. Your fingertips drip with viscous slime.

When gloves of the poisoned soul are bound to your hands chakra, the poison also deals Strength damage equal to the amount of Wisdom damage dealt (one save resists both effects).
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_GLOVES_OF_THE_POISONED_SOUL); 
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_GLOVES_OF_THE_POISONED_SOUL);
	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_GLOVES_OF_THE_POISONED_SOUL);
	int nDamage = 1 + nEssentia;
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_GLOVES_OF_THE_POISONED_SOUL);
    
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
            {                
            	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            	{
					ApplyAbilityDamage(oTarget, ABILITY_WISDOM, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
                	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
                	DelayCommand(60.0, ApplyAbilityDamage(oTarget, ABILITY_WISDOM, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0));
                	DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget));
                	if (GetIsMeldBound(oMeldshaper, MELD_GLOVES_OF_THE_POISONED_SOUL) == CHAKRA_HANDS)
                	{
						ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
                		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISENTIGRATION_SMP), oTarget);
                		DelayCommand(60.0, ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0));
                		DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISENTIGRATION_SMP), oTarget));                	
                	}
                }	
            }    
        }
    }    

}