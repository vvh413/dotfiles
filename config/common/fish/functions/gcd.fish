function gcd
    set -lx TOPLEVEL (git rev-parse --show-toplevel 2> /dev/null)
    if test $status -eq 0
        cd $TOPLEVEL
    end
end
