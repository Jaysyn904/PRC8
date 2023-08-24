//:://////////////////////////////////////////////
//:: Bonus Domain system: Cast spell from domain slot
//:: prc_domain_cast
//:://////////////////////////////////////////////
/** @file
    Determines which domain slot was used based on
    spellID and runs CastDomainSpell() based on it.


    @author Ornedan
    @date   Created  - 2005.09.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_domain"

// Radial master indices in spells.2da. Assume radial entries follow immediately after the master and are in order
const int SPELLID_DOMAIN_LEVEL_1 = 1655;
const int SPELLID_DOMAIN_LEVEL_2 = 1661;
const int SPELLID_DOMAIN_LEVEL_3 = 1667;
const int SPELLID_DOMAIN_LEVEL_4 = 1673;
const int SPELLID_DOMAIN_LEVEL_5 = 1679;
const int SPELLID_DOMAIN_LEVEL_6 = 1685;
const int SPELLID_DOMAIN_LEVEL_7 = 1691;
const int SPELLID_DOMAIN_LEVEL_8 = 1701;
const int SPELLID_DOMAIN_LEVEL_9 = 1707;
const int NUM_RADIALS = 5;



void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nLevel, nSlot;

    // Determine level and slot
    if(nSpellID > SPELLID_DOMAIN_LEVEL_1 && nSpellID <= SPELLID_DOMAIN_LEVEL_1 + NUM_RADIALS){
        nLevel = 1;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_1;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_2 && nSpellID <= SPELLID_DOMAIN_LEVEL_2 + NUM_RADIALS){
        nLevel = 2;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_2;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_3 && nSpellID <= SPELLID_DOMAIN_LEVEL_3 + NUM_RADIALS){
        nLevel = 3;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_3;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_4 && nSpellID <= SPELLID_DOMAIN_LEVEL_4 + NUM_RADIALS){
        nLevel = 4;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_4;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_5 && nSpellID <= SPELLID_DOMAIN_LEVEL_5 + NUM_RADIALS){
        nLevel = 5;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_5;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_6 && nSpellID <= SPELLID_DOMAIN_LEVEL_6 + NUM_RADIALS){
        nLevel = 6;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_6;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_7 && nSpellID <= SPELLID_DOMAIN_LEVEL_7 + NUM_RADIALS){
        nLevel = 7;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_7;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_8 && nSpellID <= SPELLID_DOMAIN_LEVEL_8 + NUM_RADIALS){
        nLevel = 8;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_8;
    }else if(nSpellID > SPELLID_DOMAIN_LEVEL_9 && nSpellID <= SPELLID_DOMAIN_LEVEL_9 + NUM_RADIALS){
        nLevel = 9;
        nSlot = nSpellID - SPELLID_DOMAIN_LEVEL_9;
    }

    if(DEBUG) DoDebug("prc_domain_cast: Casting domain spell. spellID = " + IntToString(nSpellID) + " ; level = " + IntToString(nLevel) + "; slot = " + IntToString(nSlot));

    CastDomainSpell(oPC, nSlot, nLevel);
}