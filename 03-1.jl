function dist_to_center_from(target::Int)
    ring_size::Int = isqrt(target)//2*2+1
    corner_to_center::Int = ring_size-1
    target_to_corner::Int = (ring_size^2 - target)%((ring_size-1)/2)

    return corner_to_center-target_to_corner
end

f = open("03-input.txt")
target = parse(Int, readstring(f))

result = dist_to_center_from(target)
println("Distance to center: $result")