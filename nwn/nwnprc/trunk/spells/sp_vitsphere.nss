//::////////////////////////////////////////////////////////
//::
/*	
	Vitriolic Sphere (sp_vitsphere.nss)
	Conjuration (Creation) [Acid]
	Level: 				Sorcerer 5, Wizard 5, Wu Jen 5,
	Components: 		V, S, M,
	Casting Time: 		1 standard action
	Range: 				Long (400 ft. + 40 ft./level)
	Area: 				10-ft.-radius burst
	Duration: 			Instantaneous; see text
	Saving Throw: 		Reflex negates and Reflex half; see text
	Spell Resistance: 	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*	 

	You conjure a sizzling emerald sphere that drenches all 
	within the area with a potent acid.
	Affected creatures take 1d4 points of acid damage per 
	caster level (maximum 15d4) and must succeed on a Reflex 
	save or risk taking damage in the following 2 rounds 
	(6d4 points of damage in the second round and 3d4 points 
	of damage in the third round).
	Both rounds of continuing damage are subject to Reflex 
	saves for half damage; if an affected creature succeeds 
	on its second Reflex save, it takes no acid damage in 
	the third round.
	
	Material Component: A tiny glass vial filled with aqua 
	regia.
	
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-08 07:55:27
//::
//::////////////////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  

//::----------------------------------------------------------------  
//:: Continuing damage — round 2: 6d4 acid, Reflex half.  
//:: On a successful save the acid is neutralized: no round 3.  
//::----------------------------------------------------------------  
void VS_Round2(object oTarget, object oCaster, int nDC, int nMetaMagic, int nDmgType)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget))  
        return;  
  
    int nDamage = d4(6);  
    if (nMetaMagic & METAMAGIC_MAXIMIZE)  
        nDamage = 24;  
    if (nMetaMagic & METAMAGIC_EMPOWER)  
        nDamage += nDamage / 2;  
  
    if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC,  
                         SAVING_THROW_TYPE_ACID, oCaster))  
    {  
        nDamage /= 2;  
    }  
  
    effect eDam = PRCEffectDamage(oTarget, nDamage, nDmgType);  
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectLinkEffects(eDam, eVis), oTarget);  
}  
  
//::----------------------------------------------------------------  
//:: Continuing damage — round 3: 3d4 acid, Reflex half.  
//::----------------------------------------------------------------  
void VS_Round3(object oTarget, object oCaster, int nDC, int nMetaMagic, int nDmgType)  
{  
    if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget))  
        return;  
  
    int nDamage = d4(3);  
    if (nMetaMagic & METAMAGIC_MAXIMIZE)  
        nDamage = 12;  
    if (nMetaMagic & METAMAGIC_EMPOWER)  
        nDamage += nDamage / 2;  
  
    if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC,  
                         SAVING_THROW_TYPE_ACID, oCaster))  
    {  
        nDamage /= 2;  
    }  
  
    effect eDam = PRCEffectDamage(oTarget, nDamage, nDmgType);  
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
        EffectLinkEffects(eDam, eVis), oTarget);  
}  
  
void main()  
{  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
    if (!X2PreSpellCastCode())  
    {  
        PRCSetSchool();  
        return;  
    }  

    object oCaster   = OBJECT_SELF;  
    location lTarget = PRCGetSpellTargetLocation();  
    int nSpellID     = PRCGetSpellId();  
    int nCasterLvl   = PRCGetCasterLevel(oCaster);  
    int nMetaMagic   = PRCGetMetaMagicFeat();  
    int nDice        = PRCMin(nCasterLvl, 15);  
    int nDmgType     = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ACID);  
  
    effect eSphere = EffectVisualEffect(VFX_IMP_ACID_L);  
    effect eVis    = EffectVisualEffect(VFX_IMP_ACID_S);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSphere, lTarget);  
  
    // 10-ft burst — creatures and unattended objects  
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE,  
        RADIUS_SIZE_MEDIUM, lTarget, TRUE,  
        OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
  
    while (GetIsObjectValid(oTarget))  
    {  
        int nType = GetObjectType(oTarget);  
        int bValid = (nType == OBJECT_TYPE_CREATURE)  
            ? spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)  
            : TRUE; // doors/placeables always take acid  
  
        if (bValid)
        {  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);  
  
            float fDelay = PRCGetRandomDelay(0.1, 0.5);  
  
            // Initial burst: 1d4/CL (max 15d4), no save  
            int nDamage = d4(nDice);  
            if (nMetaMagic & METAMAGIC_MAXIMIZE)  
                nDamage = 4 * nDice;  
            if (nMetaMagic & METAMAGIC_EMPOWER)  
                nDamage += nDamage / 2;  
  
            // Acid Sheath (+1/die on acid) & Warmage's Edge-type bonuses  
            if (GetHasDescriptor(nSpellID, DESCRIPTOR_ACID)  
                && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))  
            {  
                nDamage += nDice;  
            }  
            nDamage += SpellDamagePerDice(oCaster, nDice);  
  
            effect eDam = PRCEffectDamage(oTarget, nDamage, nDmgType);  
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                EffectLinkEffects(eDam, eVis), oTarget));  
  
            // Creatures only: Reflex save vs. the continuing acid  
            if (nType == OBJECT_TYPE_CREATURE)  
            {  
                int nDC = PRCGetSaveDC(oTarget, oCaster);  
                if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC,  
                                      SAVING_THROW_TYPE_ACID, oCaster))  
                {  
                    DelayCommand(6.0,  
                        VS_Round2(oTarget, oCaster, nDC, nMetaMagic, nDmgType));  
                    DelayCommand(12.0,  
                        VS_Round3(oTarget, oCaster, nDC, nMetaMagic, nDmgType));  
                }  
            }  
        }  
        oTarget = MyNextObjectInShape(SHAPE_SPHERE,  
            RADIUS_SIZE_MEDIUM, lTarget, TRUE,  
            OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);  
    }  
  
    PRCSetSchool();  
}