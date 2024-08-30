//:://////////////////////////////////////////////////////
//:: Breath Weapon for Dragon Shaman Class
//:: prc_drgshm_breth.nss
//:://////////////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_breath"
#include "prc_inc_dragsham"

//////////////////////////
// Constant Definitions //
//////////////////////////

const string DSHMBREATHLOCK = "DragonShamanBreathLock";

int IsLineBreath(int nTotem)
{
    if(nTotem == FEAT_DRAGONSHAMAN_BLACK
        || nTotem == FEAT_DRAGONSHAMAN_BLUE
        || nTotem == FEAT_DRAGONSHAMAN_BRASS
        || nTotem == FEAT_DRAGONSHAMAN_BRONZE
        || nTotem == FEAT_DRAGONSHAMAN_COPPER
        )
        return TRUE;
    return FALSE;
}

// PHB II Dragon Shaman has no mention of size being taken into account with breath weapons on players. Once this
// is looked at further, this may or may not be taken into account. These rules are gone over in more detail
// in the draconomicon which has a lot more rules for dragon breath weapons.

/* float GetRangeFromSize(int nSize)
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
} */

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nTotem = GetLocalInt(oPC, "DragonShamanTotem");
    int nDamageType = GetDragonDamageType(nTotem);

    if(nSpellID == SPELL_DRAGON_SHAMAN_BREATH)
    {
        // Check the dragon breath delay lock
        if(GetLocalInt(oPC, DSHMBREATHLOCK))
        {
            SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
            return;
        }
        int nBreath;
        
        switch(nDamageType)
        {
            case DAMAGE_TYPE_ACID:         nBreath = SPELL_DRAGON_SHAMAN_BREATH_ACID; break;
            case DAMAGE_TYPE_COLD:         nBreath = SPELL_DRAGON_SHAMAN_BREATH_COLD; break;
            case DAMAGE_TYPE_ELECTRICAL:   nBreath = SPELL_DRAGON_SHAMAN_BREATH_ELEC; break;
            case DAMAGE_TYPE_FIRE:         nBreath = SPELL_DRAGON_SHAMAN_BREATH_FIRE; break;
        }
    
        object oTarget = GetSpellTargetObject();
        if(GetIsObjectValid(oTarget))
            AssignCommand(oPC, ActionCastSpellAtObject(nBreath, oTarget, METAMAGIC_ANY, TRUE));
        else
            AssignCommand(oPC, ActionCastSpellAtLocation(nBreath, GetSpellTargetLocation(), METAMAGIC_ANY, TRUE));
    }
    else
    {
        int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC);
        struct breath ShamanBreath;
    
        // Set the lock
        SetLocalInt(oPC, DSHMBREATHLOCK, TRUE);
    
        float fRange;
        //set the breath range
        if(nLevel > 19)
            fRange = 60.0;
        else if(nLevel > 11)
            fRange = 30.0;
        else
            fRange = 15.0;
 
        if(IsLineBreath(nTotem)) fRange = fRange * 2.0;

        //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
        //Save is 10+CON+1/2 Dragon Shaman level.
        int nSaveDCBoost = nLevel / 2;
    
        //starts with 2 dice at level 4
        int nDamageDice = 2;
        //Gets one more die every 2 levels
        nDamageDice += (nLevel - 4) / 2;
    
        ShamanBreath = CreateBreath(oPC, IsLineBreath(nTotem), fRange, nDamageType, 6, nDamageDice, ABILITY_CONSTITUTION, nSaveDCBoost);
        
        ApplyBreath(ShamanBreath, PRCGetSpellTargetLocation());
        //breath VFX
        /* - Taken out until we have real breath VFX - Fox
        effect eVis;
    
        if(GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC) || GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, oPC))
        {
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
        }
        else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, oPC) || GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC))
        {
            eVis = EffectVisualEffect(VFX_BEAM_LIGHTNING);
        }
        else if(GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, oPC) || GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC))
        {
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
        }
        else if(GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, oPC) || GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC))
        {
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
        }
        else if(GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, oPC))
        {
            eVis = EffectVisualEffect(VFX_BEAM_FIRE_W);
        }
        else if(GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, oPC))
        {
            eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
        }
    
        // Apply the visual effect.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
        */
        
        // Schedule opening the delay lock
        float fDelay = RoundsToSeconds(ShamanBreath.nRoundsUntilRecharge);
        SendMessageToPC(oPC, IntToString(ShamanBreath.nRoundsUntilRecharge) + " rounds until you can use your breath.");
        DelayCommand(fDelay, DeleteLocalInt(oPC, DSHMBREATHLOCK));
        DelayCommand(fDelay, FloatingTextStringOnCreature("Your breath weapon is ready now!", oPC, FALSE));
    }
}