//::///////////////////////////////////////////////
//:: Name           Mineral Warrior template test script
//:: FileName       tmp_t_mineral
//:: 
//:://////////////////////////////////////////////
/*A mineral warrior is a creature that has undergone a transformation into a creature of living stone. Many creatures embrace 
this change willingly, but evil Underdark races sometimes force it on others.

Creating a Mineral Warrior “Mineral warrior” (also called “stony”) is an acquired template that can be added to any 
corporeal creature that is not a construct, undead, or an elemental (referred to hereafter as the base creature). 
A mineral warrior uses all the base creature’s statistics and special abilities except as noted here. 

Size and Type: The creature’s type remains the same, but it gains the earth subtype. 

Size is unchanged. 

Speed: A mineral warrior gains a burrow speed equal to onehalf the base creature’s highest speed. The base creature loses 
its fly ability, if any. 

Armor Class: Natural armor improves by +3. 

Special Attacks: A mineral warrior retains all the special attacks of the base creature and also gains the earth strike
attack. 

Earth Strike (Ex): Once per day, the mineral warrior can make an exceptionally vicious attack against any foe that stands on
stone or earth. The mineral warrior adds its Constitution bonus to its attack roll and deals 1 extra point of damage per
racial Hit Die. 

Special Qualities: A mineral warrior has all the special qualities of the base creature, plus the following. 
Darkvision (Ex): A mineral warrior has darkvision out to 60 feet or the base creature’s darkvision, whichever is better. 
Damage Reduction (Ex): A mineral warrior gains damage reduction 8/adamantine. If it already has damage reduction, it retains 
both versions and uses the best one that applies. 

Abilities: Change from the base creature as follows: +2 Strength, +4 Con, –2 Int (minimum 1), –2 Wis, –2 Cha. 
Environment: Same as the base creature and underground. 

Challenge Rating: Same as the base creature +1. 
Level Adjustment: Same as the base creature +1. 
*/
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace == RACIAL_TYPE_CONSTRUCT ||
       nRace == RACIAL_TYPE_ELEMENTAL ||
       nRace == RACIAL_TYPE_UNDEAD)
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}