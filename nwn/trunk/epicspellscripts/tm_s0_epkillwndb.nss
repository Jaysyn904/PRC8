/////////////////////////////////////////////////
// Tolodine's Killing Wind: On Heartbeat
// tm_s0_epkillwndb.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    object oCaster = GetAreaOfEffectCreator();
    
    //Declare variables
    effect eVis = EffectVisualEffect( VFX_IMP_DEATH );
//    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM ); // Alternative Death VFX
    float fDelay;      
        //Get the first object in the persistent area
    object oTarget = GetFirstInPersistentObject();

 



    while( GetIsObjectValid(oTarget) )
    {
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
            oCaster) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent( oTarget,
                EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE) );
            //Make a SR check
            if( !PRCDoResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster)) )
            {

                //Make a fortitude save (-4) to avoid death
                if( !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget)+4,
                    SAVING_THROW_TYPE_DEATH, oCaster) )
                {
                    //Apply the delay VFX impact and death effect
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                    effect eDeath = EffectDeath();
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget) );
                    DeathlessFrenzyCheck(oTarget);
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
