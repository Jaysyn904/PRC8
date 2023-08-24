/*
  Spirit Strike
  prc_iaijutsu_spr
*/

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oWeap = GetFirstItemInInventory(oPC);
    int iMainHand;
    int iNumDice;
    int iNumSides;
    int nDamage = 0;
    int iChaMod = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iSkill = GetSkillRank(SKILL_IAIJUTSU_FOCUS,oPC)+ d20(); //Iaijutsu Focus Check
    string OneKat;
    int iDie = 0;

    SetLocalInt(oPC,OneKat,0);

    //Calculate Bonus Damage
    iDie = iSkill / 5;
    if(iDie > 0) //if iaijutsu check was successful
    {
        if(!GetHasFeat(FEAT_EPIC_IAIJUTSU_FOCUS)) //If not epic iaijutsu
            if(iDie > 9)
                iDie = 9;

        nDamage = d6(iDie);

        if(GetHasFeat(FEAT_STRIKE_VOID)) nDamage = nDamage + iChaMod*iDie;
        // Only works on flatfooted foes
        if (!GetIsDeniedDexBonusToAC(oTarget, oPC)) nDamage = 0;
    }

    //Begin Attack Scripting
    if(oTarget != oPC)
    {
        if(!GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
        {

            //Searching for a single Katana
            while(GetIsObjectValid(oWeap) && GetLocalInt(oPC,OneKat) == 0)
            {

                if(GetBaseItemType(oWeap) == BASE_ITEM_KATANA
                    || // Hack - Assume a Soulknife with Iaijutsu Master levels using bastard sword shape has it shaped like a katana
                   (GetStringLeft(GetTag(oWeap), 14) == "prc_sk_mblade_" && GetBaseItemType(oWeap) == BASE_ITEM_BASTARDSWORD)
                   )
                {

                    int iCriticalMultiplier = GetWeaponCritcalMultiplier(oPC, oWeap);
                    struct BonusDamage sWeaponBonusDamage = GetWeaponBonusDamage(oWeap, oTarget);
                    struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oPC, oTarget);
                    int iWeapDamage = GetWeaponDamagePerRound(oTarget, oPC, oWeap, 0);
                    int iAttackBonus = GetAttackBonus(oTarget, oPC, oWeap, 0);
                    int iWeapEnch = GetDamagePowerConstant(oWeap, oTarget, oPC);
                    int iAttack = GetAttackRoll(oTarget, oPC, oWeap, 0, iAttackBonus, 0, TRUE, 0.0);
                    SetLocalInt(oPC,OneKat,1);

                    if(iAttack == 2)
                    {
                        effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, TRUE, 0, 0, iCriticalMultiplier);
                        effect eDam = EffectDamage(nDamage,DAMAGE_TYPE_SLASHING,iWeapEnch);
                        effect eLink = EffectLinkEffects(eDam, eDamage);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
                        FloatingTextStringOnCreature("Critical Spirit Strike",OBJECT_SELF);
                    }

                    if(iAttack == 1)
                    {
                        effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, FALSE, 0, 0, iCriticalMultiplier);
                        effect eDam = EffectDamage(nDamage,DAMAGE_TYPE_SLASHING,iWeapEnch);
                        effect eLink = EffectLinkEffects(eDam, eDamage);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
                        FloatingTextStringOnCreature("Spirit Strike",OBJECT_SELF);
                    }
                }
                oWeap = GetNextItemInInventory(oPC);
            }
        }
    }
}
