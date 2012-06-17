function removeFromPath --description "Remove variables  2...N (if present) from first variable"

    # remove args from given array
    for removeVar in $argv[(seq 2 (count $argv))]
        set -e tmp
        for path in $$argv[1]
            if test "$path" = "$removeVar"
                set eraseElementIndex $eraseElementIndex (math (count $tmp)+1)
            end
            set tmp $tmp $path
        end
    end

    if set -q eraseElementIndex
        set -e $argv[1][$eraseElementIndex]
    end

    # erase if blank
    if test -z $argv[1]
        set -e $$argv[1]
    end

end
