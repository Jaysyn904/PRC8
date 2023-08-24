// Written by Stratovarius
// Activates the Widen Spell ability of the War Wizard of Cormyr
// This is read in the PRC AoE function in prc_inc_spells, where it increases the area.

#include "prc_alterations"

void main()
{

    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_WAR_WIZARD_OF_CORMYR, oPC);
    float fWid = nLevel > 4 ? 2.0://x2 at 5 level
                  nLevel > 2 ? 1.5://x1.5 at level 3+
                  0.0;//else 0
    string nMes = "";

    if(GetLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER) == 0.0)
    {
        SetLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER, fWid);
        nMes = "*Widen Spell Activated*";
    }
    else
    {
        // Removes effects and gives you back the uses per day
        DeleteLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER);
        nMes = "*Widen Spell Deactivated*";
        IncrementRemainingFeatUses(oPC, FEAT_WWOC_WIDEN_SPELL);
    }

    if (DEBUG) DoDebug("Value for WarWizardOfCormyr_Widen: " + FloatToString(GetLocalFloat(oPC, PRC_SPELL_AREA_SIZE_MULTIPLIER)));
    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}