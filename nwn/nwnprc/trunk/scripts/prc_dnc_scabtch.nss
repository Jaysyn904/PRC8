/*
    prc_dnc_scabtch

    Scabrous Touch
    Does contagion spell on touch
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"

void main()
{
	object oCaster = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster);

	int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
	if (iAttackRoll > 0)
	{
		    	int nDC = 10 + nClass/2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
		
		        int nRand = Random(7)+1;
		        int nDisease;
		        //Use a random seed to determine the disease that will be delivered.
		        switch (nRand)
		        {
		            case 1:
		                nDisease = DISEASE_CONTAGION_BLINDING_SICKNESS;
		            break;
		            case 2:
		                nDisease = DISEASE_CONTAGION_CACKLE_FEVER;
		            break;
		            case 3:
		                nDisease = DISEASE_CONTAGION_FILTH_FEVER;
		            break;
		            case 4:
		                nDisease = DISEASE_CONTAGION_MINDFIRE;
		            break;
		            case 5:
		                nDisease = DISEASE_CONTAGION_RED_ACHE;
		            break;
		            case 6:
		                nDisease = DISEASE_CONTAGION_SHAKES;
		            break;
		            case 7:
		                nDisease = DISEASE_CONTAGION_SLIMY_DOOM;
		            break;
		        }
		        if(!GetIsReactionTypeFriendly(oTarget))
		        {
		            //Fire cast spell at event for the specified target
		            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
		            effect eDisease = EffectDisease(nDisease);
		                // Make the real first save against the spell's DC
		                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		                {
		                    //The effect is permament because the disease subsystem has its own internal resolution
		                    //system in place.
		                    // The first disease save is against an impossible fake DC, since at this point the
		                    // target has already failed their real first save.
		                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
		                }
        		}
	}

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

}