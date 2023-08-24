//::///////////////////////////////////////////////
//:: Talon of Tiamat Breath Weapons
//:: prc_taltia_brth.nss
//::///////////////////////////////////////////////
/*
    Handles the breath weapons of the Talon of Tiamat
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 22, 2007
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_inc_breath"

//internal function to reset the breath used marker
void RechargeBreath(object oPC)
{
    SendMessageToPC(oPC, "Breath recharged!");
    SetLocalInt(oPC, "UsedTalonBreath", FALSE);
}

void main()
{
    object oPC = OBJECT_SELF;

    //check to see if 1d4 rounds have passed
    if(GetLocalInt(oPC, "UsedTalonBreath")) 
    {
        FloatingTextStringOnCreature("Your breath is still recharging.", oPC, FALSE);
        return;
    }

    int nSpellID = GetSpellId();
    int nClass = GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC);
    struct breath TalonBreath;

    //Acid cone
    if(nSpellID == SPELL_TOT_ACID_LINE)
    {
        if(nClass < 3)
        {
            FloatingTextStringOnCreature("This breath requires 3rd level Talon of Tiamat.", oPC, FALSE);
            return;
        }
        
        if (GetLocalInt(oPC, "TalonBreath1"))
        {
            FloatingTextStringOnCreature("You have used your Acid Line Breath for the day.", oPC, FALSE);
            return;
        }
        else
        {
        	SetLocalInt(oPC, "TalonBreath1", TRUE);
        	TalonBreath = CreateBreath(oPC, TRUE, 60.0, DAMAGE_TYPE_ACID, 4, 8, ABILITY_CONSTITUTION, nClass);
        }	
    }

    //Acid line
    if(nSpellID == SPELL_TOT_ACID_CONE)
    {
        if(nClass < 5)
        {
            FloatingTextStringOnCreature("This breath requires 5th level Talon of Tiamat.", oPC, FALSE);
            return;
        }

        if (GetLocalInt(oPC, "TalonBreath2"))
        {
            FloatingTextStringOnCreature("You have used your Acid Cone Breath for the day.", oPC, FALSE);
            return;
        }
        else
        {
        	SetLocalInt(oPC, "TalonBreath2", TRUE);
        	TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_ACID, 6, 10, ABILITY_CONSTITUTION, nClass);
        }	
    }

    //Cold
    if(nSpellID == SPELL_TOT_COLD_CONE)
    {
        if (GetLocalInt(oPC, "TalonBreath3"))
        {
            FloatingTextStringOnCreature("You have used your Cold Breath for the day.", oPC, FALSE);
            return;
        }
        else
        {
        	SetLocalInt(oPC, "TalonBreath3", TRUE);    
	        TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_COLD, 6, 3, ABILITY_CONSTITUTION, nClass);
	    }    
    }

    //Electric
    if(nSpellID == SPELL_TOT_ELEC_LINE)
    {
        if(nClass < 7)
        {
            FloatingTextStringOnCreature("This breath requires 7th level Talon of Tiamat.", oPC, FALSE);
            return;
        }

        if (GetLocalInt(oPC, "TalonBreath4"))
        {
            FloatingTextStringOnCreature("You have used your Lightning Breath for the day.", oPC, FALSE);
            return;
        }
        else
        {
        	SetLocalInt(oPC, "TalonBreath4", TRUE);
	        TalonBreath = CreateBreath(oPC, TRUE, 60.0, DAMAGE_TYPE_ELECTRICAL, 8, 12, ABILITY_CONSTITUTION, nClass);
	    }    
    }

    //Fire
    if(nSpellID == SPELL_TOT_FIRE_CONE)
    {
        if(nClass < 9)
        {
            FloatingTextStringOnCreature("This breath requires 9th level Talon of Tiamat.", oPC, FALSE);
            return;
        }

        if (GetLocalInt(oPC, "TalonBreath5"))
        {
            FloatingTextStringOnCreature("You have used your Fire Breath for the day.", oPC, FALSE);
            return;
        }
        else
        {
        	SetLocalInt(oPC, "TalonBreath5", TRUE);
	        TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_FIRE, 8, 14, ABILITY_CONSTITUTION, nClass);
	    }    
    }

    //apply the breath to the affected area
    ApplyBreath(TalonBreath, PRCGetSpellTargetLocation());

    //apply the recharge delay
    int nBreathDelay = TalonBreath.nRoundsUntilRecharge;
    SetLocalInt(oPC, "UsedTalonBreath", TRUE);
    SendMessageToPC(oPC, IntToString(nBreathDelay) + " rounds until you can use your breath.");
    DelayCommand(RoundsToSeconds(nBreathDelay), RechargeBreath(oPC));
}