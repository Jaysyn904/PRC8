// Resting isn't very safe around here

void SchoonerAttack(object oPC, object oSpawn);

void SchoonerAttack(object oPC, object oSpawn)
{
    if (!GetIsDead(oPC))
    {
        AssignCommand(oSpawn, ActionAttack(oPC));
        
        DelayCommand(3.0, SchoonerAttack(oPC, oSpawn));
    }
}

void RestSpawn(object oPC)
{
    int nSwitch = d3();
    if (nSwitch == 1)
    {
        AssignCommand(oPC, SpeakString("A dry wind touches your flesh moments before a creature charges into the light."));
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_ashen_husk", GetLocation(oPC));
        SchoonerAttack(oPC, oSpawn1);
    }
    else if (nSwitch == 2)
    {        
        AssignCommand(oPC, SpeakString("The rustle of sand grains is the only warning you get before tainted creatures swim from the sand towards you."));
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(oPC));
        object oSpawn2 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(oPC));
        object oSpawn3 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(oPC));
        object oSpawn4 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(oPC));
        object oSpawn5 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_asherati_tnt", GetLocation(oPC));
        SchoonerAttack(oPC, oSpawn1);
        SchoonerAttack(oPC, oSpawn2);
        SchoonerAttack(oPC, oSpawn3);            
        SchoonerAttack(oPC, oSpawn4);
        SchoonerAttack(oPC, oSpawn5);
    }   
    else if (nSwitch == 3)
    {        
        AssignCommand(oPC, SpeakString("A revolting, stooped, humanoid apparently composed of bleeding ash, has come hunting, and you are its prey."));
        object oSpawn1 = CreateObject(OBJECT_TYPE_CREATURE, "bdd_dustblight", GetLocation(oPC));
        SchoonerAttack(oPC, oSpawn1);
    }     
}

void main()
{
    if (d2() == 2) 
    	RestSpawn(GetLastPCRested()); // 50% chance of being attacked while resting
    else
    {
    	SetLocalInt(GetLastPCRested(), "Fatigued", FALSE);
    	DeleteLocalInt(GetLastPCRested(), "HeatstrokeCount");
    }	

    ExecuteScript("prc_rest", OBJECT_SELF);
    ExecuteScript("x2_mod_def_rest", OBJECT_SELF);    
}