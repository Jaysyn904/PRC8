/*
31/12/19 by Stratovarius

Blink Shirt Heart Bind

The appearance of your blink shirt changes little, except that now wherever it seems transparent, you do as well. Strange patches of incorporeality float over your entire body.

You can use blink as the spell (with a caster level equal to your meldshaper level). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    ActionCastSpell(SPELL_BLINK, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BLINK_SHIRT), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
}