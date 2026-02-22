/*
1/1/20 by Stratovarius

Dissolving Spittle

Descriptors: Acid 
Classes: Incarnate 
Chakra: Throat
Saving Throw: None

Incarnum forms a metallic blue-green torc around your neck. The ends of the torc resemble black or copper dragons facing each other in front of your throat. A constant bitter taste floods your mouth, but it seems to make the flavor of certain foods more enjoyable — particularly well-cooked meat.

As a standard action, you can spit a glob of acid at a target within 30 feet. This requires a ranged touch attack to hit and deals 1d6 points of acid damage. Using dissolving spittle provokes attacks of opportunity. 

Essentia: Every point of essentia you invest in your dissolving spittle increases the damage dealt by 1d6 points. 

Chakra Bind (Throat) 

Instead of a torc around your neck, the writhing shape of a twoheaded dragon arcs around your throat in blue-green scales. Tendrils of midnight blue extend up your neck and down into your shoulders like diseased veins.

When you use your ability to spit acid at an opponent, you also roll again for damage 1 round later. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 19:24:41
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void DissolvingSpittleDelay(object oMeldshaper, object oTarget, int nAttack, int nDamage, int nDamageType)
{
	ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_ACID);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oTarget); 
}

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_DISSOLVING_SPITTLE;  
  
    // Check if bound to Throat chakra (regular or double)  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    object oTarget = PRCGetSpellTargetObject();   
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DISSOLVING_SPITTLE);     
    int nDice = 1 + nEssentia;  
    effect eArrow = EffectVisualEffect(VFX_IMP_MIRV_DN_LAWNGREEN);  
      
    int nAttack = PRCDoRangedTouchAttack(oTarget);  
    if (nAttack > 0)  
    {  
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper))  
        {  
            int nDamage = d6(nDice);  
            ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_ACID);  
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oTarget);  
              
            if (nBoundToThroat)   
            {  
                nDamage = d6(nDice);  
                DelayCommand(6.0, DissolvingSpittleDelay(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_ACID));         
            }  
        }  
    }  
}

/* void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DISSOLVING_SPITTLE);   
    int nDice = 1 + nEssentia;
    effect eArrow = EffectVisualEffect(VFX_IMP_MIRV_DN_LAWNGREEN);
    
    int nAttack = PRCDoRangedTouchAttack(oTarget);
    if (nAttack > 0)
    {
        // Only creatures, and PvP check.
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper))
        {
            int nDamage = d6(nDice);
            ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_ACID);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_L), oTarget);
            
            if (GetIsMeldBound(oMeldshaper, MELD_DISSOLVING_SPITTLE) == CHAKRA_THROAT) 
            {
				nDamage = d6(nDice);
            	DelayCommand(6.0, DissolvingSpittleDelay(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_ACID));       
            }
        }
    }
} */