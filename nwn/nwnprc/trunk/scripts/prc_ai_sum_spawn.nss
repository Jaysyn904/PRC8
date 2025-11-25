#include "prc_alterations"
#include "prc_compan_inc"
#include "inc_npc"

void main()
{
    object oNPC = OBJECT_SELF;
	
	ExecuteScript("nw_ch_summon_9", oNPC);
    ExecuteScript("prc_npc_spawn", oNPC);
	
    //:: Used for the Twinfiend Pit Fiend summon
	int nUltravision = GetLocalInt(oNPC,"INNATE_ULTRAVISION");
    if(nUltravision)
	{
		effect eUltra = EffectUltravision();
		eUltra = UnyieldingEffect(eUltra);
		DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltra, oNPC));
	}	
	
	
    
    //use companion appearances
    /*if(GetPRCSwitch(MARKER_PRC_COMPANION))
    {
        int nOldAppearance = GetAppearanceType(OBJECT_SELF);
        int nNewAppearance = nOldAppearance;
        int nRandom = d100();
        switch(nOldAppearance)
        {
            case APPEARANCE_TYPE_BEHOLDER_EYEBALL:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEHOLDER_EYEBALL_150;
                break;
            case APPEARANCE_TYPE_BEHOLDER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEHOLDER_125;
                break;
            case APPEARANCE_TYPE_BEHOLDER_MAGE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEHOLDER_MAGE_125;
                break;
            case APPEARANCE_TYPE_DRAGON_BLACK:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BLACK_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BLACK_125;
                break;
            case APPEARANCE_TYPE_DRAGON_BRASS:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BRASS_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BRASS_125;
                break;
            case APPEARANCE_TYPE_DRAGON_COPPER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_COPPER_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_COPPER_125;
                break;
            case APPEARANCE_TYPE_DRAGON_BLACK:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_SILVER_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_SILVER_125;
                break;
            case APPEARANCE_TYPE_DRAGON_BRONZE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BRONZE_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BRONZE_125;
                break;
            case APPEARANCE_TYPE_DRAGON_GOLD:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_GOLD_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_GOLD_125;
                break;
            case APPEARANCE_TYPE_DRAGON_BLUE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BLUE_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_BLUE_125;
                break;
            case APPEARANCE_TYPE_DRAGON_GREEN:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_GREEN_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_GREEN_125;
                break;
            case APPEARANCE_TYPE_DRAGON_RED:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_RED_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_RED_125;
                break;
            case APPEARANCE_TYPE_DRAGON_WHITE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_WHITE_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_WHITE_125;
                break;
            case APPEARANCE_TYPE_DRAGON_SHADOW:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_SHADOW_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_SHADOW_125;
                break;
            case APPEARANCE_TYPE_DRAGON_PRIS:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_PRISM_75;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_DRAGON_PRISM_125;
                break;
                break;
            case APPEARANCE_TYPE_BEETLE_STAG:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_STAG_25;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_STAG_50;
                else if(nRandom < 70)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_STAG_125;
                break;
            case APPEARANCE_TYPE_BEETLE_STINK:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_STINK_50;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_STINK_25;
                break;
            case APPEARANCE_TYPE_BEETLE_SLICER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BEETLE_SLICER_125;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_AIR:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_AIR_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_AIR_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_EARTH:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_EARTH_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_EARTH_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_FIRE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_FIRE_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_FIRE_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_WATER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_WATER_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_WATER_150;
                break;
            case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER_125;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER_150;
                break;
            case APPEARANCE_TYPE_MUMMY_COMMON:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_MUMMY_COMMON_125;
                break;
            case APPEARANCE_TYPE_SKELETON_COMMON:
                if(nRandom < 20)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SKELETON_COMMON_50;
                else if(nRandom < 40)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SKELETON_COMMON_75;
                else if(nRandom < 60)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SKELETON_COMMON_125;
                else if(nRandom < 80)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SKELETON_COMMON_150;
                break;
            case APPEARANCE_TYPE_SHIELD_GUARDIAN:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SHIELD_GUARDIAN_125;
                break;
            case APPEARANCE_TYPE_MOHRG:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_MOHRG_125;
                break;
            case APPEARANCE_TYPE_ZOMBIE:
                if(nRandom < 20)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ZOMBIE_50;
                else if(nRandom < 40)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ZOMBIE_75;
                else if(nRandom < 60)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ZOMBIE_125;
                else if(nRandom < 80)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_ZOMBIE_150;
                break;
            case APPEARANCE_TYPE_GARGOYLE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_GARGOYLE_125;
                break;
            case APPEARANCE_TYPE_SKELETAL_DEVOURER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_SKELETAL_DEVOURER_125;
                break;
            case APPEARANCE_TYPE_PENGUIN:
                if(nRandom < 10)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_PENGUIN_150;
                else if(nRandom < 20)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_PENGUIN_200;
                else if(nRandom < 30)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_PENGUIN_300;
                else if(nRandom < 40)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_PENGUIN_400;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_PENGUIN_500;
                break;
            case APPEARANCE_TYPE_BAT:
                if(nRandom < 10)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_50;
                else if(nRandom < 20)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_60;
                else if(nRandom < 30)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_70;
                else if(nRandom < 40)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_80;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_90;
                else if(nRandom < 60)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_125;
                else if(nRandom < 70)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_150;
                else if(nRandom < 80)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_BAT_200;
                break;
            case APPEARANCE_TYPE_CAT_COUGAR:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_COUGAR_40;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_COUGAR_50;
                else if(nRandom < 72)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_COUGAR_75;
                break;
            case APPEARANCE_TYPE_CAT_LION:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_LION_40;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_LION_50;
                else if(nRandom < 72)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_LION_75;
                break;
            case APPEARANCE_TYPE_CAT_PANTHER:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_PANTHER_40;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_PANTHER_50;
                else if(nRandom < 72)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_CAT_PANTHER_75;
                break;
            case APPEARANCE_TYPE_RAT:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_RAT_50;
                else if(nRandom < 50)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_RAT_75;
                break;
            case APPEARANCE_TYPE_GOLEM_CLAY:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_GOLEM_CLAY_125;
                break;
            case APPEARANCE_TYPE_GOLEM_IRON:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_GOLEM_IRON_125;
                break;
            case APPEARANCE_TYPE_GOLEM_STONE:
                if(nRandom < 25)
                nNewAppearance = PRC_COMP_APPEARANCE_TYPE_GOLEM_STONE_125;
                break;
        
        }
        if(nOldAppearance != nNewAppearance)
            DelayCommand(0.1,
                SetCreatureAppearanceType(OBJECT_SELF, nNewAppearance));
    }*/
}