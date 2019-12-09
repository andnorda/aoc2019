function! IsValid(n)
  if len(a:n) != 6
    return 0
  endif

  let i = 0
  while i < 5
    if a:n[i] > a:n[i+1]
      return 0
    endif
    let i += 1
  endwhile

  if a:n[0] == a:n[1] && a:n[1] != a:n[2]
    return 1
  endif
  if a:n[0] != a:n[1] && a:n[1] == a:n[2] && a:n[2] != a:n[3]
    return 1
  endif
  if a:n[1] != a:n[2] && a:n[2] == a:n[3] && a:n[3] != a:n[4]
    return 1
  endif
  if a:n[2] != a:n[3] && a:n[3] == a:n[4] && a:n[4] != a:n[5]
    return 1
  endif
  if a:n[3] != a:n[4] && a:n[4] == a:n[5] && a:n[5] != a:n[6]
    return 1
  endif
  if a:n[4] != a:n[5] && a:n[5] == a:n[6]
    return 1
  endif

  return 0
endfunction

let c = 0
let i = 265275
while i <= 781584
  let c += IsValid(string(i))
  let i += 1
endwhile

echo c
