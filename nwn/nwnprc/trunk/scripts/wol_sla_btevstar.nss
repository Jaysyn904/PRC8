/**
 * @file
 * Spellscript for Bright Evening Star SLAs
 *
 */
 //::By ebonfowl for the PRC
 //::Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_template"
#include "prc_inc_combat"
#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "prc_inc_spells" 

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_hypattern: Spell expired, clearing");
        PRCRemoveEffectsFromSpell(oTarget, nSpellID);

    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void ConcentrationHB(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if(GetBreakConcentrationCheck(oCaster))
    {
        //FloatingTextStringOnCreature("Crafting: Concentration lost!", oPC);
        //DeleteLocalInt(oPC, PRC_CRAFT_HB);
        //return;
        DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining);
    }
    else
        DelayCommand(6.0f, ConcentrationHB(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oArea = GetArea(oPC);
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_BrtEvnStar");
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC) && oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC)) return;

    switch(nSLA){
        case WOL_BES_FIRE_OF_THE_HEART:
        {
            nCasterLevel = 5;
            nSpell = SPELL_FAERIE_FIRE;
            nUses = 999;
            break;
        } 
        case WOL_BES_ENTHRALLING_LIGHT:
        {
            nUses = 3;
            if (nUses > GetLegacyUses(oPC, nSLA))
            {
            object oCaster = OBJECT_SELF;
            nCasterLevel = 5;
            int nSpellID = PRCGetSpellId();
            PRCSetSchool(GetSpellSchool(nSpellID));
            if (!X2PreSpellCastCode()) return;
            object oTarget;// = PRCGetSpellTargetObject();
            location lLocation = PRCGetSpellTargetLocation();
            int nSaveDC = 11;
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nSaveDC)
                nSaveDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
            float fDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

            effect eLink = EffectFascinate();
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

            int nHDBonus = nCasterLevel;
            if (nHDBonus > 10) nHDBonus = 10;
            int nMaxHD = d4(2) + nHDBonus;
            int nSumHD = 0;
            float nRadius = RADIUS_SIZE_HUGE;
            int i, nHD, nKillSwitch;
            
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, nRadius, lLocation, TRUE);
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_RAINBOW_PATTERN), lLocation);

            while(GetIsObjectValid(oTarget) && nKillSwitch == 0)
            {
                if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
                {
                    nHD = GetHitDice(oTarget);
                    nSumHD = nSumHD + nHD;
                    if (nSumHD <= nMaxHD)
                    {
                        PRCSignalSpellEvent(oTarget, FALSE);
                        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                        DelayCommand(6.0f, ConcentrationHB(oCaster, oTarget, nSpellID, FloatToInt(fDuration)));
                    }
                    else nKillSwitch = 1;
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, nRadius, lLocation, TRUE);
            }

            PRCSetSchool();
            }
            SetLegacyUses(oPC, nSLA);
            break;
        }
        case WOL_BES_COLOR_SPRAY:
        {
        	nCasterLevel = 5;
            nSpell = SPELL_COLOR_SPRAY;
            nUses = 3;
            nDC = 11;
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
            break;
        }         
        case WOL_BES_BLINDING_FLASH:
        {
            nUses = 3;
            if (nUses > GetLegacyUses(oPC, nSLA))
            {
            if (!X2PreSpellCastCode()) return;

            PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

            //Declare major varibles
            object oCaster = OBJECT_SELF;
            object oTarget = PRCGetSpellTargetObject();
            int CasterLvl = 5;
            nDC = 13;
            if (12 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);

            float fDuration = RoundsToSeconds(CasterLvl);

            effect eVis   = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

            effect eBlind = EffectBlindness();
            effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            effect eLink  = EffectLinkEffects(eBlind, eDur);

            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BES_BLINDING_FLASH));
                //Do SR check
                if (!PRCDoResistSpell(oCaster, oTarget) && PRCGetIsAliveCreature(oTarget))
                {
                    // Make Fortitude save to negate
                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
                    {

                        //Apply visual and effects
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BES_BLINDING_FLASH, CasterLvl);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
            PRCSetSchool();
            }
            SetLegacyUses(oPC, nSLA);
            break;
        }
        case WOL_BES_SHOOTING_STARS:
        {
            nCasterLevel = 10;
            nSpell = SPELL_MAGIC_MISSILE;
            nUses = 2;           
            break;
        }
        case WOL_BES_GLITTERING_MOTES:
        {
            nCasterLevel = 5;
            nSpell = SPELL_GLITTERDUST;
            nUses = 1;
            nDC = 13;
            if (12 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
            break;
        }
        case WOL_BES_TWINKLE:
        {
            nCasterLevel = 11;
            nSpell = SPELL_BLINK;
            nUses = 3;
            break;
        }
        case WOL_BES_SILVER_STARLIGHT:
        {
        nUses = 1;
        if (nUses > GetLegacyUses(oPC, nSLA))
        {
        DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
        SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
        /*
        Spellcast Hook Code
        Added 2003-06-20 by Georg
        If you want to make changes to all spells,
        check x2_inc_spellhook.nss to find out more

        */

            if (!X2PreSpellCastCode())
            {
            // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
                return;
            }

        // End of Spell Cast Hook

            //Declare major variables
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
            effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
            effect eDam;
            effect eBlind = EffectBlindness();
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            effect eLink = EffectLinkEffects(eBlind, eDur);
            int CasterLvl = 15;
            int nDamage;
            int nOrgDam;
            int nMax;
            float fDelay;
            int nBlindLength = 3;

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, PRCGetSpellTargetLocation());
            //Get the first target in the spell area
            object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
            while(GetIsObjectValid(oTarget))
            {

                nCasterLevel= CasterLvl;
                //Limit caster level
                if (nCasterLevel > 20)
                {
                    nCasterLevel = 20;
                }    
    
                // Make a faction check
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
                {
                    fDelay = PRCGetRandomDelay(1.0, 2.0);
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_BES_SILVER_STARLIGHT));
                    //Make an SR check
                    if (!PRCDoResistSpell(oPC, oTarget, nCasterLevel, 1.0))
                    {
                        //Extra effects to undead, oozes and shapechangers
                        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OOZE
                        || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER)
                        {
                            //Roll damage and save
                            nDamage = d6(nCasterLevel);
                            nMax = 6;
                        }
                        else
                        {
                            //Roll damage and save
                            nDamage = d6(3);
                            nOrgDam = nDamage;
                            nMax = 6;
                            nCasterLevel = 3;
                            //Get the adjusted damage due to Reflex Save, Evasion or Improved Evasion
                        }

                        nDamage += SpellDamagePerDice(oPC, nCasterLevel);
                        nDC = 20;
                        if (17 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                        nDC = 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            

                        //Check that a reflex save was made.
                        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (nDC), SAVING_THROW_TYPE_DIVINE, oPC, 1.0) == 0)
                        {
                            DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindLength),TRUE,-1,CasterLvl));
                        }
                        else
                        {
                            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_DIVINE);
                        }
                        //Set damage effect
                        eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
                        if(nDamage > 0)
                        {
                            //Apply the damage effect and VFX impact
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                            PRCBonusDamage(oTarget);
                        }
                    }
                }
                //Get the next target in the spell area
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, PRCGetSpellTargetLocation());
            }

        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        // Getting rid of the integer used to hold the spells spell school
        }
        SetLegacyUses(oPC, nSLA);
            break;
        }
        case WOL_BES_STARLIGHT_DISPELLING:
        {
            nCasterLevel = 15;
            if(GetIsObjectValid(oArea)
            && !GetIsDay()
            && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
            && !GetIsAreaInterior(oArea))
            {
                nCasterLevel = 20;
            }    
            nSpell = SPELL_GREATER_DISPELLING;
            nUses = 1;          
            break;
        }
        case WOL_BES_TALES_IN_THE_SKY:
        {
            if(GetIsObjectValid(oArea)
            && !GetIsDay()
            && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
            && !GetIsAreaInterior(oArea))
            {
                nCasterLevel = 15;
                nSpell = SPELL_LEGEND_LORE;
                nUses = 1;         
                break;
            }
            else
            {
                PrintString("Tales in the Sky is only usable outside at night.");
                break;
            }    
        }
        case WOL_BES_CALL_DOWN_A_STAR:
        {
            nCasterLevel = 17;
            nSpell = SPELL_SUMMON_CREATURE_IX_FIRE;
            nUses = 1;
            break;
        }      
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        