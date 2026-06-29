#!/usr/bin/env perl

use v5.14;
use warnings;

my $buf = "";
my $cnt;
my $overlap = 1024;
my $byte;

my @ref;
my @bookmark;

my %seen_bookmark;

while (read(STDIN, $byte, 1)) {
    $buf .= $byte;
    $cnt++;

                # <w:instrText xml:space="preserve"> REF _Ref227760336 
    if ($buf =~ m{<w:instrText xml:space="preserve"> *REF * ([^ ]+) $}) {
        push @ref, $1;
    } elsif (@ref and $buf =~ m{(<w:fldChar w:fldCharType="separate"/></w:r>)$}) {
        $cnt = 0;
    } elsif (@ref and $buf =~ m{(<w:r[^>]*><w:fldChar w:fldCharType="end"/></w:r>)$}) {
        $buf = substr($buf, 0, -$cnt).$1; # Remove text version of reference.
        my $ref = pop @ref;
        $buf .= qq{<w:r><w:t>«REF $ref»</w:t></w:r>};
    } elsif ($buf =~ m{<w:bookmarkStart w:id="[^"]+" w:name="([^"]+)"/>$}) {
        push @bookmark, $1;
    } elsif (@bookmark and $buf =~ m{<w:bookmarkEnd w:id="[^"]+"/>$}) {
        my $bookmark = pop @bookmark;
        if ($buf =~ m{</w:p><w:bookmarkEnd w:id="[^"]+"/>$}) {
            print STDERR "skipping bookmark $bookmark: outside paragraph\n";
        } elsif ($buf =~ m{<w:r><w:fldChar w:fldCharType="begin"/></w:r><w:bookmarkStart w:id="[^"]+" w:name="[^"]+"/><w:bookmarkEnd w:id="[^"]+"/>$}) {
            print STDERR "skipping bookmark $bookmark: inside field\n";
        } elsif ($seen_bookmark{$bookmark}) {
            print STDERR "skipping bookmark $bookmark: duplicate\n";
        } else {
            $buf .= qq{<w:r><w:t>«BOOKMARK $bookmark»</w:t></w:r>};
            $seen_bookmark{$bookmark} = 1;
        }
    }

    if (length($buf) > $overlap) {
        print substr($buf, 0, length($buf)-$overlap, "");
    }
}
print $buf;

# while (<<>>) {
#     if (q)
#     $file =~ s{<w:r w:rsidR="[^"]+"><w:fldChar w:fldCharType="begin"/></w:r>}{<w:t>«FLDBEG»</w:t>}g;
#     $file =~ s{<w:r w:rsidR="[^"]+"><w:fldChar w:fldCharType="end"/></w:r>}{<w:t>«FLDEND»</w:t>}g;
#     $file =~ s{<w:r w:rsidR="[^"]+"><w:fldChar w:fldCharType="end"/></w:r>}{<w:t>«FLDEND»</w:t>}g;
#     print;
# }
