//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Command
//:: prc_doa_command.nss
//::///////////////////////////////////////////////
/*
    Controls the casting of the Command and Greater Command spells for the DoA
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void main()
{
    object oPC = OBJECT_SELF;
    int nSpellId = PRCGetSpellId();
    if(DEBUG) DoDebug("prc_doa_command: SpellId: " + IntToString(nSpellId));
    // Put each one into the appropriate spot
    if (nSpellId == SPELL_DOA_COMMAND_APPROACH        ) ActionCastSpell(SPELL_COMMAND_APPROACH        );
    if (nSpellId == SPELL_DOA_COMMAND_DROP            ) ActionCastSpell(SPELL_COMMAND_DROP            );
    if (nSpellId == SPELL_DOA_COMMAND_FALL            ) ActionCastSpell(SPELL_COMMAND_FALL            );
    if (nSpellId == SPELL_DOA_COMMAND_FLEE            ) ActionCastSpell(SPELL_COMMAND_FLEE            );
    if (nSpellId == SPELL_DOA_COMMAND_HALT            ) ActionCastSpell(SPELL_COMMAND_HALT            );
    if (nSpellId == SPELL_DOA_GREATER_COMMAND_APPROACH) ActionCastSpell(SPELL_GREATER_COMMAND_APPROACH);
    if (nSpellId == SPELL_DOA_GREATER_COMMAND_DROP    ) ActionCastSpell(SPELL_GREATER_COMMAND_DROP    );
    if (nSpellId == SPELL_DOA_GREATER_COMMAND_FALL    ) ActionCastSpell(SPELL_GREATER_COMMAND_FALL    );
    if (nSpellId == SPELL_DOA_GREATER_COMMAND_FLEE    ) ActionCastSpell(SPELL_GREATER_COMMAND_FLEE    );
    if (nSpellId == SPELL_DOA_GREATER_COMMAND_HALT    ) ActionCastSpell(SPELL_GREATER_COMMAND_HALT    );
}