//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: X2_S0_PersBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, float fDuration, int nClass)
{
    //Declare major variables
    int nStat = nClass == CLASS_TYPE_INVALID ?
                 GetAbilityModifier(ABILITY_CHARISMA, oCaster) ://if cast from items use charisma by default
                 GetDCAbilityModForClass(nClass, oCaster);
    nStat /= 2;
    // GZ: Just in case...
    if(nStat > 20)
        nStat = 20;
    else if(nStat < 1)
        nStat = 1;

    object oWeapon;
    string sWeapon = "NW_WSWDG001";
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    int i = 1;
    while(GetIsObjectValid(oSummon))
    {
        if(GetResRef(oSummon) == "X2_S_FAERIE001")
        {
            if(!GetIsObjectValid(GetItemPossessedBy(oSummon, sWeapon)))
            {
                //Create item on the creature, epuip it and add properties.
                oWeapon = CreateItemOnObject(sWeapon, oSummon);
                // GZ: Fix for weapon being dropped when killed
                SetDroppableFlag(oWeapon, FALSE);
                AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon, fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_5_HP), oWeapon, fDuration);
            }
        }
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nClass = PRCGetLastSpellCastClass();
    int nDuration = PRCGetCasterLevel(oCaster) / 2;
    int nSwitch = GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);

    if(nDuration < 1)
        nDuration = 1;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;   //Duration is +100%
    float fDuration = nSwitch ? RoundsToSeconds(nDuration * nSwitch):
                                 TurnsToSeconds(nDuration);

    effect eSummon = EffectSummonCreature("X2_S_FAERIE001");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget);

    DelayCommand(1.0, spellsCreateItemForSummoned(oCaster, fDuration, nClass));

    PRCSetSchool();
}