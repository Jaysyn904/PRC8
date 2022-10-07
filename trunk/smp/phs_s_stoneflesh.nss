/*:://////////////////////////////////////////////
//:: Spell Name Stone to Flesh
//:: Spell FileName PHS_S_StoneFlesh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One petrified creature or a cylinder of stone
    Duration: Instantaneous
    Saving Throw: Fortitude negates (object); see text
    Spell Resistance: Yes

    This spell restores a petrified creature to its normal state, restoring life
    and goods. The creature must make a DC 15 Fortitude save to survive the
    process. Any petrified creature, regardless of size, can be restored.

    The spell also can convert a mass of stone into a fleshy substance. Such
    flesh is inert and lacking a vital life force unless a life force or magical
    energy is available. (For example, this spell would turn a stone golem into
    a flesh golem, but an ordinary statue would become a corpse.) You can affect
    an object that fits within a cylinder from 1 foot to 3 feet in diameter and
    up to 10 feet long or a cylinder of up to those dimensions in a larger mass
    of stone.

    Material Component: A pinch of earth and a drop of blood.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy to do:

    - Restore any petrified creature

    Not easy to do:

    - Convert a stone golem to a flesh golem
    - Convert stone to a fleshy substance.

    Do the first, only, for now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STONE_TO_FLESH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nType = GetObjectType(oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STONE_TO_FLESH, FALSE);

    // We restore them if it is a creature
    if(nType == OBJECT_TYPE_CREATURE)
    {
        // Petrified? No SR checks
        if(PHS_GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget))
        {
            // DC 15 or death
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, 15))
            {
                // Death
                PHS_ApplyDeathByDamage(oTarget);
            }
            else
            {
                // Removal of petrify
                PHS_RemoveSpecificEffect(EFFECT_TYPE_PETRIFY, oTarget, SUBTYPE_IGNORE);
            }
        }
        // Else, Golem?
        // * Should work fine on PC's this method.
        else if(GetAppearanceType(oTarget) == APPEARANCE_TYPE_GOLEM_STONE)
        {
            // Spell resistance checks
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Fortitude negates
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
                {
                    // Turn to flesh golem
                    SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_GOLEM_FLESH);

                    // Destroy stone golem hide properties
                    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);

                    // Destroy them
                    IPRemoveAllItemProperties(oHide, DURATION_TYPE_PERMANENT);
/*  // Add the flesh golem ones.
    +1 Soak 15 damage
    50% fire vunrability
    Immunity:
    Critical hits
    Death magic
    Disease
    Level/Ability Drain
    Mind-affecting
    Paralysis
    Poison
    Sneak attack   */
                    // Add those above
                    itemproperty IP_Add = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEVULNERABILITY_50_PERCENT);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);
                    IP_Add = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
                    AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oHide);

                    // Change all attacks to 2d8 damage
                    int nCnt;
                    object oClaw;
                    for(nCnt = INVENTORY_SLOT_CWEAPON_L; nCnt <= INVENTORY_SLOT_CWEAPON_B; nCnt++)
                    {
                        // Get claw (or punch or whatever)
                        oClaw = GetItemInSlot(nCnt, oTarget);

                        // Remove old ones
                        IPRemoveAllItemProperties(oClaw, DURATION_TYPE_PERMANENT);

                        // 2d8 damage, nothing else
                        IP_Add = ItemPropertyMonsterDamage(IP_CONST_MONSTERDAMAGE_2d8);
                        AddItemProperty(DURATION_TYPE_PERMANENT, IP_Add, oClaw);
                    }
                }
            }
        }
    }
    else
    {
        // Turn some stone...to flesh...
        // Placables ETC.
        // Spell resistance checks
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Fortitude negates
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC))
            {
            }
        }
    }
}
