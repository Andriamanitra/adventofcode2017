import Base.print_matrix

result = 0

function neighbor_sum(grid, x, y)
    global result
    sum = grid[x-1, y-1]+grid[x, y-1]+grid[x+1, y-1]+grid[x-1, y]+grid[x+1, y]+grid[x-1, y+1]+grid[x, y+1]+grid[x+1, y+1]
    if sum >= target && result == 0
        result = sum
    end
    return sum
end

function main()
    matrix_dims::Int = 13

    grid = zeros(Int, matrix_dims, matrix_dims)
    x::Int = ceil(matrix_dims/2)
    y::Int = ceil(matrix_dims/2)

    grid[x, y] = 1
    
    round = 1

    y += 1
    while y < matrix_dims
        # go up
        for i in 1:(2*round-1)
            grid[x, y] = neighbor_sum(grid, x, y)
            x -= 1
        end
        # go left
        for i in 1:(2*round)
            grid[x, y] = neighbor_sum(grid, x, y)
            y -= 1
        end
        # go down
        for i in 1:(2*round)
            grid[x, y] = neighbor_sum(grid, x, y)
            x += 1
        end
        # go right
        for i in 1:(2*round+1)
            grid[x, y] = neighbor_sum(grid, x, y)
            y += 1
        end
        round += 1
    end
    # uncomment to print the whole thing
    #print_matrix(STDOUT, grid[2:(size(grid,1)-1), 2:(size(grid,2)-1)]);println()
end

f = open("3-input.txt")
target = parse(Int, readstring(f))
main()
println("First number bigger than target ($target) is $result")