/*:://////////////////////////////////////////////
//:: Spell Name Pyrotechnics
//:: Spell FileName PHS_S_Pyrotech
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Pyrotechnics
    Transmutation
    Level: Brd 2, Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Long (40M)
    Target: One fire source, such as a spell or creature
    Duration: 1d4+1 rounds, or 1d4+1 rounds after creatures leave the smoke
              cloud; see text
    Saving Throw: Will negates or Fortitude negates; see text
    Spell Resistance: Yes or No; see text

    Pyrotechnics turns a fire into either a burst of blinding fireworks or a
    thick cloud of choking smoke, depending on the version you choose.

    Fireworks: The fireworks are a flashing, fiery, momentary burst of glowing,
    colored aerial lights. This effect causes creatures within 40 meters
    (120 feet) of the fire source to become blinded for 1d4+1 rounds (Will
    negates). These creatures must have line of sight to the fire to be
    affected. Spell resistance can prevent blindness.

    Smoke Cloud: A writhing stream of smoke billows out from the source, forming
    a choking cloud. The cloud spreads to a 6.67M (20 feet) radius and lasts for
    1 round per caster level. All sight, even darkvision, is ineffective in or
    into the cloud. All within the cloud take -4 penalties to Strength and
    Dexterity (Fortitude negates). These effects last for 1d4+1 rounds after
    the cloud dissipates or after the creature leaves the area of the cloud.
    Spell resistance does not apply, and this effect cannot be dispelled.

    Material Component: The spell uses one fire source, magical or creature.
    Magical fires are not extinguished, although a fire-based creature used as
    a source takes 1 point of damage per caster level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses Darkness invisibility for the ineffective through the cloud part.

    Defaults to fireworks. No sub-dial.

    The impact is easy - 1d4 + 1 rounds of blindness, SR + Will negates.

    The smoke cloud (1 round/level) applies the Darkness, and Darkness
    invisibility.

    Every HB may apply the -4 penalties to strength and dexterity.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// If oObject is firey (Can be considered so in many cases), usually a fire
// based creature, we return TRUE. If this is so, we also do damage to it.
int GetIsFireObject(object oObject, int nCasterLevel);
// If there is a firey AOE near to this target location, we return TRUE - but
// do nothing about it mind you.
int GetIsFireLocation(location lTarget);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PYROTECHNICS)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Check later if firey
    location lTarget = GetSpellTargetLocation();// Might target a firey AOE
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nSpell = GetLocalInt(oCaster, "PHS_SPELL_PYROTECHNICS_CHOICE");

    // Must target something firey for both spells
    if(GetIsFireObject(oTarget, nCasterLevel) || GetIsFireLocation(lTarget))
    {
        // What version of the spell are we doing?
        if(nSpell == 0)
        {
            // Defaults to fireworks

            // Duration (Blindness via. Fireworks) 1d4 + 1 rounds.
            float fBlindness, fDelay;

            // Declare effects
            effect eBlind = EffectBlindness();
            effect eBlindVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
            effect eBlindDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            effect eBlindLink = EffectLinkEffects(eBlind, eBlindDur);

            // Apply AOE visual
            effect eImpact = EffectVisualEffect(PHS_VFX_FNF_PYROTECHNICS);
            PHS_ApplyLocationVFX(lTarget, eImpact);

            // Get all targets in a sphere, 40M radius, all creatures.
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            // Loop targets
            while(GetIsObjectValid(oTarget))
            {
                // PvP Check
                if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget))
                {
                    //Fire cast spell at event for the specified target
                    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PYROTECHNICS);

                    // Get the distance between the explosion and the target to calculate delay
                    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/10;

                    // Spell resistance And immunity checking.
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Will negates
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                        {
                            // Get duration
                            fBlindness = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, 1);

                            // Apply blindness for the duration
                            DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eBlindVis, eBlindLink, fBlindness));
                        }
                    }
                }
                // Get Next Target
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }

        }
        else //if(nSpell == 1)
        {
            // Else, smoke cloud

            // Duration (AOE) - 1 round/level
            float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

            // Declare effects
            effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_PYROTECHNICS);

            // Apply the AOE
            PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
        }
    }
}

// If oObject is firey (Can be considered so in many cases), usually a fire
// based creature, we return TRUE. If this is so, we also do damage to it.
int GetIsFireObject(object oObject, int nCasterLevel)
{
    int nType = GetObjectType(oObject);
    // Check if a firey creature
    if(nType == OBJECT_TYPE_CREATURE)
    {
        switch(GetAppearanceType(oObject))
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
                // Firey + Do damage
                PHS_ApplyDamageToObject(oObject, nCasterLevel);

                return TRUE;
            }
            break;
        }
        // Not firey
        return FALSE;
    }
    // Placable
    else if(nType == OBJECT_TYPE_PLACEABLE)
    {
        // We check 2 things.
        // 1. A local saying "This produces fire"
        // 2. GetPlaceableIllumination();

        if(GetLocalInt(oObject, "PHS_FIRE") &&
           GetPlaceableIllumination(oObject))
        {
            // Firey + Do damage
            PHS_ApplyDamageToObject(oObject, nCasterLevel);
            // Its ok
            return TRUE;
        }
        return FALSE;
    }
    else if(nType == OBJECT_TYPE_DOOR)
    {
        // Doors currently have no fire version
        return FALSE;
    }
    // Anything else
    return FALSE;
}

// If there is a firey AOE near to this target location, we return TRUE - but
// do nothing about it mind you.
int GetIsFireLocation(location lTarget)
{
    // Check for nearest objects which are fire AOE's
    int nCnt = 1;
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, nCnt);
    while(GetIsObjectValid(oAOE) && GetDistanceBetweenLocations(lTarget, GetLocation(oAOE)) <= 7.0)
    {
        // We will check the tag.
        if(PHS_GetIsFireyAOE(oAOE))
        {
            // Firey
            return TRUE;
        }
        // Next AOE
        nCnt++;
        oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget, nCnt);
    }
    // No fire
    return FALSE;
}
