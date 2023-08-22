//::///////////////////////////////////////////////
//:: Fist of Hextor Brutal Strike Mode
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Changes whether the Brutal Strike feat applies an attack bonus or a damage bonus
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_hextor"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    int nBrutalStrikeCount = _prc_inc_hextor_BrutalStrikeFeatCount(oPC);

    string sMessage;
    if(GetLocalInt(oPC, BRUTAL_STRIKE_MODE_VAR))
    {
        SetLocalInt(oPC, BRUTAL_STRIKE_MODE_VAR, 0);
        sMessage = ReplaceString(GetStringByStrRef(46339+0x01000000), "%(DAMAGE)", IntToString(nBrutalStrikeCount)); //"Brutal Strike: damage +%(DAMAGE)"
    }
    else
    {
        SetLocalInt(oPC, BRUTAL_STRIKE_MODE_VAR, 1);
        sMessage = ReplaceString(GetStringByStrRef(46338+0x01000000), "%(ATTACK)", IntToString(nBrutalStrikeCount)); //"Brutal Strike: attack +%(ATTACK)"
    }
    FloatingTextStringOnCreature(sMessage, oPC, FALSE);

    _prc_inc_hextor_ApplyBrutalStrike(oPC, nBrutalStrikeCount);
}
