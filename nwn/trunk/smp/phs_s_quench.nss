/*:://////////////////////////////////////////////
//:: Spell Name Quench
//:: Spell FileName PHS_S_Quench
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 10M-radius (30-ft.) spread
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    Quench is often used to put out forest fires and other conflagrations. It
    extinguishes all nonmagical fires in its area. The spell also dispels any
    fire spells in its area, though you must succeed on a dispel check (1d20 +1
    per caster level, maximum +15) against each spell to dispel it. The DC to
    dispel such spells is 11 + the caster level of the fire spell.

    Each elemental (fire) creature within the area of a quench spell takes 1d6
    points of damage per caster level (maximum 15d6, no save allowed).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is changed, it obviously can't detect if there is a natural fire.

    Fire creatures are damaged.

    Fire AOE's are destroyed (dispel check).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_QUENCH)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    // Max bonus of +15 from caster level for dispelling and damage
    int nMaxBonus = PHS_LimitInteger(nCasterLevel, 15);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sTag;
    int nType, nDam;

    // Visual effects
    effect eAOE = EffectVisualEffect(PHS_VFX_FNF_QUENCH_WATER);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_QUENCH_IMPACT);

    // Get the objects and area-of-effects in the AOE.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        // Type
        nType = GetObjectType(oTarget);

        // Check object type
        if(nType == OBJECT_TYPE_CREATURE)
        {
            // A creature can be damaged, probably.
            switch(GetAppearanceType(oTarget))
            {
                // Being a bit leniant on who to have as "firey".
                case APPEARANCE_TYPE_BALOR:
                case APPEARANCE_TYPE_DOG_HELL_HOUND:
                case APPEARANCE_TYPE_ELEMENTAL_FIRE:
                case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
                case APPEARANCE_TYPE_GIANT_FIRE:
                case APPEARANCE_TYPE_GIANT_FIRE_FEMALE:
                case APPEARANCE_TYPE_MEPHIT_FIRE:
                case APPEARANCE_TYPE_MEPHIT_MAGMA:
                {
                    // Damage
                    nDam = PHS_MaximizeOrEmpower(6, nMaxBonus, nMetaMagic);

                    // No save

                    // Damage it - magical damage (it isn't specified in description)
                    PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam);
                }
                break;
            }
        }
        else if(nType == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            // Must be an area of effect - dispel it if a fire one
            if(PHS_GetIsFireyAOE(oTarget))
            {
                // Dispel
                PHS_DispelMagicAreaOfEffect(oTarget, nMaxBonus);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }
}
