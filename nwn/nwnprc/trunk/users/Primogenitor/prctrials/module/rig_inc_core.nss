//this gets the cache chest for this combination
//note that nLevel is no longer used
//note that by default a chest will be created if it doesnt exist already.
object RIG_GetCacheChest(int nBaseItemType, int nAC, int nLevel, int nCreate = TRUE);

//This function will create chests for all the roots in order to cache suitable
void RIG_DoSetup();

//this is an internal function used to test if an object is suitable for a creature
int RIG_CheckLimitations(object oItem, object oPC = OBJECT_SELF);

//apply an itemproperty to an item based on an ID number
//returns the object that it was applied to, or invalid if:
//  the itemproperty was invalid
//  the itemproperty could not be applied
//  the item already had an itemproperty of the same type & subtype
object RIG_AddItemProperty(object oItem, int nRIGIP);

//Returns a root of the same type as the object passed in
//Calls RIG_GetRandomMatchingRootByType
int RIG_GetRandomMatchingRoot(object oItem, int nAC = 0);

//gets a root by ID suitable to match the base item type passed in
int RIG_GetRandomMatchingRootByType(int nBase, int nAC = 0);

//gets the current cache size for this base item type
int RIG_GetCacheSize(int nBaseItem);

//main function to handle prefix/root/suffix selection
object RIG_Core(object oItem, int nLevel, int nType = BASE_ITEM_INVALID, int nAC = 0);


object RIG_GetCacheChest(int nBaseItemType, int nAC, int nLevel, int nCreate = TRUE)
{
    string sTag = "RIG_Chest_"+IntToString(nBaseItemType)+"_"+IntToString(nAC);
    object oChest = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oChest)
        && nCreate)
    {
        location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
        oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "rig_chest", lLimbo, FALSE, sTag);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oChest);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oChest);
        SetLocalInt(oChest, "BaseItem", nBaseItemType);
        SetLocalInt(oChest, "Level", nLevel);
        SetLocalInt(oChest, "AC", nAC);
    }
    return oChest;
}

//spawn a chest for each base item type
//Private Function
void RIG_DoSetup2(int nBaseItemType, int nAC = 0)
{
    int nLevel;
    for(nLevel=1; nLevel<=40; nLevel++)
    {
        object oChest = RIG_GetCacheChest(nBaseItemType, nAC, nLevel);
    }    
}

void RIG_DoSetup()
{
    int i;
    for(i=0;i<RIG_ROOT_COUNT;i++)
    {
        string sBaseType = Get2DACache("rig_root", "BaseItem", i);
        if(sBaseType != "")
        {
            //dont setup some base types we dont have in the RIG yet
            int nBaseType = StringToInt(sBaseType);
            if(nBaseType != BASE_ITEM_MAGICROD
                && nBaseType != BASE_ITEM_MAGICWAND
                && nBaseType != BASE_ITEM_SCROLL
                && nBaseType != BASE_ITEM_SPELLSCROLL
                && nBaseType != BASE_ITEM_THIEVESTOOLS
                && nBaseType != BASE_ITEM_TORCH
                && nBaseType != BASE_ITEM_TRAPKIT
                && nBaseType != BASE_ITEM_POTIONS
                && nBaseType != BASE_ITEM_MISCSMALL
                && nBaseType != BASE_ITEM_MISCMEDIUM
                && nBaseType != BASE_ITEM_MISCLARGE
                && nBaseType != BASE_ITEM_KEY
                && nBaseType != BASE_ITEM_LARGEBOX
                && nBaseType != BASE_ITEM_INVALID
                && nBaseType != BASE_ITEM_GOLD
                && nBaseType != BASE_ITEM_GEM
                && nBaseType != BASE_ITEM_ENCHANTED_WAND
                && nBaseType != BASE_ITEM_ENCHANTED_SCROLL
                && nBaseType != BASE_ITEM_ENCHANTED_POTION
                && nBaseType != BASE_ITEM_CSLSHPRCWEAP
                && nBaseType != BASE_ITEM_CREATUREITEM
                && nBaseType != BASE_ITEM_CSLASHWEAPON
                && nBaseType != BASE_ITEM_CRAFTMATERIALSML
                && nBaseType != BASE_ITEM_CRAFTMATERIALMED
                && nBaseType != BASE_ITEM_CPIERCWEAPON
                && nBaseType != BASE_ITEM_CBLUDGWEAPON
                && nBaseType != BASE_ITEM_BOOK
                && nBaseType != BASE_ITEM_BLANK_WAND
                && nBaseType != BASE_ITEM_BLANK_SCROLL
                && nBaseType != BASE_ITEM_BLANK_POTION        
                )
            {
                int nAC = StringToInt(Get2DACache("rig_root", "AC", i));
                float fDelay = IntToFloat(i)/1.0;
                DelayCommand(fDelay, RIG_DoSetup2(nBaseType, nAC));  
            }    
        }
    }
    //enable fast-caching at start
    SetLocalInt(GetModule(), "RIG_Doing_Setup", RIG_ROOT_COUNT);
    //maximum cap of 5 minutes of fast-caching
    DelayCommand(60.0*5.0, DeleteLocalInt(GetModule(), "RIG_Doing_Setup"));
}


int RIG_CheckLimitations(object oItem, object oPC = OBJECT_SELF)
{
    itemproperty ipTemp = GetFirstItemProperty(oItem);
    int nClassValid = -1;
    int nRaceValid = -1;
    int nSAlignValid = -1;
    int nAlignValid = -1;
    while(GetIsItemPropertyValid(ipTemp))
    {
        int nType = GetItemPropertyType(ipTemp);
        int nSubType = GetItemPropertySubType(ipTemp);
        switch(nType)
        {
            case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
                switch(nSubType)
                {
                    case IP_CONST_ALIGNMENTGROUP_EVIL:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_GOOD:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
                        if(GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENTGROUP_LAWFUL:
                        if(GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                }
                break;
            case ITEM_PROPERTY_USE_LIMITATION_CLASS:
                if(GetLevelByClass(nSubType, oPC))
                    nClassValid = TRUE;
                else if(nClassValid == -1)
                    nClassValid = FALSE;
                break;
            case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
                if(GetRacialType(oPC) == nSubType)
                    nRaceValid = TRUE;
                else if(nRaceValid == -1)
                    nRaceValid = FALSE;
                break;
            case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
                switch(nSubType)
                {
                    case IP_CONST_ALIGNMENT_CE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_CN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_CG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_NE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_TN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_NG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LE:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LN:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                    case IP_CONST_ALIGNMENT_LG:
                        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
                            && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL)
                            nAlignValid = TRUE;
                        else if(nAlignValid == -1)
                            nAlignValid = FALSE;
                        break;
                }
                break;

        }
        ipTemp = GetNextItemProperty(oItem);
    }
    if(nAlignValid == FALSE
        || nClassValid == FALSE
        || nRaceValid == FALSE
        || nSAlignValid == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}

object RIG_AddItemProperty(object oItem, int nRIGIP)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("oItem is not valid going into RIG_AddItemProperty");
        return OBJECT_INVALID;
    }
    if(nRIGIP <0)
    {
        DoDebug("nRIGIP is less than 0 going into RIG_AddItemProperty");
        DestroyObject(oItem);
        return OBJECT_INVALID;
    }
    if(nRIGIP == 0)
    {
        //DoDebug("nRIGIP is 0 going into RIG_AddItemProperty");
        //no itemproperty, do nothing
        return oItem;
    }
    int nType = StringToInt(Get2DACache("rig_ip", "Type", nRIGIP));
    string sVar2 = Get2DACache("rig_ip", "Var2", nRIGIP);
    string sVar3 = Get2DACache("rig_ip", "Var3", nRIGIP);
    string sVar4 = Get2DACache("rig_ip", "Var4", nRIGIP);
    int nVar2 = -1;
    int nVar3 = -1;
    int nVar4 = -1;
    //if its not blank, convert to an int
    if(sVar2 != "")
        nVar2 = StringToInt(sVar2);
    if(sVar3 != "")
        nVar3 = StringToInt(sVar3);
    if(sVar4 != "")
        nVar4 = StringToInt(sVar4);
    itemproperty ipToApply;
    ipToApply = IPGetItemPropertyByID(nType, nVar2, nVar3, nVar4);
    if(!GetIsItemPropertyValid(ipToApply))
    {
        DoDebug("Itemproperty is not valid to apply nRIGIP="+IntToString(nRIGIP));
        DestroyObject(oItem);
        return OBJECT_INVALID;
    }
    //test if it already has an IP of that type & subtype
    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == GetItemPropertyType(ipToApply)
            && (GetItemPropertySubType(ipTest) == GetItemPropertySubType(ipToApply)
                    || GetItemPropertySubType(ipTest) == -1))
            return OBJECT_INVALID;
        ipTest = GetNextItemProperty(oItem);
    }
    IPSafeAddItemProperty(oItem, ipToApply);
    //check it worked
    itemproperty ipTemp = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTemp))
    {
        if(ipTemp == ipToApply)
            return oItem;
        ipTemp = GetNextItemProperty(oItem);
    }
    //did not work
    DoDebug("Itemproperty is not applicable to this base item. Name="+GetName(oItem)+" IPType="+IntToString(nType)+" nRIGIP="+IntToString(nRIGIP));
    DestroyObject(oItem);
    return OBJECT_INVALID;
}

int RIG_GetRandomMatchingRoot(object oItem, int nAC = 0)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("oItem is not valid going into RIG_GetRandomMatchingRoot");
        return -1;
    }
    int nBase = GetBaseItemType(oItem);
    return RIG_GetRandomMatchingRootByType(nBase, nAC);
}

int RIG_GetRandomMatchingRootByType(int nBase, int nAC = 0)
{
    //if the root is the same as the base item type, return it
    if(StringToInt(Get2DACache("rig_root", "BaseItem", nBase)) == nBase)
        return nBase;
    int i = 0;
    string sValue = Get2DACache("rig_root", "BaseItem", i);
    while(sValue != "")
    {
        if(StringToInt(sValue) == nBase)
        {
            //fuggly hardcoding for different armors
            if(nBase == BASE_ITEM_ARMOR)
            {
                if(nAC == StringToInt(Get2DACache("rig_root", "AC", i)))
                    return i;
            }
            else
                return i;
        }
        i++;
        sValue = Get2DACache("rig_root", "BaseItem", i);
    }
    //should never get here
    return -1;
}

int RIG_GetCacheSize(int nBaseItem)
{
    int nCacheSize = GetLocalInt(GetModule(), "RigCacheMax"+IntToString(nBaseItem));
    if(nCacheSize < RIG_ITEM_CACHE_SIZE)
        nCacheSize = RIG_ITEM_CACHE_SIZE;
    return nCacheSize;
}


object RIG_Core(object oItem, int nLevel, int nType = BASE_ITEM_INVALID, int nAC = 0)
{
    //get a valid root
    int nRoot;
    if(GetIsObjectValid(oItem))
    {
        nRoot = RIG_GetRandomMatchingRoot(oItem, nAC);
        DestroyObject(oItem);
    }    
    else
        nRoot = RIG_GetRandomMatchingRootByType(nType, nAC);
    //get the resref of that root
    string sResRef = Get2DACache("rig_root", "ResRef", nRoot);
    if(nType == BASE_ITEM_INVALID
        && GetIsObjectValid(oItem))
        nType = GetBaseItemType(oItem);
    if(nType == BASE_ITEM_INVALID)
        return OBJECT_INVALID;
    int nIPType = StringToInt(Get2DACache("baseitems", "PropColumn", nType));
    object oReturn = CreateItemOnObject(sResRef, GetObjectByTag("HEARTOFCHAOS"));
    //sanity test
    if(!GetIsObjectValid(GetObjectByTag("HEARTOFCHAOS")))
    {
        DoDebug("RIG_Core() HEARTOFCHAOS is not valid");
        return OBJECT_INVALID;
    }
    //sanity test
    if(!GetIsObjectValid(oReturn))
        oReturn = oItem;
    //sanity test
    if(!GetIsObjectValid(oReturn))
    {
        DoDebug("RIG_Core() oReturn is not valid");
        return OBJECT_INVALID;
    }
    //store things about the object for the random2da system to detect
    SetLocalInt(OBJECT_SELF, "Random_Default_Level", nLevel);
    SetLocalObject(OBJECT_SELF, "Random_Default_Object", oReturn);
    //get the suffix/prefix
    int nSuffix, nPrefix;
    string sSuffix, sPrefix;
    if(nLevel <= 20
        && RIG_PRE_EPIC_ONE_AFFIX_LIMIT)
    {    
        //pre-epic, either a prefix or a suffix, not both
        if(Random(2))
            sSuffix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);            
        else          
            sPrefix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);
    }
    else
    {
        //epic item, can have both prefix and suffix
        //random order of selection though
        if(Random(2))
        {
            sSuffix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType); 
            //second one is a number of levels lower equal to the difference from the max
            //e.g. 30 & 20, 25 & 10, 35 & 30, etc
            nLevel  = nLevel-(40-nLevel);
            SetLocalInt(OBJECT_SELF, "Random_Default_Level", nLevel);
            sPrefix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);           
        }    
        else          
        {
            sPrefix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType);
            //second one is a number of levels lower equal to the difference from the max
            //e.g. 30 & 20, 25 & 10, 35 & 30, etc
            nLevel  = nLevel-(40-nLevel);
            SetLocalInt(OBJECT_SELF, "Random_Default_Level", nLevel);
            sSuffix = GetRandomFrom2DA("rig_affix_r", "random_default", nIPType); 
        }    
    }    
    //sanity check. No prefix/suffixs at all, then abort.
    if(sSuffix == "" 
        && sPrefix == "")
    {
        DestroyObject(oItem);
        DestroyObject(oReturn);
        return OBJECT_INVALID;
    }
    nSuffix = StringToInt(sSuffix);
    nPrefix = StringToInt(sPrefix);
    if(nPrefix == nSuffix 
        && nPrefix != 0 
        && nSuffix != 0)
    {
        //Duplicates become single-affixs
        if(Random(2))
            nPrefix = 0;
        else
            nSuffix = 0;
    }
    if(nSuffix != 0)
    {
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property1", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property2", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property3", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property4", nSuffix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property5", nSuffix)));
    }
    if(nPrefix != 0)
    {
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property1", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property2", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property3", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property4", nPrefix)));
        if(GetIsObjectValid(oReturn))
        oReturn = RIG_AddItemProperty(oReturn, StringToInt(Get2DACache("rig_affix", "Property5", nPrefix)));
    }
    //clean up afterwards
    DestroyObject(oItem);
    DeleteLocalInt(GetModule(), "RIG_LEVEL");
    string sPrefixName = Get2DACache("rig_affix", "Text", nPrefix);
    string sSuffixName = Get2DACache("rig_affix", "Text", nSuffix);
    string sName = Get2DACache("rig_root", "Name", nRoot);
    if(sPrefixName != "") sName = sPrefixName+" "+sName;
    if(sSuffixName != "") sName = sName+" of "+sSuffixName;
    SetName(oReturn, sName);
    return oReturn;
}