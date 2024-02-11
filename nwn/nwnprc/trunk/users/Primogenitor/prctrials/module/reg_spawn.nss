#include "rig_inc"
#include "ref_inc"
#include "rng_inc"
#include "pnp_shft_poly"
#include "prc_alterations"
#include "inc_ecl"

void EquipByType(int nType, int nSlot, int nAC = 0, int nTrial = 10)
{
    //repeated failures, abort
    if(nTrial <= 0)
        return;
    //dead, abort
    if(GetIsDead(OBJECT_SELF))
        return;    
        
    object oItem = GetRandomizedItemByType(
        nType,
        //GetECL(OBJECT_SELF),
        GetHitDice(OBJECT_SELF),
        nAC);
        
    if(!GetIsObjectValid(oItem))
    {
        float fDelay = IntToFloat(Random(60))/10.0;
        DelayCommand(fDelay, 
            EquipByType(nType, nSlot, nAC, nTrial-1));
        return;
    }

    if(nSlot != -1)
    {
        //if its armor, make sure not in combat mode
        if(nType == BASE_ITEM_ARMOR)
            ClearAllActions(TRUE);
        ForceEquip(OBJECT_SELF,
            oItem,
            nSlot);
    }        
}

void DoArmor()
{
    //get AC
    int nAC = 0;
    if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY))
        nAC = RandomI(3)+6;
    else if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM))
        nAC = RandomI(2)+4;
    else if(GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT))
        nAC = RandomI(3)+1;

    //monks have zero AC
    //so do wizards & sorcs
    if(GetLevelByClass(CLASS_TYPE_MONK)
        || GetLevelByClass(CLASS_TYPE_SORCERER)
        || GetLevelByClass(CLASS_TYPE_WIZARD))
        nAC = 0;
    //rangers have light armor
    //so do bards
    else if(GetLevelByClass(CLASS_TYPE_RANGER)
        || GetLevelByClass(CLASS_TYPE_BARD))
        nAC = RandomI(3)+1;
    DelayCommand(0.1, 
        EquipByType(BASE_ITEM_ARMOR, 
            INVENTORY_SLOT_CHEST, 
            nAC));
}

void DoRanged()
{
    int nType = GetHandItemType(OBJECT_SELF, FALSE, TRUE);
    //delay this so the ammo creates first
    DelayCommand(1.1, 
        EquipByType(nType, INVENTORY_SLOT_RIGHTHAND));
    if(nType == BASE_ITEM_HEAVYCROSSBOW
        || nType == BASE_ITEM_LIGHTCROSSBOW)
        DelayCommand(0.2, 
            EquipByType(BASE_ITEM_BOLT,     
                INVENTORY_SLOT_BOLTS));
    else if(nType == BASE_ITEM_LONGBOW
        || nType == BASE_ITEM_SHORTBOW)
        DelayCommand(0.3, 
            EquipByType(BASE_ITEM_ARROW, 
                INVENTORY_SLOT_ARROWS));
    else if(nType == BASE_ITEM_SLING)
        DelayCommand(0.4, 
            EquipByType(BASE_ITEM_BULLET, 
                INVENTORY_SLOT_BULLETS));
}

void ForceSetCreatureBodyPart(int nPart, int nModelNumber, object oCreature=OBJECT_SELF, int nIndex = 0)
{
    //sanity check not being changed already
    if(GetLocalInt(oCreature, "ForceSetCreatureBodyPart"+IntToString(nPart)) != nModelNumber+1
        && GetLocalInt(oCreature, "ForceSetCreatureBodyPart"+IntToString(nPart)) != 0)
        return;
    //mark it as being changed for sanity purposes    
    SetLocalInt(oCreature, "ForceSetCreatureBodyPart"+IntToString(nPart), nModelNumber+1);
    //change the body part
    SetCreatureBodyPart(nPart, nModelNumber, oCreature);
    //test if it really was changed
    //not sure if this will work or not
    if(nIndex < 10)
    {
        DelayCommand(1.00, 
            ForceSetCreatureBodyPart(nPart, nModelNumber, oCreature, nIndex+1));
        return;    
    }
    //clean up marker
    DeleteLocalInt(oCreature, "ForceSetCreatureBodyPart"+IntToString(nPart));
}

//changes portrait, head, and appearance
//based on the target race with a degree of randomization.
void MyDoDisguise(int nRace, object oTarget = OBJECT_SELF)
{
    //tends to go wrong, not sure why
    return;
    //store current appearance to be safe
    StoreAppearance(oTarget);
    int nAppearance; //appearance to change into
    int nHeadMax;    //max head ID, changed to random 1-max
    int nGender = GetGender(oTarget);
    int nPortraitMin;//minimum row in portraits.2da
    int nPortraitMax;//maximum row in portraits.2da
    switch(nRace)
    {
        case RACIAL_TYPE_DWARF:
            nAppearance = APPEARANCE_TYPE_DWARF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =   9;  nPortraitMax =  17; }
            else
            {   nHeadMax = 12; nPortraitMin =   1;  nPortraitMax =   8; }
            break;
        case RACIAL_TYPE_ELF:
            nAppearance = APPEARANCE_TYPE_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =  31;  nPortraitMax =  40; }
            else
            {   nHeadMax = 16; nPortraitMin =  18;  nPortraitMax =  30; }
            break;
        case RACIAL_TYPE_HALFELF:
            nAppearance = APPEARANCE_TYPE_HALF_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin =  93;  nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin =  67;  nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFORC:
            nAppearance = APPEARANCE_TYPE_HALF_ORC;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 134;  nPortraitMax = 139; }
            else
            {   nHeadMax = 1;  nPortraitMin = 130;  nPortraitMax = 133; }
            break;
        case RACIAL_TYPE_HUMAN:
            nAppearance = APPEARANCE_TYPE_HUMAN;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin = 93;   nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin = 67;   nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFLING:
            nAppearance = APPEARANCE_TYPE_HALFLING;
            if(nGender == GENDER_MALE)
            {   nHeadMax =  8; nPortraitMin = 61;   nPortraitMax = 66; }
            else
            {   nHeadMax = 11; nPortraitMin = 54;   nPortraitMax = 59;  }
            break;
        case RACIAL_TYPE_GNOME:
            nAppearance = APPEARANCE_TYPE_GNOME;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 47;   nPortraitMax = 53; }
            else
            {   nHeadMax =  9; nPortraitMin = 41;   nPortraitMax = 46;  }
            break;
        default: //not a normal race, abort
            return;
    }
    //change the appearance
    SetCreatureAppearanceType(oTarget, nAppearance);

    //need to be delayed a bit otherwise you get "supergnome" and "exploded elf" effects
    //still get weird stuff with missing bodyparts from time to time though :(
    DelayCommand(1.1, ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,       d2(), oTarget));
    DelayCommand(1.2, ForceSetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,        d2(), oTarget));
    DelayCommand(1.3, ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,      d2(), oTarget));
    DelayCommand(1.4, ForceSetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,       d2(), oTarget));
    DelayCommand(1.5, ForceSetCreatureBodyPart(CREATURE_PART_TORSO,            d2(), oTarget));
    DelayCommand(1.6, ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,    d2(), oTarget));
    DelayCommand(1.7, ForceSetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,     d2(), oTarget));
    DelayCommand(1.8, ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,      d2(), oTarget));
    DelayCommand(1.9, ForceSetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,       d2(), oTarget));
    
    //dont do these body parts, they dont have tattoos and weird things could happen
    //ForceSetCreatureBodyPart(CREATURE_PART_BELT,             d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_NECK,             d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,   d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,    d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,       d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_LEFT_HAND,        d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_PELVIS,           d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,       d2(), oTarget);
    //ForceSetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,        d2(), oTarget);
    //randomise the head
    DelayCommand(2.0, ForceSetCreatureBodyPart(CREATURE_PART_HEAD, Random(nHeadMax)+1, oTarget));
    
    //remove any wings/tails
    SetCreatureWingType(CREATURE_WING_TYPE_NONE, oTarget);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oTarget);

    int nPortraitID = Random(nPortraitMax-nPortraitMin+1)+nPortraitMin;
    string sPortraitResRef = Get2DACache("portraits", "BaseResRef", nPortraitID);
    sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1); //trim the trailing _
    SetPortraitResRef(oTarget, sPortraitResRef);
    SetPortraitId(oTarget, nPortraitID);
}
            
void ReapplyWingsAndTails()
{
    //DoDisguise removed wings/tails need to re-add
    if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI)
        SetCreatureWingType(CREATURE_WING_TYPE_DEMON, OBJECT_SELF);
    else if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_AVARIEL)
        SetCreatureWingType(CREATURE_WING_TYPE_BIRD, OBJECT_SELF);
}        

void EquipOther()
{
    //other items
    int nECL = GetHitDice(OBJECT_SELF);
    //number of slots to fill
    int nSlotMax = 8;
    //half by ECL, and half by chance
    int nSlotCount = FloatToInt((IntToFloat(nECL)/20.0)*(IntToFloat(nSlotMax)/2.0));
    nSlotCount += Random(nSlotCount+1);
    //fill them
    int nSlots;
    int i;
    for(0;i<nSlotCount;i++)
    {
        int nRandom = Random(8);
        switch(nRandom)
        {
            case 0:
                nSlots = nSlots | 1;
                break;
            case 1:
                nSlots = nSlots | 2;
                break;
            case 2:
                nSlots = nSlots | 4;
                break;
            case 3:
                nSlots = nSlots | 8;
                break;
            case 4:
                nSlots = nSlots | 16;
                break;
            case 5:
                nSlots = nSlots | 32;
                break;
            case 6:
                nSlots = nSlots | 64;
                break;
            case 7:
                nSlots = nSlots | 128;
                break;
        }
    }
    //bitwise math
    //head
    if(nSlots & 1)
        DelayCommand(5.0,
            EquipByType(BASE_ITEM_HELMET, INVENTORY_SLOT_HEAD));
    //rings
    if(nSlots & 2)
        DelayCommand(6.0,
            EquipByType(BASE_ITEM_RING, INVENTORY_SLOT_LEFTHAND));
    if(nSlots & 4)
        DelayCommand(7.0,
            EquipByType(BASE_ITEM_RING, INVENTORY_SLOT_RIGHTHAND));
    //belt        
    if(nSlots & 8)
        DelayCommand(8.0,
            EquipByType(BASE_ITEM_BELT, INVENTORY_SLOT_BELT));
    //belt        
    if(nSlots & 16)
        DelayCommand(9.0,
            EquipByType(BASE_ITEM_BOOTS, INVENTORY_SLOT_BOOTS));
    //cloak        
    if(nSlots & 32)
        DelayCommand(10.0,
            EquipByType(BASE_ITEM_CLOAK, INVENTORY_SLOT_CLOAK));
    //necklace        
    if(nSlots & 64)
        DelayCommand(11.0,
            EquipByType(BASE_ITEM_AMULET, INVENTORY_SLOT_NECK));
    //bracers/gloves        
    if(nSlots & 128)
        DelayCommand(12.0,
            EquipByType(BASE_ITEM_BRACER, INVENTORY_SLOT_ARMS));

}

void main()
{
    //make sure it only runs once
    if(GetLocalInt(OBJECT_SELF, "Spawned")) 
        return;
    SetLocalInt(OBJECT_SELF, "Spawned", TRUE);

    //attatch prc_ai_mob_* scripts via eventhook
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPHYSICALATTACKED,   "prc_ai_mob_attck", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONBLOCKED,            "prc_ai_mob_block", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCOMBATROUNDEND,     "prc_ai_mob_combt", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONCONVERSATION,       "prc_ai_mob_conv",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDAMAGED,            "prc_ai_mob_damag", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDISTURBED,          "prc_ai_mob_distb", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONPERCEPTION,         "prc_ai_mob_percp", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPAWNED,            "prc_ai_mob_spawn", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONSPELLCASTAT,        "prc_ai_mob_spell", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONDEATH,              "prc_ai_mob_death", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONRESTED,             "prc_ai_mob_rest",  TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONUSERDEFINED,        "prc_ai_mob_userd", TRUE, FALSE);
    AddEventScript(OBJECT_SELF, EVENT_VIRTUAL_ONHEARTBEAT,          "prc_ai_mob_heart", TRUE, FALSE);
    
    //if you have a familiar, summon it    
    if(GetHasFeat(FEAT_ANIMAL_COMPANION))
    {
        SummonAnimalCompanion();
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
        DelayCommand(1.0, 
            SetName(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION), 
                RandomName(NAME_ANIMAL)));
    }
    //if you have an animal companion, summon it
    if(GetHasFeat(FEAT_SUMMON_FAMILIAR))
    {
        SummonFamiliar();
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
        DelayCommand(1.0, 
            SetName(GetAssociate(ASSOCIATE_TYPE_FAMILIAR), 
                RandomName(NAME_FAMILIAR)));
    }

    SetName(OBJECT_SELF, RandomName()+" "+RandomName());
    //DelayCommand(0.0, SetName(OBJECT_SELF, RNG_GetRandomNameForObject()+" "+RNG_GetRandomNameForObject()));

    DelayCommand(1.0, MyDoDisguise(MyPRCGetRacialType(OBJECT_SELF)));
    DelayCommand(1.5, ReapplyWingsAndTails());
    DelayCommand(2.0, DoArmor());

    //equip ranged first
    DelayCommand(3.0, DoRanged());
    //create melee weapons for later
    //will also make shields
    DelayCommand(4.0,
        EquipByType(GetHandItemType(OBJECT_SELF, FALSE, FALSE),-1));
    DelayCommand(5.0,
        EquipByType(GetHandItemType(OBJECT_SELF, TRUE, FALSE),-1));
    DelayCommand(6.0, EquipOther());
        
}
