<div class="box">
    <h3>Manual</h3>
    <ul id="bonsai">
        <li><a id="main" href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=main">~~~MAIN~~~</a></li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=base_classes">~~~BASE_CLASSES~~~</a>
            <?php if ($section == "base_classes") { ?>
            <ul id="base_classes">
                ~~~BASE_CLASSES_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=prestige_classes">~~~PRESTIGE_CLASSES~~~</a>
            <?php if ($section == "prestige_classes") { ?>
            <ul id="prestige_classes">
                ~~~PRESTIGE_CLASSES_ENTRIES~~~
            </ul>
            <?php } ?>
         </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=domains">~~~DOMAINS~~~</a>
            <?php if ($section == "domains") { ?>
            <ul id="domains">
                ~~~DOMAINS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=feats">~~~FEATS~~~</a>
            <?php if ($section == "feats") { ?>
            <ul id="feats">
                <!-- Link to a list of all feats goes here -->
                <li><a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=feats&amp;page=alphasortedfeats">~~~ALL_FEATS~~~</a></li>

                <li style="list-style:none"><hr style="width:160px; margin-left:0;" /></li>
                <!-- Links to masterfeats go here -->
                ~~~MASTERFEAT_ENTRIES~~~

                <li style="list-style:none"><hr style="width:160px; margin-left:0;" /></li>
                <!-- Links to non-master, non-successor feats go here -->
                ~~~FEAT_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=epic_feats">~~~EPIC_FEATS~~~</a>
            <?php if ($section == "epic_feats") { ?>
            <ul id="epic_feats">
                <!-- Link to a list of all feats goes here. featpagelink -->
                <li><a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=epic_feats&amp;page=alphasortedepicfeats">~~~ALL_EPIC_FEATS~~~</a></li>

                <li style="list-style:none"><hr style="width:160px; margin-left:0;" /></li>
                <!-- Links to masterfeats go here. Series of featpagelink -->
                ~~~EPIC_MASTERFEAT_ENTRIES~~~

                <li style="list-style:none"><hr style="width:160px; margin-left:0;" /></li>
                <!-- Links to non-master, non-successor feats go here. Series of featpagelink -->
                ~~~EPIC_FEAT_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=psionic_powers">~~~PSIONIC_POWERS~~~</a>
            <?php if ($section == "psionic_powers") { ?>
            <ul id="psionic_powers">
                ~~~PSIONIC_POWERS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=utterances">~~~TRUENAME_UTTERANCES~~~</a>
            <?php if ($section == "utterances") { ?>
            <ul id="utterances">
                ~~~TRUENAME_UTTERANCES_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=races">~~~RACES~~~</a>
            <?php if ($section == "races") { ?>
            <ul id="races">
                ~~~RACES_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=skills">~~~SKILLS~~~</a>
            <?php if ($section == "skills") { ?>
            <ul id="skills">
                ~~~SKILLS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=spells">~~~SPELLS~~~</a>
            <?php if ($section == "spells") { ?>
            <ul id="spells">
                ~~~SPELLS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=epic_spells">~~~EPIC_SPELLS~~~</a>
            <?php if ($section == "epic_spells") { ?>
            <ul id="epic_spells">
                ~~~EPIC_SPELLS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li>
            <a href="<?= DLA_WEBROOT ?>/index.php?location=manual&amp;lang=~~~LANG_ID~~~&amp;section=modified_spells">~~~MODIFIED_SPELLS~~~</a>
            <?php if ($section == "modified_spells") { ?>
            <ul id="modified_spells">
                ~~~MODIFIED_SPELLS_ENTRIES~~~
            </ul>
            <?php } ?>
        </li>
        <li style="list-style:none"><hr style="width:160px; margin-left:0;" /></li>
        ~~~LANG_SPEC_STATIC_MENUS~~~
    </ul>
</div>
