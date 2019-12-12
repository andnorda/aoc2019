function! RunProgram()
  let program = [3,8,1005,8,336,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,101,0,8,28,1006,0,36,1,2,5,10,1006,0,57,1006,0,68,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,63,2,6,20,10,1,106,7,10,2,9,0,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,97,1006,0,71,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,1002,8,1,122,2,105,20,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,148,2,1101,12,10,1006,0,65,2,1001,19,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,181,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,204,2,7,14,10,2,1005,20,10,1006,0,19,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,236,1006,0,76,1006,0,28,1,1003,10,10,1006,0,72,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,102,1,8,271,1006,0,70,2,107,20,10,1006,0,81,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,303,2,3,11,10,2,9,1,10,2,1107,1,10,101,1,9,9,1007,9,913,10,1005,10,15,99,109,658,104,0,104,1,21101,0,387508441896,1,21102,1,353,0,1106,0,457,21101,0,937151013780,1,21101,0,364,0,1105,1,457,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,179490040923,1,1,21102,411,1,0,1105,1,457,21101,46211964123,0,1,21102,422,1,0,1106,0,457,3,10,104,0,104,0,3,10,104,0,104,0,21101,838324716308,0,1,21101,0,445,0,1106,0,457,21102,1,868410610452,1,21102,1,456,0,1106,0,457,99,109,2,22101,0,-1,1,21101,40,0,2,21101,0,488,3,21101,478,0,0,1106,0,521,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,483,484,499,4,0,1001,483,1,483,108,4,483,10,1006,10,515,1101,0,0,483,109,-2,2105,1,0,0,109,4,2101,0,-1,520,1207,-3,0,10,1006,10,538,21101,0,0,-3,22102,1,-3,1,21202,-2,1,2,21101,0,1,3,21101,557,0,0,1105,1,562,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,585,2207,-4,-2,10,1006,10,585,22101,0,-4,-4,1106,0,653,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21102,604,1,0,1106,0,562,21202,1,1,-4,21101,0,1,-1,2207,-4,-2,10,1006,10,623,21102,0,1,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,645,21202,-1,1,1,21101,0,645,0,106,0,520,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0]

  let paintCount = 0

  let ship = {}
  let pos = [0, 0]
  let dir = 0

  let first = 1
  function! GetColor() closure
    let key = pos[0].','.pos[1]
    if has_key(ship, key)
      let ret = get(ship, key)
    else
      if first
        let ret = 1
        let first = 0
      else
        let ret = 0
      endif
    endif
    return ret
  endfunction

  function! Paint(color) closure
    let key = pos[0].','.pos[1]
    if !has_key(ship, key)
      let paintCount += 1
    endif
    let ship[key] = a:color
  endfunction

  function! TurnAndMove(dir) closure
    if a:dir
      let dir += 1
    else
      let dir -= 1
    endif
    let dir = (dir+4) % 4
    if dir == 0
      let pos[0] -= 1
    elseif dir == 1
      let pos[1] += 1
    elseif dir == 2
      let pos[0] += 1
    else
      let pos[1] -= 1
    endif
  endfunction

  let type = 0

  let memory = {}
  let i = 0
  while i < len(program)
    let memory[i] = program[i]
    let i += 1
  endwhile
  let ip = 0
  let relativeBase = 0

  function! Mem(address) closure
    if has_key(memory, a:address)
      return get(memory, a:address)
    else
      return 0
    endif
  endfunction

  while 1
    let instruction = '0000' . string(Mem(ip))
    let instLen = len(instruction)
    let opcode = instruction[instLen - 2:instLen - 1]

    function! Address(offset) closure
      let mode = instruction[instLen - (a:offset + 2)]
      if mode == '0'
        return Mem(ip + a:offset)
      elseif mode == '2'
        return Mem(ip + a:offset) + relativeBase
      else
        return ip + a:offset
      endif
    endfunction

    if opcode == '01' " add
      let memory[Address(3)] = Mem(Address(1)) + Mem(Address(2))
      let ip += 4

    elseif opcode == '02' " multiply
      let memory[Address(3)] = Mem(Address(1)) * Mem(Address(2))
      let ip += 4

    elseif opcode == '03' " input
      let memory[Address(1)] = GetColor()
      let ip += 2

    elseif opcode == '04' " output
      if type == 0
        call Paint(Mem(Address(1)))
        let type = 1
      else
        call TurnAndMove(Mem(Address(1)))
        let type = 0
      endif
      let ip += 2

    elseif opcode == '05' " jump if true
      if Mem(Address(1))
        let ip = Mem(Address(2))
      else
        let ip += 3
      endif

    elseif opcode == '06' " jump if false
      if !Mem(Address(1))
        let ip = Mem(Address(2))
      else
        let ip += 3
      endif

    elseif opcode == '07' " less than
      let memory[Address(3)] = Mem(Address(1)) < Mem(Address(2))
      let ip += 4

    elseif opcode == '08' " equals
      let memory[Address(3)] = Mem(Address(1)) == Mem(Address(2))
      let ip += 4

    elseif opcode == '09' " equals
      let relativeBase += Mem(Address(1))
      let ip += 2

    elseif opcode == '99' " return
      let points = []
      function! Set(point, color) closure
        let [x, y] = split(a:point, ',')
        call add(points, {'x': x, 'y': y, 'color': a:color})
      endfunction
      call map(copy(ship), function("Set"))
      let maxX = max(map(copy(points), {_, point -> point['x']}))
      let maxY = max(map(copy(points), {_, point -> point['y']}))

      let map = []
      let x = 0
      while x < maxX + 1
        let line = ''
        let y = 0
        while y < maxY + 1
          let key = x.','.y
          if has_key(ship, key)
            let char = get(ship, key)
          else
            let char = '0'
          end
          let line = line . char
          let y += 1
        endwhile
        call add(map, line)
        let x += 1
      endwhile

      for line in map
        echom substitute(substitute(line, '0', ' ', 'g'), '1', '□', 'g')
      endfor

      return paintCount

    endif
  endwhile
endfunction

echom RunProgram()
