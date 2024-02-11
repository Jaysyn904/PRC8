/*
    sp_antimagic

    Abjuration
    Level: Clr 8, Magic 6, Protection 6, Sor/Wiz 6
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation, centered on you
    Duration: 10 min./level (D)
    Saving Throw: None
    Spell Resistance: See text
    An invisible barrier surrounds you and moves with you. The space within this barrier is impervious to most magical effects, including spells, spell-like abilities, and supernatural abilities. Likewise, it prevents the functioning of any magic items or spells within its confines.
    An antimagic field suppresses any spell or magical effect used within, brought into, or cast into the area, but does not dispel it. Time spent within an antimagic field counts against the suppressed spell’s duration.
    Summoned creatures of any type and incorporeal undead wink out if they enter an antimagic field. They reappear in the same spot once the field goes away. Time spent winked out counts normally against the duration of the conjuration that is maintaining the creature. If you cast antimagic field in an area occupied by a summoned creature that has spell resistance, you must make a caster level check (1d20 + caster level) against the creature’s spell resistance to make it wink out. (The effects of instantaneous conjurations are not affected by an antimagic field because the conjuration itself is no longer in effect, only its result.)
    A normal creature can enter the area, as can normal missiles. Furthermore, while a magic sword does not function magically within the area, it is still a sword (and a masterwork sword at that). The spell has no effect on golems and other constructs that are imbued with magic during their creation process and are thereafter self-supporting (unless they have been summoned, in which case they are treated like any other summoned creatures). Elementals, corporeal undead, and outsiders are likewise unaffected unless summoned. These creatures’ spell-like or supernatural abilities, however, may be temporarily nullified by the field. Dispel magic does not remove the field.
    Two or more antimagic fields sharing any of the same space have no effect on each other. Certain spells, such as wall of force, prismatic sphere, and prismatic wall, remain unaffected by antimagic field (see the individual spell descriptions). Artifacts and deities are unaffected by mortal magic such as this.
    Should a creature be larger than the area enclosed by the barrier, any part of it that lies outside the barrier is unaffected by the field.
    Arcane Material Component: A pinch of powdered iron or iron filings.

    By: Flaming_Sword
    Created: Sept 27, 2006
    Modified: Sept 27, 2006

    Copied from psionics
*/

#include "prc_sp_func"
#include "prc_add_spell_dc"

int PresenceCheck(object oCaster){
    effect eTest = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eTest)){
        if(GetEffectSpellId(eTest) == SPELL_ANTIMAGIC_FIELD &&
           GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT   &&
           GetEffectCreator(eTest) == oCaster
           )
            return TRUE;

        eTest = GetNextEffect(oCaster);
    }

    return FALSE;
}

void main()
{
    object oCaster = OBJECT_SELF;

    if(PresenceCheck(oCaster))
    {
        PRCRemoveSpellEffects(SPELL_ANTIMAGIC_FIELD, oCaster, oCaster);
        return;
    }

    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr(oCaster);
    float fDuration = 600.0 * nCasterLevel; //modify if necessary
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;

    int nAoE = AOE_PER_NULL_PSIONICS_FIELD;
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(nAoE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);

    //Setup Area Of Effect object
    object oAoE = GetAreaOfEffectObject(GetLocation(oTarget), "VFX_PER_NULLPSIONICS", oCaster);
    SetAllAoEInts(SPELL_ANTIMAGIC_FIELD, oAoE, 0, 0, nCasterLevel);
    SetLocalInt(oAoE, "nPenetre", nPenetr);

    PRCSetSchool();
}