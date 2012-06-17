function edit -d "Open a file using scribes"
    for file in $argv
        if test -e $file
            EDITOR $file
            echo "Opening file $file"
        else
            echo "Create file? (y/n)"
            read createFile
            if test $createFile = "y"
                EDITOR -n $file
                echo "Creating file $file"
            end
        end
    end
end
