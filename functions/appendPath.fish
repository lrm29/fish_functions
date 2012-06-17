function appendPath --description "Append values to path variable"

    not set -q $argv[1]; and set -gx $argv[1]

    for addVar in $argv[(seq 2 (count $argv))]
        test -d "$addVar"; or break;
        set -l tmp 1
        for path in $$argv[1]
            if test "$path" = "$addVar"
                set -g found $tmp
            end
            set tmp (math (count $tmp) + 1)
        end

        if set -q found
            set -e $argv[1][$found]
        end

        set -x $argv[1] $$argv[1] $addVar

        set -e found
    end

end
