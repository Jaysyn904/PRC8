#include "x2_inc_spellhook"
#include "prc_inc_sp_tch"

// Function to calculate the ranged attack bonus manually
int CalculateRangedAB(object oCaster)
{
    int nBAB = GetBaseAttackBonus(oCaster); // Get the base attack bonus of the caster
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCaster); // Get Dexterity modifier

    int nRangedAttackBonus = nBAB + nDexMod; // Ranged attack bonus is BAB + Dexterity modifier

    return nRangedAttackBonus;
}

// Function to handle the ranged attack
void ForceNeedleAttack(object oCaster, object oTarget, int nBonus)
{
    // Constants
    float fRange = FeetToMeters(5.0 * IntToFloat(nBonus)); // Range is 5 feet per spell level
    
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);

    // Get the distance to the target and check if it's within range
    float fDistance = GetDistanceBetween(oCaster, oTarget);
    if (fDistance > fRange)
    {
        SendMessageToPC(oCaster, "Target is out of range.");
        return;
    }

    // Calculate ranged attack bonus
    int nRangedAttackBonus = CalculateRangedAB(oCaster);

    // Check if the caster has Point Blank Shot feat and is within 30 feet of the target
    if (GetHasFeat(FEAT_POINT_BLANK_SHOT, oCaster) && fDistance <= FeetToMeters(30.0)) // Within 30 feet for PBS bonus
    {
        nRangedAttackBonus += 1;
    }

    // Perform a standard ranged attack roll (not a ranged touch attack)
    int nDieRoll = d20(1);
    int nAttackRoll = nDieRoll + nRangedAttackBonus;
    int nAC = GetAC(oTarget); // Get the target's AC for a normal ranged attack

    // Construct the attack roll message in the format of NWN combat log
    string sMessage;
    string sCasterName = GetName(oCaster);
    string sTargetName = GetName(oTarget);
    
    if (nAttackRoll >= nAC)
    {
        // If the attack hits, deal damage based on the highest force spell level
        int nDamage = d4(nBonus); // Deal 1d4 damage per force spell level
		nDamage += SpellSneakAttackDamage(oCaster, oTarget);

        // Handle critical hit on a natural 20
        if (nDieRoll == 20)
        {
            nDamage *= 2;
            sMessage = PRC_TEXT_LIGHT_BLUE + sCasterName + PRC_TEXT_ORANGE +" attacks " + sTargetName + ": *critical hit* " + "(" + IntToString(nDieRoll) + " + " + IntToString(nRangedAttackBonus) + " = " + IntToString(nAttackRoll) + ")";
        }
        else
        {
            sMessage = PRC_TEXT_LIGHT_BLUE + sCasterName + PRC_TEXT_ORANGE +" attacks " + sTargetName + ": *hit* " + "(" + IntToString(nDieRoll) + " + " + IntToString(nRangedAttackBonus) + " = " + IntToString(nAttackRoll) + ")";
        }

        // Apply the MIRV and damage effect
        effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL);
        
        // Delay visual effects to simulate missile travel
        float fDelay = fDistance / (3.0 * log(fDistance) + 2.0);
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 0.0f, FALSE));
        DelayCommand(fDelay + 0.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));

        DelayCommand(fDelay + 0.2, SendMessageToPC(oCaster, sMessage));
    }
    else
    {
        // If the attack misses
        sMessage = PRC_TEXT_LIGHT_BLUE + sCasterName + PRC_TEXT_ORANGE + " attacks " + sTargetName + ": *miss* " + "(" + IntToString(nDieRoll) + " + " + IntToString(nRangedAttackBonus) + " = " + IntToString(nAttackRoll) + ")";
        SendMessageToPC(oCaster, sMessage);
    }
}

void main()
{
    // Declare major variables
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nBonus = GetLocalInt(oPC, "InvisibleNeedleBonus");
    
    if (!GetLocalInt(oPC, "InvisibleNeedleBonus")) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    ForceNeedleAttack(oPC, oTarget, nBonus);
}
