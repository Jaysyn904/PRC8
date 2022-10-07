/*
12/1/20 by Stratovarius

Unicorn Horn

Descriptors: Mind-Affecting  
Classes: Totemist 
Chakra: Brow (totem) 
Saving Throw: None

You shape the pure soul energy of a unicorn into an ivory-colored horn that seems to sprout from your forehead. Its color is an unblemished white, and it seems to glow with a soft blue-white radiance. Its purity flows into you, and it is difficult to conceive of an evil thought with the horn so close to your mind.

You gain a +2 competence bonus on Animal Empathy and Move Silently checks. 

Essentia: Your bonus on Animal Empathy and Move Silently checks increases by 2 for every point of invested essentia. 

Chakra Bind (Brow) 

A streak of white appears in your hair near the unicorn horn, and your eyes change color—becoming deep sea-blue, violet, or fiery gold.

You gain the ability to detect evil once per round as a standard action. 

Chakra Bind (Totem)

A tuft of white hair hangs down from your forehead around your unicorn horn, while your forehead itself thickens somewhat to support the horn it bears. All of your hair transforms into a cascading white mane, and if you are male a white beard sprouts from your chin. You can feel purity and energy flowing into your body through your horn.

You can gore with the unicorn horn as a natural weapon that deals 1d6 points of damage. You gain an enhancement bonus on attack rolls and damage rolls with your horn equal to the number of points of essentia you invest in it. If you hit an undead creature with your horn attack, you deal an extra 1d6 points of damage. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    ActionCastSpell(SPELL_DETECT_EVIL, GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_UNICORN_HORN), 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
}