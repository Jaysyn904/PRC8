//::///////////////////////////////////////////////
//:: Glyph of Warding Heartbet
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Glyph of warding damage script

    This spellscript is fired when someone triggers
    a player cast Glyph of Warding


    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"


void DoDamage(int nDamage, int nDamageType, object oTarget)
{
    nDamageType = ChangedElementalDamage(GetAreaOfEffectCreator(), nDamageType);

    effect eVis;
    switch (nDamageType)
    {
        case DAMAGE_TYPE_ACID:       eVis = EffectVisualEffect(VFX_IMP_ACID_L);      break;
        case DAMAGE_TYPE_COLD:       eVis = EffectVisualEffect(VFX_IMP_FROST_L);     break;
        case DAMAGE_TYPE_ELECTRICAL: eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M); break;
        case DAMAGE_TYPE_FIRE:       eVis = EffectVisualEffect(VFX_IMP_FLAME_M);     break;
        case DAMAGE_TYPE_SONIC:      eVis = EffectVisualEffect(VFX_IMP_SONIC);       break;
    }

    effect eDam = PRCEffectDamage(oTarget, nDamage, nDamageType);
    if(nDamage > 0)
    {
        //Apply VFX impact and damage effect
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(0.01,SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    int nSpellID = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_SPELLID");

    //Declare major variables
    object oTarget = GetLocalObject(OBJECT_SELF,"X2_GLYPH_LAST_ENTER");
    location lTarget = GetLocation(OBJECT_SELF);
    int nDamage, nDamageType, nSaveType, nVfx, nDice;
    int nCasterLevel =   GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
    int nMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC");
    object oCreator = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER");

    int nPenetr = SPGetPenetrAOE(oCreator, nCasterLevel);

    if(!GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_PLAYERCREATED"))
        oCreator = OBJECT_SELF;

    if(!GetIsObjectValid(oCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    switch (nSpellID)
    {
        case SPELL_GLYPH_OF_WARDING_ACID:                nDamageType = DAMAGE_TYPE_ACID;       nSaveType = SAVING_THROW_TYPE_ACID;        nDice = min((nCasterLevel /2), 5);  nVfx = VFX_FNF_EXPLOSION_ACID; break;
        case SPELL_GLYPH_OF_WARDING_COLD:                nDamageType = DAMAGE_TYPE_COLD;       nSaveType = SAVING_THROW_TYPE_COLD;        nDice = min((nCasterLevel /2), 5);  nVfx = VFX_FNF_EXPLOSION_COLD; break;
        case SPELL_GLYPH_OF_WARDING_ELECTRICITY:         nDamageType = DAMAGE_TYPE_ELECTRICAL; nSaveType = SAVING_THROW_TYPE_ELECTRICITY; nDice = min((nCasterLevel /2), 5);  nVfx = VFX_FNF_ELECTRIC_EXPLOSION; break;
        case SPELL_GLYPH_OF_WARDING_FIRE:                nDamageType = DAMAGE_TYPE_FIRE;       nSaveType = SAVING_THROW_TYPE_FIRE;        nDice = min((nCasterLevel /2), 5);  nVfx = VFX_FNF_FIREBALL; break;
        case SPELL_GLYPH_OF_WARDING_SONIC:               nDamageType = DAMAGE_TYPE_SONIC;      nSaveType = SAVING_THROW_TYPE_SONIC;       nDice = min((nCasterLevel /2), 5);  nVfx = VFX_FNF_SOUND_BURST; break;
        case SPELL_GREATER_GLYPH_OF_WARDING_ACID:        nDamageType = DAMAGE_TYPE_ACID;       nSaveType = SAVING_THROW_TYPE_ACID;        nDice = min((nCasterLevel /2), 10); nVfx = VFX_FNF_EXPLOSION_ACID; break;
        case SPELL_GREATER_GLYPH_OF_WARDING_COLD:        nDamageType = DAMAGE_TYPE_COLD;       nSaveType = SAVING_THROW_TYPE_COLD;        nDice = min((nCasterLevel /2), 10); nVfx = VFX_FNF_EXPLOSION_COLD; break;
        case SPELL_GREATER_GLYPH_OF_WARDING_ELECTRICITY: nDamageType = DAMAGE_TYPE_ELECTRICAL; nSaveType = SAVING_THROW_TYPE_ELECTRICITY; nDice = min((nCasterLevel /2), 10); nVfx = VFX_FNF_ELECTRIC_EXPLOSION; break;
        case SPELL_GREATER_GLYPH_OF_WARDING_FIRE:        nDamageType = DAMAGE_TYPE_FIRE;       nSaveType = SAVING_THROW_TYPE_FIRE;        nDice = min((nCasterLevel /2), 10); nVfx = VFX_FNF_FIREBALL; break;
        case SPELL_GREATER_GLYPH_OF_WARDING_SONIC:       nDamageType = DAMAGE_TYPE_SONIC;      nSaveType = SAVING_THROW_TYPE_SONIC;       nDice = min((nCasterLevel /2), 10); nVfx = VFX_FNF_SOUND_BURST; break;
        case SPELL_ELDER_GLYPH_OF_WARDING_ACID:          nDamageType = DAMAGE_TYPE_ACID;       nSaveType = SAVING_THROW_TYPE_ACID;        nDice = min(nCasterLevel, 30);      nVfx = VFX_FNF_EXPLOSION_ACID; break;
        case SPELL_ELDER_GLYPH_OF_WARDING_COLD:          nDamageType = DAMAGE_TYPE_COLD;       nSaveType = SAVING_THROW_TYPE_COLD;        nDice = min(nCasterLevel, 30);      nVfx = VFX_FNF_EXPLOSION_COLD; break;
        case SPELL_ELDER_GLYPH_OF_WARDING_ELECTRICITY:   nDamageType = DAMAGE_TYPE_ELECTRICAL; nSaveType = SAVING_THROW_TYPE_ELECTRICITY; nDice = min(nCasterLevel, 30);      nVfx = VFX_FNF_ELECTRIC_EXPLOSION; break;
        case SPELL_ELDER_GLYPH_OF_WARDING_FIRE:          nDamageType = DAMAGE_TYPE_FIRE;       nSaveType = SAVING_THROW_TYPE_FIRE;        nDice = min(nCasterLevel, 30);      nVfx = VFX_FNF_FIREBALL; break;
        case SPELL_ELDER_GLYPH_OF_WARDING_SONIC:         nDamageType = DAMAGE_TYPE_SONIC;      nSaveType = SAVING_THROW_TYPE_SONIC;       nDice = min(nCasterLevel, 30);      nVfx = VFX_FNF_SOUND_BURST; break;
    }

    nDice = nDice < 1 ? 1 : nDice;

    effect eDam;
    effect eExplode = EffectVisualEffect(nVfx);

    //Check the faction of the entering object to make sure the entering object is not in the casters faction

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Cycle through the targets in the explosion area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
            if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCreator, PRCGetSpellId()));
                //Make SR check
                if (!PRCDoResistSpell(oCreator, oTarget,nPenetr))
                {
                    int nDC = PRCGetSaveDC(oTarget,oCreator);
                    nDamage = d8(nDice);
                    //Enter Metamagic conditions

                    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 8 * nDice;//Damage is at max
                    }
                    if ((nMetaMagic & METAMAGIC_EMPOWER))
                    {
                        nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                    }
                	// Acid Sheath adds +1 damage per die to acid descriptor spells
                	if (GetHasDescriptor(GetSpellId(), DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCreator))
                		nDamage += nDice;  
					nDamage += SpellDamagePerDice(oCreator, nDice);
                    //Change damage according to Reflex, Evasion and Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (nDC), nSaveType, oCreator);

                    //----------------------------------------------------------
                    // Have the creator do the damage so he gets feedback strings
                    //----------------------------------------------------------
                    if (oCreator != OBJECT_SELF)
                    {
                        AssignCommand(oCreator, DoDamage(nDamage,nDamageType,oTarget));
                    }
                    else
                    {
                        DoDamage(nDamage,nDamageType,oTarget);
                    }

                }
            }
             //Get next target in the sequence
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
