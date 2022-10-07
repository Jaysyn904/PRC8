/*
30/12/19 by Stratovarius

Beast Tamer Circlet Crown Bind

Your silver circlet fuses to your head, sending silver-blue tendrils like tiny veins under your skin. The endless clamor of beast noises becomes intelligible to you — you understand the range of needs and emotions that drives these utterances — but you are still able to ignore it with a modicum of concentration.

You gain the ability to charm animals, as the spell. You can use this ability in any round during which you invest essentia in your beast tamer circlet. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    if (GetLocalInt(oMeldshaper, "EssentiaRound"+IntToString(MELD_BEAST_TAMER_CIRCLET)))
    {
    	ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    	ActionCastSpell(SPELL_CHARM_PERSON_OR_ANIMAL, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BEAST_TAMER_CIRCLET), 0, GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_BEAST_TAMER_CIRCLET), METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    	ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
    }	
}