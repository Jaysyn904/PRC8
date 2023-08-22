//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dweomerthf"
/*   Purpose: Dweomer Thief - the target loses a spell from the highest level,
        which subsequently turns into a scroll in the caster's inventory.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
//#include "x2_inc_spellhook"
#include "prc_getbest_inc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DWEO_TH))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nTargetSpell;
        effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
        effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)))
            {
                 if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget)+5,
                    SAVING_THROW_TYPE_NONE))
                 {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVis, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVis2, oTarget);
                    nTargetSpell = GetBestAvailableSpell(oTarget);
                    if (nTargetSpell != 99999)
                    {
                        int nSpellIP = StringToInt(Get2DACache
                            ("des_crft_spells", // Name of the 2DA file.
                            "IPRP_SpellIndex",  // The column.
                            nTargetSpell));     // The row.
                        object oScroll = CreateItemOnObject("it_dweomerthief",
                            OBJECT_SELF);
                        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(nSpellIP,
                                IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE),
                                oScroll);
                        DecrementRemainingSpellUses(oTarget, nTargetSpell);
                    }
                 }
            }
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

