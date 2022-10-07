//#include "prc_alterations"
#include "prc_weap_apt"
#include "tob_inc_tobfunc"

void WeaponAptitude(object oPC)
{
    //Reapply weapon aptitude if it gets unapplied (for instance, 
    //if shifting from one form to another removes the feats from
    //the PC's skin).
    int nAppliedPC = GetLocalInt(oPC, "PRC_WEAPON_APTITUDE_APPLIED");
    int nAppliedSkin = GetLocalInt(GetPCSkin(oPC), "PRC_WEAPON_APTITUDE_APPLIED");
    if(nAppliedPC && !nAppliedSkin)
        ApplyWeaponAptitude(OBJECT_SELF, TRUE);
}

void BattleClarity(object oPC)
{
    int nSave = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    // Can't be negative.
    if (0 > nSave) nSave = 0;
    // INT to Reflex saves
    SetCompositeBonus(GetPCSkin(oPC), "BattleClarity", nSave, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
    if (DEBUG) DoDebug("Battle Clarity applied: " + IntToString(nSave));
}
// Supposed to only apply to AoOs
void BattleMastery(object oPC)
{
    int nAttackBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    // Can't be negative.
    if (0 > nAttackBonus) nAttackBonus = 0;
    // INT to Attack Bonus
    SetCompositeAttackBonus(oPC, "BattleMastery", nAttackBonus);
    if (DEBUG) DoDebug("Battle Mastery applied: " + IntToString(nAttackBonus));
}

void main()
{
    object oPC = OBJECT_SELF;
    int nWarbladeLevels = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);
    if (nWarbladeLevels >= 1)
    {
        WeaponAptitude(oPC);
        BattleClarity(oPC);
    }
    /*if (nWarbladeLevels >= 15)
        BattleMastery(oPC);*/
}