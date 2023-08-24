#include "prc_inc_spells"
#include "x0_i0_modes"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    DelayCommand(0.2, SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE));
    DelayCommand(0.21, UseStealthMode());
    DelayCommand(0.2, ActionUseSkill(SKILL_HIDE, oPC));
    DelayCommand(0.2, ActionUseSkill(SKILL_MOVE_SILENTLY, oPC));

    //AddItemProperty(DURATION_TYPE_TEMPORARY,PRCItemPropertyBonusFeat(31),oSkin,3.0f);
    AddSkinFeat(FEAT_HIDE_IN_PLAIN_SIGHT, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT, oSkin, oPC, 3.0f);
    SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE);
}