//::///////////////////////////////////////////////
//:: Desecrate
//:: PRC_TN_desecrate
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    string nMes = "";

    if(!GetHasSpellEffect(SPELL_DES_100) )
    {    
        effect eAOE = EffectAreaOfEffect(AOE_MOB_DES_100); //"prc_tn_des_a", "prc_tn_des_a", "prc_tn_des_b");
        effect eVis = EffectVisualEffect(VFX_TN_DES_100);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(99));
        //rather than a big flashy desecration effect, the alternative is a dark light effect
        if(GetPRCSwitch(PRC_TRUE_NECROMANCER_ALTERNATE_VISUAL))
            eVis = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, HoursToSeconds(99));
        nMes = "*Major Desecrate Activated*";
    }
    else     
    {
        // Removes effects
        PRCRemoveSpellEffects(SPELL_DES_100, oPC, oPC);
        nMes = "*Major Desecrate Deactivated*";
    }
    FloatingTextStringOnCreature(nMes, oPC, FALSE);
}

