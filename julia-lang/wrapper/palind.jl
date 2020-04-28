function is_palind(palavra::String)
    length(palavra) == 1 && return true
    j = length(palavra)+1
    for i = 1:length(palavra)
        j-=1
        if palavra[j] != palavra[i]
            return false
        end
    end
    return true
end


while true
    println(is_palind(readline()))
end
