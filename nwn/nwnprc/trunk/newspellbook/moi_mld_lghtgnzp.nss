/*
6/1/20 by Stratovarius

Lightning Gauntlets

Descriptors: Electricity  
Classes: Incarnate  
Chakra: Hands
Saving Throw: None

Incarnum forms into a pair of metallic gloves that hover around your hands and any other gloves or gauntlets you wear. Blue arcs of electricity crackle between the fingers and spark between the gloves when you bring your hands close to each other.

While wearing lightning gauntlets, you can deal 1d6 points of electricity damage with a successful melee touch attack (a standard action). 

Essentia: Every point of essentia you invest in your lightning gauntlets increases the damage dealt by 1d6 points.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_LIGHTNING_GAUNTLETS); 
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_LIGHTNING_GAUNTLETS);
    
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
            {                
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oTarget);	
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nEssentia+1), DAMAGE_TYPE_ELECTRICAL), oTarget);
            }    
        }
    }    

}