function cleanPath --description "Clean the supplied path variable"

    set -l tmpPath

    # Check that the path exists
    for path in $$argv[1]
        # Remove trailing /
        set path (echo $path | sed 's/\/$//')
        if test -d "$path"
            # Check that there are no duplicates
            set -l found false
            for i in $tmpPath
                test "$path" = "$i"; and set found true
            end
            test $found = false; and set tmpPath $tmpPath $path
        end
    end

    # Erase if empty, otherwise set the path
    test -z $tmpPath[1];
        and set -e $argv[1];
        or set -x $argv[1] $tmpPath

end
