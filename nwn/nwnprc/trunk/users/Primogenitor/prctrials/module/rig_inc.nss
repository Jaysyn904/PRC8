
//called mainly by the caching system
//does the actual creation and stuff
void CreateRandomizeItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE);

//spliot to avoid TMI
void CreateRandomizeItemByType_B(object oItem, int nLevel, int nAC, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)  ;

//retrieves an object from the cache
object GetRandomizedItemByType(int nBaseItemType, int nLevel, int nAC = 0);

const int       RIG_CREATE_ALL_CACHE_CHESTS_ON_LOAD = TRUE;
const int       RIG_ITEM_CACHE_SIZE                 =   1;
const int       RIG_ITEM_CACHE_SIZE_MAX             =  10;
const int       RIG_PRE_EPIC_ONE_AFFIX_LIMIT        = TRUE;
const int       RIG_ROOT_COUNT                      =  70;
const int       RIG_STOLEN_RATE                     =   1; //percentage
const int       RIG_CURSED_RATE                     =   1; //percentage
const int       RIG_STACK_MIN_PROPORTION            =  50; //percentage
const int       RIG_STACK_MAX_PROPORTION            = 100; //percentage
const int       RIG_CHARGE_MIN_PROPORTION           =  25; //percentage
const int       RIG_CHARGE_MAX_PROPORTION           =  75; //percentage

#include "prc_gateway"
#include "rig_inc_app"
#include "rig_inc_core"

//Returns TRUE if oItem is stackable
int GetIsStackableItem(object oItem)
{
    //sanity testing
    if(!GetIsObjectValid(oItem))
        return FALSE;
    int nStackSize = GetItemStackSize(oItem);
    //Set the stacksize to two
    SetItemStackSize(oItem, 2);
    //Check if it really is two - otherwise, not stackable!
    int bStack;
    if(GetItemStackSize(oItem)==2)
        bStack = TRUE;
    //restore original stack size
    SetItemStackSize(oItem, nStackSize);
    //Return bStack which is TRUE if item is stackable
    return bStack;
}

object GetRandomizedItemByType(int nBaseItemType, int nLevel, int nAC = 0)
{
    //check its not an invalid type
    if(nBaseItemType == BASE_ITEM_INVALID)
        return OBJECT_INVALID; 
    object oChest = RIG_GetCacheChest(nBaseItemType, nAC, nLevel);
    //sanity check,chest is valid  
    if(!GetIsObjectValid(oChest))
    {
        DoDebug("GetRandomizedItemByType() oChest is not valid!");
        return OBJECT_INVALID;
    }    
    //test against the counter local
    //no objects in it abort now
    if(!GetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel))) 
        return OBJECT_INVALID;

    //loop over them to find one    
    //Possible TMI point?
    //not if each item/level has its own creature  
    //ah but then the cache gets into the gigabyte size range
    object oTest = GetFirstItemInInventory(oChest);
    while(GetIsObjectValid(oTest))
    {
        //clean up things that arnt supposed to be their
        if(GetLocalInt(oTest, "RigLevel") ==0)
        {
            DestroyObject(oTest);
        }    
        else if(GetLocalInt(oTest, "RigLevel") == nLevel
            && RIG_CheckLimitations(oTest)
            )    
            break;//end while loop
        oTest = GetNextItemInInventory(oChest);
    }
    //we didnt find anything
    if(!GetIsObjectValid(oTest))
    {
        //check the size of the cache for this item, and if less than cachemax increase it
        int nCacheMax = RIG_GetCacheSize(nBaseItemType);
        if(nCacheMax < RIG_ITEM_CACHE_SIZE_MAX)
        {
            SetLocalInt(GetModule(), "RigCacheMax"+IntToString(nBaseItemType), nCacheMax+1);
            DoDebug("GetRandomizedItemByType() Increasing the size of the cache for "+IntToString(nBaseItemType)+" to "+IntToString(nCacheMax+1));
        }    
        //return something invalid so we can try again later
        return OBJECT_INVALID;
    }    
    //we did find something, bring it back
    object oReturn = CopyItem(oTest, OBJECT_SELF, TRUE);
    SetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel), 
        GetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel))-1);
    //to save time, only destroy a proportion of originals
    //this is based on how many items of that level are in the chest. 
    //If its full, never duplicate.
    //If its empty, always duplicate.
    int nCacheSize = RIG_GetCacheSize(nBaseItemType);
    if(RandomI(nCacheSize) < GetLocalInt(oChest, "ContentsLevel"+IntToString(nLevel)))
        DestroyObject(oTest);
    return oReturn;    
}

//during this function, the item is checked against OBJECT_SELF
//for equiping restrictions
void CreateRandomizeItemByType(int nBaseItemType, int nLevel, int nAC = 0, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)
{
    if(nBaseItemType == BASE_ITEM_INVALID)
    {
        DoDebug("CreateRandomizeItemByType() invalid base item type");
        return;
    }

    SetLocalInt(OBJECT_SELF, "Random_Default_Level", nLevel);
    object oItem;
    //do the itemproperties
    if(nRandomizeAffixs)
        oItem = RIG_Core(oItem, nLevel, nBaseItemType, nAC);
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("CreateRandomizeItemByType() invalid after Rig_Core");
        return;
    }
    //split to avoid TMI
    DelayCommand(0.0, CreateRandomizeItemByType_B(oItem, nLevel, nAC, nRandomizeAppearance, nRandomizeAffixs, nRandomizeOther));
}    

void CreateRandomizeItemByType_B(object oItem, int nLevel, int nAC, int nRandomizeAppearance = TRUE, int nRandomizeAffixs = TRUE, int nRandomizeOther = TRUE)   
{    
    //randomize appearance
    if(nRandomizeAppearance)
        oItem = RandomizeItemAppearance(oItem, nAC);
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("CreateRandomizeItemByType() invalid after RandomizeItemAppearance");
        return;
    }

    //move it back from temporary storage
    DestroyObject(oItem);
    oItem = CopyItem(oItem, OBJECT_SELF, TRUE);
    if(!GetIsObjectValid(oItem))
    {
        DoDebug("CreateRandomizeItemByType() invalid after copy back");
        return;
    }

    if(nRandomizeOther)
    {
        //randomize charges if appropriate
        if(GetItemCharges(oItem) > 0)
        {
            int nCharges = 50;
            nCharges = FloatToInt(IntToFloat(nCharges)*IntToFloat(RandomI(RIG_CHARGE_MAX_PROPORTION-RIG_CHARGE_MIN_PROPORTION)+RIG_CHARGE_MIN_PROPORTION)*0.01);
            SetItemCharges(oItem, nCharges);
        }    

        //randomize stack size, if appropriate
        if(GetIsStackableItem(oItem))
        {
            int nStack = StringToInt(Get2DACache("baseitems", "ILRStackSize", GetBaseItemType(oItem)));
            nStack = FloatToInt(IntToFloat(nStack)*IntToFloat(RandomI(RIG_STACK_MAX_PROPORTION-RIG_STACK_MIN_PROPORTION)+RIG_STACK_MIN_PROPORTION)*0.01);
            SetItemStackSize(oItem, nStack);
        }    

        //a % of items are cursed
        SetItemCursedFlag(oItem, FALSE);
        if(RandomI(100)<RIG_CURSED_RATE)
            SetItemCursedFlag(oItem, TRUE);

        //a % of items are stolen
        SetStolenFlag(oItem, FALSE);
        if(RandomI(100)<RIG_STOLEN_RATE)
            SetStolenFlag(oItem, TRUE);
    }    
    SetLocalInt(oItem, "RigLevel", nLevel);

    int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel));
    if(GetIsObjectValid(oItem))
        SetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel), nItemCount+1);    
}