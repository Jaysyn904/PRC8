/*
7/1/20 by Stratovarius

Mage Spectacles Brow Bind

Instead of spectacles perched on your nose, your mage’s spectacles manifest as a third eye embedded in your forehead, its iris a rich azure. Through this eye, magical inscriptions open their secrets.

You can cast read magic at will. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    ActionCastSpell(SPELL_READ_MAGIC, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MAGES_SPECTACLES), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
}