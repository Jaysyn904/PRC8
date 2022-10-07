/////////////////////////////////////////////////
// Magma Burst
// tm_s0_epMagmaBu.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save.  If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    // Spell Cast Hook
    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MAGMA_B))
    {
        // Declare major variables
        object oCaster = OBJECT_SELF;
        object oTarget;
        // Boneshank - Added in the nDC formula.
         float fDelay;
        int nDamage;
        int nCasterLvl = GetTotalCastingLevel(OBJECT_SELF);
        effect eAOE = EffectAreaOfEffect
            ( AOE_PER_FOGFIRE, "tm_s0_epmagmabua", "tm_s0_epmagmabub", "tm_s0_epmagmabuc" );
        location lTarget = PRCGetSpellTargetLocation();
        int nDuration = GetTotalCastingLevel(OBJECT_SELF) / 5; //B- changed.
        effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_FIRE );
        effect eImpact2 = EffectVisualEffect( VFX_FNF_IMPLOSION );
        effect eImpact3 = EffectVisualEffect( VFX_FNF_STRIKE_HOLY );
        effect eImpact4 = EffectVisualEffect( VFX_FNF_FIRESTORM );
        effect eVis = EffectVisualEffect( VFX_IMP_FLAME_M );
        effect eDam;
        // Direct Impact is handled first.  (20d8) - reflex.
        // Apply the explosion at the location captured above.
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact4, lTarget );

        // Declare the spell shape, size and the location.  Capture the first target .
        oTarget = GetFirstObjectInShape
            ( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
        // Cycle through the targets within the spell shape until an invalid object is captured.
        while( GetIsObjectValid(oTarget) )
        {
            if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
            {
                //Fire cast spell at event for the specified target
                SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL) );
                // Set the delay for the explosion.
                fDelay = PRCGetRandomDelay( 0.5f, 2.0f );
                if( !PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay) )
                {
                    nDamage = d8(20);
                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = PRCGetReflexAdjustedDamage( nDamage, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_FIRE );
                    //Set the damage effect
                    eDam = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
                    if( nDamage > 0 )
                    {
                        // Apply effects to the currently selected target (dmg & visual)
                        DelayCommand( fDelay,
                            SPApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget) );
                        DelayCommand( fDelay,
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                    }
                }
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape
                ( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
        }

        //Create the AoE object at the location for the next effects
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration) );
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
