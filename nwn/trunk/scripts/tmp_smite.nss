/**
 * @file
 * Spellscript for a range of template Abilities.
 */
//constants 16300 - 17300
const int CELESTIAL_ABI_SMITE_EVIL = 16301;
const int FIENDISH_ABI_SMITE_GOOD = 16302;
const int HALF_CELESTIAL_ABI_SMITE_EVIL = 16303;
const int HALF_FIENDISH_ABI_SMITE_GOOD = 16324;

#include "prc_inc_smite"
#include "prc_inc_template"

//Check for remining SLA uses
int CheckUses(int nSpellID, int nUses)
{
    int nTest = GetLocalInt(OBJECT_SELF, "TemplateSLA_"+IntToString(nSpellID));
    if(nUses == 0) //unlimited uses per day
        return TRUE;
    else if(nTest < nUses)
    {
        nTest++;
        SetLocalInt(OBJECT_SELF, "TemplateSLA_"+IntToString(nSpellID), nTest);
        return TRUE;
    }
    else
    {
        FloatingTextStringOnCreature("You have already used this ability today.", OBJECT_SELF);
        return FALSE;
    }
}

void main()
{
    int nSpellID = GetSpellId();
    int nUses = 1;

    switch(nSpellID)
    {
        case CELESTIAL_ABI_SMITE_EVIL:
        {
            if(CheckUses(nSpellID, nUses)) DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_EVIL_TEMPLATE_CELESTIAL);
            break;
        }
        case FIENDISH_ABI_SMITE_GOOD:
        {
            if(CheckUses(nSpellID, nUses)) DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_GOOD_TEMPLATE_FIENDISH);
            break;
        }
        case HALF_CELESTIAL_ABI_SMITE_EVIL:
        {
            if(CheckUses(nSpellID, nUses)) DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_EVIL_TEMPLATE_HALF_CELESTIAL);
            break;
        }
        case HALF_FIENDISH_ABI_SMITE_GOOD:
        {
            if(CheckUses(nSpellID, nUses)) DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_GOOD_TEMPLATE_HALF_FIEND);
            break;
        }
    }
}
