/**
 * @file
 * Spellscript for Acererak Vestige
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    int nCasterLevel = GetBinderLevel(oBinder, VESTIGE_ACERERAK);
    int nDC = GetBinderDC(oBinder, VESTIGE_ACERERAK);
    int nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    switch(nSLA){
        case 19113:
        {
            nSpell = SPELL_DETECT_UNDEAD;
            break;
        } 
        case 19114:
        {
            nSpell = SPELL_HIDE_FROM_UNDEAD;
            break;
        }         
    }

    DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);    
}
        