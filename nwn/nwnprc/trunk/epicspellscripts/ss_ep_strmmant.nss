//::///////////////////////////////////////////////
//:: Storm Mantle
//:: tm_s0_epstrmmant.nss
//:://////////////////////////////////////////////
/*
    Grants all within the casters party within a radius of 10
    to receive a Greater Spell Mantle.
*/
//:://////////////////////////////////////////////
//:: Created By: Nron Ksr
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if( !X2PreSpellCastCode() )
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }  // End of Spell Cast Hook
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_STORM_M))
    {
        //Declare major variables
        object oTarget = GetFirstObjectInShape( SHAPE_SPHERE,
            RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation() );
        effect eVis = EffectVisualEffect( VFX_DUR_SPELLTURNING );
        effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
        int nDuration = GetTotalCastingLevel( OBJECT_SELF ); // Bone - changed

        effect eImpact = EffectVisualEffect( VFX_FNF_LOS_NORMAL_20 );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation() );

        while( GetIsObjectValid(oTarget) )
        {
            if( spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) )
            {
                //Link Effects are inside the IF to cause a d12 roll on each mantle
                int nAbsorb = d12() + 10;
                effect eAbsob = EffectSpellLevelAbsorption( 9, nAbsorb );
                effect eLink = EffectLinkEffects( eVis, eAbsob );
                eLink = EffectLinkEffects( eLink, eDur );

                //Fire cast spell at event for the specified target
                SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF,
                    SPELL_GREATER_SPELL_MANTLE, FALSE) );
                PRCRemoveEffectsFromSpell( oTarget, GetSpellId() );
                //Apply the VFX impact and effects
                SPApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink,
                    oTarget, RoundsToSeconds(nDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF) );
            }
            oTarget = GetNextObjectInShape( SHAPE_SPHERE,
                RADIUS_SIZE_HUGE, PRCGetSpellTargetLocation() );
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

