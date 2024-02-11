/////////////////////////////////////////////////
// Leech Field: On Heartbeat
// tm_s0_epleech.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/15/2004
// Description: An AoE that saps the life of those in the
// field and transfers it to the caster.
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////
#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget;
    int nDamage;
    float fDelay;
            
    //Capture the first target object in the shape.
    oTarget = GetFirstInPersistentObject();


    // If oCaster is not valid
    if( !GetIsObjectValid(oCaster) )
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        DestroyObject( OBJECT_SELF );
        return;
    }

    //Declare and assign personal impact visual effect.
    effect eVisHeal = EffectVisualEffect( VFX_IMP_HEALING_M );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eBad = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
    effect eDam, eHeal;



    while( GetIsObjectValid(oTarget) )
    {
        //Declare the spell shape, size and the location.
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
            GetAreaOfEffectCreator()) )
        {
            fDelay = PRCGetRandomDelay(0.5, 2.0);
            //Roll damage.
            // Apply effects to the currently selected target.

            // * any undead should be healed, not just Friendlies
            if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
            || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
            || GetLocalInt(oTarget, "AcererakHealing"))
            {
                //Fire cast spell at event for the specified target
                SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST) );
                //Set the heal effect
                eHeal = EffectHeal(d6(4));
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget) );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget) );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget) );
            }
            else
            {
                if( !PRCDoResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster), fDelay) )
                {
                        

                    // Debug message.
                    SendMessageToPC(oCaster, "Not resisted.");
                    nDamage = d6(4);
                    //Adjust damage for Save
                    if( PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget) , //B-chngd to nDC
                        SAVING_THROW_TYPE_NEGATIVE, oCaster, fDelay) )
                    {
                        nDamage /= 2;
                        
                        if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                        {
                        nDamage = 0;
                        }                         
                    }
                    //Fire cast spell at event for the specified target
                    SignalEvent( oTarget,
                        EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST) );
                    //Set the damage effect
                    eDam = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
                    // Apply effects to the currently selected target.
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
                    //This visual effect is applied to the target object not the location as above.
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget) );

                    // Heal the caster
                    if( GetCurrentHitPoints(oCaster) <= GetMaxHitPoints(oCaster) * 2 )
                    {
                        eHeal = EffectTemporaryHitpoints(nDamage);
                        DelayCommand( 2.1,
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                                eVisHeal, oCaster) );
                        DelayCommand( 2.1,
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eHeal, oCaster,
                                    TurnsToSeconds(GetTotalCastingLevel(oCaster)), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)) );
                    }
                }
            }
        }
    //Select the next target within the spell shape.
    oTarget = GetNextInPersistentObject();
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
