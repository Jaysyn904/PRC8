//::///////////////////////////////////////////////
//:: Breath Weapon for Half Dragon template
//:: tmp_hdrag_breath.nss
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Silver)
//:: Created On: June, 17, 2003 (June, 7, 2005)
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_breath"
#include "prc_inc_template"

//////////////////////////
// Constant Definitions //
//////////////////////////
const string HDRAGBREATHLOCK = "HalfDragonBreathLock";

int IsLineBreath()
{
    int nSubTemplate = GetPersistantLocalInt(OBJECT_SELF, "HalfDragon_Template");

    if(nSubTemplate == TEMPLATE_HDRAGON_CHROMATIC_BLACK
        || nSubTemplate == TEMPLATE_HDRAGON_CHROMATIC_BLUE
        || nSubTemplate == TEMPLATE_HDRAGON_METALLIC_BRASS
        || nSubTemplate == TEMPLATE_HDRAGON_METALLIC_BRONZE
        || nSubTemplate == TEMPLATE_HDRAGON_METALLIC_COPPER
        || nSubTemplate == TEMPLATE_HDRAGON_GEM_AMETHYST
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_BROWN
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_CHAOS
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_OCEANUS
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_RADIANT
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_RUST
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_STYX
        || nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_TARTERIAN
        )
        return TRUE;
    return FALSE;
}

//Returns range in feet for breath struct.  Conversion to meters is 
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

void main()
{
    if(GetLocalInt(OBJECT_SELF, "TemplateSLA_"+IntToString(GetSpellId())))
    {
        FloatingTextStringOnCreature("You have already used this ability today.", OBJECT_SELF);
        return;
    }

    // Check the dragon breath delay lock
    if(GetLocalInt(OBJECT_SELF, HDRAGBREATHLOCK))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
        IncrementRemainingFeatUses(OBJECT_SELF, FEAT_TEMPLATE_HALF_DRAGON_BREATH);
        return;
    }

    //Declare main variables.
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nSubTemplate = GetPersistantLocalInt(OBJECT_SELF, "HalfDragon_Template");
    struct breath DiscBreath;
    int nDamageDice = 6;
    int DBREED;
    effect eVis;

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    int nSaveDCBonus = GetLevelByClass(CLASS_TYPE_DRAGON, oPC)/2;

    //range calculation
    float fRange = GetRangeFromSize(PRCGetCreatureSize(oPC));
    if(IsLineBreath()) fRange = fRange * 2.0;

    //Only Dragons with Breath Weapons will have damage caused by their breath attack.
    //Any Dragon type not listed here will have a breath attack, but it will not
    //cause damage or create a visual effect.
    switch(nSubTemplate)
    {
        case TEMPLATE_HDRAGON_CHROMATIC_RED:     DBREED = DAMAGE_TYPE_FIRE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
        case TEMPLATE_HDRAGON_METALLIC_BRASS:    DBREED = DAMAGE_TYPE_FIRE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
        case TEMPLATE_HDRAGON_METALLIC_GOLD:     DBREED = DAMAGE_TYPE_FIRE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
        case TEMPLATE_HDRAGON_LUNG_LUNGWANG:     DBREED = DAMAGE_TYPE_FIRE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
        case TEMPLATE_HDRAGON_LUNG_TIENLUNG:     DBREED = DAMAGE_TYPE_FIRE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
        case TEMPLATE_HDRAGON_CHROMATIC_BLACK:   DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_CHROMATIC_GREEN:   DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_METALLIC_COPPER:   DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_OBSCURE_BROWN:     DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_OBSCURE_DEEP:      DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_OBSCURE_RUST:      DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_OBSCURE_STYX:      DBREED = DAMAGE_TYPE_ACID; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID); break;
        case TEMPLATE_HDRAGON_METALLIC_SILVER:   DBREED = DAMAGE_TYPE_COLD; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHCOLD); break;
        case TEMPLATE_HDRAGON_CHROMATIC_WHITE:   DBREED = DAMAGE_TYPE_COLD; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHCOLD); break;
        case TEMPLATE_HDRAGON_CHROMATIC_BLUE:    DBREED = DAMAGE_TYPE_ELECTRICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHMIND); break;//VFX_FNF_DRAGBREATHELEC
        case TEMPLATE_HDRAGON_METALLIC_BRONZE:   DBREED = DAMAGE_TYPE_ELECTRICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHMIND); break;
        case TEMPLATE_HDRAGON_OBSCURE_OCEANUS:   DBREED = DAMAGE_TYPE_ELECTRICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHMIND); break;
        case TEMPLATE_HDRAGON_OBSCURE_SONG:      DBREED = DAMAGE_TYPE_ELECTRICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHMIND); break;
        case TEMPLATE_HDRAGON_GEM_EMERALD:       DBREED = DAMAGE_TYPE_SONIC; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHSONIC); break;
        case TEMPLATE_HDRAGON_GEM_SAPPHIRE:      DBREED = DAMAGE_TYPE_SONIC; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHSONIC); break;
        case TEMPLATE_HDRAGON_OBSCURE_BATTLE:    DBREED = DAMAGE_TYPE_SONIC; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHSONIC); break;
        case TEMPLATE_HDRAGON_OBSCURE_HOWLING:   DBREED = DAMAGE_TYPE_SONIC; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHSONIC); break;
        case TEMPLATE_HDRAGON_GEM_CRYSTAL:       DBREED = DAMAGE_TYPE_POSITIVE; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHHOLY); break;
        case TEMPLATE_HDRAGON_GEM_AMETHYST:      DBREED = DAMAGE_TYPE_BLUDGEONING; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHODD); break;
        case TEMPLATE_HDRAGON_GEM_TOPAZ:         DBREED = DAMAGE_TYPE_MAGICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHODD); break;
        case TEMPLATE_HDRAGON_OBSCURE_ETHEREAL:  DBREED = DAMAGE_TYPE_MAGICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHODD); break;
        case TEMPLATE_HDRAGON_OBSCURE_RADIANT:   DBREED = DAMAGE_TYPE_MAGICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHODD); break;
        case TEMPLATE_HDRAGON_OBSCURE_TARTERIAN: DBREED = DAMAGE_TYPE_MAGICAL; eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHODD); break;
        default: DBREED = -1;  eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND); break;
    }

    if (DBREED > 0)  DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, DBREED, 8, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus);
    //If Topaz, activate override for special impact VFX for Topaz's breath
    if (nSubTemplate == TEMPLATE_HDRAGON_GEM_TOPAZ) DiscBreath.nOverrideSpecial = BREATH_TOPAZ;
    if (nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_CHAOS)
    {
        int eleBreath;
        int nNumDice = d10();
        //Sets the random Element factor of the Chaos Dragons Breath Weapon.
        //Affects damage, saving throw, and impact visual.
        if((nNumDice==1) || (nNumDice==2))
        {
            eleBreath = DAMAGE_TYPE_COLD;
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHCOLD);
        }
        else if((nNumDice==3) || (nNumDice==4))
        {
            eleBreath = DAMAGE_TYPE_ACID;
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHACID);
        }
        else if((nNumDice==5) || (nNumDice==6))
        {
            eleBreath = DAMAGE_TYPE_FIRE;
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
        }
        else if((nNumDice==7) || (nNumDice==8))
        {
            eleBreath = DAMAGE_TYPE_SONIC;
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHSONIC);
        }
        else //if((nNumDice==9) || (nNumDice==10))
        {
            eleBreath = DAMAGE_TYPE_ELECTRICAL;
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHMIND);//VFX_FNF_DRAGBREATHELEC
        }

        DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, eleBreath, 8, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus);
    }
    if (nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_PYROCLASTIC)  DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, DAMAGE_TYPE_SONIC, 8, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_PYROCLASTIC);
    if (nSubTemplate == TEMPLATE_HDRAGON_OBSCURE_SHADOW) DiscBreath = CreateBreath(oPC, IsLineBreath(), fRange, -1, 8, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_SHADOW);

    //actual breath effect
    ApplyBreath(DiscBreath, PRCGetSpellTargetLocation());

    //breath VFX
    //effect eVis = EffectVisualEffect(1332);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());

    if(GetHasFeat(FEAT_FULL_DRAGON_BREATH, oPC))
    {
        // Schedule opening the delay lock
        float fDelay = RoundsToSeconds(DiscBreath.nRoundsUntilRecharge);
        IncrementRemainingFeatUses(oPC, FEAT_TEMPLATE_HALF_DRAGON_BREATH);
        SendMessageToPC(oPC, "Your breath weapon will be ready again in " + IntToString(DiscBreath.nRoundsUntilRecharge) + " rounds.");
        // Set the lock
        SetLocalInt(oPC, HDRAGBREATHLOCK, TRUE);

        DelayCommand(fDelay, DeleteLocalInt(oPC, HDRAGBREATHLOCK));
        DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));
    }
    else
        SetLocalInt(oPC, "TemplateSLA_"+IntToString(GetSpellId()), 1);
}

