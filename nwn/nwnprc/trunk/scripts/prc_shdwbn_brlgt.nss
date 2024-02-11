#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetLocalInt(oPC, "PierceShadows")) return;
    
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))  return;
    DecrementRemainingFeatUses(oPC,FEAT_TURN_UNDEAD);
    
    location lTarget = GetLocation(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR);
    float fRad = FeetToMeters(20.0 + 5.0 * nClass);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), lTarget);

    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    int nDamage;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRad, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (oTarget != oPC)
        {
            effect eDeath = EffectDamage(d6(4), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
            effect eLink = EffectLinkEffects(eDeath, eVis);
            DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget));
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRad, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}
