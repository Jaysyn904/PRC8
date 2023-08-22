/*
    Warlock epic feat
    Morpheme Savant
*/
#include "prc_inc_racial"

#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    int nSpellID = GetSpellId();
    if(DEBUG) DoDebug("Morpheme Savant Spell ID: " + IntToString(nSpellID));

    if(nSpellID == INVOKE_MORPHEME_SAVANT_WORD_KILL)
        DoRacialSLA(SPELL_POWER_WORD_KILL, CasterLvl);
    else if(nSpellID == INVOKE_MORPHEME_SAVANT_WORD_STUN)
        DoRacialSLA(SPELL_POWER_WORD_STUN, CasterLvl);
}
