/*
   ----------------
   Fog from the Void, Fog Cloud Enter

   true_utr_fogvoid
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Fog from the Void

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    At your words, moisture in the air and ground condenses into a thick mist.
    You create a thick, roiling cloud of fog like the fog cloud spell.
    If you add 10 to the DC of your Truespeak check, you can create a solid fog, as the spell.
*/

#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    SetAllAoEInts(INVOKE_AOE_MIASMIC_CLOUD,OBJECT_SELF, GetSpellSaveDC());

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nCasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nDC = GetInvocationSaveDC(oTarget, oCaster, INVOKE_MIASMIC_CLOUD);
	
	if (GetHasFeat(FEAT_ABFOC_MIASMIC_CLOUD, oCaster)) nDC += 2;
	
    effect eConceal = EffectConcealment(20);
    effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
    effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    // Link
    effect eLink = EffectLinkEffects(eConceal, eDex);
    eLink = EffectLinkEffects(eConceal, eStr);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_MIASMIC_CLOUD));

    if(oTarget != oCaster)
    {
        if(!PRCDoResistSpell(oCaster, oTarget, SPGetPenetrAOE(GetAreaOfEffectCreator(), nCasterLvl)))
    	{
    		//save
    		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    		{
                // Maximum time possible. If its less, its simply cleaned up when the utterance ends.
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(20));
            }
            else
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(20));
        }
    }
    else
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(20));
}
