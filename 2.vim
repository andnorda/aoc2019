let program = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,19,5,23,2,6,23,27,1,6,27,31,2,31,9,35,1,35,6,39,1,10,39,43,2,9,43,47,1,5,47,51,2,51,6,55,1,5,55,59,2,13,59,63,1,63,5,67,2,67,13,71,1,71,9,75,1,75,6,79,2,79,6,83,1,83,5,87,2,87,9,91,2,9,91,95,1,5,95,99,2,99,13,103,1,103,5,107,1,2,107,111,1,111,5,0,99,2,14,0,0]

let target = 19690720
let noun = -1
let verb = 0

while memory[0] != target && verb != 99
  if noun == 99
    let verb += 1
    let noun = 0
  else
    let noun += 1
  endif
  let memory = program + []
  let ip = 0
  let memory[1] = noun
  let memory[2] = verb

  while memory[ip] != 99 && ip + 3 < len(memory)
    let instruction = memory[ip]
    if instruction == 1
      let memory[memory[ip + 3]] = memory[memory[ip + 1]] + memory[memory[ip + 2]]
    elseif instruction == 2
      let address = memory[ip + 3]
      if address >= len(memory)
        break
      endif
      let memory[address] = memory[memory[ip + 1]] * memory[memory[ip + 2]]
    endif
    let ip += 4
  endwhile

endwhile

echom memory
echom noun
echom verb
echom 100 * noun + verb
