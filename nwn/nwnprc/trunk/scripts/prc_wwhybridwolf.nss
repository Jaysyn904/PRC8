//::///////////////////////////////////////////////
//:: Turns player into a werewolf
//:: prc_wwhybridwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:: Updated On: 2012 11-27 (Added Switch for PnP Shifter Polymorphing instead of Bioware)
//:://////////////////////////////////////////////

#include "pnp_shft_poly"
#include "prc_inc_template"
#include "prc_inc_wwolf"

// Creates the target Hybrid Form creature that the PC will transform into
object PnP_WereWolfHybridShifting_BuildTarget(object oPC);

// Removes the 1st standard Invisiblity effect from the PC after using PnP Shifter shifting
void PRC_StripWereWolfInvis(object oPC);


void main()
{
    object oPC = OBJECT_SELF;
    int nPoly;
    int bTemplate = PRCWWHasTemplate(oPC);
    int bDirectTemplateChange = bTemplate
        && GetLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME) == PRC_WW_FORM_HYBRID;

    // Retrieve Module flag 
    int iPnPShifterShapchange = GetPRCSwitch(PRC_WEREWOLF_HYBRID_USE_SHIFTER_SHAPECHANGE);

    if(GetLocalInt(oPC, "WWHybrid") != TRUE)
    {
        if(GetLocalInt(oPC, "WWWolf"))
        {
            if(!bTemplate)
            {
                FloatingTextStringOnCreature(
                    "Return to humanoid form before assuming hybrid form.",
                    oPC, FALSE);
                return;
            }

            // D&D 3.0 permits animal <-> hybrid as one voluntary standard
            // action. The helper rolls once, genuinely restores true form,
            // then applies this destination after the engine teardown settles.
            PRCWWStartFormSwitch(oPC, PRC_WW_FORM_HYBRID);
            return;
        }

        // Existing class characters still need the old level-2 feature.
        if(!bTemplate && !GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
        {
            FloatingTextStringOnCreature("You can only assume your hybrid form if you are at least level 2 in the werewolf class", oPC, FALSE);
            return;
        }

        if(bTemplate && !bDirectTemplateChange
        && !PRCWWCanChange(oPC, FALSE))
            return;

        if(bTemplate)
        {
            // Like PRC PnP shifting, change the body without unequipping or
            // merging real gear. Keep the template's fixed traits and its
            // own Control Shape/episode lifecycle, not shifter class stats.
            PRCWWBeginFormTransition(oPC);
            if(!PRCWWApplyHybrid(oPC))
            {
                PRCWWRemoveHybrid(oPC);
                if(bDirectTemplateChange)
                    SetLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED, TRUE);
                else
                    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
                PRCWWQueueFormTransitionEval(oPC);
                FloatingTextStringOnCreature(
                    "Hybrid form could not be applied; your existing form and equipment are preserved.",
                    oPC, FALSE);
                return;
            }

            SetLocalInt(oPC, "WWHybrid", TRUE);
            if(!bDirectTemplateChange)
                PRCWWOnAssumeForm(oPC);
            PRCWWApplyFormProperties(oPC, TRUE);
            DelayCommand(0.1, PRCWWRefreshHybridForm(oPC));
            PRCWWQueueFormTransitionEval(oPC);
            return;
        }

        if(!iPnPShifterShapchange) // Use Bioware Polymorph effect
        {
            nPoly = POLYMORPH_TYPE_WEREWOLF_0s;

            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1))
                nPoly = POLYMORPH_TYPE_WEREWOLF_1s;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2))
                nPoly = POLYMORPH_TYPE_WEREWOLF_2s;
            if(GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WEREWOLF_0l;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WEREWOLF_1l;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WEREWOLF_2l;
            LycanthropePoly(oPC, nPoly, TRUE);
            SetLocalInt(oPC, "WWHybrid", TRUE);
        } // END Polymorph Shifting

        else // Use PnP Shifter Shape Change
        {
            // Check if we can transform
            if (!CanShift(oPC))
                return;
        
            //check if a shifter (or morphed-werewolf) and if shifted then unshift
            ShifterCheck(oPC);
            ClearAllActions(); // prevents an exploit (taken from shifter code), PC is OBJECT_SELF, so no need to Assign this action
        
            // Create target Creature to transform into, based on the PC's Werewolf class feats
            object oCreature = PnP_WereWolfHybridShifting_BuildTarget(oPC);

            if (!GetIsObjectValid(oCreature))
            {
                FloatingTextStringOnCreature("Unable to create Werewolf Hybrid Form template creature. Aborting transformation!", oPC, FALSE);
                return;
            }

            // Call the Transformation into the target creature
            SetShift(oPC,oCreature); // Will automatically delete the target creatue after the shift is completed

            // Set Shifted Flag
            SetLocalInt(oPC, "WWHybrid", TRUE);

            // Remove the 1st normal invisibility effect that we can find on the werewolf, since the shifting will provide one
            // Delayed so it occurs after shifting is completed
            DelayCommand(2.0,PRC_StripWereWolfInvis(oPC));
        } // END PnP Werewolf Shifting
    } // END Transform to Hybrid

    // Currently in Hybrid Form, so unpolymorph
    // PnP Unshift handed in prc_wwunpoly
    else
    {
        if(bTemplate && !PRCWWCanChange(oPC, TRUE))
            return;

        ExecuteScript("prc_wwunpoly", oPC);
        if(bTemplate && PRCWWHasTemplateFormEffect(oPC))
            return;

        DeleteLocalInt(oPC, "WWHybrid");
        if(bTemplate)
            PRCWWOnReturnHumanoid(oPC);
    } // END Unpolymorph from Hybrid form
}


// PnP Werewolf Shifting, Target Form
// Creates the target Hybrid Form creature that the PC will transform into
// Uses the PC's Werewolf feats to create the target creature
object PnP_WereWolfHybridShifting_BuildTarget(object oPC)
{
    object oCreature;

    // Get the waypoint in Limbo where shifting template creatures are spawned
    object oSpawnWP = GetWaypointByTag(SHIFTING_TEMPLATE_WP_TAG);
    // Paranoia check - the WP should be built into the area data of Limbo
    if(!GetIsObjectValid(oSpawnWP))
    {
        if(DEBUG) DoDebug("prc_inc_shifting: ShiftIntoResRef(): ERROR: Template spawn waypoint does not exist.");
        // Create the WP
        oSpawnWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, SHIFTING_TEMPLATE_WP_TAG);
    }

    // Get the WP's location
    location lLimbo  = GetLocation(oSpawnWP);

    // Create the target creature (in Limbo) by copying the PC
    oCreature = CopyObject(oPC, lLimbo, OBJECT_INVALID, "PRC_WereWolf_Hybrid_PnP_Template");

    // Abort creation if we can't make the target
    if(!GetIsObjectValid(oCreature))
        return OBJECT_INVALID;

    // Strip the created creature of all items, objects and effects    

    // remove inventory contents from created creature
    object oItem = GetFirstItemInInventory(oCreature);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oCreature);
    }
    // remove all equipped items from created creature
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oCreature);
        if(GetIsObjectValid(oItem))
        {
            SetPlotFlag(oItem,FALSE);
            DestroyObject(oItem);
        }
    }

    // Remove all gold from creature
    TakeGoldFromCreature(GetGold(oCreature), oCreature, TRUE);

    SetLootable(oCreature, FALSE);

    // Remove all effects from creature
    effect eEff = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eEff))
    {
        RemoveEffect(oCreature, eEff);
        eEff = GetNextEffect(oCreature);
    }

    // Determine polymorph target in the same way as the Bioware Polymorph werewolf
    // Check PC for the various Werewolf feats
    int nPoly = POLYMORPH_TYPE_WEREWOLF_0s;

    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1,oPC))
    {
        nPoly = POLYMORPH_TYPE_WEREWOLF_1s;
    }
    if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2,oPC))
    {
        nPoly = POLYMORPH_TYPE_WEREWOLF_2s;
    }
    if (GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3,oPC))
    {
        nPoly = POLYMORPH_TYPE_WEREWOLF_0l;
    }
    if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1,oPC)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3,oPC))
    {
        nPoly = POLYMORPH_TYPE_WEREWOLF_1l;
    }
    if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2,oPC)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3,oPC))
    {
        nPoly = POLYMORPH_TYPE_WEREWOLF_2l;
    }

    // Instead of transforming the PC directly, polymorph the newly created creature in the same way the PC would have been changed
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPolymorph(nPoly), oCreature);

    // Most of the below bonuses will already be included in the newly polymorphed creature, 
    // however some will not due to the fixed nature of polymorphing into a specific creature 
    // with pre-set stats, so now we set expected bonuses and then adjust the target to meet the goal numbers

    // Strength, Dexterity, Constitution & Natural AC bonuses from Werewolf forms
    int iStrBoost, iDexBoost, iConBoost, iNaturalArmor;

    // oCreature Skin
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);

    // Wolf Class, Level 2 Bonuses
    // Dex + 4, Con + 2 (more), Alertness, Knockdown 
    // (Alertness and Knockdown are actually provided inherantly at 4th class level, not by Wolf Class, so they are not included here)
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2))
    {
        iDexBoost = 4;
        iStrBoost = 2;
        iConBoost = 4;
        iNaturalArmor = 2;
    }

    // Wolf Class, Level 1 Bonuses
    // Str + 2, Con + 2, Natural Armor + 2, Creature attacks
    // (Creature attacks are included in the polymorph)
    else if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1))
    {
        iStrBoost = 2;
        iConBoost = 2;
        iNaturalArmor = 2;
    }

    // Compare the raw PC ability scores to the (already modified via polymorph) target creature ablity scores and adjust as needed to get the final expected bonuses
    iDexBoost = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) + iDexBoost - GetAbilityScore(oCreature, ABILITY_DEXTERITY);
    iStrBoost = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) + iStrBoost - GetAbilityScore(oCreature, ABILITY_STRENGTH);
    iConBoost = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) + iConBoost - GetAbilityScore(oCreature, ABILITY_CONSTITUTION);


    // Apply bonuses to target creature. Shifting code will read the full stat value 
    // (or calculate AC value) and provide bonuses to the PC approprately

    // Strength modification
    if (iStrBoost > 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_STRENGTH, iStrBoost), oCreature, 0.0f);
    else if (iStrBoost < 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, abs(iStrBoost)), oCreature, 0.0f);

    // Dexterity modification
    if (iDexBoost > 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_DEXTERITY, iDexBoost), oCreature, 0.0f);
    else if (iDexBoost < 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_DEXTERITY, abs(iDexBoost)), oCreature, 0.0f);

    // Constitution modification
    if (iConBoost > 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_CONSTITUTION, iConBoost), oCreature, 0.0f);      
    else if (iConBoost < 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, abs(iConBoost)), oCreature, 0.0f);     

    // Remove all AC bonuses from the werewolf creature skin
    itemproperty ipIPLoop = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipIPLoop))
    {
        if (GetItemPropertyType(ipIPLoop) == ITEM_PROPERTY_AC_BONUS)
            RemoveItemProperty(oSkin,ipIPLoop);

        ipIPLoop = GetNextItemProperty(oSkin);
    }

    // Calcualte AC bonus granted by the werewolf class
    iNaturalArmor -= ( GetAC(oCreature) - GetAbilityModifier(ABILITY_DEXTERITY, oCreature) - 10 );

    // Natural Armor modification
    if (iNaturalArmor > 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(iNaturalArmor,AC_NATURAL_BONUS,AC_VS_DAMAGE_TYPE_ALL), oCreature, 0.0f);          
    else if (iNaturalArmor < 0)
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACDecrease(abs(iNaturalArmor),AC_DODGE_BONUS,AC_VS_DAMAGE_TYPE_ALL), oCreature, 0.0f);

    // Other feats
    int iClassLevel = 0; // Legacy class row 173 is now Silverstar.
 
    // Class Level 3 Grants Weapon Focus in Creature weapons; Provide Focus in Unarmed strike to avoid Bio-Bug'd Creature Weapon Focus
    // 9  WeapFocusCreature             291       3    3              0 
    if (iClassLevel >= 3)
    {
        // Don't need "safe add" here - that will be used in the actual Shifting routine for the PC.
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE), oSkin, 0.0f);
    }

    // Class Level 5 Grants Weapon Specialization in Creature weapons; Provide Specialization in Unarmed strike to avoid Bio-Bug'd Creature Weapon Spec
    // 12 WeapSpecCreature              290       3    5              0 
    if (iClassLevel >= 5)
    {
        // Don't need "safe add" here - that will be used in the actual Shifting routine for the PC.
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE), oSkin, 0.0f);
    }

    // Set target Creature to be deleted by the Shifter Script
    SetLocalInt(oCreature,"pnp_shifter_deleteme",1);

    // Paranoya clean up of creature in 10 seconds
    DestroyObject(oCreature, 10.0);

    return oCreature;
}



// Removes the 1st standard Invisiblity effect from the PC
void PRC_StripWereWolfInvis(object oPC)
{
    effect eInvis = GetFirstEffect(oPC);
    int iContinue = TRUE;
    while( GetIsEffectValid(eInvis) && iContinue )
    {
        if (GetEffectType(eInvis) == EFFECT_TYPE_INVISIBILITY)
        {
                RemoveEffect(oPC, eInvis);
                iContinue  = FALSE;
        }
        
        eInvis = GetNextEffect(oPC);
    }
}
