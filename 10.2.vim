let pi = acos(-1)

let input = ['#.....#...#.........###.#........#..', '....#......###..#.#.###....#......##', '......#..###.......#.#.#.#..#.......', '......#......#.#....#.##....##.#.#.#', '...###.#.#.......#..#...............', '....##...#..#....##....#...#.#......', '..##...#.###.....##....#.#..##.##...', '..##....#.#......#.#...#.#...#.#....', '.#.##..##......##..#...#.....##...##', '.......##.....#.....##..#..#..#.....', '..#..#...#......#..##...#.#...#...##', '......##.##.#.#.###....#.#..#......#', '#..#.#...#.....#...#...####.#..#...#', '...##...##.#..#.....####.#....##....', '.#....###.#...#....#..#......#......', '.##.#.#...#....##......#.....##...##', '.....#....###...#.....#....#........', '...#...#....##..#.#......#.#.#......', '.#..###............#.#..#...####.##.', '.#.###..#.....#......#..###....##..#', '#......#.#.#.#.#.#...#.#.#....##....', '.#.....#.....#...##.#......#.#...#..', '...##..###.........##.........#.....', '..#.#..#.#...#.....#.....#...###.#..', '.#..........#.......#....#..........', '...##..#..#...#..#...#......####....', '.#..#...##.##..##..###......#.......', '.##.....#.......#..#...#..#.......#.', '#.#.#..#..##..#..............#....##', '..#....##......##.....#...#...##....', '.##..##..#.#..#.................####', '##.......#..#.#..##..#...#..........', '#..##...#.##.#.#.........#..#..#....', '.....#...#...#.#......#....#........', '....#......###.#..#......##.....#..#', '#..#...##.........#.....##.....#....']
let base = [26, 29]

function! Rad(you, point)
  let x = a:point[0] - a:you[0]
  let y = a:point[1] - a:you[1]

  let rad = acos(-y / sqrt(x*x + y*y))
  if x >= 0
    return rad
  else
    return acos(-1) * 2 - rad
  endif
endfunction

function! Test(result, expected, name)
  if round(a:result * 10000) != round(a:expected * 10000)
    echom '---------------'
    echom a:name." failed"
    echom "Result: "
    echom a:result
    echom "Expected: "
    echom a:expected
  endif
endfunction

call Test(Rad([8, 3], [8, 1]), 0, "Rad 0")
call Test(Rad([8, 3], [9, 2]), pi * 0.25, "Rad 0.25")
call Test(Rad([8, 3], [12, 3]), pi * 0.5, "Rad 0.5")
call Test(Rad([8, 3], [8, 4]), pi * 1, "Rad 1")
call Test(Rad([8, 3], [2, 3]), pi * 1.5, "Rad 1.5")
call Test(Rad([8, 3], [7, 4]), pi * 1.25, "Rad 1.75")
call Test(Rad([8, 3], [7, 0]), 5.961435, "Rad [0, 7]")

function! FlatMap(list, func)
  let list = map(copy(a:list), a:func)
  let res = []
  for item in list
    for jtem in item
      call add(res, jtem)
    endfor
  endfor
  return res
endfunction

let Point = {input -> filter(FlatMap(input, {i, line -> map(split(line, '\zs'), {j, char -> [j,i]})}), {idx, val -> input[val[1]][val[0]] == '#'})}

let points = Point(input)

function! Dist(a, b)
  let x = a:a[0] - a:b[0]
  let y = a:a[1] - a:b[1]
  return abs(x) + abs(y)
endfunction

let asteroids = []
for [x, y] in points
  call add(asteroids, {
        \ 'x': x,
        \ 'y': y,
        \ 'angle': Rad(base, [x, y]),
        \ 'dist': Dist(base, [x, y])
        \})
endfor

func DistSort(a, b)
  let diff = a:a['dist'] - a:b['dist']
  if diff == 0.0
    return 0
  elseif diff > 0
    return 1
  else
    return -1
  endif
endfunction

function! Rank(asteroids)
  for asteroid in a:asteroids
    function! SameAngle(_, a) closure
      return round(a:a['angle'] * 10000) == round(asteroid['angle'] * 10000)
    endfunction
    let same = filter(copy(a:asteroids), function("SameAngle"))
    call sort(same, "DistSort")
    let asteroid['rank'] = index(same, asteroid)
  endfor
endfunction

call Rank(asteroids)

function! Angle(a, b)
  let diff = round(a:a['angle'] * 10000) - round(a:b['angle'] * 10000)
  if diff == 0.0
    return 0
  elseif diff > 0
    return 1
  else
    return -1
  endif
endfunction

function! Rank(a, b)
  let diff = a:a['rank'] - a:b['rank']
  if diff == 0
    return 0
  elseif diff > 0
    return 1
  else
    return -1
  endif
endfunction

call sort(asteroids, "Angle")
call sort(asteroids, "Rank")

for a in asteroids
  echom index(asteroids, a)
  echom a
endfor
