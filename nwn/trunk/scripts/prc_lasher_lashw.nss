//::///////////////////////////////////////////////
//:: Lasher - Lashing Whip
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: Sept 29, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_2dacache"
#include "prc_inc_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    PRCRemoveEffectsFromSpell(oPC, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        SupernaturalEffect(
            EffectDamageIncrease(DAMAGE_BONUS_2, IP_CONST_DAMAGETYPE_PHYSICAL)
        ),
        oPC);

}
