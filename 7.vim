function! RunProgram(phaseSetting)
  let program = [3,8,1001,8,10,8,105,1,0,0,21,34,43,60,81,94,175,256,337,418,99999,3,9,101,2,9,9,102,4,9,9,4,9,99,3,9,102,2,9,9,4,9,99,3,9,102,4,9,9,1001,9,4,9,102,3,9,9,4,9,99,3,9,102,4,9,9,1001,9,2,9,1002,9,3,9,101,4,9,9,4,9,99,3,9,1001,9,4,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,99]

  function! Program(input, inputIndex, memory, ip, output)
    let input = a:input
    let inputIndex = a:inputIndex
    let memory = a:memory
    let ip = a:ip

    while 1
      let instruction = '00000' . string(memory[ip])
      let instLen = len(instruction)
      let opcode = instruction[instLen - 2:instLen - 1]

      let parameters = 0

      if opcode == '01' " add
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

      elseif opcode == '02' " multiply
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

      elseif opcode == '03' " input
        let parameters = 1
        let mode1 = instruction[instLen - 3]
        if mode1 == '0'
          let param1 = memory[ip + 1]
        else
          let param1 = ip + 1
        endif

        let memory[param1] = input[inputIndex]
        let inputIndex += 1

      elseif opcode == '04' " output
        let parameters = 1
        let mode1 = instruction[instLen - 3]
        if mode1 == '0'
          let param1 = memory[ip + 1]
        else
          let param1 = ip + 1
        endif

        return {'output': memory[param1], 'prog': function("Program"), 'input': input, 'inputIndex': inputIndex, 'memory': memory, 'ip': ip + 2}

      elseif opcode == '05' " jump if true
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

      elseif opcode == '06' " jump if false
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

      elseif opcode == '07' " less than
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

      elseif opcode == '08' " equals
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

      elseif opcode == '99' " return
        return {'output': a:output}

      endif

      let ip += 1 + parameters
    endwhile
  endfunction

  return {'output': 0, 'prog': function("Program"), 'input': [a:phaseSetting], 'inputIndex': 0, 'memory': program + [], 'ip': 0}
endfunction

let codes = [5, 6, 7, 8, 9]
let A = [0,1,2,3,4]
let B = [0,1,2,3]
let C = [0,1,2]
let D = [0,1]
let res = {}

for a in A
  for b in B
    for c in C
      for d in D
        let aa = codes[a]
        call remove(codes, index(codes, aa))
        let bb = codes[b]
        call remove(codes, index(codes, bb))
        let cc = codes[c]
        call remove(codes, index(codes, cc))
        let dd = codes[d]
        call remove(codes, index(codes, dd))
        let ee = codes[0]

        let aResult = RunProgram(aa)
        let bResult = RunProgram(bb)
        let cResult = RunProgram(cc)
        let dResult = RunProgram(dd)
        let eResult = RunProgram(ee)

        while has_key(eResult, 'prog')
          let input = aResult['input']
          call add(input, eResult['output'])
          let aResult = aResult['prog'](input, aResult['inputIndex'], aResult['memory'], aResult['ip'], aResult['output'])

          let input = bResult['input']
          call add(input, aResult['output'])
          let bResult = bResult['prog'](input, bResult['inputIndex'], bResult['memory'], bResult['ip'], bResult['output'])

          let input = cResult['input']
          call add(input, bResult['output'])
          let cResult = cResult['prog'](input, cResult['inputIndex'], cResult['memory'], cResult['ip'], cResult['output'])

          let input = dResult['input']
          call add(input, cResult['output'])
          let dResult = dResult['prog'](input, dResult['inputIndex'], dResult['memory'], dResult['ip'], dResult['output'])

          let input = eResult['input']
          call add(input, dResult['output'])
          let eResult = eResult['prog'](input, eResult['inputIndex'], eResult['memory'], eResult['ip'], eResult['output'])
        endwhile

        let res[aa.bb.cc.dd.ee] = eResult['output']

        let codes = [5, 6, 7, 8, 9]
      endfor
    endfor
  endfor
endfor

echo max(res)
let @* = max(res)
