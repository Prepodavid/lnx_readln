BEGIN{sum=0;i=0} {sum+=$0; a[i]=$0; i++;} 
END {hs = sum/2;
  flg = 0
  if (1 == sum%2) {print "No\n"} 
  else {
    if ( a[0] == hs || a[1] == hs || a[2] == hs || a[3] == hs) {
      print "Yes\n" hs
      flag++;
    }
  
    if ( 0 == flag ) {
      if ( a[0]+a[1] == hs ||
           a[0]+a[2] == hs ||
           a[0]+a[3] == hs) {
        print "Yes\n" hs
      }
    }
    
  }
}
