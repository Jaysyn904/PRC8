//:://////////////////////////////////////////////////
//:: X0_CH_HEN_REST
/*
  OnRest event handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////
#include "inc_newspellbook"

void main()
{
    object oSelf = OBJECT_SELF;
    // modifed by primogenitor
    // aribeth uses her blackguard spellbook
    if(GetTag(oSelf) == "H2_Aribeth")
    {
        //check spellbook has been setup
        if(!GetLocalInt(oSelf, "PRC_Aribeth_Spellbook"))
        {
            persistant_array_create(oSelf, "Spellbook1_31");
            persistant_array_create(oSelf, "Spellbook2_31");
            persistant_array_create(oSelf, "Spellbook3_31");
            persistant_array_create(oSelf, "Spellbook4_31");
            persistant_array_set_int(oSelf, "Spellbook1_31", 0, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_MAGIC_WEAPON));
            persistant_array_set_int(oSelf, "Spellbook1_31", 1, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 2, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 3, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 4, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 5, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 6, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));
            persistant_array_set_int(oSelf, "Spellbook1_31", 7, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DOOM));

            persistant_array_set_int(oSelf, "Spellbook2_31", 0, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_BULLS_STRENGTH));
            persistant_array_set_int(oSelf, "Spellbook2_31", 1, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DARKNESS));
            persistant_array_set_int(oSelf, "Spellbook2_31", 2, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_EAGLE_SPLEDOR));
            persistant_array_set_int(oSelf, "Spellbook2_31", 3, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_DARKNESS));
            persistant_array_set_int(oSelf, "Spellbook2_31", 4, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_MODERATE_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook2_31", 5, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_MODERATE_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook2_31", 6, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_MODERATE_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook2_31", 7, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_MODERATE_WOUNDS));

            persistant_array_set_int(oSelf, "Spellbook3_31", 0, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_PROTECTION_FROM_ELEMENTS));
            persistant_array_set_int(oSelf, "Spellbook3_31", 1, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_PROTECTION_FROM_ELEMENTS));
            persistant_array_set_int(oSelf, "Spellbook3_31", 2, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));
            persistant_array_set_int(oSelf, "Spellbook3_31", 3, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));
            persistant_array_set_int(oSelf, "Spellbook3_31", 4, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));
            persistant_array_set_int(oSelf, "Spellbook3_31", 5, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));
            persistant_array_set_int(oSelf, "Spellbook3_31", 6, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));
            persistant_array_set_int(oSelf, "Spellbook3_31", 7, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_CONTAGION));

            persistant_array_set_int(oSelf, "Spellbook4_31", 0, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_SUMMON_CREATURE_IV));
            persistant_array_set_int(oSelf, "Spellbook4_31", 1, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_CRITICAL_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook4_31", 2, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_SUMMON_CREATURE_IV));
            persistant_array_set_int(oSelf, "Spellbook4_31", 3, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_CRITICAL_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook4_31", 4, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_CRITICAL_WOUNDS));
            persistant_array_set_int(oSelf, "Spellbook4_31", 5, RealSpellToSpellbookID(CLASS_TYPE_BLACKGUARD, SPELL_INFLICT_CRITICAL_WOUNDS));
            SetLocalInt(oSelf, "PRC_Aribeth_Spellbook", TRUE);
        }
        CheckNewSpellbooks(oSelf);
    }
}