/*:://////////////////////////////////////////////
//:: Spell Name Appraisal
//:: Spell FileName XXX_S_Appraisal
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 1, Sor/Wiz 1
    Components: V, S, F
    Casting Time: 1 full round
    Range: Touch
    Target: One item
    Duration: Instantaneous
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)
    Source: Various (Aenea DM)

    When this spell is cast, it brings to the caster's mind the amount of money,
    to within 10% of their value, that the item is worth to the average buyer.
    An item may be worth more or less to specific buyers, but this spell provides
    only what an average buyer would pay for it.

    If this spell is cast on a magical item, the appraisal is based only on the
    non-magical properties of the item, with any magical weapons being treated
    as masterwork, +1 attack only, weapons.

    Focus: A miniature scale worth at least 50 gp.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The example was:

    If this spell is cast on a magical item, the appraisal is based only on the
    non-magical properties of the item. As an example, a keen flaming longsword
    +1 would, according to this spell, be worth between 284 gp and 346 gp
    (within 10% of the price of a masterwork longsword, which is 315 gp).

    Which is fine.

    This is done via. 2da lookups, as to make it easier. Noting, of course, that
    unless they know it is masterwork, they will not even get the +1 attack bonus
    bonus to the price.

    Arrows ETC which are treated as 1 GP, cannot be anything but 1GP. Nothing
    will be estimated at 0.

    Masterwork (+1 attack) costs 404 when added to a blank weapon - thusly, this
    is how much will be added if the weapon is actually magical.

    NOTE:

    Average buyer, as it is only the base cost, is using a check of 100% basically.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

const int SMP_MASTERWORK_BONUSPRICE = 404;

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_APPRAISAL)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oPossessor = GetItemPossessor(oTarget);
    int nValue, nBasePrice;
    int bMagical = SMP_IP_GetIsEnchanted(oTarget);
    int bIdentified = GetIdentified(oTarget);
    int bPlot = GetPlotFlag(oTarget);
    float fTimesBy;

    // Check for focus
    if(!SMP_ComponentFocusItem(SMP_ITEM_MINATURE_SCALES, "Minature scales worth at least 50GP", "Appraisal")) return;

    // Check target - must be an item
    if(GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
        FloatingTextStringOnCreature("*You must cast appraisal on a item*", oCaster, FALSE);
        return;
    }

    // Signal event for possessor - make sure it is some valid creature (else, the caster)
    if(!GetIsObjectValid(oPossessor))
    {
        oPossessor = oCaster;
    }

    // If plot, report it (they'd know if they tried to sell it anyway)
    if(bPlot == TRUE)
    {
        FloatingTextStringOnCreature("*The item targeted is too important to sell*", oCaster, FALSE);
    }
    else
    {
        // Report the price
        nBasePrice = StringToInt(Get2DAString("baseitems", "BaseCost", GetBaseItemType(oTarget)));

        // If identified, we will know if it is magical
        if(bIdentified == TRUE)
        {
            // If magical, add on the SMP_MASTERWORK_BONUSPRICE amount
            if(bMagical == TRUE)
            {
                nBasePrice += SMP_MASTERWORK_BONUSPRICE;
            }
        }

        // 10% either way.
        if(d2() == 1)
        {
            // Add 0-10% value
            fTimesBy = 1.0 + (IntToFloat(Random(10001)) / 100000);
            if(fTimesBy == 0.0 || fTimesBy == 1.0)
            {
                nValue = nBasePrice;
            }
            else
            {
                nValue = FloatToInt(IntToFloat(nBasePrice) * fTimesBy);
            }
        }
        else
        {
            // Take away 0-10% value
            fTimesBy = 1.0 - (IntToFloat(Random(10001)) / 100000);
            if(fTimesBy == 0.0 || fTimesBy == 1.0)
            {
                nValue = nBasePrice;
            }
            else
            {
                nValue = FloatToInt(IntToFloat(nBasePrice) * fTimesBy);
            }
        }
        // Check nValue, must be >= 1
        if(nValue < 1) nValue = 1;

        // Report value
        FloatingTextStringOnCreature("*You determine " + GetName(oTarget) + " to be worth around " + IntToString(nValue) + "GP*", oCaster, FALSE);

        // Delcare effects
        effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

        // Signal event
        SMP_SignalSpellCastAt(oPossessor, SMP_SPELL_APPRAISAL, FALSE);

        // Apply effects
        SMP_ApplyVFX(oPossessor, eVis);
    }
}
