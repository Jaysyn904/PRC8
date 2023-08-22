//::///////////////////////////////////////////////
//:: Psycarnum Blade spellscript
//:: moi_ft_psyblade
//:://////////////////////////////////////////////
/*
    You can expend your psionic focus when making an attack 
    with your mind blade to gain an insight bonus on the 
    damage roll equal to 1d6 per point of invested essentia. 
    You must decide whether or not to use this feat prior to 
    making the attack roll. If your attack misses, you still 
    expend your psionic focus.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 20.01.2020
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_soulkn"
#include "psi_inc_psifunc"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;

    // Make sure they are wielding a mindblade
    if(!GetIsMindblade(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper)))
    {
        SendMessageToPCByStrRef(oMeldshaper, 16824509);
        return;
    }
    if(!UsePsionicFocus(oMeldshaper))
    {
        SendMessageToPC(oMeldshaper, "You must be psionically focused to use this feat");
        return;
    }
    
    int nDamage = d6(GetEssentiaInvestedFeat(oMeldshaper, FEAT_PSYCARNUM_BLADE));

    PerformAttackRound(oTarget, oMeldshaper, eDummy, 0.0, 0, nDamage, DAMAGE_TYPE_PIERCING, FALSE, "Psycarnum Blade Hit", "Psycarnum Blade Miss");
}