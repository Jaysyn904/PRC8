/*
31/12/19 by Stratovarius

Beast Tamer Circlet Totem Bind

Instead of a gleaming silver band around your head, your beast tamer circlet manifests as a ring of silver hair, while all the hair on your head becomes long and coarse like a beast’s mane.

You gain the ability to use animal trance, as the spell. You can use this ability once per minute if you have essentia invested in this soulmeld.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    if (GetEssentiaInvested(oMeldshaper, MELD_BEAST_TAMER_CIRCLET))
    {
    	ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    	ActionCastSpell(SPELL_ANIMAL_TRANCE, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BEAST_TAMER_CIRCLET), 0, GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BEAST_TAMER_CIRCLET), METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    	ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
    }	
}