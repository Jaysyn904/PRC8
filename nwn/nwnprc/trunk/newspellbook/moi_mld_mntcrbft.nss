/*
7/1/20 by Stratovarius

Manticore Belt Totem Bind

A long, thick tail emerges from the back of your manticore belt, writhing and lashing at your command. At its tip is a cluster of spikes. Like a manticore, you can propel those spikes at your foes.

As a standard action, you can snap your tail to loose a volley of spikes equal to the number of points of essentia you invest in your manticore belt. Make a ranged attack roll for each spike using your full base attack bonus. A successful hit deals 1d6 points of damage plus one-half your Strength modifier. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 14:50:10
//::
//:: Double Totem bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_combat"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_MANTICORE_BELT;  
  
    // Check if bound to Totem chakra (regular or double)  
    int nBoundToTotem = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
        nBoundToTotem = TRUE;  
  
    if (!nBoundToTotem) return; // Exit if not bound to Totem  
  
    object oTarget = PRCGetSpellTargetObject();  
    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper);  
    int nBonus = GetAbilityModifier(ABILITY_DEXTERITY, oMeldshaper) - nStr; // It's a ranged attack  
    int nTotal = GetEssentiaInvested(oMeldshaper, MELD_MANTICORE_BELT);  
    int i;  
    for (i = 0; i < nTotal; i++)  
    {  
        int nAttack = GetAttackRoll(oTarget, oMeldshaper, OBJECT_INVALID, 0, nBonus);  
        if (nAttack)  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage((d6() + nStr / 2) * nAttack, DAMAGE_TYPE_PIERCING), oTarget);  
    }  
}

/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper);
    int nBonus = GetAbilityModifier(ABILITY_DEXTERITY, oMeldshaper) - nStr; // It's a ranged attack
    int nTotal = GetEssentiaInvested(oMeldshaper, MELD_MANTICORE_BELT);
    int i;
    for(i=0;i<nTotal;i++)
    {
        int nAttack = GetAttackRoll(oTarget, oMeldshaper, OBJECT_INVALID, 0, nBonus);
        if (nAttack)
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage((d6()+nStr/2)*nAttack, DAMAGE_TYPE_PIERCING), oTarget);
    }
} */