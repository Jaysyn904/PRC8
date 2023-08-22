#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
    int nBurn = BurnSpell(oPC);

    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }

    effect eLink = EffectVisualEffect(PSI_DUR_SHADOW_BODY);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
    SetLocalInt(oPC, "SacredStrike", nBurn);
    DelayCommand(0.1, ExecuteScript("prc_sneak_att", oPC));
    DelayCommand(6.0, DeleteLocalInt(oPC, "SacredStrike"));
    DelayCommand(6.1, ExecuteScript("prc_sneak_att", oPC));
}