#!/usr/bin/perl -w

#
# summary_extract.pl
#

my($BEFORE_SUMMARY, $IN_SUMMARY, $AFTER_SUMMARY) = (0..10);
my($state) = $BEFORE_SUMMARY;
my($enum_counter) = 0;
while (<>) {
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
    next if (/^ *%/); 
    s/~*\\(reviewfix|cite)\{[^}]*\}//g;
    s/%.*$$//;
    s/\\(textbf|emph|SummarySpace|url|tightlist)//g;
    s/\\end\{small\}//g;
    s/^ *//;
    s/(``|'')/"/g;
    s/~/ /g;
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
    # fancy enumeration
    print;
};

