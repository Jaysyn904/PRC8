/*
This is the edited script I had made changes to before Silver reverted to
the original. It has:

Round delays for metabreath/multiple uses
Line breath (working)
Pyroclastic being 50% of each
PRCGetReflexAdjustedDamage to interact better with other systems
Range dependant on size
Less code duplication by using dedicated functions. Easier to fix/find bugs.
Moved breath VFX so when different ones for different colors are done they can be easily implemented

Moved to a new script so its not lost permanently. Feel free to refer to this if you want.

Primogenitor

//:: edited by Fox on 1/19/08

Script has been rewritten to use the new breath include.  Most of the above has 
been subsumed into said include where appropriate.

//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Silver)
//:: Created On: June, 17, 2003 (June, 7, 2005)
//:://////////////////////////////////////////////
*/
#include "prc_inc_spells"
#include "prc_inc_breath"
#include "prc_inc_combat"

//////////////////////////
// Constant Definitions //
//////////////////////////


int IsLineBreath()
{
    object oDD = OBJECT_SELF;
    if(GetHasFeat(FEAT_BLACK_DRAGON, oDD)
        || GetHasFeat(FEAT_BLUE_DRAGON, oDD)
        || GetHasFeat(FEAT_BRASS_DRAGON, oDD)
        || GetHasFeat(FEAT_BRONZE_DRAGON, oDD)
        || GetHasFeat(FEAT_COPPER_DRAGON, oDD)
        || GetHasFeat(FEAT_AMETHYST_DRAGON, oDD)
        || GetHasFeat(FEAT_BROWN_DRAGON, oDD)
        || GetHasFeat(FEAT_CHAOS_DRAGON, oDD)
        || GetHasFeat(FEAT_OCEANUS_DRAGON, oDD)
        || GetHasFeat(FEAT_RADIANT_DRAGON, oDD)
        || GetHasFeat(FEAT_RUST_DRAGON, oDD)
        || GetHasFeat(FEAT_STYX_DRAGON, oDD)
        || GetHasFeat(FEAT_TARTIAN_DRAGON, oDD)
        )
        return TRUE;
    return FALSE;
}

//Returns range in feet for breath struct. Conversion to meters is
//handled internally in the include
float GetRangeFromSize(int nSize)
{
    float fRange = 30.0;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:
        case CREATURE_SIZE_DIMINUTIVE:
        case CREATURE_SIZE_TINY:        fRange = 15.0; break;
        case CREATURE_SIZE_SMALL:       fRange = 20.0; break;
        case CREATURE_SIZE_MEDIUM:      fRange = 30.0; break;
        case CREATURE_SIZE_LARGE:       fRange = 40.0; break;
        case CREATURE_SIZE_HUGE:        fRange = 50.0; break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = 60.0; break;
        case CREATURE_SIZE_COLOSSAL:    fRange = 70.0; break;
    }
    return fRange;
}

void BreathRecharge(object oPC)
{
    IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
    SendMessageToPC(oPC, "Your breath weapon is ready now");
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC);
    location lTarget = PRCGetSpellTargetLocation();
    struct breath DiscBreath;
    int bLine = IsLineBreath();
    int nVis;

    //range calculation
    float fRange = GetRangeFromSize(PRCGetCreatureSize(oPC));
    if(bLine) fRange *= 2.0;

    //Li Lung dragons have a 'roar' instead of breath weapon
    /*if(GetHasFeat(FEAT_LI_LUNG_DRAGON, oPC))
    {
        if(nUses < 3)
        {
            IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
            nUses++;
            lTarget = GetLocation(oPC);
            fRange = FeetToMeters(fRange);
            float fDuration = RoundsToSeconds(nLevel);
            PlaySound("c_dragnold_atk1");
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), lTarget);

            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, fDuration));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));

                oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
            }
            SetLocalInt(oPC, SPECIAL_BREATH_USES, nUses);
        }
        return;
    }
    else if(GetHasFeat(FEAT_FANG_DRAGON, oPC))
    {
        
        else if(nUses < 2)
        {
            IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
            nUses++;
            object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
            int AttackRoll = GetAttackRoll(oTarget, oPC, oBite);
            int nDamage = d4(1) * AttackRoll;

            if(nDamage)
            {
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_PERMANENT, TRUE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
            }
            SetLocalInt(oPC, SPECIAL_BREATH_USES, nUses);
        }
        return;
    }*/

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 DD level.  Gains +1 at level 13, and every 3 levels after.
    int nSaveDCBonus = ((nLevel)/2) + PRCMax((nLevel - 10) / 3, 0);

    //Sets damage levels for Dragon Breath attacks.  2d10 at level 3,
    //4d10 at level 7, and then an additional 2d10 every 3 levels (10, 13, 16, ect)
    int nDice;
    
    if (nLevel >= 3) nDice += 2;
    if (nLevel >= 7) nDice += 2;
    if (nLevel >= 10) nDice += 2;
    if (nLevel >= 13) nDice += 2;
    if (nLevel >= 16) nDice += 2;
    if (nLevel >= 19) nDice += 2;
    if (nLevel >= 22) nDice += 2;
    if (nLevel >= 25) nDice += 2;
    if (nLevel >= 28) nDice += 2;

    //Only Dragons with Breath Weapons will have damage caused by their breath attack.
    //Any Dragon type not listed here will have a breath attack, but it will not
    //cause damage or create a visual effect.
    int DBREED = GetHasFeat(FEAT_RED_DRAGON,       oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_BRASS_DRAGON,     oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_GOLD_DRAGON,      oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC) ? DAMAGE_TYPE_FIRE :
                 GetHasFeat(FEAT_BLACK_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_GREEN_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_COPPER_DRAGON,    oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_BROWN_DRAGON,     oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_DEEP_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_RUST_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_STYX_DRAGON,      oPC) ? DAMAGE_TYPE_ACID :
                 GetHasFeat(FEAT_SILVER_DRAGON,    oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_WHITE_DRAGON,     oPC) ? DAMAGE_TYPE_COLD :
                 GetHasFeat(FEAT_BLUE_DRAGON,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_BRONZE_DRAGON,    oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_OCEANUS_DRAGON,   oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_SONG_DRAGON,      oPC) ? DAMAGE_TYPE_ELECTRICAL :
                 GetHasFeat(FEAT_EMERALD_DRAGON,   oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_SAPPHIRE_DRAGON,  oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_BATTLE_DRAGON,    oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_HOWLING_DRAGON,   oPC) ? DAMAGE_TYPE_SONIC :
                 GetHasFeat(FEAT_CRYSTAL_DRAGON,   oPC) ? DAMAGE_TYPE_POSITIVE :
                 GetHasFeat(FEAT_AMETHYST_DRAGON,  oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_TOPAZ_DRAGON,     oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_ETHEREAL_DRAGON,  oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_RADIANT_DRAGON,   oPC) ? DAMAGE_TYPE_MAGICAL :
                 GetHasFeat(FEAT_TARTIAN_DRAGON,   oPC) ? DAMAGE_TYPE_MAGICAL :
                -1;

    if(GetHasFeat(FEAT_CHAOS_DRAGON, oPC))
    {
        //Sets the random Element factor of the Chaos Dragons Breath Weapon.
        //Affects damage, saving throw, and impact visual.
        switch(Random(5))
        {
            case 0: DBREED = DAMAGE_TYPE_COLD; break;
            case 1: DBREED = DAMAGE_TYPE_ACID; break;
            case 2: DBREED = DAMAGE_TYPE_FIRE; break;
            case 3: DBREED = DAMAGE_TYPE_SONIC; break;
            case 4: DBREED = DAMAGE_TYPE_ELECTRICAL; break;
        }
    }

    DiscBreath = CreateBreath(oPC, bLine, fRange, DBREED, 10, nDice, ABILITY_CONSTITUTION, nSaveDCBonus);

    //activate override for special breath weapons
    DiscBreath.nOverrideSpecial = GetHasFeat(FEAT_SHADOW_DRAGON, oPC)      ? BREATH_SHADOW :
                                  GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC) ? BREATH_PYROCLASTIC :
                                  GetHasFeat(FEAT_TOPAZ_DRAGON, oPC)       ? BREATH_TOPAZ :
                                  0;

    //vfx
    switch(DBREED)
    {
        case DAMAGE_TYPE_FIRE:       nVis = VFX_FNF_DRAGBREATHGROUND; break;
        case DAMAGE_TYPE_ACID:       nVis = VFX_FNF_DRAGBREATHACID;   break;
        case DAMAGE_TYPE_COLD:       nVis = VFX_FNF_DRAGBREATHCOLD;   break;
        case DAMAGE_TYPE_ELECTRICAL: nVis = VFX_FNF_DRAGBREATHMIND;   break;//VFX_FNF_DRAGBREATHELEC
        case DAMAGE_TYPE_SONIC:      nVis = VFX_FNF_DRAGBREATHSONIC;  break;
        case DAMAGE_TYPE_POSITIVE:   nVis = VFX_FNF_DRAGBREATHHOLY;   break;
        default:                     nVis = VFX_FNF_DRAGBREATHODD;    break;
    }

    //actual breath effect
    ApplyBreath(DiscBreath, lTarget);

    //breath VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), lTarget);

    if(GetHasFeat(FEAT_FULL_DRAGON_BREATH, oPC))
    {
        // Schedule opening the delay lock
        float fDelay = RoundsToSeconds(DiscBreath.nRoundsUntilRecharge);
        SendMessageToPC(oPC, "Your breath weapon will be ready again in " + IntToString(DiscBreath.nRoundsUntilRecharge) + " rounds.");

        DelayCommand(fDelay, BreathRecharge(oPC));
    }
}