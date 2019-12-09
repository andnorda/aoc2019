let program = [3,225,1,225,6,6,1100,1,238,225,104,0,1101,9,90,224,1001,224,-99,224,4,224,102,8,223,223,1001,224,6,224,1,223,224,223,1102,26,62,225,1101,11,75,225,1101,90,43,225,2,70,35,224,101,-1716,224,224,4,224,1002,223,8,223,101,4,224,224,1,223,224,223,1101,94,66,225,1102,65,89,225,101,53,144,224,101,-134,224,224,4,224,1002,223,8,223,1001,224,5,224,1,224,223,223,1102,16,32,224,101,-512,224,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1001,43,57,224,101,-147,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,36,81,225,1002,39,9,224,1001,224,-99,224,4,224,1002,223,8,223,101,2,224,224,1,223,224,223,1,213,218,224,1001,224,-98,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,102,21,74,224,101,-1869,224,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1101,25,15,225,1101,64,73,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,226,677,224,1002,223,2,223,1005,224,329,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,344,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,359,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,7,226,226,224,1002,223,2,223,1006,224,389,1001,223,1,223,8,226,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,107,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,1008,677,677,224,102,2,223,223,1006,224,434,101,1,223,223,1107,226,677,224,102,2,223,223,1005,224,449,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,464,101,1,223,223,107,226,677,224,102,2,223,223,1005,224,479,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,494,1001,223,1,223,1108,226,677,224,102,2,223,223,1006,224,509,101,1,223,223,1107,677,226,224,1002,223,2,223,1005,224,524,101,1,223,223,1008,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,554,101,1,223,223,1107,677,677,224,1002,223,2,223,1006,224,569,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,584,101,1,223,223,1108,677,677,224,102,2,223,223,1005,224,599,101,1,223,223,108,677,677,224,1002,223,2,223,1006,224,614,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,629,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,644,101,1,223,223,1007,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,1108,677,226,224,102,2,223,223,1006,224,674,101,1,223,223,4,223,99,226]

let memory = program + []
let ip = 0
let input = 5

while memory[ip] != 99
  let instruction = '0000' . string(memory[ip])
  let instLen = len(instruction)
  let opcode = instruction[instLen - 1]

  let parameters = 0

  if opcode == '1' " add
    let parameters = 3
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif

    let memory[memory[ip + 3]] = param1 + param2

  elseif opcode == '2' " multiply
    let parameters = 3
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif

    let memory[memory[ip + 3]] = param1 * param2

  elseif opcode == '3' " input
    let parameters = 1
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[ip + 1]
    else
      let param1 = ip + 1
    endif

    let memory[param1] = input

  elseif opcode == '4' " output
    let parameters = 1
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[ip + 1]
    else
      let param1 = ip + 1
    endif

    echom memory[param1]
    let @* = memory[param1]

  elseif opcode == '5' " jump if true
    let parameters = 2
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif

    if param1
      let ip = param2
      continue
    endif

  elseif opcode == '6' " jump if false
    let parameters = 2
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif


    if !param1
      let ip = param2
      continue
    endif

  elseif opcode == '7' " less than
    let parameters = 3
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif

    let memory[memory[ip + 3]] = param1 < param2

  elseif opcode == '8' " equals
    let parameters = 3
    let mode1 = instruction[instLen - 3]
    if mode1 == '0'
      let param1 = memory[memory[ip + 1]]
    else
      let param1 = memory[ip + 1]
    endif
    let mode2 = instruction[instLen - 4]
    if mode2 == '0'
      let param2 = memory[memory[ip + 2]]
    else
      let param2 = memory[ip + 2]
    endif

    let memory[memory[ip + 3]] = param1 == param2

  endif

  let ip += 1 + parameters
endwhile