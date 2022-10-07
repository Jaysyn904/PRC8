#include "prc_inc_spells"
#include "prc_add_spell_dc"
void BioWareDrown(int nCasterLevel, object oCaster, object oTarget, float fDelay);

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel();

    // Apply a fancy effect for such a high level spell.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);

    float fDelay;

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nTargets = 0;
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);

        // Run the Bioware drown code.
        object oCaster = OBJECT_SELF;
        BioWareDrown (nCasterLvl, oCaster, oTarget, fDelay);

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}

//
// BioWare's drown code from x0_s0_drown.nss
//
void BioWareDrown(int nCasterLevel, object oCaster, object oTarget, float fDelay)
{
    //Declare major variables
//    object oTarget = PRCGetSpellTargetObject();
//    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDam = GetCurrentHitPoints(oTarget);
    //Set visual effect
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Check faction of target
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
//  if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 437));
        //Make SR Check
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLevel + SPGetPenetr()))
        {
            // * certain racial types are immune
            if ((MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
                &&(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                &&(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
            {
                //Make a fortitude save
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCaster)))
                {
                    nDam = FloatToInt(nDam * 0.9);
                    eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING);
                    //Apply the VFX impact and damage effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
    }
}
