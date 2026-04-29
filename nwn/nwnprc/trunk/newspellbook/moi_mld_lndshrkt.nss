/*
6/1/20 by Stratovarius

Landshark Boots Chakra Bind (Totem) 

Your hands as well as your feet gain the heavy claws of a bulette, including one prominent central claw and two smaller claws on the sides. 
These massive claws emerge from the backs of your hands so you can bring them to bear while making a fist.

You can use the claws on your hands as natural weapons that deal 1d6 points of damage. You cannot use a shield while these claws are in place. 
For every point of essentia you invest in your landshark boots, you gain a +1 enhancement bonus on attack rolls and damage rolls with these claws. 
If you achieve a Jump check result good enough to jump over an opponent, you can attack that opponent with all four claws as a standard action. 
You cannot make any other attacks in the same round, whether from natural weapons or manufactured weapons. 
*/

#include "moi_inc_moifunc"
#include "prc_inc_combat" 

void SharkAttack(object oTarget, object oMeldshaper)
{
	effect eNone;
	PerformAttack(oTarget, oMeldshaper, eNone, 0.0, 0, 0, 0, "Landshark Attack Hit", "Landshark Attack Miss");
	PerformAttack(oTarget, oMeldshaper, eNone, 0.0, 0, 0, 0, "Landshark Attack Hit", "Landshark Attack Miss");
	PerformAttack(oTarget, oMeldshaper, eNone, 0.0, 0, 0, 0, "Landshark Attack Hit", "Landshark Attack Miss");
	PerformAttack(oTarget, oMeldshaper, eNone, 0.0, 0, 0, 0, "Landshark Attack Hit", "Landshark Attack Miss");
}

void main()
{
	object oMeldshaper    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    int iJumpRoll = d20() + GetSkillRank(SKILL_JUMP, oMeldshaper) + GetAbilityModifier(ABILITY_STRENGTH, oMeldshaper);
    int nDC = 12;
    int nSizePenalty;
    int nSize = PRCGetCreatureSize(oTarget);
    effect eNone;
    
    if(nSize == CREATURE_SIZE_MEDIUM) nSizePenalty = 5;
    if(nSize == CREATURE_SIZE_LARGE) nSizePenalty = 10;
    if(nSize == CREATURE_SIZE_HUGE) nSizePenalty = 15;
    if(nSize == CREATURE_SIZE_GARGANTUAN) nSizePenalty = 20;
    if(nSize == CREATURE_SIZE_COLOSSAL) nSizePenalty = 25;
    
    nDC += nSizePenalty;
    // Claws only, and need to make the jump                
    if(iJumpRoll >= nDC && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper)))
    {
        AssignCommand(oMeldshaper, ClearAllActions(TRUE));
        effect eJump = EffectDisappearAppear(GetLocation(oMeldshaper));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oMeldshaper, 2.0);
            
        DelayCommand(0.0, SharkAttack(oTarget, oMeldshaper));
    }
    
    else
    {
        FloatingTextStringOnCreature("Jump check failed.", oMeldshaper);
        DelayCommand(0.0, PerformAttack(oTarget, oMeldshaper, eNone, 0.0, 0, 0, 0, "Hit", "Miss"));
    }
}