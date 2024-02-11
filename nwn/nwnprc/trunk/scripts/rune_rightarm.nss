#include "inc_newspellbook"
#include "prc_inc_core"
#include "inc_dynconv"

void main()
{
    object oPC = OBJECT_SELF;
    string sVar = "Runescar_Arm_Right";
    int nSpellID = GetPersistantLocalInt(oPC, sVar) - 1;
    if(nSpellID > -1)
    {
        int nLevel = GetPersistantLocalInt(oPC, sVar+"_level");
        DeletePersistantLocalInt(oPC, sVar);
        DeletePersistantLocalInt(oPC, sVar+"_level");

        // Special check for subradial spells
        if(StringToInt(Get2DACache("spells", "SubRadSpell1", nSpellID)))
        {
            SetLocalInt(oPC, "DomainOrigSpell", nSpellID);
            SetLocalInt(oPC, "DomainCastClass", CLASS_TYPE_RUNESCARRED);
            SetLocalInt(oPC, "RunscarredLevel", nLevel);
            StartDynamicConversation("prc_domain_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
        }
        else
        {
            int nSpellLevel = GetLocalInt(oPC, "Runescar_spell_level_"+IntToString(nSpellID));
            int nDC = 10 + nSpellLevel + GetAbilityModifier(ABILITY_WISDOM, oPC);
            ActionCastSpell(nSpellID, nLevel, nDC, 0, METAMAGIC_NONE, CLASS_TYPE_RUNESCARRED);
        }
    }
    else
        FloatingTextStringOnCreature("You dont have a Runescar there", oPC);
}