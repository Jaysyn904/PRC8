/*
    prc_coc_wrath

    Adds bonuses for 1 round

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 27, 2007

*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
        SendMessageToPC(oPC, "Cannot use this feat if you are evil.");
        return;
    }
    int nLevel = (GetLevelByClass(CLASS_TYPE_COC, oPC));
    effect eLink = EffectLinkEffects(EffectAttackIncrease(2, ATTACK_BONUS_ONHAND), EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_DIVINE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);

}