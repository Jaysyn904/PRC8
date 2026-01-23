//Spell script for reserve feat aoe attacks
//prc_reservaoe
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_spells"  
#include "prc_add_spell_dc"

void DoAOE(effect eVis, effect eExplode, int nSaveType, int nDamage, int nDamageType, int nShape, float fSize, int nSpellID, int nBonus)
{
    object oPC = OBJECT_SELF;
    object oBeamTarget = PRCGetSpellTargetObject();
    int nDC = 10 + nBonus + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);

    location lTarget = GetIsObjectValid(PRCGetSpellTargetObject()) ? // Are we targeting an object, or just at a spot on the ground?
                       GetLocation(PRCGetSpellTargetObject()) :      // Targeting an object
                       PRCGetSpellTargetLocation();                  // Targeting a spot on the ground

    effect eDam;

    //If no beam target object, make one
    if (!GetIsObjectValid(oBeamTarget))
    {
        oBeamTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lTarget);
    }
    
    //Get first target in spell area
    object oTarget = MyFirstObjectInShape(nShape, fSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, nSpellID));
            float fDelay = GetDistanceBetween(oPC, oTarget)/20;

            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);
            if(nDamage > 0)
            {
                //Set the damage effect
                eDam = PRCEffectDamage(oTarget, nDamage, nDamageType);
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the visual that erupts on the target not on the ground.
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }

        //Get next target in spell area
        oTarget = MyNextObjectInShape(nShape, fSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oPC));
        if(DEBUG) DoDebug("prc_reservaoe: Next target is: " + DebugObject2Str(oTarget));
    }

    //Apply explosion visual if needed
    if (nShape == SHAPE_SPHERE) ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplode, lTarget, 1.0);
    else if (nShape == SHAPE_SPELLCYLINDER) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExplode, oBeamTarget, 1.0);

    //Remove the created beam target object if it exists
    if (GetResRef(oBeamTarget) == "prc_invisobj") DestroyObject(oBeamTarget, 3.0);
}

void main()
{
	object oPC = OBJECT_SELF;
    
    int nSpellID = PRCGetSpellId();
    int nDamage, nShape, nSaveType, nDamageType, nBonus;

    float fSize;
    
    effect eVis, eVisFail, eExplode;

    switch (nSpellID)
    {
        case SPELL_FIERY_BURST:
        {
	        nDamage = d6(GetLocalInt(oPC, "FieryBurstBonus"));
            nShape = SHAPE_SPHERE;
            nSaveType = SAVING_THROW_TYPE_FIRE;
            nDamageType = DAMAGE_TYPE_FIRE;
            nBonus = GetLocalInt(oPC, "FieryBurstBonus");

            fSize = FeetToMeters(5.0);
            
            eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
            eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);

            if (nBonus < 1)
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

	        DoAOE(eVis, eExplode, nSaveType, nDamage, nDamageType, nShape, fSize, nSpellID, nBonus);
            break;
        }
        
        case SPELL_STORM_BOLT:
        {
	        nDamage = d6(GetLocalInt(oPC, "StormBoltBonus"));
            nShape = SHAPE_SPELLCYLINDER;
            nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nBonus = GetLocalInt(oPC, "StormBoltBonus");

            fSize = FeetToMeters(20.0);
            
            eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
            eExplode = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_HAND);

            if (!GetLocalInt(oPC, "StormBoltBonus"))
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

	        DoAOE(eVis, eExplode, nSaveType, nDamage, nDamageType, nShape, fSize, nSpellID, nBonus);
            break;
        }

        case SPELL_WINTERS_BLAST:
        {
	        nDamage = d4(GetLocalInt(oPC, "WintersBlastBonus"));
            nShape = SHAPE_SPELLCONE;
            nSaveType = SAVING_THROW_TYPE_COLD;
            nDamageType = DAMAGE_TYPE_COLD;
            nBonus = GetLocalInt(oPC, "WintersBlastBonus");

            fSize = FeetToMeters(15.0);
            
            eVis = EffectVisualEffect(VFX_IMP_FROST_S);
            eExplode = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_HAND); //Not used for this one, vfx set in 2da

            if (!GetLocalInt(oPC, "WintersBlastBonus"))
            {
                FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
                return;
            }

	        DoAOE(eVis, eExplode, nSaveType, nDamage, nDamageType, nShape, fSize, nSpellID, nBonus);
            break;
        }
    }
}