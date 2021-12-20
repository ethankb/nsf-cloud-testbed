#!/usr/bin/perl -w

#
# summary_extract.pl
#

#
# This ugly script takes latex in and spits out clean-ish ASCII,
# suitable for cut-and-paste into NSF's web form.
#
# At one point it was sed, but then we added enumerate
# which forces a stateful scripting language.
#

my($BEFORE_SUMMARY, $IN_SUMMARY, $AFTER_SUMMARY) = (0..10);
my($state) = $BEFORE_SUMMARY;
my($enum_counter) = 0;
while (<>) {
    # extract the summary, bounded by \SummaryStartHere and \SummaryEndHere
    # (we assume those are defined to be null commands in macros.tex).
    if ($state == $BEFORE_SUMMARY) {
        if (/\\SummaryStartHere/) {
            $state = $IN_SUMMARY;
        };
        next;
    } elsif ($state == $AFTER_SUMMARY) {
        next;
    };
    # assert($state == $IN_SUMMARY);
    if (/\\SummaryEndHere/) {
        $state = $AFTER_SUMMARY;
        next;
    };
    # bf => uppercase
    s/\\textbf\{([^}]+)\}/uc($1)/ge;
    # clean up different kinds of latex
    next if (/^ *%/); 
    s/~*\\(reviewfix|cite)\{[^}]*\}//g;
    s/%.*$$//;
    s/\\(textbf|emph|SummarySpace|url|tightlist)//g;
    s/\\end\{small\}//g;
    s/^ *//;
    s/(``|'')/"/g;
    s/~/ /g;
    # recreate enumeration (the whole point of this script)
    if (/\\begin\{enumerate\}/) {
        $enum_counter = 0;
        next;
    };
    if (/\\end\{enumerate\}/) {
        next;
    };
    if (/\\def\\labelenumi.*/) {
        next;
    };
    if (/^\\item/) {
        $enum_counter++;
        print "\n$enum_counter. ";
        next;
    };
    print;
};

