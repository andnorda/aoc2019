function! IsColinear(a, b, c)
  let [x1, y1] = a:a
  let [x2, y2] = a:b
  let [x3, y3] = a:c

  return x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2) == 0
endfunction

function! NumBetween(a, b, c)
  return a:a >= a:c && a:c >= a:b || a:a <= a:c && a:c <= a:b
endfunction

function! IsBetween(a, b, c)
  if a:a == a:b || a:a == a:c || a:b == a:c
    return 0
  endif

  if !IsColinear(a:a, a:b, a:c)
    return 0
  endif

  return NumBetween(a:a[0], a:b[0], a:c[0]) && NumBetween(a:a[1], a:b[1], a:c[1])
endfunction

let result = IsBetween([0, 0], [0, 2], [0, 1])
if !result
  echom "IsBetween fail [0, 0], [0, 2], [0, 1]"
endif

let result = IsBetween([0, 0], [0, 1], [0, 2])
if result
  echom "IsBetween fail [0, 0], [0, 1], [0, 2]"
endif

let result = IsBetween([0, 3], [0, 1], [0, 2])
if !result
  echom "IsBetween fail [0, 3], [0, 1], [0, 2]"
endif

let result = IsBetween([0, 0], [2, 0], [1, 0])
if !result
  echom "IsBetween fail [0, 0], [2, 0], [1, 0]"
endif

let result = IsBetween([0, 0], [2, 0], [6, 0])
if result
  echom "IsBetween fail [0, 0], [2, 0], [6, 0]"
endif

let result = IsBetween([0, 0], [2, 2], [3, 1])
if result
  echom "IsBetween fail [0, 0], [2, 2], [3, 1]"
endif

let result = IsBetween([0, 0], [0, 0], [1, 1])
if result
  echom "IsBetween fail [0, 0], [0, 0], [1, 1]"
endif

let result = IsBetween([0, 0], [1, 1], [1, 1])
if result
  echom "IsBetween fail [0, 0], [1, 1], [1, 1]"
endif

let result = IsBetween([1, 1], [0, 0], [1, 1])
if result
  echom "IsBetween fail [0, 0], [1, 1], [1, 1]"
endif

let result = IsBetween([0, 1], [0, 4], [2, 0])
if result
  echom "IsBetween fail [0, 1], [0, 4], [2, 0]"
endif

let result = IsBetween([0, 1], [3, 4], [2, 3])
if !result
  echom "IsBetween fail [0, 1], [3, 4], [2, 3]"
endif

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

let Coords = {input -> filter(FlatMap(input, {i, line -> map(split(line, '\zs'), {j, char -> [i,j]})}), {idx, val -> input[val[0]][val[1]] == '#'})}

let input = ['.#..#', '.....', '#####', '....#', '...##']
let expected = [[0, 1], [0, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [3, 4], [4, 3], [4, 4]]
let result = Coords(input)
if result != expected
  echom 'Parse fail'
  echom result
  echom expected
endif

function! CountVisible(coord, list)
  let visibleCount = 0
  for i in a:list
    let omg = map(copy(a:list), {idx, j -> IsBetween(a:coord, i, j)})
    if i != a:coord && !max(omg)
      let visibleCount += 1
    endif
  endfor
  echom a:coord
  return visibleCount
endfunction

let result = CountVisible([0, 1], [[0, 1], [0, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [3, 4], [4, 3], [4, 4]])
if result != 7
  echom 'Count visible fail'
  echom result
  echom expected
endif


let input = [[0, 1], [0, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [3, 4], [4, 3], [4, 4]]
let expected = [7, 7, 6, 7, 7, 7, 5, 7, 8, 7]

function! CountAll(input)
  return map(copy(a:input), {_, coord -> CountVisible(coord, a:input)})
endfunction

let result = CountAll(input)
if result != expected
  echom 'Count visible fail'
  echom result
  echom expected
endif

let input = ['#.....#...#.........###.#........#..', '....#......###..#.#.###....#......##', '......#..###.......#.#.#.#..#.......', '......#......#.#....#.##....##.#.#.#', '...###.#.#.......#..#...............', '....##...#..#....##....#...#.#......', '..##...#.###.....##....#.#..##.##...', '..##....#.#......#.#...#.#...#.#....', '.#.##..##......##..#...#.....##...##', '.......##.....#.....##..#..#..#.....', '..#..#...#......#..##...#.#...#...##', '......##.##.#.#.###....#.#..#......#', '#..#.#...#.....#...#...####.#..#...#', '...##...##.#..#.....####.#....##....', '.#....###.#...#....#..#......#......', '.##.#.#...#....##......#.....##...##', '.....#....###...#.....#....#........', '...#...#....##..#.#......#.#.#......', '.#..###............#.#..#...####.##.', '.#.###..#.....#......#..###....##..#', '#......#.#.#.#.#.#...#.#.#....##....', '.#.....#.....#...##.#......#.#...#..', '...##..###.........##.........#.....', '..#.#..#.#...#.....#.....#...###.#..', '.#..........#.......#....#..........', '...##..#..#...#..#...#......####....', '.#..#...##.##..##..###......#.......', '.##.....#.......#..#...#..#.......#.', '#.#.#..#..##..#..............#....##', '..#....##......##.....#...#...##....', '.##..##..#.#..#.................####', '##.......#..#.#..##..#...#..........', '#..##...#.##.#.#.........#..#..#....', '.....#...#...#.#......#....#........', '....#......###.#..#......##.....#..#', '#..#...##.........#.....##.....#....']
let coords = Coords(input)
echo len(coords)
let counts = CountAll(coords)
echo max(counts)
