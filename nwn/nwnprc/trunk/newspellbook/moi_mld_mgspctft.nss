/*
7/1/20 by Stratovarius

Mage Spectacles Brow Bind

Instead of spectacles perched on your nose, your mage’s spectacles manifest as a third eye embedded in your forehead, its iris a rich azure. Through this eye, magical inscriptions open their secrets.

You can cast read magic at will. 
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 14:54:47
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_MAGES_SPECTACLES;  
  
    // Check if bound to Brow chakra (regular or double)  
    int nBoundToBrow = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_BROW)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_BROW)) == nMeldId)  
        nBoundToBrow = TRUE;  
  
    if (!nBoundToBrow) return; // Exit if not bound to Brow  
  
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));  
    ActionCastSpell(SPELL_READ_MAGIC, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MAGES_SPECTACLES), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);  
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA"));  
}

/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    ActionCastSpell(SPELL_READ_MAGIC, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_MAGES_SPECTACLES), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
} */