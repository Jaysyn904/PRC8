/////////////////////////////////////////////////
// Tolodine's Killing Wind: On Enter
// tm_s0_epkillwnda.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////

#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare variables
    effect eVis = EffectVisualEffect( VFX_IMP_DEATH );
//    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM ); // Alternative Death VFX
    float fDelay;
    
    //Get the first object entering the area
    object oTarget = GetEnteringObject();


    if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
        GetAreaOfEffectCreator()) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent( oTarget,
            EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE) );
        //Make SR check
        if( !PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF)))
        {
            //Make a fortitude save (-4) to avoid death
            if( !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget)+4,
                SAVING_THROW_TYPE_DEATH, GetAreaOfEffectCreator()) )
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
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
