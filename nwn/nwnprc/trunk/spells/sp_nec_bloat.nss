//::///////////////////////////////////////////////
//:: Name      Necrotic Bloat
//:: FileName  sp_nec_bloat.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Bloat
Necromancy [Evil]
Level: Clr 3, sor/wiz 3
Components: V, S, F
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: Living creature with necrotic cyst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You cause the cyst of a subject already harboring
a necrotic cyst (see spell of the same name) to
pulse and swell. This agitation of the necrotic
cyst tears living tissue and expands the size of
the cyst, dealing massive internal damage to the
subject. The subject takes 1d6 points of damage
per level (maximum 10d6), and half the damage is
considered vile damage because the cyst expands
to envelop the newly necrotized tissue. The cyst
is reduced to its original size when the vile
damage is healed.

Vile damage can only be healed
by magic cast within the area of a consecrate or
hallow spell (or an area naturally consecrated or
hallowed). Points of vile damage represent such
an evil violation to a character's body or soul
that only in a holy place, with holy magic, can
the damage be repaired.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_necro_cyst"
#include "inc_utility"

void main()
{
    // Set the spellschool
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;


    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nLevel = PRCMin(PRCGetCasterLevel(oPC), 10);
    int nMetaMagic = PRCGetMetaMagicFeat();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NECROTIC_BLOAT, oPC);

    if(!GetCanCastNecroticSpells(oPC))
    return;

    if(!GetHasNecroticCyst(oTarget))
    {
        // "Your target does not have a Necrotic Cyst."
        SendMessageToPCByStrRef(oPC, nNoNecCyst);
        return;
    }

    //Resolve spell
    int nDam = d6(nLevel);

    //Metmagic: Maximize
    if (nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDam = 6 * (nLevel);
    }

    //Metmagic: Empower
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDam += (nDam/2);
    }
	nDam += SpellDamagePerDice(oPC, nLevel);
    int nVile = nDam/2;
    int nNorm = (nDam - nVile);

    //Vile damage is currently being applied as Positive damage
    effect eVileDam = PRCEffectDamage(oTarget, nVile, DAMAGE_TYPE_POSITIVE);
    effect eNormDam = PRCEffectDamage(oTarget, nNorm, DAMAGE_TYPE_MAGICAL);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);


    PRCSetSchool();

    //SPEvilShift(oPC);
}
