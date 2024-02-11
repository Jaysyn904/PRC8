/////////////////////////////////////////////////
// Tolodine's Killing Wind
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
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
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_TOLO_KW))
    {
        //Declare variables
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nToAffect = nCasterLevel;
        location lTarget = PRCGetSpellTargetLocation();

        // Visual effect creations
        effect eImpact = EffectVisualEffect( 262 );
        effect eImpact2 = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_MIND );
        effect eImpact3 = EffectVisualEffect( VFX_FNF_HOWL_WAR_CRY );
        effect eImpact4 = EffectVisualEffect( VFX_FNF_SOUND_BURST );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact4, lTarget );

        effect eAOE = EffectAreaOfEffect
            ( AOE_PER_FOG_OF_BEWILDERMENT, "tm_s0_epkillwnda", "tm_s0_epkillwndb", "****" );

        //Create an instance of the AOE Object
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(10) );
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
