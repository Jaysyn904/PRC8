//::///////////////////////////////////////////////
//:: Name
//:: FileName  sp_prismt_sphr.nss
//:://////////////////////////////////////////////
/**@file Prismatic Sphere
Abjuration
Level: Protection 9, Sor/Wiz 9, Sun 9
Components: V
Range: 10 ft.
Effect: 10-ft.-radius sphere centered on you

This spell functions like prismatic wall, except you
conjure up an immobile, opaque globe of shimmering,
multicolored light that surrounds you and protects
you from all forms of attack. The sphere flashes in
all colors of the visible spectrum.

The sphere's blindness effect on creatures with less
than 8 HD lasts 2d4x10 minutes.

You can pass into and out of the prismatic sphere and
remain near it without harm. However, when you are
inside it, the sphere blocks any attempt to project
something through the sphere (including spells). Other
creatures that attempt to attack you or pass through
suffer the effects of each color, one at a time.

Typically, only the upper hemisphere of the globe will
exist, since you are at the center of the sphere, so
the lower half is usually excluded by the floor surface
you are standing on.

The colors of the sphere have the same effects as the
colors of a prismatic wall:

Red     1st     Deals 20 points of fire damage (Reflex half).
Orange  2nd     Deals 40 points of acid damage (Reflex half).
Yellow  3rd     Deals 80 points of electricity damage (Reflex half).
Green   4th     Poison (Kills; Fortitude partial for 1d6 points of Con damage instead).
Blue    5th     Turned to stone (Fortitude negates).
Indigo  6th     Will save or become insane (as insanity spell).
Violet  7th     Creatures sent to another plane (Will negates).

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool(SPELL_SCHOOL_ABJURATION);

        object oPC = OBJECT_SELF;
        location lTarget = GetLocation(oPC);
        object oTarget;
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDuration;
        float fDelay;
        float fDurFX = 3.0;
        float fDurAoE = TurnsToSeconds(nCasterLvl * 10);
        if (nMetaMagic & METAMAGIC_EXTEND) fDurAoE += fDurAoE;

        /*
        // Added a hearbeat script since .2DA only points to A and B for on enter and on exit
        //     LABEL                             SHAPE RADIUS WIDTH LENGTH ONENTER           ONEXIT            HEARTBEAT
        // 173 VFX_PER_PRISMATIC_SPHERE          C     3.048  ****  ****   sp_prismt_sphrA   sp_prismt_sphrB   ****
        */
        effect eAoE = EffectAreaOfEffect(VFX_PER_PRISMATIC_SPHERE, "sp_prismt_sphrA", "sp_prismt_sphrH", "sp_prismt_sphrB");
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lTarget, fDurAoE);
        object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_PRISMATIC_SPHERE");
        SetAllAoEInts(SPELL_PRISMATIC_SPHERE, oAoE, PRCGetSpellSaveDC(SPELL_PRISMATIC_SPHERE, SPELL_SCHOOL_ABJURATION), 0, nCasterLvl);

        //SendMessageToPC(oPC, "Casting a modified Prismatic Sphere with dur: " + FloatToString(fDurAoE));

        // Handles visual fx of the spell (and continued on the heartbeat script) since the fx seem to last max 3 secs.
        effect eVFX = EffectVisualEffect(VFX_DUR_PRISMATIC_SPHERE, FALSE, 1.0, [0.0,0.0,0.064], [0.0,0.0,0.36]);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lTarget, fDurFX);
        // Repeats the vFX after 3 seconds
        DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lTarget, fDurFX));

        // Declare blindness
        effect eBlind = EffectBlindness();

        // Start cycling through the AOE Object for viable targets
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);

        while(GetIsObjectValid(oTarget))
        {

                // PvP check
                if(!GetIsReactionTypeFriendly(oTarget, oPC) &&
                // Make sure they are not immune to spells
                !PRCGetHasEffect(EFFECT_TYPE_SPELL_IMMUNITY, oTarget))
                {
                        // Check HD
                        if(GetHitDice(oTarget) <= 8)
                        {
                                // Fire cast spell at event for the affected target
                                PRCSignalSpellEvent(oTarget, TRUE, SPELL_PRISMATIC_SPHERE, oPC);

                                // Check if they can see
                                if(!PRCGetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget))
                                {
                                        // Check spell resistance
                                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl))
                                        {
                                                // Get duration
                                                fDuration = IntToFloat(d4(2) * 10);
                                                if(nMetaMagic & METAMAGIC_EXTEND) fDuration += fDuration;

                                                // Get a small delay
                                                fDelay = GetDistanceToObject(oTarget)/20;

                                                // Apply blindness
                                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration, TRUE, SPELL_PRISMATIC_SPHERE, nCasterLvl));
                                        }
                                }
                        }
                }
                //Get next target.
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
        PRCSetSchool();
}
