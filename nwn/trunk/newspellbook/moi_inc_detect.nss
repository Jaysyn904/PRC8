/*
Incarnate Detect Opposition
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
	int nSpell;
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_NEUTRAL) nSpell = SPELL_DETECT_CHAOS;
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_NEUTRAL) nSpell = SPELL_DETECT_LAW;
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD) nSpell = SPELL_DETECT_EVIL;
	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL) nSpell = SPELL_DETECT_GOOD;    
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    ActionCastSpell(nSpell, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_INCARNATE, -1), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 	
}