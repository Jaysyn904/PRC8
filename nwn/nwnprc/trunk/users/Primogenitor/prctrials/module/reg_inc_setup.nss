const string REG_RESREF_PREFIX      = "prc_npc_";//"mob_";
const int    REG_RACE_MAX           = 8;//255;
const int    REG_RACE_INSTANCE_MAX  = 50;

int GetPackageForClass(int nClass);
object REG_CreateNPC(location lSpawn, float fCR, int nRace);

void REG_LevelupAndStoreNPC(string sResRef, location lSpawn)
{
    object oNPC = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);
    //make sure you clean up first
    DestroyObject(oNPC);
//DoDebug("Initial XP = "+IntToString(GetXP(oNPC)));
    //give them lvl 40 XP
    SetXP(oNPC, 40*39*500);
//DoDebug("After SetXP = "+IntToString(GetXP(oNPC)));
    //level then up to 40
    //use default package, its not great but it works
    int nHD = GetHitDice(oNPC);
//DoDebug("Initial HD = "+IntToString(nHD));
    if(nHD != 1)
    {
        DoDebug("Starting HD is not 1 "+GetName(oNPC));
        return;
    }
    //racial HD if appropriate
    if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
    {
        int nRace = GetRacialType(oNPC);
        int nRacialHDCount = StringToInt(Get2DACache("ECL", "RaceHD", nRace));
        int nRacialHDClass = StringToInt(Get2DACache("ECL", "RaceClass", nRace));
        while(nHD<nRacialHDCount+1)//+1 for initial class HD
        {
            nHD = LevelUpHenchman(oNPC, nRacialHDClass, TRUE);        
        }
    }
    int nClass1 = GetClassByPosition(1, oNPC);
    int nClass2 = CLASS_TYPE_INVALID;
    
    while(nHD<40)
    {
        int nPackage = PACKAGE_INVALID;
        int nClass;
        //get a random matched class if appropriate
        //50/50 leveling
        if(nClass2 != CLASS_TYPE_INVALID
            && nHD%2 == 1)
            nClass == nClass2;
        else
            nClass == nClass1;
        //make sure alignment is correct
        AdjustAlignment(oNPC, ALIGNMENT_NEUTRAL, 100);
        if(nClass == CLASS_TYPE_PALADIN)
        {
            AdjustAlignment(oNPC, ALIGNMENT_LAWFUL, 100);
            AdjustAlignment(oNPC, ALIGNMENT_GOOD,   100);    
        }
        if(nClass == CLASS_TYPE_MONK)
        {
            AdjustAlignment(oNPC, ALIGNMENT_LAWFUL, 100); 
        }
        nPackage = GetPackageForClass(nClass);
        nHD = LevelUpHenchman(oNPC, nClass, TRUE, nPackage);
        if(nHD == 0)
        {
            DoDebug("Unable to levelup "+GetName(oNPC));
            DelayCommand(0.0, REG_LevelupAndStoreNPC(sResRef, lSpawn));
            return;
        }
    }
//DoDebug("Final HD = "+IntToString(nHD));
    string sVar = REG_RESREF_PREFIX;
    sVar += IntToString(GetRacialType(oNPC));
    int nNPCCount = GetCampaignInt(REG_DATABASE, sVar+"_count");
    nNPCCount++;
    SetCampaignInt(REG_DATABASE, sVar+"_count", nNPCCount);
    sVar += "_"+IntToString(nNPCCount);
    StoreCampaignObject(REG_DATABASE, sVar+"_obj", oNPC);
}

void REG_DoSetup(int nRace = RACIAL_TYPE_INVALID)
{
    if(nRace == RACIAL_TYPE_INVALID)
    {
        return;
//for debug purposes
//DestroyCampaignDatabase(REG_DATABASE);
        if(GetCampaignInt(REG_DATABASE, "reg_setup"))
            return;
        for(nRace = 0; nRace <= REG_RACE_MAX; nRace++)
        {
            DelayCommand(0.01, REG_DoSetup(nRace));
        }
        DelayCommand(0.1, SetCampaignInt(REG_DATABASE, "reg_setup", TRUE));
    }
    else if(StringToInt(Get2DACache("racialtypes", "PlayerRace", nRace)))
    {
        int i;
        int nClass;
        int nTotal;
        object oWP = GetObjectByTag("HEARTOFCHAOS");
        location lSpawn = GetLocation(oWP);
        if(!GetIsObjectValid(oWP))
            lSpawn = GetStartingLocation();
        for(nClass = 0; nClass <= 10; nClass++)
        {
            nTotal += StringToInt(Get2DACache("reg_raceclass", "Class_"+IntToString(nClass), nRace));
        }
        for(i=0;i<REG_RACE_INSTANCE_MAX;i++)
        {
            int nGender = RandomI(2);
            int nRandom = RandomI(nTotal);
            int nTempTotal = 0;
            /*
            for(nClass = 0; nClass <= 10 && nTempTotal < nRandom; nClass++)
            {
                nTempTotal += StringToInt(Get2DACache("reg_raceclass", "Class_"+IntToString(nClass), nRace));
            }
            */
            //DEBUG
            nClass = RandomI(11);
            string sResRef = REG_RESREF_PREFIX+IntToString(nRace)+"_"+IntToString(nClass)+"_"+IntToString(nGender);
            DelayCommand(0.01, REG_LevelupAndStoreNPC(sResRef, lSpawn));
        }
    }
}

object REG_CreateNPC(location lSpawn, float fCR, int nRace)
{
//StartTimer(OBJECT_SELF, "REG_CreateNPC");
    string sVar = REG_RESREF_PREFIX;
    sVar += IntToString(nRace);
    int nNPCCount = GetCampaignInt(REG_DATABASE, sVar+"_count");
    if(nNPCCount == 0)
    {
        //not already in database, put them there
        REG_DoSetup(nRace);
        return OBJECT_INVALID;
    }
    nNPCCount = RandomI(nNPCCount)+1;
    sVar += "_"+IntToString(nNPCCount);
    object oSpawn = RetrieveCampaignObject(REG_DATABASE, sVar+"_obj", lSpawn);
    if(!GetIsObjectValid(oSpawn))
    {
        DoDebug("Unable to spawn from database "+sVar);
        return OBJECT_INVALID;
    }
    //store how many Great X feats they have
    //this is to fix a bioware bug where de-leveling doesnt remove the stat bonus
    int nGreatStr;
    int nGreatDex;
    int nGreatCon;
    int nGreatInt;
    int nGreatWis;
    int nGreatCha;
    if     (GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_10, oSpawn)) nGreatStr = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_9, oSpawn)) nGreatStr = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_8, oSpawn)) nGreatStr = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_7, oSpawn)) nGreatStr = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_6, oSpawn)) nGreatStr = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_5, oSpawn)) nGreatStr = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_4, oSpawn)) nGreatStr = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_3, oSpawn)) nGreatStr = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_2, oSpawn)) nGreatStr = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_STRENGTH_1, oSpawn)) nGreatStr = 1;
    if     (GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_10, oSpawn)) nGreatDex = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_9, oSpawn)) nGreatDex = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_8, oSpawn)) nGreatDex = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_7, oSpawn)) nGreatDex = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_6, oSpawn)) nGreatDex = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_5, oSpawn)) nGreatDex = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_4, oSpawn)) nGreatDex = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_3, oSpawn)) nGreatDex = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_2, oSpawn)) nGreatDex = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_DEXTERITY_1, oSpawn)) nGreatDex = 1;
    if     (GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_10, oSpawn)) nGreatCon = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_9, oSpawn)) nGreatCon = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_8, oSpawn)) nGreatCon = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_7, oSpawn)) nGreatCon = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_6, oSpawn)) nGreatCon = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_5, oSpawn)) nGreatCon = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_4, oSpawn)) nGreatCon = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_3, oSpawn)) nGreatCon = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_2, oSpawn)) nGreatCon = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CONSTITUTION_1, oSpawn)) nGreatCon = 1;
    if     (GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_10, oSpawn)) nGreatInt = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_9, oSpawn)) nGreatInt = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_8, oSpawn)) nGreatInt = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_7, oSpawn)) nGreatInt = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_6, oSpawn)) nGreatInt = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_5, oSpawn)) nGreatInt = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_4, oSpawn)) nGreatInt = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_3, oSpawn)) nGreatInt = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_2, oSpawn)) nGreatInt = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_INTELLIGENCE_1, oSpawn)) nGreatInt = 1;
    if     (GetHasFeat(FEAT_EPIC_GREAT_WISDOM_10, oSpawn)) nGreatWis = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_9, oSpawn)) nGreatWis = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_8, oSpawn)) nGreatWis = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_7, oSpawn)) nGreatWis = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_6, oSpawn)) nGreatWis = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_5, oSpawn)) nGreatWis = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_4, oSpawn)) nGreatWis = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_3, oSpawn)) nGreatWis = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_2, oSpawn)) nGreatWis = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_WISDOM_1, oSpawn)) nGreatWis = 1;
    if     (GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_10, oSpawn)) nGreatCha = 10;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_9, oSpawn)) nGreatCha = 9;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_8, oSpawn)) nGreatCha = 8;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_7, oSpawn)) nGreatCha = 7;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_6, oSpawn)) nGreatCha = 6;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_5, oSpawn)) nGreatCha = 5;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_4, oSpawn)) nGreatCha = 4;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_3, oSpawn)) nGreatCha = 3;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_2, oSpawn)) nGreatCha = 2;
    else if(GetHasFeat(FEAT_EPIC_GREAT_CHARISMA_1, oSpawn)) nGreatCha = 1;

    //de-level them by removing XP
//DoDebug("Initial XP = "+IntToString(GetXP(oSpawn)));
//DoDebug("Initial HD = "+IntToString(GetHitDice(oSpawn)));
    int nNewXP = FloatToInt(fCR*(fCR-1.0)*500.0);
    SetXP(oSpawn, nNewXP);
//DoDebug("After SetXP = "+IntToString(GetXP(oSpawn)));
//DoDebug("Final HD = "+IntToString(GetHitDice(oSpawn)));

    //apply penalties to counter the GreatX feats
    if(nGreatStr)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_STRENGTH, nGreatStr)),
        oSpawn);
    if(nGreatDex)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, nGreatDex)),
        oSpawn);
    if(nGreatCon)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, nGreatCon)),
        oSpawn);
    if(nGreatInt)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_INTELLIGENCE, nGreatInt)),
        oSpawn);
    if(nGreatWis)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_WISDOM, nGreatWis)),
        oSpawn);
    if(nGreatCha)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectAbilityDecrease(ABILITY_CHARISMA, nGreatCha)),
        oSpawn);

    //use delay command to avoid TMIs
    AssignCommand(oSpawn,
        DelayCommand(1.00,
            ExecuteScript("reg_spawn", oSpawn)));
//DoDebug("Timer REG_CreateNPC(): "+StopTimer(OBJECT_SELF, "REG_CreateNPC"));
    return oSpawn;
}

int GetPackageForClass(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARBARIAN:
            switch(Random(5))
            {
                case 0: return PACKAGE_BARBARIAN; break;
                case 1: return PACKAGE_BARBARIAN_BRUTE; break;
                case 2: return PACKAGE_BARBARIAN_ORCBLOOD; break;
                case 3: return PACKAGE_BARBARIAN_SAVAGE; break;
                case 4: return PACKAGE_BARBARIAN_SLAYER; break;
            }
            break;
        case CLASS_TYPE_BARD:
            switch(Random(5))
            {
                case 0: return PACKAGE_BARD; break;
                case 1: return PACKAGE_BARD_BLADE; break;
                case 2: return PACKAGE_BARD_GALLANT; break;
                case 3: return PACKAGE_BARD_JESTER; break;
                case 4: return PACKAGE_BARD_LOREMASTER; break;
            }
            break;
        case CLASS_TYPE_CLERIC:
            switch(Random(5))
            {
                case 0: return PACKAGE_CLERIC; break;
                case 1: return PACKAGE_CLERIC_BATTLE_PRIEST; break;
                case 2: return PACKAGE_CLERIC_DEADWALKER; break;
                case 3: return PACKAGE_CLERIC_ELEMENTALIST; break;
                case 4: return PACKAGE_CLERIC_SHAMAN; break;
            }
            break;
        case CLASS_TYPE_DRUID:
            switch(Random(5))
            {
                case 0: return PACKAGE_DRUID; break;
                case 1: return PACKAGE_DRUID_DEATH; break;
                case 2: return PACKAGE_DRUID_GRAY; break;
                case 3: return PACKAGE_DRUID_HAWKMASTER; break;
                case 4: return PACKAGE_DRUID_INTERLOPER; break;
            }
            break;
        case CLASS_TYPE_FIGHTER:
            switch(Random(5))
            {
                case 0: return PACKAGE_FIGHTER; break;
                case 1: return PACKAGE_FIGHTER_COMMANDER; break;
                case 2: return PACKAGE_FIGHTER_FINESSE; break;
                case 3: return PACKAGE_FIGHTER_GLADIATOR; break;
                case 4: return PACKAGE_FIGHTER_PIRATE; break;
            }
            break;
        case CLASS_TYPE_MONK:
            switch(Random(5))
            {
                case 0: return PACKAGE_MONK; break;
                case 1: return PACKAGE_MONK_DEVOUT; break;
                case 2: return PACKAGE_MONK_GIFTED ; break;
                case 3: return PACKAGE_MONK_PEASANT; break;
                case 4: return PACKAGE_MONK_SPIRIT; break;
            }
            break;
        case CLASS_TYPE_PALADIN:
            switch(Random(5))
            {
                case 0: return PACKAGE_PALADIN; break;
                case 1: return PACKAGE_PALADIN_CHAMPION; break;
                case 2: return PACKAGE_PALADIN_ERRANT; break;
                case 3: return PACKAGE_PALADIN_INQUISITOR; break;
                case 4: return PACKAGE_PALADIN_UNDEAD; break;
            }
            break;
        case CLASS_TYPE_RANGER:
            switch(Random(5))
            {
                case 0: return PACKAGE_RANGER; break;
                case 1: return PACKAGE_RANGER_GIANTKILLER; break;
                case 2: return PACKAGE_RANGER_MARKSMAN; break;
                case 3: return PACKAGE_RANGER_STALKER; break;
                case 4: return PACKAGE_RANGER_WARDEN; break;
            }
            break;
        case CLASS_TYPE_ROGUE:
            switch(Random(5))
            {
                case 0: return PACKAGE_ROGUE; break;
                case 1: return PACKAGE_ROGUE_BANDIT; break;
                case 2: return PACKAGE_ROGUE_GYPSY; break;
                case 3: return PACKAGE_ROGUE_SCOUT; break;
                case 4: return PACKAGE_ROGUE_SWASHBUCKLER; break;
            }
            break;
        case CLASS_TYPE_SORCERER:
            switch(Random(9))
            {
                case 0: return PACKAGE_SORCERER; break;
                case 1: return PACKAGE_SORCERER_ABJURATION; break;
                case 2: return PACKAGE_SORCERER_CONJURATION; break;
                case 3: return PACKAGE_SORCERER_DIVINATION; break;
                case 4: return PACKAGE_SORCERER_ENCHANTMENT; break;
                case 5: return PACKAGE_SORCERER_EVOCATION; break;
                case 6: return PACKAGE_SORCERER_ILLUSION; break;
                case 7: return PACKAGE_SORCERER_NECROMANCY; break;
                case 8: return PACKAGE_SORCERER_TRANSMUTATION; break;
            }
            break;
        case CLASS_TYPE_WIZARD:
            switch(Random(9))
            {
                case 0: return PACKAGE_WIZARDGENERALIST; break;
                case 1: return PACKAGE_WIZARD_ABJURATION; break;
                case 2: return PACKAGE_WIZARD_CONJURATION; break;
                case 3: return PACKAGE_WIZARD_DIVINATION; break;
                case 4: return PACKAGE_WIZARD_ENCHANTMENT; break;
                case 5: return PACKAGE_WIZARD_EVOCATION; break;
                case 6: return PACKAGE_WIZARD_ILLUSION; break;
                case 7: return PACKAGE_WIZARD_NECROMANCY; break;
                case 8: return PACKAGE_WIZARD_TRANSMUTATION; break;
            }
            break;
    }
    return PACKAGE_INVALID;
}
