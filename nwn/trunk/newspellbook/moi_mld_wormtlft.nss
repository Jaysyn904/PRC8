/*
Wormtail belt

Chakra Bind (Totem)

A thick, purple-scaled tail emerges from the back of your wormtail belt. It is long enough that you can reach it around you to attack your foes with the stinger at its end, which drips with poison.

You can use your wormtail belt’s stinger to make natural attacks. You cannot use the stinger as a natural secondary weapon—
using the stinger is the only attack you can make in a given round. You use your full base attack bonus for the attack roll,
and the stinger deals 1d6 points of damage. In addition, the stinger delivers a weakening poison that deals initial damage 
of 1d4 Strength (no secondary damage). A successful Fortitude save negates the poison damage. Every point of essentia you 
invest in your wormtail belt gives you a +1 enhancement bonus on your attack rolls with the stinger, as well as 
increasing the poison’s save DC
*/
#include "prc_inc_combmove"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_WORMTAIL_BELT);
    int nDC            = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_WORMTAIL_BELT) + nEssentia;
    
    int nAttack = GetAttackRoll(oTarget, oMeldshaper, OBJECT_INVALID, 0, nEssentia);
    if(nAttack)
    {		
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nAttack) + ((GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper)/2)*nAttack), DAMAGE_TYPE_PIERCING), oTarget);
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
        {
			ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d4(), DURATION_TYPE_TEMPORARY, TRUE, -1.0);
        }
    }   
}