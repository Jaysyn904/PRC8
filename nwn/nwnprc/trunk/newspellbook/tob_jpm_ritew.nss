#include "prc_alterations"
#include "tob_move_const"

void Lore(object oTarget, object oSkin, int nBonus)
{

   if(GetLocalInt(oSkin, "RiteWaking") == nBonus) return;

    SetCompositeBonus(oSkin, "RiteWaking", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void RiteWaking(object oTarget)
{
        effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
        eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_DEATH));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oTarget);
}

void main()
{
    //Declare main variables.
    int nID = GetSpellId();
    object oTarget = (nID == JPM_SPELL_RITE_WAKING_SELF) ? OBJECT_SELF : PRCGetSpellTargetObject();
    object oSkin = GetPCSkin(oTarget);
    
    Lore(oTarget, oSkin, 2);
    RiteWaking(oTarget);
}