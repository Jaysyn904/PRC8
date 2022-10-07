// Favoured Soul passive abilities.
// Resist 3 elements, DR, Weapon Focus/Spec

#include "prc_inc_wpnrest"
#include "pnp_shft_poly"

void ResistElement(object oPC, object oSkin, int iLevel, int iType, string sVar)
{
    if(GetLocalInt(oSkin, sVar) == iLevel)
        return;

    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(iType, iLevel), oSkin));
    SetLocalInt(oSkin, sVar, iLevel);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC);

    if(nClass > 4)
    {
        string sVar = "FavouredSoulResistElement";
        if (GetHasFeat(FEAT_FAVOURED_SOUL_ACID, oPC))
        {
            sVar += "Acid";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ACID, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_COLD, oPC))
        {
            sVar += "Cold";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_COLD, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_ELEC, oPC))
        {
            sVar += "Elec";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ELECTRICAL, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_FIRE, oPC))
        {
            sVar += "Fire";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_FIRE, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_SONIC, oPC))
        {
            sVar += "Sonic";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_SONIC, sVar);
        }
    }

    // Wings
    if(nClass > 16)
    {
        int nAlign = GetAlignmentGoodEvil(oPC);
        int nWings = nAlign == ALIGNMENT_EVIL ? CREATURE_WING_TYPE_DEMON:
                     nAlign == ALIGNMENT_GOOD ? CREATURE_WING_TYPE_ANGEL:
                     CREATURE_WING_TYPE_BIRD;
        //use this wrapper to make sure it interacts with polymorph etc correctly
        DoWings(oPC, nWings);
    }

    // Damage Reduction
    if(nClass > 19)
    {
        if(GetLocalInt(oSkin, "FavouredSoulDR"))
            return;

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_3, IP_CONST_DAMAGESOAK_10_HP), oSkin);
        SetLocalInt(oSkin, "FavouredSoulDR", TRUE);
    }

    // This gives them proficiency in the chosen weapon
    if(nClass > 2)
    {
        int nBaseItem;
        int nIprop;

        if(GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BASTARD_SWORD   );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BATTLE_AXE      );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_CLUB            );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DAGGER          );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DART            );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DIRE_MACE       );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DOUBLE_AXE      );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DWAXE           );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_AXE       );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_SWORD     );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HALBERD         );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HAND_AXE        );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW  );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_FLAIL     );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KAMA            );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KATANA          );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KUKRI           );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW  );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_FLAIL     );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_HAMMER    );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_MACE      );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONG_SWORD      );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONGBOW         );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_MORNING_STAR    );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_RAPIER          );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCIMITAR        );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCYTHE          );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORT_SWORD     );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORTBOW        );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHURIKEN        );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SICKLE          );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SLING           );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SPEAR           );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_STAFF           );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_THROWING_AXE    );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WAR_HAMMER      );
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WHIP            );

        if(!IsProficient(oPC, nBaseItem))
        {
            nIprop = GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem));
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }

    // Do Weapon spec
    if(nClass > 11)
    {
        if     (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,    oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE,       IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE,       oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_CLUB,             IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB,             oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER,           IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER,           oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_DART,             IP_CONST_FEAT_WEAPON_SPECIALIZATION_DART,             oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_DIRE_MACE,        IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE,        oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE,       IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE,       oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_DWAXE,            IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE,            oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_AXE,        IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE,        oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD,      IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD,      oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_HALBERD,          IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD,          oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_HAND_AXE,         IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE,         oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,   IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,   oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL,      IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL,      oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_KAMA,             IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA,             oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_KATANA,           IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA,           oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_KUKRI,            IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI,            oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,   IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,   oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL,      IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL,      oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,     IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,     oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE,       IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE,       oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LONG_SWORD,       IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD,       oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,          IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONGBOW,          oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_MORNING_STAR,     IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR,     oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER,           IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER,           oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SCIMITAR,         IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR,         oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SCYTHE,           IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE,           oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD,      IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD,      oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,         IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORTBOW,         oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SHURIKEN,         IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHURIKEN,         oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SICKLE,           IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE,           oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SLING,            IP_CONST_FEAT_WEAPON_SPECIALIZATION_SLING,            oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_SPEAR,            IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR,            oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_STAFF,            IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF,            oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_THROWING_AXE,     IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE,     oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,       IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,       oSkin, oPC);
        else if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)) AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_WHIP,             IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP,             oSkin, oPC);
    }
}




/*

FocusToWeapProf(FEAT_WEAPON_FOCUS_BASTARD_SWORD   ); AddSkinFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD,    GetWeaponProfIPFeat(FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_BATTLE_AXE      ); AddSkinFeat(FEAT_WEAPON_PROFICIENCY_BATTLEAXE,    GetWeaponProfIPFeat(FEAT_WEAPON_PROFICIENCY_BATTLEAXE),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_CLUB            ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_DAGGER          ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_DART            ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_DIRE_MACE       ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_DOUBLE_AXE      ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_DWAXE           ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_AXE       ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_SWORD     ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_HALBERD         ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_HAND_AXE        ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW  ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_FLAIL     ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_KAMA            ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_KATANA          ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_KUKRI           ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW  ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_FLAIL     ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_HAMMER    ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_MACE      ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LONG_SWORD      ); AddSkinFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD,    GetWeaponProfIPFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_LONGBOW         ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_MORNING_STAR    ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_RAPIER          ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SCIMITAR        ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SCYTHE          ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORT_SWORD     ); AddSkinFeat(FEAT_WEAPON_PROFICIENCY_SHORTSWORD,    GetWeaponProfIPFeat(FEAT_WEAPON_PROFICIENCY_SHORTSWORD),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORTBOW        ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SHURIKEN        ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SICKLE          ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SLING           ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_SPEAR           ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_STAFF           ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_THROWING_AXE    ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_WAR_HAMMER      ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);
 FocusToWeapProf(FEAT_WEAPON_FOCUS_WHIP            ); AddSkinFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem)),    oSkin, oPC);



*/



























                                                                                                                                