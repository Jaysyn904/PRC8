/**
 * @file
 * Spellscript for Crimson Ruination SLAs
 *
 */

#include "prc_inc_template"

int PRCCanCreatureBeDestroyed(object oTarget)
{
    if (!GetPlotFlag(oTarget) && !GetImmortal(oTarget))
        return TRUE;
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Sunsword");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_SUNSWORD_DAY:
        {
            nCasterLevel = GetHitDice(oPC);
            nSpell = SPELL_DAYLIGHT;
            nUses = 1;
            if (GetHitDice(oPC) >= 16 && GetHasFeat(FEAT_LESSER_LEGACY, oPC)) nUses = 999;
            break;
        } 
        case WOL_SUNSWORD_WARD:
        {
            nCasterLevel = 11;
            nSpell = SPELL_DEATH_WARD;
            nUses = 1;
            break;
        }  
        case WOL_SUNSWORD_BANISH:
        {
            nCasterLevel = GetHitDice(oPC);
            nUses = 1;
            nDC = 20;            
            if (17 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC);         
		    location lTarget = GetLocation(oPC);
		    // * the pool is the number of hit dice of creatures that can be banished
		    int nPool = 2 * nCasterLevel;
		
		    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
		    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
		
		    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

		    //Get the first object in the are of effect
		    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		    while(GetIsObjectValid(oTarget))
		    {
		        // * Is the creature a summoned associate
		        // * or is the creature an outsider
		        // * and is there enough points in the pool
		        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && nPool > 0)
		        {
		            // * March 2003. Added a check so that 'friendlies' will not be
		            // * unsummoned.
		            if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
		            {
		                SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_BANISHMENT));

		                // * Must be enough points in the pool to destroy target
		                if (nPool >= GetHitDice(oTarget))
		                {
		                    // * Make SR and will save checks
		                    if (!PRCDoResistSpell(oPC, oTarget, nCasterLevel) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
		                    {
		                        nPool = nPool - GetHitDice(oTarget);
		                        DeathlessFrenzyCheck(oTarget);
		                        //Apply the VFX and delay the destruction of the summoned monster so
		                        //that the script and VFX can play.
		                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		                        if(PRCCanCreatureBeDestroyed(oTarget))
		                        {
		                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
		                            //Which is bad when you have plot-specific things being done in that
		                            //OnDeath script... so lets kill it.
		                            effect eKill = PRCEffectDamage(oTarget, GetCurrentHitPoints(oTarget));
		                            //just to be extra-sure... :)
		                            effect eDeath = EffectDeath(FALSE, FALSE);
		                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
		                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
		                        }
		                    }
		                }
		            } // rep check
		        }
		        //Get next creature in the shape.
		        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		    }
            break;
        } 
        case WOL_SUNSWORD_UNDEATH:
        {
            nCasterLevel = 20;
            nSpell = SPELL_UNDEATH_TO_DEATH;
            nUses = 1;
            nDC = 20;            
            if (17 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC);             
            break;
        }         
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    SetLegacyUses(oPC, nSLA);
    FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);    
    if (nSpell > 0) 
        DoRacialSLA(nSpell, nCasterLevel, nDC);    
}
        