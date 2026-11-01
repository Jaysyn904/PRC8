/*
03/02/21 by Stratovarius

Pact Augmentation (Su): Beginning at 2nd level, you can draw additional power from the vestiges you bind. As long as you are bound to at least one vestige, you can choose
one ability from the following list. Each time you rebind a vestige, you also reselect your pact augmentation ability. 

As you attain higher levels, you can make additional selections from the list. You gain one additional ability at 5th, 10th, 16th, and 20th level (to a maximum of five selections
at 20th level). You can choose a single ability multiple times, and their effects stack. For instance, at 16th level you could choose bonus hit points twice and damage reduction twice,
gaining +10 hit points and damage reduction 2/-.

Pact Augmentation Abilities
+5 hit points
Energy resistance 5 (acid, cold, electricity, fire, or sonic)
+1 insight bonus on saving throws
Damage reduction 1/-
+1 insight bonus to Armor Class
+1 insight bonus on attack rolls
+1 insight bonus on damage rolls
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_natweap"

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    if (!GetIsObjectValid(oBinder)) oBinder = OBJECT_SELF;

    // Synchronously remove any prior Pact Augmentation effects on impact before applying
    // the new eLink so async "x0_rodwonder" casts never stack 2x/4x.
    PRCRemoveSpellEffects(VESTIGE_PACT_AUGMENTATION, oBinder, oBinder);
    GZPRCRemoveSpellEffects(VESTIGE_PACT_AUGMENTATION, oBinder, FALSE);
    effect eOldAug = GetFirstEffect(oBinder);
    while (GetIsEffectValid(eOldAug))
    {
        if (GetEffectSpellId(eOldAug) == VESTIGE_PACT_AUGMENTATION || GetEffectTag(eOldAug) == "BinderPactAugmentEff")
            RemoveEffect(oBinder, eOldAug);
        eOldAug = GetNextEffect(oBinder);
    }

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Zuriel's Pact Fortification doubles all benefits received from Pact Augmentation.
    // Check both GetHasSpellEffect(VESTIGE_ZURIEL) and GetLocalInt("ZurielBoundActive") so
    // Zuriel's 2x multiplier applies whether Zuriel is bound first, bound last, or still resolving its cast.
    int bZurielActive = !GetLocalInt(oBinder, "ZurielExpellingNow") && (GetHasSpellEffect(VESTIGE_ZURIEL, oBinder) || GetLocalInt(oBinder, "ZurielBoundActive"));
    int nMult = (bZurielActive && !GetIsVestigeExploited(oBinder, VESTIGE_ZURIEL_PACT_FORTIFICATION)) ? 2 : 1;

    int i, bHasNewSelection = FALSE;
    for(i = 1; i <= 11; i++)
    {
        if (GetLocalInt(oBinder, "PactAugment"+IntToString(i)) > 0)
            bHasNewSelection = TRUE;
    }
    if (bHasNewSelection)
    {
        for(i = 1; i <= 11; i++)
            SetLocalInt(oBinder, "SavedPactAugment"+IntToString(i), GetLocalInt(oBinder, "PactAugment"+IntToString(i)));
    }

    int nAug1  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment1")  : GetLocalInt(oBinder, "SavedPactAugment1"))  * nMult;
    int nAug2  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment2")  : GetLocalInt(oBinder, "SavedPactAugment2"))  * nMult;
    int nAug3  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment3")  : GetLocalInt(oBinder, "SavedPactAugment3"))  * nMult;
    int nAug4  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment4")  : GetLocalInt(oBinder, "SavedPactAugment4"))  * nMult;
    int nAug5  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment5")  : GetLocalInt(oBinder, "SavedPactAugment5"))  * nMult;
    int nAug6  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment6")  : GetLocalInt(oBinder, "SavedPactAugment6"))  * nMult;
    int nAug7  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment7")  : GetLocalInt(oBinder, "SavedPactAugment7"))  * nMult;
    int nAug8  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment8")  : GetLocalInt(oBinder, "SavedPactAugment8"))  * nMult;
    int nAug9  = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment9")  : GetLocalInt(oBinder, "SavedPactAugment9"))  * nMult;
    int nAug10 = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment10") : GetLocalInt(oBinder, "SavedPactAugment10")) * nMult;
    int nAug11 = (bHasNewSelection ? GetLocalInt(oBinder, "PactAugment11") : GetLocalInt(oBinder, "SavedPactAugment11")) * nMult;

    // Temp HP: MUST be applied as a standalone unlinked effect (never inside EffectLinkEffects),
    // because NWN CNWSEffectListHandler::OnEffectRemoved only subtracts m_nTemporaryHitPoints when
    // the top-level effect type is EFFECT_TYPE_TEMPORARY_HITPOINTS (not EFFECT_TYPE_LINK).
    if (nAug1)
    {
        effect eTempHP = TagEffect(SupernaturalEffect(EffectTemporaryHitpoints(nAug1 * 5)), "BinderPactAugmentEff");
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oBinder, HoursToSeconds(24));
    }
    if (nAug2) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, nAug2 * 5));
    if (nAug3) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nAug3 * 5));
    if (nAug4) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nAug4 * 5));
    if (nAug5) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, nAug5 * 5));
    if (nAug6) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, nAug6 * 5));
    if (nAug7) eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAug7));
    if (nAug8)
    {
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nAug8));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, nAug8));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, nAug8));
    }
    if (nAug9)  eLink = EffectLinkEffects(eLink, EffectACIncrease(nAug9));
    if (nAug10) eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAug10));
    if (nAug11) eLink = EffectLinkEffects(eLink, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nAug11)));

    eLink = TagEffect(SupernaturalEffect(eLink), "BinderPactAugmentEff");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oBinder, HoursToSeconds(24));

    // Clean up time
    for(i = 0; i <= 11; i++)
        DeleteLocalInt(oBinder, "PactAugment"+IntToString(i));
}
