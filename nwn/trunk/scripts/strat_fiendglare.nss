#include "prc_inc_spells"

void main()
{

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eLink = EffectShaken();
    effect eStun = EffectStunned();
    int nLevel = 10;


    //Meta-Magic checks
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM));
        //Spell Resistance and Saving throw

        //* GZ Engine fix for mind affecting spell

        int nResult =       WillSave(oTarget, 20, SAVING_THROW_TYPE_MIND_SPELLS);
        if (nResult == 2)
        {
            if (GetIsPC(OBJECT_SELF)) // only display immune feedback for PCs
            {
                FloatingTextStrRefOnCreature(84525, oTarget,FALSE); // * Target Immune
            }
            return;
        }

        nResult = (nResult && PRCDoResistSpell(OBJECT_SELF, oTarget,10+SPGetPenetr()));
        if (!nResult)
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nLevel));
            if ( GetMaxHitPoints( oTarget) < 51)
            {
                int nRoll = d4( 3);
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
            }
            else

                if ( GetMaxHitPoints( oTarget) < 101)
                {
                    int nRoll = d4( 2);
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
                }
                else

                    if ( GetMaxHitPoints( oTarget) < 151)
                    {
                        int nRoll = d4( 1);
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun , oTarget, RoundsToSeconds(nRoll));
                    }
        }
    }


// Getting rid of the local integer storing the spellschool name
}
