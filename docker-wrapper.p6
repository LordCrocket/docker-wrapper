#!/usr/bin/perl6
use v6;
#use Grammar::Tracer;

#https://github.com/docker/distribution/blob/master/reference/reference.go
grammar Docker {
    rule TOP { '/usr/bin/docker' <command> }
    rule command { <build>|<ps>|<rm> } 
    rule ps { ps [\-a]?}
    rule rm { rm <digest-hex> } 
    rule build { build \-t <image-name> . } 

    rule image-name { [<hostname>'/']? <component> ['/' <component>]* }
    rule component { <alpha-numeric> [<separator> <alpha-numeric>]* }
    rule alpha-numeric { <[a..z0..9]>+ }
    rule separator { <[_.]>|_|[\-]* }

    rule hostname { <hostcomponent> ['.' <hostcomponent>]* [':'<port-number>]? }
    rule hostcomponent { [\w|\-]+}
    rule digest-hex { <[ 0..9a..fA..F ]>+ }

    rule port-number { \d+ }

}
my $command = @*ARGS.join(" ");
if (Docker.parse($command)) {
    shell $command;
}
else {
    note "Not allowed to run: $command";
}
