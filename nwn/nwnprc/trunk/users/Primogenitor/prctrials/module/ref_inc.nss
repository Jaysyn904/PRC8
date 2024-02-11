/*
Primogenitors Random Equipment Functions

This include file contains a group of functions that will create equipment
on the creatures they are called upon.
The equipment will be just the basic bioware defaults, so you will have to
add/replace with enchanted versions yourself.
If the target already has equipment, this will be created and equiped instead.
However, the AI may restore the other if it is better.

To use, include this file in a script.
Then call EquipWeapon, EquipArmor, and/or EquipMisc from the OnSpawn
Best used if spawned out of combat, otherwise they may not equip
Also, call these after any levelling has been done to use gained feats
If used on creatures with claws/bites/slams then the handed weapons will be
used instead of the natural weapons, even if they are inferior.
*/


#include "ref_inc_func"
#include "prc_gateway"
            /*
string FilledIntToString2(int nX)
{
    string sReturn = "";
    if (nX < 100)
        sReturn = sReturn + "0";
    if (nX < 10)
        sReturn = sReturn + "0";
    sReturn = sReturn + IntToString(nX);
    return sReturn;
}                  */

int GetCanEquipBaseItemType(int nType, object oObject)
{
    int nValue = TRUE;
    int j;
    for(j=0;j<5;j++)
    {
        string sReqFeat = Get2DACache("baseitems", "ReqFeat"+IntToString(j), nType);
        if(sReqFeat != "")
        {
            nValue = FALSE;
            if(GetHasFeat(StringToInt(sReqFeat), oObject))
            {
                nValue = TRUE;
                j = 100;
            }
        }
    }
    return nValue;
}

int GetShouldDualWeild(object oObject)
{
    int nScore = 0;
    if(GetHasFeat(FEAT_AMBIDEXTERITY,oObject))
        nScore += 10;
    if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING,oObject))
        nScore += 10;
    if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING,oObject))
        nScore += 20;
    if(GetHasFeat(374,oObject))//ranger dual-wielding
        nScore += 20;
    if(nScore+d20()>30)
        return TRUE;
    return FALSE;
}

int GetObjectWeildType(object oObject)
{
    //get type of weidling
    //0 = undecided yet
    //1 = sword'n'board
    //2 = dual weapons
    //3 = 2handed
    //4 = barehanded
    //5 = double ended weapons
    int nWeild = GetLocalInt(oObject, "WeildType");
    if(!nWeild)
    {
        if((GetLevelByClass(CLASS_TYPE_MONK, oObject)
                && RandomI(2)) //half of monks fight unarned
            || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oObject))
            || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oObject))
            || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oObject))) //any creature weapons are used
            nWeild = 4;
        else if((GetHasFeat(FEAT_SHIELD_PROFICIENCY, oObject)
                && RandomI(2))) //half of shield users fight with a shield (not all because a lot of classes get shield prof
            nWeild = 1;
        else if(GetShouldDualWeild(oObject))
        {
            if(RandomI(4)) //a quater use double ended
                nWeild = 5;
            else//rest use dual
                nWeild = 2;
        }
        else if(GetCreatureSize(oObject)+1 > CREATURE_SIZE_LARGE) //no huge or bigger weapons, so sword'n'board instead
            nWeild = 1;
        else
            nWeild = 3;//default to 2-handed
        SetLocalInt(oObject, "WeildType", nWeild);
    }
    return nWeild;
}

void DoScoreForBaseItemType(int nBaseItemType, object oObject)
{
//DoDebug("Running DoScoreForBaseItemType() on "+GetName(oObject));
    int nScore;
    if(GetCanEquipBaseItemType(nBaseItemType, oObject))
    {
//DoDebug(IntToString(nBaseItemType)+" is equipable");
        nScore += 100; //add a hundred for being equipable
        //adjust the value based on feats for it
        //DevCrit
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 7), oObject))
            nScore +=  500;
        //Weapon Specialization
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 7), oObject))
            nScore +=  100;
        //Weapon of Choice
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 6), oObject))
            nScore += 1000;
        //Weapon Focus
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 5), oObject))
            nScore +=  100;
        //Improved Critical
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 4), oObject))
            nScore +=  100;
        //Epic Weapon Specialization
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 3), oObject))
            nScore +=  100;
        //Epic Weapon Focus
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 2), oObject))
            nScore +=  100;
        //Overwhelming Crit
        if(GetHasFeat(GetFeatForBaseItem(nBaseItemType, 1), oObject))
            nScore +=  500;
    }
    if(nScore)
    {
        array_set_int(oObject, "REF_prefs_score",
            array_get_size(oObject, "REF_prefs_score"), nScore);
        array_set_int(oObject, "REF_prefs_type",
            array_get_size(oObject, "REF_prefs_type"), nBaseItemType);
        SetLocalInt(oObject, "REF_total",
            GetLocalInt(oObject, "REF_total")+nScore);
    }
}

void DoScores(int bRanged, int nSize, int nWeild, object oObject)
{
//DoDebug("Running DoScores() on "+GetName(oObject));
    //ranged weapons
    if(bRanged)
    {
        switch(nSize)
        {
            case CREATURE_SIZE_TINY:
                //should never have ranged tiny weapons
                //fall through to small
            case CREATURE_SIZE_SMALL:
                DoScoreForBaseItemType(BASE_ITEM_SHURIKEN,      oObject);
                DoScoreForBaseItemType(BASE_ITEM_DART,          oObject);
                DoScoreForBaseItemType(BASE_ITEM_LIGHTCROSSBOW, oObject);
                DoScoreForBaseItemType(BASE_ITEM_SLING,         oObject);
                DoScoreForBaseItemType(BASE_ITEM_THROWINGAXE,   oObject);
                break;
            case CREATURE_SIZE_MEDIUM:
                DoScoreForBaseItemType(BASE_ITEM_HEAVYCROSSBOW, oObject);
                DoScoreForBaseItemType(BASE_ITEM_SHORTBOW,      oObject);
                break;
            case CREATURE_SIZE_HUGE:
                //no such thing as a huge weapon, fall back to large
            case CREATURE_SIZE_LARGE:
                DoScoreForBaseItemType(BASE_ITEM_LONGBOW,       oObject);
                break;
        }
    }
    else
    {
        switch(nSize)
        {
            case CREATURE_SIZE_TINY:
                DoScoreForBaseItemType(BASE_ITEM_DAGGER, oObject);
                DoScoreForBaseItemType(BASE_ITEM_KUKRI, oObject);
                break;
            case CREATURE_SIZE_SMALL:
                DoScoreForBaseItemType(BASE_ITEM_WHIP, oObject);
                DoScoreForBaseItemType(BASE_ITEM_SICKLE, oObject);
                DoScoreForBaseItemType(BASE_ITEM_KAMA, oObject);
                DoScoreForBaseItemType(BASE_ITEM_HANDAXE, oObject);
                DoScoreForBaseItemType(BASE_ITEM_LIGHTHAMMER, oObject);
                DoScoreForBaseItemType(BASE_ITEM_LIGHTMACE, oObject);
                DoScoreForBaseItemType(BASE_ITEM_SHORTSWORD, oObject);
                break;
            case CREATURE_SIZE_MEDIUM:
                DoScoreForBaseItemType(BASE_ITEM_LONGSWORD, oObject);
                DoScoreForBaseItemType(BASE_ITEM_BATTLEAXE, oObject);
                DoScoreForBaseItemType(BASE_ITEM_LIGHTFLAIL, oObject);
                DoScoreForBaseItemType(BASE_ITEM_BASTARDSWORD, oObject);
                DoScoreForBaseItemType(BASE_ITEM_WARHAMMER, oObject);
                DoScoreForBaseItemType(BASE_ITEM_CLUB, oObject);
                DoScoreForBaseItemType(BASE_ITEM_KATANA, oObject);
                DoScoreForBaseItemType(BASE_ITEM_MORNINGSTAR, oObject);
                DoScoreForBaseItemType(BASE_ITEM_RAPIER, oObject);
                DoScoreForBaseItemType(BASE_ITEM_SCIMITAR, oObject);
                DoScoreForBaseItemType(BASE_ITEM_DWARVENWARAXE, oObject);
                break;
            case CREATURE_SIZE_HUGE:
                //no such thing as a huge weapon, fall back to large
            case CREATURE_SIZE_LARGE:
                //these are only used as large double-ended
                if(nSize == CREATURE_SIZE_LARGE
                    && nWeild == 5)
                {
                    DoScoreForBaseItemType(BASE_ITEM_DIREMACE, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_DOUBLEAXE, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_TWOBLADEDSWORD, oObject);
                }
                else
                {
                    DoScoreForBaseItemType(BASE_ITEM_GREATAXE, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_GREATSWORD, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_HALBERD, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_HEAVYFLAIL, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_QUARTERSTAFF, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_SCYTHE, oObject);
                    DoScoreForBaseItemType(BASE_ITEM_SHORTSPEAR, oObject);
                }
                break;
        }
    }
}

int GetHandItemType(object oObject = OBJECT_SELF, int bOffHand = FALSE, int bRanged = FALSE)
{
//Debug for speed test
//return BASE_ITEM_SHORTSWORD;
    int nOnHandType = GetLocalInt(oObject, "REF_onhand")-1;
    int nOffHandType = GetLocalInt(oObject, "REF_offhand")-1;
    int nRangedType = GetLocalInt(oObject, "REF_ranged")-1;
    //return if already set
    if(bRanged && nRangedType != -1)
        return nRangedType;
    else if(!bRanged && bOffHand && nOffHandType != -1)
        return nOffHandType;
    else if(!bRanged && !bOffHand && nOnHandType != -1)
        return nOnHandType;
    int nWeild = GetObjectWeildType(oObject);
    //check for unarmed types
    if(nWeild == 4) //unarmed
    {
        SetLocalInt(oObject, "REF_onhand", BASE_ITEM_INVALID+1);
        SetLocalInt(oObject, "REF_offhand", BASE_ITEM_INVALID+1);
        return BASE_ITEM_INVALID;
    }
    else if(nWeild == 2
        && bOffHand) //2handed offhand
    {
        SetLocalInt(oObject, "REF_offhand", BASE_ITEM_INVALID+1);
        return BASE_ITEM_INVALID;
    }
    else if(nWeild == 1
        && bOffHand) //sword and board offhand
    {
        if(GetHasFeat(FEAT_SHIELD_PROFICIENCY, oObject))
        {
            int nType;
            switch(RandomI(3))
            {
                default:
                case 0: nType = BASE_ITEM_SMALLSHIELD; break;
                case 1: nType = BASE_ITEM_LARGESHIELD; break;
                case 2: nType = BASE_ITEM_TOWERSHIELD; break;
            }
            SetLocalInt(oObject, "REF_offhand", nType+1);
            return nType;
        }
        SetLocalInt(oObject, "REF_offhand", BASE_ITEM_INVALID+1);
        return BASE_ITEM_INVALID;
    }
    else if((nWeild == 3        //2 handed
            || nWeild == 5)     //double ended
        && bOffHand)
    {
        SetLocalInt(oObject, "REF_offhand", BASE_ITEM_INVALID+1);
        return BASE_ITEM_INVALID;
    }

    if(bRanged
        && bOffHand) //ranged offhand
    {
        if(nOnHandType == BASE_ITEM_SLING
            && GetHasFeat(FEAT_SHIELD_PROFICIENCY, oObject))
        {
            int nType;
            switch(3)
            {
                case 0: nType = BASE_ITEM_SMALLSHIELD; break;
                case 1: nType = BASE_ITEM_LARGESHIELD; break;
                case 2: nType = BASE_ITEM_TOWERSHIELD; break;
            }
            SetLocalInt(oObject, "REF_offhand", nType+1);
            return nType;
        }
        SetLocalInt(oObject, "REF_offhand", BASE_ITEM_INVALID+1);
        return BASE_ITEM_INVALID;
    }
    //cleanup from before
    array_delete(oObject, "REF_prefs_score");
    array_delete(oObject, "REF_prefs_type");

    //make an array
    array_create(oObject, "REF_prefs_score");
    array_create(oObject, "REF_prefs_type");
    //add none as a start
    array_set_int(oObject, "REF_prefs_score",
        array_get_size(oObject, "REF_prefs_score"), 1);
    array_set_int(oObject, "REF_prefs_type",
        array_get_size(oObject, "REF_prefs_type"), BASE_ITEM_INVALID);
    SetLocalInt(oObject, "REF_total", 1);


    //work out optimum size
    int nSize = GetCreatureSize(oObject);
    //2handed or double in onhand, increase size
    if((nWeild == 3
            || nWeild == 5)
        && !bRanged
        && !bOffHand)
        nSize++;
    //ranged increase size in onhand
    else if(bRanged
        && !bOffHand)
        nSize++;
    //dual weilding, reduce size
    else if(nWeild == 2)
        nSize--;

    if(nSize < CREATURE_SIZE_TINY)
        nSize = CREATURE_SIZE_TINY;
    else if(nSize > CREATURE_SIZE_HUGE)
        nSize = CREATURE_SIZE_HUGE;

    while(nSize >= CREATURE_SIZE_TINY
        && GetLocalInt(oObject, "REF_total") == 1)
    {
        DoScores(bRanged, nSize, nWeild, oObject);
        nSize--;
    }

    int nTotal = GetLocalInt(oObject, "REF_total");
    int nType;
    //if no valid types, abort
    if(!nTotal)
        nType = BASE_ITEM_INVALID;
    else
    {
        //pick a random type from the array
        int nRandom = RandomI(nTotal);
        int i=0;
        int nSubTotal = array_get_int(oObject, "REF_prefs_score", i);
        while(nSubTotal < nRandom)
        {
            i++;
            nSubTotal+= array_get_int(oObject, "REF_prefs_score", i);
        }
        nType = array_get_int(oObject, "REF_prefs_type", i);
    }
    if(bRanged)
        SetLocalInt(oObject, "REF_ranged", nType+1);
    else if(!bOffHand && !bRanged)
        SetLocalInt(oObject, "REF_onhand", nType+1);
    else if(bOffHand && !bRanged)
        SetLocalInt(oObject, "REF_offhand", nType+1);
    return nType;
}
