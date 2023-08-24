/////////////////////////////////////////////////
// Leech Field
// tm_s0_epleech.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: An AoE that saps the life of those in the
// field and transfers it to the caster.
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_LEECH_F))
    {

        //Declare variables
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nToAffect = nCasterLevel;
        location lTarget = PRCGetSpellTargetLocation();

        // Visual effect creations
        effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
        effect eImpact2 = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
        effect eImpact3 = EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD );

        // Linking visuals
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );

        effect eAOE = EffectAreaOfEffect
            ( AOE_PER_EVARDS_BLACK_TENTACLES,
                "tm_s0_epleecha", "tm_s0_epleechb", "****" );

        //Create an instance of the AOE Object
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE,
            lTarget, RoundsToSeconds(nCasterLevel) );
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
