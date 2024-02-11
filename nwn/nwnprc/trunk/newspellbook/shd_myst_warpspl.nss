/*
14/02/19 by Stratovarius

Warp Spell

Initiate, Black Magic 
Level/School: 4th/ Abjuration 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: A spell or mystery cast by someone else 
Duration: Instantaneous 
Saving Throw: Will negates; see text 
Spell Resistance: No

You reach out with shadowy energies, banishing your foe’s spell or mystery into the Plane of Shadow while replacing it with its dark re?ection.

You can cast this mystery as an immediate action to warp another caster’s spell or mystery. In this case, warp spell must be used at the moment of the other caster’s casting. To 
be successful, you must beat the other caster on an opposed caster level check (1d20 + caster level). If you do not, you have failed to take control of his spell or mystery, and 
it manifests normally. If you succeed on the opposed check, the other caster’s mystery or spell is countered, as if you had used the counterspell action successfully, and you 
gain one additional use of an apprentice-path mystery that you know. You can keep this additional use until a later turn (requiring a standard action to activate), but it must be 
used within 1 hour or it is lost. You can also combine the activation of the additional spell or mystery with the immediate action required for the warp spell mystery itself, 
allowing you to cast the apprentice-path mystery out of turn.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

    if(myst.bCanMyst)
    {
        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_NONE))
        {    
            SetLocalInt(oTarget, "WarpSpell", myst.nShadowcasterLevel);
            SetLocalObject(oTarget, "WarpSpell", oShadow);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST), oTarget);
        }    
    }
}