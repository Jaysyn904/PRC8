/*
30/12/19 by Stratovarius

Armguards of Disruption Arms Bind

Incarnum flows from the bracers to envelop you and then fades into invisibility. A corona of blue-white energy erupts when an undead creature attacks you, blocking its blows and suppressing its powers.

You gain an insight bonus to your AC and on your saving throws equal to the number of points of essentia invested in your armguards of disruption. These bonuses apply only against attacks made by undead creatures. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_ARMGUARDS_OF_DISRUPTION); 
    // We know it's bound, now to check which class bound it 
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_ARMGUARDS_OF_DISRUPTION);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_ARMGUARDS_OF_DISRUPTION);
    
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0 && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
            {                
                int nDamage = d6(1+nEssentia);
                ApplyTouchAttackDamage(oMeldshaper, oTarget, nAttack, nDamage, DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_HOLY), oTarget);
            }    
        }
    }    

}