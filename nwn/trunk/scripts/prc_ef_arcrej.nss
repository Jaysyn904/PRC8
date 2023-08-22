#include "prc_sp_func"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetLocalInt(oPC, "EF_SPELL_CURRENT");
    string sArray = GetLocalString(oPC, "EF_SPELL_CURRENT");

    int nUses = sArray == "" ? GetHasSpell(nSpellID, oPC) :
                persistant_array_get_int(oPC, sArray, nSpellID);

    if(!nUses)
    {
        FloatingTextStringOnCreature("You have no more uses of the chosen spell", oPC, FALSE);
        return;
    }

    // expend spell use
    if(sArray == "")
    {
        DecrementRemainingSpellUses(oPC, nSpellID);
    }
    else
    {
        nUses--;
        persistant_array_set_int(oPC, sArray, nSpellID, nUses);
    }

    int nLevel = GetLocalInt(oPC, "EF_SPELL_CURRENT_LVL");
    effect eHeal = EffectHeal(nLevel);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
}