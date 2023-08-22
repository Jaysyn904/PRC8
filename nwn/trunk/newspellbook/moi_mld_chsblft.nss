/*
10/1/20 by Stratovarius

Planar Chasuble Soul Bind 

The embroidered patterns formed by raw incarnum in the front of your planar chasuble constantly shift and seem to depict living scenes from planes beyond the material world.

Once per week you can cast gate.
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    if (!GetLocalInt(oMeldshaper, "PlanarChasubleLimit"))
    {
    	ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    	ActionCastSpell(SPELL_GATE, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PLANAR_CHASUBLE), 0, GetMeldshaperDC(oMeldshaper, CLASS_TYPE_INCARNATE, MELD_PLANAR_CHASUBLE), METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    	ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
    	SetLocalInt(oMeldshaper, "PlanarChasubleLimit", 1);
    }	
}