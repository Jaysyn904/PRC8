//::///////////////////////////////////////////////
//:: Fist of Hextor Damage/Attack
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses by using
//:: ActionCastSpellOnSelf
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_hextor"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    _prc_inc_hextor_ApplyBrutalStrike(oPC, _prc_inc_hextor_BrutalStrikeFeatCount(oPC));
}
