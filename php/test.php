<?php
/*
* Tip: test out with `php -a` - interactive mode
*/

function createPhoneNumber($numbersArray) {
  $exact = 10;
  if (count($numbersArray) != $exact) 
    return false;

  $part = "(";  
  for ($i=0; $i < $exact; $i++) {
    if ($i===2) {
      $part .= "$numbersArray[$i]) ";
    } else if ($i===5) {
      $part .= "$numbersArray[$i]-";
    } else {
      $part .= $numbersArray[$i];
    }
  }
  
  return $part;
}

// Cleaner, simpler, same result
function createPhoneNumber(array $digits): string {
  return sprintf("(%d%d%d) %d%d%d-%d%d%d%d", ...$digits);
}
