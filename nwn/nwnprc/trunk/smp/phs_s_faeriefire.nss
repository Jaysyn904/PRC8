/*:://////////////////////////////////////////////
//:: Spell Name Faerie Fire
//:: Spell FileName PHS_S_FaerieFire
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Light]
    Level: Drd 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: Creatures and objects within a 1.67-M.-radius burst
    Duration: 1 min./level (D)
    Saving Throw: None
    Spell Resistance: Yes

    A pale glow surrounds and outlines the subjects. Outlined subjects shed
    light as candles. Outlined creatures have blur, displacement, invisibility,
    or similar effects removed from them, and they cannot apply such effects
    again until the duration expires of Faeri Fire is dispelled. The light is
    too dim to have any special effect on undead or dark-dwelling creatures
    vulnerable to light. The light, however, carries with it a -10 penalty to
    hide checks if illuminated. The faerie fire is randomly blue, green, or violet.
    The faerie fire does not cause any harm to the objects or creatures thus
    outlined.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, small burst.

    It only removes the effects and doesn't allow them to be reapplied.

    Note:
    Could change to dispelling effects. This would mean that for the level 1
    spell that it is, it could be less powerful.
    Note 2:
    It has the smallest radius, and might not be too harmful anyway.

    Applies a -10 penalty to the hide skill, however.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FAERIE_FIRE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;
    int nVFX;
    effect eCheck;

    // Get duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Randomise nVFX
    switch(d3())
    {
        case 1: nVFX = VFX_DUR_GLOW_LIGHT_BLUE; break;
        case 2: nVFX = VFX_DUR_GLOW_LIGHT_GREEN; break;
        case 3: nVFX = VFX_DUR_GLOW_LIGHT_PURPLE; break;
    }

    // Declare Effects
    effect eDur = EffectVisualEffect(nVFX);
    effect eHide = EffectSkillDecrease(SKILL_HIDE, 10);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eDur, eHide);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_FAERIE_FIRE);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 1.67M radius, creatures only.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 1.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FAERIE_FIRE);

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/30;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Remove the effects from the target:
                // * Displacement, EffectInvisibility, Blur.
                eCheck = GetFirstEffect(oTarget);
                while(GetIsEffectValid(eCheck))
                {
                    switch(GetEffectType(eCheck))
                    {
                        case EFFECT_TYPE_INVISIBILITY:
                        case EFFECT_TYPE_IMPROVEDINVISIBILITY:
                        {
                            // Remove all invisibilities
                            RemoveEffect(oTarget, eCheck);
                        }
                        break;
                        // Other spells
                        default:
                        {
                            switch(GetEffectSpellId(eCheck))
                            {
                                case PHS_SPELL_BLUR:
                                case PHS_SPELL_FAERIE_FIRE: // No overlap of -10
                                case PHS_SPELL_DISPLACEMENT:
                                {
                                    // Remove all displacement and blurs
                                    RemoveEffect(oTarget, eCheck);
                                }
                                break;
                            }
                        }
                        break;
                    }
                    // Get next effect
                    eCheck = GetNextEffect(oTarget);
                }
                // Apply effects
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 1.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
