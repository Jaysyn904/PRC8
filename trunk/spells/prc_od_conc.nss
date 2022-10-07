/** @file
    prc_od_conc

    Runs in the PC's virtual OnDamaged slot, added as an event script by spells
    that require concentration to maintain.

    Makes a concentration check if the PC is damaged and sets the local int
    "CONC_BROKEN" if the check fails

    @author fluffyamoeba
    @date   Created 2007.08.05
*/

#include "inc_eventhook"

void main()
{
    object oPC = OBJECT_SELF;
    // concentration check uses a DC of 10 + damage dealt + spell level
    int nDamage = GetLocalInt(oPC, "PRC_LastDamageTaken");
    int nSpellLevel = GetLocalInt(oPC, "CONC_SPELL_LEVEL");
    int nDC = 10 + nDamage + nSpellLevel;

    if(!GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, nDC))
    {
        RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");
        SetLocalInt(oPC, "CONC_BROKEN", TRUE);
    }
    else
        DeleteLocalInt(oPC, "CONC_BROKEN");
}