
//nBase is BASE_ITEM_*
//nType     = 1 Overwhelming Crit
//          = 2 Epic Weapon Focus
//          = 3 Epic Weapon Specialization
//          = 4 Improved Critical
//          = 5 Weapon Focus
//          = 6 Weapon of Choice
//          = 7 Weapon Specialization
//          = 8 DevCrit 
int GetFeatForBaseItem(int nBase, int nType);

#include "prc_inc_combat"

int GetFeatForBaseItem(int nBase, int nType)
{
    switch(nType)
    {
        case 1: return GetFeatByWeaponType(nBase, "OverwhelmingCrit"); break;
        case 2: return GetFeatByWeaponType(nBase, "EpicFocus"); break;
        case 3: return GetFeatByWeaponType(nBase, "EpicSpecialization"); break;
        case 4: return GetFeatByWeaponType(nBase, "ImprovedCrit"); break;
        default: //default to weapon focus
        case 5: return GetFeatByWeaponType(nBase, "Focus"); break;
        case 6: return GetFeatByWeaponType(nBase, "WeaponOfChoice"); break;
        case 7: return GetFeatByWeaponType(nBase, "Specialization"); break;
        case 8: return GetFeatByWeaponType(nBase, "DevastatingCrit"); break;
    }
    //just in case you ever get here
    return -1;
}
