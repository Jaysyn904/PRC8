//::///////////////////////////////////////////////
//:: Thrall of Orcus Carrion Stench
//:: prc_to_carrion.nss
//:://////////////////////////////////////////////
/*
    Creatures entering the area around the Thrall
    must save or be cursed with Doom
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:: Updated On: July 22, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    string nMes = "";

    if(!GetHasSpellEffect(SPELL_TO_CARRION, oPC))
    {
        effect eAOE = EffectAreaOfEffect(AOE_MOB_CARRION);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, HoursToSeconds(100));
        nMes = "*Carrion Stench Activated*";
    }
    else
    {
        // Removes effects
        PRCRemoveSpellEffects(SPELL_TO_CARRION, oPC, oPC);
        nMes = "*Carrion Stench Deactivated*";
    }
    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}