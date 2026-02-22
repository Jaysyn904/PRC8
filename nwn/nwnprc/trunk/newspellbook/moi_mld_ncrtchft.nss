/*
20/1/21 by Stratovarius

Necrocarnum Touch

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Arms
Saving Throw: See text

Jet black shadows wreathe your hands and forearms, coiling and twisting with a life of their own. These insubstantial coils of energy hint at evil and agony, seeming to draw light and hope out of the
surrounding area.

The coiling energy makes the movements of your hands and arms hard to follow. While you have necrocarnum touch shaped, you gain a +4 bonus on Pickpocket checks.

Essentia: Whenever you invest essentia in necrocarnum touch, you can make a melee touch attack as a standard action. This attack deals 1d8 points of damage for every point
of essentia that you invest in the soulmeld, but only on living creatures (Fortitude half).

Chakra Bind (Arms) 

While necrocarnum touch is bound to your arms chakra, you can fire a ray of pure necrocarnum as a standard action. This ray requires a ranged touch attack to hit and has a range of
30 feet. If it strikes a living creature, it deals 1d8 points of damage for every point of essentia that you invest in the soulmeld (Fortitude half).
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 14:32:51
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_NECROCARNUM_TOUCH;  
  
    // Check if bound to Arms chakra (regular or double)  
    int nBoundToArms = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_ARMS)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_ARMS)) == nMeldId)  
        nBoundToArms = TRUE;  
  
    if (!nBoundToArms) return; // Exit if not bound to Arms  
  
    object oTarget = PRCGetSpellTargetObject();   
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_TOUCH);     
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_TOUCH);  
    int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_TOUCH);       
    int nAttack;  
    int nRanged = FALSE;  
    if (GetSpellId() == 18955) // MELD_NECROCARNUM_TOUCH_ARMS  
    {  
        nRanged = TRUE;  
        nAttack = PRCDoRangedTouchAttack(oTarget);  
    }	  
    else  
        nAttack = PRCDoMeleeTouchAttack(oTarget);  
      
    if (nAttack > 0)  
    {  
        // Only living creatures, and PvP check.  
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper) && PRCGetIsAliveCreature(oTarget))  
        {  
            int nDamage = d8(nEssentia);  
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))  
            {  
                nDamage /= 2;  
                  
                if (GetHasMettle(oTarget, SAVING_THROW_FORT)) // Ignores partial effects  
                    nDamage = 0;  
            }              
            if(nDamage)  
            {  
                ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_NEGATIVE);  
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);  
            }	  
        }  
    }  
    if (nRanged)  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND), oTarget, 1.7, FALSE);  
}

/* void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_TOUCH);   
   	int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_TOUCH);
	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_TOUCH);     
    int nAttack;
    int nRanged = FALSE;
    if (GetSpellId() == 18955) // MELD_NECROCARNUM_TOUCH_ARMS
    {
    	nRanged = TRUE;
    	nAttack = PRCDoRangedTouchAttack(oTarget);
    }	
    else
    	nAttack = PRCDoMeleeTouchAttack(oTarget);
    
    if (nAttack > 0)
    {
        // Only living creatures, and PvP check.
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oMeldshaper) && PRCGetIsAliveCreature(oTarget))
        {
            int nDamage = d8(nEssentia);
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            {
                nDamage /= 2;
                
            	if (GetHasMettle(oTarget, SAVING_THROW_FORT)) // Ignores partial effects
            		nDamage = 0;
            }            
            if(nDamage)
            {
            	ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_NEGATIVE);
            	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
            }	
        }
    }
    if (nRanged)
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND), oTarget, 1.7, FALSE);
} */