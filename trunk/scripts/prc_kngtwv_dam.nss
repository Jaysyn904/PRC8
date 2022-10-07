#include "prc_inc_burn"
#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    int nBurn = BurnSpell(oPC);

    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }
    
    object oTarget = PRCGetSpellTargetObject();
    
    int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        nBurn = PRCGetReflexAdjustedDamage(d6(nBurn), oTarget, 20, SAVING_THROW_TYPE_SPELL, oPC);
        ApplyTouchAttackDamage(oPC, oTarget, iAttackRoll, nBurn, DAMAGE_TYPE_MAGICAL, DAMAGE_TYPE_FIRE);
    }    
}